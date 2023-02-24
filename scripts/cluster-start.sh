#!/usr/bin/env bash
# TODO: Make sure no error is throw
# set -e

# Databases and datastores
kubectl create -f "pods/db-influx.yaml" \
-f "pods/db-redis.yaml" \
-f "pods/db-postgres.yaml" \
-f "pods/db-kafka.yaml" \
-f "pods/db-zookeeper.yaml"

sleep 10

./scripts/cluster-forward.sh

sleep 1

./scripts/cluster-initial-service-blockchainservice.sh

sleep 1

./scripts/cluster-forward-kill.sh

sleep 1

# Services
kubectl create -f "pods/service-tradesblockservice.yaml" \
-f "pods/service-filtersblockservice.yaml"

# TODO: only forward when pod is ready
./scripts/cluster-forward.sh

sleep 1

# TODO: Make sure if this is all assets
# TODO: SushiSwap
./scripts/cluster-initial-assetCollectionService.sh "SushiSwap" ""
./scripts/cluster-initial-assetCollectionService.sh "PanCakeSwap" ""
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "eth_assets"
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "non_eth_assets"
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "fiat_assets"
# TODO: Uniswap
# ./scripts/cluster-initial-assetCollectionService.sh "Uniswap" ""
# panic: runtime error: invalid memory address or nil pointer dereference
# [signal SIGSEGV: segmentation violation code=0x1 addr=0x8 pc=0xc1e227]
# 
# goroutine 11 [running]:
# math/big.(*Int).Int64(...)
# 	/usr/lib/go/src/math/big/int.go:418
# github.com/diadata-org/diadata/pkg/dia/service/assetservice/source.(*UniswapAssetSource).getNumPairs(0xc000428ae0)
# 	/home/alex/go/pkg/mod/github.com/diadata-org/diadata@v1.4.148/pkg/dia/service/assetservice/source/uniswap.go:177 +0xe7
# github.com/diadata-org/diadata/pkg/dia/service/assetservice/source.(*UniswapAssetSource).fetchAssets(0xc000428ae0)
# 	/home/alex/go/pkg/mod/github.com/diadata-org/diadata@v1.4.148/pkg/dia/service/assetservice/source/uniswap.go:182 +0x36
# github.com/diadata-org/diadata/pkg/dia/service/assetservice/source.NewUniswapAssetSource.func1()
# 	/home/alex/go/pkg/mod/github.com/diadata-org/diadata@v1.4.148/pkg/dia/service/assetservice/source/uniswap.go:123 +0x25
# created by github.com/diadata-org/diadata/pkg/dia/service/assetservice/source.NewUniswapAssetSource
# 	/home/alex/go/pkg/mod/github.com/diadata-org/diadata@v1.4.148/pkg/dia/service/assetservice/source/uniswap.go:122 +0xdcb

sleep 1

# TODO: Make sure correct pairs to discover
./scripts/cluster-initial-service-pairDiscoveryService.sh "Bitfinex" "remoteFetch"
./scripts/cluster-initial-service-pairDiscoveryService.sh "Bittrex" "remoteFetch"
./scripts/cluster-initial-service-pairDiscoveryService.sh "CoinBase" "remoteFetch"
./scripts/cluster-initial-service-pairDiscoveryService.sh "Bitmax" "remoteFetch"
./scripts/cluster-initial-service-pairDiscoveryService.sh "KuCoin" "remoteFetch"
# ./scripts/cluster-initial-service-pairDiscoveryService.sh "MEXC" "remoteFetch"
# TODO: MEXC
# ERRO[0001] unmarshal symbols: json: cannot unmarshal array into Go struct field MEXCExchangeInfo.rateLimits of type string 
# ERRO[0001] fetching pairs from API for exchange MEXC: json: cannot unmarshal array into Go struct field MEXCExchangeInfo.rateLimits of type string 
# FATA[0001] update exchange pairs for MEXC: json: cannot unmarshal array into Go struct field MEXCExchangeInfo.rateLimits of type string 
# ./scripts/cluster-initial-service-pairDiscoveryService.sh "OKEx" "remoteFetch"
# TODO: OKEx
# ERRO[0001] fetching pairs from API for exchange OKEx: HTTP Response Error 503 
# FATA[0001] update exchange pairs for OKEx: HTTP Response Error 503 
# ./scripts/cluster-initial-service-pairDiscoveryService.sh "Kraken" "remoteFetch"
# TODO: Kraken
# ERRO[0000] fetching pairs from API for exchange Kraken: FetchAvailablePairs() not implemented 
# FATA[0000] update exchange pairs for Kraken: FetchAvailablePairs() not implemented 

sleep 1

./scripts/cluster-initial-service-pairDiscoveryService.sh "Bitfinex" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "Bittrex" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "CoinBase" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "MEXC" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "Bitmax" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "KuCoin" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "OKEx" "verification"
./scripts/cluster-initial-service-pairDiscoveryService.sh "Kraken" "verification"

sleep 1

./scripts/cluster-forward-kill.sh

sleep 1

kubectl create -f "pods/scraper-exchangescraper-bitfinex.yaml" \
-f "pods/scraper-exchangescraper-bittrex.yaml" \
-f "pods/scraper-exchangescraper-coinbase.yaml" \
-f "pods/scraper-exchangescraper-mexc.yaml" \
-f "pods/scraper-exchangescraper-bitmax.yaml" \
-f "pods/scraper-exchangescraper-kucoin.yaml" \
-f "pods/scraper-exchangescraper-okex.yaml" \
-f "pods/scraper-exchangescraper-kraken.yaml"

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