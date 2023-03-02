#!/usr/bin/env bash
set -e

echo "Creating config maps..."
kubectl create configmap redis-configmap --from-file=deployments/config/redis.conf
kubectl create configmap influx-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap postgres-configmap --from-file=deployments/config/postgresql.conf
kubectl create configmap pginit-configmap --from-file=deployments/config/pginit.sql

echo "Creating and starting data services..."
kubectl create -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml"

echo "Creating and starting services..."
kubectl create -f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

echo "Creating and starting scrapers:exchanges..."
kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitmax.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kucoin.yaml" \
-f "deployments/k8s-yaml/exchangescraper-okex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kraken.yaml"

echo "Creating and starting rest server..."
kubectl create -f "deployments/k8s-yaml/restserver.yaml"