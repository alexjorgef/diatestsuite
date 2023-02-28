#!/usr/bin/env bash
set -e

echo "Creating and starting data services..."
kubectl create -f "pods/db-influx.yaml" \
-f "pods/db-redis.yaml" \
-f "pods/db-postgres.yaml" \
-f "pods/db-kafka.yaml"

echo "Creating and starting services..."
kubectl create -f "pods/service-tradesblockservice.yaml" \
-f "pods/service-filtersblockservice.yaml"

echo "Creating and starting scrapers:exchanges..."
kubectl create -f "pods/scraper-exchangescraper-bitfinex.yaml" \
-f "pods/scraper-exchangescraper-bittrex.yaml" \
-f "pods/scraper-exchangescraper-coinbase.yaml" \
-f "pods/scraper-exchangescraper-mexc.yaml" \
-f "pods/scraper-exchangescraper-bitmax.yaml" \
-f "pods/scraper-exchangescraper-kucoin.yaml" \
-f "pods/scraper-exchangescraper-okex.yaml" \
-f "pods/scraper-exchangescraper-kraken.yaml"