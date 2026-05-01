# ================================
# HOME CREDIT DEFAULT RISK — SQL ANALYSIS
# Tool: MySQL Workbench
# Dataset: Kaggle - Home Credit Default Risk
# Author: Bulelwa Bisholo
# ================================


# ================================
# 1. DATA UNDERSTANDING
# ================================

-- Checking dataset size to understand scale
SELECT COUNT(*) 
FROM application_train;

-- Viewing table structure and column definitions
DESCRIBE application_train;

-- Previewing sample records to understand data format
SELECT * 
FROM application_train 
LIMIT 5;


# ================================
# 2. DATA QUALITY CHECKS
# ================================

-- Checking missing values in key financial variable
SELECT COUNT(*) AS missing_income
FROM application_train
WHERE AMT_INCOME_TOTAL IS NULL;


# ================================
# 3. KEY VARIABLE SELECTION
# ================================

-- Selecting relevant features for credit risk analysis
SELECT 
    SK_ID_CURR,
    TARGET,
    NAME_CONTRACT_TYPE,
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    AMT_ANNUITY,
    NAME_EDUCATION_TYPE,
    NAME_FAMILY_STATUS,
    DAYS_BIRTH,
    DAYS_EMPLOYED
FROM application_train
LIMIT 10;


# ================================
# 4. DEFAULT DISTRIBUTION
# ================================

-- Distribution of default vs non-default clients
SELECT 
    TARGET,
    COUNT(*) AS total_clients,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM application_train), 2) AS percentage
FROM application_train
GROUP BY TARGET;


# ================================
# 5. FINANCIAL INSIGHTS BY DEFAULT STATUS
# ================================

-- Comparing financial behavior of defaulters vs non-defaulters
SELECT 
    TARGET,
    ROUND(AVG(AMT_INCOME_TOTAL), 2) AS avg_income,
    ROUND(AVG(AMT_CREDIT), 2) AS avg_credit,
    ROUND(AVG(AMT_ANNUITY), 2) AS avg_annuity
FROM application_train
GROUP BY TARGET;


# ================================
# 6. EDUCATION & DEFAULT RISK
# ================================

-- Default rate by education level
SELECT 
    NAME_EDUCATION_TYPE,
    COUNT(*) AS total_clients,
    SUM(TARGET) AS total_defaults,
    ROUND(SUM(TARGET) * 100.0 / COUNT(*), 2) AS default_rate
FROM application_train
GROUP BY NAME_EDUCATION_TYPE
ORDER BY default_rate DESC;


# ================================
# 7. INCOME SEGMENTATION ANALYSIS
# ================================

-- Default risk by income groups
SELECT 
    CASE 
        WHEN AMT_INCOME_TOTAL < 100000 THEN 'Low Income'
        WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,
    
    COUNT(*) AS total_clients,
    ROUND(SUM(TARGET) * 100.0 / COUNT(*), 2) AS default_rate
FROM application_train
GROUP BY income_group
ORDER BY default_rate DESC;


# ================================
# 8. AGE SEGMENTATION ANALYSIS
# ================================

-- Default risk by age group
SELECT 
    CASE 
        WHEN ABS(DAYS_BIRTH) / 365 < 30 THEN 'Under 30'
        WHEN ABS(DAYS_BIRTH) / 365 BETWEEN 30 AND 50 THEN '30-50'
        ELSE '50+'
    END AS age_group,

    COUNT(*) AS total_clients,
    ROUND(SUM(TARGET) * 100.0 / COUNT(*), 2) AS default_rate,
    ROUND(AVG(AMT_CREDIT), 2) AS avg_credit
FROM application_train
GROUP BY age_group
ORDER BY default_rate DESC;


# ================================
# 9. CREDIT BURDEN ANALYSIS
# ================================

-- Credit-to-income ratio analysis
SELECT 
    SK_ID_CURR,
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    ROUND(AMT_CREDIT / AMT_INCOME_TOTAL, 2) AS credit_income_ratio,
    TARGET
FROM application_train
WHERE AMT_CREDIT / AMT_INCOME_TOTAL > 5
ORDER BY credit_income_ratio DESC;


# ================================
# 10. SIMPLE RISK FLAG MODEL
# ================================

-- Basic risk classification using credit burden
SELECT 
    SK_ID_CURR,
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    ROUND(AMT_CREDIT / AMT_INCOME_TOTAL, 2) AS credit_income_ratio,

    CASE 
        WHEN AMT_CREDIT / AMT_INCOME_TOTAL > 10 THEN 'Extreme Risk'
        WHEN AMT_CREDIT / AMT_INCOME_TOTAL BETWEEN 5 AND 10 THEN 'High Risk'
        ELSE 'Moderate Risk'
    END AS lending_risk_flag
FROM application_train;

# ================================
# 10. RULE-BASED CREDIT RISK SCORING MODEL (SIMULATION)
# ================================

-- This section simulates a simplified credit risk decisioning system
-- using income, age, and credit burden indicators.

WITH base_data AS (
    SELECT 
        SK_ID_CURR,

        -- Age calculation
        ABS(DAYS_BIRTH) / 365.0 AS age,

        AMT_INCOME_TOTAL,
        AMT_CREDIT,

        -- Credit burden indicator
        AMT_CREDIT / AMT_INCOME_TOTAL AS credit_income_ratio,

        TARGET
    FROM application_train
),

scored_data AS (
    SELECT 
        SK_ID_CURR,
        AMT_INCOME_TOTAL,
        AMT_CREDIT,
        age,
        credit_income_ratio,
        TARGET,

        -- Age risk scoring
        CASE 
            WHEN age < 30 THEN 3
            WHEN age BETWEEN 30 AND 50 THEN 2
            ELSE 1
        END AS age_risk,

        -- Income risk scoring
        CASE 
            WHEN AMT_INCOME_TOTAL < 100000 THEN 3
            WHEN AMT_INCOME_TOTAL BETWEEN 100000 AND 300000 THEN 2
            ELSE 1
        END AS income_risk,

        -- Credit burden risk scoring
        CASE 
            WHEN credit_income_ratio > 10 THEN 3
            WHEN credit_income_ratio BETWEEN 5 AND 10 THEN 2
            ELSE 1
        END AS credit_risk

    FROM base_data
)

SELECT 
    SK_ID_CURR,
    AMT_INCOME_TOTAL,
    AMT_CREDIT,
    age,
    credit_income_ratio,

    age_risk,
    income_risk,
    credit_risk,

    -- Total risk score (simple additive model)
    (age_risk + income_risk + credit_risk) AS total_risk_score,

    -- Lending decision logic
    CASE 
        WHEN (age_risk + income_risk + credit_risk) <= 4 THEN 'LOW RISK - APPROVE'
        WHEN (age_risk + income_risk + credit_risk) BETWEEN 5 AND 6 THEN 'MEDIUM RISK - REVIEW'
        ELSE 'HIGH RISK - REJECT'
    END AS lending_decision

FROM scored_data;
-- ================================
-- END OF ANALYSIS
-- Key Insight: Income level, age, and credit burden show strong relationships with default risk.
-- ================================