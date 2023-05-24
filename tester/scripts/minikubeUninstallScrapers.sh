#!/usr/bin/env bash

minikube_profile="diadata-tester"

kubectl config use-context "${minikube_profile}"

kubectl delete -f "deployments/k8s-yaml/liquidityscraper-platypus.yaml"

kubectl delete -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"