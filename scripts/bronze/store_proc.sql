
-- ====================================================================
-- Project: Bank Churn Analytics
-- Task: Data Warehouse - Bronze Ingestion Pipeline (Full Load)
-- Developer: Yanolitics
-- Purpose: Bulk load raw data from CRM, CBS, and The Central Financial Ledger (CFL) CSV files source.
-- Strategy: Truncate & Insert (As per design architecture)
-- WARNING: Truncates all destination tables before importing data.
-- ====================================================================

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        SET NOCOUNT ON; -- Prevents internal row-count messages from cluttering your custom log

        PRINT '======================================================================';
        PRINT '                    LOADING BRONZE LAYER PIPELINE                     ';
        PRINT '======================================================================';
    
        -- ─── SECTION 1: INGESTION ───────────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 1: INGESTION';
        PRINT '----------------------------------------------------------------------';

        -- 1. Ingest CRM Profiles
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Ingesting: bronze.crm_profiles';
        TRUNCATE TABLE bronze.crm_profiles;
        BULK INSERT bronze.crm_profiles
        FROM 'C:\DATASETS\crm_profiles.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FORMAT = 'CSV',
            TABLOCK
        );
        PRINT '>> SUCCESS: bronze.crm_profiles loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
        PRINT '----------------------------------------------------------------------';

        -- 2. Ingest Credit Accounts Ops
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Ingesting: bronze.credit_accounts_ops';
        TRUNCATE TABLE bronze.credit_accounts_ops;
        BULK INSERT bronze.credit_accounts_ops
        FROM 'C:\DATASETS\credit_accounts_ops.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FORMAT = 'CSV',
            TABLOCK
        );
        PRINT '>> SUCCESS: bronze.credit_accounts_ops loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
        PRINT '----------------------------------------------------------------------';

        -- 3. Ingest Ledger_Transactions
        SET @start_time = GETDATE();
        PRINT '>> Truncating and Ingesting: bronze.ledger_transactions';
        TRUNCATE TABLE bronze.ledger_transactions;
        BULK INSERT bronze.ledger_transactions
        FROM 'C:\DATASETS\ledger_transactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            FORMAT = 'CSV',
            TABLOCK
        );
        PRINT '>> SUCCESS: bronze.ledger_transactions loaded.';
        PRINT '----------------------------------------------------------------------';
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
        PRINT '----------------------------------------------------------------------';
        PRINT ''
        PRINT ''
        PRINT '----------------------------------------------------------------------';
        PRINT 'OVERALL LOAD DURATION'
        SET @batch_end_time = GETDATE();
        PRINT '>> Load Duration: '+ CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + 'seconds';
        PRINT '----------------------------------------------------------------------';


        -- ─── SECTION 3: VERIFICATION AUDIT ──────────────────────────────────
        PRINT '';
        PRINT '----------------------------------------------------------------------';
        PRINT ' SECTION 3: VERIFICATION AUDIT';
        PRINT '----------------------------------------------------------------------';
    
        SELECT 'bronze.crm_profiles' AS table_name, COUNT(*) AS total_rows_loaded FROM bronze.crm_profiles
        UNION ALL
        SELECT 'bronze.credit_accounts_ops', COUNT(*) FROM bronze.credit_accounts_ops
        UNION ALL
        SELECT 'bronze.ledger_transactions', COUNT(*) FROM bronze.ledger_transactions

        PRINT '';
        PRINT '======================================================================';
        PRINT '               BRONZE LAYER LOAD COMPLETED SUCCESSFULLY               ';
        PRINT '======================================================================';
    END TRY
    BEGIN CATCH
        PRINT '======================================================================';
        PRINT '              ERROR OCCURRED DURING LOADING BRONZE LAYER              ';
        PRINT '======================================================================';
        PRINT CONCAT('Error Message  : ', ERROR_MESSAGE());
        PRINT CONCAT('Error Number   : ', ERROR_NUMBER());
        PRINT CONCAT('Error Severity : ', ERROR_SEVERITY());
        PRINT CONCAT('Error State    : ', ERROR_STATE());
        PRINT '======================================================================';
    END CATCH
END;
GO
GO
