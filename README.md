This repo cover the development of a new test-space environment with DIA's platform. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contains proposal documents.

- [Prepare files](#prepare-files)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Inspirations](#inspirations)

## Prepare files

1. Clone the DIA's repo or a fork to .testenv folder:

```sh
git clone git@github.com:diadata-org/diadata.git .testenv
```

2. Copy the prepared files:

```sh
cp -Rf inject/* .testenv/
```

1. Link the setup script:

```sh
ln -s "$PWD/setup" .testenv/setup
```

4. Change to .testenv directory, and test-space are ready to run;

```sh
cd .testenv
```

## Requirements

Minimum hardware recommended:

* Disk space available: 30 GB
* RAM available: 8 GB

The followding systems are covered:

* Architectures: x86_64
* OSs: Arch Linux v6.3.6-arch1-1

Software dependencies needed:

* *bash*, *git*, *yq*
* *minikube*, and *docker* as main driver

## Getting Started

Run the setup script:

`./setup <COMMAND>`

Where `<COMMAND>` could be:

* `minikube-start`: Start cluster
* `minikube-build`: Build images
* `minikube-install`/`minikube-uninstall`: Install/Uninstall DIA's platform
1. Modify files
   * `pkg/dia/scraper/exchange-scrapers/CustomScraper.go`
   * `pkg/dia/Config.go`
   * `pkg/dia/scraper/exchange-scrapers/APIScraper.go`
   * `config/Custom.json`
2. Modify the `build/Dockerfile-genericCollector` and the `build/Dockerfile-pairDiscoveryService` file and add these two Dockerfile lines before the RUN go mod tidy step:

```dockerfile
COPY . /diadata
RUN go mod edit -replace github.com/diadata-org/diadata=/diadata
```

7. Build the necessary service's containers:

```shell
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService .
minikube image build -t diadata.genericCollector:latest -f build/Dockerfile-genericCollector .
```

1. Add a new entry to exchange table database:

```shell
kubectl exec -it deployment/postgres -- psql -U postgres -c "INSERT INTO exchange (exchange_id, "name", centralized, bridge, contract, blockchain, rest_api, ws_api, pairs_api, watchdog_delay, scraper_active) VALUES(gen_random_uuid(), 'Custom', true, false, '', '', '', 'wss://ws-feed.pro.coinbase.com', 'https://api.pro.coinbase.com/products', 300, true);"
```

9. `minikube-create exchangescraper`: Create a new exchange scraper
10. `minikube-delete exchangescraper`: Delete a exchange scraper

11. Wait for the services to start and finally you can create/delete your scraper:

> Also, can test with a pre-configured scraper, defined at `tester/deployments/k8s-yaml/exchangescraper-<NAME>.yaml` file.

For creating:

```sh
kubectl create -f ./deployments/k8s-yaml/exchangescraper-custom.yaml
```

For deleting:

```sh
kubectl delete -f ./deployments/k8s-yaml/exchangescraper-custom.yaml
```

## Inspirations

* https://github.com/ljmf00/dotfiles
* https://github.com/googleforgames/agones
* https://github.com/smartcontractkit/chainlink-env

<!--
##################################################################################
##################################################################################
##################################################################################
-->

<!--
## Dumper

DIA version: `v1.4.241`

### Prepare files

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 .temp-dumper`
2. Copy modified files: `cp -Rf dumper/* .temp-dumper`

### Start the cluster

Start the local cluster by running the script:

```sh
(
  cd .temp-dumper && ./scripts/minikubeStart.sh
)
```

### Install the platform

1. Build the containers into cluster:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeBuild.sh
)
```

1. Services and exchange scrapers:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeInstallPreSnap.sh
)
```

3. Create a folder for PostgreSQL dump: `mkdir -p .mount-dumper-postgresdump`
4. Mount the folder of your host filesystem as a shared volume in the cluster: `minikube mount --profile diadata-dumper "$(pwd)/.mount-dumper-postgresdump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)

### Create a dumper

Creating a cronjob:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeInstallSnap.sh
)
```

Delete the cronjob:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeUninstallSnap.sh
)
```

### Uninstall the platform

Uninstall the platform:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeUninstallPreSnap.sh
)
```

### Cluster stop

You can safely stop the cluster:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeStop.sh
)
```

### Cluster delete

1. Delete the cluster node completly:

```sh
(
  cd ./.temp-dumper/
  ./scripts/minikubeDelete.sh
)
```

2. Also, the temporary files and mounts can be removed:

```sh
rm -rf ./.temp-dumper/
rm -rf ./.mount-dumper-postgresdump/
```
-->