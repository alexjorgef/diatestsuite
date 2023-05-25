package scrapers

import (
	"errors"
	"strconv"
	"sync"
	"time"

	krakenapi "github.com/beldur/kraken-go-api-client"
	"github.com/diadata-org/diadata/pkg/dia"
	models "github.com/diadata-org/diadata/pkg/model"
	"github.com/zekroTJA/timedmap"
)

const (
	customRefreshDelay = time.Second * 30 * 1
)

type CustomScraper struct {
	// signaling channels
	shutdown     chan nothing
	shutdownDone chan nothing
	// error handling; to read error or closed, first acquire read lock
	// only cleanup method should hold write lock
	errorLock    sync.RWMutex
	error        error
	closed       bool
	pairScrapers map[string]*CustomPairScraper // pc.ExchangePair -> pairScraperSet
	api          *krakenapi.KrakenApi
	ticker       *time.Ticker
	exchangeName string
	chanTrades   chan *dia.Trade
	db           *models.RelDB
}

// NewCustomScraper returns a new CustomScraper initialized with default values.
// The instance is asynchronously scraping as soon as it is created.
func NewCustomScraper(key string, secret string, exchange dia.Exchange, scrape bool, relDB *models.RelDB) *CustomScraper {
	s := &CustomScraper{
		shutdown:     make(chan nothing),
		shutdownDone: make(chan nothing),
		pairScrapers: make(map[string]*CustomPairScraper),
		api:          krakenapi.New(key, secret),
		ticker:       time.NewTicker(customRefreshDelay),
		exchangeName: exchange.Name,
		error:        nil,
		chanTrades:   make(chan *dia.Trade),
		db:           relDB,
	}
	if scrape {
		go s.mainLoop()
	}
	return s
}

// mainLoop runs in a goroutine until channel s is closed.
func (s *CustomScraper) mainLoop() {
	for {
		select {
		case <-s.ticker.C:
			s.Update()
		case <-s.shutdown: // user requested shutdown
			log.Printf("CustomScraper shutting down")
			s.cleanup(nil)
			return
		}
	}
}

// closes all connected PairScrapers
// must only be called from mainLoop
func (s *CustomScraper) cleanup(err error) {

	s.errorLock.Lock()
	defer s.errorLock.Unlock()

	if err != nil {
		s.error = err
	}
	s.closed = true

	close(s.shutdownDone) // signal that shutdown is complete
}

// Close closes any existing API connections, as well as channels of
// PairScrapers from calls to ScrapePair
func (s *CustomScraper) Close() error {
	if s.closed {
		return errors.New("CustomScraper: Already closed")
	}
	close(s.shutdown)
	<-s.shutdownDone
	s.errorLock.RLock()
	defer s.errorLock.RUnlock()
	return s.error
}

// CustomPairScraper implements PairScraper for Kraken
type CustomPairScraper struct {
	parent     *CustomScraper
	pair       dia.ExchangePair
	closed     bool
	lastRecord int64
}

// ScrapePair returns a PairScraper that can be used to get trades for a single pair from
// this APIScraper
func (s *CustomScraper) ScrapePair(pair dia.ExchangePair) (PairScraper, error) {

	s.errorLock.RLock()
	defer s.errorLock.RUnlock()
	if s.error != nil {
		return nil, s.error
	}
	if s.closed {
		return nil, errors.New("CustomScraper: Call ScrapePair on closed scraper")
	}
	ps := &CustomPairScraper{
		parent:     s,
		pair:       pair,
		lastRecord: 0, //TODO FIX to figure out the last we got...
	}

	s.pairScrapers[pair.Symbol] = ps

	return ps, nil
}

func (s *CustomScraper) FillSymbolData(symbol string) (dia.Asset, error) {
	return dia.Asset{Symbol: symbol}, nil
}

// FetchAvailablePairs returns a list with all available trade pairs
func (s *CustomScraper) FetchAvailablePairs() (pairs []dia.ExchangePair, err error) {
	return []dia.ExchangePair{}, errors.New("FetchAvailablePairs() not implemented")
}

// NormalizePair accounts for the par
func (ps *CustomScraper) NormalizePair(pair dia.ExchangePair) (dia.ExchangePair, error) {
	if len(pair.ForeignName) == 7 {
		if pair.ForeignName[4:5] == "Z" || pair.ForeignName[4:5] == "X" {
			pair.ForeignName = pair.ForeignName[:4] + pair.ForeignName[5:]
			return pair, nil
		}
		if pair.ForeignName[:1] == "Z" || pair.ForeignName[:1] == "X" {
			pair.ForeignName = pair.ForeignName[1:]
		}
	}
	if len(pair.ForeignName) == 8 {
		if pair.ForeignName[4:5] == "Z" || pair.ForeignName[4:5] == "X" {
			pair.ForeignName = pair.ForeignName[:4] + pair.ForeignName[5:]
		}
		if pair.ForeignName[:1] == "Z" || pair.ForeignName[:1] == "X" {
			pair.ForeignName = pair.ForeignName[1:]
		}
	}
	if pair.ForeignName[len(pair.ForeignName)-3:] == "XBT" {
		pair.ForeignName = pair.ForeignName[:len(pair.ForeignName)-3] + "BTC"
	}
	if pair.ForeignName[:3] == "XBT" {
		pair.ForeignName = "BTC" + pair.ForeignName[len(pair.ForeignName)-3:]
	}
	return pair, nil
}

// Channel returns a channel that can be used to receive trades/pricing information
func (ps *CustomScraper) Channel() chan *dia.Trade {
	return ps.chanTrades
}

func (ps *CustomPairScraper) Close() error {
	ps.closed = true
	return nil
}

// Error returns an error when the channel Channel() is closed
// and nil otherwise
func (ps *CustomPairScraper) Error() error {
	s := ps.parent
	s.errorLock.RLock()
	defer s.errorLock.RUnlock()
	return s.error
}

// Pair returns the pair this scraper is subscribed to
func (ps *CustomPairScraper) Pair() dia.ExchangePair {
	return ps.pair
}

func (s *CustomScraper) Update() {
	tmDuplicateTrades := timedmap.New(duplicateTradesScanFrequency)

	for _, ps := range s.pairScrapers {

		r, err := s.api.Trades(ps.pair.ForeignName, ps.lastRecord)

		if err != nil {
			log.Printf("err on collect trades %v %v", err, ps.pair.ForeignName)
			time.Sleep(1 * time.Minute)
		} else {
			if r != nil {
				ps.lastRecord = r.Last
				for _, ti := range r.Trades {
					// p, _ := s.NormalizePair(ps.pair)
					t := NewTrade(ps.pair, ti, strconv.FormatInt(r.Last, 16), s.db)
					// Handle duplicate trades.
					t.IdentifyDuplicateTagset(tmDuplicateTrades, duplicateTradesMemory)
					ps.parent.chanTrades <- t
				}
			} else {
				log.Printf("r nil")
			}
		}
	}
}