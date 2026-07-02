-- ====================================================================
-- Project: Bank Churn Analytics
-- Task: Data Warehouse - Bronze Layer Ingestion (BankChurners)
-- Developer: Yanolitics
-- Purpose: Creates raw landing tables for CRM, CBS, and The Central Financial Ledger (CFL) CSV files.
-- WARNING: Running this script drops existing tables and permanently 
--          deletes all data within them. Dev use only!
-- ====================================================================

USE BankChurnAnalytics;
GO

-- ─── SECTION 1: TABLES ───────────────────────────────────────────

-- 1. Customer Info Table
IF OBJECT_ID('bronze.crm_profiles', 'U') IS NOT NULL
    DROP TABLE bronze.crm_profiles;
GO

CREATE TABLE bronze.crm_profiles (
    CLIENTNUM INT NULL,
    Customer_Age FLOAT NULL, -- Changed to FLOAT to safely accept pandas decimal formats (e.g., 45.0)
    Gender NVARCHAR(10) NULL,
    Dependent_count INT NULL,
    Education_Level NVARCHAR(20) NULL,
    Marital_Status NVARCHAR(20) NULL,
    Contacts_Count_12_mon INT NULL -- Removed the trailing comma here
);
GO 
    
-- 2. Core Banking System
IF OBJECT_ID('bronze.credit_accounts_ops', 'U') IS NOT NULL
    DROP TABLE bronze.credit_accounts_ops;
GO

CREATE TABLE bronze.credit_accounts_ops (
    CLIENTNUM INT,
    Attrition_Flag NVARCHAR(50),
    Card_Category NVARCHAR (20),
    Income_Category NVARCHAR (20),
    Months_on_book INT,
    Total_Relationship_Count INT,
    Months_Inactive_12_mon INT
 );
GO    

-- 3. The Central Financial Ledger
IF OBJECT_ID('bronze.ledger_transactions', 'U') IS NOT NULL
    DROP TABLE bronze.ledger_transactions;
GO

CREATE TABLE bronze.ledger_transactions (
    CLIENTNUM INT NULL,
    Credit_Limit NVARCHAR (50) NULL,
    Total_Revolving_Bal INT NULL,
    Avg_Open_To_Buy FLOAT NULL,
    Total_Trans_Amt INT NULL,
    Total_Trans_Ct INT NULL,
    Avg_Utilization_Ratio FLOAT NULL,
    Total_Amt_Chng_Q4_Q1 FLOAT NULL,
    Total_Ct_Chng_Q4_Q1 FLOAT NULL
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
