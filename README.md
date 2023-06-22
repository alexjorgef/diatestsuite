Cover the development of a test-space environment with DIA's platform. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contain notes.

## Requirements

Minimum hardware recommended:

* 50 GB disk space available
* 8 GB memory available
* 4 CPU

The followding systems are covered:

* Architectures: x86_64
* Systems: Linux v6.3.8

Software dependencies needed:

* *bash*, *git*, *jq*, ~~*yq*~~
* *minikube*, and *docker* as main driver

## Prepare this repository

Clone this repo and change directory:

```sh
git clone git@github.com:alexjorgef/diatestsuite.git
cd diatestsuite
```

Then:

* Remove env, if exists
* Clone the DIA's repo or a fork to .testenv folder
* Copy the modification files
* Link script (workaround for fast development)
* Change to temporary directory

```sh
if [ -d "./.testenv" ]; then rm -Rf "./.testenv"; fi
git clone git@github.com:diadata-org/diadata.git -b v1.4.288 "./.testenv"
cp -Rf ./inject/* "./.testenv"
cp -Rf ./inject/.[^.]* "./.testenv"
ln -s "$PWD/env" "./.testenv/env"
cd "./.testenv/"
```

## Run

Run the script to manage the enviornment 🚀:

```sh
./env --help
```

## Demo log

Running:

```sh
./env start
./env install full
./env create example exchange
./env create example liquidity
./env create example foreign
```

Took 9m13s

```
Sourcing local config file ...
DIA Version: v1.4.288
Num. CPUs: 8
Disk size: 60g
Memory: 8g
K8s version: v1.26.5
Docker version: v24.0.2
Minikube driver: docker
Minikube profile: alexandre
minikube version: v1.30.1
commit: 08896fd1dc362c097c925146c4a0d0dac715ace0-dirty
Starting Minikube cluster ...
😄  [alexandre] minikube v1.30.1 on Arch "rolling"
✨  Using the docker driver based on user configuration
📌  Using Docker driver with root privileges
👍  Starting control plane node alexandre in cluster alexandre
🚜  Pulling base image ...
🔥  Creating docker container (CPUs=8, Memory=8192MB) ...
🐳  Preparing Kubernetes v1.26.5 on Docker 23.0.2 ...
❌  Unable to load cached images: loading cached images: stat /home/alex/.minikube/cache/images/amd64/registry.k8s.io/pause_test2: no such file or directory
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "alexandre" cluster and "default" namespace by default
Building base images ...
[+] Building 172.1s (14/14) FINISHED                                                                                     docker:default
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-DiadataBuild-117-Dev                                                          0.1s
 => => transferring dockerfile: 414B                                                                                               0.0s
 => [internal] load metadata for public.ecr.aws/docker/library/golang:1.17                                                         2.1s
 => [internal] load build context                                                                                                  1.1s
 => => transferring context: 172.07MB                                                                                              1.0s
 => [1/9] FROM public.ecr.aws/docker/library/golang:1.17@sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18  31.6s
 => => resolve public.ecr.aws/docker/library/golang:1.17@sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18   0.0s
 => => sha256:55636cf1983628109e569690596b85077f45aca810a77904e8afad48b49aa500 1.80kB / 1.80kB                                     0.0s
 => => sha256:d836772a1c1f9c4b1f280fb2a98ace30a4c4c87370f89aa092b35dfd9556278a 55.00MB / 55.00MB                                   7.8s
 => => sha256:d1989b6e74cfdda1591b9dd23be47c5caeb002b7a151379361ec0c3f0e6d0e52 10.88MB / 10.88MB                                   3.5s
 => => sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18 2.35kB / 2.35kB                                     0.0s
 => => sha256:742df529b073e7d1e213702a6cca40c32f3f5068125988de249416ba0abee517 7.12kB / 7.12kB                                     0.0s
 => => sha256:66a9e63c657ad881997f5165c0826be395bfc064415876b9fbaae74bcb5dc721 5.16MB / 5.16MB                                     3.6s
 => => sha256:c28818711e1ed38df107014a20127b41491b224d7aed8aa7066b55552d9600d2 54.58MB / 54.58MB                                  18.5s
 => => sha256:9d6246ba248cc80872dc2995f9080ef76305b540968dadb096b75f2e2146a38a 85.90MB / 85.90MB                                  21.6s
 => => extracting sha256:d836772a1c1f9c4b1f280fb2a98ace30a4c4c87370f89aa092b35dfd9556278a                                          0.8s
 => => sha256:21d43f0d73c2979514706af3d892f631b75d5c2d56aebfac0172e5a4e934b447 135.06MB / 135.06MB                                26.4s
 => => extracting sha256:66a9e63c657ad881997f5165c0826be395bfc064415876b9fbaae74bcb5dc721                                          0.2s
 => => extracting sha256:d1989b6e74cfdda1591b9dd23be47c5caeb002b7a151379361ec0c3f0e6d0e52                                          0.1s
 => => extracting sha256:c28818711e1ed38df107014a20127b41491b224d7aed8aa7066b55552d9600d2                                          1.0s
 => => sha256:d8a1c5873f408d3f5a8d8d73c6b9a3d77818bab0b26142a493909ea8c4d0c020 154B / 154B                                        18.9s
 => => extracting sha256:9d6246ba248cc80872dc2995f9080ef76305b540968dadb096b75f2e2146a38a                                          1.6s
 => => extracting sha256:21d43f0d73c2979514706af3d892f631b75d5c2d56aebfac0172e5a4e934b447                                          3.0s
 => => extracting sha256:d8a1c5873f408d3f5a8d8d73c6b9a3d77818bab0b26142a493909ea8c4d0c020                                          0.0s
 => [2/9] RUN apt update && apt upgrade -y                                                                                        15.7s
 => [3/9] COPY ./config/ /config/                                                                                                  0.1s
 => [4/9] COPY --link . /diadata                                                                                                   0.4s 
 => [5/9] WORKDIR /go/src/                                                                                                         0.0s 
 => [6/9] COPY ./go.mod ./                                                                                                         0.0s 
 => [7/9] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.3s 
 => [8/9] RUN go mod download                                                                                                     89.4s
 => [9/9] RUN go get github.com/karalabe/usb@v0.0.0-20210518091819-4ea20957c210                                                   10.6s
 => exporting to image                                                                                                            21.6s
 => => exporting layers                                                                                                           21.6s
 => => writing image sha256:a146ad084dfe17daf2c4825c51ed44f0974bab009cbf0b8846120943d14fb95a                                       0.0s
 => => naming to docker.io/library/dia.build-117.dev:latest                                                                        0.0s
Base image build successfully [1/1]
All DIA's images build successfully

real	3m35,351s
user	0m4,317s
sys	0m1,837s
Sourcing local config file ...
Creating and installing DIA's services (on full mode) ...
[+] Building 23.2s (12/12) FINISHED                                                                                      docker:default
 => [internal] load .dockerignore                                                                                                  0.0s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-filtersBlockService-Dev                                                       0.0s
 => => transferring dockerfile: 388B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.2s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => [2/7] COPY --link . /diadata                                                                                                   1.4s
 => [3/7] WORKDIR /go/src/                                                                                                         0.1s
 => [4/7] COPY ./cmd/services/filtersBlockService ./                                                                               0.1s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.4s
 => [6/7] RUN go mod tidy && go install                                                                                           14.6s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.4s 
 => exporting to image                                                                                                             6.0s 
 => => exporting layers                                                                                                            6.0s
 => => writing image sha256:a8e69d59b8e6fadb9f0ec3f6fb4dc743c948d2264993d8d6d9a8d4e4b59e5496                                       0.0s
 => => naming to docker.io/library/dia.filtersblockservice.dev:latest                                                              0.0s
Service image present [1/4]
[+] Building 34.1s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-tradesBlockService-Dev                                                        0.0s
 => => transferring dockerfile: 419B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.0s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.0s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/services/tradesBlockService ./                                                                                0.0s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.4s
 => [6/7] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          25.8s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.6s 
 => exporting to image                                                                                                             7.2s
 => => exporting layers                                                                                                            7.1s
 => => writing image sha256:74275cd596052078112e2d520e3f4a110a9f7cb3a6cdc850a64be25a65e60b4d                                       0.0s
 => => naming to docker.io/library/dia.tradesblockservice.dev:latest                                                               0.0s
Service image present [2/4]
[+] Building 16.5s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-blockchainservice-Dev                                                         0.1s
 => => transferring dockerfile: 382B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/services/blockchainservice ./                                                                                 0.1s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.6s
 => [6/7] RUN go mod tidy && go install                                                                                            9.7s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.7s
 => exporting to image                                                                                                             5.1s
 => => exporting layers                                                                                                            5.1s
 => => writing image sha256:5114c213cb70110535c4abf3b4c58d7f666456e127e6b4f1c4495d8ca1e0d556                                       0.0s
 => => naming to docker.io/library/dia.blockchainservice.dev:latest                                                                0.0s
Service image present [3/4]
[+] Building 34.4s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-assetCollectionService-Dev                                                    0.1s
 => => transferring dockerfile: 389B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/assetCollectionService ./                                                                                     0.1s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.6s
 => [6/7] RUN go mod tidy && go install                                                                                           25.4s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.7s 
 => exporting to image                                                                                                             7.3s
 => => exporting layers                                                                                                            7.3s
 => => writing image sha256:590fb7a9402034df0e147f34e4709f871ac4338326d7d8b7c8fae38c593c67b2                                       0.0s
 => => naming to docker.io/library/dia.assetcollectionservice.dev:latest                                                           0.0s
Service image present [4/4]

real	1m51,541s
user	0m2,446s
sys	0m1,272s
deployment.apps/service-filtersblockservice created
deployment.apps/service-tradesblockservice created
deployment.apps/data-kafka created
service/data-kafka created
configmap/postgres-schemma created
deployment.apps/data-postgres created
service/data-postgres created
deployment.apps/data-redis created
service/data-redis created
deployment.apps/data-influx created
service/data-influx created
job.batch/job-prepare created
All DIA's services created with success
Sourcing local config file ...
Checking if services images are present ...
[+] Building 43.6s (12/12) FINISHED                                                                                      docker:default
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-pairDiscoveryService-Dev                                                      0.0s
 => => transferring dockerfile: 425B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/services/pairDiscoveryService ./                                                                              0.1s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.5s
 => [6/7] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          31.8s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.8s 
 => exporting to image                                                                                                            10.3s 
 => => exporting layers                                                                                                           10.3s 
 => => writing image sha256:6e95d481a36fcafe292ea465eef900c0db5d0f2b2bd04c13bf72460e5c73cf4a                                       0.0s
 => => naming to docker.io/library/dia.pairdiscoveryservice.dev:latest                                                             0.0s
Service image present [1/4]
[+] Building 65.6s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-genericCollector-Dev                                                          0.1s
 => => transferring dockerfile: 407B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/exchange-scrapers/collector ./                                                                                0.1s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.8s
 => [6/7] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          46.5s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 0.8s
 => exporting to image                                                                                                            17.1s 
 => => exporting layers                                                                                                           17.1s 
 => => writing image sha256:b704cafa963328d99a9179f41d669cc4ecaab9967b0dc4bac3598c20deb78b27                                       0.0s 
 => => naming to docker.io/library/dia.genericcollector.dev:latest                                                                 0.0s 
Service image present [2/4]                                                                                                             
[+] Building 36.9s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-genericForeignScraper-Dev                                                     0.1s
 => => transferring dockerfile: 404B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/foreignscraper ./                                                                                             0.2s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.7s
 => [6/7] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          26.8s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 1.3s
 => exporting to image                                                                                                             7.5s
 => => exporting layers                                                                                                            7.4s
 => => writing image sha256:f0c4486dab911218a8f8541375a228e4ef3ef0f42817e0ac4806f0dce4011ce9                                       0.0s
 => => naming to docker.io/library/dia.genericforeignscraper.dev:latest                                                            0.0s
Service image present [3/4]
[+] Building 68.5s (12/12) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-liquidityScraper-Dev                                                          0.1s
 => => transferring dockerfile: 403B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/7] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.70kB                                                                                              0.1s
 => CACHED [2/7] COPY --link . /diadata                                                                                            0.0s
 => CACHED [3/7] WORKDIR /go/src/                                                                                                  0.0s
 => [4/7] COPY ./cmd/liquidityScraper ./                                                                                           0.7s
 => [5/7] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         2.9s
 => [6/7] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          52.7s
 => [7/7] RUN go mod edit -replace github.com/diadata-org/diadata=/mnt/env-context                                                 1.3s
 => exporting to image                                                                                                            10.4s
 => => exporting layers                                                                                                           10.3s
 => => writing image sha256:df2a5ad1e8d3b28f0eeded035beb6b75f920cc96b229d00fc4bbddf444b29e34                                       0.0s
 => => naming to docker.io/library/dia.liquidityscraper.dev:latest                                                                 0.0s
Service image present [4/4]

real	3m38,561s
user	0m2,612s
sys	0m1,515s
Creating exchange example ...
pod/scraper-exchange-bitfinex created
pod/scraper-exchange-bittrex created
pod/scraper-exchange-coinbase created
pod/scraper-exchange-mexc created
Example exchange created with success
Sourcing local config file ...
Checking if services images are present ...
Service image present [1/4]
Service image present [2/4]
Service image present [3/4]
Service image present [4/4]

real	0m1,919s
user	0m0,654s
sys	0m0,453s
Creating liquidity example ...
pod/scraper-liquidity-platypus created
Example liquidity created with success
Sourcing local config file ...
Checking if services images are present ...
Service image present [1/4]
Service image present [2/4]
Service image present [3/4]
Service image present [4/4]

real	0m1,328s
user	0m0,656s
sys	0m0,420s
Creating foreign example ...
pod/scraper-foreign-yahoofinance created
pod/scraper-foreign-googlefinance created
Example foreign created with success
The DIA enviorment manager

Environment variables:

| Name                    | Description                 |
|-------------------------|-----------------------------|
| MINIKUBE_PROFILE        | Minikube profile name       |
| MINIKUBE_HW_DISK_SIZE   | Minikube disk size          |
| MINIKUBE_HW_CPUS        | Minikube number of CPUs     |
| MINIKUBE_HW_RAM         | Minikube memory limit       |
| MINIKUBE_K8S_VERSION    | K8s version                 |

Usage:
  env [OPTIONS] COMMAND [ARGS]...

Options:
  -h --help             Print help

Available commands:
  code-build            Build platform code
  code-lint             Lint code
  code-test             Run tests
  start                 Start cluster
  stop                  Stop the cluster
  delete                Delete all cluster resources
  install [full]        Install DIA platform
  uninstall             Un-install DIA platform
  create                Create a new resource
  remove                Remove a resource
  clean                 Clean unused files
  info                  Show detailed information
  shell                 Connect to enviornment shell
  logs                  Print logs
  ping                  Make ping tests
  data-list             List data
  data-reset            Reset data

Report bugs to: <https://github.com/diadata-org/diadata/issues>
```