#!/bin/bash

kubectl create -f "deployments/k8s-yaml/posgres-cron.yaml"
kubectl create secret generic kaniko-secret --from-file="deployments/config/kaniko-secret.json"