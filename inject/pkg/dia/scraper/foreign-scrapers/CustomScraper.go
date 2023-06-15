package foreignscrapers

import (
	"encoding/json"
	"errors"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"

	models "github.com/diadata-org/diadata/pkg/model"
	"github.com/diadata-org/diadata/pkg/utils"
	"github.com/gocolly/colly"
	log "github.com/sirupsen/logrus"
)

type CustomScraper struct {
	ticker          *time.Ticker
	foreignScrapper ForeignScraper
	currenciesMap   map[string]string
}

type customWebCurrency struct {
	Symbol string
	Name   string
}

type customHttpQuoteResp struct {
	QuoteResponse struct {
		Result []struct {
			Symbol             string  `json:"symbol"`
			RegularMarketPrice float64 `json:"regularMarketPrice"`
			RegularMarketTime  int     `json:"regularMarketTime"`
		} `json:"result"`
		Error interface{} `json:"error"`
	} `json:"quoteResponse"`
}

const (
	customSource            = "Custom"
	customUpdateFreqDefault = 60 * 2 // Default update frequency (in seconds)
	customUpdateFreqEnv     = "CUSTOM_UPDATE_FREQ"
	customWebCurrencies     = "https://finance.yahoo.com/currencies"
	customHttpV10Host       = "https://query1.finance.yahoo.com"
	customHttpV11Host       = "https://query2.finance.yahoo.com"
	customTypeCurrency      = "CURRENCY"
)

var (
	customHttpPathQuote = ""
)

func NewCustomScraper(datastore models.Datastore) (s *CustomScraper) {
	foreignScrapper := ForeignScraper{
		shutdown:      make(chan nothing),
		error:         nil,
		datastore:     datastore,
		chanQuotation: make(chan *models.ForeignQuotation),
	}

	// Define the update frequency
	updateFreq := customUpdateFreqDefault * time.Second
	customUpdateFreqEnv, err := strconv.ParseInt(utils.Getenv(customUpdateFreqEnv, "0"), 10, 64)
	if err != nil {
		log.Errorf("parse fail to %v env variable: %v", customUpdateFreqEnv, err)
		return
	}
	if customUpdateFreqEnv != 0 {
		updateFreq = time.Duration(customUpdateFreqEnv) * time.Second
	}

	customHttpPathQuote = utils.Getenv("HTTP_PATH_QUOTE", "/v6/finance/quote")

	// Because Yahoo Finance don't have any public endpoint to discover available currency's symbols,
	// we need to scrape webpage to extract metadata. This map is the fallback in case the crawling process fails.
	// Also, some of the pairs are not contained in the webpage. These need to be added to the env var manually.
	// The data was extracted on Jan10 2023, maps the Yahoo Finance symbols to a pair of ISO 4217 friendly format.
	// Examples: EURGBP=X:EUR-GBP, CNY=X:USD-CNY
	currencyMapDefault := make(map[string]string)
	currenciesList := strings.Split(utils.Getenv("CURRENCIES_LIST_YAHOO", ""), ",")
	for _, c := range currenciesList {
		currency := strings.Split(c, ":")
		if len(currency) != 2 {
			log.Fatal("currency must have 2 identifier: ", currency)
		}
		currencyMapDefault[currency[0]] = currency[1]
	}

	log.Infoln("Trying to extract symbol/name metadata from Yahoo by crawling the webpage")
	currencyMap := make(map[string]string)
	data, err := customCrawlCurrencies()
	if err != nil {
		log.Warnf("Failed to crawl currencies, using default map: %s", err)
		currencyMap = currencyMapDefault
	} else {
		log.Infoln(data)
		for _, currency := range data {
			currencyMap[currency.Symbol] = currency.Name
		}
		if len(currencyMap) < len(currencyMapDefault) {
			for symbol, name := range currencyMapDefault {
				if _, ok := currencyMap[symbol]; !ok {
					currencyMap[symbol] = name
				}
			}
		}
	}

	s = &CustomScraper{
		ticker:          time.NewTicker(updateFreq),
		foreignScrapper: foreignScrapper,
		currenciesMap:   currencyMap,
	}

	// go s.mainLoop()

	return s
}

// Close closes any existing connections
func (scraper *CustomScraper) Close() error {
	if scraper.foreignScrapper.closed {
		return errors.New("scraper already closed")
	}
	close(scraper.foreignScrapper.shutdown)
	<-scraper.foreignScrapper.shutdownDone
	scraper.foreignScrapper.errorLock.RLock()
	defer scraper.foreignScrapper.errorLock.RUnlock()
	return scraper.foreignScrapper.error
}

// GetQuoteChannel returns the channel to which new quotes are pushed
func (scraper *CustomScraper) GetQuoteChannel() chan *models.ForeignQuotation {
	return scraper.foreignScrapper.chanQuotation
}

// UpdateQuotation retrieves new coin information from the Yahoo Finance API and stores it to influx
func (scraper *CustomScraper) UpdateQuotation() error {
	log.Printf("Executing %s quote update", customSource)
	resp, err := scraper.getCurrencies()
	if err != nil {
		log.Error("Get currencies: ", err)
		return err
	}
	if resp.QuoteResponse.Error != nil {
		return fmt.Errorf("api returned an error %s", resp.QuoteResponse.Error)
	}
	for _, q := range resp.QuoteResponse.Result {
		priceYesterday, err := scraper.foreignScrapper.datastore.GetForeignPriceYesterday(scraper.currenciesMap[q.Symbol], customSource)
		if err != nil {
			priceYesterday = 0
		}
		quote := models.ForeignQuotation{
			Symbol:             scraper.currenciesMap[q.Symbol],
			Name:               q.Symbol,
			Price:              q.RegularMarketPrice,
			PriceYesterday:     priceYesterday,
			VolumeYesterdayUSD: 0.0, // TODO: fetched volume data is always 0 (not available)
			Source:             customSource,
			Time:               time.Unix(int64(q.RegularMarketTime), 0),
		}
		scraper.foreignScrapper.chanQuotation <- &quote
	}
	return nil
}

// mainLoop runs in a goroutine until channel s is closed.
func (scraper *CustomScraper) mainLoop() {
	log.Infof("Make initial update")
	err := scraper.UpdateQuotation()
	if err != nil {
		log.Error(err)
	}

	log.Infof("Starting main loop")
	for {
		select {
		case <-scraper.ticker.C:
			err := scraper.UpdateQuotation()
			if err != nil {
				log.Error(err)
			}
		case <-scraper.foreignScrapper.shutdown: // user requested shutdown
			log.Printf("%s scraper shutting down", customSource)
			return
		}
	}
}

// getCurrencies retrieves the current currency information from the Yahoo Finance API
func (scraper *CustomScraper) getCurrencies() (quoteResp customHttpQuoteResp, err error) {
	client := &http.Client{}
	req, err := http.NewRequest("GET", customHttpV11Host+customHttpPathQuote, nil)
	if err != nil {
		return quoteResp, err
	}

	// Add URL query parameters and encode them
	q := url.Values{}
	var symbols []string
	for k := range scraper.currenciesMap {
		symbols = append(symbols, k)
	}
	q.Add("symbols", strings.Join(symbols, ","))
	req.URL.RawQuery = q.Encode()
	// Make the request and unmarshal the response
	resp, err := client.Do(req)
	if err != nil {
		return quoteResp, err
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return quoteResp, err
	}
	err = json.Unmarshal(body, &quoteResp)
	if err != nil {
		return quoteResp, err
	}

	return quoteResp, nil
}

// crawlCurrencies crawl Yahoo Finance currencies webpage and return a slice of currency metadata
func customCrawlCurrenciesA() (currencies []customWebCurrency, err error) {
	c := colly.NewCollector()

	c.OnResponse(func(r *colly.Response) {
		if r.StatusCode == 200 {
			log.Debug("URL '%s' %d", r.Request.URL, r.StatusCode)
		} else {
			log.Debug("URL '%s' %d", r.Request.URL, r.StatusCode)
		}
	})

	c.OnError(func(r *colly.Response, err error) {
		log.Errorln(err)
	})

	c.OnHTML("#list-res-table > div > table > tbody", func(e *colly.HTMLElement) {
		e.ForEach("tr", func(_ int, el *colly.HTMLElement) {
			symbol := el.ChildText("td:nth-child(1)")
			name := el.ChildText("td:nth-child(2)")
			if nameSplit := strings.Split(name, "/"); len(nameSplit) != 2 {
				log.Errorf("Cannot parse name %s", name)
				return
			}
			currency := customWebCurrency{
				Symbol: symbol,
				Name:   strings.Split(name, "/")[0] + "-" + strings.Split(name, "/")[1],
			}
			currencies = append(currencies, currency)
		})
	})

	err = c.Visit(customWebCurrencies)
	if err != nil {
		return currencies, err
	}

	return currencies, nil
}

func customCrawlCurrencies() (currencies []customWebCurrency, err error) {
	c := colly.NewCollector(
		// colly.UserAgent("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36"),
		colly.UserAgent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"),
	)

	c.OnResponse(func(r *colly.Response) {
		if r.StatusCode == 200 {
			log.Infof("%d from %s", r.StatusCode, r.Request.URL)
			log.Infoln(r.Headers)
			log.Infoln(r.Request)
			err := r.Request.Post("https://consent.google.com/save", map[string]string{
				"bl":       "boq_identityfrontenduiserver_20230611.09_p0",
				"x":        "8",
				"gl":       "PT",
				"m":        "0",
				"app":      "0",
				"pc":       "fgc",
				"continue": "https%3A%2F%2Fwww.google.com%2Ffinance%2Fquote%2FTWD-USD",
				"hl":       "en-US",
				"cm":       "2",
				"set_eom":  "true",
			})
			if err != nil {
				log.Error(err)
			}
			log.Infoln(r.StatusCode)
			log.Infoln(string(r.Body))

			// log.Infoln(string(r.Body))
		} else {
			log.Infof("URL '%s' %d", r.Request.URL, r.StatusCode)
		}
	})

	c.OnError(func(r *colly.Response, err error) {
		log.Errorln(err)
	})

	c.OnHTML("", func(e *colly.HTMLElement) {
		log.Infoln("FOUND")
	})

	// c.OnXML("/html/body/c-wiz[2]/div/div[4]/div/main/div[2]/c-wiz/div/div[1]/div/div[1]/div/div[1]/div/span/div/div", func(e *colly.XMLElement) {
	// 	log.Infoln("FOUND FOUND")
	// 	log.Infoln("FOUND FOUND")
	// 	log.Infoln("FOUND FOUND")
	// })

	// c.OnXML("/html/", func(e *colly.XMLElement) {
	// 	log.Infoln("FOUND")
	// })

	// c.OnHTML("#list-res-table > div > table > tbody", func(e *colly.HTMLElement) {
	// 	e.ForEach("tr", func(_ int, el *colly.HTMLElement) {
	// 		symbol := el.ChildText("td:nth-child(1)")
	// 		name := el.ChildText("td:nth-child(2)")
	// 		if nameSplit := strings.Split(name, "/"); len(nameSplit) != 2 {
	// 			log.Errorf("Cannot parse name %s", name)
	// 			return
	// 		}
	// 		currency := customWebCurrency{
	// 			Symbol: symbol,
	// 			Name:   strings.Split(name, "/")[0] + "-" + strings.Split(name, "/")[1],
	// 		}
	// 		currencies = append(currencies, currency)
	// 	})
	// })

	err = c.Visit("https://www.google.com/finance/quote/TWD-USD")
	if err != nil {
		return currencies, err
	}
	log.Printf("Scraping finished\n")

	return currencies, nil
}
