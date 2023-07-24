Cover the development of a test-space environment with DIA's platform. [Wiki](https://github.com/alexjorgef/diatestsuite/wiki) contain notes.

## Requirements

Minimum hardware recommended:

* 50 GB disk space available
* 8 GB memory available
* 4 CPU

The followding systems are covered:

* Architectures: x86_64
* Systems: Linux v6.3.9

Software dependencies needed:

* *bash*, *git*, *docker*, *docker-buildx*, *minikube*, *kubectl*, *jq*, *yq*

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
rm -rf "./.testenv"
# git clone git@github.com:diadata-org/diadata.git -b v1.4.289 "./.testenv"
git clone git@github.com:diadata-org/diadata.git "./.testenv"
cp -Rf ./inject/* "./.testenv"
cp -Rf ./inject/.[^.]* "./.testenv"
# ln -s "$PWD/env" "./.testenv/env"
cd "./.testenv/"
```

## Getting start

Run the script to manage the enviornment 🚀:

```sh
./env --help
```

## Tests

1. Start platform and install resources:

```shell
./env start
./env --full install
```

2. Create demo scrapers:

```shell
./env create demos-scraper
```

3. Remove demo scrapers:

```shell
./env remove demos-scraper
```

4. Create one-by-one:

```shell
./env create scraper-cex coinbase
./env create scraper-dex platypus
./env create scraper-liquidity platypus
./env create scraper-foreign yahoofinance
```

5. Remove existing scrapers:

```shell
./env remove scraper-cex coinbase
./env remove scraper-dex platypus
./env remove scraper-liquidity platypus
./env remove scraper-foreign yahoofinance
```

6. Create dev scrapers:

```shell
./env create scraper-cex
./env create scraper-dex
./env create scraper-foreign
./env create scraper-liquidity
```

5. Remove existing dev scrapers:

```shell
./env remove scraper-cex
./env remove scraper-dex
./env remove scraper-foreign
./env remove scraper-liquidity
```

6. Uninstall

```shell
./env --full uninstall
```

6. Delete

```shell
./env delete
```

## Lists

```shell
./env data-list
./env data-list exchange
./env data-list blockchain
./env create scraper-dex testwrong
```

## Performance

Measure time of image building proccess:

```shell
time (./env --full install)
```