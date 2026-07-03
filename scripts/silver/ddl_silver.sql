-- ====================================================================
-- Project:   Bank Churn Analytics
-- Task:      Data Warehouse - Silver Layer Ingestion (BankChurners)
-- Developer: Yanolitics
-- Purpose:   Creates target destination tables for cleaned CRM, CBS, and 
--            The Central Financial Ledger (CFL) data layers.
-- WARNING:   Running this script drops existing tables and permanently 
--            deletes all data within them. Dev use only!
-- ====================================================================
USE BankChurnAnalytics; 
GO

-- ─── SECTION 1: TABLES ───────────────────────────────────────────

-- 1. Customer Info Table
IF OBJECT_ID('silver.crm_profiles', 'U') IS NOT NULL
    DROP TABLE silver.crm_profiles;
GO
CREATE TABLE silver.crm_profiles (
    CLIENTNUM INT NULL,
    Customer_Age INT NULL, 
    Gender NVARCHAR(10) NULL,
    Dependent_count INT NULL,
    Education_Level NVARCHAR(20) NULL,
    Marital_Status NVARCHAR(20) NULL,
    Contacts_Count_12_mon INT NULL
);
GO 
 
-- 2. Core Banking System (Credit Account Operations)
IF OBJECT_ID('silver.credit_accounts_ops', 'U') IS NOT NULL
    DROP TABLE silver.credit_accounts_ops;
GO
CREATE TABLE silver.credit_accounts_ops (
    CLIENTNUM INT NULL,                 
    Attrition_Flag NVARCHAR(50) NULL,   
    Card_Category NVARCHAR(20) NULL,    
    Income_Category NVARCHAR(20) NULL,  
    Months_on_book INT NULL,            
    Total_Relationship_Count INT NULL,  
    Months_Inactive_12_mon INT NULL     
);
GO

-- 3. The Central Financial Ledger
IF OBJECT_ID('silver.ledger_transactions', 'U') IS NOT NULL
    DROP TABLE silver.ledger_transactions;
GO
CREATE TABLE silver.ledger_transactions (
    CLIENTNUM INT NULL,
    Credit_Limit FLOAT NULL,
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
WHERE s.name = 'silver'
ORDER BY table_name;
GO
