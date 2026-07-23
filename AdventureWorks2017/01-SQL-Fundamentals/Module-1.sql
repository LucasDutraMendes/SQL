-- AdventureWorks2017 Table

-- Module 1

/* 1 List the first name, last name, and email promotion of all people.
Order the results by last name. */

SELECT * FROM Person.Person; 

SELECT 
	FirstName, 
	LastName, 
	EmailPromotion 
FROM Person.Person
ORDER BY LastName; 

-- 1.1  Silly queries - use DISTINCT to select distincted FirstNames
SELECT DISTINCT
	FirstName 
FROM PERSON.Person;

-- 2 Return all distinct cities. Sort the cities alphabetically.

SELECT * FROM PERSON.Address;

SELECT DISTINCT 
	City 
FROM PERSON.Address
ORDER BY City;

-- *** Distinct is used to avoid duplicates

-- 3 List every product that costs more than $100. ProductID - Name - ListPrice 
-- Sort by price (highest first).

SELECT 
	ProductID, 
	Name,
	ListPrice
FROM Production.Product
WHERE ListPrice > 100
ORDER BY ListPrice DESC; 

-- 4 The 20 most expensive Products - ProductId, Name, List Price

SELECT TOP(20)
	ProductID,
	Name,
	ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- 5 Find every product whose name starts with Mountain.

SELECT
	ProductID,
	Name
FROM Production.Product
WHERE Name LIKE 'Mountain%'

-- 6 Find every product whose name contains the word Road.

SELECT 
	ProductID,
	Name
FROM Production.Product
WHERE Name LIKE '%ROAD%';

-- 7 Find every product whose name ends with Bike.

SELECT
	ProductID,
	Name
FROM Production.Product
WHERE Name LIKE '%BIKE'; 

-- 8 List every employee hired between: 2012-01-01 - 2013-12-31 - sort by HireDate

SELECT
	BusinessEntityID,
	JobTitle,
	HireDate
FROM HumanResources.Employee
WHERE HireDate BETWEEN '2012-01-01' AND '2013-12-31'
ORDER BY HireDate;

-- 9 Return every customerID whose TerritoryID is: 1 2 4 6 - sort by CustomerId

SELECT
	CustomerID,
	TerritoryID
FROM Sales.Customer
WHERE TerritoryID IN (1,2,4,6)
ORDER BY CustomerID; 

-- 10 List every product whose ListPrice is between 500 and 1500.

SELECT 
	ProductID,
	Name,
	ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 500 AND 1500
ORDER BY ListPrice DESC;
	
-- 11 Return every productId, Name, ProductNumber that has no color assigned.

SELECT
	ProductID,
	Name,
	ProductNumber
FROM Production.Product
WHERE Color IS NULL; 

-- 11.1 Count

SELECT COUNT(*)
FROM Production.Product
WHERE Color IS NULL;

SELECT COUNT(*)
FROM Production.Product
WHERE Color = ' ';


-- 12 Return every productId, Name, ProductNumber that has a color assigned. sort by color

SELECT 
	ProductID,
	Name,
	ProductNumber,
	Color
FROM Production.Product
WHERE Color IS NOT NULL
ORDER BY Color; 

-- 12.1 Count

SELECT COUNT(*)
FROM Production.Product
WHERE Color IS NOT NULL;

-- 13 Return every product whose color is: Black - Red - Silver - Sort by Color, Name

SELECT
	ProductID,
	Name,
	Color
FROM Production.Product
WHERE Color IN ('Black', 'Red', 'Silver')
ORDER BY 
	Color,
	Name; 

-- 14 Return the first 15 products ordered alphabetically.

SELECT TOP (15)
	ProductID,
	Name,
	ProductNumber
FROM Production.Product
ORDER BY Name; 

-- 15 Find every person whose last name begins with the letter S. Sort alphabetically

SELECT 
	BusinessEntityID,
	FirstName,
	MiddleName,
	LastName
FROM Person.Person
WHERE LastName LIKE 'S%'
ORDER BY 
	LastName, 
	FirstName; 

-- 16 Find every person whose first name contains the letters an. Sort by FirstName Asc - LastName Desc

SELECT 
	BusinessEntityID,
	FirstName,
	MiddleName,
	LastName
FROM Person.Person
WHERE FirstName LIKE '%an%'
ORDER BY 
	FirstName ASC,
	LastName DESC;

-- 17 List every sales order placed after 2013-01-01. Sort by newest orders first.

SELECT
	SalesOrderID,
	OrderDate,
	TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate > '2013-01-01'
ORDER BY OrderDate DESC;

-- 18 Return the 25 largest sales orders based on TotalDue. 

SELECT TOP (25)
	SalesOrderID,
	OrderDate,
	TotalDue
FROM Sales.SalesOrderHeader 
ORDER BY TotalDue DESC; 

-- 19 Find every product that satisfies all of these conditions: 
-- Price greater than 1000
-- Color is not NULL
-- FinishedGoodsFlag = 1
-- Sort by ListPrice descending.

SELECT
	ProductID,
	Name,
	ProductNumber,
	ListPrice,
	Color,
	FinishedGoodsFlag
FROM Production.Product
WHERE 
	ListPrice > 1000 
	AND Color IS NOT NULL 
	AND FinishedGoodsFlag = 1 
ORDER BY ListPrice DESC; 

-- 20 Create a report showing products that satisfy all of these conditions:
-- Name contains Touring
-- Price between 1000 and 3000
-- FinishedGoodsFlag = 1
-- Color is not NULL
-- Order by: ListPrice descending Name ascending 

SELECT 
	ProductID,
	Name,
	ProductNumber,
	Color,
	ListPrice 
FROM Production.Product
WHERE 
	Name LIKE '%Touring%'
	AND ListPrice Between 1000 and 3000
	AND FinishedGoodsFlag = 1
	AND Color IS NOT NULL
ORDER BY
	ListPrice DESC,
	Name ASC; 

-- 21 List the 10 cheapest finished products.

SELECT TOP (10)
	ProductID,
	Name,
	ProductNumber,
	ListPrice,
	FinishedGoodsFlag
FROM Production.Product
WHERE FinishedGoodsFlag = 1
ORDER BY
	ListPrice ASC,
	Name ASC;


--22 How many different cities exist in the database?

SELECT 
	COUNT(DISTINCT City) AS DistinctCities
FROM Person.Address;

--23 Find every product whose name contains Helmet, Road, or Touring.

SELECT
	ProductID,
	Name,
	ProductNumber
FROM Production.Product
WHERE 
	Name LIKE '%Helmet%'
	OR Name LIKE '%Road%'
	OR Name LIKE '%Touring%'
ORDER BY 
	Name,
	ProductID; 

--24 List every employee hired before 2010 - Sort by HireDate.

SELECT
	BusinessEntityID,
	NationalIDNumber,
	JobTitle,
	HireDate
FROM HumanResources.Employee
WHERE HireDate < '2010-01-01'
ORDER BY
	HireDate DESC; 
	
select * from HumanResources.Employee
Table: HumanResources.Employee

-- 25 Return the 50 oldest sales orders.

SELECT TOP (50)
	SalesOrderID,
	SalesOrderNumber,
	PurchaseOrderNumber,
	OrderDate
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

-- 26 All Products where weight is between 700 and 500.

SELECT 
	ProductID,
	Name, 
	ProductNumber,
	Weight
FROM Production.Product 
WHERE Weight BETWEEN 500 AND 700;
--WHERE Weight >= 500 and Weight <= 700; 


