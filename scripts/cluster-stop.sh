#!/usr/bin/env bash
kubectl delete -f "pods/db-influx.yaml" \
-f "pods/db-redis.yaml" \
-f "pods/db-postgres.yaml" \
-f "pods/db-kafka.yaml" \
-f "pods/db-zookeeper.yaml"
kubectl delete -f "pods/service-tradesblockservice.yaml" \
-f "pods/service-filtersblockservice.yaml"
kubectl delete -f "pods/scraper-exchangescraper-bitfinex.yaml" \
-f "pods/scraper-exchangescraper-bittrex.yaml" \
-f "pods/scraper-exchangescraper-coinbase.yaml" \
-f "pods/scraper-exchangescraper-mexc.yaml" \
-f "pods/scraper-exchangescraper-dfyn.yaml" \
-f "pods/scraper-exchangescraper-bitmax.yaml" \
-f "pods/scraper-exchangescraper-crex24.yaml" \
-f "pods/scraper-exchangescraper-hitbtc.yaml" \
-f "pods/scraper-exchangescraper-loopring.yaml" \
-f "pods/scraper-exchangescraper-uniswap.yaml" \
-f "pods/scraper-exchangescraper-uniswapv3.yaml" \
-f "pods/scraper-exchangescraper-sushiswap.yaml" \
-f "pods/scraper-exchangescraper-kucoin.yaml" \
-f "pods/scraper-exchangescraper-stex.yaml" \
-f "pods/scraper-exchangescraper-okex.yaml" \
-f "pods/scraper-exchangescraper-kraken.yaml" \
-f "pods/scraper-exchangescraper-zb.yaml" \
-f "pods/scraper-exchangescraper-quoine.yaml" \
-f "pods/scraper-exchangescraper-bitbay.yaml"