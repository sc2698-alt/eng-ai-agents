#!/usr/bin/env bash
set -e

echo "Removing old DuckLake catalog..."
rm -f metadata.ducklake metadata.ducklake.wal metadata.ducklake.tmp

echo "Starting containers..."
docker compose up -d

echo "Installing dependencies..."
docker compose exec -T lab pip install duckdb datasets pandas pyarrow boto3 pillow huggingface_hub

echo "Creating lakehouse bucket if needed..."
docker compose exec -T lab python - <<'PY'
import boto3
from botocore.exceptions import ClientError

s3 = boto3.client(
    "s3",
    endpoint_url="http://rustfs:9000",
    aws_access_key_id="rustfsadmin",
    aws_secret_access_key="rustfsadmin",
)

bucket = "lakehouse"

try:
    s3.head_bucket(Bucket=bucket)
    print(f"Bucket already exists: {bucket}")
except ClientError:
    s3.create_bucket(Bucket=bucket)
    print(f"Created bucket: {bucket}")
PY

echo "Building local Parquet inputs..."
docker compose exec -T lab python notebooks/01_ingest_coco.py
docker compose exec -T lab python notebooks/02_ingest_visdrone.py

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