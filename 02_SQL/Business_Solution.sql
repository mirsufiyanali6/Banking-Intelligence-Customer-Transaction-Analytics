USE Banking;

--1.What are the total number of transactions, total transaction value, and average transaction value?

SELECT
COUNT(*) AS TotalTransactions,
ROUND(SUM(ABS(TransactionAmount)),2) AS TotalTransactionValue,
ROUND(AVG(ABS(TransactionAmount)),2) AS AverageTransactionValue
FROM fact_transaction;

--2.How do Debit and Credit transactions compare in terms of transaction count, total value, and average value?

SELECT
TransactionType,
COUNT(*) AS TransactionCount,
ROUND(SUM(ABS(TransactionAmount)),2) AS TotalTransactionValue,
ROUND(AVG(ABS(TransactionAmount)),2) AS AverageTransactionValue
FROM fact_transaction
GROUP BY TransactionType
ORDER BY TotalTransactionValue DESC;

--3.What percentage of transactions are successful versus failed?

SELECT
Status,
COUNT(*) AS TransactionCount,
ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (),2) AS Percentage
FROM fact_transaction
GROUP BY Status;

--4.Which transaction channel has the highest transaction volume and transaction value?

SELECT
TransactionChannel,
COUNT(*) AS TransactionCount,
ROUND(SUM(ABS(TransactionAmount)),2) AS TotalTransactionValue,
ROUND(AVG(ABS(TransactionAmount)),2) AS AverageTransactionValue
FROM fact_transaction
GROUP BY TransactionChannel
ORDER BY TotalTransactionValue DESC;

--5.Which transaction channel has the highest transaction failure rate?

SELECT
TransactionChannel,
COUNT(*) AS TotalTransactions,
SUM(CASE WHEN Status = 'Failed' THEN 1 ELSE 0 END) AS FailedTransactions,
ROUND(SUM(CASE WHEN Status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS FailureRate
FROM fact_transaction
GROUP BY TransactionChannel
ORDER BY FailureRate DESC;

--6.How does the Debit/Credit transaction mix differ across Mobile, Web, and ATM channels?

SELECT
TransactionChannel,
TransactionType,
COUNT(*) AS TransactionCount,
SUM(ABS(TransactionAmount)) AS TransactionValue
FROM fact_transaction
GROUP BY TransactionChannel, TransactionType
ORDER BY TransactionChannel, TransactionValue DESC;

--7.How do transaction volume and transaction value change month by month?

SELECT
YEAR(TransactionDate) AS Year,
MONTH(TransactionDate) AS Month,
COUNT(*) AS TransactionCount,
SUM(ABS(TransactionAmount)) AS TransactionValue
FROM fact_transaction
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY Year, Month;

--8.How does transaction performance compare across different years?

SELECT
YEAR(TransactionDate) AS Year,
COUNT(*) AS TransactionCount,
ROUND(SUM(ABS(TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(TransactionAmount)),2) AS AverageTransactionValue
FROM fact_transaction
GROUP BY YEAR(TransactionDate)
ORDER BY Year;

--9.Which months generate the highest transaction value?

SELECT
MONTH(TransactionDate) AS MonthNumber,
DATENAME(MONTH, TransactionDate) AS MonthName,
COUNT(*) AS TransactionCount,
ROUND(SUM(ABS(TransactionAmount)),2) AS TransactionValue
FROM fact_transaction
GROUP BY MONTH(TransactionDate), DATENAME(MONTH, TransactionDate)
ORDER BY TransactionValue DESC;

--10.What is the month-over-month growth in transaction value?

WITH MonthlyTransactions AS (
SELECT
DATEFROMPARTS(YEAR(TransactionDate), MONTH(TransactionDate), 1) AS MonthStart,
ROUND(SUM(ABS(TransactionAmount)),2) AS TransactionValue
FROM fact_transaction
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
),
MonthlyGrowth AS (
SELECT
MonthStart,
TransactionValue,
LAG(TransactionValue) OVER (ORDER BY MonthStart) AS PreviousMonthValue
FROM MonthlyTransactions
)
SELECT
MonthStart,
TransactionValue,
PreviousMonthValue,
ROUND((TransactionValue - PreviousMonthValue) * 100 / NULLIF(PreviousMonthValue, 0),2) AS MoM_Growth_Percentage
FROM MonthlyGrowth
ORDER BY MonthStart;

--11.Which customers generate the highest total transaction value?

SELECT TOP 10
c.CustomerID,
c.Region,
c.Status,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue
FROM customer c
JOIN account a
ON c.CustomerID = a.CustomerID
JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerID, c.Region, c.Status
ORDER BY TransactionValue DESC;

--12.How does transaction activity differ between Active, Inactive, and Suspended customers?

SELECT
c.Status AS CustomerStatus,
COUNT(DISTINCT c.CustomerID) AS CustomerCount,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(t.TransactionAmount)),2) AS AverageTransactionValue
FROM customer c
LEFT JOIN account a
ON c.CustomerID = a.CustomerID
LEFT JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY c.Status
ORDER BY TransactionValue DESC;

--13.Which regions generate the highest transaction volume and transaction value?

SELECT
c.Region,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(t.TransactionAmount)),2) AS AverageTransactionValue
FROM customer c
JOIN account a
ON c.CustomerID = a.CustomerID
JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY c.Region
ORDER BY TransactionValue DESC;

--14.Which customers have the highest number of transactions?

SELECT TOP 10
c.CustomerID,
c.Region,
c.Status,
ROUND(COUNT(t.TransactionID),2) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue
FROM customer c
JOIN account a
ON c.CustomerID = a.CustomerID
JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY c.CustomerID, c.Region, c.Status
ORDER BY TransactionCount DESC;

--15.Which account type generates the highest transaction volume and transaction value?

SELECT
a.AccountType,
COUNT(DISTINCT a.AccountID) AS AccountCount,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(t.TransactionAmount)),2) AS AverageTransactionValue
FROM account a
LEFT JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY a.AccountType
ORDER BY TransactionValue DESC;

--16.How does transaction activity differ between Open and Closed accounts?

SELECT
a.Status AS AccountStatus,
COUNT(DISTINCT a.AccountID) AS AccountCount,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(t.TransactionAmount)),2) AS AverageTransactionValue
FROM account a
LEFT JOIN fact_transaction t
ON a.AccountID = t.AccountID
GROUP BY a.Status
ORDER BY TransactionValue DESC;

--17.Which product categories generate the highest transaction value?

SELECT
c.ProductCategoryID,
c.ProductCategoryName,
ROUND(COUNT(t.TransactionID),2) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue
FROM category c
JOIN subcategory s
ON c.ProductCategoryID = s.ProductCategoryID
JOIN product p
ON s.ProductSubCategoryID = p.ProductSubcategoryID
JOIN fact_transaction t
ON p.ProductID = t.ProductID
GROUP BY c.ProductCategoryID, c.ProductCategoryName
ORDER BY TransactionValue DESC;

--18.Which individual products generate the highest transaction value?

SELECT TOP 10
p.ProductID,
p.ProductName,
COUNT(t.TransactionID) AS TransactionCount,
ROUND(SUM(ABS(t.TransactionAmount)),2) AS TransactionValue,
ROUND(AVG(ABS(t.TransactionAmount)),2) AS AverageTransactionValue
FROM product p
JOIN fact_transaction t
ON p.ProductID = t.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TransactionValue DESC;