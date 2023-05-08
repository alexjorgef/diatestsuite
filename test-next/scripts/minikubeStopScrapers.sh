#!/usr/bin/env bash

kubectl delete -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"