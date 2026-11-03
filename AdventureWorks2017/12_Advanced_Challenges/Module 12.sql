/*
=============================================================
Module 12 - SQL Advanced Challenges
=============================================================

Description:
This module consolidates advanced SQL skills through
practical exercises and real-world business scenarios.

Topics Covered:
- SQL Fundamentals and Functions
- JOINs and Relationships
- Aggregations and Grouping
- Subqueries and EXISTS
- Common Table Expressions (CTEs)
- Window Functions
- Views
- Stored Procedures
- Indexes and Execution Plans
- Query Performance Diagnosis and Optimization
- Final Integrated Challenge

Database:
- AdventureWorks2017

Exercises:
20

Author:
Lucas Dutra Mendes

=============================================================
*/

-- =========================================================
-- Exercise 1 - Customer Sales Analysis
-- =========================================================
-- The sales department wants to analyze customer sales
-- performance during 2013.
--
-- Using Sales.SalesOrderHeader, write a query that returns
-- customers who placed at least 5 orders during 2013.
--
-- Return the following columns:
--   CustomerID
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--
-- Requirements:
-- 1. Consider only orders placed during 2013.
-- 2. Calculate TotalOrders using COUNT().
-- 3. Calculate TotalSales using SUM(TotalDue).
-- 4. Calculate AverageOrderValue using AVG(TotalDue).
-- 5. Return only customers with at least 5 orders.
-- 6. Sort the results by TotalSales in descending order.
--
-- Do not use CTEs or subqueries for this exercise.

SELECT 
	CustomerID,
	COUNT(*) AS TotalOrders,
	SUM(TotalDue) AS TotalSales,
	AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader  
WHERE YEAR(OrderDate) = 2013 -- Alternative SARGable predicate: WHERE OrderDate >= '20130101' AND OrderDate < '20140101'
GROUP BY CustomerID
HAVING COUNT(*) > 4
ORDER BY SUM(TotalDue) DESC;

-- =========================================================
-- Exercise 2 - Order Classification
-- =========================================================
-- The sales department wants to classify sales orders
-- placed during 2013 according to their total value.
--
-- Using Sales.SalesOrderHeader, write a query that returns:
--   SalesOrderID
--   CustomerID
--   OrderDateFormatted
--   OrderYear
--   OrderMonth
--   TotalDue,
--   OrderCategory
--
-- Requirements:
-- 1. Consider only orders placed during 2013.
-- 2. Format OrderDate as yyyy-mm-dd using CONVERT().
-- 3. Extract the year and month using YEAR() and MONTH().
-- 4. Convert TotalDue to DECIMAL(12,2) using CAST().
-- 5. Classify each order using CASE:
--      TotalDue >= 10000 -> 'High Value'
--      TotalDue >= 5000  -> 'Medium Value'
--      Otherwise         -> 'Standard'
-- 6. Sort the results by TotalDue in descending order.
--
-- Do not use CTEs, subqueries, or window functions.

SELECT 
	SalesOrderID,
	CustomerID,
	CONVERT(CHAR(10), OrderDate, 23) AS OrderDateFormatted,
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	CAST(TotalDue AS DECIMAL(12,2)) AS TotalDue,
	CASE
		WHEN TotalDue >= 10000 THEN 'High Value'
		WHEN TotalDue >= 5000 THEN 'Medium Value'
		ELSE 'Standard'
	END AS OrderCategory
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013 -- Alternative SARGable predicate: WHERE OrderDate >= '20130101' AND OrderDate < '20140101'
ORDER BY TotalDue DESC; 

-- =========================================================
-- Exercise 3 - Product Catalog Analysis
-- =========================================================
-- The product management team needs a report of products
-- currently listed with a price greater than zero.
--
-- Using Production.Product, write a query that returns:
--   ProductID
--   ProductName
--   ProductNumber
--   ProductPrefix
--   ProductColor
--   ListPrice
--   PriceCategory
--
-- Requirements:
-- 1. Return only products with ListPrice greater than zero.
-- 2. Display ProductName in uppercase and remove leading
--    and trailing spaces.
-- 3. Extract the first 3 characters of ProductNumber
--    as ProductPrefix.
-- 4. Replace NULL values in Color with 'Not Specified'.
-- 5. Convert ListPrice to DECIMAL(10,2).
-- 6. Classify products using CASE:
--      ListPrice >= 1000 -> 'Premium'
--      ListPrice >= 100  -> 'Mid-Range'
--      Otherwise         -> 'Standard'
-- 7. Sort by ListPrice in descending order.
--
-- Do not use JOINs, CTEs, subqueries, or window functions.

SELECT
	ProductID,
	UPPER(TRIM(Name)) AS ProductName,
	ProductNumber,
	LEFT(ProductNumber, 3) AS ProductPrefix,
	COALESCE(Color, 'Not Specified') AS ProductColor,
	CAST(ListPrice AS DECIMAL(10,2)) AS ListPrice,
	CASE
		WHEN ListPrice >= 1000 THEN 'Premium'
		WHEN ListPrice >= 100 THEN 'Mid-Range'
		ELSE 'Standard'
	END AS PriceCategory
FROM Production.Product
WHERE ListPrice > 0
ORDER BY ListPrice DESC;

-- =========================================================
-- Exercise 4 - Product Subcategory Analysis
-- =========================================================
-- The product management team needs a report showing
-- products together with their respective subcategories.
--
-- Use the following tables:
--   Production.Product
--   Production.ProductSubcategory
--
-- Return the following columns:
--   ProductID
--   ProductName
--   ProductNumber
--   ListPrice
--   SubcategoryName
--
-- Requirements:
-- 1. Join the two tables using ProductSubcategoryID.
-- 2. Return only products with a ListPrice greater than zero.
-- 3. Display the product name as ProductName.
-- 4. Display the subcategory name as SubcategoryName.
-- 5. Sort by SubcategoryName in ascending order,
--    then by ListPrice in descending order.
--
-- Do not use CTEs, subqueries, or window functions.

SELECT
	pp.ProductID,
	pp.Name AS ProductName,
	pp.ProductNumber,
	pp.ListPrice,
	pc.Name AS SubCategoryName
FROM Production.Product AS pp
INNER JOIN Production.ProductSubcategory AS pc
	ON  pc.ProductSubcategoryID = pp.ProductSubcategoryID
WHERE pp.ListPrice > 0
ORDER BY 
		pc.Name ASC,
		pp.ListPrice DESC;

-- =========================================================
-- Exercise 5 - Product Subcategory Summary
-- =========================================================
-- The product management team wants to analyze products
-- grouped by subcategory.
--
-- Tables:
--   Production.Product
--   Production.ProductSubcategory
--
-- Return:
--   ProductSubcategoryID
--   SubcategoryName
--   TotalProducts
--   AverageListPrice
--   HighestListPrice
--
-- Requirements:
-- 1. Join the two tables using ProductSubcategoryID.
-- 2. Consider only products with ListPrice greater than zero.
-- 3. Count the products in each subcategory.
-- 4. Calculate the average and highest ListPrice per subcategory.
-- 5. Return only subcategories with at least 10 qualifying products.
-- 6. Sort by AverageListPrice in descending order.
--
-- Do not use CTEs, subqueries, or window functions.

SELECT
	pc.ProductSubcategoryID,
	pc.Name AS SubCategoryName,
	AVG(pp.ListPrice) AS AverageListPrice,
	MAX(pp.ListPrice) AS HighestListPrice,
	COUNT(*) AS TotalProducts
FROM Production.Product AS pp
INNER JOIN Production.ProductSubcategory AS pc
	ON pc.ProductSubcategoryID = pp.ProductSubcategoryID
WHERE pp.ListPrice > 0
GROUP BY
    pc.ProductSubcategoryID,
    pc.Name
HAVING COUNT(*) > 9
ORDER BY AverageListPrice DESC;

-- =========================================================
-- Exercise 6 - Customers Without Orders
-- =========================================================
-- The sales department wants to identify customers
-- who have never placed a sales order.
--
-- Tables:
--   Sales.Customer
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   AccountNumber
--
-- Requirements:
-- 1. Include all customers initially.
-- 2. Identify customers who have no matching sales orders.
-- 3. Return only customers who have never placed an order.
-- 4. Sort by CustomerID in ascending order.
--
-- Do not use subqueries, CTEs, or window functions.

SELECT
	sc.CustomerID,
	sc.AccountNumber
FROM Sales.Customer AS sc
LEFT JOIN Sales.SalesOrderHeader AS ss
	ON ss.CustomerID = sc.CustomerID
WHERE ss.SalesOrderID IS NULL
ORDER BY sc.CustomerID ASC;

-- =========================================================
-- Exercise 7 - Sales by Territory
-- =========================================================
-- The sales management team wants to analyze sales
-- performance by territory during 2013.
--
-- Tables:
--   Sales.SalesOrderHeader
--   Sales.SalesTerritory
--
-- Return:
--   TerritoryID
--   TerritoryName
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--
-- Requirements:
-- 1. Join the two tables using TerritoryID.
-- 2. Consider only orders placed during 2013.
-- 3. Use a SARGable date-range predicate.
-- 4. Count the orders in each territory.
-- 5. Calculate total sales using SUM(TotalDue).
-- 6. Calculate average order value using AVG(TotalDue).
-- 7. Return only territories with at least 100 orders.
-- 8. Sort by TotalSales in descending order.
--
-- Do not use CTEs, subqueries, or window functions.

SELECT
	st.TerritoryID,
	st.Name AS TerritoryName,
	COUNT(*) AS TotalOrders,
	SUM(TotalDue) AS TotalSales,
	AVG(TotalDue) AS AverageOrderValue	
FROM Sales.SalesOrderHeader AS so
INNER JOIN Sales.SalesTerritory AS st
	ON st.TerritoryID = so.TerritoryID
WHERE so.OrderDate >= '20130101' AND so.OrderDate < '20140101'
GROUP BY st.TerritoryID, st.Name
HAVING COUNT(*) > 99
ORDER BY TotalSales DESC;

-- =========================================================
-- Exercise 8 - Product Category Analysis
-- =========================================================
-- The product management team wants to compare product
-- counts and prices across product categories.
--
-- Tables:
--   Production.Product
--   Production.ProductSubcategory
--   Production.ProductCategory
--
-- Return:
--   ProductCategoryID
--   CategoryName
--   TotalProducts
--   AverageListPrice
--   HighestListPrice
--
-- Requirements:
-- 1. Join the three tables using their corresponding IDs.
-- 2. Consider only products with ListPrice greater than zero.
-- 3. Count the qualifying products in each category.
-- 4. Calculate the average and highest ListPrice per category.
-- 5. Return only categories with at least 20 qualifying products.
-- 6. Sort by AverageListPrice in descending order.
--
-- Do not use CTEs, subqueries, or window functions.

SELECT
	ps.ProductCategoryID,
	pc.Name AS CategoryName,
	COUNT(*) AS TotalProducts,
	AVG(pp.ListPrice) AS AverageListPrice,
	MAX(pp.ListPrice) AS HighestListPrice
FROM Production.Product as pp
INNER JOIN Production.ProductSubcategory AS ps
	ON ps.ProductSubcategoryID = pp.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
	ON pc.ProductCategoryID = ps.ProductCategoryID
WHERE pp.ListPrice > 0
GROUP BY 
	ps.ProductCategoryID,
	pc.Name
HAVING COUNT(*) > 19
ORDER BY AverageListPrice DESC;

-- =========================================================
-- Exercise 9 - Products Above Average Price
-- =========================================================
-- The product management team wants to identify products
-- whose list price is higher than the average list price
-- of all products with a positive price.
--
-- Table:
--   Production.Product
--
-- Return:
--   ProductID
--   ProductName
--   ProductNumber
--   ListPrice
--   AverageListPrice
--
-- Requirements:
-- 1. Consider only products with ListPrice greater than zero
--    in the main result.
-- 2. Return products whose ListPrice is greater than the
--    average ListPrice of all products with a positive price.
-- 3. Use a subquery to calculate the average price.
-- 4. Sort by ListPrice in descending order.
--
-- Do not use CTEs or window functions.

SELECT
	ProductID,
	Name AS ProductName,
	ProductNumber,
	ListPrice,
    (
        SELECT AVG(ListPrice)
        FROM Production.Product
        WHERE ListPrice > 0
    ) AS AverageListPrice
FROM Production.Product
WHERE ListPrice > 0 
	AND ListPrice >
(
	SELECT
		AVG(ListPrice)
	FROM Production.Product
	WHERE ListPrice > 0
)
ORDER BY ListPrice DESC

-- =========================================================
-- Exercise 10 - Customers Without Orders in 2013
-- =========================================================
-- The sales department wants to identify existing customers
-- who have placed orders in the past but did not place
-- any orders during 2013.
--
-- Tables:
--   Sales.Customer
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   AccountNumber
--
-- Requirements:
-- 1. Return only customers who have placed at least one
--    sales order at any time.
-- 2. Exclude customers who placed any order during 2013.
-- 3. Use EXISTS and NOT EXISTS with correlated subqueries.
-- 4. Use a SARGable date-range predicate for 2013.
-- 5. Sort by CustomerID in ascending order.
--
-- Do not use JOINs in the main query, CTEs,
-- or window functions.

SELECT
    sc.CustomerID,
    sc.AccountNumber
FROM Sales.Customer AS sc
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS so
    WHERE so.CustomerID = sc.CustomerID
)
AND NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS soh
    WHERE soh.CustomerID = sc.CustomerID
      AND soh.OrderDate >= '20130101'
      AND soh.OrderDate < '20140101'
)
ORDER BY sc.CustomerID ASC;

-- =========================================================
-- Exercise 11 - Customer Sales Summary Using a CTE
-- =========================================================
-- The sales department wants to identify high-performing
-- customers during 2013.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--
-- Requirements:
-- 1. Use a CTE named CTECustomerSales to calculate the metrics.
-- 2. Consider only orders placed during 2013.
-- 3. Calculate TotalOrders using COUNT().
-- 4. Calculate TotalSales using SUM(TotalDue).
-- 5. Calculate AverageOrderValue using AVG(TotalDue).
-- 6. Return customers with at least 5 orders and total sales
--    greater than 10000.
-- 7. Sort by TotalSales in descending order.
--
-- Use a SARGable date-range predicate.
-- Do not use additional CTEs, subqueries, or window functions.

WITH CTECustomerSales AS
(
	SELECT
		CustomerID,
		COUNT(*) AS TotalOrders,
		SUM(TotalDue) AS TotalSales,
		AVG(TotalDue) AS AverageOrderValue
	FROM Sales.SalesOrderHeader
	WHERE OrderDate >= '20130101' 
		AND OrderDate < '20140101'
	GROUP BY CustomerID
)
SELECT * FROM CTECustomerSales
WHERE TotalOrders >= 5
  AND TotalSales > 10000
ORDER BY TotalSales DESC;

-- =========================================================
-- Exercise 12 - Product Sales Analysis Using Multiple CTEs
-- =========================================================
-- The sales department wants to identify the 10 products
-- that generated the highest revenue during 2013.
--
-- Tables:
--   Sales.SalesOrderHeader
--   Sales.SalesOrderDetail
--   Production.Product
--
-- Return:
--   ProductID
--   ProductName
--   TotalQuantitySold
--   TotalRevenue
--
-- Requirements:
-- 1. Use a CTE named CTEOrderLines2013 to retrieve order lines
--    from orders placed during 2013.
-- 2. Calculate LineRevenue as OrderQty * UnitPrice
--    inside the first CTE.
-- 3. Use a second CTE named CTEProductSales to aggregate
--    TotalQuantitySold and TotalRevenue by ProductID.
-- 4. Join the aggregated results with Production.Product
--    to retrieve the product name.
-- 5. Return the 10 products with the highest TotalRevenue.
-- 6. Sort by TotalRevenue in descending order.
--
-- Use a SARGable date-range predicate.
-- Do not use subqueries or window functions.

;WITH CTEOrderLines2013 AS
(
    SELECT
        d.ProductID,
        d.OrderQty,
        d.UnitPrice,
        d.OrderQty * d.UnitPrice AS LineRevenue
    FROM Sales.SalesOrderHeader AS h
    INNER JOIN Sales.SalesOrderDetail AS d
        ON d.SalesOrderID = h.SalesOrderID
    WHERE h.OrderDate >= '20130101'
      AND h.OrderDate < '20140101'
),
CTEProductSales AS
(
    SELECT
        ProductID,
        SUM(OrderQty) AS TotalQuantitySold,
        SUM(LineRevenue) AS TotalRevenue
    FROM CTEOrderLines2013
    GROUP BY ProductID
)

SELECT TOP (10)
    ps.ProductID,
    p.Name AS ProductName,
    ps.TotalQuantitySold,
    ps.TotalRevenue
FROM CTEProductSales AS ps
INNER JOIN Production.Product AS p
    ON p.ProductID = ps.ProductID
ORDER BY ps.TotalRevenue DESC;

-- =========================================================
-- Exercise 13 - Ranking Customer Orders
-- =========================================================
-- The sales department wants to rank each customer's
-- orders placed during 2013 according to their total value.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   SalesOrderID
--   OrderDate
--   TotalDue
--   OrderRank
--
-- Requirements:
-- 1. Consider only orders placed during 2013.
-- 2. Use ROW_NUMBER() to rank orders for each customer.
-- 3. Partition the ranking by CustomerID.
-- 4. Order each customer's ranking by TotalDue
--    in descending order.
-- 5. Sort the final results by CustomerID and OrderRank.
--
-- Use a SARGable date-range predicate.
-- Do not use CTEs or subqueries.

SELECT
	CustomerID,
	SalesOrderID,
	OrderDate,
	TotalDue,
	ROW_NUMBER() OVER(
		PARTITION BY CustomerID 
		ORDER BY TotalDue DESC) AS OrderRank
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101'
ORDER BY CustomerID, OrderRank;

-- =========================================================
-- Exercise 14 - ROW_NUMBER() vs RANK()
-- =========================================================
-- The sales department wants to compare two ranking
-- methods for customer orders placed during 2013.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   SalesOrderID
--   OrderDate
--   TotalDue
--   RowNumberRank
--   SalesRank
--
-- Requirements:
-- 1. Consider only orders placed during 2013.
-- 2. Use ROW_NUMBER() to rank orders within each customer.
-- 3. Use RANK() to rank orders within each customer.
-- 4. Partition both rankings by CustomerID.
-- 5. Order both rankings by TotalDue in descending order.
-- 6. Sort the final results by CustomerID, SalesRank,
--    and SalesOrderID.
--
-- Use a SARGable date-range predicate.
-- Do not use CTEs or subqueries.

SELECT
	CustomerID,
	SalesOrderID,
	OrderDate,
	TotalDue,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY TotalDue DESC) AS RowNumberRank,
    RANK() OVER(PARTITION BY CustomerID ORDER BY TotalDue DESC) AS SalesRank
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101'
ORDER BY CustomerID, SalesRank, SalesOrderID;

-- =========================================================
-- Exercise 15 - Comparing Ranking Functions
-- =========================================================
-- The sales department wants to compare three ranking
-- methods for customer orders placed during 2013.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Return:
--   CustomerID
--   SalesOrderID
--   TotalDue
--   RowNumberRank
--   SalesRank
--   DenseRank
--
-- Requirements:
-- 1. Consider only orders placed during 2013.
-- 2. Use ROW_NUMBER() to assign a unique sequential number.
-- 3. Use RANK() to assign rankings while preserving ties.
-- 4. Use DENSE_RANK() to assign rankings without gaps.
-- 5. Partition all three rankings by CustomerID.
-- 6. Order all rankings by TotalDue in descending order.
-- 7. Sort the final results by CustomerID, DenseRank,
--    and SalesOrderID.
--
-- Use a SARGable date-range predicate.
-- Do not use CTEs or subqueries.

SELECT
	CustomerID,
	SalesOrderID,
	TotalDue,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY TotalDue DESC) AS RowNumberRank,
    RANK() OVER(PARTITION BY CustomerID ORDER BY TotalDue DESC) AS SalesRank,
	DENSE_RANK() OVER(PARTITION BY CustomerID ORDER BY TotalDue DESC) AS DenseRank
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101' AND OrderDate < '20140101'
ORDER BY CustomerID, DenseRank, SalesOrderID;

-- =========================================================
-- Exercise 16 - Customer Sales Summary View
-- =========================================================
-- Create a view named Sales.vw_CustomerSalesSummary.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- The view must return:
--   CustomerID
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--
-- Requirements:
-- 1. Calculate the total number of orders per customer.
-- 2. Calculate the total sales (SUM of TotalDue).
-- 3. Calculate the average order value (AVG of TotalDue).
-- 4. Group the results by CustomerID.
-- 5. Include all orders, without a date filter.
--
-- After creating the view, write a SELECT statement to:
-- 1. Retrieve customers with at least 5 orders.
-- 2. Retrieve customers with TotalSales greater than 50000.
-- 3. Sort the results by TotalSales in descending order.
--
-- Do not use CTEs or subqueries.
-- Do not use ORDER BY inside the view definition.

GO
CREATE VIEW Sales.vw_CustomerSalesSummary AS
    SELECT
        CustomerID,
        COUNT(*) AS TotalOrders,
        SUM(TotalDue) AS TotalSales,
        AVG(TotalDue) AS AverageOrderValue
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID;
GO

SELECT *
FROM Sales.vw_CustomerSalesSummary
WHERE TotalOrders >= 5
  AND TotalSales > 50000
ORDER BY TotalSales DESC;

-- =========================================================
-- Exercise 17 - Customer Orders Stored Procedure
-- =========================================================
-- Create a stored procedure named Sales.usp_GetCustomerOrders.
-- Table:
--   Sales.SalesOrderHeader
--
-- The stored procedure must:
-- 1. Accept a parameter named @CustomerID (INT).
-- 2. Return the following columns:
--      SalesOrderID
--      CustomerID
--      OrderDate
--      TotalDue
-- 3. Filter orders using the @CustomerID parameter.
-- 4. Sort the results by OrderDate in descending order.
--
-- After creating the stored procedure:
-- 1. Execute it for CustomerID = 11000.
--
-- Do not use dynamic SQL, CTEs or subqueries.

GO
CREATE PROCEDURE Sales.usp_GetCustomerOrders
	@CustomerID INT AS
SELECT
	SalesOrderID,
	CustomerID,
	OrderDate,
	TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID
ORDER BY OrderDate DESC; 
GO

EXEC Sales.usp_GetCustomerOrders @CustomerID = 11000;

-- =========================================================
-- Exercise 18 - Indexes and Execution Plans
-- =========================================================
-- The sales department frequently retrieves orders by OrderDate.
-- The database administrator wants to improve this query's performance.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Requirements:
-- 1. Retrieve the following columns:
--      SalesOrderID
--      CustomerID
--      OrderDate
--      TotalDue
--
-- 2. Filter orders placed between June 1 and June 7, 2013.
-- 3. Sort the results by OrderDate in descending order.
-- 4. Execute the query and analyze its execution plan.
-- 5. Create a NONCLUSTERED INDEX named:
--      IX_SalesOrderHeader_OrderDate
--    Using OrderDate as the key column.
-- 6. Include CustomerID and TotalDue in the index.
-- 7. Execute the same query again.
-- 8. Compare the execution plans before and after
--    creating the index.
--
-- Do not modify the original query.
-- Do not use CTEs or subqueries.

SET STATISTICS IO, TIME ON;

-- 1. Execute the original query and analyze its execution plan.

SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130601'
  AND OrderDate < '20130608'
ORDER BY OrderDate DESC;

-- 2. Create a NONCLUSTERED INDEX.

CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_OrderDate
ON Sales.SalesOrderHeader (OrderDate)
INCLUDE (CustomerID, TotalDue);

-- 3. Execute the same query again and compare the execution plan.

SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130601'
  AND OrderDate < '20130608'
ORDER BY OrderDate DESC;

SET STATISTICS TIME, IO OFF;

-- =========================================================
-- Exercise 19 - Query Performance Diagnosis and Optimization
-- =========================================================
-- The sales department is investigating a query that retrieves
-- orders placed during June 2013.
--
-- Table:
--   Sales.SalesOrderHeader
--
-- Requirements:
-- 1. Retrieve:
--      SalesOrderID
--      CustomerID
--      OrderDate
--      TotalDue
--
-- 2. Filter orders placed during June 2013.
-- 3. Sort the results by OrderDate in descending order.
-- 4. Execute the original query using YEAR() and MONTH().
-- 5. Analyze the Actual Execution Plan.
-- 6. Rewrite the query using a SARGable date-range predicate.
-- 7. Execute the optimized query.
-- 8. Compare the execution plans and performance metrics.
--
-- Reuse the index created in Exercise 18.
-- Do not create another index.
-- Do not use CTEs or subqueries.

-- Original query (non-SARGable):

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
  AND MONTH(OrderDate) = 6
ORDER BY OrderDate DESC;

-- Optimized query (SARGable):

SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130601'
  AND OrderDate < '20130701'
ORDER BY OrderDate DESC;

SET STATISTICS IO, TIME OFF;

-- =========================================================
-- Exercise 20 - Final Challenge
-- Customer Sales Performance Report
-- =========================================================
-- The sales management team wants a report ranking customers
-- according to their sales performance during 2013.
--
-- Tables:
--   Sales.Customer
--   Sales.SalesOrderHeader
--
-- Requirements:
-- 1. Retrieve sales information for 2013 only.
-- 2. Create a CTE named CustomerSales to calculate:
--      CustomerID
--      TotalOrders
--      TotalSales
--      AverageOrderValue
--
-- 3. Consider only customers with at least 5 orders.
-- 4. Create a second CTE named RankedCustomers.
-- 5. Use DENSE_RANK() to rank customers by TotalSales
--    in descending order.
-- 6. Join Sales.Customer to retrieve AccountNumber.
-- 7. Classify customers using CASE:
--      TotalSales >= 100000 -> 'High'
--      TotalSales >= 50000  -> 'Medium'
--      Otherwise            -> 'Standard'
--
-- 8. Return customers within the top 10 sales ranks,
--    including ties.
--
-- Final output:
--   CustomerID
--   AccountNumber
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--   SalesRank
--   SalesCategory
--
-- 9. Sort the results by SalesRank and CustomerID.
-- 10. Use a SARGable date-range predicate.
--
-- Do not use stored procedures or views.

DECLARE @StartDate DATE = '20130101';
DECLARE @EndDate DATE = '20140101';

;WITH CustomerSales AS
(
    SELECT
        soh.CustomerID,
        COUNT(*) AS TotalOrders,
        SUM(soh.TotalDue) AS TotalSales,
        AVG(soh.TotalDue) AS AverageOrderValue
    FROM Sales.SalesOrderHeader AS soh
    WHERE soh.OrderDate >= @StartDate
      AND soh.OrderDate < @EndDate
    GROUP BY soh.CustomerID
    HAVING COUNT(*) >= 5
),
RankedCustomers AS
(
    SELECT
        CustomerID,
        TotalOrders,
        TotalSales,
        AverageOrderValue,
        DENSE_RANK() OVER(
            ORDER BY TotalSales DESC
        ) AS SalesRank
    FROM CustomerSales
)

SELECT
    sc.CustomerID,
    sc.AccountNumber,
    rc.TotalOrders,
    rc.TotalSales,
    rc.AverageOrderValue,
    rc.SalesRank,
    CASE
        WHEN rc.TotalSales >= 100000 THEN 'High'
        WHEN rc.TotalSales >= 50000 THEN 'Medium'
        ELSE 'Standard'
    END AS SalesCategory
FROM RankedCustomers AS rc
INNER JOIN Sales.Customer AS sc
    ON sc.CustomerID = rc.CustomerID
WHERE rc.SalesRank <= 10
ORDER BY
    rc.SalesRank ASC,
    sc.CustomerID ASC;


/*
-- Side Notes
=============================
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM Sales.SalesOrderDetail
            WHERE ProductID = 707
        )
        THEN 'Yes'
        ELSE 'No'
    END AS ProductExists;
=============================
	IF EXISTS (
    SELECT 1
    FROM Sales.SalesOrderDetail
    WHERE ProductID = 707
)
    PRINT 'ProductID exists';
ELSE
    PRINT 'ProductID does not exist';
=============================
*/ 