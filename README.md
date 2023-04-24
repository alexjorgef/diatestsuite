## Development

Requirements:

* bash
* docker

Prepare:

```shell
rm -rf diadata/
git clone git@github.com:diadata-org/diadata.git diadata
# Copy test files to cloned repo
cp -Rf test-v1/* diadata/
cd diadata/
```

Develop:

1. Run the install script: `./scripts/minikubeStart.sh`
2. Build the platform into cluster: `./scripts/minikubeBuild.sh`
3. Install the builded code: `./scripts/minikubeInstall.sh`
4. Run the scrapers: `./scripts/minikubeStartScrapers.sh`