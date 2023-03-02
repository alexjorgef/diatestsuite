#!/usr/bin/env bash
set -e

docker build -f "build/Dockerfile-genericCollector" --tag=dia-exchangescraper-collector:0.1 .
docker build -f "build/Dockerfile-restServer" --tag=dia-http-restserver:0.1 .
docker build -f "build/Dockerfile-assetCollectionService" --tag=dia-service-assetcollectionservice:0.1 .
docker build -f "build/Dockerfile-blockchainservice" --tag=dia-service-blockchainservice:0.1 .
docker build -f "build/Dockerfile-filtersBlockService" --tag=dia-service-filtersblockservice:0.1 .
docker build -f "build/Dockerfile-pairDiscoveryService" --tag=dia-service-pairdiscoveryservice:0.1 .
docker build -f "build/Dockerfile-tradesBlockService" --tag=dia-service-tradesblockservice:0.1 .
