#!/usr/bin/env sh
set -e

# Installing dia-system chart
kubectl create namespace "dia-system-node"
helm repo update
helm upgrade "dia-release" --namespace "dia-system" --create-namespace --install --set "exchangescrapers.namespaces={default,dia-system-node}" "./deployments/helm/dia"

# Installing Loki with Helm
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace logging
helm upgrade --install loki --namespace=logging grafana/loki-stack

# Installing Prometheus operator chart
minikube addons disable metrics-server
kubectl apply --server-side -f manifests/setup
kubectl wait \
    --for condition=Established \
    --all CustomResourceDefinition \
    --namespace=monitoring
kubectl apply -f manifests/

# Installing influxdb
kubectl apply -f https://raw.githubusercontent.com/influxdata/docs-v2/master/static/downloads/influxdb-k8-minikube.yaml

# Installing Cert Manager
# Installing Cert Manager CRDs with kubectl
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.crds.yaml
# Installing Cert Manager with Helm
helm repo add jetstack https://charts.jetstack.io
helm repo update
kubectl create namespace cert-manager
helm upgrade \
    --namespace cert-manager \
    --version 1.11.0 \
    --install cert-manager jetstack/cert-manager

# Creating Self-Signed Cert Issuer
kubectl apply -f https://gist.githubusercontent.com/t83714/51440e2ed212991655959f45d8d037cc/raw/7b16949f95e2dd61e522e247749d77bc697fd63c/selfsigned-issuer.yaml

# Installing Jaeger Operator chart in observability namespace
kubectl create namespace observability
kubectl create -f https://github.com/jaegertracing/jaeger-operator/releases/download/v1.43.0/jaeger-operator.yaml -n observability