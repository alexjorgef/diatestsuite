#!/usr/bin/env bash
set -e

# TODO: isolate this first stage of init containers in a helm chart

echo "Creating config maps..."
kubectl create configmap redis-configmap --from-file=pods/redis.conf
kubectl create configmap influx-configmap --from-file=pods/influxdb.conf
kubectl create configmap postgres-configmap --from-file=pods/postgresql.conf
kubectl create configmap pginit-configmap --from-file=pods/pginit.sql

echo "Creating and starting data services..."
kubectl create -f "pods/db-influx.yaml" \
-f "pods/db-redis.yaml" \
-f "pods/db-postgres.yaml" \
-f "pods/db-kafka.yaml"

echo "Creating and starting services..."
kubectl create -f "pods/service-tradesblockservice.yaml" \
-f "pods/service-filtersblockservice.yaml"

sleep 5

echo "Creating and starting scrapers:exchanges..."
kubectl create -f "pods/scraper-exchangescraper-bitfinex.yaml" \
-f "pods/scraper-exchangescraper-bittrex.yaml" \
-f "pods/scraper-exchangescraper-coinbase.yaml" \
-f "pods/scraper-exchangescraper-mexc.yaml" \
-f "pods/scraper-exchangescraper-bitmax.yaml" \
-f "pods/scraper-exchangescraper-kucoin.yaml" \
-f "pods/scraper-exchangescraper-okex.yaml" \
-f "pods/scraper-exchangescraper-kraken.yaml"

echo "Creating and starting rest server..."
kubectl create -f "pods/http-restserver.yaml"