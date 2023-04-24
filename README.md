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