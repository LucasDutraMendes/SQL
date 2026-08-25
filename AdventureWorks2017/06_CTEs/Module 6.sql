/*
=============================================================
Module 06 - Common Table Expressions
=============================================================

Description:
This module introduces Common Table Expressions (CTEs) and
demonstrates how they can be used to organize complex SQL
queries into logical steps.

Topics Covered:
- Basic CTEs
- CTE + Aggregation
- CTE + JOIN
- Multiple CTEs
- CTE + Subqueries
- Multi-Step Transformations
- CASE with CTEs
- Recursive CTEs

Database:
- AdventureWorks2017

Exercises:
16

Author:
Lucas Dutra Mendes

=============================================================
*/

-- CTE
-- 1 The production manager wants to create a report containing only products whose ListPrice is greater than 1000.
-- ORDER BY ListPrice DESC;

WITH CTEListPrice AS
(
	SELECT 
		ProductID,
		Name AS ProductName,
		ListPrice
	FROM Production.Product
	WHERE ListPrice > 1000
)
SELECT * FROM CTEListPrice
ORDER BY ListPrice DESC;

-- 2 The sales manager wants to identify customers whose total sales are greater than 10,000.
-- Group by CustomerID inside the CTE. Order by AverageOrderValue DESC.
 
WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales
FROM CTETotalSales
WHERE TotalSales > 10000
ORDER BY TotalSales DESC;

-- 3 The sales manager wants to identify customers whose average order value is greater than 1,000.
-- Group by CustomerID inside the CTE. Return only customers whose AverageOrderValue is greater than 1,000.

WITH CTEAverageOrderValue AS
(
    SELECT
        CustomerID,
        AVG(TotalDue) AS AverageOrderValue
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID 
)
SELECT 
    CustomerID,
    AverageOrderValue
FROM CTEAverageOrderValue
WHERE AverageOrderValue > 1000
ORDER BY AverageOrderValue DESC;

-- 4 The sales manager wants a report showing each customer together with their total sales amount. 
-- Use a JOIN between the CTE and Sales.Customer. Include only customers with orders. Order by TotalSales DESC.
-- CustomerID - AccountNumber - TotalSales

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT 
    c.CustomerID,
    c.AccountNumber,
    cs.TotalSales
FROM Sales.Customer AS c
INNER JOIN CTETotalSales AS cs
    ON cs.CustomerID = c.CustomerID
ORDER BY TotalSales DESC;

-- 5 The sales manager wants to identify customers whose total sales are greater than 20,000 and display their account number.
-- Calculate total sales per customer using SUM(TotalDue). Group by CustomerID inside the CTE. Join the CTE with Sales.Customer.
-- CustomerID - AccountNumber - TotalSales - Return only customers with TotalSales > 20000. Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT 
    c.CustomerID,
    c.AccountNumber,
    ct.TotalSales
FROM Sales.Customer AS c
INNER JOIN CTETotalSales AS ct
    ON c.CustomerID = ct.CustomerID
WHERE TotalSales > 20000
ORDER BY TotalSales DESC;

-- 6 The sales manager wants to identify customers who have placed at least 5 orders. Group by CustomerID inside the CTE.
-- Join the CTE with Sales.Customer. Return: CustomerID AccountNumber OrderCount

WITH CTEOrderCount AS
(
    SELECT
        CustomerID,
        COUNT(*) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    cte.OrderCount
FROM CTEOrderCount AS cte
INNER JOIN Sales.Customer AS sc
    ON sc.CustomerID = cte.CustomerID
WHERE cte.OrderCount > 4
ORDER BY cte.OrderCount DESC;

-- 7 The sales manager wants to identify customers whose average order value is greater than 2,000. Calculate the average 
-- TotalDue for each CustomerID. Group by CustomerID inside the CTE. Join the CTE with Sales.Customer. Return only customers 
-- with AverageOrderValue > 2000. Return: CustomerID AccountNumber AverageOrderValue - Order by AverageOrderValue DESC.

WITH CTEOrderValue AS
(
    SELECT
        CustomerID,
        AVG(TotalDue) AS AverageOrder
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    cte.AverageOrder
FROM CTEOrderValue AS cte
INNER JOIN Sales.Customer AS sc
    ON sc.CustomerID = cte.CustomerID
WHERE cte.AverageOrder > 2000
ORDER BY cte.AverageOrder DESC;

-- 8 The sales manager wants to identify customers whose total sales exceed 20,000 and whose average order value exceeds 
-- 2,000.Calculate both: SUM(TotalDue) as TotalSales AVG(TotalDue) as AverageOrderValue Group by CustomerID inside the CTE.
-- Join the CTE with Sales.Customer. Return: CustomerID AccountNumber TotalSales AverageOrderValue Return only customers 
-- satisfying both conditions. Order by TotalSales DESC.

WITH CTECustomers AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS SumOrder,
        AVG(TotalDue) AS AverageOrder
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    cte.SumOrder,
    cte.AverageOrder
FROM CTECustomers AS cte
INNER JOIN Sales.Customer AS sc
    ON sc.CustomerID = cte.CustomerID
WHERE cte.SumOrder > 20000 AND
      cte.AverageOrder > 2000    
ORDER BY cte.SumOrder DESC;

-- Multiple CTE
-- 9 The sales manager wants to identify customers whose total sales are above the average total sales per customer.
-- Requirements Use two CTEs. The first CTE must calculate TotalSales for each CustomerID. The second CTE must calculate the
-- average TotalSales across all customers. The final query should return:CustomerID TotalSales - TotalSales is greater than 
-- the average. Order by TotalSales DESC

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS SumOrder
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
CTEAverage AS
(
    SELECT
        AVG(SumOrder) AS AvSales
    FROM CTETotalSales
)
SELECT
    ts.CustomerID,
    ts.SumOrder AS 'Sum>Avg'
FROM CTETotalSales AS ts
CROSS JOIN CTEAverage AS av
WHERE ts.SumOrder > av.AvSales
ORDER BY ts.SumOrder DESC;

-- 10 The sales manager wants to identify customers whose total sales are above the average total sales of all customers 
-- and display their account number. Requirements Use two CTEs. The first CTE must calculate TotalSales for each CustomerID.
-- The second CTE must calculate the average TotalSales from the first CTE. Join the result with Sales.Customer.
-- Return: CustomerID AccountNumber TotalSales - Return only customers whose TotalSales is greater than the overall average.
-- Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS SumOrder
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
),
CTEAverage AS
(
    SELECT
        AVG(SumOrder) AS AvSales
    FROM CTETotalSales
)
SELECT
    c.CustomerID,
    c.AccountNumber,
    ts.SumOrder
FROM CTETotalSales AS ts
CROSS JOIN CTEAverage AS av
INNER JOIN Sales.Customer AS c
    ON c.CustomerID = ts.CustomerID
WHERE ts.SumOrder > av.AvSales
ORDER BY ts.SumOrder DESC;

-- 11 The sales manager wants to identify customers who have placed more than 5 orders and whose total sales are greater
-- than 20,000. Requirements Use two CTEs. CTE 1: calculate the number of orders for each CustomerID. CTE 2: calculate the 
-- total sales for each CustomerID. Join the two CTEs using CustomerID. Join the result with Sales.Customer.
-- Return: CustomerID AccountNumber OrderCount TotalSales - Return only customers satisfying both conditions.
-- Order by TotalSales DESC.

WITH CTEOrders AS
(
    SELECT
        CustomerID,
        COUNT(TotalDue) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
    HAVING COUNT(TotalDue) > 5
),
CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    cto.CustomerID,
    c.AccountNumber,
    cto.OrderCount,
    cts.TotalSales
FROM CTEOrders AS cto
INNER JOIN CTETotalSales AS cts
    ON cto.CustomerID = cts.CustomerID
INNER JOIN Sales.Customer AS c
    ON c.CustomerID = cto.CustomerID
WHERE cts.TotalSales > 20000
ORDER BY cts.TotalSales DESC;

-- CTE + Subquery
-- 12 The sales manager wants to identify customers whose total sales are greater than the average total sales across 
-- all customers. Use a CTE. The CTE must calculate TotalSales for each CustomerID. Use a subquery to calculate the average
-- TotalSales. Return: CustomerID TotalSales Return only customers whose TotalSales is greater than the overall average.
-- Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales
FROM CTETotalSales
WHERE TotalSales >
(
    SELECT
        AVG(TotalSales)
    FROM CTETotalSales
)
ORDER BY TotalSales DESC;

-- 13 The sales manager wants to identify customers whose total sales are greater than the average total sales of customers 
-- who placed more than 5 orders. Use a CTE to calculate: CustomerID TotalSales OrderCount. Group by CustomerID inside the 
-- CTE. Use a subquery to calculate the average TotalSales, considering only customers with more than 5 orders. Return:
-- CustomerID TotalSales Return only customers whose TotalSales is greater than that average. Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales,
        COUNT(TotalDue) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales
FROM CTETotalSales
WHERE TotalSales >
(
    SELECT
        AVG(TotalSales)
    FROM CTETotalSales
    WHERE OrderCount > 5
)
ORDER BY TotalSales DESC;

-- 14 The sales manager wants to classify customers based on their total sales. Use a CTE to calculate TotalSales for each 
-- CustomerID. Group by CustomerID. In the outer query, use CASE to classify customers as 'High Value' when TotalSales 
-- >= 50000 'Medium Value' when TotalSales >= 20000, and 'Low Value' otherwise. Return: CustomerID TotalSales
-- CustomerCategory. Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales,
    CASE
        WHEN TotalSales >= 50000 THEN 'High Value'
        WHEN TotalSales >= 20000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerCategory
FROM CTETotalSales
ORDER BY TotalSales DESC;

-- 15 The sales manager wants to classify customers based on their total sales and number of orders.Use a CTE to calculate 
-- TotalSales and OrderCount for each CustomerID. Group by CustomerID. In the outer query, use CASE to classify customers
-- as 'VIP' when TotalSales >= 50000 and OrderCount >= 10, 'Regular' when TotalSales >= 20000 and OrderCount >= 5, 
-- and 'Low Value' otherwise. Return: CustomerID TotalSales OrderCount CustomerCategory. Order by TotalSales DESC.

WITH CTETotalSales AS
(
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales,
        COUNT(TotalDue) AS OrderCount
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    TotalSales,
    OrderCount,
    CASE
        WHEN TotalSales >=50000 AND OrderCount >= 10 THEN 'VIP'
        WHEN TotalSales >= 20000 AND OrderCount >= 5 THEN 'Regular'
        ELSE 'Low Value'
    END AS CustomerCategory
FROM CTETotalSales
ORDER BY TotalSales DESC;

-- CTE Recursive
-- 16 The HR department wants to display the employee hierarchy starting from the top-level employee.
-- Use a recursive CTE with HumanResources.Employee and the OrganizationNode column.
-- Start with the employee whose OrganizationNode represents the top level of the hierarchy.
-- Recursively find each employee's direct subordinates using OrganizationNode.GetAncestor(1).
-- Return: BusinessEntityID OrganizationNode HierarchyLevel.
-- Start HierarchyLevel at 0 and increase it by 1 for each hierarchy level.
-- Use UNION ALL between the anchor and recursive members.

WITH EmployeeHierarchy AS
(
    SELECT
        e.BusinessEntityID,
        e.OrganizationNode,
        0 AS HierarchyLevel
    FROM HumanResources.Employee AS e
    WHERE e.OrganizationLevel = 1

    UNION ALL

    SELECT
        e.BusinessEntityID,
        e.OrganizationNode,
        eh.HierarchyLevel + 1
    FROM HumanResources.Employee AS e
    INNER JOIN EmployeeHierarchy AS eh
        ON e.OrganizationNode.GetAncestor(1) = eh.OrganizationNode
)
SELECT
    BusinessEntityID,
    OrganizationNode,
    HierarchyLevel
FROM EmployeeHierarchy;
