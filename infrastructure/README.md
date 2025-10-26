# Infrastructure & Orchestration

This architecture diagram illustrates the **end-to-end data flow** implemented in the SkillCorner ETL project.  
It follows a **Medallion-style design** — progressing from raw ingested data through structured, validated, and aggregated layers to downstream consumption.

<p align="center">
  <img src="./Data_Flow_Architecture.png.png" alt="Data Flow Architecture" width="90%">
</p>

## Overview
- **Data Sources:** External feeds such as APIs, Cloud Storage, or streaming topics (e.g. Kafka).  
- **Raw Layer:** Stores extracted files in their native structure for traceability.  
- **Bronze Layer:** Normalised and minimally cleaned tables representing the canonical raw data.  
- **Silver Layer:** Joined, validated, and enriched datasets ready for analytics.  
- **Gold Layer:** Aggregated player and team metrics forming the analytical output.  
- **Downstream:** Data exports, dashboards, and applications consuming Gold outputs.  

## Cross-cutting Components
- **Data Cataloguing & Lineage:** Metadata tracking across Bronze → Gold layers.  
- **Orchestration:** Workflow scheduling and dependency management (e.g. notebook execution, future DAGs).  
- **Monitoring:** Logging and operational visibility for ingestion and transformation quality.  
