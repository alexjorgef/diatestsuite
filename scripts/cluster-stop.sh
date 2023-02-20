#!/usr/bin/env bash
set -e

kubectl delete -f "pods/db-influx.yaml"
kubectl delete -f "pods/db-redis.yaml"