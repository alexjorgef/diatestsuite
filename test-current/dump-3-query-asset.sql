COPY (
    SELECT * FROM asset WHERE asset_id IN (
        SELECT DISTINCT asset_id FROM poolasset WHERE "time_stamp" >= now() - interval '48 hours'
    )
) TO STDOUT WITH (format csv, delimiter ';');