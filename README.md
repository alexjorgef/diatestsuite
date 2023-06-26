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
# git clone git@github.com:diadata-org/diadata.git -b v1.4.288 "./.testenv"
git clone git@github.com:diadata-org/diadata.git "./.testenv"
cp -Rf ./inject/* "./.testenv"
cp -Rf ./inject/.[^.]* "./.testenv"
ln -s "$PWD/env" "./.testenv/env"
cd "./.testenv/"
```

## Getting start

Run the script to manage the enviornment 🚀:

```sh
./env --help
```

## Demo

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