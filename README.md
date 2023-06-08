This is a suite of scripts/tools for facilitating the test proccess of DIA platform.

[Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contains proposal documents for future versions of official documentation ([docs.diadata.org](https://docs.diadata.org)), with detailed instructions for users.

- [Requirements](#requirements)
- [Development](#development)
  - [Tester](#tester)
    - [Prepare files](#prepare-files)
    - [Start the cluster](#start-the-cluster)
    - [Install the platform](#install-the-platform)
    - [Develop on the platform](#develop-on-the-platform)
      - [Modify an existing scraper](#modify-an-existing-scraper)
      - [Add a new scraper](#add-a-new-scraper)
    - [Uninstall the platform](#uninstall-the-platform)
    - [Cluster stop](#cluster-stop)
    - [Cluster clean](#cluster-clean)
  - [Dumper](#dumper)
    - [Prepare files](#prepare-files-1)
    - [Start the cluster](#start-the-cluster-1)
    - [Install the platform](#install-the-platform-1)
    - [Install the cronjob](#install-the-cronjob)
    - [Uninstall the platform](#uninstall-the-platform-1)
    - [Cluster stop](#cluster-stop-1)
    - [Cluster clean](#cluster-clean-1)

---

## Requirements

* bash
* minikube
* docker

---

## Development Guide

This section will cover the development instructions for the following products:

* [Tester](#tester): Create a new test space environment with DIA's platform (runs on a local machine).
* [Dumper](#dumper): Dumper will extract a snapshot of relational data, and upload it to registry (runs on a production cluster machine).

### Tester

#### Prepare files

> Note: Make sure you are at the root directory of this repo!

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 .temp-tester`
2. Copy modified files: `cp -Rf tester/* .temp-tester/`

#### Start the cluster

Start the local cluster with `minikube start` command

#### Install the platform

1. Build the containers into cluster:

```shell
(
    cd ./.temp-tester/
    minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild .
    minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 .
    minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService .
    minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService .
)
```

2. Install the platform by running the script:

```shell
(
    cd ./.temp-tester/
    kubectl create -f ./deployments/k8s-yaml/influx.yaml
    kubectl create -f ./deployments/k8s-yaml/redis.yaml
    kubectl create -f ./deployments/k8s-yaml/postgres.yaml
    kubectl create -f ./deployments/k8s-yaml/kafka.yaml
    kubectl create -f ./deployments/k8s-yaml/tradesblockservice.yaml
    kubectl create -f ./deployments/k8s-yaml/filtersblockservice.yaml
)
```

#### Develop on the platform

##### Test an existing scraper

WIP...

##### Test a new scraper

1. Add the custom scraper files:

* `pkg/dia/scraper/exchange-scrapers/CustomScraper.go`
* `pkg/dia/Config.go`
* `pkg/dia/scraper/exchange-scrapers/APIScraper.go`
* `config/Custom.json`

2. Modify the `build/Dockerfile-genericCollector` and the `build/Dockerfile-pairDiscoveryService` file and add these two Dockerfile lines before the RUN go mod tidy step:

```dockerfile
COPY . /diadata
RUN go mod edit -replace github.com/diadata-org/diadata=/diadata
```

3. Build the necessary service's containers:

```shell
(
    cd ./.temp-tester/
    minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService .
    minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector .
)
```

4. Add a new entry to exchange table database:

```shell
kubectl exec -it deployment/postgres -- psql -U postgres -c "INSERT INTO exchange (exchange_id, "name", centralized, bridge, contract, blockchain, rest_api, ws_api, pairs_api, watchdog_delay, scraper_active) VALUES(gen_random_uuid(), 'Custom', true, false, '', '', '', 'wss://ws-feed.pro.coinbase.com', 'https://api.pro.coinbase.com/products', 300, true);"
```

5. Wait for the services to start and finally you can create/delete your scraper:

> Also, can test with a pre-configured scraper, defined at `tester/deployments/k8s-yaml/exchangescraper-<NAME>.yaml` file.

For creating:

```shell
(cd ./.temp-tester/; kubectl create -f ./deployments/k8s-yaml/exchangescraper-custom.yaml)
```

For deleting:

```shell
(cd ./.temp-tester/; kubectl delete -f ./deployments/k8s-yaml/exchangescraper-custom.yaml)
```

#### Uninstall the platform

Uninstall the DIA services:

```shell
(
    cd ./.temp-tester/
    kubectl delete -f ./deployments/k8s-yaml/filtersblockservice.yaml
    kubectl delete -f ./deployments/k8s-yaml/tradesblockservice.yaml
    kubectl delete -f ./deployments/k8s-yaml/kafka.yaml
    kubectl delete -f ./deployments/k8s-yaml/postgres.yaml
    kubectl delete -f ./deployments/k8s-yaml/redis.yaml
    kubectl delete -f ./deployments/k8s-yaml/influx.yaml
)
```

#### Cluster stop

You can stop the cluster with `minikube stop` command

#### Cluster delete

1. Delete the cluster node completly with `minikube delete` command
2. Also, can remove the temporary files of mount:

```sh
rm -rf ./.temp-tester/
```

### Dumper

#### Prepare files

2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 .temp-dumper`
3. Copy modified files: `cp -Rf dumper/* ./.temp-dumper/`

#### Start the cluster

Start the local cluster by running the script: `(cd ./.temp-dumper/; ./scripts/minikubeStart.sh )`

#### Install the platform

1. Build the containers into cluster: `(cd ./.temp-dumper/; ./scripts/minikubeBuild.sh )`
2. Services and exchange scrapers: `(cd ./.temp-dumper/; ./scripts/minikubeInstallPreSnap.sh)`
3. Create a folder for PostgreSQL dump: `mkdir -p .mount-dumper-postgresdump`
4. Mount the folder of your host filesystem as a shared volume in the cluster: `minikube mount --profile diadata-dumper "$(pwd)/.mount-dumper-postgresdump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)

#### Test the cronjob

Create a snapshot's cronjob:

```shell
./.temp-dumper/scripts/minikubeInstallSnap.sh
```

Deleting a snapshot's cronjob:

```shell
./.temp-dumper/scripts/minikubeUninstallSnap.sh
```

#### Uninstall the platform

Uninstall the platform: `(cd ./.temp-dumper/; ./scripts/minikubeUninstallPreSnap.sh )`

#### Cluster stop

Now you can safely stop the cluster: `(cd ./.temp-dumper/; ./scripts/minikubeStop.sh )`

#### Cluster delete

1. Delete the cluster node completly: `(cd ./.temp-dumper/; ./scripts/minikubeDelete.sh )`
2. Also, can remove the temporary files of mount:

```sh
rm -rf ./.mount-dumper-postgresdump/
rm -rf ./.temp-dumper/
```
