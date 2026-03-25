-- Project: Exploratory Data Analysis on Global Layoffs Dataset
-- Author: Bulelwa Bisholo
-- Description: This project explores trends in global layoffs, identifying key companies,
-- industries, and patterns in workforce reductions.
-- DATE: March 2026
-- TOOLS: MySQL, CTEs, Window Functions, Case Statements

SELECT company, location, industry, total_laid_off, percentage_laid_off
FROM layoffs_staging2;

-- Question 1a. What is the total number of layoffs recorded?
SELECT SUM(total_laid_off)
FROM layoffs_staging2;

-- Question 1b. What is the largest single layoff event and highest layoff percentage recorded?
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Question 2a. Which companies laid off 100% of their workforce?
SELECT 
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Insight:
-- Several companies laid off 100% of their employees,
-- indicating complete shutdowns or severe operational failures,
-- particularly among smaller or highly vulnerable organizations.

-- Question 2b: Which funded companies still ended in complete layoffs?
-- Goal: Identify organizations with recorded funding that still reached 100% layoffs,
-- showing that funding alone did not guarantee survival.

SELECT 
    company, 
    industry, 
    country, 
    total_laid_off, 
    funds_raised_millions
FROM layoffs_staging2
WHERE percentage_laid_off = 1
  AND funds_raised_millions IS NOT NULL  -- Added to focus on funded companies
ORDER BY funds_raised_millions DESC;

-- Insight:
-- Some companies that raised substantial funding still laid off 100% of employees,
-- suggesting that access to capital alone was not enough to prevent collapse.

-- Question 3: Which companies had the highest layoffs?

WITH Company_Layoffs AS (
    SELECT 
        company, 
        SUM(total_laid_off) AS total_layoffs
    FROM layoffs_staging2
    GROUP BY company
)
SELECT 
    company, 
    total_layoffs,
    DENSE_RANK() OVER (ORDER BY total_layoffs DESC) AS ranking
FROM Company_Layoffs
WHERE total_layoffs IS NOT NULL
ORDER BY ranking ASC;

-- Insight:
-- Ranking the companies allows us to quickly identify the 'Top 10' 
-- most impacted firms rather than just looking at a long list of sums.

-- 4. Which industries were most affected by layoffs?

SELECT industry, SUM(total_laid_off) AS total_layoffs
from layoffs_staging2
GROUP BY industry 
ORDER BY total_layoffs DESC;

-- Insight:
-- Other or certain industries experienced significantly higher layoffs.
-- Highlighting sector-specific economic pressures during this period.

-- Question 5: How have layoffs changed over time?

SELECT YEAR(`date`) AS year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY year;

-- Insight:
-- Layoffs peaked in 2023, showing a sharp increase compared to previous years.
-- This suggests that 2023 was a particularly challenging period for companies,
-- potentially driven by economic pressure, post-pandemic adjustments, or cost-cutting strategies.

-- Question 6: How did layoffs vary by company over time?

SELECT company, YEAR(`date`) AS year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY total_layoffs DESC;

-- Insight:
-- Layoffs varied significantly across companies and years,
-- with certain companies experiencing spikes in specific periods,
-- indicating that workforce reductions were not evenly distributed over time.

-- Question 7: Which countries experienced the most layoffs?

SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging2
GROUP BY country
ORDER BY total_layoffs DESC;

-- Insight:
-- The United States recorded the highest number of layoffs,
-- highlighting its significant exposure to workforce reductions,
-- particularly within major industries such as technology.

-- Section 2: Deep Dive into Company Financials

-- Question 8: Did higher funding levels protect employees from layoffs?
-- This query categorizes companies by funding to see if 'Mega-Funded' firms 
-- were more stable than 'Early Stage' startups.

SELECT 
    CASE 
        WHEN funds_raised_millions IS NULL THEN 'Unknown'
        WHEN funds_raised_millions < 50 THEN 'Early Stage'
        WHEN funds_raised_millions BETWEEN 50 AND 500 THEN 'Mid-Growth'
        ELSE 'Mega-Funded'
    END AS funding_tier,
    ROUND(AVG(percentage_laid_off), 2) AS avg_layoff_percent
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- Insight: 
-- Generally, Early Stage companies saw higher percentage layoffs (often 100%), 
-- while Mega-Funded companies had lower percentages but much higher total counts.
