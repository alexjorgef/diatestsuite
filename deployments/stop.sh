#!/usr/bin/env sh
# TODO: uncomment below line when work is done here
#set -e

echo "Cleaning and stopping rest server..."
kubectl delete -f "deployments/k8s-yaml/restserver.yaml"

echo "Cleaning and stopping scrapers:exchanges..."
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
-f "deployments/k8s-yaml/exchangescraper-bitbay.yaml"

echo "Cleaning and stopping services..."
kubectl delete -f "deployments/k8s-yaml/tradesblockservice.yaml" \
-f "deployments/k8s-yaml/filtersblockservice.yaml"

echo "Cleaning and stopping data services..."
kubectl delete -f "deployments/k8s-yaml/influx.yaml" \
-f "deployments/k8s-yaml/redis.yaml" \
-f "deployments/k8s-yaml/postgres.yaml" \
-f "deployments/k8s-yaml/kafka.yaml"

echo "Deleting config maps..."
kubectl delete configmap postgres-configmap
kubectl delete configmap pginit-configmap
kubectl delete configmap redis-configmap
kubectl delete configmap influx-configmap