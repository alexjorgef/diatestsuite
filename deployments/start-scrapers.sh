#!/usr/bin/env sh
set -e

echo "- Building and loading images ..."
docker build -f "build/Dockerfile-genericCollector" --tag=dia-exchangescraper-collector:0.1 .
docker build -f "build/Dockerfile-ecb" --tag=dia-exchangescraper-ecb:0.1 .
docker save dia-exchangescraper-collector:0.1 | (eval $(minikube docker-env) && docker load)
docker save dia-exchangescraper-ecb:0.1 | (eval $(minikube docker-env) && docker load)

echo "- Creating and starting scrapers..."
kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitmax.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kucoin.yaml" \
-f "deployments/k8s-yaml/exchangescraper-okex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kraken.yaml" \
-f "deployments/k8s-yaml/exchangescraper-ecb.yaml"