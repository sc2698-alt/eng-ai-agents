CREATE OR REPLACE TABLE gold.coco AS
SELECT
    file_name,
    caption,
    license,
    CASE
        WHEN license <= 3 THEN 'train'
        ELSE 'eval'
    END AS split
FROM silver.coco;

CREATE OR REPLACE TABLE gold.visdrone AS
SELECT
    clip_uri,
    fragment_id,
    start_frame,
    end_frame,
    n_objects,
    n_frames,
    duration_seconds,
    CASE
        WHEN n_objects > 20 THEN 'busy'
        ELSE 'normal'
    END AS fragment_label
FROM silver.visdrone;