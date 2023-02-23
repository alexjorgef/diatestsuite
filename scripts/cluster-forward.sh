#!/usr/bin/env bash
echo "Starting cluster forwards..."

nohup kubectl port-forward diadata-clusterdev-db-postgres 5432:5432 >/dev/null 2>&1 &
echo $! >.pid-forward-db-postgres

nohup kubectl port-forward diadata-clusterdev-db-redis 6379:6379 >/dev/null 2>&1 &
echo $! >.pid-forward-db-redis

nohup kubectl port-forward diadata-clusterdev-db-influx 8086:8086 >/dev/null 2>&1 &
echo $! >.pid-forward-db-influx
