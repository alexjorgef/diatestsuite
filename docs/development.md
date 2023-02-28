# Development

## Requirements

> Note: for supportted minikube's drivers check [this document](https://minikube.sigs.k8s.io/docs/drivers/)

* [minikube](https://minikube.sigs.k8s.io/docs/): minikube quickly sets up a local Kubernetes cluster
* [kubectl](https://kubernetes.io/docs/reference/kubectl/kubectl/): kubectl controls the Kubernetes cluster manager
* Optional
  * [k9s](https://k9scli.io/): k9s is a terminal based UI to interact with your Kubernetes clusters

## Guides

### Getting Started

Firstly run the safety checks:

```shell
./scripts/checks.sh
```

Initialize the cluster:

```shell
./scripts/cluster-init.sh
```

Build images:

```shell
./scripts/cluster-build.sh
```

Load images to cluster:

```shell
./scripts/cluster-load.sh
```

Start cluster:

```shell
./scripts/cluster-start.sh
```

### Advanced

> Check Minikube [handbook](https://minikube.sigs.k8s.io/docs/handbook/)

Start Kubernetes Dashboard UI:

```shell
minikube dashboard --url=true --port=8083
```

Forward ports to your local machine:

```shell
kubectl port-forward diadata-clusterdev-db-postgres 5432:5432
kubectl port-forward diadata-clusterdev-db-redis 6379:6379
kubectl port-forward diadata-clusterdev-db-influx 8086:8086
```

Batch scripts:

```shell
# Killing and initialize the local cluster
./scripts/cluster-delete.sh; ./scripts/cluster-init.sh

# Building and loading image containers to cluster
./scripts/cluster-build.sh; ./scripts/cluster-load.sh

# Re-Start all containers in cluste
./scripts/cluster-stop.sh; ./scripts/cluster-start.sh
```

## Endpoints

Kubernetes:

* Dashboard UI: http://127.0.0.1:8083/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

## Debug and Troubleshooting

On `containers/*/Dockerfile` use `*:debug` tag on 2nd stage image:

```
# ...

# 1. comment this line
#FROM gcr.io/distroless/base

# 2. and use this line instead
FROM gcr.io/distroless/base:debug

# ...
```

## Common Issues

### Add custom host to kubernetes

> ref: https://hjrocha.medium.com/add-a-custom-host-to-kubernetes-a06472cedccb

run `kubectl -n kube-system edit configmap/coredns` and edit forward and hosts fields:

```yaml
data: 
  Corefile: |
      .:53 {
          errors
          health
          ready
          kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
          }
          prometheus :9153
          forward . 8.8.8.8 8.8.4.4
          cache 30
          loop
          reload
          loadbalance
          hosts custom.hosts mycustom.host {
            1.2.3.4 mycustom.host
            fallthrough
          }
       }
```

reload core-dns by typing: `kubectl delete pod -n kube-system core-dns-#########`

## Known Bugs or Issues

* Mounting hostPath volumes with ```minikube start --mount-string```, can't set permissions
  * ```--mount-uid=1001``` don't work with ```docker``` driver (do nothing)
  * ```--mount-gid=1001``` don't work with ```docker``` driver (do nothing)
* Mounting hostPath volumes with "minikube mount", can't see free space with 9p filesystem (df -h command)

## References & Inspirations

* https://github.com/moby/moby/blob/master/contrib/check-config.sh