#!/usr/bin/env sh
set -e

echo "- Creating and starting scrapers:exchanges..."
kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitmax.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kucoin.yaml" \
-f "deployments/k8s-yaml/exchangescraper-okex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kraken.yaml"