Cover the development of a test-space environment with DIA's platform. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contains proposal documents.

Minimum hardware recommended:

* 50Gb-100Gb disk space available
* 8Gb memory available
* 4 CPU

The followding systems are covered:

* Architectures: x86_64
* OSs: Arch Linux v6.3.6-arch1-1

Software dependencies needed:

* *bash*, *git*, *yq*
* *minikube*, and *docker* as main driver

## Prepare files

1. Clone the DIA's repo or a fork to .testenv folder:

```sh
git clone git@github.com:diadata-org/diadata.git -b v1.4.261 --depth 1 .testenv
```

2. Copy the prepared files:

```sh
cp -Rf inject/* .testenv/
```

1. Link the setup script:

```sh
ln -s "$PWD/setup" .testenv/setup
```

1. After changing the directory to .testenv, test-space are ready to be run:

```sh
cd .testenv
```

## Setup

Run the setup script to manage the enviornment 🚀:

`./setup --help`