#!/bin/bash

# Set your database connection details
DB_NAME="your_db_name"
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
DB_HOST="your_db_host"
DB_PORT="your_db_port"

# Set the output file name
OUTPUT_FILE="db_dump.sql"

# Set the table names you want to filter
TABLE_NAMES=("exchangepair" "pool" "poolasset" "asset" "blockchain" "exchange") # Add more table names as needed

# Empty the output file
$OUTPUT_FILE

# Export the filtered data for each table
export PGPASSWORD=$DB_PASSWORD

for TABLE_NAME in "${TABLE_NAMES[@]}"; do
  # Create a temporary SQL file for filtering the data
  echo "COPY (SELECT * FROM $TABLE_NAME WHERE created_at > current_date - interval '7 days') TO STDOUT WITH (FORMAT binary);" > filter_data.sql

  # Append the filtered data to the output file
  pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f - $DB_NAME -t $TABLE_NAME --file filter_data.sql >> $OUTPUT_FILE

  # Clean up the temporary SQL file
  rm filter_data.sql
done

echo "Database dump created successfully with the last 7 days of data for multiple tables."