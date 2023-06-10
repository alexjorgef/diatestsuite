This repo cover the development of:

* **Tester** - Create a new test-space environment with DIA's platform (used for contributing/mantaining)

* **Dumper** - Extract a snapshot of data, and distribute (runs on production machine)

> [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contains proposal documents.

---

Minimum hardware recommended:

* Disk space available: 30 GB
* RAM available: 8 GB

The followding systems are covered:

* Architectures: x86_64
* OSs: Arch Linux v6.3.6-arch1-1

Software dependencies needed:

* *bash*
* *minikube*, and *docker* as main driver

---

- [Tester](#tester)
  - [Prepare files](#prepare-files)
  - [Start the cluster](#start-the-cluster)
  - [Install the platform](#install-the-platform)
  - [Develop on the platform](#develop-on-the-platform)
    - [Test a new scraper](#test-a-new-scraper)
    - [Test an existing scraper](#test-an-existing-scraper)
  - [Uninstall the platform](#uninstall-the-platform)
  - [Cluster stop](#cluster-stop)
  - [Cluster delete](#cluster-delete)
- [Dumper](#dumper)
  - [Prepare files](#prepare-files-1)
  - [Start the cluster](#start-the-cluster-1)
  - [Install the platform](#install-the-platform-1)
  - [Create a dumper](#create-a-dumper)
  - [Uninstall the platform](#uninstall-the-platform-1)
  - [Cluster stop](#cluster-stop-1)
  - [Cluster delete](#cluster-delete-1)

---

## Tester

### Prepare files

1. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 .temp-tester`
2. Copy modified files: `cp -Rf tester/* .temp-tester/`

### Start the cluster

Start the local cluster with `minikube start` command

### Install the platform

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

### Develop on the platform

#### Test a new scraper

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

```sh
(
  cd ./.temp-tester/
  kubectl create -f ./deployments/k8s-yaml/exchangescraper-custom.yaml
)
```

For deleting:

```sh
(
  cd ./.temp-tester/
  kubectl delete -f ./deployments/k8s-yaml/exchangescraper-custom.yaml
)
```

#### Test an existing scraper

WIP...

### Uninstall the platform

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

### Cluster stop

You can stop the cluster with `minikube stop` command

### Cluster delete

1. Delete the cluster node completly with `minikube delete` command
2. Also, the temporary files can be removed:

```sh
rm -rf ./.temp-tester/
```

---

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