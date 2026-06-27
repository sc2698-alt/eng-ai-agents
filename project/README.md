# AI Lakehouse Project

## Overview

This project demonstrates the construction of a simple AI lakehouse using DuckDB, DuckLake, and RustFS. The pipeline ingests data from Hugging Face, stores it in a medallion architecture, raw → silver → gold, tracks changes through DuckLake snapshots, and publishes a processed dataset back to Hugging Face.

Datasets used:

* COCO 2017 image captions
* Simulated VisDrone video fragment index

---

## Project Structure

```
project/
├── docker-compose.yml
├── rebuild.sh
├── notebooks/
├── sql/
└── README.md
```

* `docker-compose.yml` starts RustFS and the DuckDB environment.
* `notebooks/` contains the data ingestion and Hugging Face scripts.
* `sql/` contains the SQL transformations for the raw, silver, and gold layers.
* `rebuild.sh` recreates the lakehouse from scratch.

---

## Requirements

* Docker
* Docker Compose

Create a `.env` file containing your Hugging Face access token:

```
HF_TOKEN=your_token_here
```

The `.env` file is ignored by Git and should not be committed.

---

## Rebuilding the Lakehouse

To recreate the entire project from an empty environment, run:

```bash
./rebuild.sh
```

The rebuild script will:

1. Start the Docker containers.
2. Install the required Python packages.
3. Download the COCO dataset.
4. Generate the VisDrone fragment index.
5. Build the raw, silver, and gold DuckLake tables.
6. Print the available tables and current snapshot history.

---

## Hugging Face Round-Trip

After rebuilding the lakehouse, the Gold COCO dataset can be published back to Hugging Face using:

```bash
python notebooks/03_push_gold_to_hf.py
```

Published dataset:

https://huggingface.co/datasets/samuel-carlos/ai-lakehouse-gold-coco

---

## Features

* RustFS object storage
* DuckLake catalog and snapshot versioning
* Raw, silver, and gold medallion architecture
* COCO metadata ingestion
* VisDrone fragment indexing
* Time travel queries
* Snapshot rollback
* Incremental ingestion
* Hugging Face dataset publishing

---

## Author

Samuel Carlos
