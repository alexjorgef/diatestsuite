# diatestsuite

## Requirements

* bash
* minikube
* docker

---

## Development

### Dumper

Dump a snapshot of relational data from an existing PostgreSQL database and push it to a Docker registry

#### Start the cluster and prepare files

> Note: Make sure you are at the root directory of this repo!

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-dumper`
3. Copy modified files: `cp -Rf dumper/* mounts/diadata-dumper/`
4. Make sure you are in the injected *mounts/diadata-dumper/* directory: `cd mounts/diadata-dumper/`
5. Start the local cluster: `./scripts/minikubeStart.sh`
6. Build the containers into cluster: `./scripts/minikubeBuild.sh`
7. Services and exchange scrapers: `./scripts/minikubeInstallPreSnap.sh`
8. Make sure you return to previous folder, the root directory of the project: `cd ../..`
9. Create the shared folder for postgres: `mkdir -p mounts/postgres-dump`
10. Mount a shared volume for PostgreSQL to dump: `minikube mount --profile diadata-dumper "$(pwd)/mounts/postgres-dump:/data/shared-postgres" --uid 70 --gid 70` (Note that uid 70 and gid 70 is due to postgres alpine image, normal image have different permissions)
11. Back again to *mounts/diadata-dumper/* directory: `cd mounts/diadata-dumper/`

#### Install

1. Snapshot cronjob: `./scripts/minikubeInstallSnap.sh`

#### Stop and Uninstall

1. Make sure you are in the injected `mounts/diadata-dumper/` directory
2. Uninstall the platform: `./scripts/minikubeUninstallSnap.sh`, `./scripts/minikubeUninstallPreSnap.sh`
3. Now you can safely stop the cluster: `./scripts/minikubeStop.sh`

#### Cluster clean

1. Delete the cluster node: `./scripts/minikubeDelete.sh`
2. Also, can remove the files: `rm -rf mounts/`

### Tester

Create a new test space environment for DIA platform

#### Start the cluster and prepare files

> Note: Make sure you are at the root directory of this repo!

1. Start the local cluster: `minikube start`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 diadata`
3. Copy modified files: `cp -Rf tester/* diadata/`
4. Build the containers into cluster:

```shell
minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild diadata
minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 diadata
minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService diadata
minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService diadata
```

#### Install

1. Install the platform by running the script:

```shell
kubectl create -f tester/deployments/k8s-yaml/influx.yaml
kubectl create -f tester/deployments/k8s-yaml/redis.yaml
kubectl create -f tester/deployments/k8s-yaml/postgres.yaml
kubectl create -f tester/deployments/k8s-yaml/kafka.yaml
kubectl create -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl create -f tester/deployments/k8s-yaml/filtersblockservice.yaml
```

2. Add the custom scraper files:

* `pkg/dia/scraper/exchange-scrapers/CustomScraper.go`
* `pkg/dia/Config.go`
* `pkg/dia/scraper/exchange-scrapers/APIScraper.go`
* `config/Custom.json`

3. Modify the `build/Dockerfile-genericCollector` and the `build/Dockerfile-pairDiscoveryService` file and add these two Dockerfile lines before the RUN go mod tidy step:

```dockerfile
COPY . /diadata
RUN go mod edit -replace github.com/diadata-org/diadata=/diadata
```

4. Build the necessary service's containers:

```shell
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService diadata
minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector diadata
```

5. Add a new entry to exchange table database:

```shell
kubectl exec -it deployment/postgres -- psql -U postgres -c "INSERT INTO exchange (exchange_id, "name", centralized, bridge, contract, blockchain, rest_api, ws_api, pairs_api, watchdog_delay, scraper_active) VALUES(gen_random_uuid(), 'Custom', true, false, '', '', '', 'wss://ws-feed.pro.coinbase.com', 'https://api.pro.coinbase.com/products', 300, true);"
```

6. Wait for the services to start and finally you can install your scraper:

```shell
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml
```

7. Also, can test with a pre-configured scrapers:

```shell
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bitfinex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bittrex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-coinbase.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-mexc.yaml
```

#### Stop and Uninstall

1. To uninstall your scraper:

```shell
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml
```

2. To uninstall the scrapers:

```shell
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-bitfinex.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-bittrex.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-coinbase.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-mexc.yaml
```

3. Uninstall the platform:

```shell
kubectl delete -f tester/deployments/k8s-yaml/filtersblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/kafka.yaml
kubectl delete -f tester/deployments/k8s-yaml/postgres.yaml
kubectl delete -f tester/deployments/k8s-yaml/redis.yaml
kubectl delete -f tester/deployments/k8s-yaml/influx.yaml
```

4. Now you can safely stop the cluster: `minikube stop`

#### Cluster clean

1. Delete the cluster node: `minikube delete`