/*
=============================================================
Module 08 - Views
=============================================================

Description:
This module introduces SQL Views used to create reusable,
controlled, and queryable database objects based on SELECT
statements.

Topics Covered:
- CREATE VIEW
- Querying Views
- Views + JOINs
- Views + Multiple JOINs
- Views + Aggregation
- Views + CASE
- Business Logic in Views
- ALTER VIEW
- DROP VIEW
- Views + CTEs
- Views + Subqueries
- Views + Security
- Database Roles
- GRANT SELECT
- Indexed Views
- SCHEMABINDING
- UNIQUE CLUSTERED INDEX
- Practical Scenarios

Database:
- AdventureWorks2017

Exercises:
19

Extra Queries:
2

Author:
Lucas Dutra Mendes

=============================================================
*/

-- 1 The production manager wants to create a reusable report containing product information.
-- Create a view named ProductList returning: ProductID ProductName ProductSubcategoryID ProductNumber ListPrice.
-- Use Production.Product. After creating the view, query the view to return all products.

CREATE VIEW ProductList AS
	SELECT
		ProductID,
		Name AS ProductName,
		ProductSubcategoryID,
		ProductNumber,
		ListPrice
	FROM Production.Product;

SELECT * FROM ProductList;

-- 2 The production manager wants to use the ProductList view to identify products
-- with a ListPrice greater than 1000. Query the ProductList view.
-- Return: ProductID ProductName ProductNumber ListPrice. Order by ListPrice DESC.

SELECT
	ProductID,
	ProductName,
	ProductNumber,
	ListPrice
FROM ProductList
WHERE ListPrice > 1000
ORDER BY ListPrice DESC;

-- 3 The production manager wants to create a report showing product information together with its subcategory.
-- Use the ProductList view and Production.ProductSubcategory. Join the view with the subcategory table using
-- ProductSubcategoryID. Return: ProductID ProductName ListPrice ProductSubcategoryID SubcategoryName.
-- Order by ProductSubcategoryID, then ListPrice DESC.

SELECT
    pl.ProductID,
    pl.ProductName,
    pl.ListPrice,
    pl.ProductSubcategoryID,
    pp.Name AS SubcategoryName
FROM ProductList AS pl
INNER JOIN Production.ProductSubcategory AS pp
    ON pp.ProductSubcategoryID = pl.ProductSubcategoryID
ORDER BY 
    pl.ProductSubcategoryID,
    pl.ListPrice DESC;

-- 4 The production manager wants a report showing each product together with its subcategory and category.
-- Use the ProductList view, Production.ProductSubcategory, and Production.ProductCategory.
-- Join ProductList to ProductSubcategory using ProductSubcategoryID, then join ProductSubcategory
-- to ProductCategory using ProductCategoryID. Return: ProductID ProductName ListPrice SubcategoryName CategoryName.
-- Exclude products without a ProductSubcategoryID. Order by CategoryName, SubcategoryName, then ListPrice DESC.

SELECT
    pl.ProductID,
    pl.ProductName,
    pl.ListPrice,
    pl.ProductSubcategoryID,
    pp.Name AS SubcategoryName,
    pc.Name AS CategoryName
FROM ProductList AS pl
INNER JOIN Production.ProductSubcategory AS pp
    ON pp.ProductSubcategoryID = pl.ProductSubcategoryID
INNER JOIN Production.ProductCategory as pc
    ON pc.ProductCategoryID = pp.ProductCategoryID
WHERE pl.ProductSubcategoryID IS NOT NULL
ORDER BY 
    CategoryName,
    SubcategoryName,
    pl.ListPrice DESC;

-- 5 The sales manager wants to create a reusable report showing each customer and the total number of orders they have placed.
-- Create a view named CustomerOrderCount. Use Sales.Customer and Sales.SalesOrderHeader.
-- Calculate the number of orders for each CustomerID using COUNT(). Return: CustomerID AccountNumber OrderCount.
-- Join Sales.Customer with Sales.SalesOrderHeader and group by CustomerID and AccountNumber.

CREATE VIEW CustomerOrderCount AS
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        COUNT(*) AS OrderCount
    FROM Sales.Customer AS sc
    INNER JOIN Sales.SalesOrderHeader AS ss
        ON ss.CustomerID = sc.CustomerID 
    GROUP BY 
        sc.CustomerID,
        sc.AccountNumber;

SELECT *
FROM CustomerOrderCount
ORDER BY OrderCount DESC;

-- 6 The sales manager wants a reusable report showing each customer and the total amount they have spent.
-- Create a view named CustomerTotalSales.
-- Use Sales.Customer and Sales.SalesOrderHeader.
-- Calculate the total sales for each customer using SUM(TotalDue).
-- Return: CustomerID, AccountNumber, TotalSales.
-- Group the results by CustomerID and AccountNumber.

CREATE VIEW CustomerTotalSales AS
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        SUM(ss.TotalDue) AS TotalSales
    FROM Sales.Customer AS sc
    INNER JOIN Sales.SalesOrderHeader AS ss
        ON ss.CustomerID = sc.CustomerID
    GROUP BY 
        sc.CustomerID,
        sc.AccountNumber; 

SELECT *
FROM CustomerTotalSales; 

-- 7 The sales team wants to classify products based on their list price.
-- Create a view named ProductPriceCategory.
-- Use Production.Product.
-- Return: ProductID, Name AS ProductName, ListPrice, PriceCategory.
-- Use CASE to classify products:
--   ListPrice < 100       → 'Low'
--   ListPrice < 500       → 'Medium'
--   ListPrice >= 500      → 'High'

CREATE VIEW ProductPriceCategory AS
    SELECT
        ProductID,
        Name AS ProductName,
        ListPrice,
        CASE
            WHEN ListPrice >= 500 THEN 'High'
            WHEN ListPrice >= 100  THEN 'Medium'
            ELSE 'Low'
        END AS PriceCategory
    FROM Production.Product;

SELECT * FROM ProductPriceCategory;

-- 8 The sales manager wants a reusable report classifying customers based on their total sales.
-- Create a view named CustomerSalesCategory.
-- Use Sales.Customer and Sales.SalesOrderHeader.
-- Calculate the total sales for each customer using SUM(TotalDue).
-- Return: CustomerID, AccountNumber, TotalSales, SalesCategory.
-- Use CASE to classify customers:
--   TotalSales < 10000      → 'Low'
--   TotalSales < 50000      → 'Medium'
--   TotalSales >= 50000     → 'High'

CREATE VIEW CustomerSalesCategory AS
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        SUM(ss.TotalDue) AS TotalSales,
        CASE
            WHEN SUM(ss.TotalDue) >= 50000 THEN 'High'
            WHEN SUM(ss.TotalDue) >= 10000 THEN 'Medium'
            ELSE 'Low'
        END AS SalesCategory
    FROM Sales.Customer as sc
    INNER JOIN Sales.SalesOrderHeader AS  ss
        ON ss.CustomerID = sc.CustomerID
    GROUP BY
        sc.CustomerID,
        sc.AccountNumber;

SELECT * FROM CustomerSalesCategory; 

-- 9 The product manager wants to improve the ProductPriceCategory report.
-- Alter the existing ProductPriceCategory view.
-- Add ProductNumber to the columns returned by the view.
-- Keep the existing PriceCategory logic unchanged.

ALTER VIEW ProductPriceCategory AS
    SELECT
        ProductID,
        Name AS ProductName,
        ProductNumber,
        ListPrice,
        CASE
            WHEN ListPrice >= 500 THEN 'High'
            WHEN ListPrice >= 100  THEN 'Medium'
            ELSE 'Low'
        END AS PriceCategory
    FROM Production.Product;

SELECT * FROM ProductPriceCategory;

-- 10 The product manager wants to change the pricing classification.
-- Alter the existing ProductPriceCategory view.
-- Change the PriceCategory rules to:
--   ListPrice < 200       → 'Low'
--   ListPrice < 1000      → 'Medium'
--   ListPrice >= 1000     → 'High'
-- Keep ProductID, ProductName, ProductNumber and ListPrice in the view.

ALTER VIEW ProductPriceCategory AS
    SELECT
        ProductID,
        Name AS ProductName,
        ProductNumber,
        ListPrice,
        CASE
            WHEN ListPrice >= 1000 THEN 'High'
            WHEN ListPrice >= 200  THEN 'Medium'
            ELSE 'Low'
        END AS PriceCategory
    FROM Production.Product;

SELECT * FROM ProductPriceCategory; 

-- 11 The sales team no longer needs the CustomerOrderCount report.
-- Drop the CustomerOrderCount view.

DROP VIEW CustomerOrderCount; 

SELECT * FROM CustomerOrderCount;


-- 12 The sales manager wants a reusable report showing customers whose total sales are above the average customer sales.
-- Create a view named CustomersAboveAverageSales.
-- Use a CTE to calculate the total sales for each customer.
-- Then compare each customer's TotalSales with the average TotalSales across all customers.
-- Return: CustomerID, AccountNumber, TotalSales.

CREATE VIEW CustomersAboveAverageSales AS
WITH CTETotalSales AS
(
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        SUM(ss.TotalDue) AS TotalSales
    FROM Sales.Customer AS sc
    INNER JOIN Sales.SalesOrderHeader AS ss
        ON ss.CustomerID = sc.CustomerID
    GROUP BY
        sc.CustomerID,
        sc.AccountNumber
)
SELECT
    CustomerID,
    AccountNumber,
    TotalSales
FROM CTETotalSales
WHERE TotalSales > (
    SELECT AVG(TotalSales)
    FROM CTETotalSales); 

SELECT *
FROM CustomersAboveAverageSales
ORDER BY TotalSales DESC;

-- 13 The product manager wants a reusable report showing products whose list price is above the average product price.
-- Create a view named ProductsAboveAveragePrice.
-- Use Production.Product.
-- Return: ProductID, Name AS ProductName, ListPrice.
-- Use a subquery to calculate the average ListPrice.
-- Return only products whose ListPrice is above the overall average.

CREATE VIEW ProductsAboveAveragePrice AS
    SELECT
        ProductID,
        Name AS ProductName,
        ListPrice
    FROM Production.Product
    WHERE ListPrice > (
        SELECT
            AVG(ListPrice) 
        FROM Production.Product);

SELECT * FROM ProductsAboveAveragePrice;

-- 14 The sales team should have access only to basic customer information.
-- Create a view named CustomerBasicInfo.
-- Use Sales.Customer.
-- Return only: CustomerID, AccountNumber, TerritoryID.
-- Do not include sensitive or unnecessary columns from the base table.

CREATE VIEW CustomerBasicInfo AS
    SELECT
        CustomerID,
        AccountNumber,
        TerritoryID
    FROM Sales.Customer;

GRANT SELECT ON CustomerBasicInfo TO dbo;

SELECT * FROM CustomerBasicInfo; 

-- 15 The company wants to manage access to customer information through a role.
-- Create a database role named SalesReaders.
-- Grant SELECT permission on CustomerBasicInfo to SalesReaders.
-- Do not grant the permission directly to an individual user.
-- Verify that the role exists and that the permission was granted.

CREATE ROLE SalesReaders;

GRANT SELECT ON CustomerBasicInfo TO SalesReaders; 

SELECT name
FROM sys.database_principals
WHERE name = 'SalesReaders';

SELECT
    dp.permission_name,
    dp.state_desc,
    OBJECT_NAME(dp.major_id) AS ObjectName,
    USER_NAME(dp.grantee_principal_id) AS Grantee
FROM sys.database_permissions AS dp
WHERE OBJECT_NAME(dp.major_id) = 'CustomerBasicInfo'
  AND USER_NAME(dp.grantee_principal_id) = 'SalesReaders';

-- INDEXED VIEW
-- 16 The sales team wants a materialized summary of the number of orders per customer.
-- Create an indexed view named CustomerOrderSummary.
-- Use Sales.SalesOrderHeader.
-- Return CustomerID and the total number of orders.
-- Use COUNT_BIG(*) for the order count.
-- Use SCHEMABINDING.
-- Then create a UNIQUE CLUSTERED INDEX on CustomerID.

CREATE VIEW dbo.CustomerOrderSummary
WITH SCHEMABINDING
AS
SELECT
    CustomerID,
    COUNT_BIG(*) AS NumberOfOrders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID; 

CREATE UNIQUE CLUSTERED INDEX IX_CustomerOrderSummary
ON dbo.CustomerOrderSummary(CustomerID);

-- 17 The sales team frequently needs a list of customers with their total sales.
-- Create a view named CustomerSalesReport.
-- Return: CustomerID, AccountNumber, TotalSales.
-- Use Sales.Customer and Sales.SalesOrderHeader.
-- Calculate TotalSales with SUM(TotalDue).
-- Group the results by CustomerID and AccountNumber.

CREATE VIEW dbo.CustomerSalesReport AS
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    SUM(ss.TotalDue) AS TotalSales
FROM Sales.Customer AS sc
INNER JOIN Sales.SalesOrderHeader AS ss
    ON ss.CustomerID = sc.CustomerID
GROUP BY
    sc.CustomerID,
    sc.AccountNumber;

SELECT * FROM dbo.CustomerSalesReport
ORDER BY TotalSales;

-- 18 The sales manager wants a reusable report showing customer sales performance.
-- Create a view named CustomerSalesPerformance.
-- Return: CustomerID, AccountNumber, TotalSales, SalesCategory.
-- Calculate TotalSales using SUM(TotalDue).
-- Classify customers using CASE:
--   TotalSales < 10000      → 'Low'
--   TotalSales < 50000      → 'Medium'
--   TotalSales >= 50000     → 'High'
-- Use Sales.Customer and Sales.SalesOrderHeader.

CREATE VIEW CustomerSalesPerformance AS
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    SUM(ss.TotalDue) AS TotalSales,
    CASE
        WHEN SUM(ss.TotalDue) < 10000 THEN 'Low'
        WHEN SUM(ss.TotalDue) < 50000 THEN 'Medium'
        ELSE 'High'
    END AS SalesCategory
FROM Sales.Customer AS sc
INNER JOIN Sales.SalesOrderHeader AS ss
    ON ss.CustomerID = sc.CustomerID
GROUP BY
    sc.CustomerID,
    sc.AccountNumber;

SELECT * FROM CustomerSalesPerformance;

-- 19 The sales director wants a reusable customer performance report.
-- Create a view named CustomerPerformanceReport. Return:
--   CustomerID
--   AccountNumber
--   TotalOrders
--   TotalSales
--   SalesCategory
--   AverageOrderValue
-- The report must:
--   - show the total number of orders for each customer;
--   - show the total sales for each customer;
--   - classify customers as Low, Medium, or High based on TotalSales:
--       < 10000      → Low
--       < 50000      → Medium
--       >= 50000     → High
--   - calculate the average value per order.
-- Use Sales.Customer and Sales.SalesOrderHeader.

CREATE VIEW CustomerPerformanceReport AS
SELECT
    sc.CustomerID,
    sc.AccountNumber,
    COUNT(*) AS TotalOrders,
    SUM(ss.TotalDue) AS TotalSales,
    SUM(ss.TotalDue) / COUNT(*) AS AverageOrderValue,
        CASE
        WHEN SUM(ss.TotalDue) < 10000 THEN 'Low'
        WHEN SUM(ss.TotalDue) < 50000 THEN 'Medium'
        ELSE 'High'
    END AS SalesCategory
FROM Sales.Customer AS sc
INNER JOIN Sales.SalesOrderHeader AS ss
    ON ss.CustomerID = sc.CustomerID
GROUP BY
    sc.CustomerID,
    sc.AccountNumber;

SELECT * FROM CustomerPerformanceReport;

-- 20 Extra - Search for current user

SELECT SUSER_SNAME() AS LoginName,
       USER_NAME() AS DatabaseUser;

-- 21 Extra - Search for view

SELECT
    name AS ViewName
FROM sys.views
ORDER BY name;

-- OR

SELECT
    s.name AS SchemaName,
    v.name AS ViewName
FROM sys.views AS v
INNER JOIN sys.schemas AS s
    ON v.schema_id = s.schema_id
ORDER BY
    s.name,
    v.name;