# diatestsuite

## Requirements

* bash
* docker

## Development

Prepare files:

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git`
2. Copy modified files: `cp -Rf test/* diadata/`

Start and install:

> Make sure you are in the injected `diadata/` directory

1. Start the local cluster: `./scripts/minikubeStart.sh`
2. Build the containers into cluster: `./scripts/minikubeBuild.sh`
3. Install the platform by running the script: `./scripts/minikubeInstall.sh`

Stop and uninstall:

> Make sure you are in the injected `diadata/` directory

1. Uninstall the platform: `./scripts/minikubeUninstall.sh`
2. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

Clean and reset the env:

> Before cleaning the files, make sure all services are stopped

1. Remove the files: `rm -rf diadata/`
2. Delete the cluster: `minikube delete --profile="diadata"`
3. Prune all unused cluster resources: `minikube ssh --profile diadata -- docker system prune -af`
4. Prune all local docker resources: `docker system prune -af`

## Testing Database Snapshots (WIP)

1. Dump DB data to a .sql file by:

```shell
kubectl exec -it deployment/postgres -- pg_dump --host localhost --port 5432 --username postgres --format plain --column-inserts --data-only --schema public --dbname postgres > ./test/deployments/config/pginitdata.sql
```

2. Change to diadata/ folder and run:

```shell
docker build -f "build/Dockerfile-postgres" -t "diadata.postgres:latest" .
docker container rm postgres-container-test
docker run -d --name postgres-container-test -p 5433:5432 diadata.postgres:latest
docker logs postgres-container-test -f
```

## WIP

> ref: https://devtron.ai/blog/creating-a-kubernetes-cron-job-to-backup-postgres-db/

or could restore by: `cat ./test/deployments/config/pginitdata.sql | kubectl exec -i deployment/postgres -- psql --username postgres --dbname postgres`


kubectl cp filter_data.sql postgres-74d779c47f-s7l8h:/filter_data.sql


pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f - $DB_NAME -t $TABLE_NAME --file filter_data.sql >> $OUTPUT_FILE

pg_dump -h localhost -p 5432 -U postgres -F c -b -v -f - postgres -t exchangepair --file filter_data.sql