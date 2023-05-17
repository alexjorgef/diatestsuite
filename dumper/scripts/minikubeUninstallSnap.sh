#!/bin/bash

kubectl delete -f "deployments/k8s-yaml/postgres-snapshot-cron.yaml"
kubectl delete secret regcred