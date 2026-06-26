import pandas as pd
import random

rows = []

clips = ["clip_001.mp4", "clip_002.mp4", "clip_003.mp4"]

for clip in clips:
    for fragment_id in range(40):
        start_frame = fragment_id * 150
        end_frame = start_frame + 149
        start_time = fragment_id * 5.0
        end_time = start_time + 5.0
        n_objects = random.randint(5, 45)

        rows.append({
            "clip_uri": f"s3://lakehouse/assets/visdrone/{clip}",
            "fragment_id": fragment_id,
            "start_frame": start_frame,
            "end_frame": end_frame,
            "start_time": start_time,
            "end_time": end_time,
            "n_objects": n_objects,
            "classes": ["car", "pedestrian"] if n_objects <= 20 else ["car", "pedestrian", "bus"]
        })

df = pd.DataFrame(rows)

output_path = "/data/local/visdrone_raw.parquet"
df.to_parquet(output_path)

print(df.head())
print(f"Rows: {len(df)}")
print(f"Saved VisDrone fragment index to {output_path}")