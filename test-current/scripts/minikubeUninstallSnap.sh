#!/bin/bash

kubectl delete -f "deployments/k8s-yaml/posgres-cron-pod.yaml"
kubectl delete secret kaniko-secret