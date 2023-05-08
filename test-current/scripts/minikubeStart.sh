#!/usr/bin/env bash

minikube_kubernetes_ver="v1.25.8"
minikube_profile="diadata"
minikube_driver="docker"

minikube start --kubernetes-version="${minikube_kubernetes_ver}" \
    --profile="${minikube_profile}" \
    --driver="${minikube_driver}"
    # --mount-string="$HOME/go/src/github.com/nginx:/data" \
    # --mount