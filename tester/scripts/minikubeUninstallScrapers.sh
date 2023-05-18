#!/usr/bin/env bash

minikube_profile="diadata-tester"

kubectl config use-context "${minikube_profile}"

kubectl delete -f "deployments/k8s-yaml/liquidityscraper-platypus.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-bittrex.yaml" \
-f "deployments/k8s-yaml/exchangescraper-coinbase.yaml" \
-f "deployments/k8s-yaml/exchangescraper-mexc.yaml"