# Backup Documentation

A toolkit for building and developing the DIA platform

## Requirements

* A system with at least 8GB of RAM;
* [Docker](https://www.docker.com) installed on your system.

## Running a Minikube cluster

This will setup a [Minikube](https://github.com/kubernetes/minikube) cluster, running on an `diadata` profile.

## Guides and tutorials

### How to add a new foreign scraper

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

### How to add a new liquidity scraper

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

## Monitoring

For monitoring the cluster resources we install a Prometheus operator that has multiple services with user interfaces, please check the [kube-prometheus documentation](https://github.com/prometheus-operator/kube-prometheus/blob/main/docs/access-ui.md).

## Debug & Troubleshooting

In order to show logs from cluster just type the following command:

```sh
kubectl logs <POD_NAME>
```

To debug InfluxDB writes, just change points in batch to see more frequent writes to influx (`pkg/model/db.go`):

```go
influxMaxPointsInBatch = 10
```

## Accessing UIs and data endpoints

### Grafana

Forward the ports of UIs to your machine:

```bash
kubectl port-forward diadata-clusterdev-grafana 3000:3000
```

After that, you can access Grafana at [http://localhost:3000/](http://localhost:3000/)

### Kafka UI

Forward the ports of UIs to your machine:

```bash
kubectl port-forward diadata-clusterdev-db-kafka 8080:8080
```

After that, you can access AKHQ, the Kafka GUI at [http://localhost:8080/](http://localhost:8080/)

### Delivery services

Forward data delivery service's ports to localhost:

```shell
# REST Server
kubectl port-forward diadata-clusterdev-http-restserver 8081:8081

# GraphQL Server
kubectl port-forward diadata-clusterdev-http-graphqlserver 1111:1111
```

The routes available after you forward them to the host machine:

* **REST Server**: localhost:8081
* **GraphQL**:
  * **Server**: localhost:1111
  * **Web UI**: [http://localhost:1111/](http://localhost:1111/)

## Other useful commands

Clean unused resources on docker:

```shell
docker system prune -af
```