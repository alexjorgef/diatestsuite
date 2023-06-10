#!/usr/bin/env bash

minikube_profile="diadata-dumper"

kubectl config use-context "${minikube_profile}"

kubectl delete -f "deployments/k8s-yaml/postgres-snapshot-cron.yaml"
kubectl delete secret regcred