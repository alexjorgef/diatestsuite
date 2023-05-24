# diatestsuite - Tester

## Development

Prepare files:

1. Create a directory for mounts: `mkdir -p mounts/`
2. Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-tester`
3. Copy modified files: `cp -Rf tester/* mounts/diadata-tester/`

Start and install:

1. Make sure you are in the injected *mounts/diadata-tester/* directory: `cd mounts/diadata-tester/`
2. Start the local cluster: `minikube start`
3. Build the containers into cluster:


```shell
minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild .
minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 .
minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService .
minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService .
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService .
minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector .
```

4. Install the platform by running the script:

```shell
kubectl create -f deployments/k8s-yaml/influx.yaml
kubectl create -f deployments/k8s-yaml/redis.yaml
kubectl create -f deployments/k8s-yaml/postgres.yaml
kubectl create -f deployments/k8s-yaml/kafka.yaml
kubectl create -f deployments/k8s-yaml/tradesblockservice.yaml
kubectl create -f deployments/k8s-yaml/filtersblockservice.yaml
```

1. Finally you can install the scrapers:

```shell
kubectl create -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl create -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"
```

Uninstall and Stop:

1. Make sure you are in the injected *mounts/diadata-tester/* directory: `cd mounts/diadata-tester/`
2. Uninstall the platform:

```shell
kubectl delete -f "deployments/k8s-yaml/filtersblockservice.yaml"
kubectl delete -f "deployments/k8s-yaml/tradesblockservice.yaml"
kubectl delete -f "deployments/k8s-yaml/kafka.yaml"
kubectl delete -f "deployments/k8s-yaml/postgres.yaml"
kubectl delete -f "deployments/k8s-yaml/redis.yaml"
kubectl delete -f "deployments/k8s-yaml/influx.yaml"
```

1. To uninstall the scrapers:

```shell
kubectl delete -f "deployments/k8s-yaml/exchangescraper-bitfinex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-bittrex.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-coinbase.yaml"
kubectl delete -f "deployments/k8s-yaml/exchangescraper-mexc.yaml"
```

2. Now you can safely stop the cluster: `minikube stop`

Clean and reset the env:

1. Delete the cluster node: `minikube delete`
2. Also, can remove the files: `rm -rf mounts/`
3. Prune all local docker resources: `docker system prune -af`