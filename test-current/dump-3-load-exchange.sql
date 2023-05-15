\COPY exchange FROM '/postgres-dump/dump-3-exchange_cex.csv' WITH (FORMAT csv, DELIMITER ';');
\COPY exchange FROM '/postgres-dump/dump-3-exchange_dex.csv' WITH (FORMAT csv, DELIMITER ';');