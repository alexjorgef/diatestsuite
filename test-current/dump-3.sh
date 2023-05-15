#!/usr/bin/env bash

psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-asset.sql --output /postgres-dump/dump-3-asset.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-blockchain.sql --output /postgres-dump/dump-3-blockchain.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchange_cex.sql --output /postgres-dump/dump-3-exchange_cex.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchange_dex.sql --output /postgres-dump/dump-3-exchange_dex.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-exchangepair.sql --output /postgres-dump/dump-3-exchangepair.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-pool.sql --output /postgres-dump/dump-3-pool.csv
psql --host ${PGHOST} --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-query-poolasset.sql --output /postgres-dump/dump-3-poolasset.csv