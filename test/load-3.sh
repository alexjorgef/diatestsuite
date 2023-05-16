#!/usr/bin/env bash

psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-blockchain.sql
psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-exchange.sql
psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-asset.sql
psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-exchangepair.sql
psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-poolasset.sql
psql --host ${PGHOST_TEMP} --port 5432 --username ${PGUSER_TEMP} --dbname ${PGDB_TEMP} --file /postgres-dump/dump-3-load-pool.sql

tail -f /dev/null