# diatestsuite

## Requirements

* bash
* docker

## Development

Prepare files:

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git`
2. Copy modified files: `cp -Rf test-current/* diadata/`

Develop:

1. Change folder to DIA temp repo: `cd diadata/`
2. Run the install script: `./scripts/minikubeStart.sh`
3. Build the platform into cluster: `./scripts/minikubeBuild.sh`
4. Install the builded code: `./scripts/minikubeInstall.sh`
5. Run the scrapers: `./scripts/minikubeStartScrapers.sh`

Clean and reset the env:

1. Remove the files: `rm -rf diadata/`
2. Delete the cluster: `minikube delete --profile="diadata"`
3. Prune all unused docker resources: `docker system prune -af`

## Testing Database Snapshots (WIP)

1. Dump DB data to a .sql file by:

```shell
kubectl exec -it deployment/postgres -- pg_dump --host localhost --port 5432 --username postgres --format plain --column-inserts --data-only --schema public --dbname postgres > pginitdata.sql > ./test-current/deployments/config/pginitdata.sql
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

or could restore by: `cat ./test-current/deployments/config/pginitdata.sql | kubectl exec -i deployment/postgres -- psql --username postgres --dbname postgres`