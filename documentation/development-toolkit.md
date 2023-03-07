A toolkit for testing the DIA ecossystem locally.

- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Endpoints](#endpoints)
- [Guides](#guides)
  - [How to add a new scraper](#how-to-add-a-new-scraper)
- [Advanced Usage](#advanced-usage)
  - [Stop and delete minikube](#stop-and-delete-minikube)
  - [Forward ports to localhost](#forward-ports-to-localhost)
- [Structure](#structure)

---

## Requirements

> For supported minikube's drivers check [the official documentation](https://minikube.sigs.k8s.io/docs/drivers/). The [docker](https://docs.docker.com/get-docker/) driver is the recommended and default option, therefore should be seen as requirement.

* [minikube](https://minikube.sigs.k8s.io/docs/): minikube quickly sets up a local Kubernetes cluster
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/): kubectl controls the Kubernetes cluster manager

Optional:

* [k9s](https://k9scli.io/): k9s is a terminal based UI to interact with your Kubernetes clusters

## Getting Started

Initialize the cluster:

```shell
./deployments/init.sh
```

Start the cluster's containers:

```shell
./deployments/start.sh
```

You can stop the cluster's containers with:

```shell
./deployments/stop.sh
```

Finally, start the Kubernetes Dashboard UI to see your cluster:

```shell
minikube dashboard --url=true --port=8083
```

After the dashboard service is ready, you can visit the web interface on your favorite browser:

```
http://127.0.0.1:8083/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

### Endpoints

> The routes are only available after you [forward service's ports](#forward-ports-to-localhost) to your host machine.

* **REST Server**: localhost:8081
* **PostgreSQL Database**: localhost:5432
* **Redis Cache**: localhost:6379
* **InfluxDB Datastore**: localhost:8086

---

## Advanced Usage

> For more information about minikube CLI commands, check the handbook [here](https://minikube.sigs.k8s.io/docs/handbook/).

### Stop and delete minikube

> Be aware, this command delete all minikube nodes you have!

```shell
minikube delete --all --purge
```

### Forward ports to localhost

REST Server:

```shell
kubectl port-forward diadata-clusterdev-http-restserver 8081:8081
```

PostgreSQL Database:

```shell
kubectl port-forward diadata-clusterdev-db-postgres 5432:5432
```

Redis Cache:

```shell
kubectl port-forward diadata-clusterdev-db-redis 6379:6379
```

InfluxDB Datastore:

```shell
kubectl port-forward diadata-clusterdev-db-influx 8086:8086
```

---

## Structure

File structure:

```
.
├── build                                    Folder that holds all the custom container's definitions
│   ├── Dockerfile-assetCollectionService
│   ├── Dockerfile-blockchainservice
│   ├── Dockerfile-filtersBlockService
│   ├── Dockerfile-genericCollector
│   ├── Dockerfile-pairDiscoveryService
│   ├── Dockerfile-restServer
│   └── Dockerfile-tradesBlockService
├── deployments
│   ├── config                               Config files needed for initialize cluster containers
│   │   ├── influxdb2.conf
│   │   ├── influxdb.conf
│   │   ├── pginit.sql
│   │   ├── postgresql.conf
│   │   └── redis.conf
│   ├── k8s-yaml                             Deployment configs
│   │   ├── exchangescraper-*.yaml
│   │   ├── filtersblockservice.yaml
│   │   ├── influx.yaml
│   │   ├── kafka.yaml
│   │   ├── postgres.yaml
│   │   ├── redis.yaml
│   │   ├── restserver.yaml
│   │   └── tradesblockservice.yaml
│   ├── init.sh                              Script for initialize local cluster
│   ├── start.sh                             Script for start containers
│   └── stop.sh                              Script for stop containers
└── minikube.log                             Cluster log
```

Overview diagram:

![cluster_diagram](diagram.png)

---

## Guides

### Add an exchange scraper

> Reference: https://docs.diadata.org/contribute/tutorials/exchangescrapers

Add exchange at `pkg/dia/Config.go`:

```go
const (
  MySourceExchangeExchange           = "MySourceExchange"
  // ... and all other exchanges
)
```

Add JSON object at `config/exchanges/exchanges.json`:

```json
{
  "Exchanges": [
    {
      "Name": "MySourceExchange",
      "Centralized": true,
      "Bridge": false,
      "Contract": "",
      "Blockchain": {
        "Name": ""
      },
      "RestAPI": "",
      "WsAPI": "",
      "pairsAPI": "",
      "WatchdogDelay": 1200
    }
    // ... and all other exchanges
  ]
}
```

Add pairs to `config/MySourceExchange.json` config:

```json
{
  "Coins": [
    {
      "Exchange": "MySourceExchange",
      "ForeignName": "QUICK-USD",
      "Ignore": false,
      "Symbol": "QUICK"
    }
    // ... and all other pairs
  ]
}
```

And Git verified coin tokens to `config/gitcoinverified/MySourceExchange.json` config:

```json
{
  "Tokens": [
    {
      "Symbol": "WBTC",
      "Exchange": "MySourceExchange",
      "Blockchain": "Ethereum",
      "Address": "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599"
    }
    // ... and all other pairs
  ]
}
```

Now just add a [**Go**](go.md) file to implement the scraper class at `pkg/dia/scraper/exchange-scrapers/MySourceExchangeScraper.go` with this template:

```go
type APIScraper interface {
	io.Closer
	// ScrapePair returns a PairScraper that continuously scrapes trades for a
	// single pair from this APIScraper
	ScrapePair(pair dia.Pair) (PairScraper, error) // only for centralized exchanges
	// FetchAvailablePairs returns a list with all available trade pairs (usually
	// fetched from an exchange's API)
	FetchAvailablePairs() (pairs []dia.Pair, err error)
	// Channel returns a channel that can be used to receive trades
	Channel() chan *dia.Trade
  // TODO
  FillSymbolData(symbol string) (asset dia.Asset, err error)
  // TODO
  NormalizePair(pair dia.ExchangePair) (dia.ExchangePair, error)
}
type PairScraper interface {
	io.Closer
	// Error returns an error when the channel Channel() is closed
	// and nil otherwise
	Error() error
	// Pair returns the pair this scraper is subscribed to
	Pair() dia.ExchangePair
}
```

Furthermore, in order for our system to see your scraper, add a reference to it in Config.go in the dia package, and to the switch statement in `pkg/dia/scraper/exchange-scrapers/APIScraper.go` in the scrapers package:

```go
func NewAPIScraper(exchange string, key string, secret string) APIScraper {
	switch exchange {
	case dia.MySourceExchange:
		return NewMySourceScraper(key, secret, dia.MySourceExchange)
	}
}
```

Other common methods (totally optional):

```go
//  ExchangeScraper
func (s *ExchangeScraper) mainLoop() {}
  -> func (s *ExchangeScraper) cleanup() {}
func (s *ExchangeScraper) ping() {}
func (s *ExchangeScraper) subscribe(pair dia.ExchangePair) error {}
func (s *ExchangeScraper) unsubscribe(pair dia.ExchangePair) error {}
func (s *ExchangeScraper) isClosed() bool {}
func (s *ExchangeScraper) close() {}
func (s *ExchangeScraper) error() error {}
func (s *ExchangeScraper) setError(err error) {}
```

Check the quotations by typing this using `influxdb` CLI:

```
USE dia
SELECT * FROM assetQuotations WHERE time > now() - 4m
```

### Add an foreign scraper

Scrapers are all at: `pkg/dia/scraper/foreign-scrapers/` and interfaces are at `pkg/dia/scraper/foreign-scrapers/Scrapper.go`

```go
type ForeignScrapperer interface {
	UpdateQuotation() error
	GetQuoteChannel() chan *models.ForeignQuotation
}
```

1. Add scraper implementation

Add a `MyExchangeScraper.go` Golang file to `pkg/dia/scraper/foreign-scrapers/` folder and add the next implementations:

```go
func (scraper *MyExchangeScraper) Pool() chan dia.Pool {}
func (scraper *MyExchangeScraper) Done() chan bool {}
```

2. Add a constructor

Add a constructor for the scraper:

```go
func NewMyExchangeScraper(exchange dia.Exchange) *MyExchangeScraper {}
```

3. Add MyExchangeScraper to foreign scraper cmd

At `cmd/foreignscraper/foreign.go` add a additional case on main type switch:

```go
// ...
switch *scraperType {
	// ...
	case "CoinMarketCap":
		log.Println("Foreign Scraper: Start scraping data from CoinMarketCap")
		sc = scrapers.NewCoinMarketCapScraper(ds)
	case "MyExchangeScraper": // <-- add your switch-case base on scraper name
		log.Println("Foreign Scraper: Start scraping data from MyExchangeScraper")
		sc = scrapers.NewMyExchangeScraper(ds)
	default:
		sc = scrapers.NewGenericForeignScraper()
}
// ...
```

### Add an liquidity scraper

Scrapers are all at: `pkg/dia/scraper/liquidity-scrapers/` and interfaces are at `pkg/dia/scraper/liquidity-scrapers/ScraperInterface.go`

```go
type LiquidityScraper interface {
	Pool() chan dia.Pool
	Done() chan bool
}
```

1. Add scraper implementation

Add a `MySourceExchange.go` Golang file to `pkg/dia/scraper/liquidity-scrapers/` folder and add the next implementations:

```go
func (scraper *MySourceExchangeScraper) Pool() chan dia.Pool {}
func (scraper *MySourceExchangeScraper) Done() chan bool {}
```

2. Add a constructor

Add a constructor for the scraper:

```go
func NewMySourceExchangeScraper(exchange dia.Exchange) *MySourceExchangeScraper {}
```