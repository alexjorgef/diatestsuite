#!/usr/bin/env bash

export PGHOST= PGUSER=${PGUSER_TEMP} PGDB=${PGDB_TEMP} PGPASSWORD=${PGPASSWORD_TEMP}
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-blockchain.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-exchange.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-asset.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-pool.sql
psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-poolasset.sql
pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /tmp/pgdump.sql
echo TRY
pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /data/pv0001/pgdump.sql
pg_dump -p 5432 -U $PGUSER --format c --blobs --verbose --dbname $PGDB --schema public --file /data/pv0003/pgdump.sql
# id -u
# id -g
# id -u postgres
# id -g postgres
# ls -la /tmp/pgdump.sql
# ls -la /data/pv0001/pgdump.sql
# ls -la /data/pv0002
# ls -la /data/pv0003

# psql --port 5432 --username ${PGUSER} --dbname ${PGDB} --file /postgres-dump/dump-3-load-exchangepair.sql; \
# cat /var/lib/postgresql/data/postmaster.pid
# pg_ctl stop -D /var/lib/postgresql/data -m smart
# pg_ctl --help
# pg_ctl stop -D /var/lib/postgresql/data -m smart
# pg_ctl kill TERM 1

# pg_ctl stop -m immediate -W -s

# pg_ctl stop -D /var/lib/postgresql/data -W -s
# pg_ctl -D "$PGDATA" stop
# /usr/local/bin/pg_ctl stop -D /var/lib/postgresql/data -w -t 60 -m fast
# kill -INT `head -1 /var/lib/postgresql/data/postmaster.pid`

# su postgres -c "pg_ctl -D /var/lib/postgresql/data -l logfile stop"
# pg_ctl status
# ls -la /var/lib/postgresql/data/postmaster.pid
# cat /var/lib/postgresql/data/postmaster.pid
# pg_ctl -D /var/lib/postgresql/data -w -t 1000 stop
head -1 /var/lib/postgresql/data/postmaster.pid
# kill -TERM `head -1 /var/lib/postgresql/data/postmaster.pid`
# pg_ctl -D "$PGDATA" -m immediate -w stop
echo $?
kill -TERM "$(head -1 /var/lib/postgresql/data/postmaster.pid)"
# ls -la /var/lib/postgresql/data/postmaster.pid
# cat /var/lib/postgresql/data/postmaster.pid
# echo $?
# pg_ctl status
# exit 0
# ls -la /var/lib/postgresql/data/postmaster.pid