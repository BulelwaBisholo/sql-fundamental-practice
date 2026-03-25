# SQL Data Projects & Fundamentals

This repository contains my SQL learning journey, featuring foundational exercises and real-world data projects. These projects demonstrate my ability to handle the entire data lifecycle—from raw data cleaning to extracting business insights.

## Projects

### 1. Global Layoffs - Data Cleaning
* **Objective:** Transform a messy, raw layoffs dataset into a structured format ready for analysis.
* **Key Actions:**
    * Removed duplicates using **Window Functions (`ROW_NUMBER()`)**.
    * Standardized inconsistent data (company names, industries, and countries).
    * Converted string date columns into proper **SQL Date** formats.
    * Handled missing values using **Self-Joins** and NULL logic.
    * Filtered out incomplete records to ensure high data quality.

### 2. Global Layoffs - Exploratory Data Analysis (EDA)
> **Note:** This analysis was performed using the `layoffs_staging2` table created in the cleaning phase.
* **Trend Identification:** Identified 2023 as the peak period for global layoffs.
* **Competitive Ranking:** Ranked top-impacted companies using **`DENSE_RANK()`**.
* **Funding vs. Survival:** Analyzed the relationship between capital and layoffs using **CASE Statements**.
* **Industry Deep-Dive:** Pinpointed which sectors faced the most significant workforce reductions globally.

### 3. SQL Fundamentals Practice
* Comprehensive exercises covering basic exploration, `WHERE` clause logic, and complex operators.

---

## Tools & Skills
* **Database Engine:** MySQL
* **Technical Skills:** Data Cleaning & Transformation, Business Intelligence, Time-Series Analysis.
* **SQL Proficiency:** CTEs, Window Functions, Joins, Aggregations, and Conditional Logic.
