from datasets import load_dataset
import pandas as pd

print("Loading COCO dataset...")

ds = load_dataset("phiyodr/coco2017", split="train[:1%]")

print("Converting to dataframe...")
df = pd.DataFrame(ds)

print(df.head())

output_path = "/data/local/coco_raw.parquet"
df.to_parquet(output_path)

print(f"Saved to {output_path}")