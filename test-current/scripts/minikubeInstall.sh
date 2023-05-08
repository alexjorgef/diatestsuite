#!/usr/bin/env bash

kubectl create configmap redis-configmap --from-file=deployments/config/redis.conf
kubectl create configmap influx-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap postgres-configmap --from-file=deployments/config/pginit.sql

kubectl create -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml" \
-f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"