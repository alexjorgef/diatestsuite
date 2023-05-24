#!/usr/bin/env bash
set -e

minikube_profile="diadata-tester"
image_tag="diadata"

eval "$(minikube -p $minikube_profile docker-env)"

. ./baseimage.sh --notpush

docker build -f "build/Dockerfile-filtersBlockService" -t "${image_tag}.filtersblockservice:latest" .
docker build -f "build/Dockerfile-genericCollector" -t "${image_tag}.exchangescrapercollector:latest" .
docker build -f "build/Dockerfile-liquidityScraper" -t "${image_tag}.liquidityscraper:latest" .
docker build -f "build/Dockerfile-pairDiscoveryService" -t "${image_tag}.pairdiscoveryservice:latest" .
docker build -f "build/Dockerfile-tradesBlockService" -t "${image_tag}.tradesblockservice:latest" .

eval "$(minikube -p $minikube_profile docker-env --unset)"

#minikube image build -t diadata.build -f build/build/Dockerfile-DiadataBuild .
#minikube image build -t diadata.build-117 -f build/build/Dockerfile-DiadataBuild-117 .
# not needed
#minikube image build -t diadata.build-119 -f build/build/Dockerfile-DiadataBuild-119 .

#minikube image tag diadata.build:latest us.icr.io/dia-registry/devops/build:latest
#minikube image tag diadata.build-117:latest us.icr.io/dia-registry/devops/build-117:latest
# not needed
#minikube image tag diadata.build-119:latest us.icr.io/dia-registry/devops/build-119:latest

#minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService .
#minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService .
# needed to scrapers
#minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService .
#minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector-dev .