# 📊 Home Credit Default Risk — SQL Analysis Project

## 👩🏽‍💻 Author
Bulelwa Bisholo  
GitHub: https://github.com/BulelwaBisholo/data-analytics-sql-projects

---

## 📌 Project Overview

*This project demonstrates how SQL can be used to analyze credit risk patterns and simulate lending decisions using a rule-based scoring approach.*

The goal is to simulate a basic **credit risk analysis workflow** using SQL by:
- Understanding client demographics and financial behavior
- Identifying risk patterns linked to default status
- Building a simple rule-based credit risk scoring model

---

## 🎯 Problem Statement

Financial institutions need to assess whether a client is likely to default on a loan.  
This project explores:
- Who is most likely to default?
- What financial and demographic factors influence default risk?
- Can we simulate a simple credit risk decision system using SQL?

---

## 🛠 Tools Used

- MySQL Workbench
- SQL (Joins, CASE statements, Aggregations, CTEs)
- Kaggle Dataset: Home Credit Default Risk

---

## 📂 Dataset

The dataset contains client-level financial and demographic information such as:
- Income
- Loan amount
- Age
- Education level
- Loan repayment status (TARGET variable)

---

## 🔍 Key Analysis Performed

### 1. Data Exploration
- Checked dataset size and structure
- Identified key variables for analysis

### 2. Data Quality Checks
- Checked missing values in financial fields

### 3. Default Risk Analysis
- Distribution of default vs non-default clients
- Default rate across different segments

### 4. Customer Segmentation
- Income-based groups
- Age-based groups
- Education-level analysis

### 5. Financial Behaviour Insights
- Comparison of income, credit, and annuity between defaulters and non-defaulters
- Credit-to-income ratio analysis

---

## 📊 Key Insights

- Clients in lower income brackets exhibit significantly higher default rates
- Younger borrowers (under 30) show increased credit risk compared to older groups
- High credit-to-income ratios are strongly associated with elevated default probability
- Education level shows a measurable relationship with default behavior
---

## 🧠 Credit Risk Scoring Model (Simulation)

A rule-based scoring system was created to simulate lending decisions using:

- Age risk
- Income risk
- Credit burden (credit-to-income ratio)

Each factor was assigned a risk score (1–3), and combined into a total risk score:

- Low Risk → Approve
- Medium Risk → Review
- High Risk → Reject

This simulates a simplified version of real-world credit decision systems.

## 💡 Business Value

This analysis demonstrates how financial institutions can:
- Identify high-risk customer segments
- Improve lending decision strategies
- Reduce default rates through data-driven insights

---

## 📈 What I Learned

- How to clean and explore large datasets using SQL
- How to structure analytical thinking for business problems
- How financial variables influence credit risk
- How to simulate decision-making systems using data logic

---

## 🚀 Future Improvements

- Add visualizations using Python or Power BI
- Build a predictive model using machine learning
- Improve scoring model with weighted variables
- Perform deeper feature engineering

---

## 📌 Conclusion

This project demonstrates how SQL can be used not just for querying data, but for building structured business insights and simulating real-world credit risk decision systems.
