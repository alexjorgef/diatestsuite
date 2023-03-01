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
    docker build -f Dockerfile-genericCollector --tag=dia-exchangescraper-collector:0.1 .
    docker build -f Dockerfile-restServer --tag=dia-http-restserver:0.1 .
    docker build -f Dockerfile-assetCollectionService --tag=dia-service-assetcollectionservice:0.1 .
    docker build -f Dockerfile-blockchainservice --tag=dia-service-blockchainservice:0.1 .
    docker build -f Dockerfile-filtersBlockService --tag=dia-service-filtersblockservice:0.1 .
    docker build -f Dockerfile-pairDiscoveryService --tag=dia-service-pairdiscoveryservice:0.1 .
    docker build -f Dockerfile-tradesBlockService --tag=dia-service-tradesblockservice:0.1 .
)

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_enable "${DIA_VM_PROFILE}"
fi