#!/usr/bin/env sh
set -e

EXITCODE=0

# https://github.com/moby/moby/blob/master/contrib/check-config.sh
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "$1 command available"
    else
        echo "$1 command missing"
        EXITCODE=1
    fi
}

cluster_env_enable() {
    echo "Enabling cluster environment ..."
    eval "$(minikube -p "${1}" docker-env)"
    if [ $? -eq 0 ]; then
        echo "Cluster environment is now enabled"
    else
        echo "Cluster environment enabling failed"
        exit 1
    fi
}

cluster_env_disable() {
    echo "Disabling cluster environment ..."
    eval "$(minikube docker-env -u)"
    if [ $? -eq 0 ]; then
        echo "Cluster environment is now disabled"
    else
        echo "Cluster environment disabling failed"
        exit 1
    fi
}

check_command kubectl
[ "$EXITCODE" = 0 ] && echo "OK kubectl"
check_command minikube
[ "$EXITCODE" = 0 ] && echo "OK minikube"

DIA_VM_PROFILE="dia-vmprofile"
DIA_NAMESPACE="dia-system"
DIA_NAMESPACE_NODE="dia-system-node"
DIA_CHART_NAME="dia-release"
# TODO: after deploy
# DIA_CHART="dia/dia"
DIA_CHART="./deployments/helm/dia"
CLUSTER_HW_MEMORY=4096
CLUSTER_HW_VCPU=4
CLUSTER_HW_DISK_SIZE="30g"
MINIKUBE_VLVL=1
MINIKUBE_DRIVER="docker"
MINIKUBE_CONTAINER_RUNTIME="docker"
MINIKUBE_KUBERNETES_VER="v1.23.8"
MINIKUBE_NODES=1

if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    check_command docker
    [ "$EXITCODE" = 0 ] && echo "OK docker"
    [ "$(systemctl is-active docker)" = 'active' ] && echo "OK docker daemon"
    if id -nG "$USER" | grep -qw "docker"; then
        echo "OK docker rootless"
    else
        echo "ERROR user '$USER' does not belong to 'docker' group"
        return 1
    fi
    unset DOCKER_TLS_VERIFY
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset MINIKUBE_ACTIVE_DOCKERD
fi

echo "- Building images ..."
docker build -f "build/Dockerfile-genericCollector" --tag=dia-exchangescraper-collector:0.1 .
docker build -f "build/Dockerfile-restServer" --tag=dia-http-restserver:0.1 .
docker build -f "build/Dockerfile-assetCollectionService" --tag=dia-service-assetcollectionservice:0.1 .
docker build -f "build/Dockerfile-blockchainservice" --tag=dia-service-blockchainservice:0.1 .
docker build -f "build/Dockerfile-filtersBlockService" --tag=dia-service-filtersblockservice:0.1 .
docker build -f "build/Dockerfile-pairDiscoveryService" --tag=dia-service-pairdiscoveryservice:0.1 .
docker build -f "build/Dockerfile-tradesBlockService" --tag=dia-service-tradesblockservice:0.1 .

echo "- Deleting minikube ..."
minikube delete --profile="$DIA_VM_PROFILE"

cluster_env_disable

# TODO: make sure we dont delete any other important user files
echo "- Removing minikube cache and configs ..."
rm -rf ~/.kube/cache
rm ~/.kube/config

echo "- Starting minikube cluster ..."
minikube start \
    --profile="${DIA_VM_PROFILE}" \
    --v="${MINIKUBE_VLVL}" \
    --driver="${MINIKUBE_DRIVER}" \
    --kubernetes-version="${MINIKUBE_KUBERNETES_VER}" \
    --cpus="${CLUSTER_HW_VCPU}" \
    --memory="${CLUSTER_HW_MEMORY}" \
    --disk-size="${CLUSTER_HW_DISK_SIZE}" \
    --alsologtostderr=false \
    --cni=bridge \
    --container-runtime="${MINIKUBE_CONTAINER_RUNTIME}" \
    --nodes="${MINIKUBE_NODES}" \
    --extra-config=apiserver.enable-swagger-ui=true \
    --force-systemd

echo "- Changing profile to ${DIA_VM_PROFILE} ..."
minikube profile "${DIA_VM_PROFILE}"

echo "- Enabling addons ..."
minikube -p $DIA_VM_PROFILE addons enable metrics-server

echo "- Installing dia-system chart ..."
kubectl create namespace "$DIA_NAMESPACE_NODE"
helm repo update
helm upgrade "$DIA_CHART_NAME" --namespace "$DIA_NAMESPACE" --create-namespace --install --set "exchangescrapers.namespaces={default,${DIA_NAMESPACE_NODE}}" "$DIA_CHART"

echo "- Loading images into cluster ..."
if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    docker save dia-exchangescraper-collector:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-http-restserver:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-assetcollectionservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-blockchainservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-filtersblockservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-pairdiscoveryservice:0.1 | (eval $(minikube docker-env) && docker load)
    docker save dia-service-tradesblockservice:0.1 | (eval $(minikube docker-env) && docker load)
fi

cluster_env_enable "${DIA_VM_PROFILE}"

exit $EXITCODE
