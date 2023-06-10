#!/usr/bin/env bash

export PGHOST=${PGHOST_EXTRACT} PGUSER=${PGUSER_EXTRACT} PGDB=${PGDB_EXTRACT} PGPASSWORD=${PGPASSWORD_EXTRACT}; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-asset.sql --output /tmp/dump-asset.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-blockchain.sql --output /tmp/dump-blockchain.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-exchange_cex.sql --output /tmp/dump-exchange_cex.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-exchange_dex.sql --output /tmp/dump-exchange_dex.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-exchangepair.sql --output /tmp/dump-exchangepair.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-pool.sql --output /tmp/dump-pool.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-poolasset.sql --output /tmp/dump-poolasset.csv