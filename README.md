# DIAData Dev Environment

## Getting Started

1. Run the safety checks:

```shell
./scripts/checks.sh
```

2. Start a cluster

```shell
./scripts/cluster-start.sh
```

## Know Issues

1. Mounting hostPath volumes with ```minikube start --mount-string```, can't set permissions
  * ```--mount-uid=1001``` don't work with ```docker``` driver (do nothing)
  * ```--mount-gid=1001``` don't work with ```docker``` driver (do nothing)
2. Mounting hostPath volumes with "minikube mount", can't see free space with 9p filesystem (df -h command)

## References & Inspirations

* https://github.com/moby/moby/blob/master/contrib/check-config.sh