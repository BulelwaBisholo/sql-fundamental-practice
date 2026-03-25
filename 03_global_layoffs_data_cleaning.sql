-- Data Cleaning Project: Global Layoffs Dataset
-- Source: Alex The Analyst SQL Data Cleaning Project
-- Author: Bulelwa Bisholo
-- Purpose: Demonstrate SQL techniques for cleaning raw data,
-- including duplicate removal, standardization, and handling null values.

SELECT *
FROM layoffs;

-- 1. PHASE 1: Staging and Data Protection
-- I created a staging table so I could clean the data without modifying the original dataset.
-- This is standard practise in data cleaning because it preserves the raw data
-- and protects data integrity throughout the cleaning process.

CREATE TABLE layoffs_staging
LIKE layoffs;

-- 2. Copying data from the raw table into the staging table
-- so that all cleaning steps are performed on the staged dataset.

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Checking if the copied data has been incorrectly inserted into the staging table
SELECT *
FROM layoffs_staging;

-- PHASE 2: REMOVING DUPLICATES
-- A CTE is used to create a temporary result set and identify potential duplicate records. 

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Result: No duplicate rows were found in this version of the dataset.
-- The deduplication logic is included to demonstrate the standard cleaning workflow.

-- Since MySQL does not allow deleting directly from a CTE in this case,
-- I created a second staging table (layoffs_staging2) to handle duplicate removal.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select *
from layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`,stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

Select *
From layoffs_staging2
Where row_num >1;
-- Result: 0 rows returned
-- No duplicate records were found in this dataset version.

-- PHASE 3: DATA STANDARDIZATION

-- Standardize company names by removing leading and trailing spaces 
-- so that values like "Google" and " Google" are treated consistently.

SELECT company,TRIM(company)
FROM layoffs_staging2;

-- Remove incidental whitespace from company names for consistency.
UPDATE Layoffs_staging2
SET company = TRIM(company);

-- Review distinct industry values to identify inconsistencies
SELECT DISTINCT industry 
FROM layoffs_staging2
Order by industry; 

-- Check for Crypto-related variations in the industry column
SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%';

-- Standardize all Crypto-related variations to 'Crypto'
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Result: Matching rows were found, but no updates were required
-- because the values were already standardized.
SELECT DISTINCT industry 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%'
ORDER BY 1;

-- Review distinct location values for inconsistencies
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Review distinct country values for inconsistencies
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- Inspect country values with inconsistent formatting
SELECT *
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

-- Compare original and cleaned country values
SELECT DISTINCT country, TRIM(TRAILING '.' from Country)
FROM layoffs_staging2
ORDER BY 1;
-- Standardize country values by removing trailing punctuation
UPDATE layoffs_staging2
SET COUNTRY = TRIM(TRAILING '.' from Country)
WHERE country like 'United States%';

--  The date column was originally stored as text
SELECT `date`
FROM layoffs_staging2;

-- Convert the date column to a proper DATE format for filtering and analysis
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER table layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Identify missing or blank values in the industry column
SELECT company, industry
FROM layoffs_staging2
WHERE INDUSTRY IS NULL
OR INDUSTRY = '';

-- Convert blank industry values to NULL for consistency
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT company, industry
FROM layoffs_staging2
WHERE INDUSTRY IS NULL;

-- PHASE 4: HANDLING NULLS & MISSING VALUES

-- Assumption: each company should have a consistent industry classification across records.
-- A self-join is used to match rows with missing industry values (t1)
-- to rows where the same company already has industry information populated (t2).
-- This helps retain as much usable data as possible before removing incomplete records.

SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry is null OR t1.industry = '')
AND t2.industry is not null;


-- Populate missing industry values using existing records for the same company
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Identify rows where both layoff metrics are missing
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;

-- Removing records where essential analysis metrics are missing
-- Rows where both total layoffs and percentage layoffs were null did not contain useful information, so they were removed from the dataset
DELETE
FROM layoffs_staging2
WHERE total_laid_off is null
AND percentage_laid_off is null;

-- Remove the helper column used for deduplication
ALTER TABLE layoffs_staging2
DROP row_num;

-- Final check of cleaned data
SELECT *
FROM layoffs_staging2;



























