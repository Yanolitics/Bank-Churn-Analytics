-- ====================================================================
-- Project:     Bank Churn Analytics
-- Task:        Data Warehouse - Silver Ingestion Pipeline (Full Load)
-- Developer:   Yanolitics
-- Purpose:     Cleanse, deduplicate, and transform raw Bronze layer tables.
-- Strategy:    Truncate & Insert (As per design architecture)
-- WARNING:     Truncates all destination tables before importing data.
-- ====================================================================
USE BankChurnAnalytics;
GO

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        SET NOCOUNT ON; -- Prevents internal row-count messages from cluttering your custom log

        PRINT '======================================================================';
        PRINT '                    LOADING SILVER LAYER PIPELINE                     ';
        PRINT '======================================================================';
    
        -- ─── SECTION 1: CRM TRANSFORMATIONS ──────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 1: CRM TRANSFORMATIONS';
        PRINT '----------------------------------------------------------------------';

        -- 1. Load CRM Customer Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Transforming: silver.crm_profiles';
        TRUNCATE TABLE silver.crm_profiles;
        
        INSERT INTO silver.crm_profiles (
            CLIENTNUM,
            Customer_Age,
            Gender,
            Dependent_count,
            Education_Level,
            Marital_Status,
            Contacts_Count_12_mon
        )
        SELECT
            CLIENTNUM,
            CAST(
                CASE 
                    WHEN Customer_Age > 100 THEN NULL
                    WHEN Customer_Age <= 18 THEN NULL
                    ELSE Customer_Age
                END 
            AS INT) AS Customer_Age,
            CASE WHEN TRIM(UPPER(Gender)) IN ('MALE','M') THEN 'M'
                WHEN TRIM(UPPER(Gender)) IN ('FEMALE', 'F') THEN 'F'
                ELSE 'N/A'
            END AS Gender,
            Dependent_count,
            Education_Level,
            CASE WHEN TRIM(UPPER(Marital_Status)) IN ('N/A', 'UNKNOWN') THEN 'Unknown'
                ELSE TRIM(Marital_Status)
            END AS Marital_Status,
            Contacts_Count_12_mon 
        FROM bronze.crm_profiles;

        PRINT '>> SUCCESS: silver.crm_profiles loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------------------------------';


        -- ─── SECTION 2: CREDIT ACCOUNTS TRANSFORMATIONS ──────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 2: CREDIT ACCOUNTS OPERATIONS TRANSFORMATIONS';
        PRINT '----------------------------------------------------------------------';

        -- 2. Load Credit Accounts Ops
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Transforming: silver.credit_accounts_ops';
        TRUNCATE TABLE silver.credit_accounts_ops;

        INSERT INTO silver.credit_accounts_ops (
            CLIENTNUM,
            Attrition_Flag,
            Card_Category,
            Income_Category,
            Months_on_book,
            Total_Relationship_Count,
            Months_Inactive_12_mon
        )
        SELECT
            CLIENTNUM,
            CASE WHEN TRIM(UPPER(Attrition_Flag)) IN('ATTRITED', 'ATTRITED CUSTOMER') THEN 'Attrited Customer'
                WHEN TRIM(UPPER(Attrition_Flag)) IN('EXISTING', 'EXISTING CUSTOMER') THEN 'Existing Customer'
                ELSE TRIM(Attrition_Flag)
            END AS Attrition_Flag,
            Card_Category,
            Income_Category,
            Months_on_book,
            Total_Relationship_Count,
            Months_Inactive_12_mon
        FROM (
            SELECT *, ROW_NUMBER() OVER(PARTITION BY CLIENTNUM ORDER BY CLIENTNUM) AS CN FROM bronze.credit_accounts_ops
        ) t
        WHERE CN = 1;
            
        PRINT '>> SUCCESS: silver.credit_accounts_ops loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------------------------------';


        -- ─── SECTION 3: CFL TRANSFORMATIONS ──────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 3: CENTRAL FINANCIAL LEDGER TRANSFORMATIONS';
        PRINT '----------------------------------------------------------------------';

        -- 3. Load Ledger Transactions
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Transforming: silver.ledger_transactions';
        TRUNCATE TABLE silver.ledger_transactions;

        INSERT INTO silver.ledger_transactions (
            CLIENTNUM,
            Credit_Limit,
            Total_Revolving_Bal,
            Avg_Open_To_Buy,
            Total_Trans_Amt,
            Total_Trans_Ct,
            Avg_Utilization_Ratio,
            Total_Amt_Chng_Q4_Q1,
            Total_Ct_Chng_Q4_Q1
        )
        SELECT
	        CLIENTNUM,
	        TRY_CAST(
                CASE 
                    WHEN Credit_Limit LIKE 'ERR_VAL' THEN NULL
                    WHEN Credit_Limit LIKE '$%' AND Credit_Limit LIKE '%,%' THEN REPLACE(REPLACE(Credit_Limit, '$', ''),',','')
                    WHEN Credit_Limit LIKE '$%' THEN REPLACE(Credit_Limit, '$', '')
                    ELSE Credit_Limit
                END 
            AS FLOAT) AS Credit_Limit,
            Total_Revolving_Bal,
            Avg_Open_To_Buy,
            Total_Trans_Amt,
            Total_Trans_Ct,
            Avg_Utilization_Ratio,
            Total_Amt_Chng_Q4_Q1,
            Total_Ct_Chng_Q4_Q1
        FROM bronze.ledger_transactions;

        PRINT '>> SUCCESS: silver.ledger_transactions loaded.'; -- Fixed string typo
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------------------------------';

        PRINT '';
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT 'OVERALL LOAD DURATION';
        SET @batch_end_time = GETDATE();
        PRINT '>> Total Operational Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '----------------------------------------------------------------------';


        -- ─── SECTION 4: QUALITY CHECK & VERIFICATION AUDIT ──────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 4: QUALITY CHECK & VERIFICATION AUDIT';
        PRINT '----------------------------------------------------------------------';
        
        -- Volume Profile Snapshot
        SELECT 'silver.crm_profiles' AS table_name, COUNT(*) AS total_rows_retained FROM silver.crm_profiles
        UNION ALL
        SELECT 'silver.credit_accounts_ops', COUNT(*) FROM silver.credit_accounts_ops
        UNION ALL
        SELECT 'silver.ledger_transactions', COUNT(*) FROM silver.ledger_transactions;

        PRINT '';
        PRINT '>> Reviewing detailed data clean-up assertions...';
        
        -- Diagnostic Error Report Tracking
        SELECT 'crm_profiles' AS profiling_target, 'Nullified Invalid Customer Ages' AS metrics, 
            SUM(CASE WHEN Customer_Age IS NULL THEN 1 ELSE 0 END) AS issue_count FROM silver.crm_profiles
        UNION ALL
        SELECT 'crm_profiles', 'Unmapped Out-of-Scope Genders (N/A)', 
            SUM(CASE WHEN Gender = 'N/A' THEN 1 ELSE 0 END) FROM silver.crm_profiles
        UNION ALL
        SELECT 'credit_accounts_ops', 'Unstandardized Attrition Flags Remaining', 
            SUM(CASE WHEN Attrition_Flag NOT IN ('Attrited Customer', 'Existing Customer') THEN 1 ELSE 0 END) FROM silver.credit_accounts_ops
        UNION ALL
        SELECT 'ledger_transactions', 'Nullified Financial Credit Limits (ERR_VAL)', 
            SUM(CASE WHEN Credit_Limit IS NULL THEN 1 ELSE 0 END) FROM silver.ledger_transactions;

        PRINT '';
        PRINT '======================================================================';
        PRINT '               SILVER LAYER LOAD COMPLETED SUCCESSFULLY               ';
        PRINT '======================================================================';
    END TRY
    BEGIN CATCH
        PRINT '======================================================================';
        PRINT '        ERROR OCCURRED DURING LOADING SILVER LAYER PIPELINE           ';
        PRINT '======================================================================';
        PRINT CONCAT('Error Message  : ', ERROR_MESSAGE());
        PRINT CONCAT('Error Number   : ', ERROR_NUMBER());
        PRINT CONCAT('Error Severity : ', ERROR_SEVERITY());
        PRINT CONCAT('Error State    : ', ERROR_STATE());
        PRINT '======================================================================';
    END CATCH
END;
GO
