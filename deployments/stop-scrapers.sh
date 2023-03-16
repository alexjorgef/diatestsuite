#!/usr/bin/env sh
set -e

echo "- Cleaning and stopping scrapers..."
kubectl delete -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml" \
-f "deployments/k8s-yaml/exchangescraper-dfyn.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitmax.yaml" \
-f "deployments/k8s-yaml/exchangescraper-crex24.yaml" \
-f "deployments/k8s-yaml/exchangescraper-hitbtc.yaml" \
-f "deployments/k8s-yaml/exchangescraper-loopring.yaml" \
-f "deployments/k8s-yaml/exchangescraper-uniswap.yaml" \
-f "deployments/k8s-yaml/exchangescraper-uniswapv3.yaml" \
-f "deployments/k8s-yaml/exchangescraper-sushiswap.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kucoin.yaml" \
-f "deployments/k8s-yaml/exchangescraper-stex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-okex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-kraken.yaml" \
-f "deployments/k8s-yaml/exchangescraper-zb.yaml" \
-f "deployments/k8s-yaml/exchangescraper-quoine.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitbay.yaml" \
-f "deployments/k8s-yaml/exchangescraper-ecb.yaml"