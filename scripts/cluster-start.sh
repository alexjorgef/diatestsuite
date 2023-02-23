#!/usr/bin/env bash
set -e

# Databases and datastores
kubectl create -f "pods/db-influx.yaml"
kubectl create -f "pods/db-redis.yaml"
kubectl create -f "pods/db-postgres.yaml"
# kubectl create -f "pods/db-kafka.yaml"

sleep 20

# TODO: only forward when pod is ready
(
    echo "Starting cluster forwards..."
    kubectl port-forward diadata-clusterdev-db-postgres 5432:5432 &
    echo $! >.pid-forward-db-postgres
    kubectl port-forward diadata-clusterdev-db-redis 6379:6379 &
    echo $! >.pid-forward-db-redis
    kubectl port-forward diadata-clusterdev-db-influx 8086:8086 &
    echo $! >.pid-forward-db-influx
)

sleep 2

(
    echo "Initializing databases..."
    ./scripts/cluster-initial-service-blockchainservice.sh
)

sleep 1

kill -9 "$(cat .pid-forward-db-postgres)"
kill -9 "$(cat .pid-forward-db-redis)"
kill -9 "$(cat .pid-forward-db-influx)"

# Services
#kubectl create -f "pods/service-tradesblockservice.yaml"
#kubectl create -f "pods/service-filtersblockservice.yaml"