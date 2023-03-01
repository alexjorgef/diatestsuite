#!/usr/bin/env bash
set -e

DIA_VM_PROFILE="diadata-vmprofile"

__cluster_env_enable() {
    echo "Enabling cluster environment ..."
    eval "$(minikube -p "${1}" docker-env)"
    if [ $? -eq 0 ]; then
        echo "Cluster environment is now enabled"
    else
        echo "Cluster environment enabling failed"
        exit 1
    fi
}
__cluster_env_disable() {
    echo "Disabling cluster environment ..."
    eval "$(minikube docker-env -u)"
    if [ $? -eq 0 ]; then
        echo "Cluster environment is now disabled"
    else
        echo "Cluster environment disabling failed"
        exit 1
    fi
}

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_disable
fi

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

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_enable "${DIA_VM_PROFILE}"
fi