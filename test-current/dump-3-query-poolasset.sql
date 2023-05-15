COPY (
    SELECT * FROM poolasset WHERE "time_stamp" >= now() - interval '48 hours'
) TO STDOUT WITH (format csv, delimiter ';');