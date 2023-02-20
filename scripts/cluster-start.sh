#!/usr/bin/env bash
set -e

kubectl delete -f "pods/db-influx.yaml"

kubectl create -f "pods/db-influx.yaml"