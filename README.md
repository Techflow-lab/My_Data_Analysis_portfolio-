# Data Analytics Portfolio — SQL · Python · Power BI

---

## What this repository is

A self-directed portfolio built around one question: **can I take raw, messy source data and carry it all the way to a decision a business stakeholder can act on — end to end, on my own?**

Each project below covers a different segment of that chain. Together they cover the full analyst workflow: *ingest → model → clean → analyse → visualise → communicate.*

| # | Project | Business question | Stack | Deliverable |
|---|---------|-------------------|-------|-------------|
| 1 | [World Life Expectancy](#1-world-life-expectancy--sql-cleaning--eda) | Does national income explain life expectancy? | MySQL | Cleaned table + EDA queries |
| 2 | [US Household Income](#2-us-household-income--sql-cleaning--geo-economic-analysis) | Which states and settlement types have the highest incomes? | MySQL | Cleaned two-table model + analysis |
| 3 | [HR Attrition Dashboard](#3-hr-attrition-dashboard--power-bi) | Who leaves the company, and where should HR intervene? | Power BI, Excel | Interactive `.pbix` dashboard |
| 4 | [Python Analysis Foundations](#4-python-analysis-foundations) | — | Python, pandas, regex | Reference notebooks |

---

## 1. World Life Expectancy — SQL cleaning & EDA

`MySQL/world_life_expectancy_project/`

A raw WHO-style dataset (~2,900 rows, 193 countries) with duplicates and missing values, cleaned and analysed entirely in SQL.

**Data cleaning**
- **Deduplication** — identified duplicate country–year records with a `ROW_NUMBER() OVER (PARTITION BY ...)` window function over a composite key, then deleted via a subquery on the row IDs.
- **Categorical imputation** — filled blank `Status` values through a self-join that propagates the known Developed / Developing label from other years of the same country.
- **Numeric imputation** — filled missing `Life expectancy` values by **linear interpolation between the adjacent years**, using a triple self-join on `(country, year-1)` and `(country, year+1)`.
- Each cleaning step is followed by an explicit verification query — cleaning is only finished once it is proven.

**Analysis**
- Life expectancy vs. average GDP per country, ranked
- High-GDP vs. low-GDP cohort comparison using conditional aggregation (`SUM(CASE WHEN ...)`)
- Developed vs. developing country groups: country count and average life expectancy
- Life expectancy vs. average BMI, to test whether the income effect is confounded

> **Key finding:** *[Fill in your own 1–2 sentence conclusion with the actual numbers you obtained — e.g. the average life-expectancy gap between the high- and low-GDP cohorts.]*

---

## 2. US Household Income — SQL cleaning & geo-economic analysis

`MySQL/USHousehold_project/`

Two related tables (≈32,000 geographic records + income statistics) joined and analysed in MySQL.

**Data cleaning**
- Duplicate removal via windowed `ROW_NUMBER()`, with a distinct-count check to confirm uniqueness
- **Standardisation of dirty categorical data** — corrected misspelt and inconsistently cased state names (`georia` → `Georgia`, `alabama` → `Alabama`) and harmonised inconsistent place-type labels (`Boroughs` → `Borough`)
- Handled `NULL` place names

**Analysis**
- Total land and water area aggregated by state
- Top 10 states by average median household income (inner join between the geography and statistics tables, zero-income records excluded)
- Income by settlement type (City / Town / Borough / CDP), filtered with `HAVING COUNT(...) > 100` so that small, statistically unreliable categories cannot distort the ranking
- City-level income ranking within each state

> **Key finding:** *[Fill in — e.g. which settlement type carries the highest median income and by how much.]*

---

## 3. HR Attrition Dashboard — Power BI

`PowerBI/Finalproject_PowerBI.pbix` · source data: `HR_Data.xlsx`

An interactive dashboard on 1,470 employee records, built on a **star schema**: one fact table (`HR_Data`, 38 attributes) joined to three dimension tables (`Departments`, `Jobs`, `Education`) via surrogate keys.

**What it covers**
- Overall attrition rate and headcount KPIs
- Attrition broken down by age group, department, job role, salary band, and gender
- Behavioural drivers: overtime, business travel frequency, work–life balance, job satisfaction, years since last promotion
- Cross-filtering so an HR manager can drill from a company-level number to the specific role that produces it

**Why it belongs in an analyst portfolio:** it is the *communication* end of the workflow — the point where the analysis stops being a query result and becomes something a non-technical decision-maker can use.

<img width="1914" height="950" alt="image" src="https://github.com/user-attachments/assets/5b6fdafd-c76a-4e3f-abfc-d227e6fec313" />

---

## 4. Python Analysis Foundations

`Python_project/`

Reference notebooks I maintain and reuse, rather than one-off exercises:

| Notebook | Content |
|---|---|
| `01pythonbasics.ipynb` | Python built-ins for data work, grouped by use case, with target types and mutation behaviour documented |
| `03regex_usecase.ipynb` | Regular expressions for extracting phone numbers, emails, domains and titles from unstructured text |
| `04pandas_basics.ipynb` | NumPy arrays, pandas Series and DataFrame construction and indexing |
| `02unit_of_mesurement.ipynb` | Small control-flow exercise (unit converter) |

---

## Skills map

| Workflow stage | Tools | Where to see it |
|---|---|---|
| Data modelling | Star schema, primary/foreign keys | Power BI model; see also the [PostgreSQL project](https://github.com/Techflow-lab/hospital_infection_database_Germany) |
| Data cleaning | SQL window functions, self-joins, conditional aggregation | Projects 1 & 2 |
| Exploratory analysis | `GROUP BY` / `HAVING` / `CASE`, joins, subqueries; pandas | Projects 1, 2, 4 |
| Text & unstructured data | Python `re` | Project 4 |
| Visualisation & BI | Power BI, DAX, matplotlib | Project 3 |
| Version control | Git, GitHub | This repository |

**Tech stack:** MySQL · PostgreSQL · Python (pandas, NumPy, matplotlib, seaborn, SciPy) · Power BI · Excel · Git · VS Code

---

## How to run

```bash
git clone https://github.com/Techflow-lab/My_Data_Analysis_portfolio-.git
```

- **SQL projects** — create the schema in MySQL, load the CSV in the project folder, then execute the `.sql` script top to bottom (scripts are written in workflow order: clean first, verify, then analyse).
- **Power BI** — open the `.pbix` file in Power BI Desktop; the Excel source is in the same folder.
- **Notebooks** — `pip install pandas numpy matplotlib seaborn`, then open in Jupyter or VS Code.

---

## Related repositories

- **[hospital_infection_database_Germany](https://github.com/Techflow-lab/hospital_infection_database_Germany)** — relational database design and advanced analytical SQL in PostgreSQL (ER model → schema → ETL → window functions → views and functions).
- **[it-ds-journey](https://github.com/Techflow-lab/it-ds-journey)** — university coursework and certification labs: statistics, hypothesis testing, and linear-programming optimisation.

---

*Feedback on any project here is genuinely welcome — open an issue or reach out on LinkedIn.*
