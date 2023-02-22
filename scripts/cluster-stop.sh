#!/usr/bin/env bash

# Databases and datastores
kubectl delete -f "pods/db-influx.yaml"
kubectl delete -f "pods/db-redis.yaml"
kubectl delete -f "pods/db-postgres.yaml"
kubectl delete -f "pods/db-kafka.yaml"

# Services
kubectl delete -f "pods/service-tradesblockservice.yaml"
kubectl delete -f "pods/service-filtersblockservice.yaml"

# Scrapers
kubectl delete -f "pods/scraper-exchangescraper-bitfinex.yaml"
kubectl delete -f "pods/scraper-exchangescraper-bittrex.yaml"
kubectl delete -f "pods/scraper-exchangescraper-coinbase.yaml"
kubectl delete -f "pods/scraper-exchangescraper-mexc.yaml"
kubectl delete -f "pods/scraper-exchangescraper-dfyn.yaml"
kubectl delete -f "pods/scraper-exchangescraper-bitmax.yaml"
kubectl delete -f "pods/scraper-exchangescraper-crex24.yaml"
kubectl delete -f "pods/scraper-exchangescraper-hitbtc.yaml"
kubectl delete -f "pods/scraper-exchangescraper-loopring.yaml"
kubectl delete -f "pods/scraper-exchangescraper-uniswap.yaml"
kubectl delete -f "pods/scraper-exchangescraper-uniswapv3.yaml"
kubectl delete -f "pods/scraper-exchangescraper-sushiswap.yaml"
kubectl delete -f "pods/scraper-exchangescraper-kucoin.yaml"
kubectl delete -f "pods/scraper-exchangescraper-stex.yaml"
kubectl delete -f "pods/scraper-exchangescraper-okex.yaml"
kubectl delete -f "pods/scraper-exchangescraper-kraken.yaml"
kubectl delete -f "pods/scraper-exchangescraper-zb.yaml"
kubectl delete -f "pods/scraper-exchangescraper-quoine.yaml"
kubectl delete -f "pods/scraper-exchangescraper-bitbay.yaml"