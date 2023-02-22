# Development

## Requirements

* minikube
* kubectl

## Guides

### Getting Started

* Run the safety checks:

```shell
./scripts/checks.sh
```

* Initialize the cluster

```shell
./scripts/cluster-init.sh
```

* Build images

```shell
./scripts/cluster-build.sh
```

* Load images

```shell
./scripts/cluster-load.sh
```

* Start pods

```shell
./scripts/cluster-start.sh
```

### Advanced

Batch scripts:

```shell
./scripts/cluster-delete.sh; ./scripts/cluster-init.sh
```

```shell
./scripts/cluster-build.sh; ./scripts/cluster-load.sh
```

```shell
./scripts/cluster-stop.sh; ./scripts/cluster-start.sh
```

## Know Issues

1. Mounting hostPath volumes with ```minikube start --mount-string```, can't set permissions
  * ```--mount-uid=1001``` don't work with ```docker``` driver (do nothing)
  * ```--mount-gid=1001``` don't work with ```docker``` driver (do nothing)
2. Mounting hostPath volumes with "minikube mount", can't see free space with 9p filesystem (df -h command)

## References & Inspirations

* https://github.com/moby/moby/blob/master/contrib/check-config.sh

---

on Dockerfile use `# FROM gcr.io/distroless/base:debug` on 2nd stage