-- This Exploratory Data Analysis (EDA) aims to identify patterns and risk factors associated with loan default in the Home Credit dataset.
-- Author:Bulelwa Bisholo

-- Section 1 - Dataset understanding 
-- Question 1: How large is the dataset?
-- Insight:
-- The dataset contains 305545 total loan applications.

SELECT COUNT(*) as total_records
FROM application_train;

-- Question 2: Does each row represent a unique customer?
-- Insight:
-- The total number of records matches the number of distinct customer IDs,
-- indicating that there are no duplicate client records in the dataset.


SELECT COUNT(DISTINCT SK_ID_CURR) AS unique_clients
FROM application_train;

-- Section 2- Data Quality Assessment 

-- Question 3: Are there any missing values in key financial columns?
-- Insight:
-- The applicant income column (AMT_INCOME_TOTAL) contains no missing values. All loan application records include income information, making the column suitable for further financial and risk analysis.

SELECT 
  COUNT(*) AS total,
  COUNT(AMT_INCOME_TOTAL) AS income_not_null,
  COUNT(*) - COUNT(AMT_INCOME_TOTAL) AS income_nulls
FROM application_train;

-- Section 3: Loan Default Analysis 

-- Question 4: What percentage of clients defaulted on loans?
-- Insight:
-- The majority of applicants were non-defaulters, while a smaller percentage experienced payment difficulties. 
-- This indicates that the dataset is imbalanced toward successful repayments.

SELECT 
    CASE
        WHEN TARGET = 1 THEN 'Defaulter'
        ELSE 'Non-Defaulter'
    END AS client_status,

    COUNT(*) AS total_count,

    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage

FROM application_train

GROUP BY client_status;

-- TARGET column:
-- 1 = Defaulter (client experienced payment difficulties)
-- 0 = Non-defaulter (client repaid successfully)

-- Section 4: Customer Risk Exploration

-- Question 5: Which income groups are associated with higher default rates?
-- Insight:
-- High income clients have a noticeably lower default rate (6.9%) compared to low and middle income clients (low income at 8.22% and middle income at 8.52%) , suggesting income provides a protective effect mainly at higher earning levels. 
-- The difference between low and middle income groups is negligible, indicating a threshold effect rather than a gradual relationship.
SELECT
    CASE
        WHEN AMT_INCOME_TOTAL < 112500 THEN 'Low Income'
        WHEN AMT_INCOME_TOTAL < 225000 THEN 'Middle Income'
        ELSE 'High Income'
    END AS income_group,

    COUNT(*) AS total_clients,

    ROUND(AVG(TARGET) * 100, 2) AS default_rate_percentage,

    ROUND(AVG(AMT_INCOME_TOTAL), 2) AS avg_income

FROM application_train

GROUP BY income_group

ORDER BY avg_income;

-- Question 6: 
-- Are clients borrowing amounts disproportionate to their income — and does that correlate with higher default rates?
-- Insight 
-- Low risk clients, those borrowing less than their annual income, default at a notably lower rate of 6.60% compared to moderate and high risk groups at 8.27% and 8.08% respectively. 
-- Interestingly, the highest debt burden group does not default at the highest rate, suggesting that loan size relative to income alone is not sufficient to predict default risk. 
-- This may indicate that other factors such as income level and loan purpose also play a role — a pattern consistent with reckless lending cases observed in debt counselling practice, 
-- where high loan amounts were approved despite clients' limited repayment capacity.
SELECT
    CASE
        WHEN (AMT_CREDIT / AMT_INCOME_TOTAL) < 1 THEN 'Low Risk'
        WHEN (AMT_CREDIT / AMT_INCOME_TOTAL) < 3 THEN 'Moderate Risk'
        ELSE 'High Risk - High Debt Burden'
    END AS debt_to_income_group,
    
    COUNT(*) AS total_clients,
    ROUND(AVG(TARGET) * 100, 2) AS default_rate,
    ROUND(AVG(AMT_CREDIT / AMT_INCOME_TOTAL), 2) AS avg_debt_to_income

FROM application_train

GROUP BY debt_to_income_group
ORDER BY avg_debt_to_income;

-- Section 5
-- Question 7:  
-- Does default risk vary by age group and gender, and which segments should the bank monitor most closely?
-- Insight 
-- Young male clients (Under 30) carry the highest default risk at 12.60%, nearly double that of older female clients (Over 60) at 4.55%.
-- This suggests the bank should apply stricter credit assessment criteria for young male applicants while offering more favourable terms to older female clients who demonstrate consistently lower risk.

SELECT 
    CASE 
        WHEN FLOOR(ABS(DAYS_BIRTH) / 365) < 30 THEN 'Under 30'
        WHEN FLOOR(ABS(DAYS_BIRTH) / 365) BETWEEN 30 AND 45 THEN '30-45'
        WHEN FLOOR(ABS(DAYS_BIRTH) / 365) BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'Over 60'
    END AS age_group,
    CODE_GENDER,      
    COUNT(*) AS total_clients,
    ROUND(AVG(TARGET) * 100, 2) AS default_rate
FROM application_train
WHERE CODE_GENDER != 'XNA'
GROUP BY age_group, CODE_GENDER  
ORDER BY age_group;

-- Question 8:  
-- Which occupation types carry the highest credit default risk?
-- Low-skill laborers present the highest default risk at 17.23%, more than three times that of accountants at 4.85%. 
-- The bank should apply more rigorous credit screening for manual and low-skill occupations while recognising that professional occupations such as accounting and IT staff represent significantly lower risk profiles

SELECT OCCUPATION_TYPE,
COUNT(*) AS Total_clients,
ROUND(AVG(TARGET) * 100, 2) AS Default_rate
FROM application_train
WHERE OCCUPATION_TYPE IS NOT NULL
AND OCCUPATION_TYPE != ''
GROUP BY OCCUPATION_TYPE
ORDER BY Default_rate DESC;

