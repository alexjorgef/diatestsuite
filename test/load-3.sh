#!/usr/bin/env bash

export PGHOST= PGUSER=${PGUSER_TEMP} PGDB=${PGDB_TEMP} PGPASSWORD=${PGPASSWORD_TEMP}
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-blockchain.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-exchange.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-asset.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-pool.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-poolasset.sql

pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /data/pv0003/pgdump.sql