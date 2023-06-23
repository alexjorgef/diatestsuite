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
time (./env start)
time (./env install full)
time (./env create example exchange)
time (./env create example liquidity)
time (./env create example foreign)
time (./env create exchange)
time (./env create liquidity)
time (./env create foreign)
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
[+] Building 163.7s (13/13) FINISHED                                                                                     docker:default
 => [internal] load build definition from Dockerfile-DiadataBuild-117-Dev                                                          0.2s
 => => transferring dockerfile: 391B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.2s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for public.ecr.aws/docker/library/golang:1.17                                                         2.2s
 => [1/8] FROM public.ecr.aws/docker/library/golang:1.17@sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18  32.4s
 => => resolve public.ecr.aws/docker/library/golang:1.17@sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18   0.1s
 => => sha256:87262e4a4c7db56158a80a18fefdc4fee5accc41b59cde821e691d05541bbb18 2.35kB / 2.35kB                                     0.0s
 => => sha256:55636cf1983628109e569690596b85077f45aca810a77904e8afad48b49aa500 1.80kB / 1.80kB                                     0.0s
 => => sha256:742df529b073e7d1e213702a6cca40c32f3f5068125988de249416ba0abee517 7.12kB / 7.12kB                                     0.0s
 => => sha256:66a9e63c657ad881997f5165c0826be395bfc064415876b9fbaae74bcb5dc721 5.16MB / 5.16MB                                     2.8s
 => => sha256:d836772a1c1f9c4b1f280fb2a98ace30a4c4c87370f89aa092b35dfd9556278a 55.00MB / 55.00MB                                   5.9s
 => => sha256:d1989b6e74cfdda1591b9dd23be47c5caeb002b7a151379361ec0c3f0e6d0e52 10.88MB / 10.88MB                                   5.2s
 => => sha256:c28818711e1ed38df107014a20127b41491b224d7aed8aa7066b55552d9600d2 54.58MB / 54.58MB                                  17.4s
 => => sha256:9d6246ba248cc80872dc2995f9080ef76305b540968dadb096b75f2e2146a38a 85.90MB / 85.90MB                                  24.3s
 => => extracting sha256:d836772a1c1f9c4b1f280fb2a98ace30a4c4c87370f89aa092b35dfd9556278a                                          0.8s
 => => sha256:21d43f0d73c2979514706af3d892f631b75d5c2d56aebfac0172e5a4e934b447 135.06MB / 135.06MB                                29.2s
 => => extracting sha256:66a9e63c657ad881997f5165c0826be395bfc064415876b9fbaae74bcb5dc721                                          0.1s
 => => extracting sha256:d1989b6e74cfdda1591b9dd23be47c5caeb002b7a151379361ec0c3f0e6d0e52                                          0.1s
 => => sha256:d8a1c5873f408d3f5a8d8d73c6b9a3d77818bab0b26142a493909ea8c4d0c020 154B / 154B                                        17.6s
 => => extracting sha256:c28818711e1ed38df107014a20127b41491b224d7aed8aa7066b55552d9600d2                                          0.9s
 => => extracting sha256:9d6246ba248cc80872dc2995f9080ef76305b540968dadb096b75f2e2146a38a                                          1.4s
 => => extracting sha256:21d43f0d73c2979514706af3d892f631b75d5c2d56aebfac0172e5a4e934b447                                          2.6s
 => => extracting sha256:d8a1c5873f408d3f5a8d8d73c6b9a3d77818bab0b26142a493909ea8c4d0c020                                          0.0s
 => [internal] load build context                                                                                                  0.2s
 => => transferring context: 5.69MB                                                                                                0.1s
 => [2/8] RUN apt update && apt upgrade -y                                                                                        17.9s
 => [3/8] COPY ./config/ /config/                                                                                                  0.1s
 => [4/8] WORKDIR /go/src/                                                                                                         0.0s
 => [5/8] COPY ./go.mod ./                                                                                                         0.0s 
 => [6/8] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.3s 
 => [7/8] RUN go mod download                                                                                                     82.4s 
 => [8/8] RUN go get github.com/karalabe/usb@v0.0.0-20210518091819-4ea20957c210                                                    7.1s 
 => exporting to image                                                                                                            21.0s
 => => exporting layers                                                                                                           20.9s
 => => writing image sha256:ef3be9a3924643edad0ca08468995f4c3b550f08c6b7886c29588247d8f24bfb                                       0.0s
 => => naming to docker.io/library/dia.build-117.dev:latest                                                                        0.0s
Base image build successfully [1/1]
All DIA's images build successfully
( ./env start; )  2,83s user 1,40s system 2% cpu 3:21,37 total
Sourcing local config file ...
Creating and installing DIA's services (on full mode) ...
[+] Building 25.3s (11/11) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-filtersBlockService-Dev                                                       0.0s
 => => transferring dockerfile: 308B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.4s
 => [internal] load build context                                                                                                  0.9s
 => => transferring context: 166.42MB                                                                                              0.9s
 => [2/6] COPY . /diadata                                                                                                          3.2s
 => [3/6] WORKDIR /go/src/                                                                                                         0.1s
 => [4/6] COPY ./cmd/services/filtersBlockService ./                                                                               0.1s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.4s
 => [6/6] RUN go mod tidy && go install                                                                                           14.4s
 => exporting to image                                                                                                             6.0s
 => => exporting layers                                                                                                            5.9s
 => => writing image sha256:f11f919f72e1faf2074522e1526b6ee9335cc84eb8c5dd2f9dba7e72ab6ec758                                       0.0s
 => => naming to docker.io/library/dia.filtersblockservice.dev:latest                                                              0.0s
Service image present [1/4]
[+] Building 36.1s (11/11) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-tradesBlockService-Dev                                                        0.0s
 => => transferring dockerfile: 339B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/services/tradesBlockService ./                                                                                0.1s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.4s
 => [6/6] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          28.3s
 => exporting to image                                                                                                             7.1s
 => => exporting layers                                                                                                            7.1s
 => => writing image sha256:dd5cf95ceb7c7300e1f91e3468b57271ca9f55747d403b6da1b38da01afab1db                                       0.0s
 => => naming to docker.io/library/dia.tradesblockservice.dev:latest                                                               0.0s
Service image present [2/4]
[+] Building 15.9s (11/11) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-blockchainservice-Dev                                                         0.1s
 => => transferring dockerfile: 302B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/services/blockchainservice ./                                                                                 0.1s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.6s
 => [6/6] RUN go mod tidy && go install                                                                                           10.0s
 => exporting to image                                                                                                             5.0s
 => => exporting layers                                                                                                            5.0s
 => => writing image sha256:87fb3d7b3a585fc64885a60b78199383e40fd51bbed62e26ecc86834ec09ce8d                                       0.0s
 => => naming to docker.io/library/dia.blockchainservice.dev:latest                                                                0.0s
Service image present [3/4]
[+] Building 34.6s (11/11) FINISHED                                                                                      docker:default
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-assetCollectionService-Dev                                                    0.0s
 => => transferring dockerfile: 309B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/assetCollectionService ./                                                                                     0.1s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.5s
 => [6/6] RUN go mod tidy && go install                                                                                           26.8s
 => exporting to image                                                                                                             7.1s 
 => => exporting layers                                                                                                            7.0s
 => => writing image sha256:2afc91d14940f6ce9b86aac6fdb8468aa8225cbccea10b5ac3489c7162b054e0                                       0.0s
 => => naming to docker.io/library/dia.assetcollectionservice.dev:latest                                                           0.0s
Service image present [4/4]
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
( ./env install full; )  5,52s user 2,47s system 6% cpu 1:57,87 total
Sourcing local config file ...
Checking if services images are present ...
[+] Building 53.8s (11/11) FINISHED                                                                                      docker:default
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-pairDiscoveryService-Dev                                                      0.1s
 => => transferring dockerfile: 345B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.0s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/services/pairDiscoveryService ./                                                                              0.1s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.5s
 => [6/6] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          42.4s
 => exporting to image                                                                                                            10.3s 
 => => exporting layers                                                                                                           10.3s 
 => => writing image sha256:264a5428c6fa73e9379bdc8ee2d4c9ad8befe50ad9010d2accf79d955f85347d                                       0.0s 
 => => naming to docker.io/library/dia.pairdiscoveryservice.dev:latest                                                             0.0s
Service image present [1/4]
[+] Building 61.7s (11/11) FINISHED                                                                                      docker:default
 => [internal] load .dockerignore                                                                                                  0.2s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load build definition from Dockerfile-genericCollector-Dev                                                          0.2s
 => => transferring dockerfile: 327B                                                                                               0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/exchange-scrapers/collector ./                                                                                1.4s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.9s
 => [6/6] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          47.7s
 => exporting to image                                                                                                            11.2s 
 => => exporting layers                                                                                                           11.1s 
 => => writing image sha256:49535ffc440c13283bff3775d9e0891b61b3a8742ce9af755984cd210a7ce28e                                       0.0s 
 => => naming to docker.io/library/dia.genericcollector.dev:latest                                                                 0.0s 
Service image present [2/4]                                                                                                             
[+] Building 35.5s (11/11) FINISHED                                                                                      docker:default 
 => [internal] load build definition from Dockerfile-genericForeignScraper-Dev                                                     0.1s
 => => transferring dockerfile: 324B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/foreignscraper ./                                                                                             0.2s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.6s
 => [6/6] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          25.7s
 => exporting to image                                                                                                             8.7s
 => => exporting layers                                                                                                            8.6s
 => => writing image sha256:dd5ed4438d791a8d76555529591032c932a083e0e0932792d54a0fead95d50a4                                       0.0s
 => => naming to docker.io/library/dia.genericforeignscraper.dev:latest                                                            0.0s
Service image present [3/4]
[+] Building 61.3s (11/11) FINISHED                                                                                      docker:default
 => [internal] load build definition from Dockerfile-liquidityScraper-Dev                                                          0.2s
 => => transferring dockerfile: 323B                                                                                               0.0s
 => [internal] load .dockerignore                                                                                                  0.1s
 => => transferring context: 61B                                                                                                   0.0s
 => [internal] load metadata for docker.io/library/dia.build-117.dev:latest                                                        0.0s
 => [1/6] FROM docker.io/library/dia.build-117.dev:latest                                                                          0.0s
 => [internal] load build context                                                                                                  0.1s
 => => transferring context: 100.99kB                                                                                              0.1s
 => CACHED [2/6] COPY . /diadata                                                                                                   0.0s
 => CACHED [3/6] WORKDIR /go/src/                                                                                                  0.0s
 => [4/6] COPY ./cmd/liquidityScraper ./                                                                                           0.4s
 => [5/6] RUN go mod edit -replace github.com/diadata-org/diadata=/diadata                                                         0.8s
 => [6/6] RUN go mod tidy -go=1.16 && go mod tidy -go=1.17 && go install                                                          44.7s
 => exporting to image                                                                                                            14.9s
 => => exporting layers                                                                                                           14.9s
 => => writing image sha256:c17cf62d7fed1ce67a7139bcc8f2bacaab2dbb70799ee7ee56452889a62b28e8                                       0.0s
 => => naming to docker.io/library/dia.liquidityscraper.dev:latest                                                                 0.0s
Service image present [4/4]
Creating exchange example ...
pod/scraper-exchange-bitfinex created
pod/scraper-exchange-bittrex created
pod/scraper-exchange-coinbase created
pod/scraper-exchange-mexc created
pod/scraper-exchange-bitmart created
pod/scraper-exchange-platypus created
pod/scraper-exchange-orca created
Example exchange created with success
( ./env create example exchange; )  4,83s user 2,07s system 3% cpu 3:42,28 total
Sourcing local config file ...
Checking if services images are present ...
Service image present [1/4]
Service image present [2/4]
Service image present [3/4]
Service image present [4/4]
Creating liquidity example ...
pod/scraper-liquidity-platypus created
pod/scraper-liquidity-orca created
Example liquidity created with success
( ./env create example liquidity; )  1,09s user 0,63s system 18% cpu 9,214 total
Sourcing local config file ...
Checking if services images are present ...
Service image present [1/4]
Service image present [2/4]
Service image present [3/4]
Service image present [4/4]
Creating foreign example ...
pod/scraper-foreign-yahoofinance created
Example foreign created with success
( ./env create example foreign; )  0,91s user 0,44s system 85% cpu 1,581 total
```