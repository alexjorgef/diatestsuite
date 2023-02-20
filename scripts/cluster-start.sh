#!/usr/bin/env bash
set -e

kubectl create -f "pods/db-influx.yaml"
kubectl create -f "pods/db-redis.yaml"
kubectl create -f "pods/db-postgres.yaml"