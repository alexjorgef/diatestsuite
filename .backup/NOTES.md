## Debug Influx writes

To debug InfluxDB writes, just change points in batch to see more frequent writes to influx (`pkg/model/db.go`):

```go
influxMaxPointsInBatch = 10
```

## Accessing endpoints

The routes available after forward:

* REST Server: port 8081
* GraphQL: port 1111, and [Web UI](http://localhost:1111/)
* Kafka: port 8080, and [AKHQ Web UI](http://localhost:8080/)
* Grafana: port 3000, and [Web UI](http://localhost:3000/)

## Add a new foreign scraper

Implement `ForeignScrapperer` interface at `pkg/dia/scraper/foreign-scrapers/Scrapper.go` file

```go
type ForeignScrapperer interface {
	UpdateQuotation() error
	GetQuoteChannel() chan *models.ForeignQuotation
}
```

Add the scraper implementation a `MyForeignScraper.go` Golang file to `pkg/dia/scraper/foreign-scrapers/` folder and add the next implementations:

```go
func (scraper *MyForeignScraper) Pool() chan dia.Pool {}
func (scraper *MyForeignScraper) Done() chan bool {}
```

1. Add a constructor for the scraper:

```go
func NewMyForeignScraper(exchange dia.Exchange) *MyForeignScraper {}
```

1. Add `MyForeignScraper` case at scraper file `cmd/foreignscraper/foreign.go`:

```go
switch *scraperType {
	case "MyForeignScraper":
		log.Println("Start scraping data")
		sc = scrapers.NewMyForeignScraper(ds)
}
```

## Add a new liquidity scraper

Implement `LiquidityScraper` interface at `pkg/dia/scraper/liquidity-scrapers/ScraperInterface.go` file

```go
type LiquidityScraper interface {
	Pool() chan dia.Pool
	Done() chan bool
}
```

1. Add a scraper implementation, `MyLiquidityScraper.go` file to `pkg/dia/scraper/liquidity-scrapers/` folder implement the functions:

```go
func (scraper *MyLiquidityScraper) Pool() chan dia.Pool {}
func (scraper *MyLiquidityScraper) Done() chan bool {}
```

1. Add a constructor for the scraper:

```go
func NewMyLiquidityScraper(exchange dia.Exchange) *MyLiquidityScraper {}
```