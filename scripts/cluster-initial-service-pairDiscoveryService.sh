#!/usr/bin/env bash
# TODO: change this to a docker container
export USE_ENV=true
export INFLUXURL=http://localhost:8086
export INFLUXUSER=diadata_user
export INFLUXPASSWORD=diadata_pw
export POSTGRES_USER=d2Vic2l0ZV91c2Vy
export POSTGRES_PASSWORD=cGFzcw==
export POSTGRES_HOST=localhost
export POSTGRES_DB=diadata_psql_db
export REDISURL=localhost:6379
cd containers/diacmd-services-blockchainservice/diadata/cmd/services/pairDiscoveryService || exit
go mod tidy
go run main.go -exchange="$1" -mode="$2"