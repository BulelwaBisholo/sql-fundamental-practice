-- 1. The below is a basic data exploration
-- Retrieving all columns to understand the table struscture

SELECT *
from Parks_and_Recreation.employee_demographics;

-- 2. Arithmetic Operations and PEMDAS          
-- Here I am demonstrating the order of operations by calculating a projected age metric
SELECT first_name, 
last_name, 
birth_date,
age,
(age + 10) *10 AS age_calculation -- I've added an 'alias' to name the column
FROM Parks_and_Recreation.employee_demographics;

#PEMDAS is the order of operations for arithmatic and math within mysql

-- 3. I am using DISTINCT below to work/look for unique values 
-- To identify unique combinations of names and gender

SELECT DISTINCT first_name, gender 
FROM Parks_and_Recreation.employee_demographics;