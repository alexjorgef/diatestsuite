#!/usr/bin/env bash
set -e

(
    cd containers
    docker save dia-exchangescraper-collector:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-http-restserver:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-assetcollectionservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-blockchainservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-filtersblockservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-pairdiscoveryservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-tradesblockservice:0.1 | (eval $(minikube docker-env) && docker load)
)