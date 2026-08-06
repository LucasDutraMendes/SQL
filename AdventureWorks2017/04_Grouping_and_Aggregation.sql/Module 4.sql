/*
===========================================================
Module 04 - Grouping and Aggregation
===========================================================

Description:
This module covers SQL aggregation techniques using
GROUP BY, HAVING, aggregate functions, and conditional
logic with CASE.

Topics Covered:
- GROUP BY
- COUNT
- SUM
- AVG
- MIN
- MAX
- HAVING
- CASE
- SUM(CASE...)
- COUNT(CASE...)

Database:
- AdventureWorks2017

Exercises:
13

Author:
Lucas Dutra Mendes

===========================================================
*/

-- GROUP BY
-- 1 Display the number of products for each color.

SELECT Color,
	COUNT(Color) AS CountColors
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
ORDER BY CountColors DESC;

-- SUM ()
-- 2 Display the total sales amount for each customer.

SELECT	
	CustomerID,
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY CustomerID 
ORDER BY TotalSales;

-- AVG()
-- 3 Display the average order value for each customer.

SELECT 
	CustomerID,
	AVG(TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY AverageOrderValue;

-- MAX()
-- 4 Display the cheapest product price for each product subcategory.

SELECT
	ProductSubcategoryID,
	MAX(ListPrice) AS HighestPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
ORDER BY HighestPrice;

-- MIN()
-- 5 Display the most expensive product price for each product subcategory.

SELECT
	ProductSubcategoryID,
	MIN(ListPrice) AS LowestPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID
ORDER BY LowestPrice;

-- SUM()
-- 6 Display the total sales for each customer by year.

SELECT
	CustomerID,
	YEAR(OrderDate) AS OrderYear, 
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY CustomerID, YEAR(OrderDate)
ORDER BY CustomerID, OrderYear;

-- HAVING()
-- 7 Display customers who have placed more than 10 orders.

SELECT
	CustomerID,
	COUNT(SalesOrderID) AS NumberOfOrders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 10
ORDER BY NumberOfOrders DESC;

-- 8 Display customers who placed orders after January 1, 2013 and have more than 5 orders during that period.

SELECT
	CustomerID,
	COUNT(SalesOrderNumber) AS NumberOfOrders -- or COUNT(*)
FROM Sales.SalesOrderHeader
WHERE OrderDate > '2013-01-01'
GROUP BY CustomerID
HAVING COUNT(SalesOrderNumber) > 5
ORDER BY NumberOfOrders DESC; 

-- CASE
-- 9 Classify each product according to its price - Order by List Price
-- ListPrice = 0 → 'Free' - ListPrice < 100 → 'Low Price' - ListPrice < 1000 → 'Medium Price' - Otherwise → 'High Price'

SELECT
	ProductID,
	Name AS ProductName,
	ListPrice,
	CASE
		WHEN ListPrice = 0 THEN 'Free'
		WHEN ListPrice < 100 THEN 'Low Price'
		WHEN ListPrice < 1000 THEN 'Medium Price'
		ELSE 'High Price'
	END AS PriceCategory
FROM Production.Product
ORDER BY ListPrice ASC; 

-- 10 The sales manager wants to know the total value of high-value orders and regular orders for each customer.
-- Return CustomerID - HighValueSales - RegularSales
-- Requirements An order is High Value if TotalDue >= 1000 - Otherwise, it is a Regular Order - 
-- Use SUM() together with CASE - Group the results by CustomerID - Order by CustomerID.

SELECT
	CustomerID,
	SUM(
		CASE
			WHEN TotalDue >= 1000 THEN TotalDue
			ELSE 0
		END
	) AS HighValueSales,

	SUM(
		CASE
			WHEN TotalDue < 1000 THEN TotalDue
			ELSE 0
		END
	) AS RegularSales
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;

-- 11 The sales manager wants to know how many high-value orders and how many regular orders each customer has placed.
-- Return CustomerID - HighValueOrders - RegularOrders
-- Requirements A High Value Order is TotalDue >= 1000 - Otherwise, it is a Regular Order. 
-- Use COUNT() together with CASE. Group the results by CustomerID. Order by CustomerID.

SELECT
	CustomerID,
	COUNT(
		CASE 
			WHEN TotalDue >= 1000 THEN 1
			ELSE NULL
		END
	) AS HighValueOrders,

	COUNT(
		CASE
			WHEN TotalDue < 1000 THEN 1
		ELSE NULL
	END
	) AS RegularOrders
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID;

-- 12 The sales manager wants a summary showing how many products belong to each price category.
-- Classify the products using: ListPrice = 0 → Free - ListPrice < 100 → Low Price 
-- ListPrice < 1000 → Medium Price - Then: Group the results by the price category. 
-- Count the number of products in each category. Order by NumberOfProducts in descending order.
-- Otherwise → High Price

SELECT
    CASE
        WHEN ListPrice = 0 THEN 'Free'
        WHEN ListPrice < 100 THEN 'Low Price'
        WHEN ListPrice < 1000 THEN 'Medium Price'
        ELSE 'High Price'
    END AS PriceCategory,
    COUNT(*) AS NumberOfProducts -- Note Aggregate functions (COUNT, SUM, AVG, MIN, and MAX) 
	                             -- operate on the groups created by the GROUP BY clause.
FROM Production.Product
GROUP BY
    CASE
        WHEN ListPrice = 0 THEN 'Free'
        WHEN ListPrice < 100 THEN 'Low Price'
        WHEN ListPrice < 1000 THEN 'Medium Price'
        ELSE 'High Price'
    END
ORDER BY NumberOfProducts DESC;

-- 13 The sales manager wants a report showing the number of products and the average price for each price 
-- category. Return PriceCategory - NumberOfProducts - AveragePrice. Requirements - Classify the products 
-- using: ListPrice = 0 → Free - ListPrice < 100 → Low Price - ListPrice < 1000 → Medium Price - Otherwise → High Price

SELECT
	CASE
		WHEN ListPrice = 0 THEN 'Free'
		WHEN ListPrice < 100 THEN 'Low Price'
		WHEN ListPrice < 1000 THEN 'Medium Price'
		ELSE 'High Price'
	END AS PriceCategory,
	COUNT(*) AS NumberOfProducts,
	AVG(ListPrice) AS AveragePrice
FROM Production.Product
GROUP BY
	CASE
		WHEN ListPrice = 0 THEN 'Free'
		WHEN ListPrice < 100 THEN 'Low Price'
		WHEN ListPrice < 1000 THEN 'Medium Price'
		ELSE 'High Price'
	END
ORDER BY AveragePrice DESC; 
