#!/usr/bin/env bash

minikube_kubernetes_ver="v1.25.8"
minikube_profile="diadata-dumper"
minikube_driver="docker"

minikube start --kubernetes-version="${minikube_kubernetes_ver}" \
    --profile="${minikube_profile}" \
    --driver="${minikube_driver}" \
    --mount-string="$(pwd):/mnt/diadata-dumper:rw" \
    --mount=true