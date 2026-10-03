# CD PROJEKT – Game Sales Analytics

Portfolio project: a messy sales export is cleaned in **Python (pandas)** and modelled in **Power BI** to track revenue against monthly targets for *The Witcher* and *Cyberpunk 2077* across platforms and markets (2023–2025).

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
Then open `dashboard/CDP_Sales_Analytics.pbip` in Power BI Desktop and click **Refresh**.
If your folder is not `C:\Users\<you>\Documents\cdp-basic`, update the `DataFolder` parameter in Power Query.

## Next steps
- [ ] Load `sales_clean.csv` into **PostgreSQL** and answer the business questions with SQL
- [ ] Point the Power BI model to PostgreSQL instead of the CSV files
- [ ] Add dashboard screenshots to this README

## Author
**Gustavo Anselmo** – Data Analyst (Python · SQL · Power BI), based in Warsaw
