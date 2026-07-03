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
<img width="16384" height="3166" alt="BankChurnAnalytics drawio" src="https://github.com/user-attachments/assets/26c98f22-3fde-4e57-8afb-268b451c0a09" />


### 2. Advanced Data Transformation & Feature Engineering
* **Purpose:** Converting raw transactional records into clean business performance indicators. Advanced T-SQL scripting was leveraged to build optimized analytical views.
* **Core SQL Techniques Applied:**
    *   **Common Table Expressions (CTEs):** Used to isolate, aggregate, and contrast historical quarterly transaction metrics.
    *   **Defensive Calculation Logic:** Implemented math boundaries to protect calculations against dividing-by-zero errors.
    *   **Risk-Tier Segmentations:** Developed conditional CASE WHEN structures to categorize continuous customer activities into risk-stratified operational buckets (e.g., support call counts, inactivity durations).
 
<!-- Image Placeholder for T-SQL Code / Stored Procedure Script -->
![T-SQL Feature Engineering Script](images/tsql_transformation_query.png)

### 3. Power BI Data Modeling (The Semantic Layer)
* **Purpose:** Establishing an optimized relational star schema inside Power BI Desktop to facilitate blazing-fast reporting and accurate data calculations.
* **Modeling Strategies Applied:**
    *   **Star Schema Architecture:** Separated core customer metrics into a central Fact Table flanked by optimized Dimension Tables.
    *   **Advanced DAX Metrics:** Engineered explicit measures to calculate real-time portfolio counts, churned customer volumes, and dynamic percentage margins.
    *   **Filter Context Customization:** Tailored visual cross-filtering and cross-highlighting interaction parameters to ensure clean data exploration.

<!-- Image Placeholder for Power BI Relationship Model View -->
![Power BI Star Schema Data Model](images/powerbi_data_model.png)

### 4. Consume Layer: Interactive Executive Dashboard
* **Purpose:** Serving visual intelligence to executives, operational leads, and cross-functional teams to drive customer preservation strategies.
* **Visual Interface Modules:**
    *   **Executive KPI Scoreboard:** High-level summary displaying overall portfolio scale and the baseline churn metric.
    *   **Financial Velocity Table:** Tracks behavioral drop-offs across historical spending patterns and card usage frequencies.
    *   **Product Category Risk Profile:** Isolates structural vulnerability across the bank's card tiers (Blue, Silver, Gold, Platinum).
    *   **Inactivity Danger Zone Analysis:** Pinpoints the exact month customer dormancy transitions into permanent attrition.
    *   **Customer Friction Meter:** Directly measures the quantitative relationship between repeated helpdesk tickets and portfolio leakage.
 
<!-- Image Placeholder for the Final Dashboard Visual Layout -->
![Bank Churn Analytics Executive Dashboard](images/bca_dashboard_layout.png)

---

## 📊 Strategic Business Insights Uncovered

Through deep data exploration, this project uncovered critical diagnostic behavior patterns that can be translated directly into corporate defensive actions:

🚨 The 0.59 Velocity "Tripwire": Healthy, active accounts maintain a baseline transaction count ratio near 0.74. However, historical records reveal that churned customers drop down to a 0.59 transaction velocity right before they leave. This metric serves as a predictable early-warning indicator for the customer relationship team.

* **Premium Tier Vulnerability:** Attrition is hitting our most profitable segments hardest. While entry-level tiers remain highly stable, Platinum cardholders suffer a massive 25.00% churn rate and Gold tiers sit at 20.69%, directly threatening fee-based revenue.
* **The Month 4 Retention Cliff:** Account dormancy features a massive retention drop-off peaking exactly at 4 months of inactivity (~29% churn). Marketing re-engagement campaigns must intervene during Month 2 or 3 to effectively disrupt this drop-off.
* **Support Friction Caps:** Customer helpdesk lines are acting as churn accelerators. While the bank safely handles up to 2 calls, hitting 4 support contacts spikes churn to nearly 38%, and reaching 6 contacts represents a near-certain 90% cancellation rate.

---

## ⚡ Tech Stack & Core Concepts Demonstrated

* **Query Engine:** Microsoft SQL Server (T-SQL)
* **Analytics & BI Platform:** Power BI Desktop
* **Modeling Paradigms:** Star Schema, Feature Engineering, Common Table Expressions (CTEs), Filter Context, DAX Measure Engineering.
* **Core Business Domains:** Retail Banking, Portfolio Risk Management, Customer Churn Mitigation, Operational Performance Optimization.

---

## 👨‍💻 About the Developer

I’m Timothy, a certified data analyst with a deep background in managing rigid data structures and corporate compliance within the financial sector. I pivoted into data analytics because I am passionate about engineering reliable data solutions, unraveling complex business problems, and delivering clear, actionable metrics to stakeholders.

I thrive on building optimized models, writing clean documentation, and creating intuitive visual architectures that help business leaders make rapid, data-backed operational decisions.
