-----/* =========================================================
   NHS PRESCRIBING ANALYSIS
   Database: NHS_Prescribing
   Table: [dbo].[NHS - Prescribing]
   ========================================================= */


/* =========================================================
   01. DATA VALIDATION
   ========================================================= */

-- 01.1 Total Records


SELECT
    COUNT(*) AS Total_Records
FROM [dbo].[NHS - Prescribing];
-- 01.2 Date Range

SELECT
    MIN(PERIOD) AS Start_Date,
    MAX(PERIOD) AS End_Date
FROM [dbo].[NHS - Prescribing];


-- 01.3 Unique Trusts
SELECT
    COUNT(DISTINCT HOSPITAL_TRUST_CODE) AS Unique_Trusts
FROM [dbo].[NHS - Prescribing];

-- 01.4 Unique BNF Products

SELECT
    COUNT(DISTINCT BNF_CODE) AS Unique_BNF_Products
FROM [dbo].[NHS - Prescribing];

-- 01.5 NULL Check
SELECT
    SUM(CASE WHEN PERIOD IS NULL THEN 1 ELSE 0 END) AS Null_PERIOD,
    SUM(CASE WHEN BNF_NAME IS NULL THEN 1 ELSE 0 END) AS Null_BNF_NAME,
    SUM(CASE WHEN BNF_CODE IS NULL THEN 1 ELSE 0 END) AS Null_BNF_CODE,
    SUM(CASE WHEN HOSPITAL_TRUST_CODE IS NULL THEN 1 ELSE 0 END) AS Null_Trust_Code,
    SUM(CASE WHEN HOSPITAL_TRUST IS NULL THEN 1 ELSE 0 END) AS Null_Trust_Name,
    SUM(CASE WHEN QUANTITY IS NULL THEN 1 ELSE 0 END) AS Null_Quantity,
    SUM(CASE WHEN TOTAL_QUANTITY IS NULL THEN 1 ELSE 0 END) AS Null_Total_Quantity,
    SUM(CASE WHEN TOTAL_ITEMS IS NULL THEN 1 ELSE 0 END) AS Null_Total_Items,
    SUM(CASE WHEN TOTAL_ACTUAL_COST IS NULL THEN 1 ELSE 0 END) AS Null_Actual_Cost,
    SUM(CASE WHEN TOTAL_NIC IS NULL THEN 1 ELSE 0 END) AS Null_NIC
FROM [dbo].[NHS - Prescribing];

-- 01.6 Exact Duplicate Check
SELECT
    PERIOD,
    BNF_NAME,
    BNF_CODE,
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    QUANTITY,
    TOTAL_QUANTITY,
    TOTAL_ITEMS,
    TOTAL_ACTUAL_COST,
    TOTAL_NIC,
    COUNT(*) AS Duplicate_Count
FROM [dbo].[NHS - Prescribing]
GROUP BY
    PERIOD,
    BNF_NAME,
    BNF_CODE,
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    QUANTITY,
    TOTAL_QUANTITY,
    TOTAL_ITEMS,
    TOTAL_ACTUAL_COST,
    TOTAL_NIC
HAVING COUNT(*) > 1;

-- 01.7 Negative Value Check

SELECT
    SUM(CASE WHEN QUANTITY < 0 THEN 1 ELSE 0 END) AS Negative_Quantity,
    SUM(CASE WHEN TOTAL_QUANTITY < 0 THEN 1 ELSE 0 END) AS Negative_Total_Quantity,
    SUM(CASE WHEN TOTAL_ITEMS < 0 THEN 1 ELSE 0 END) AS Negative_Total_Items,
    SUM(CASE WHEN TOTAL_ACTUAL_COST < 0 THEN 1 ELSE 0 END) AS Negative_Actual_Cost,
    SUM(CASE WHEN TOTAL_NIC < 0 THEN 1 ELSE 0 END) AS Negative_NIC
FROM [dbo].[NHS - Prescribing];


/* =========================================================
   02. EXPLORATORY DATA ANALYSIS (EDA)
   ========================================================= */

-- 02.1 Numeric Profile

SELECT
    MIN(QUANTITY) AS Min_Quantity,
    MAX(QUANTITY) AS Max_Quantity,
    AVG(QUANTITY) AS Avg_Quantity,

    MIN(TOTAL_QUANTITY) AS Min_Total_Quantity,
    MAX(TOTAL_QUANTITY) AS Max_Total_Quantity,
    AVG(TOTAL_QUANTITY) AS Avg_Total_Quantity,

    MIN(TOTAL_ITEMS) AS Min_Total_Items,
    MAX(TOTAL_ITEMS) AS Max_Total_Items,
    AVG(TOTAL_ITEMS) AS Avg_Total_Items,

    MIN(TOTAL_ACTUAL_COST) AS Min_Actual_Cost,
    MAX(TOTAL_ACTUAL_COST) AS Max_Actual_Cost,
    AVG(TOTAL_ACTUAL_COST) AS Avg_Actual_Cost,

    MIN(TOTAL_NIC) AS Min_NIC,
    MAX(TOTAL_NIC) AS Max_NIC,
    AVG(TOTAL_NIC) AS Avg_NIC
FROM [dbo].[NHS - Prescribing];


-- 02.2 Categorical Profile


SELECT
    COUNT(DISTINCT BNF_NAME) AS Unique_BNF_Names,
    COUNT(DISTINCT BNF_CODE) AS Unique_BNF_Codes,
    COUNT(DISTINCT HOSPITAL_TRUST_CODE) AS Unique_Trust_Codes,
    COUNT(DISTINCT HOSPITAL_TRUST) AS Unique_Trust_Names
FROM [dbo].[NHS - Prescribing];

-- 02.3 Record Distribution by Trust

SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    COUNT(*) AS Record_Count
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Record_Count DESC;


-- 02.4 Trust-level Aggregation


SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    COUNT(*) AS Record_Count,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Total_Actual_Cost DESC;


-- 02.5 Overall Totals


SELECT
    COUNT(*) AS Total_Records,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC
FROM [dbo].[NHS - Prescribing];

-- 02.6 Top BNF Products by Actual Cost


SELECT TOP 20
    BNF_CODE,
    BNF_NAME,
    COUNT(*) AS Record_Count,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
ORDER BY
    Total_Actual_Cost DESC;


-- 02.7 Zero-value Analysis


SELECT
    SUM(CASE WHEN QUANTITY = 0 THEN 1 ELSE 0 END) AS Zero_Quantity,
    SUM(CASE WHEN TOTAL_QUANTITY = 0 THEN 1 ELSE 0 END) AS Zero_Total_Quantity,
    SUM(CASE WHEN TOTAL_ITEMS = 0 THEN 1 ELSE 0 END) AS Zero_Total_Items,
    SUM(CASE WHEN TOTAL_ACTUAL_COST = 0 THEN 1 ELSE 0 END) AS Zero_Actual_Cost,
    SUM(CASE WHEN TOTAL_NIC = 0 THEN 1 ELSE 0 END) AS Zero_NIC
FROM [dbo].[NHS - Prescribing];


-- 02.8 Cost per Item by Trust

SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_ITEMS) AS Total_Items,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(SUM(TOTAL_ITEMS), 0)
        AS DECIMAL(18,2)
    ) AS Actual_Cost_Per_Item
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Actual_Cost_Per_Item DESC;

-- 02.9 Product Cost per Item Minimum 10 Items

SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_ITEMS) AS Total_Items,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(SUM(TOTAL_ITEMS), 0)
        AS DECIMAL(18,2)
    ) AS Actual_Cost_Per_Item
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
HAVING
    SUM(TOTAL_ITEMS) >= 10
ORDER BY
    Actual_Cost_Per_Item DESC;

-- 02.10 Actual Cost vs NIC


SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC,
    CAST(
        SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC)
        AS DECIMAL(18,2)
    ) AS Cost_Difference,
    CAST(
        (
            (SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC))
            / NULLIF(SUM(TOTAL_NIC), 0)
        ) * 100
        AS DECIMAL(18,2)
    ) AS Difference_Percentage
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
HAVING
    SUM(TOTAL_NIC) > 0
ORDER BY
    ABS(SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC)) DESC;


-- 02.11 Trust Contribution %   Trust Contribution to Total Expenditure

SELECT TOP 20
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(
            (
                SELECT SUM(TOTAL_ACTUAL_COST)
                FROM [dbo].[NHS - Prescribing]
            ), 0
        ) * 100
        AS DECIMAL(18,2)
    ) AS Cost_Contribution_Percentage
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Total_Actual_Cost DESC;



-- 02.12 Trust × BNF Product Diversity


SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    COUNT(DISTINCT BNF_CODE) AS Unique_BNF_Products
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Unique_BNF_Products DESC;

-- 02.13 BNF × Trust Coverage


SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    COUNT(DISTINCT HOSPITAL_TRUST_CODE) AS Trust_Count
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
ORDER BY
    Trust_Count DESC;


-- 02.14 Trust × BNF Activity


SELECT TOP 30
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    BNF_CODE,
    BNF_NAME,
    COUNT(*) AS Record_Count
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    BNF_CODE,
    BNF_NAME
ORDER BY
    Record_Count DESC;

/* =========================================================
   03. BUSINESS QUESTIONS
   ========================================================= */

-- Q1. Where is prescribing expenditure concentrated?

WITH TrustCost AS
(
    SELECT
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST,
        SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost
    FROM [dbo].[NHS - Prescribing]
    GROUP BY
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST
),
RankedTrusts AS
(
    SELECT
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST,
        Total_Actual_Cost,
        SUM(Total_Actual_Cost) OVER (
            ORDER BY Total_Actual_Cost DESC
            ROWS UNBOUNDED PRECEDING
        ) AS Cumulative_Cost,
        SUM(Total_Actual_Cost) OVER () AS Overall_Cost
    FROM TrustCost
)
SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    Total_Actual_Cost,
    CAST(
        Total_Actual_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cost_Contribution_Percentage,
    CAST(
        Cumulative_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cumulative_Cost_Percentage
FROM RankedTrusts
ORDER BY
    Total_Actual_Cost DESC;

-- Q2. Which BNF products contribute most to expenditure?

SELECT TOP 20
    BNF_CODE,
    BNF_NAME,
    COUNT(*) AS Record_Count,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
ORDER BY
    Total_Actual_Cost DESC;

-- Q3. What is the difference between Actual Cost and NIC?

SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_NIC) AS Total_NIC,
    CAST(
        SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC)
        AS DECIMAL(18,2)
    ) AS Cost_Difference,
    CAST(
        (
            (SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC))
            / NULLIF(SUM(TOTAL_NIC), 0)
        ) * 100
        AS DECIMAL(18,2)
    ) AS Difference_Percentage
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
HAVING
    SUM(TOTAL_NIC) > 0
ORDER BY
    ABS(SUM(TOTAL_ACTUAL_COST) - SUM(TOTAL_NIC)) DESC;


-- Q4. Are there unusual or high-cost records/products
--     that warrant investigation?
SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_ITEMS) AS Total_Items,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(SUM(TOTAL_ITEMS), 0)
        AS DECIMAL(18,2)
    ) AS Actual_Cost_Per_Item
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
HAVING
    SUM(TOTAL_ITEMS) >= 10
ORDER BY
    Actual_Cost_Per_Item DESC;

-- Q5. How is prescribing volume distributed across Trusts
SELECT
    'Trust' AS Analysis_Level,
    HOSPITAL_TRUST_CODE AS Entity_Code,
    HOSPITAL_TRUST AS Entity_Name,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST

UNION ALL

SELECT
    'Product' AS Analysis_Level,
    BNF_CODE AS Entity_Code,
    BNF_NAME AS Entity_Name,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME

ORDER BY
    Analysis_Level,
    Total_Quantity DESC;


-- Q6. Are there meaningful differences between Trusts
--     when we account for volume?

SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_ITEMS) AS Total_Items,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(SUM(TOTAL_ITEMS), 0)
        AS DECIMAL(18,2)
    ) AS Actual_Cost_Per_Item
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Actual_Cost_Per_Item DESC;

-- Q7. Are there data-quality or reporting anomalies
--     that could affect interpretation?

SELECT
    SUM(CASE WHEN QUANTITY = 0 THEN 1 ELSE 0 END) AS Zero_Quantity,
    SUM(CASE WHEN TOTAL_QUANTITY = 0 THEN 1 ELSE 0 END) AS Zero_Total_Quantity,
    SUM(CASE WHEN TOTAL_ITEMS = 0 THEN 1 ELSE 0 END) AS Zero_Total_Items,
    SUM(CASE WHEN TOTAL_ACTUAL_COST = 0 THEN 1 ELSE 0 END) AS Zero_Actual_Cost,
    SUM(CASE WHEN TOTAL_NIC = 0 THEN 1 ELSE 0 END) AS Zero_NIC,

    SUM(CASE WHEN QUANTITY < 0 THEN 1 ELSE 0 END) AS Negative_Quantity,
    SUM(CASE WHEN TOTAL_QUANTITY < 0 THEN 1 ELSE 0 END) AS Negative_Total_Quantity,
    SUM(CASE WHEN TOTAL_ITEMS < 0 THEN 1 ELSE 0 END) AS Negative_Total_Items,
    SUM(CASE WHEN TOTAL_ACTUAL_COST < 0 THEN 1 ELSE 0 END) AS Negative_Actual_Cost,
    SUM(CASE WHEN TOTAL_NIC < 0 THEN 1 ELSE 0 END) AS Negative_NIC
FROM [dbo].[NHS - Prescribing];

-- Q8. Which Trust–BNF combinations account for unusually
--     high prescribing activity or expenditure?

SELECT TOP 30
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    BNF_CODE,
    BNF_NAME,
    COUNT(*) AS Record_Count,
    SUM(TOTAL_QUANTITY) AS Total_Quantity,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    BNF_CODE,
    BNF_NAME
ORDER BY
    Total_Actual_Cost DESC;

-- Q9. Which products have high expenditure despite
--     relatively low prescribing volume?

SELECT TOP 30
    BNF_CODE,
    BNF_NAME,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost,
    SUM(TOTAL_ITEMS) AS Total_Items,
    CAST(
        SUM(TOTAL_ACTUAL_COST) /
        NULLIF(SUM(TOTAL_ITEMS), 0)
        AS DECIMAL(18,2)
    ) AS Actual_Cost_Per_Item
FROM [dbo].[NHS - Prescribing]
GROUP BY
    BNF_CODE,
    BNF_NAME
HAVING
    SUM(TOTAL_ITEMS) >= 10
ORDER BY
    Actual_Cost_Per_Item DESC;

-- Q10. How much of total expenditure is associated with
--     a relatively small number of Trusts or BNF products?

---Trust

WITH TrustCost AS
(
    SELECT
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST,
        SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost
    FROM [dbo].[NHS - Prescribing]
    GROUP BY
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST
),
RankedTrusts AS
(
    SELECT
        HOSPITAL_TRUST_CODE,
        HOSPITAL_TRUST,
        Total_Actual_Cost,
        SUM(Total_Actual_Cost) OVER (
            ORDER BY Total_Actual_Cost DESC
            ROWS UNBOUNDED PRECEDING
        ) AS Cumulative_Cost,
        SUM(Total_Actual_Cost) OVER () AS Overall_Cost
    FROM TrustCost
)
SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    Total_Actual_Cost,
    CAST(
        Total_Actual_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cost_Contribution_Percentage,
    CAST(
        Cumulative_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cumulative_Cost_Percentage
FROM RankedTrusts
ORDER BY
    Total_Actual_Cost DESC;



---Product 

WITH BNF_Cost AS
(
    SELECT
        BNF_CODE,
        BNF_NAME,
        SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost
    FROM [dbo].[NHS - Prescribing]
    GROUP BY
        BNF_CODE,
        BNF_NAME
),
RankedBNF AS
(
    SELECT
        BNF_CODE,
        BNF_NAME,
        Total_Actual_Cost,
        SUM(Total_Actual_Cost) OVER (
            ORDER BY Total_Actual_Cost DESC
            ROWS UNBOUNDED PRECEDING
        ) AS Cumulative_Cost,
        SUM(Total_Actual_Cost) OVER () AS Overall_Cost
    FROM BNF_Cost
)
SELECT
    BNF_CODE,
    BNF_NAME,
    Total_Actual_Cost,
    CAST(
        Total_Actual_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cost_Contribution_Percentage,
    CAST(
        Cumulative_Cost / NULLIF(Overall_Cost, 0) * 100
        AS DECIMAL(18,2)
    ) AS Cumulative_Cost_Percentage
FROM RankedBNF
ORDER BY
    Total_Actual_Cost DESC;


-- Q11. Are prescribing activity and expenditure telling
--     the same story?

SELECT
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST,
    SUM(TOTAL_ITEMS) AS Total_Items,
    SUM(TOTAL_ACTUAL_COST) AS Total_Actual_Cost
FROM [dbo].[NHS - Prescribing]
GROUP BY
    HOSPITAL_TRUST_CODE,
    HOSPITAL_TRUST
ORDER BY
    Total_Actual_Cost DESC;

/* =========================================================
   04. KEY ANALYSIS / INSIGHTS
   ========================================================= */
--Concemtration Analysis 

--Prescribing expenditure is not evenly distributed across Trusts. The top 26 of 191 Trusts account for approximately 50.29% of total Actual Cost, while the top 65 Trusts account for approximately 80.34%.

--Supporting figures:

--Total Trusts: 191
--Total Actual Cost: £8.75 million
--Top 26 Trusts → 50.29%
--Top 65 Trusts → 80.34%

--What this tells us:
--A relatively smaller group of Trusts accounts for a substantial share of total prescribing expenditure.

-- Product expenditure analysis

--Prescribing expenditure is distributed across a large number of BNF products, with the highest-cost products contributing a relatively small share individually. Lisdexamfetamine 30mg capsules recorded the highest Total Actual Cost at approximately £85,815, followed by Iopidine 1% eye drops at approximately £79,468.

--Important observation:
--Even the highest-cost individual product accounts for only about 1% of total expenditure, indicating that product-level expenditure is relatively dispersed.

-- Actual Cost vs NIC analysis

 --- Overall, Total Actual Cost (£8.75 million) was lower than Total NIC (£9.06 million) by approximately £306,983.

-- At product level, the difference was not uniform:

---Some products had Actual Cost higher than NIC. Others had Actual Cost lower than NIC.
---The largest absolute differences were concentrated in a relatively small number of products.

--Interpretation:
--Actual Cost and NIC are related but do not tell exactly the same financial story. Comparing them helps identify products with notable cost differences that may warrant further investigation.

-- Volume-adjusted analysis
--Actual Cost per Item varies considerably across Trusts. For example, Queen Victoria Hospital recorded approximately £198.41 per item, compared with approximately £18.68 per item at Midlands Partnership University NHS Foundation Trust.

---Interpretation:
--Looking only at total expenditure can hide differences in prescribing volume. Calculating Actual Cost per Item provides a volume-adjusted view of expenditure across Trusts.

-- Trust–BNF analysis
-- Prescribing activity and expenditure vary substantially across individual Trust–BNF combinations. Some combinations have high record counts and prescribing volume, while others generate relatively high expenditure despite fewer records.
-- Midlands Partnership University NHS Foundation Trust + Physeptone 1mg/ml oral solution sugar free → 280 records
--Central & North West London + Methadone 1mg/ml → 208 records
--North London + Methadone 1mg/ml → 182 records

--Interpretation:
--Looking at the Trust + product combination provides a more granular view than analysing Trusts or products separately and can highlight combinations that warrant further investigation.

-- Activity vs expenditure analysis
---Prescribing activity and expenditure do not necessarily move together. Trusts with a high number of prescribing items do not always have the highest total expenditure, indicating that volume alone does not explain expenditure differences.
---East Kent had the highest record count (4,181) but ranked third in Total Actual Cost.
--Midlands Partnership had fewer records (2,700) but ranked first in Total Actual Cost. 
---Interpretation:
--This suggests that prescribing volume and expenditure provide different perspectives and should be analysed together rather than using activity alone to understand expenditure.