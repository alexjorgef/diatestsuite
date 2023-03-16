#!/usr/bin/env sh
# TODO: uncomment below line when work is done here
#set -e

echo "- Cleaning and stopping delivery services..."
kubectl delete -f "deployments/k8s-yaml/restserver.yaml" \
-f "deployments/k8s-yaml/graphqlserver.yaml"

echo "- Cleaning and stopping services..."
kubectl delete -f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

echo "- Cleaning and stopping monitoring services..."
kubectl delete -f "deployments/k8s-yaml/grafana.yaml"

echo "- Cleaning and stopping data services..."
kubectl delete -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml"

echo "- Deleting config maps..."
kubectl delete configmap postgres-configmap
kubectl delete configmap pginit-configmap
kubectl delete configmap redis-configmap
kubectl delete configmap influx-configmap
kubectl delete configmap grafana-datasources-configmap