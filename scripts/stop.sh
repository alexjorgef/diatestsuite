#!/usr/bin/env bash

echo "Cleaning and stopping rest server..."
kubectl delete -f "pods/http-restserver.yaml"

echo "Cleaning and stopping scrapers:exchanges..."
kubectl delete -f "pods/scraper-exchangescraper-bitfinex.yaml" \
-f "pods/scraper-exchangescraper-bittrex.yaml" \
-f "pods/scraper-exchangescraper-coinbase.yaml" \
-f "pods/scraper-exchangescraper-mexc.yaml" \
-f "pods/scraper-exchangescraper-dfyn.yaml" \
-f "pods/scraper-exchangescraper-bitmax.yaml" \
-f "pods/scraper-exchangescraper-crex24.yaml" \
-f "pods/scraper-exchangescraper-hitbtc.yaml" \
-f "pods/scraper-exchangescraper-loopring.yaml" \
-f "pods/scraper-exchangescraper-uniswap.yaml" \
-f "pods/scraper-exchangescraper-uniswapv3.yaml" \
-f "pods/scraper-exchangescraper-sushiswap.yaml" \
-f "pods/scraper-exchangescraper-kucoin.yaml" \
-f "pods/scraper-exchangescraper-stex.yaml" \
-f "pods/scraper-exchangescraper-okex.yaml" \
-f "pods/scraper-exchangescraper-kraken.yaml" \
-f "pods/scraper-exchangescraper-zb.yaml" \
-f "pods/scraper-exchangescraper-quoine.yaml" \
-f "pods/scraper-exchangescraper-bitbay.yaml"

echo "Cleaning and stopping services..."
kubectl delete -f "pods/service-tradesblockservice.yaml" \
-f "pods/service-filtersblockservice.yaml"

echo "Cleaning and stopping data services..."
kubectl delete -f "pods/db-influx.yaml" \
-f "pods/db-redis.yaml" \
-f "pods/db-postgres.yaml" \
-f "pods/db-kafka.yaml"

kubectl delete configmap postgres-configmap
kubectl delete configmap pginit-configmap
kubectl delete configmap redis-configmap