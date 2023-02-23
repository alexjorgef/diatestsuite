#!/usr/bin/env bash
echo "Cleaning and stopping cluster forwards..."

kill -9 "$(cat .pid-forward-db-postgres)"
kill -9 "$(cat .pid-forward-db-redis)"
kill -9 "$(cat .pid-forward-db-influx)"
