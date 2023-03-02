#!/usr/bin/env bash
# set -e

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

if command -v kubectl >/dev/null 2>&1; then
    echo "OK kubectl"
else
    echo "ERROR make sure you have kubectl installed"
    return 1
fi
if command -v docker >/dev/null 2>&1; then
    echo "OK docker"
    if id -nG "$USER" | grep -qw "docker"; then
        echo "OK docker rootless"
    else
        echo "ERROR user '$USER' does not belong to 'docker' group"
        return 1
    fi
    if (! pgrep -f docker >/dev/null); then
        echo "WARN docker daemon is not running, do you like to start it? (Y/N)"
        read answer
        if [[ $answer == 'Y' || $answer == 'y' ]]; then
            sudo systemctl start docker.service
            if [ $? -eq 0 ]; then
                echo "OK docker daemon is $(systemctl is-active docker)"
            else
                echo "ERROR docker daemon is not running"
                return 1
            fi
        else
            echo "ERROR docker daemon is not running"
            return 1
        fi
    else
        echo "OK docker daemon is $(systemctl is-active docker)"
    fi
else
    echo "ERROR make sure you have docker installed"
    return 1
fi
if command -v minikube >/dev/null 2>&1; then
    echo "OK minikube"
else
    echo "ERROR make sure you have minikube installed"
    exit 1
fi

DIA_VM_PROFILE="diadata-vmprofile"
DIA_CONFIG_CTX="diadata_config_ctx"
DIA_NAMESPACE="diadata"
DIA_CHART="diadata-release"
DIA_NAMESPACE="diadata-namespace"
CLUSTER_HW_MEMORY=4096
CLUSTER_HW_VCPU=4
CLUSTER_HW_DISK_SIZE="30g"
MINIKUBE_VLVL=8
MINIKUBE_DRIVER="docker"
MINIKUBE_CONTAINER_RUNTIME="docker"
MINIKUBE_KUBERNETES_VER="v1.21.6"
MINIKUBE_NODES=1
__cluster_env_disable
echo "Setting a new kubectl config context ..."
kubectl config set-context "$DIA_CONFIG_CTX"
echo "Switching to DIA config context ..."
kubectl config use-context "$DIA_CONFIG_CTX"
minikube config set memory $CLUSTER_HW_MEMORY
echo "Starting minikube cluster ..."
minikube start \
    --profile="${DIA_VM_PROFILE}" \
    --v="${MINIKUBE_VLVL}" \
    --log_file="$(pwd)/minikube.log" \
    --driver="${MINIKUBE_DRIVER}" \
    --kubernetes-version="${MINIKUBE_KUBERNETES_VER}" \
    --cpus="${CLUSTER_HW_VCPU}" \
    --memory="${CLUSTER_HW_MEMORY}" \
    --disk-size="${CLUSTER_HW_DISK_SIZE}" \
    --alsologtostderr=false \
    --container-runtime="${MINIKUBE_CONTAINER_RUNTIME}" \
    --nodes="${MINIKUBE_NODES}" \
    --mount-string="$(pwd)/data/volumes:/mnt/volumes:rw" \
    --mount=true \
    --extra-config=apiserver.enable-swagger-ui=true \
    --feature-gates="LocalStorageCapacityIsolation=false"
minikube profile "${DIA_VM_PROFILE}"
if [ "$MINIKUBE_DRIVER" = "docker" ]; then
    __cluster_env_enable "${DIA_VM_PROFILE}"
fi
kubectl get namespaces --output=name | grep "$DIA_NAMESPACE" >/dev/null
if [ $? -eq 0 ]; then
    echo "DIA resources are installed"
else
    echo "DIA resources are not present, installing ..."
    helm repo update
    kubectl create namespace "${DIA_NAMESPACE}"
fi
echo "Mounting shared data to minikube ..."
nohup minikube mount "$(pwd)/data/shared:/mnt/shared:ro" --uid 1001 --gid 1001 --9p-version=9p2000.L >/dev/null 2>&1 &
echo $! >.minikube-pid-mount-data-sync
# sleep 5
# echo "Starting static persistent volumes ..."
# kubectl create -f "data.yaml"
sleep 2
minikube ssh "sudo mkdir -p /mnt/volumes/scraper"
minikube ssh "sudo chown -R 1001:1001 /mnt/volumes/scraper"
minikube -p $DIA_VM_PROFILE addons enable metrics-server