# CD PROJEKT – Game Sales Analytics

Portfolio project: a messy sales export is cleaned in **Python (pandas)**, loaded into **PostgreSQL** and analysed with **SQL**, then modelled in **Power BI** to track revenue against monthly targets for *The Witcher* and *Cyberpunk 2077* across platforms and markets (2023–2025).

> **Disclaimer:** all data is fictitious and generated for portfolio purposes. This is an independent project, not affiliated with or endorsed by CD PROJEKT S.A. The logo is used only to identify the case study.

## Business questions
- Are we hitting the monthly revenue target? How does this year compare with last year?
- Which games sell best, and how much revenue comes from DLCs (expansions)?
- PC vs consoles: which platforms and stores drive revenue?
- Which countries and regions matter most, and where are refund rates highest?

## Data cleaning (Python)
`python/my_clean.py` reads `data/raw/sales_raw.csv` (30,350 rows) and writes `data/clean/sales_clean.csv` (30,000 rows).

| Problem in the raw export | Fix |
|---|---|
| 350 duplicated rows | `drop_duplicates()` |
| 605 orders with an empty country | filled with `"Unknown"` |
| Extra spaces in platform names | `str.strip()` |
| Prices with a comma as the decimal separator (`59,99`) | replaced with a dot and converted to `float` |
| `refunded` mixing `yes` / `no` / `Y` / `N` | standardised to `Y` / `N` with `np.where` |
| New column | `net_revenue_eur = price × (1 − discount)` |

## SQL analysis (PostgreSQL)
The clean data and the monthly targets are loaded into a PostgreSQL database (`cdp_basic`) and the business questions are answered in [`sql/03_analysis.sql`](sql/03_analysis.sql):

| # | Question | SQL used |
|---|---|---|
| 1 | Revenue and orders by year | `GROUP BY`, `EXTRACT` |
| 2 | Revenue by game | `GROUP BY`, `ORDER BY ... DESC` |
| 3 | Revenue by platform in 2025 | `WHERE` |
| 4 | Top 5 countries by revenue | `WHERE`, `LIMIT` |
| 5 | Refund rate by country | `CASE WHEN`, `ROUND` |
| 6 | Markets with more than 1,000 orders | `HAVING`, `AVG` |
| 7 | Monthly revenue vs target | `JOIN`, `DATE_TRUNC` |
| 8 | Full price vs discounted orders | `CASE WHEN` + `GROUP BY` |

### Key findings
- **2024 was the weak year:** revenue fell 9.4% vs 2023 and recovered 5.8% in 2025.
- **October 2024 hit only 44% of target**, the biggest miss in the period.
- **Cyberpunk 2077 is the top earner** (€427k) even though *The Witcher 3* has more orders: it sells at a higher price.
- **The United States is the largest market** (€226k), followed by Germany and the United Kingdom.
- **Discounted orders are 23% of orders but only 15% of revenue.**

## Power BI dashboard
5 pages: a cover page + 4 analysis pages.

| Page | What it shows |
|---|---|
| **Home** | Project summary, headline KPIs and navigation |
| **Overview** | Revenue vs target by month, year-to-date, yearly scorecard, revenue by franchise |
| **Games & DLC** | Best-selling titles, base game vs DLC share, discount depth |
| **Platforms** | PC vs consoles, platform mix by year, store scorecard (Steam, GOG.com, PlayStation Store...) |
| **Markets** | Revenue by country and region, Europe share, refund rate by country |

Model: `sales_clean` + `targets` + a `Calendar` table, with DAX measures for revenue, orders, average order value, refund rate, target achievement, year-over-year comparison (`SAMEPERIODLASTYEAR`) and year-to-date (`TOTALYTD`).

The report is saved in the **PBIP** format (`dashboard/`), so the model (TMDL) and the report pages (JSON) are plain text and readable on GitHub.

## Repository structure
```
data/
  raw/          sales_raw.csv, targets.csv   (input)
  clean/        sales_clean.csv              (output of the Python step)
python/
  my_clean.py   data cleaning script
sql/
  01_create_tables.sql   tables in PostgreSQL
  02_check_load.sql      row-count check after loading
  03_analysis.sql        8 business questions
dashboard/
  CDP_Sales_Analytics.pbip   open this file in Power BI Desktop
```

## How to run
```powershell
python -m venv .venv
.venv\Scripts\activate
pip install pandas numpy
python python/my_clean.py
```
Then, in PostgreSQL (pgAdmin): create a database `cdp_basic`, run `sql/01_create_tables.sql`, import `data/clean/sales_clean.csv` into `sales_clean` and `data/raw/targets.csv` into `targets` (CSV, header on), and run `sql/03_analysis.sql`.

Finally, open `dashboard/CDP_Sales_Analytics.pbip` in Power BI Desktop and click **Refresh**.
If your folder is not `C:\Users\<you>\Documents\cdp-basic`, update the `DataFolder` parameter in Power Query.

## Next steps
- [x] Load the clean data into PostgreSQL and answer the business questions with SQL
- [ ] Point the Power BI model to PostgreSQL instead of the CSV files
- [ ] Add dashboard screenshots to this README

## Author
**Gustavo Anselmo** – Data Analyst (Python · SQL · Power BI), based in Warsaw
