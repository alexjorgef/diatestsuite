#!/usr/bin/env bash

kubectl delete -f "deployments/k8s-yaml/posgres-cron.yaml"

kubectl delete -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml" \
-f "deployments/k8s-yaml/liquidityscraper-orca.yaml"

kubectl delete -f "deployments/k8s-yaml/filtersblockservice.yaml" \
-f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/kafka.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/influx.yaml"

kubectl delete configmap redis-configmap influx-configmap postgres-configmap