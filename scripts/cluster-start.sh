#!/usr/bin/env bash
set -e

# Databases and datastores
#kubectl create -f "pods/db-influx.yaml"
#kubectl create -f "pods/db-redis.yaml"
#kubectl create -f "pods/db-postgres.yaml"
#kubectl create -f "pods/db-kafka.yaml"

# Services
#kubectl create -f "pods/service-tradesblockservice.yaml"
#kubectl create -f "pods/service-filtersblockservice.yaml"

# Scrapers
#kubectl create -f "pods/scraper-exchangescraper-bitfinex.yaml"
#kubectl create -f "pods/scraper-exchangescraper-bittrex.yaml"
#kubectl create -f "pods/scraper-exchangescraper-coinbase.yaml"
#kubectl create -f "pods/scraper-exchangescraper-mexc.yaml"
# kubectl create -f "pods/scraper-exchangescraper-dfyn.yaml"
# kubectl create -f "pods/scraper-exchangescraper-bitmax.yaml"
# kubectl create -f "pods/scraper-exchangescraper-crex24.yaml"
# kubectl create -f "pods/scraper-exchangescraper-hitbtc.yaml"
# kubectl create -f "pods/scraper-exchangescraper-loopring.yaml"
# kubectl create -f "pods/scraper-exchangescraper-uniswap.yaml"
# kubectl create -f "pods/scraper-exchangescraper-uniswapv3.yaml"
# kubectl create -f "pods/scraper-exchangescraper-sushiswap.yaml"
# kubectl create -f "pods/scraper-exchangescraper-kucoin.yaml"
# kubectl create -f "pods/scraper-exchangescraper-stex.yaml"
# kubectl create -f "pods/scraper-exchangescraper-okex.yaml"
kubectl create -f "pods/scraper-exchangescraper-kraken.yaml"
kubectl create -f "pods/scraper-exchangescraper-zb.yaml"
kubectl create -f "pods/scraper-exchangescraper-quoine.yaml"
kubectl create -f "pods/scraper-exchangescraper-bitbay.yaml"