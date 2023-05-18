# diatestsuite

## Development

Prepare files:

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-dumper`
3. Copy modified files: `cp -Rf dumper/* mounts/diadata-dumper/`

Start and install:

1. Make sure you are in the injected `mounts/diadata-dumper/` directory
2. Start the local cluster: `./scripts/minikubeStart.sh`
3. Build the containers into cluster: `./scripts/minikubeBuild.sh`
4. Services and exchange scrapers: `./scripts/minikubeInstallPreSnap.sh`
5. Make sure you return to previous folder, the root directory of the project
6. Create the shared folder for postgres: `mkdir -p mounts/postgres-dump`
7. Mount a shared volume for PostgreSQL to dump: `minikube mount --profile diadata-dumper "$(pwd)/mounts/postgres-dump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)
8. Back again to `mounts/diadata-dumper/` directory
9. Snapshot cronjob: `./scripts/minikubeInstallSnap.sh`

Stop and uninstall:

1. Make sure you are in the injected `mounts/diadata-dumper/` directory
2. Uninstall the platform: `./scripts/minikubeUninstallSnap.sh`, `./scripts/minikubeUninstallPreSnap.sh`
3. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

Clean and reset the env:

1. Before cleaning the files, make sure all services are stopped
2. Delete the cluster node: `./scripts/minikubeDelete.sh`
3. Also, can remove the files: `rm -rf mounts/`
4. Prune all local docker resources: `docker system prune -af`