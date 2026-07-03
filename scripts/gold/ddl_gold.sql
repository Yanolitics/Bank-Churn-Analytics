-- ====================================================================
-- Project:     Bank Churn Analytics
-- Task:        Data Warehouse - Gold Layer (Dimensional Modeling)
-- Developer:   Yanolitics
-- Purpose:     Conformed Star Schema Deployment Script (Dimensions & Facts)
-- Strategy:    Clean Slate Drop followed by full DDL initialization
-- ====================================================================
USE BankChurnAnalytics;
GO

PRINT '======================================================================';
PRINT '         CLEANING EXISTING GOLD LAYER VIEWS (CRITICAL ORDER)          ';
PRINT '======================================================================';

-- STEP 1: Drop Fact tables first to break relational dependencies
PRINT '>> Dropping View if exists: gold.fact_transactions';
DROP VIEW IF EXISTS gold.fact_transactions;

-- STEP 2: Safe to drop Parent Dimension tables now
PRINT '>> Dropping View if exists: gold.dim_customer';
DROP VIEW IF EXISTS gold.dim_customer;
GO

PRINT '======================================================================';
PRINT '         INITIALIZING GOLD LAYER VIEWS DEPLOYMENT                     ';
PRINT '======================================================================';

-- ─── VIEW 1: CUSTOMER CONFORMED DIMENSION ───────────────────────────
PRINT '>> Creating View: gold.dim_customer';
GO

CREATE OR ALTER VIEW gold.dim_customer AS
SELECT
    -- Unique Identifier
    cp.CLIENTNUM,
    
    -- Customer Demographics
    cp.Customer_Age,
    cp.Gender,
    cp.Dependent_count,
    cp.Education_Level,
    cp.Marital_Status,
    
    -- Account Operational Metadata
    ca.Attrition_Flag,
    ca.Card_Category,
    ca.Income_Category,
    ca.Months_on_book,
    ca.Total_Relationship_Count,
    ca.Months_Inactive_12_mon,
    
    -- Behavioral Touchpoints
    cp.Contacts_Count_12_mon
FROM silver.crm_profiles cp
LEFT JOIN silver.credit_accounts_ops ca 
    ON cp.CLIENTNUM = ca.CLIENTNUM;
GO

-- ─── VIEW 2: LEDGER TRANSACTION CONFORMED FACT ────────────────────────────
PRINT '>> Creating View: gold.fact_transactions';
GO

CREATE OR ALTER VIEW gold.fact_transactions AS
SELECT
    -- Key Linkages
    CLIENTNUM,
    
    -- Financial Parameters & Limits
    Credit_Limit,
    Avg_Open_To_Buy,
    Avg_Utilization_Ratio,
    
    -- Balance Snapshots
    Total_Revolving_Bal,
    
    -- Activity Metrics (Volumes & Counts)
    Total_Trans_Amt,
    Total_Trans_Ct,
    
    -- Velocity Performance Metrics (Q4 vs Q1 Changes)
    Total_Amt_Chng_Q4_Q1,
    Total_Ct_Chng_Q4_Q1
FROM silver.ledger_transactions;
GO

PRINT '======================================================================';
PRINT '         GOLD LAYER DIMENSIONAL VIEWS DEPLOYED SUCCESSFULLY           ';
PRINT '======================================================================';
