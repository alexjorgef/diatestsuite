#!/usr/bin/env sh
set -e

EXITCODE=0

_color() {
	codes=
	if [ "$1" = 'bold' ]; then
		codes='1'
		shift
	fi
	if [ "$#" -gt 0 ]; then
		code=
		case "$1" in
			# see https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
			black) code=30 ;;
			red) code=31 ;;
			green) code=32 ;;
			yellow) code=33 ;;
			blue) code=34 ;;
			magenta) code=35 ;;
			cyan) code=36 ;;
			white) code=37 ;;
		esac
		if [ "$code" ]; then
			codes="${codes:+$codes;}$code"
		fi
	fi
	printf '\033[%sm' "$codes"
}

_wrap_color() {
	text="$1"
	shift
	_color "$@"
	printf '%s' "$text"
	_color reset
	echo
}

_wrap_good() {
	echo "$(_wrap_color "$1" white): $(_wrap_color "$2" green)"
}

_wrap_bad() {
	echo "$(_wrap_color "$1" bold): $(_wrap_color "$2" bold red)"
}

# https://github.com/moby/moby/blob/master/contrib/check-config.sh
check_command() {
	if command -v "$1" > /dev/null 2>&1; then
		_wrap_good "$1 command" 'available'
	else
		_wrap_bad "$1 command" 'missing'
		EXITCODE=1
	fi
}

check_command kubectl
[ "$EXITCODE" = 0 ] && echo "OK kubectl"
check_command minikube
[ "$EXITCODE" = 0 ] && echo "OK minikube"

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
MINIKUBE_KUBERNETES_VER="v1.26.1"
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
    unset DOCKER_TLS_VERIFY;
    unset DOCKER_HOST;
    unset DOCKER_CERT_PATH;
    unset MINIKUBE_ACTIVE_DOCKERD;
    docker build -f "build/Dockerfile-genericCollector" --tag=dia-exchangescraper-collector:0.1 .
    docker build -f "build/Dockerfile-restServer" --tag=dia-http-restserver:0.1 .
    docker build -f "build/Dockerfile-assetCollectionService" --tag=dia-service-assetcollectionservice:0.1 .
    docker build -f "build/Dockerfile-blockchainservice" --tag=dia-service-blockchainservice:0.1 .
    docker build -f "build/Dockerfile-filtersBlockService" --tag=dia-service-filtersblockservice:0.1 .
    docker build -f "build/Dockerfile-pairDiscoveryService" --tag=dia-service-pairdiscoveryservice:0.1 .
    docker build -f "build/Dockerfile-tradesBlockService" --tag=dia-service-tradesblockservice:0.1 .
fi

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

# Check if the context exists in the Kubernetes cluster
if kubectl config get-contexts | grep -q "^$DIA_VM_PROFILE"; then
    echo "Switching kubectl config context to $DIA_VM_PROFILE ..."
    kubectl config use-context "$DIA_VM_PROFILE"
fi

# Check if the selected profile exists in Minikube
if minikube profile list | grep -q "^$DIA_VM_PROFILE"; then
    echo "Stopping minikube cluster ..."
    minikube stop
fi

echo "Deleting minikube ..."
minikube delete --profile="$DIA_VM_PROFILE"
cluster_env_disable
echo "Cleaning Minikube mount proccess"
if [ -f .minikube-pid-mount-data-sync ]
then
    pid=$(cat .minikube-pid-mount-data-sync)
    if ps -p $pid > /dev/null
    then
        echo "Process with ID $pid is running. Killing with -9 option..."
        kill -9 $pid
    else
        echo "Process with ID $pid is not running."
    fi
else
    echo "File .minikube-pid-mount-data-sync does not exist."
fi

echo "Removing minikube cache and configs ..."
rm -rf ~/.kube/cache
rm ~/.kube/config

cluster_env_disable
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
# kubectl get namespaces --output=name | grep "$DIA_NAMESPACE" >/dev/null
# if [ $? -eq 0 ]; then
#     echo "DIA resources are installed"
# else
#     echo "DIA resources are not present, installing ..."
#     helm repo update
#     kubectl create namespace "${DIA_NAMESPACE}"
# fi

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

echo "Mounting shared data to minikube ..."
nohup minikube mount "$(pwd)/data/shared:/mnt/shared:ro" --uid 1001 --gid 1001 --9p-version=9p2000.L >/dev/null 2>&1 &
echo $! >.minikube-pid-mount-data-sync
minikube ssh "sudo mkdir -p /mnt/volumes/scraper"
minikube ssh "sudo chown -R 1001:1001 /mnt/volumes/scraper"
minikube -p $DIA_VM_PROFILE addons enable metrics-server

exit $EXITCODE