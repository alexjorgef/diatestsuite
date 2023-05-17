#!/usr/bin/env bash

export PGHOST=${PGHOST_EXTRACT} PGUSER=${PGUSER_EXTRACT} PGDB=${PGDB_EXTRACT} PGPASSWORD=${PGPASSWORD_EXTRACT}; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-asset.sql --output /tmp/dump-3-asset.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-blockchain.sql --output /tmp/dump-3-blockchain.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchange_cex.sql --output /tmp/dump-3-exchange_cex.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchange_dex.sql --output /tmp/dump-3-exchange_dex.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchangepair.sql --output /tmp/dump-3-exchangepair.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-pool.sql --output /tmp/dump-3-pool.csv; \
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-poolasset.sql --output /tmp/dump-3-poolasset.csv