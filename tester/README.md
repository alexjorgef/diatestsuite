# diatestsuite - Tester

## Start and install

* Start the local cluster: `minikube start`
* Create a directory for mounts: `mkdir -p mounts`
* Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git --depth 1 mounts/diadata-tester`
* Copy modified files: `cp -Rf tester/* mounts/diadata-tester/`
* Make sure you are in the injected *mounts/diadata-tester/* directory: `cd mounts/diadata-tester/`
* Build the containers into cluster:

```shell
minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild .
minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 .
minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService .
minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService .
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService .
minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector .
```

* You can go back to project root directory: `cd ../..`
* Install the platform by running the script:

```shell
kubectl create -f tester/deployments/k8s-yaml/influx.yaml
kubectl create -f tester/deployments/k8s-yaml/redis.yaml
kubectl create -f tester/deployments/k8s-yaml/postgres.yaml
kubectl create -f tester/deployments/k8s-yaml/kafka.yaml
kubectl create -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl create -f tester/deployments/k8s-yaml/filtersblockservice.yaml
```

* Wait for the services to start and finally you can install the scrapers:

```shell
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bitfinex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bittrex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-coinbase.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-mexc.yaml
```

## Stop and Uninstall

* To uninstall the scrapers:

```shell
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-bitfinex.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-bittrex.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-coinbase.yaml
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-mexc.yaml
```

* Uninstall the platform:

```shell
kubectl delete -f tester/deployments/k8s-yaml/filtersblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl delete -f tester/deployments/k8s-yaml/kafka.yaml
kubectl delete -f tester/deployments/k8s-yaml/postgres.yaml
kubectl delete -f tester/deployments/k8s-yaml/redis.yaml
kubectl delete -f tester/deployments/k8s-yaml/influx.yaml
```

* Now you can safely stop the cluster: `minikube stop`
* Delete the cluster node: `minikube delete`
* Also, can remove the files: `rm -rf mounts/`