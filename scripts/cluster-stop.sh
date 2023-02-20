#!/usr/bin/env bash
set -e

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

DIADATA_VM_PROFILE="diadata-vmprofile"
DIADATA_CONFIG_CTX="diadata_config_ctx"
CLUSTER_HW_MEMORY=4096
CLUSTER_HW_VCPU=4
CLUSTER_HW_DISK_SIZE="30g"
MINIKUBE_VLVL=8
MINIKUBE_DRIVER="docker"
MINIKUBE_CONTAINER_RUNTIME="docker"
MINIKUBE_KUBERNETES_VER="v1.21.6"
MINIKUBE_NODES=1
echo "Switching kubectl config context to $DIADATA_VM_PROFILE ..."
kubectl config use-context "$DIADATA_VM_PROFILE"
# for i in "${arrayInstances[@]}"; do
#     __info "Removing static PVCs $i"
#     kubectl delete -f "gs/$i/data.yaml"
# done
# echo "Removing static persistent volumes ..."
# kubectl delete -f "data.yaml"
echo "Stopping minikube cluster ..."
minikube stop
echo "Deleting minikube ..."
minikube delete --profile="$DIADATA_VM_PROFILE"
__cluster_env_disable
echo "Cleaning Minikube mount proccess"
kill -9 "$(cat .pid-mount-data-sync)"
echo "Removing minikube config ..."
# for i in "${arrayInstances[@]}"; do
#     __info "Removing unused gameserver folders for $i game type ..."
#     rm -rf data/data-gs/dst/diadata-gs-*
# done
echo "Removing minikube config ..."
rm ~/.kube/config
echo "Cleaning minikube cache ..."
rm -rf ~/.kube/cache
