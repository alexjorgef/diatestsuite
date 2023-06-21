Cover the development of a test-space environment with DIA's platform. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contain notes.

## Requirements

Minimum hardware recommended:

* 50Gb disk space available
* 8Gb memory available
* 4 CPU

The followding systems are covered:

* Architectures: x86_64
* Systems: Linux v6.3.8

Software dependencies needed:

* *bash*, *git*, *jq*, ~~*yq*~~
* *minikube*, and *docker* as main driver

## Prepare this repository

First, clone this repo and change directory:

```sh
git clone git@github.com:alexjorgef/diatestsuite.git
cd diatestsuite
```

Second:

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
./env start
./env install full
./env create example exchange
./env create example liquidity
./env create example foreign
./env --help
```

Renovate files:

```sh
(
    cd ..
    cp -Rf ./inject/* "./.testenv"
    cp -Rf ./inject/.[^.]* "./.testenv"
)
```

## Performance

Best start time (DIA v1.4.288 on Minikube+Docker):

* Cluster start: 3m56
* Full installation: 1m57
* Create resouce: 3m38

## To do

* [ ] Providers to have reproducible tests over scrapers
* [ ] Single container mode only w/ Docker