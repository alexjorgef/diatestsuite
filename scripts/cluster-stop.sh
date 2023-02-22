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
kubectl delete -f "pods/scraper-bitfinex.yaml"
kubectl delete -f "pods/scraper-bittrex.yaml"
kubectl delete -f "pods/scraper-coinbase.yaml"
kubectl delete -f "pods/scraper-mexc.yaml"