# 📊 Home Credit Default Risk — SQL & Power BI Analysis Project

## 👩🏽‍💻 Author

Bulelwa Bisholo  
GitHub: https://github.com/BulelwaBisholo/data-analytics-sql-projects

---

## 📌 Project Overview

*This project demonstrates how SQL and Power BI can be used to analyze credit risk patterns and simulate lending decisions using a rule-based scoring approach.*

The goal is to simulate a basic **credit risk analysis workflow** by:

- Understanding client demographics and financial behavior
- Identifying risk patterns linked to default status
- Building a simple rule-based credit risk scoring model
- Visualizing key insights in an interactive Power BI dashboard

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
- Power BI Service (browser-based)
- SQL (Joins, CASE statements, Aggregations, CTEs, Window Functions)
- Kaggle Dataset: Home Credit Default Risk

---

## 📂 Dataset

The dataset contains client-level financial and demographic information such as:

- Income
- Loan amount
- Age
- Occupation type
- Loan repayment status (TARGET variable)

---

## 🔍 Key Analysis Performed

### 1. Data Exploration
- Checked dataset size and structure
- Identified key variables for analysis

### 2. Data Quality Checks
- Checked missing values in financial fields
- Flagged DAYS_EMPLOYED anomaly (suspicious positive values)

### 3. Default Risk Analysis
- Distribution of default vs non-default clients
- Default rate across different segments

### 4. Customer Segmentation
- Income-based groups
- Debt-to-income groups
- Age group and gender analysis
- Occupation type analysis

### 5. Financial Behaviour Insights
- Comparison of income, credit, and annuity between defaulters and non-defaulters
- Credit-to-income ratio analysis

---

## 📊 Power BI Dashboard

An interactive dashboard was built in Power BI Service to visualize key findings:

![Home Credit Default Risk Dashboard](Power-BI-Dashboard/Home-Credit-Dashboard.png)

**Visuals included:**
- 🍩 Default Rate overview (Donut Chart)
- 📊 Default Rate by Income Group
- 📊 Default Rate by Debt-to-Income Group
- 📊 Default Rate by Age Group and Gender
- 📊 Default Rate by Occupation Type

---

## 📊 Key Insights

- **91.91%** of clients are non-defaulters; **8.09%** default rate overall
- **Young male clients (Under 30)** carry the highest default risk at **12.60%**
- **Low-skill laborers** have the highest occupation default rate at **17.23%** — over 3x that of accountants (4.85%)
- **Middle Income** clients default more than Low Income clients — a counterintuitive finding worth investigating
- **Moderate debt burden** clients default at a higher rate than high debt burden clients (8.27% vs 8.08%)
- Older female clients (Over 60) represent the **lowest risk segment** at 4.55%

---

## 🧠 Credit Risk Scoring Model (Simulation)

A rule-based scoring system was created to simulate lending decisions using:

- Age risk
- Income risk
- Credit burden (credit-to-income ratio)

Each factor was assigned a risk score (1–3), combined into a total risk score:

- ✅ Low Risk → **Approve**
- ⚠️ Medium Risk → **Review**
- ❌ High Risk → **Reject**

This simulates a simplified version of real-world credit decision systems.

---

## 💡 Business Value

This analysis demonstrates how financial institutions can:

- Identify high-risk customer segments
- Improve lending decision strategies
- Reduce default rates through data-driven insights
- Target demographic and occupational risk profiles for tailored credit products

---

## 📈 What I Learned

- How to clean and explore large datasets (307K rows) using SQL
- How to structure analytical thinking for business problems
- How financial variables influence credit risk
- How to simulate decision-making systems using data logic
- How to build and format a professional dashboard in Power BI Service

---

## 🚀 Future Improvements

- Build a predictive model using machine learning
- Improve scoring model with weighted variables
- Perform deeper feature engineering
- Add time-series analysis on repayment behaviour

---

## 📌 Conclusion

This project demonstrates how SQL and Power BI can be used not just for querying data, but for building structured business insights, simulating real-world credit risk decision systems, and communicating findings through professional data visualizations.
