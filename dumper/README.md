# diatestsuite

## Development

Prepare files:

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-dumper`
3. Copy modified files: `cp -Rf dumper/* mounts/diadata-dumper/`

Start and install:

> Make sure you are in the injected `mounts/diadata-dumper/` directory

1. Start the local cluster: `./scripts/minikubeStart.sh`
2. Build the containers into cluster: `./scripts/minikubeBuild.sh`
3. Install the platform by running the scripts:
   1. Services and exchange scrapers: `./scripts/minikubeInstall.sh`
   2. Liquidity scrapers: `./scripts/minikubeInstallLiquidity.sh`
   3. Return to previous folder (root directory of project) and mount a shared volume for PostgreSQL to dump: `minikube mount --profile diadata-dumper "$(pwd)/mounts/postgres-dump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)
   4. Snapshot cronjob: `./scripts/minikubeInstallSnap.sh`

Stop and uninstall:

> Make sure you are in the injected `mounts/diadata-dumper/` directory

1. Uninstall the platform: `./scripts/minikubeUninstallSnap.sh`, `./scripts/minikubeUninstallLiquidity.sh`, `./scripts/minikubeUninstall.sh`
2. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

Clean and reset the env:

> Before cleaning the files, make sure all services are stopped

1. Prune all unused cluster resources: `minikube ssh --profile diadata-dumper -- docker system prune -af`
2. Delete the cluster node: `./scripts/minikubeDelete.sh`
3. Also, can remove the files: `rm -rf mounts/`
4. Prune all local docker resources: `docker system prune -af`