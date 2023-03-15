#!/usr/bin/env sh
set -e

echo "- Creating config maps..."
kubectl create configmap redis-configmap --from-file=deployments/config/redis.conf
kubectl create configmap influx-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap postgres-configmap --from-file=deployments/config/postgresql.conf
kubectl create configmap pginit-configmap --from-file=deployments/config/pginit.sql
kubectl create configmap grafana-datasources-configmap --from-file=deployments/config/grafana-datasources.yaml

echo "- Creating and starting data services..."
kubectl create -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml"

echo "- Creating and starting monitoring services..."
kubectl create -f "deployments/k8s-yaml/grafana.yaml"

echo "- Creating and starting services..."
kubectl create -f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

echo "- Creating and starting rest server..."
kubectl create -f "deployments/k8s-yaml/restserver.yaml"