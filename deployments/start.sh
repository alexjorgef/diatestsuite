#!/usr/bin/env sh
set -e

echo "- Building and loading images ..."
docker build -f "build/Dockerfile-restServer" --tag=dia-http-restserver:0.1 --quiet .
docker build -f "build/Dockerfile-graphqlServer" --tag=dia-http-graphqlserver:0.1 --quiet .
docker build -f "build/Dockerfile-assetCollectionService" --tag=dia-service-assetcollectionservice:0.1 --quiet .
docker build -f "build/Dockerfile-blockchainservice" --tag=dia-service-blockchainservice:0.1 --quiet .
docker build -f "build/Dockerfile-supplyService" --tag=dia-service-supplyservice:0.1 --quiet .
docker build -f "build/Dockerfile-filtersBlockService" --tag=dia-service-filtersblockservice:0.1 --quiet .
docker build -f "build/Dockerfile-pairDiscoveryService" --tag=dia-service-pairdiscoveryservice:0.1 --quiet .
docker build -f "build/Dockerfile-tradesBlockService" --tag=dia-service-tradesblockservice:0.1 --quiet .
docker save dia-http-restserver:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-http-graphqlserver:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-assetcollectionservice:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-blockchainservice:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-supplyservice:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-filtersblockservice:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-pairdiscoveryservice:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-service-tradesblockservice:0.1 | (eval $(minikube docker-env) && docker load)

echo "- Creating config maps..."
kubectl create configmap redis-configmap --from-file=deployments/config/redis.conf
kubectl create configmap influx-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap influx-migration2-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap postgres-configmap --from-file=deployments/config/postgresql.conf
kubectl create configmap pginit-configmap --from-file=deployments/config/pginit.sql
kubectl create configmap grafana-datasources-configmap --from-file=deployments/config/grafana-datasources.yaml
kubectl create configmap akhq-configmap --from-file=deployments/config/akhq.yaml

echo "- Creating and starting data services..."
kubectl create -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/influx-migration2.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml"

echo "- Creating and starting monitoring services..."
kubectl create -f "deployments/k8s-yaml/grafana.yaml"

echo "- Creating and starting services..."
kubectl create -f "deployments/k8s-yaml/supplyservice.yaml" \
-f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

echo "- Creating and starting delivery services..."
kubectl create -f "deployments/k8s-yaml/restserver.yaml" \
-f "deployments/k8s-yaml/graphqlserver.yaml"