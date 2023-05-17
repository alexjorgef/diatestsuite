#!/bin/bash

kubectl delete -f "deployments/k8s-yaml/postgres-cron-pod-extract.yaml"
# kubectl delete -f "deployments/k8s-yaml/postgres-cron-pod.yaml"
kubectl delete secret regcred