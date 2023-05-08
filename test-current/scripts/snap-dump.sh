#!/bin/bash

DB_NAME="postgres"
DB_USER="postgres"
#DB_PASSWORD="your_db_password"
DB_HOST="localhost"
DB_PORT="5432"

OUTPUT_FILE="db_dump.sql"
TABLE_NAMES=("exchangepair" "pool" "poolasset" "asset" "blockchain" "exchange")

rm $OUTPUT_FILE

# Export the filtered data for each table
#export PGPASSWORD=$DB_PASSWORD

for TABLE_NAME in "${TABLE_NAMES[@]}"; do
  echo "COPY (SELECT * FROM $TABLE_NAME WHERE created_at > current_date - interval '7 days') TO STDOUT WITH (FORMAT binary);" > filter_data.sql
  pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f - $DB_NAME -t $TABLE_NAME --file filter_data.sql >> $OUTPUT_FILE
  rm filter_data.sql
done

echo "Database dump created successfully with the last 7 days of data for multiple tables."