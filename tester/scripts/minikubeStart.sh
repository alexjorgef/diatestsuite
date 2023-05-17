#!/usr/bin/env bash

minikube_kubernetes_ver="v1.25.8"
minikube_profile="diadata-tester"
minikube_driver="docker"

minikube start --kubernetes-version="${minikube_kubernetes_ver}" \
    --profile="${minikube_profile}" \
    --user="$(whoami)" \
    --driver="${minikube_driver}" \
    --mount-string="$(pwd):/mnt/diadata-tester:rw" \
    --mount=true