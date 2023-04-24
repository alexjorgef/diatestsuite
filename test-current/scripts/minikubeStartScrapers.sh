#!/usr/bin/env bash

kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"