# KPI Definitions
## Banking Transaction & Customer Analytics

Every KPI below is defined the way it's actually calculated in the SQL layer
(`Business_Solution.sql`) and the Power BI dashboards, so numbers reconcile
across tools. `ABS(TransactionAmount)` is used throughout because signed
amounts (negative = outflow) would otherwise cancel out and understate volume.

---

## Transaction-Level KPIs

| KPI | Definition | Formula | Why it matters |
|---|---|---|---|
| **Total Transactions** | Count of all transaction records | `COUNT(*)` | Baseline activity volume |
| **Total Transaction Value** | Sum of absolute transaction amounts | `SUM(ABS(TransactionAmount))` | Total money movement through the bank |
| **Average Transaction Value** | Mean absolute transaction amount | `AVG(ABS(TransactionAmount))` | Typical ticket size; flags shifts in customer behavior |
| **Transaction Success Rate** | Share of transactions with Status = 'Success' | `COUNT(Success) / COUNT(*) * 100` | Core measure of platform/operational reliability |
| **Transaction Failure Rate (overall / by channel)** | Share of transactions with Status = 'Failed', overall and per channel | `COUNT(Failed) / COUNT(*) * 100`, grouped by `TransactionChannel` | Pinpoints where operational friction is concentrated |
| **Debit/Credit Mix** | Count, total value, and average value split by `TransactionType` | Grouped `COUNT`, `SUM(ABS())`, `AVG(ABS())` by type | Shows whether money is net flowing in or out, and at what ticket size |
| **Channel Performance** | Count and value split by `TransactionChannel` (Mobile/Web/ATM) | Grouped `COUNT`, `SUM(ABS())` by channel | Identifies the highest-volume and highest-value channel |
| **Month-over-Month (MoM) Growth %** | Percentage change in monthly transaction value vs. the prior month | `(CurrentMonthValue - PriorMonthValue) / PriorMonthValue * 100` | Trend direction, independent of absolute scale |
| **Year-over-Year Performance** | Transaction count, value, and average value by calendar year | Grouped by `YEAR(TransactionDate)` | Long-run trajectory across the 2020–2025 window |

## Customer KPIs

| KPI | Definition | Formula | Why it matters |
|---|---|---|---|
| **Total Customers** | Distinct count of customers | `COUNT(DISTINCT CustomerID)` | Base size of the customer book |
| **Active Customer %** | Share of customers with Status = 'Active' | `COUNT(Active) / COUNT(*) * 100` | Direct read on customer-base health |
| **Customer Status Distribution** | Count/share of customers by Status (Active/Suspended/Inactive) | Grouped `COUNT` by `Status` | Surfaces retention risk (currently 38% Suspended, 29% Inactive) |
| **Average Transactions per Customer** | Mean transaction count per customer | `COUNT(TransactionID) / COUNT(DISTINCT CustomerID)` | Engagement depth, not just headcount |
| **Customer Value Concentration** | Top-N customers by total transaction value | `SUM(ABS(TransactionAmount))` per customer, ranked, `TOP 10` | Flags reliance on a small number of high-value customers |
| **Transaction Value by Region** | Total/average transaction value grouped by customer region | Grouped `SUM`/`AVG(ABS())` by `Region` | Geographic performance and expansion targeting |

## Account KPIs

| KPI | Definition | Formula | Why it matters |
|---|---|---|---|
| **Account Count by Type** | Distinct accounts grouped by `AccountType` (Checking/Savings/Credit) | `COUNT(DISTINCT AccountID)` by type | Product-line footprint |
| **Transaction Value by Account Type** | Total/average value of transactions tied to each account type | Grouped `SUM`/`AVG(ABS())` via account join | Which account type drives the most activity |
| **Open vs. Closed Account Activity** | Transaction count/value split by account `Status` | Grouped `SUM`/`AVG(ABS())` by `Status` | Confirms closed accounts aren't generating live transactions (data-quality check) and quantifies churn impact |

## Product KPIs

| KPI | Definition | Formula | Why it matters |
|---|---|---|---|
| **Transaction Value by Product Category** | Total value rolled up from Product → Subcategory → Category | Grouped `SUM(ABS())` via category joins | Identifies the strongest product line (A/B/C) |
| **Top Products by Value** | Individual products ranked by total transaction value | `SUM(ABS())` per product, `TOP 10` | Product-level focus for merchandising/cross-sell |

## Statistical Validation KPIs

These aren't dashboard tiles — they're the tests used to confirm whether a
pattern above is real or just noise:

| Test | Question it answers | Result in this dataset |
|---|---|---|
| **Independent T-Test** | Does average transaction value differ between Debit and Credit? | No (p = 0.816) |
| **One-Way ANOVA** | Does average transaction value differ across Mobile/Web/ATM? | No (p = 0.285) |
| **Chi-Square Test** | Is customer status associated with channel choice? | No (p = 0.214) |
| **Pearson Correlation** | How strongly does transaction frequency relate to total value? | Very strong (r = 0.99) |
| **95% Confidence Interval** | What's the plausible range for the true average transaction value? | $2,479.62 – $2,535.90 |

*Significance threshold (α) = 0.05 across all tests.*
