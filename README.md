## Development

Requirements:

* bash
* docker

Develop:

1. Run the install script: `./scripts/minikubeStart.sh`
2. Build the platform into cluster: `./scripts/minikubeBuild.sh`
3. Install the builded code: `./scripts/minikubeInstall.sh`
4. Run the scrapers: `./scripts/minikubeStartScrapers.sh`