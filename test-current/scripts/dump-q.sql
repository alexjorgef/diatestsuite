-- TODO

-- CEX Scrapers:
--   exchangepair
-- DEX Scrapers:
--   pool, poolasset
-- Assets:
--   asset, blockchain, exchange

-- Decentralized exchanges
SELECT * FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours';
SELECT * FROM pool WHERE pool_id IN (
	SELECT DISTINCT pool_id FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours'
);
SELECT * FROM asset WHERE asset_id IN (
	SELECT DISTINCT asset_id FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours'
);
SELECT * FROM blockchain WHERE "name" IN (
	SELECT DISTINCT blockchain FROM asset WHERE asset_id IN (
		SELECT DISTINCT asset_id FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours'
	)
);
SELECT * FROM exchange WHERE "name" IN (
	SELECT distinct exchange FROM pool WHERE pool_id IN (
		SELECT DISTINCT pool_id FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours'
	)
);

-- Centralized exchanges
SELECT * FROM exchange WHERE centralized = true;
SELECT * FROM exchangepair where exchange in (
	select distinct name from exchange where centralized = true
);

-- Foreign keys are wrong?
SELECT * FROM blockchain WHERE "nativetoken_id" IN (
	SELECT DISTINCT asset_id FROM asset WHERE asset_id IN (
		SELECT DISTINCT asset_id FROM poolasset WHERE "time_stamp" >= now() - interval '25 hours'
	)
);