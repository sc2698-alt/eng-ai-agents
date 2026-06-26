import duckdb
import pandas as pd
from datasets import load_dataset

print("Loading incremental COCO slice from Hugging Face...")

ds = load_dataset("phiyodr/coco2017", split="train[1%:2%]")
df = pd.DataFrame(ds)

output_path = "/data/local/coco_increment.parquet"
df.to_parquet(output_path)

con = duckdb.connect()
con.execute(open("sql/00_attach.sql").read())

before = con.sql("SELECT COUNT(*) FROM raw.coco").fetchone()[0]
print(f"raw.coco rows before: {before}")

con.execute("""
INSERT INTO raw.coco
SELECT * FROM read_parquet('/data/local/coco_increment.parquet');
""")

after = con.sql("SELECT COUNT(*) FROM raw.coco").fetchone()[0]
print(f"raw.coco rows after: {after}")

print(con.sql("FROM ducklake_snapshots('lake')"))
print("Incremental ingest complete.")