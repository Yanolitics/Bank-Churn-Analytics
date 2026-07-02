SELECT
    CLIENTNUM,
    CASE 
        WHEN Customer_Age > 100 THEN NULL
        WHEN Customer_Age <= 18 THEN NULL
        ELSE Customer_Age
    END AS Customer_Age,
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
SELECT *, ROW_NUMBER() OVER(PARTITION BY CLIENTNUM ORDER BY CLIENTNUM) AS CN FROM bronze.credit_accounts_ops) t
WHERE CN = 1

SELECT 
    CLIENTNUM,
    Credit_Limit,
    Total_Revolving_Bal,
    Avg_Open_To_Buy,
    Total_Trans_Amt,
    Total_Trans_Ct,
    Avg_Utilization_Ratio,
    Total_Amt_Chng_Q4_Q1,
    Total_Ct_Chng_Q4_Q1
FROM bronze.ledger_transactions;
