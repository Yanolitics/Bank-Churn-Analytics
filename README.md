# 📈 Bank Churn & Customer Behavioral Analytics Project

Welcome to my customer analytics repository! This project presents an end-to-end data pipeline and business intelligence solution designed to analyze, model, and visualize customer attrition within the retail banking sector. 

Operating under the moniker **Yanolitics**, I developed this project to demonstrate how raw transactional and operational customer data can be transformed into high-impact, diagnostic business assets using **SQL Server (T-SQL)** and **Power BI**.

---

## 🗺️ High-Level Project Workflow

The project follows a rigorous, decoupled data workflow to ensure data integrity, clean transformation tracking, and optimal dashboard performance:
[Raw Banking Logs] ➔ [SQL Server Ingestion] ➔ [T-SQL Feature Engineering] ➔ [Power BI Semantic Model] ➔ [Executive Dashboard]

---

## 🛠️ Stage-by-Step Project Breakdown

### 1. Database Initialization & Data Ingestion
* **Purpose:** Setting up the dedicated relational database environment and loading raw customer records.
* **Database Engine:** Microsoft SQL Server (T-SQL).
* **Ingestion Strategy:** Safe batch loading of raw source files into physical staging tables, ensuring exact data type casting and structure optimization.

--```markdown
<!-- Image Placeholder for SQL Server Schema / Object Explorer -->
![Database Schema Ingestion Layout](images/sql_database_setup.png)

### 2. Advanced Data Transformation & Feature Engineering
* **Purpose:** Converting raw transactional records into clean business performance indicators. Advanced T-SQL scripting was leveraged to build optimized analytical views.
* **Core SQL Techniques Applied:**
* ***Common Table Expressions (CTEs):** Used to isolate, aggregate, and contrast historical quarterly transaction metrics.

Defensive Calculation Logic: Implemented math boundaries to protect calculations against dividing-by-zero errors.

Risk-Tier Segmentations: Developed conditional CASE WHEN structures to categorize continuous customer activities into risk-stratified operational buckets (e.g., support call counts, inactivity durations).
