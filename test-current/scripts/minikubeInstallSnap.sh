#!/bin/bash

kubectl create secret docker-registry regcred \
    --docker-server="https://index.docker.io/v1/" \
    --docker-username="alex1a" \
    --docker-password="R3Uf&nq@A9&hv&"
kubectl create -f "deployments/k8s-yaml/postgres-cron-pod.yaml"