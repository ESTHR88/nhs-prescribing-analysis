# NHS Prescribing Analysis

## Project Overview
This project analyses NHS prescribing data using SQL Server and Tableau Public to explore prescribing expenditure, activity and cost distribution across hospital trusts and BNF products.

The project is being developed in stages, starting with an overview dashboard and expanding into more detailed trust-level and product-level analysis.

## Project Objectives
- Identify hospital trusts with the highest prescribing expenditure.
- Identify BNF products contributing most to Actual Cost.
- Summarise key prescribing activity and expenditure measures.
- Validate data quality before performing analysis.

## Tools Used
- **SQL Server:** Data validation, exploratory data analysis (EDA) and business analysis queries.
- **Tableau Public:** Dashboard development and data visualisation.
- **GitHub:** Project documentation and version control.

## Data Preparation and Validation
The dataset was imported into SQL Server and checked for:
- Row counts and data types.
- Missing values and duplicate records.
- Negative and zero values.
- Unusual or high-cost records requiring further investigation.

## Current Tableau Dashboard: NHS Prescribing Analysis
The first dashboard provides an overview of prescribing expenditure and activity through six KPIs:
- Number of Hospital Trusts.
- Distinct BNF Codes.
- Total Items.
- Total Quantity.
- Total NIC.
- Total Actual Cost.

It also includes two visualisations:
1. **Top 10 BNF Products by Actual Cost** — identifies products with the highest recorded actual expenditure.
2. **Top 10 Trusts by Actual Cost** — compares hospital trusts with the highest recorded actual expenditure.

Hospital Trust and BNF Name filters are available to support interactive exploration of the dashboard.

## Initial Data Findings
- **Records:** 165,783
- **Hospital Trusts:** 191
- **Distinct BNF Codes:** 5,606
- **Total Actual Cost:** Approximately £8.75 million
- **Total NIC:** Approximately £9.06 million

The supplied dataset covers a single reporting date, so time-trend analysis is not included.

## Planned Enhancements
The next development stages are:
- **Trust Analysis Dashboard:** Further examination of prescribing volume, expenditure and cost per item across trusts.
- **Product Analysis Dashboard:** Further examination of high-cost products, Actual Cost versus NIC, and trust–product combinations.

These dashboards are planned extensions and are not part of the current dashboard yet.

## Limitations
The analysis describes the supplied dataset and its reporting period. High expenditure alone does not establish inappropriate prescribing or poor value for money; further clinical and contextual investigation would be required.

## Project Files
- `NHS_Prescribing_Analysis.sql` — SQL data validation, EDA and business analysis.
- `NHS_Prescribing_Dashboard.png` — screenshot of the current overview dashboard.


