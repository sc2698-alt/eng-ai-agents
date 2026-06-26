import os
import duckdb
from datasets import Dataset

HF_REPO = "samuel-carlos/ai-lakehouse-gold-coco"

con = duckdb.connect()
con.execute(open("sql/00_attach.sql").read())

df = con.sql("""
SELECT *
FROM gold.coco
""").df()

print(df.head())
print(f"Rows: {len(df)}")

ds = Dataset.from_pandas(df)
ds.push_to_hub(HF_REPO, token=os.environ["HF_TOKEN"])

print(f"Pushed gold.coco to https://huggingface.co/datasets/{HF_REPO}")