/*1. The Portfolio Baseline (Overall Churn Rate)
Why it matters: Every churn dashboard needs a primary high-level North Star metric. 
This query establishes your baseline portfolio health. 
It tells you exactly how much of your total customer base has already walked out the door.*/

SELECT 
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churn_Count,
    SUM(CASE WHEN Attrition_Flag = 'Existing Customer' THEN 1 ELSE 0 END) AS Active_Count,
    -- Multiplying by 100.0 forces SQL Server to avoid integer division truncation
    CAST(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Churn_Rate_Percentage
FROM gold.dim_customer; 


/*2. The Customer Friction Meter (Contacts vs. Churn)
Why it matters: Earlier, we hypothesized that Contacts_Count_12_mon acts as a customer friction meter. 
This diagnostic query proves it. It groups customers by how many times they interacted with the bank 
and calculates the churn rate for each group.*/

SELECT 
    Contacts_Count_12_mon AS Total_Contacts_12M,
    COUNT(*) AS Customer_Count,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Count,
    CAST(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Group_Churn_Rate_Pct
FROM gold.dim_customer
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon ASC;

/*3. The Financial Velocity Drop-off (Behavioral Trajectory)
Why it matters: This query bridges your Dim and Fact views to look at financial velocity. 
It compares the average drop-off in transaction amounts and transaction counts (Q4 vs Q1) 
between your loyal active customers and the ones who churned.*/
SELECT 
    c.Attrition_Flag,
    COUNT(c.CLIENTNUM) AS Total_Segment_Customers,
    -- An average ratio below 1.0 means spending declined from Q1 to Q4
    CAST(AVG(t.Total_Amt_Chng_Q4_Q1) AS DECIMAL(10,3)) AS Avg_Spend_Velocity_Change,
    CAST(AVG(t.Total_Ct_Chng_Q4_Q1) AS DECIMAL(10,3)) AS Avg_Transaction_Count_Change,
    CAST(AVG(t.Avg_Utilization_Ratio) AS DECIMAL(10,3)) AS Avg_Credit_Line_Utilization
FROM gold.dim_customer c
INNER JOIN gold.fact_transactions t ON c.CLIENTNUM = t.CLIENTNUM
GROUP BY c.Attrition_Flag;
/* What to look for: Attrited customers usually have a significantly lower velocity ratio (closer to 0.3 or 0.5), 
proving that their transaction activity slowed down dramatically months before they officially left.*/


/*4. Product Category Risk Profile
Why it matters: This query identifies product line vulnerability. It calculates customer volume and churn rates across your card tiers 
(Blue, Silver, Gold, Platinum). It answers the question: Are we losing our premium high-value cardholders or our entry-level ones?*/
SELECT 
    Card_Category,
    COUNT(*) AS Total_Cardholders,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Cardholders,
    CAST(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Product_Churn_Rate_Pct
FROM gold.dim_customer
GROUP BY Card_Category
ORDER BY Product_Churn_Rate_Pct DESC;
/*Power BI Impact: This tells you whether a standard bar chart or a tree-map 
visualization is the best way to display product risk to stakeholders.*/

/*5. Inactivity Danger Zone Analysis
Why it matters: Banks need to know exactly when an inactive account transitions from 
"just resting" to "gone forever." This query evaluates churn rates based 
on how many consecutive months an account has been dark (Months_Inactive_12_mon).*/
SELECT 
    Months_Inactive_12_mon AS Months_Dormant,
    COUNT(*) AS Total_Accounts,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Confirmed_Churn,
    CAST(SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS Inactivity_Churn_Rate_Pct    
FROM gold.dim_customer
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Dormant ASC;


