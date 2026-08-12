/*
=============================================================
Module 05 - Subqueries
=============================================================

Description:
This module covers SQL subqueries, including scalar
subqueries, multiple-row subqueries, EXISTS, NOT EXISTS,
and correlated subqueries.

Topics Covered:
- Scalar Subqueries
- Multiple-Row Subqueries
- IN
- NOT IN
- Nested Subqueries
- Subqueries in the SELECT clause
- Subqueries in the FROM clause
- EXISTS
- NOT EXISTS
- Correlated Subqueries

Database:
- AdventureWorks2017

Exercises:
23

Author:
Lucas Dutra Mendes

=============================================================
*/

-- SCALAR SUBQUERY
-- 1 The sales manager wants to identify all products that are more expensive than the average product price.
-- Return: ProductID - Product Name - ListPrice
-- Requirements: Use a scalar subquery - Return only products priced above the average price.
-- Order the results by ListPrice DESC.

SELECT
	ProductID,
	Name AS ProductName,
	ListPrice
FROM Production.Product
WHERE ListPrice > 
(
	SELECT AVG(ListPrice)
	FROM Production.Product
)
ORDER BY ListPrice DESC;

-- 2 The production manager wants to identify the most expensive product in the catalog.
-- Return: ProductID - ProductName - ListPrice
-- Requirements: Use a scalar subquery. Use MAX(ListPrice). Return only the most expensive product.
-- Order by ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
WHERE ListPrice =
(
    SELECT
        MAX(ListPrice)
    FROM Production.Product
)
ORDER BY ListPrice DESC; 

-- 3 The production manager wants to identify products that are cheaper than the average product price.
-- Return - ProductID - ProductName - ListPrice. Requirements Use a Scalar Subquery. Use AVG(ListPrice).
-- Return only products priced below the average. Order by ListPrice ASC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice 
FROM Production.Product
WHERE ListPrice <
(
    SELECT
        AVG(ListPrice)
    FROM Production.Product
)
ORDER BY ListPrice;

-- 4 The production manager wants to identify the cheapest product in the catalog. Return ProductID
-- ProductName - ListPrice - Requirements Use a Scalar Subquery. Use MIN(ListPrice). Return only the cheapest 
-- product. Order by ListPrice ASC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice 
FROM Production.Product
WHERE ListPrice =
(
    SELECT
        MIN(ListPrice)
    FROM Production.Product
)
ORDER BY ListPrice; 


-- Multiple-row Subqueries
-- 5 The sales manager wants to identify all customers who have placed at least one sales order.
-- Requirements: Use a multiple-row subquery. Use IN. Do not use JOIN. Order by CustomerID.
-- Return: CustomerID - AccountNumber

SELECT
    CustomerID,
    AccountNumber
FROM Sales.Customer
WHERE CustomerID IN 
(
    SELECT
    CustomerID
    FROM Sales.SalesOrderHeader
)
ORDER BY CustomerID;

-- 6 The sales manager wants to identify all products that have been sold at least once.
-- Requirements Use a multiple-row subquery. Use IN. Do not use JOIN. Order by ProductID.
-- Return ProductID - Name as ProductName - ListPrice

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
WHERE ProductID IN
(
    SELECT
        ProductID
    FROM Sales.SalesOrderDetail
);

-- 7 The sales manager wants to identify all products that have never been sold.
-- Requirements Use a multiple-row subquery. Use IN or NOT IN. Do not use JOIN. Order by ProductID.
-- Return ProductID Name as ProductName ListPrice

SELECT  
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
WHERE ProductID NOT IN
(
    SELECT
        ProductID
    FROM Sales.SalesOrderDetail
)
ORDER BY ProductID;

-- 8 The sales manager wants to identify customers who have placed at least one order whose 
-- value is greater than the average order value. Return: CustomerID - AccountNumber - Requirements
-- Use a subquery. Calculate the average using AVG(TotalDue). Use the result inside the WHERE clause.
-- Do not use JOIN. Order by CustomerID.

SELECT
    CustomerID,
    AccountNumber
FROM Sales.Customer
WHERE CustomerID IN
(
    SELECT CustomerID
    FROM Sales.SalesOrderHeader
    WHERE TotalDue >
    (
        SELECT AVG(TotalDue)
        FROM Sales.SalesOrderHeader
    )
)
ORDER BY CustomerID;

-- 9 The sales manager wants a report showing each product and the average product price for the 
-- entire catalog. Requirements Use a subquery inside the SELECT. Calculate AveragePrice using AVG(ListPrice).
-- Do not use GROUP BY. Do not use JOIN. Order by ListPrice DESC. 
-- Return ProductID - ProductName - ListPrice - AveragePrice

SELECT
    ProductID,
    Name AS ProductName,
    Listprice,
    (
        SELECT
            AVG(ListPrice)
        FROM Production.Product 
    ) AS AveragePrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- 10 The production manager wants a report showing each product together with the highest product price in 
-- the entire catalog. Requirements Use a subquery inside the SELECT. Use MAX(ListPrice). Do not use GROUP BY.
-- Do not use JOIN. Order by ListPrice DESC. Return ProductID - ProductName - ListPrice - HighestPrice

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice,
    (
        SELECT 
            MAX(ListPrice)
        FROM Production.Product        
    ) AS HighestPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- 11 The production manager wants a report showing each product together with the lowest product price 
-- in the entire catalog. Requirements Use a subquery inside the SELECT. Use MIN(ListPrice). Do not use 
-- GROUP BY. Do not use JOIN. Order by ListPrice ASC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice,
    (
        SELECT
            MIN(ListPrice)
        FROM Production.Product
    ) AS LowestPrice
FROM Production.Product
ORDER BY ListPrice;

-- 12 The production manager wants to create a report containing only products whose price is greater than 1000.
-- Requirements: Use a subquery in the FROM. Filter ListPrice > 1000 inside the subquery. 
-- The outer query should retrieve the columns from the subquery. Do not use JOIN. 
-- Return: ProductID - ProductName - ListPrice

SELECT *
FROM (
    SELECT
        ProductID,
        Name AS ProductName,
        ListPrice
    FROM Production.Product
    WHERE ListPrice > 1000
) AS Over1000;

-- 13 What is the average total sales amount per customer? Requirements Use a subquery in the FROM. 
-- The subquery must calculate the total sales for each customer using SUM(TotalDue). Group by CustomerID.
-- The outer query must calculate the average using AVG(). Do not use JOIN. Return AverageCustomerSales

SELECT
    AVG(TotalSales) AS AverageCustomerSales
FROM (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
) AS CustomerSales;

-- 14 The sales manager wants to know the highest total sales made by a single customer. Requirements Use a 
-- subquery in the FROM. Inside the subquery, calculate the total sales for each CustomerID using 
-- SUM(TotalDue). Group by CustomerID. In the outer query, use MAX(TotalSales). Do not use JOIN.

SELECT
    MAX(TotalSales) AS HighestTotalSales
FROM (
    SELECT
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY CustomerID
) AS Sales;

-- EXISTS
-- 15 The sales manager wants to identify customers who have placed at least one order.
-- Requirements Use EXISTS. Use Sales.Customer as the main table. Check for orders in Sales.SalesOrderHeader.
-- Do not use JOIN. Order by CustomerID. Return CustomerID AccountNumber

SELECT
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS s
    WHERE s.CustomerID = c.CustomerID
);

-- 16. The sales manager wants to identify customers who have placed at least one high-value order (>= 1000).
-- Use EXISTS. Use Sales.Customer as the main table. Check the orders in Sales.SalesOrderHeader.
-- The subquery should check whether TotalDue >= 1000. Order by CustomerID.
-- Return CustomerID and AccountNumber.

SELECT
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer AS c
WHERE EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS s
    WHERE s.CustomerID = c.CustomerID AND s.TotalDue >= 1000
)
ORDER BY c.CustomerID;

-- NOT EXISTS
-- 17 The sales manager wants to identify customers who have never placed an order. Requirements Use NOT EXISTS.
-- Use Sales.Customer as the main table. Check orders in Sales.SalesOrderHeader. Do not use JOIN. Order by CustomerID.

SELECT
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS s
    WHERE s.CustomerID = c.CustomerID
);

-- 18 The sales manager wants to identify customers who do not have any high-value orders. Requirements
-- Use NOT EXISTS. Use Sales.Customer as the main table. Check orders in Sales.SalesOrderHeader. The subquery 
-- must check TotalDue >= 1000. Do not use JOIN. Order by CustomerID. Return CustomerID AccountNumber

SELECT
    c.CustomerID,
    c.AccountNumber
FROM Sales.Customer AS c
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS s
    WHERE s.CustomerID = c.CustomerID AND s.TotalDue >= 1000
)
ORDER BY c.CustomerID;

-- Correlated Subquery
-- 19 The production manager wants to identify products whose price is higher than the average price of products 
-- in the same product subcategory. Return ProductID ProductName ListPrice ProductSubcategoryID
-- Requirements Use a correlated subquery. Use the Production.Product table. Compare each product's ListPrice
-- with the average ListPrice of products in the same ProductSubcategoryID. Do not use JOIN. 
-- Do not use GROUP BY in the outer query. Order the results by ProductSubcategoryID, then ListPrice DESC.

SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice,
    p.ProductSubcategoryID
FROM Production.Product AS p
WHERE p.ListPrice >
(   
    SELECT
        AVG(pp.ListPrice)
    FROM Production.Product AS pp
    WHERE pp.ProductSubcategoryID = p.ProductSubcategoryID
)
ORDER BY
    p.ProductSubcategoryID,
    p.ListPrice DESC;

-- 20 The production manager wants to identify products whose price is lower than the average price of products 
-- in the same product subcategory. Requirements Use a correlated subquery. Compare each product's
-- ListPrice with the average ListPrice of products in the same ProductSubcategoryID. Use Production.Product. 
-- Do not use JOIN. Do not use GROUP BY in the outer query. Order by ProductSubcategoryID, then ListPrice ASC

SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice,
    p.ProductSubcategoryID
FROM Production.Product AS p
WHERE p.ListPrice <
(
    SELECT
        AVG(pp.ListPrice)
    FROM Production.Product AS pp
    WHERE pp.ProductSubcategoryID = p.ProductSubcategoryID
)
ORDER BY 
    p.ProductSubcategoryID,
    ListPrice; 

-- 21 The production manager wants to identify products that are more expensive than every other product in 
-- their own product subcategory. Requirements Use a correlated subquery. Compare each product with other 
-- products in the same ProductSubcategoryID. Identify the product(s) with the highest ListPrice in each 
-- subcategory. Do not use JOIN. Do not use GROUP BY. Order by ProductSubcategoryID, then ListPrice DESC.
-- Return ProductID ProductName ListPrice ProductSubcategoryID

SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice,
    p.ProductSubcategoryID
FROM Production.Product AS p
WHERE p.ListPrice =
(
    SELECT
        MAX(pp.ListPrice)
    FROM Production.Product AS pp
    WHERE pp.ProductSubcategoryID = p.ProductSubcategoryID
)
ORDER BY 
p.ProductSubcategoryID,
p.ListPrice DESC;

-- 22 The production manager wants to identify products whose price is higher than the average price of all
-- other products in the same product subcategory. Requirements Use a correlated subquery. Compare each
-- product with the average price of other products in the same subcategory. The current product itself 
-- must not be included when calculating the average. Do not use JOIN. Do not use GROUP BY in the outer 
-- query. Order by ProductSubcategoryID, then ListPrice DESC.

SELECT
    p.ProductID,
    p.Name AS ProductName,
    p.ListPrice,
    p.ProductSubcategoryID
FROM Production.Product AS p
WHERE p.ListPrice >
(
    SELECT
        AVG(pp.ListPrice)
    FROM Production.Product AS pp
    WHERE pp.ProductSubcategoryID = p.ProductSubcategoryID
       AND pp.ProductID <> p.ProductID
)
ORDER BY 
p.ProductSubcategoryID,
p.ListPrice DESC;

-- 23 The sales manager wants to identify customers who have never placed an order with a TotalDue greater 
-- than the average order value. Requirements Use Sales.Customer as the main table. Check orders in 
-- Sales.SalesOrderHeader. Calculate the average TotalDue using AVG(). Identify customers for whom no order 
-- exceeds that average. Do not use JOIN. Order by CustomerID. Return CustomerID AccountNumber

SELECT
    sc.CustomerID,
    sc.AccountNumber
FROM Sales.Customer AS sc
WHERE NOT EXISTS
(
    SELECT 1
    FROM Sales.SalesOrderHeader AS sh
    WHERE sh.CustomerID = sc.CustomerID
      AND sh.TotalDue >
      (
          SELECT AVG(TotalDue)
          FROM Sales.SalesOrderHeader
      )
)
ORDER BY sc.CustomerID;
