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

## Development

This section will cover the development instructions for the following products:

* [Tester](#tester): Create a new test space environment with DIA's platform (runs on a local machine).
* [Dumper](#dumper): Dumper will extract a snapshot of relational data, and upload it to registry (runs on a production cluster machine).

### Tester

#### Prepare files

> Note: Make sure you are at the root directory of this repo!

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 diadata`
2. Copy modified files: `cp -Rf tester/* diadata/`

#### Start the cluster

Start the local cluster with `minikube start` command

#### Install the platform

1. Build the containers into cluster:

```shell
minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild diadata
minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 diadata
minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService diadata
minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService diadata
```

2. Install the platform by running the script:

```shell
kubectl create -f tester/deployments/k8s-yaml/influx.yaml
kubectl create -f tester/deployments/k8s-yaml/redis.yaml
kubectl create -f tester/deployments/k8s-yaml/postgres.yaml
kubectl create -f tester/deployments/k8s-yaml/kafka.yaml
kubectl create -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl create -f tester/deployments/k8s-yaml/filtersblockservice.yaml
```

#### Develop on the platform

##### Modify an existing scraper

WIP...

##### Add a new scraper

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
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService diadata
minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector diadata
```

4. Add a new entry to exchange table database:

```shell
kubectl exec -it deployment/postgres -- psql -U postgres -c "INSERT INTO exchange (exchange_id, "name", centralized, bridge, contract, blockchain, rest_api, ws_api, pairs_api, watchdog_delay, scraper_active) VALUES(gen_random_uuid(), 'Custom', true, false, '', '', '', 'wss://ws-feed.pro.coinbase.com', 'https://api.pro.coinbase.com/products', 300, true);"
```

5. Wait for the services to start and finally you can create/delete your scraper:

> Also, can test with a pre-configured scraper, defined at `tester/deployments/k8s-yaml/exchangescraper-<NAME>.yaml` file.

For creating:

```shell
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml
```

For deleting:

```shell
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml
```

#### Uninstall the platform

Uninstall the DIA services:

```shell
kubectl delete -f tester/deployments/k8s-yaml/filtersblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/kafka.yaml
kubectl delete -f tester/deployments/k8s-yaml/postgres.yaml
kubectl delete -f tester/deployments/k8s-yaml/redis.yaml
kubectl delete -f tester/deployments/k8s-yaml/influx.yaml
```

#### Cluster stop

You can stop the cluster with `minikube stop` command

#### Cluster clean

Delete the cluster node with `minikube delete` command

### Dumper

#### Prepare files

> Note: Make sure you are at the root directory of this repo!

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-dumper`
3. Copy modified files: `cp -Rf dumper/* mounts/diadata-dumper/`

#### Start the cluster

> Note: Now, make sure you are in the injected *mounts/diadata-dumper/* directory: `cd mounts/diadata-dumper/`!

Start the local cluster by running the script: `./scripts/minikubeStart.sh`

#### Install the platform

1. Build the containers into cluster: `./scripts/minikubeBuild.sh`
2. Services and exchange scrapers: `./scripts/minikubeInstallPreSnap.sh`
3. Make sure you return to previous folder, the root directory of the project: `cd ../..`
4.  Create the shared folder for postgres: `mkdir -p mounts/postgres-dump`
5. Mount a shared volume for PostgreSQL to dump: `minikube mount --profile diadata-dumper "$(pwd)/mounts/postgres-dump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)
6. Back again to *mounts/diadata-dumper/* directory: `cd mounts/diadata-dumper/`

#### Install the cronjob

1. Snapshot cronjob: `./scripts/minikubeInstallSnap.sh`

#### Uninstall the platform

1. Make sure you are in the injected `mounts/diadata-dumper/` directory
2. Uninstall the platform: `./scripts/minikubeUninstallSnap.sh`, `./scripts/minikubeUninstallPreSnap.sh`
3. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

#### Cluster stop

1. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

#### Cluster clean

1. Delete the cluster node: `./scripts/minikubeDelete.sh`
2. Also, can remove the files: `rm -rf mounts/`
