#!/usr/bin/env bash
set -e

kubectl create -f "pods/scraper-exchangescraper-bitfinex.yaml"
kubectl create -f "pods/scraper-exchangescraper-bittrex.yaml"
kubectl create -f "pods/scraper-exchangescraper-coinbase.yaml"
kubectl create -f "pods/scraper-exchangescraper-mexc.yaml"
kubectl create -f "pods/scraper-exchangescraper-bitmax.yaml"
kubectl create -f "pods/scraper-exchangescraper-kucoin.yaml"
kubectl create -f "pods/scraper-exchangescraper-okex.yaml"
kubectl create -f "pods/scraper-exchangescraper-kraken.yaml"

# TODO:
# │ time="2023-02-23T14:40:05Z" level=error msg="error on GetExchangePairSymbols<nil>"                                                                                                                                                                                             │
# │ time="2023-02-23T14:40:05Z" level=error msg="error loading </config/BitBay.json> open /config/BitBay.json: no such file or directory"                                                                                                                                          │
# │ time="2023-02-23T14:40:05Z" level=fatal msg="error in NewConfigCollectors"
# kubectl create -f "pods/scraper-exchangescraper-bitbay.yaml"
# kubectl create -f "pods/scraper-exchangescraper-crex24.yaml"
# kubectl create -f "pods/scraper-exchangescraper-dfyn.yaml"
# kubectl create -f "pods/scraper-exchangescraper-hitbtc.yaml"
# kubectl create -f "pods/scraper-exchangescraper-loopring.yaml"
# kubectl create -f "pods/scraper-exchangescraper-quoine.yaml"
# kubectl create -f "pods/scraper-exchangescraper-stex.yaml"
# kubectl create -f "pods/scraper-exchangescraper-sushiswap.yaml"
# kubectl create -f "pods/scraper-exchangescraper-uniswap.yaml"
# kubectl create -f "pods/scraper-exchangescraper-uniswapv3.yaml"
# kubectl create -f "pods/scraper-exchangescraper-zb.yaml"