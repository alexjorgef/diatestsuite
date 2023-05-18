#!/usr/bin/env bash

export PGHOST= PGUSER=${PGUSER_TEMP} PGDB=${PGDB_TEMP} PGPASSWORD=${PGPASSWORD_TEMP}
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/load-blockchain.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/load-exchange.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/load-asset.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/load-pool.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/load-poolasset.sql
# TODO: exchangepair is missing...

pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /data/shared-postgres/pg_dump.backup