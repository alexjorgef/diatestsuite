#!/usr/bin/env bash

export PGHOST= PGUSER=${PGUSER_TEMP} PGDB=${PGDB_TEMP} PGPASSWORD=${PGPASSWORD_TEMP}
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-blockchain.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-exchange.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-asset.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-pool.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-poolasset.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /mnt/env-context/scripts/load-exchangepair.sql

pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /mnt/env-workdir/pg_dump.backup