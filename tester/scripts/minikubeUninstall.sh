#!/usr/bin/env bash

minikube_profile="diadata-tester"

kubectl config use-context "${minikube_profile}"

kubectl delete -f "deployments/k8s-yaml/filtersblockservice.yaml"
kubectl delete -f "deployments/k8s-yaml/tradesblockservice.yaml"
kubectl delete -f "deployments/k8s-yaml/kafka.yaml"
kubectl delete -f "deployments/k8s-yaml/postgres.yaml"
kubectl delete -f "deployments/k8s-yaml/redis.yaml"
kubectl delete -f "deployments/k8s-yaml/influx.yaml"

kubectl delete configmap redis-configmap influx-configmap postgres-configmap