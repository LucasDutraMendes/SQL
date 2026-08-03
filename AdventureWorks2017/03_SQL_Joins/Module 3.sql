/*
===========================================================
Module 03 - SQL JOINs
===========================================================

Description:
This module covers the most commonly used SQL JOIN operations
using the AdventureWorks2017 sample database.

Topics Covered:
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- FULL OUTER JOIN
- CROSS JOIN
- SELF JOIN (Concept Reference)

Database:
- AdventureWorks2017

Exercises:
23

Author:
Lucas Dutra Mendes

===========================================================
*/

-- INNER JOIN - Returns only the rows that have matching values in both tables
-- 1 Retrieve the customer ID, sales order ID, and order date for every order.

SELECT
	c.CustomerID,
	s.SalesOrderID,
	s.OrderDate
FROM Sales.Customer AS c
INNER JOIN Sales.SalesOrderHeader AS s
	ON c.CustomerID = s.CustomerID
ORDER BY s.OrderDate DESC; 

-- 2 Retrieve the sales order ID, product ID, and product name.

SELECT
	s.SalesOrderID,
	p.ProductID,
	p.Name
FROM Sales.SalesOrderDetail AS s
INNER JOIN Production.Product as p
	ON s.ProductID = p.ProductID
ORDER BY p.Name;

-- 3 Retrieve the customer ID, sales order ID, order date, and total due. 
-- Order the results by OrderDate in descending order.

SELECT
	c.CustomerID,
	s.SalesOrderID,
	s.OrderDate,
	s.TotalDue
FROM Sales.Customer as c
INNER JOIN Sales.SalesOrderHeader as s
	ON c.CustomerID = s.CustomerID
ORDER BY s.OrderDate DESC;

-- 4 Retrieve the product name, order quantity, and unit price. Order the results by ProductName.

SELECT
	p.Name,
	s.OrderQty,
	s.UnitPrice
FROM Production.Product AS p
INNER JOIN sales.SalesOrderDetail AS s
	ON p.ProductID = s.ProductID
ORDER BY p.Name;

-- 5 Retrieve BusinessEntityID, FirstName, LastName, JobTitle

SELECT
	p.BusinessEntityID,
	p.FirstName,
	p.LastName,
	h.JobTitle
FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS h
	ON p.BusinessEntityID = h.BusinessEntityID
ORDER BY p.LastName;

-- 6 Retrieve the following information for each sales order:
-- SalesOrderID, CustomerID, OrderDate, AccountNumber

SELECT
	c.CustomerID,
	c.AccountNumber,
	s.SalesOrderID,
	s.OrderDate
FROM Sales.Customer AS c
INNER JOIN Sales.SalesOrderHeader AS s
	ON c.CustomerID = s.CustomerID
ORDER BY s.SalesOrderID;

-- 7 Retrieve the following information:
-- SalesOrderID, CustomerID, ProductName, OrderQty, UnitPrice

SELECT
	p.ProductID,
	p.Name,
	sd.OrderQty,
	sd.UnitPrice,
	sh.SalesOrderID,
	sh.CustomerID
FROM Production.Product AS p
INNER JOIN Sales.SalesOrderDetail AS sd 
	ON sd.ProductID = p.ProductID
INNER JOIN Sales.SalesOrderHeader AS sh
	ON sh.SalesOrderID = sd.SalesOrderID
ORDER BY sh.SalesOrderID;

-- 8 Retrieve the following information: CustomerID, SalesOrderID, OrderDate
-- ProductName, OrderQty, UnitPrice

SELECT
	sc.CustomerID,
	soh.SalesOrderID,
	soh.OrderDate,
	sod.OrderQty,
	sod.UnitPrice,
	pp.Name AS ProductName
FROM Sales.Customer AS sc
INNER JOIN Sales.SalesOrderHeader AS soh
	ON sc.CustomerID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS pp
	ON sod.ProductID = pp.ProductID
ORDER BY 
	sc.CustomerID,
	soh.SalesOrderID; 

-- 9 Return: SalesOrderID, OrderDate, CustomerID, ProductName, OrderQty, UnitPrice

SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	soh.CustomerID,
	pp.Name AS ProductName,
	sod.OrderQty,
	sod.UnitPrice
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN Production.Product AS pp
	ON pp.ProductID = sod.ProductID
ORDER BY
    soh.SalesOrderID;

-- LEFT JOIN
-- 10 Display all customers, including those who have never placed an order.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate
FROM Sales.Customer AS sc
LEFT JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
ORDER BY sh.OrderDate DESC;

-- 11 Display only the customers who have never placed an order.
-- use LEFT JOIN() 

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate
FROM Sales.Customer AS sc
LEFT JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
WHERE sh.SalesOrderID IS NULL;

-- 12 Display all products, including products that have never been sold.

SELECT
	pp.ProductID,
	pp.Name AS ProductName,
	sd.SalesOrderID
FROM Production.Product AS pp
LEFT JOIN Sales.SalesOrderDetail AS sd
	ON pp.ProductID = sd.ProductID
ORDER BY pp.ProductID; 

-- 13 Display only the products that have never been sold.

SELECT
	pp.ProductID,
	pp.Name AS ProductName,
	sd.SalesOrderID
FROM Production.Product AS pp	
LEFT JOIN Sales.SalesOrderDetail AS sd
	ON pp.ProductID = sd.ProductID
WHERE
	sd.SalesOrderID IS NULL;

-- 14 Display all customers and their orders, but only orders whose TotalDue is greater than 1000.
-- Preserve all customers - Customers without qualifying orders must still appear.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate,
	sh.TotalDue
FROM Sales.Customer AS sc
LEFT JOIN Sales.SalesOrderHeader AS sh
    ON sc.CustomerID = sh.CustomerID
    AND sh.TotalDue > 1000;

-- 15 Display customers who have no orders over 1000.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate,
	sh.TotalDue
FROM Sales.Customer AS sc
LEFT JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
	AND sh.TotalDue > 1000
WHERE sh.SalesOrderID IS NULL
ORDER BY CustomerID;

-- 16 The sales manager wants a report showing every product, even those that have never been sold.

SELECT
	pp.ProductID,
	pp.Name AS ProductName,
	sd.SalesOrderID,
	sd.OrderQty,
	sd.UnitPrice
FROM Production.Product AS pp		
LEFT JOIN Sales.SalesOrderDetail AS sd
	ON pp.ProductID = sd.ProductID
ORDER BY
	pp.ProductID,
	sd.SalesOrderID; 

-- RIGHT JOIN
-- 17 The company wants a report showing every sales order, even if the corresponding customer record 
-- is missing. SalesOrderID - OrderDate - CustomerID - AccountNumber

SELECT
	sh.SalesOrderID,
	sh.OrderDate,
	sc.CustomerID,
	sc.AccountNumber
FROM Sales.Customer AS sc
RIGHT JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
ORDER BY sh.SalesOrderID;

-- FULL OUTER JOIN
-- 18 The company wants a report showing every customer and every sales order.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate
FROM Sales.Customer	AS sc
FULL OUTER JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
ORDER BY
	sc.CustomerID,
	sh.SalesOrderID; 

-- 19 Show only the records that do not have a matching record in the other table.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate
FROM Sales.Customer	AS sc
FULL OUTER JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
WHERE
	sh.SalesOrderID IS NULL
ORDER BY
	sc.CustomerID,
	sh.SalesOrderID; 

-- 20 The data quality team wants to identify records that do not have a matching record in the related table.

SELECT
	sc.CustomerID,
	sh.SalesOrderID,
	sh.OrderDate
FROM Sales.Customer	AS sc
FULL OUTER JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
WHERE
	sc.CustomerID IS NULL OR
	sh.OrderDate IS NULL
ORDER BY
	sc.CustomerID,
	sh.SalesOrderID; 

-- 21 The data quality team wants to identify customers who have never placed an order.

SELECT
	 sc.CustomerID,
	 sc.AccountNumber,
	 sh.SalesOrderID,
	 sh.OrderDate
FROM Sales.Customer AS sc
FULL OUTER JOIN Sales.SalesOrderHeader AS sh
	ON sc.CustomerID = sh.CustomerID
WHERE
	sh.SalesOrderID IS NULL
ORDER BY
	sc.CustomerID;

-- CROSS JOIN
-- 22 The company wants to generate every possible combination between sales territories and sales people.

SELECT
	st.TerritoryID,
	st.Name AS TerritoryName,
	sp.BusinessEntityID
FROM Sales.SalesTerritory AS st
CROSS JOIN Sales.SalesPerson AS sp;

-- 23 The company wants to generate every possible combination between 
-- products and sales territories to prepare a future pricing table.

SELECT
	pp.ProductID,
	pp.Name AS ProductName,
	st.TerritoryID,
	st.Name AS TerritoryName
FROM Production.Product AS pp
CROSS JOIN Sales.SalesTerritory AS st;

-- ==========================================
-- SELF JOIN (Reference)
-- ==========================================
-- AdventureWorks2017 does not contain a natural hierarchical table
-- suitable for demonstrating a classical SELF JOIN.
--
-- A SELF JOIN is not a SQL keyword.
-- It is a JOIN where the same table is referenced twice using different aliases.
--
-- Example:

/*

SELECT
    e.EmployeeID,
    e.EmployeeName,
    m.EmployeeName AS ManagerName
FROM Employees AS e
INNER JOIN Employees AS m
    ON e.ManagerID = m.EmployeeID;
