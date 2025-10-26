# SkillCorner ETL Project

## Overview
This project demonstrates a small-scale, local ETL pipeline using **Python**, **PySpark**, **Google Colab**, and local storage.  
It sources public football tracking data from the **SkillCorner OpenData GitHub repository**, performs ingestion, aggregation, validation, and visualisation to produce performance metrics for players and teams.

The notebook provides an end-to-end workflow following the *Raw → Bronze → Gold* model of the Medallion architecture.

---

## Dataset
This project uses data from the [SkillCorner OpenData repository](https://github.com/SkillCorner/opendata/tree/master/data), which includes multiple data sources across professional football matches.  
The data contains both **tracking** and **event-level** datasets in a mix of CSV, JSON, and JSONL formats.

Key datasets include:
- `dynamic_events`: event-level actions such as passes, sprints, and shots  
- `phases_of_play`: team possession and tactical phases  
- `physicalaggregates`: player movement summaries  
- `match`: match metadata (teams, players, pitch dimensions)  
- `tracking_extrapolated`: tracking coordinates and player positions  

---

## ETL Flow and Key Features
The notebook follows a **Medallion-style ETL pipeline** consisting of the following stages:

### 1. Raw → Bronze
- Downloads raw SkillCorner datasets directly from the GitHub API  
- Handles **Git LFS** (large file storage) pointer resolution  
- Writes structured **Bronze Parquet tables** with added metadata (`source_file`, `ingested_at`)  
- Modular ingestion logic via `APIClient` and `run_github_ingestion()`  

### 2. Bronze → EDA
- Performs exploratory analysis to validate schemas, record counts, and event types  
- Validates data ranges and missing fields (e.g., pitch dimensions, player IDs)  
- Uses optional **YData Profiling** to quickly profile each dataset  

### 3. Bronze → Gold
- Aggregates key **player and team performance metrics**, including:
  - **Sprinting metrics:** durations, distances, and counts per player  
  - **Passing metrics:** completion %, xThreat, forward % and shots created  
  - **Shooting metrics:** shot distances, goals, conversion rates, and header ratios  
- Produces a **final player-level dataset** combining sprinting, passing, and shooting outputs  

### 4. Validation and Visualisation
- Lightweight **data validation framework** for nulls, negatives, duplicates, and percentage ranges  
- Simple visualisations for insight:
  - Median sprint duration by player  
  - xThreat by field third  
  - Team shooting volume vs conversion rate  

### Utility Features
- Modular helper functions:
  - `APIClient` – generic, retryable, parallelised HTTP client  
  - `run_github_ingestion()` – reusable GitHub ingestion workflow  
  - `aggregate_metrics()` – reusable Spark aggregation  
  - `pct()` – safe percentage computation  
  - `save_to_csv()` – standardised CSV export  
  - `validate_gold_df()` – configurable validation for Gold tables  

---

## How to Run
This notebook runs entirely in **Google Colab**, with no external dependencies beyond those installed in the notebook.

**Steps:**
1. Open `SkillCorner_ETL.ipynb` in Google Colab  
2. Run all cells sequentially  
3. Data will be downloaded to `/content/data/raw/`  
4. Bronze tables and exports are created in:
   - `/content/data/bronze/`  
   - `/content/data/outputs/`  
   - `/exports/`

---

## Project Outputs
| Deliverable | File | Description |
|--------------|------|--------------|
| Notebook | `notebooks/SkillCorner_ETL.ipynb` | End-to-end ETL notebook |
| Final CSV | `exports/player_aggregated_metrics.csv` | Combined player metrics (sprints, passes, shots) |
| Mock IaC | `infrastructure/*.tf` | Simulated S3 IaC | Update this
| Diagram | `infrastructure/Data_Flow_Architecture.png` | Pipeline architecture diagram |

---

## Production Considerations
The notebook demonstrates a **self-contained, local ETL process** for demonstration purposes, but in a production data platform each stage would be modularised, orchestrated, and cloud-hosted for scalability and reliability.

| Aspect | Current Implementation (Notebook) | Production Equivalent |
|--------|------------------------------------|------------------------|
| **Execution Environment** | Runs entirely in Google Colab with local storage (`/content/data`) | Deployed to cloud compute (e.g. EMR, Databricks, Glue, etc.) |
| **Ingestion** | Parallel GitHub API extraction using `APIClient` and `run_github_ingestion()` | Cloud-based ingestion via Lambda, Step Functions, or Glue Jobs pulling from APIs or S3 |
| **Storage Layers** | Local directory structure (`raw`, `bronze`, `outputs`) | Cloud object storage with medallion layers (e.g. S3 or ADLS: `/raw`, `/bronze`, `/silver`, `/gold`) |
| **Schema Management** | Dynamic schema inference on read | Central schema registry (Glue Catalog, Delta, or Iceberg) with versioned schema definitions |
| **Transformation Engine** | Single SparkSession running on one Colab instance | Distributed Spark / Databricks cluster with autoscaling and workload scheduling |
| **Incremental Loads** | Full reload on each execution | Incremental ingestion using change tracking and metadata checkpoints |
| **Validation** | Inline assertions and profiling (e.g. `assert_no_nulls`, `validate_gold_df`, optional YData Profiling) | Automated data quality frameworks (e.g. Great Expectations) with CI/CD hooks |
| **Orchestration** | Sequential execution within notebook cells | Managed orchestration via Airflow, Dagster, Step Functions, or Databricks Workflows |
| **Monitoring & Logging** | Console print statements | Structured logs and metrics sent to CloudWatch, Datadog, or similar |
| **Visualisation** | Inline Matplotlib and Seaborn charts for ad-hoc EDA | Automated dashboard generation (e.g. Streamlit, Power BI, etc.) |
| **CI/CD & Infrastructure** | Manual setup and execution in Colab | IaC-managed deployment (Terraform) and automated testing in CI/CD pipelines |

---

## Author
**Matthew Dougherty** 

## Notes on Documentation
Portions of this documentation were assisted by AI (ChatGPT, OpenAI GPT-5) for the purposes of drafting and refinement.