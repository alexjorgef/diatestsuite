# diatestsuite - Tester

## Start and install

* Start the local cluster: `minikube start`
* Clone DIA repo: `git clone git@github.com:diadata-org/diadata.git -b v1.4.241 --depth 1 diadata`
* Copy modified files: `cp -Rf tester/* diadata/`
* Build the containers into cluster:

```shell
minikube image build -t us.icr.io/dia-registry/devops/build:latest -f build/build/Dockerfile-DiadataBuild diadata
minikube image build -t us.icr.io/dia-registry/devops/build-117:latest -f build/build/Dockerfile-DiadataBuild-117 diadata
minikube image build -t diadata.filtersblockservice:latest -f build/Dockerfile-filtersBlockService diadata
minikube image build -t diadata.tradesblockservice:latest -f build/Dockerfile-tradesBlockService diadata
```

* Install the platform by running the script:

```shell
kubectl create -f tester/deployments/k8s-yaml/influx.yaml
kubectl create -f tester/deployments/k8s-yaml/redis.yaml
kubectl create -f tester/deployments/k8s-yaml/postgres.yaml
kubectl create -f tester/deployments/k8s-yaml/kafka.yaml
kubectl create -f tester/deployments/k8s-yaml/tradesblockservice.yaml
kubectl create -f tester/deployments/k8s-yaml/filtersblockservice.yaml
```

* Add the custom scraper
  * pkg/dia/scraper/exchange-scrapers/APIScraper.go
  * pkg/dia/scraper/exchange-scrapers/CustomScraper.go
  * pkg/dia/Config.go
  * config/Custom.json
* Modify the `build/Dockerfile-genericCollector` and the `build/Dockerfile-pairDiscoveryService` file and add these two Dockerfile lines before the RUN go mod tidy step:

```dockerfile
COPY . /diadata
RUN go mod edit -replace github.com/diadata-org/diadata=/diadata
```

* Build the necessary service's containers:

```shell
minikube image build -t diadata.pairdiscoveryservice:latest -f build/Dockerfile-pairDiscoveryService diadata
minikube image build -t diadata.exchangescrapercollector:latest -f build/Dockerfile-genericCollector diadata
```

* Add a new entry to exchange table database:

```shell
kubectl exec -it deployment/postgres -- psql -U postgres -c "INSERT INTO public.exchange (exchange_id, "name", centralized, bridge, contract, blockchain, rest_api, ws_api, pairs_api, watchdog_delay, scraper_active) VALUES(gen_random_uuid(), 'Custom', true, false, '', '', 'https://api.kraken.com', 'wss://ws.kraken.com', 'https://api.kraken.com/0/public/AssetPairs', 300, true);"
```

* Wait for the services to start and finally you can install the scrapers:

```shell
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml

kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bitfinex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-bittrex.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-coinbase.yaml
kubectl create -f tester/deployments/k8s-yaml/exchangescraper-mexc.yaml
```

## Stop and Uninstall

* To uninstall the scrapers:

```shell
kubectl delete -f tester/deployments/k8s-yaml/exchangescraper-custom.yaml

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