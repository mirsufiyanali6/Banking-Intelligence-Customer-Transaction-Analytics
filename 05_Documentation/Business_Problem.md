# Business Problem Statement

## Background

A retail bank operates across Mobile, Web, and ATM channels, serving customers who hold Checking, Savings, and Credit accounts. Customer, account, transaction, and product data currently exist as five separate flat extracts with no analytical layer on top — there is no consolidated view of who is transacting, how much money is actually moving, or whether the customer base is healthy.

## Business Objective

Answer, in one place: how much transaction volume and value the bank processes and how it trends over time, which channels and transaction types drive that volume, which customers, regions, account types, and products generate the most value, whether the customer base (33% Active, 38% Suspended, 29% Inactive) is being fully understood, and whether commonly assumed drivers of transaction behavior (transaction type, channel, customer status) actually hold up under statistical scrutiny.

## Workstreams

**Problem 1 — Transaction Volume & Performance**
Quantify total transaction count, value, and average ticket size, and how they trend month over month and year over year.

**Problem 2 — Channel & Transaction Type Analysis**
Determine which channels (Mobile/Web/ATM) and transaction types (Debit/Credit) drive volume and value, and which channel has the highest failure rate.

**Problem 3 — Customer, Account & Regional Performance**
Identify which customers, regions, and account types (Checking/Savings/Credit) generate the most transaction value, and how activity differs across customer status (Active/Suspended/Inactive) and account status (Open/Closed).

**Problem 4 — Product Performance**
Determine which product categories and individual products drive the most transaction value.

**Problem 5 — Statistical Validation**
Test whether commonly assumed drivers of transaction value — transaction type, channel, customer status — are statistically significant, rather than accepting them at face value.

**Problem 6 — Data Quality Assessment**
Identify structural issues — duplicate source files, signed vs. absolute amount handling, undocumented codes — that would undermine trust in the findings if left unaddressed.

## Final Deliverable

A three-page Power BI dashboard suite (Executive Overview, Customer & Account Analysis, Transaction & Product Analysis), backed by SQL Server business-question queries (`Business_Solution.sql`), Python data cleaning and statistical testing (`Exploratory_Data_Analysis.ipynb`, `Statistical_Analysis.ipynb`), and a full business conclusion report (`Business_Conclusion_Report.pdf`) covering methodology, findings, and data quality caveats.
