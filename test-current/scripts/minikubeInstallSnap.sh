#!/bin/bash

kubectl create secret docker-registry regcred \
    --docker-server="https://registry.hub.docker.com/v2/" \
    --docker-username="alex1a" \
    --docker-password="R3Uf&nq@A9&hv&" \
    --docker-email="alex.jorge.m@gmail.com"
kubectl create -f "deployments/k8s-yaml/postgres-cron-pod.yaml"