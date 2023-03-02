# DIA Development Toolkit

A toolkit for testing the DIA ecossystem locally.

## Requirements

> Note: For supported minikube's drivers check [this document](https://minikube.sigs.k8s.io/docs/drivers/). The [docker](https://docs.docker.com/get-docker/) driver is the recommended and default option, therefore should be seen as requirement.

* [minikube](https://minikube.sigs.k8s.io/docs/): minikube quickly sets up a local Kubernetes cluster
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/): kubectl controls the Kubernetes cluster manager

Optional:

* [k9s](https://k9scli.io/): k9s is a terminal based UI to interact with your Kubernetes clusters

## Guides

### Getting Started

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

### Advanced

> Check minikube handbook [here](https://minikube.sigs.k8s.io/docs/handbook/) for more information about CLI commands.

Start Kubernetes Dashboard UI:

```shell
minikube dashboard --url=true --port=8083
```

Forward service's ports to your local host machine:

```shell
kubectl port-forward diadata-clusterdev-db-postgres 5432:5432
kubectl port-forward diadata-clusterdev-db-redis 6379:6379
kubectl port-forward diadata-clusterdev-db-influx 8086:8086
kubectl port-forward diadata-clusterdev-http-restserver 8081:8081
```

## Endpoints

DIA:

* REST Server: http://localhost:8081/

Kubernetes:

* Dashboard UI: http://localhost:8083/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

## Structure

```
.
├── build                                    Folder that holds all custom container definitions
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

![cluster_diagram](diagram.png)
