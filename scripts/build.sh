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
    cd containers/db-influx
    make build
)

(
    cd containers/db-redis
    make build
)

(
    cd containers/db-postgres
    make build
)

(
    cd containers/diacmd-services-tradesblockservice
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-services-filtersblockservice
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-exchangescraper-collector
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-services-blockchainservice
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-services-pairDiscoveryService
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-services-assetCollectionService
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

(
    cd containers/diacmd-http-restServer
    if [ -d ./diadata ] ; then
        rm -rf diadata
    fi
    git clone https://github.com/diadata-org/diadata
    make build
)

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_enable "${DIA_VM_PROFILE}"
fi