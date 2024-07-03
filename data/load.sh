#!/bin/sh

echo "loading schema"
psql -f /data/schema.sql
echo "loading data"
psql -c "SET session_replication_role = 'replica';"
psql -f /data/data.sql
psql -c "SET session_replication_role = 'origin';"
