COPY (
    SELECT * FROM exchangepair where exchange in (
        select distinct name from exchange where centralized = true
    )
) TO STDOUT WITH (format csv, delimiter ';');