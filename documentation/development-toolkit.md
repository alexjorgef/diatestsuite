# DIA Development Toolkit

A toolkit for testing the DIA ecossystem locally.

## Requirements

> For supported minikube's drivers check [the official documentation](https://minikube.sigs.k8s.io/docs/drivers/). The [docker](https://docs.docker.com/get-docker/) driver is the recommended and default option, therefore should be seen as requirement.

* [minikube](https://minikube.sigs.k8s.io/docs/): minikube quickly sets up a local Kubernetes cluster
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/): kubectl controls the Kubernetes cluster manager

Optional:

* [k9s](https://k9scli.io/): k9s is a terminal based UI to interact with your Kubernetes clusters

## Getting Started

Initialize the cluster:

```shell
./deployments/init.sh
```

Start the cluster's containers:

```shell
./deployments/start.sh
```

You can stop the cluster's containers with:

```shell
./deployments/stop.sh
```

Finally, start the Kubernetes Dashboard UI to see your cluster:

```shell
minikube dashboard --url=true --port=8083
```

After the dashboard service is ready, you can visit the web interface on your favorite browser:

```
http://127.0.0.1:8083/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
```

### Endpoints

> The routes are only available after you [forward service's ports](#forward-ports-to-localhost) to your host machine.

* **REST Server**: localhost:8081
* **PostgreSQL Database**: localhost:5432
* **Redis Cache**: localhost:6379
* **InfluxDB Datastore**: localhost:8086

---

## Guides

### How to add a new scraper

1. WIP...

---

## Advanced Usage

> For more information about minikube CLI commands, check the handbook [here](https://minikube.sigs.k8s.io/docs/handbook/).

#### Forward ports to localhost

REST Server:

```shell
kubectl port-forward diadata-clusterdev-http-restserver 8081:8081
```

PostgreSQL Database:

```shell
kubectl port-forward diadata-clusterdev-db-postgres 5432:5432
```

Redis Cache:

```shell
kubectl port-forward diadata-clusterdev-db-redis 6379:6379
```

InfluxDB Datastore:

```shell
kubectl port-forward diadata-clusterdev-db-influx 8086:8086
```

---

## Structure

File structure:

```
.
├── build                                    Folder that holds all the custom container's definitions
│   ├── Dockerfile-assetCollectionService
│   ├── Dockerfile-blockchainservice
│   ├── Dockerfile-filtersBlockService
│   ├── Dockerfile-genericCollector
│   ├── Dockerfile-pairDiscoveryService
│   ├── Dockerfile-restServer
│   └── Dockerfile-tradesBlockService
├── deployments
│   ├── config                               Config files needed for initialize cluster containers
│   │   ├── influxdb2.conf
│   │   ├── influxdb.conf
│   │   ├── pginit.sql
│   │   ├── postgresql.conf
│   │   └── redis.conf
│   ├── k8s-yaml                             Deployment configs
│   │   ├── exchangescraper-*.yaml
│   │   ├── filtersblockservice.yaml
│   │   ├── influx.yaml
│   │   ├── kafka.yaml
│   │   ├── postgres.yaml
│   │   ├── redis.yaml
│   │   ├── restserver.yaml
│   │   └── tradesblockservice.yaml
│   ├── init.sh                              Script for initialize local cluster
│   ├── start.sh                             Script for start containers
│   └── stop.sh                              Script for stop containers
└── minikube.log                             Cluster log
```

Overview diagram:

![cluster_diagram](diagram.png)
