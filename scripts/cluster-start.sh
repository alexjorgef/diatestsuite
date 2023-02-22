#!/usr/bin/env bash
set -e

# Databases and datastores
kubectl create -f "pods/db-influx.yaml"
kubectl create -f "pods/db-redis.yaml"
kubectl create -f "pods/db-postgres.yaml"
#kubectl create -f "pods/db-kafka.yaml"

# Services
#kubectl create -f "pods/service-tradesblockservice.yaml"
#kubectl create -f "pods/service-filtersblockservice.yaml"

# Scrapers
#kubectl create -f "pods/scraper-bitfinex.yaml"
#kubectl create -f "pods/scraper-bittrex.yaml"
kubectl create -f "pods/scraper-coinbase.yaml"
#kubectl create -f "pods/scraper-mexc.yaml"