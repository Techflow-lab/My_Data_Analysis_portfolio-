# Data Analysis Portfolio

**Zhuoda Li** | Management and Data Science, Technical University of Munich
 zhuodali028@gmail.com

A working portfolio of operational data analysis: taking raw, inconsistent business data and turning it into structured databases, verified tables and reports that people can actually make decisions on. Every project here follows the same path from a messy source file to a trustworthy answer.

The emphasis is deliberately on the unglamorous half of analytics. Most of the value in a real business sits in duplicated order rows, blank customer fields and the same entity spelled three different ways. This repository shows how I find those problems, fix them, and prove the fix worked.

---

## What this repository demonstrates

| Area | Applied in |
| :--- | :--- |
| Relational modeling, DDL, constraints, typed imports | `MySQL/USHousehold_project` |
| Duplicate detection and removal with window functions | `MySQL/USHousehold_project`, `MySQL/world_life_expectancy_project` |
| Standardizing inconsistent values and recovering nulls | `MySQL/world_life_expectancy_project` |
| CTEs, subqueries, temporary tables, aggregation | `MySQL/advancedSQL` |
| String, date and conditional SQL functions | `MySQL/SQL_basics_and_data_cleaning` |
| Python cleaning and exploratory analysis with Pandas | `Python_project` |
| Business dashboards and visual reporting | `PowerBI`, `Excel` |

---

## Projects

### 1. US Household Income: raw file to queryable database
`MySQL/USHousehold_project`

**The situation.** A flat export of roughly thirty thousand geographic and income records, delivered with duplicate row identifiers, missing place names and state names entered inconsistently in the same column.

**What I did.**
* Defined a typed schema with a primary key and explicit `NOT NULL` constraints, then loaded the raw records into it, moving the data out of a spreadsheet shape and into a structure that can be queried and joined.
* Removed duplicate rows using `ROW_NUMBER() OVER (PARTITION BY ...)` inside a subquery, then reran a grouped count to confirm every identifier appeared exactly once.
* Standardized inconsistent categorical values, for example collapsing `alabama` into `Alabama`, correcting a misspelled `georia`, and merging `Boroughs` into `Borough` so that grouping by category returns honest totals.
* Filled missing `Place` values from related records instead of deleting the rows, preserving the underlying observations.
* Produced state level aggregations of land and water area, and joined the cleaned location table against the income statistics table for mean and median household income by state and by area type.

**Why it matters.** Before the cleanup, a simple `GROUP BY State_Name` would have reported Alabama twice and undercounted every total. That is the class of silent error this project is built to catch.

---

### 2. World Life Expectancy: data quality pipeline
`MySQL/world_life_expectancy_project`

**The situation.** A country and year panel dataset with duplicated country and year combinations, blank development status fields and missing life expectancy values.

**What I did.**
* Identified duplicate country and year pairs with a grouped `HAVING COUNT(...) > 1` check before touching anything, so the scope of the problem was known first.
* Deleted only the surplus rows using a window function ranking, keeping the original observation intact.
* Recovered blank status values with a self join on the same country, inferring the correct label from the country's other years rather than dropping records.
* Interpolated missing life expectancy values from the adjacent years of the same country.
* Ran a verification query after each step to prove the table was clean before moving on.
* Analysed the cleaned data: life expectancy growth over fifteen years by country, the relationship between GDP and life expectancy across development groups, and BMI and mortality correlations, using rolling totals and window functions.

**Why it matters.** Cleaning is only credible when it is checked. Each transformation in this project is paired with the query that confirms it.

---

### 3. Advanced SQL patterns
`MySQL/advancedSQL`

Reusable query patterns applied to a bakery orders database: common table expressions, subqueries, temporary tables and grouped aggregation over customer orders, including derived metrics such as average tip per product. Includes the database setup script so the queries can be reproduced from scratch.

---

### 4. SQL fundamentals and data cleaning functions
`MySQL/SQL_basics_and_data_cleaning`

A worked reference over a customer and film database covering string functions, date and time handling, `CASE` logic, `UNION`, and pattern location, plus a customer sweepstakes source file used for cleaning practice. These are the everyday tools for normalizing free text fields such as names, cities and addresses before import.

---

### 5. Python data cleaning and exploratory analysis
`Python_project`

Jupyter notebooks working through a large job postings dataset with Pandas and NumPy:
* `01pythonbasics.ipynb`, `02unit_of_mesurement.ipynb` : core Python and unit conversion logic.
* `03regex_usecase.ipynb` : regular expressions for extracting and validating patterns inside untidy text fields.
* `04pandas_basics.ipynb` : dataframe manipulation, filtering and selection.
* `06job_data.ipynb` : loading a real job postings dataset, converting posting dates to datetime, deriving a month column, handling missing salary values, and profiling the salary distribution to find the extremes and the median.

---

### 6. Business dashboards
`PowerBI` and `Excel`

* `PowerBI/Finalproject_PowerBI.pbix` : a workforce analytics dashboard built on `HR_Data.xlsx`, reporting headcount and attrition patterns for a non technical audience.
* `Excel/Project 1 - US Debt Tracker Project Completed.xlsx` : a tracker model built with formulas and structured references rather than manual entry, with the accompanying Excel for Data Analytics certificate.
![PowerBI dashboard](C:\vscode\new_data_analysis\PowerBI\Screenshot 2026-08-15 090647.png)

---

## Tools

`PostgreSQL` `MySQL` `Python (Pandas, NumPy, SciPy, Matplotlib)` `Jupyter` `Power BI` `Excel and Google Sheets` `Git`

## Related work

**Hospital Infection Database** : a separate repository containing a full PostgreSQL implementation on German hospital infection data, including schema design, a staging layer, DML and analytical queries in SQL and PL/pgSQL.

---

## How to use this repository

Each project folder is self contained. SQL files run top to bottom in the order they appear and are commented by section, so a reviewer can follow the reasoning rather than just the syntax. Notebooks include the loading step, so they can be rerun end to end.

