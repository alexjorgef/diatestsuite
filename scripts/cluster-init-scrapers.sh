#!/usr/bin/env bash

echo "Cleaning and stopping cluster forwards..."
kill -9 "$(cat .pid-forward-db-postgres)"
kill -9 "$(cat .pid-forward-db-redis)"
kill -9 "$(cat .pid-forward-db-influx)"

# TODO: only forward when pod is ready
./scripts/cluster-forward.sh

sleep 2

# TODO: Make sure if this is all assets
./scripts/cluster-initial-assetCollectionService.sh "Uniswap" ""
./scripts/cluster-initial-assetCollectionService.sh "SushiSwap" ""
./scripts/cluster-initial-assetCollectionService.sh "PanCakeSwap" ""
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "eth_assets"
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "non_eth_assets"
./scripts/cluster-initial-assetCollectionService.sh "assetlists" "fiat_assets"

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