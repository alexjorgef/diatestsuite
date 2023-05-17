# diatestsuite

## Development

Prepare files:

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-tester`
3. Copy modified files: `cp -Rf tester/* mounts/diadata-tester/`

Start and install:

> Make sure you are in the injected `mounts/diadata-tester/` directory

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