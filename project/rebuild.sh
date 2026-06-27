#!/usr/bin/env bash
set -e

echo "Starting containers..."
docker compose up -d

echo "Installing dependencies..."
docker compose exec lab pip install duckdb datasets pandas pyarrow boto3 pillow huggingface_hub

echo "Building local Parquet inputs..."
docker compose exec lab python notebooks/01_ingest_coco.py
docker compose exec lab python notebooks/02_ingest_visdrone.py

echo "Building DuckLake tables..."
docker compose exec -T lab python - <<'PY'
import duckdb

con = duckdb.connect()
con.execute(open("sql/00_attach.sql").read())
con.execute(open("sql/10_raw.sql").read())
con.execute(open("sql/20_silver.sql").read())
con.execute(open("sql/30_gold.sql").read())

print(con.sql("SELECT schema_name, table_name FROM duckdb_tables() ORDER BY schema_name, table_name"))
print(con.sql("FROM ducklake_snapshots('lake')"))
PY

echo "Rebuild complete."