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
    cd containers/db-kafka
    make build
)

(
    cd containers/service-tradesblockservice
    if [ ! -d ./diadata ] ; then
        git clone https://github.com/diadata-org/diadata diadata
    else 
        (
            cd diadata
            git pull
        )
    fi
    make build
)

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_enable "${DIA_VM_PROFILE}"
fi