# Data Analysis Portfolio

**Zhuoda Li** — Management & Data Science, Technical University of Munich
📧 zhuodali028@gmail.com

![SQL](https://img.shields.io/badge/SQL-MySQL-4479A1?logo=mysql&logoColor=white)
![Python](https://img.shields.io/badge/Python-Pandas%20%7C%20NumPy-3776AB?logo=python&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboards-F2C811?logo=powerbi&logoColor=black)
![Excel](https://img.shields.io/badge/Excel-Modeling-217346?logo=microsoftexcel&logoColor=white)

---

## Overview

This repository is a working portfolio of **operational data analysis** — taking raw, inconsistent business data and turning it into structured databases, verified tables, and reports people can act on.

Every project follows the same discipline: **ingest → audit → clean → verify → analyze → report.** The emphasis is deliberately placed on the unglamorous half of analytics, because that is where most real-world project time — and most real-world risk — actually lives. Duplicated rows, blank fields, and inconsistently-labeled categories silently corrupt aggregate metrics far more often than any modeling choice does.

---

## Table of Contents

- [Skills Matrix](#skills-matrix)
- [SQL Projects](#sql-projects)
- [Python Projects](#python-projects)
- [Business Dashboards & Models](#business-dashboards--models)
- [Repository Structure](#repository-structure)
- [Certifications](#certifications)
- [Tools & Stack](#tools--stack)
- [Methodology](#methodology)
- [Housekeeping Notes](#housekeeping-notes)
- [How to Use This Repository](#how-to-use-this-repository)

---

## Skills Matrix

| Area | Demonstrated In |
|---|---|
| Relational modeling, DDL, typed schema design | `MySQL/USHousehold_project` |
| Duplicate detection & removal with window functions | `USHousehold_project`, `world_life_expectancy_project` |
| Standardizing inconsistent categorical values, recovering nulls | `USHousehold_project`, `world_life_expectancy_project` |
| Procedural SQL / cleaning automation (stored procedures) | `MySQL/advancedSQL/datacleanautomation_project.sql` |
| CTEs, subqueries, temp tables, aggregation | `MySQL/advancedSQL/Advanced_sql.sql` |
| String, date, and conditional SQL functions | `MySQL/SQL_basics_and_data_cleaning` |
| Pandas data cleaning, feature engineering, EDA | `Python_project` (job postings, movies, food marketing) |
| Regex-based text extraction/validation | `Python_project/03regex_usecase.ipynb` |
| Business dashboards and visual reporting | `PowerBI`, `Excel` |

---

## SQL Projects

### 1. US Household Income — Raw File to Queryable Database
`MySQL/USHousehold_project/`

| File | Role |
|---|---|
| `USHouseholdIncome.sql` | Typed schema (`CREATE TABLE`) + full data load (~30K `INSERT` rows) for the geographic/demographic table |
| `USHouseholdIncome_Statistics.sql` | Schema + data load for the companion income-statistics table (mean, median, stdev by area) |
| `project_2.sql` | The actual cleaning and analysis logic |

**Situation.** A flat export of roughly 30,000 geographic and income records, delivered with duplicate row identifiers, missing place names, and state names entered inconsistently within the same column.

**Approach (`project_2.sql`).**
- Removed duplicate rows using `ROW_NUMBER() OVER (PARTITION BY row_id ...)` inside a subquery, then reran a grouped count to confirm every identifier appeared exactly once.
- Standardized inconsistent categorical values — e.g. correcting the misspelled `georia` to `Georgia`, `alabama` to `Alabama`, and merging `Boroughs` into `Borough`.
- Backfilled a missing `Place` value (`Autaugaville`) rather than deleting the row.
- Aggregated total land and water area by state, then joined the cleaned location table against the statistics table to compute average mean/median household income by state and by property type — filtering out zero-value statistics and low-count categories (`HAVING COUNT(Type) > 100`) to keep results statistically meaningful.

**Why it matters.** Before cleanup, a simple `GROUP BY State_Name` would have reported Alabama twice and undercounted every total — exactly the class of silent error this project is built to catch.

---

### 2. World Life Expectancy — Data Quality Pipeline
`MySQL/world_life_expectancy_project/SQL_project1.sql`

**Situation.** A country-and-year panel dataset with duplicated country/year combinations, blank development-status fields, and missing life-expectancy values.

**Approach.**
- Identified duplicate `(country, year)` pairs with a grouped `HAVING COUNT(...) > 1` check *before* modifying anything, using `CONCAT(country, year)` as the composite key.
- Deleted only the surplus rows via a `ROW_NUMBER()` window-function ranking, keeping the original observation intact.
- Recovered blank status values via a self-join on the same country, inferring the correct label from that country's other years.
- Interpolated missing life-expectancy values from adjacent years of the same country.
- Analyzed the cleaned data: life-expectancy growth over time, the GDP–life-expectancy relationship across development groups, and BMI/mortality correlations using rolling totals and window functions.

**Why it matters.** Cleaning is only credible when it's checked — each transformation here is paired with a verification query before moving to the next step.

---

### 3. Advanced SQL Patterns
`MySQL/advancedSQL/`

Two distinct scripts, plus supporting data files:

- **`Advanced_sql.sql`** — CTEs, subqueries, and grouped aggregation applied to a bakery orders database (e.g. filtering CTE results by aggregated tip totals, computing average tip per product). Data: `USHouseholdIncome.csv`, `software_jobs.csv`.
- **`datacleanautomation_project.sql`** — the US Household cleaning routine re-implemented as a MySQL **stored procedure** (`Copy_and_clean_data`), which creates a cleaned target table, loads it, deduplicates, and standardizes values in one reusable, re-runnable unit — moving from one-off scripts toward a repeatable cleaning pipeline.
- Includes a completed **Advanced MySQL for Data Analysis** certificate.

---

### 4. SQL Fundamentals & Data Cleaning Functions
`MySQL/SQL_basics_and_data_cleaning/MySQL_basics_data_cleaning.sql`

A worked reference over a customer-and-film database: string functions (`LENGTH`, `LEFT`, `RIGHT`), `UNION` for combining labeled subsets, date/time handling, and conditional logic. Paired with `customer_sweepstakes.csv` for hands-on cleaning practice. These are the everyday tools for normalizing free-text fields — names, cities, addresses — before import.

---

## Python Projects
`Python_project/`

Jupyter notebooks working through Pandas, NumPy, and visualization across three real datasets:

| Notebook | Dataset | Focus |
|---|---|---|
| `01pythonbasics.ipynb` | — | Core Python fundamentals |
| `02unit_of_mesurement.ipynb` | — | Unit-conversion logic |
| `03regex_usecase.ipynb` | — | Regular expressions for extracting/validating patterns in untidy text fields |
| `04pandas_basics.ipynb` | — | DataFrame manipulation, filtering, and selection |
| `05job_data.ipynb` | Job postings dataset | Datetime conversion, deriving a posting-month column, dropping missing salaries, salary distribution (min/max/median), country- and title-level breakdowns, pivoted monthly trend lines merged against an external comparison dataset |
| `06movie_project.ipynb` | `imdb_movies.csv` | Deduplication, dropping rows with missing genre data, computing profit (`revenue − budget`), exploding pipe-delimited multi-genre fields into individual rows, and visualizing genre frequency and average revenue by genre |
| `07food_marketing.ipynb` | `u_food_marketing.csv` (+ data dictionary image) | Deduplication, feature engineering (`total_children`, `accepted_campaigns`), mapping encoded marital-status values back to labels, correlation analysis against campaign acceptance, and Seaborn visualizations of spend by age group and marital status |

---

## Business Dashboards & Models

- **`PowerBI/Finalproject_PowerBI.pbix`** — a workforce-analytics dashboard built on `HR_Data.xlsx`, reporting headcount and attrition patterns for a non-technical audience. A reference screenshot is included (`Screenshot 2026-08-15 090647.png`).
- **`Excel/Project 1 - US Debt Tracker Project Completed.xlsx`** — a tracker model built with formulas and structured references rather than manual entry.
- Both folders include the corresponding completion certificates.

---

## Repository Structure

```
My_Data_Analysis_portfolio-/
├── MySQL/
│   ├── USHousehold_project/
│   │   ├── USHouseholdIncome.sql              # schema + data load
│   │   ├── USHouseholdIncome_Statistics.sql   # schema + data load
│   │   └── project_2.sql                      # cleaning & analysis logic
│   ├── world_life_expectancy_project/
│   │   ├── SQL_project1.sql
│   │   └── WorldLifeExpectancy (1).csv
│   ├── advancedSQL/
│   │   ├── Advanced_sql.sql
│   │   ├── datacleanautomation_project.sql     # stored-procedure cleaning
│   │   ├── USHouseholdIncome.csv
│   │   ├── software_jobs.csv
│   │   └── Zhuoda Li - Advanced MySQL for Data Analysis Certificate.pdf
│   ├── SQL_basics_and_data_cleaning/
│   │   ├── MySQL_basics_data_cleaning.sql
│   │   └── customer_sweepstakes.csv
│   └── Git-2.53.0.2-64-bit.exe                 # ⚠ see Housekeeping Notes
├── Python_project/
│   ├── 01pythonbasics.ipynb
│   ├── 02unit_of_mesurement.ipynb
│   ├── 03regex_usecase.ipynb
│   ├── 04pandas_basics.ipynb
│   ├── 05job_data.ipynb
│   ├── 06movie_project.ipynb
│   ├── 07food_marketing.ipynb
│   ├── imdb_movies.csv
│   ├── u_food_marketing.csv
│   └── ufood_marketing_Dictionary.png
├── PowerBI/
│   ├── Finalproject_PowerBI.pbix
│   ├── HR_Data.xlsx
│   └── Screenshot 2026-08-15 090647.png
├── Excel/
│   ├── Project 1 - US Debt Tracker Project Completed.xlsx
│   └── Zhuoda Li - Excel for Data Analytics Certificate.pdf
├── .vscode/
├── README.md
└── Coursera 1.pdf / Coursera 2.pdf / Coursera 3.pdf / os.pdf   # ⚠ see Housekeeping Notes
```

## Certifications

- Advanced MySQL for Data Analysis — `MySQL/advancedSQL/`
- Excel for Data Analytics — `Excel/`
- Additional Coursera coursework (currently unlabeled at repo root — see below)

## Tools & Stack

`MySQL` · `Python` (Pandas, NumPy, Matplotlib, Seaborn) · `Jupyter` · `Power BI` · `Excel` · `Git`

## Methodology

1. **Audit before touching anything.** Duplicate and inconsistency checks are run and documented before any row is modified.
2. **Prefer recovery over deletion.** Missing values are inferred from related records (self-joins, adjacent time periods) wherever possible.
3. **Verify every transformation.** Each cleaning step is followed by a query that proves it worked.
4. **Move from scripts toward pipelines.** The `datacleanautomation_project.sql` stored procedure shows the same cleaning logic re-packaged as a reusable, re-runnable unit rather than a one-off script.

## Housekeeping Notes

A few items worth cleaning up to keep the repository reviewer-ready:

- **`MySQL/Git-2.53.0.2-64-bit.exe`** — a Git installer appears to have been committed by accident. Recommend removing it and adding a `.gitignore` entry for `*.exe`.
- **`Coursera 1.pdf`, `Coursera 2.pdf`, `Coursera 3.pdf`, `os.pdf`** — these sit at the repo root with no descriptive names or context. Recommend renaming them to reflect their actual content (or moving them into a `certificates/` folder alongside the other two named certificates) so a reviewer isn't left guessing.
- Consider a top-level `certificates/` folder to consolidate all four+ credential PDFs currently scattered across `Excel/`, `MySQL/advancedSQL/`, and the repo root.

## How to Use This Repository

Each project folder is self-contained. SQL files run top to bottom in the order they appear and are commented by section, so a reviewer can follow the reasoning rather than just the syntax. Notebooks include the data-loading step, so they can be re-run end to end (update local file paths first — some notebooks currently reference absolute local paths, e.g. `C:\vscode\...`).

---

<sub>Feedback and questions are welcome — reach out at zhuodali028@gmail.com.</sub>