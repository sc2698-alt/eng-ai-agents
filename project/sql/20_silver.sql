CREATE OR REPLACE TABLE silver.coco AS
SELECT
    file_name,
    coco_url,
    captions[1] AS caption,
    ids,
    license
FROM raw.coco;

CREATE OR REPLACE TABLE silver.visdrone AS
SELECT
    clip_uri,
    fragment_id,
    start_frame,
    end_frame,
    start_time,
    end_time,
    n_objects,
    classes,
    end_frame - start_frame + 1 AS n_frames,
    end_time - start_time AS duration_seconds
FROM raw.visdrone
WHERE clip_uri IS NOT NULL
  AND n_objects IS NOT NULL;