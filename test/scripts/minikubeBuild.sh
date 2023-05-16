#!/usr/bin/env bash
set -e

minikube_profile="diadata"
image_tag="diadata"

eval "$(minikube -p $minikube_profile docker-env)"

. ./baseimage.sh --notpush

docker build -f "build/Dockerfile-assetCollectionService" -t "${image_tag}.assetcollectionservice:latest" .
docker build -f "build/Dockerfile-blockchainservice" -t "${image_tag}.blockchainservice:latest" .
docker build -f "build/Dockerfile-filtersBlockService" -t "${image_tag}.filtersblockservice:latest" .
docker build -f "build/Dockerfile-genericCollector" -t "${image_tag}.exchangescrapercollector:latest" .
docker build -f "build/Dockerfile-liquidityScraper" -t "${image_tag}.liquidityscraper:latest" .
docker build -f "build/Dockerfile-pairDiscoveryService" -t "${image_tag}.pairdiscoveryservice:latest" .
docker build -f "build/Dockerfile-postgres" -t "${image_tag}.postgres:latest" .
docker build -f "build/Dockerfile-tradesBlockService" -t "${image_tag}.tradesblockservice:latest" .

eval "$(minikube -p $minikube_profile docker-env --unset)"