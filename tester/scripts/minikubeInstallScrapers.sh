#!/bin/bash

minikube_profile="diadata-tester"

kubectl config use-context "${minikube_profile}"

kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"

sleep 10

kubectl create -f "deployments/k8s-yaml/liquidityscraper-platypus.yaml"