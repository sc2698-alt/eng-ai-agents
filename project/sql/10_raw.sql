CREATE OR REPLACE TABLE raw.coco AS
SELECT * FROM read_parquet('/data/local/coco_raw.parquet');

CREATE OR REPLACE TABLE raw.visdrone AS
SELECT * FROM read_parquet('/data/local/visdrone_raw.parquet');