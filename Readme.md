# Airline Performance Analysis Using SQL

## Project Overview

This project analyzes airline performance using SQL to extract business insights from flight, revenue, customer, and operational data.

The analysis focuses on identifying performance trends, cancellations, cancellation reasons, Airspace closure reasons, closure time, flights delay time, comparing key metrics, and answering business questions through SQL queries.

## Objectives

- Evaluate overall airline performance using key metrics.
- Analyze revenue and flight performance.
- Identify top-performing airlines, routes, or other relevant categories.
- Explore customer behavior and operational trends.
- Translate query results into actionable business insights.

## Tools & Technologies

- SQL
- SQL Server
- Dataset Source - Kaggle

## Repository Structure

```text
Airline-Performance-Analysis-SQL/
│
├── README.md
│
├── SQL-Queries/
│   ├── 01_Data_Exploration/
│   │   └── CTEs.sql
│   │
│   ├── 02_Airport_Disruptions/
│   │   └── Airport_Disruption_Analysis.sql
│   │
│   ├── 03_Airspace_Closures/
│   │   └── Airspace_Closure_Analysis.sql
│   │
│   ├── 04_Flight_Cancellations/
│   │   └── Flight_Cancellation_Analysis.sql
│   │
│   ├── 05_Flight_Rerouting/
│   │   └── Flight_Reroute_Analysis.sql
│   │
│   ├── 06_Financial_Impact/
│   │   └── Loss_Estimation_By_Airline.sql
│   │
│   ├── 07_Window_Functions/
│   │   └── Window_Function_Analysis.sql
│   │
│   ├── 08_Stored_Procedures/
│   │   ├── Airline_Loss_Report.sql
│   │   ├── Severity_Disruption_Report.sql
│   │   └── Reroute_Cost_Check.sql
│   │
│   └── 09_Views_and_Temp_Tables/
│       └── Views_and_Temp_Tables.sql
│
├── Results/
│   ├── Airline_Estimated_Loss_Report.csv
│   ├── Disruption_Summary.csv
│   ├── Flight_Cancellation_Reasons.csv
│   ├── Loss_Estimation_By_Airline.csv
|   └── Disruption Reason.csv
│
└── Airline-Dataset/
    ├── Airline_Losses/
    ├── Airline_Losses_Estimate/
    ├── Airport_Disruption/
    ├── Airspace_Closures/
    ├── Conflict_Events/
    ├── Flight_Cancellations/
    └── Flight_Reroutes/
```

## Analysis & Key Findings

### 1. Airport Disruption Analysis

**Business questions**
- Which disruption most affected the airports?
- What disurption occoured at airports?
- What were the reasons of that disruption?

**Key findings**
- Partial Closure disruption most affected the airports.
- Air Traffic Control (ATC) was restricted due to Re-escalation - Full airspace Lockdown.

### 2. Airspace Closure

**Business questions**
- Averge Airspace Closure days by country?
- Which countries were most affected by closure?

**Key findings**
- Average closure of different countries are different from 1-7 days.
- Lebonan, Iraq, Syria, Iran and Yemen are most affected countries.

## Results

Query outputs are available in the [`results/`](results/) folder. Each result file is named according to the analysis it supports.

The SQL scripts contain the corresponding queries, making the analysis reproducible and easy to review.

## Conclusion

This project demonstrates the use of SQL for data analysis, aggregation, ranking, and business-oriented reporting. The results help summarize airline performance and identify areas for further investigation.

## Disclaimer

Findings are based on the dataset used in this project and should be interpreted within its scope and limitations.
