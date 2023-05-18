# diatestsuite

## Development

Prepare files:

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-tester`
3. Copy modified files: `cp -Rf tester/* mounts/diadata-tester/`

Start and install:

1. Make sure you are in the injected *mounts/diadata-tester/* directory: `cd mounts/diadata-tester/`
2. Start the local cluster: `./scripts/minikubeStart.sh`
3. Build the containers into cluster: `./scripts/minikubeBuild.sh`
4. Install the platform by running the script: `./scripts/minikubeInstall.sh`, `./scripts/minikubeInstallScrapers.sh`

Uninstall and Stop:

1. Make sure you are in the injected *mounts/diadata-tester/* directory: `cd mounts/diadata-tester/`
2. Uninstall the platform: `./scripts/minikubeUninstallScrapers.sh`, `./scripts/minikubeUninstall.sh`
3. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

Clean and reset the env:

1. Delete the cluster node: `./scripts/minikubeDelete.sh`
2. Also, can remove the files: `rm -rf mounts/`
3. Prune all local docker resources: `docker system prune -af`