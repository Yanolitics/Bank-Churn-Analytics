-- ====================================================================
-- Project: Bank Churn Analytics
-- Task: Data Warehouse - Bronze Layer Ingestion (BankChurners)
-- Developer: Yanolitics
-- Purpose: Creates raw landing table for file BankChurner.
-- WARNING: Running this script drops existing tables and permanently 
--          deletes all data within them. Dev use only!
-- ====================================================================

USE BankChurnAnalytics;
GO

-- ─── SECTION 1: CRM TABLES ───────────────────────────────────────────

-- 1. Customer Info Table
IF OBJECT_ID('bronze.bankchurners', 'U') IS NOT NULL
    DROP TABLE bronze.bankchurners;
GO

CREATE TABLE bronze.bankchurners (
    CLIENTNUM INT,
    Attrition_Flag NVARCHAR(50),
    Customer_Age INT,
    Gender NVARCHAR(10),
    Dependent_count INT,
    Education_Level NVARCHAR (20),
    Marital_Status NVARCHAR (20),
    Income_Category NVARCHAR (20),
    Card_Category NVARCHAR (20),
    Months_on_book INT,
    Total_Relationship_Count INT,
    Months_Inactive_12_mon INT,
    Contacts_Count_12_mon INT,
    Credit_Limit FLOAT,
    Total_Revolving_Bal INT,
    Avg_Open_To_Buy FLOAT,
    Total_Amt_Chng_Q4_Q1 FLOAT,
    Total_Trans_Amt INT,
    Total_Trans_Ct INT,
    Total_Ct_Chng_Q4_Q1 FLOAT,
    Avg_Utilization_Ratio FLOAT
);
GO


-- ─── SECTION 2: VERIFICATION AUDIT ──────────────────────────────────

SELECT 
    s.name AS schema_name, 
    t.name AS table_name,
    t.create_date
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'bronze'
ORDER BY table_name;
GO
