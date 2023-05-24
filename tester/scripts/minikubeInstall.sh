#!/usr/bin/env bash

minikube_profile="diadata-tester"

kubectl config use-context "${minikube_profile}"

# kubectl create configmap redis-configmap --from-file=deployments/config/redis.conf
# kubectl create configmap influx-configmap --from-file=deployments/config/influxdb.conf
kubectl create configmap postgres-configmap --from-file=deployments/config/pginit.sql

kubectl create -f "deployments/k8s-yaml/influx.yaml"
kubectl create -f "deployments/k8s-yaml/redis.yaml"
kubectl create -f "deployments/k8s-yaml/postgres.yaml"
kubectl create -f "deployments/k8s-yaml/kafka.yaml"
kubectl create -f "deployments/k8s-yaml/tradesblockservice.yaml"
kubectl create -f "deployments/k8s-yaml/filtersblockservice.yaml"