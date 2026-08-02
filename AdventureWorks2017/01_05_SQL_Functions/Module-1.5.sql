/*==============================================================================
Module 1.5 - SQL Functions

Database: AdventureWorks2017
Language: T-SQL (SQL Server)

Description:
This module introduces the most commonly used SQL functions for data
manipulation and transformation. The exercises cover string, numeric,
date/time, data conversion and NULL-handling functions frequently used
in Data Analysis and Data Engineering.

Topics Covered:

String Functions
- LEN()
- UPPER()
- LOWER()
- LEFT()
- RIGHT()
- SUBSTRING()
- CHARINDEX()

Numeric Functions
- ROUND()
- CEILING()
- FLOOR()
- ABS()

Date & Time Functions
- GETDATE()
- YEAR()
- MONTH()
- DAY()
- DATEADD()
- DATEDIFF()
- EOMONTH()
- DATEFROMPARTS()

Data Type Conversion
- CAST()
- CONVERT()

NULL Handling
- ISNULL()
- COALESCE()

Learning Objectives:
- Manipulate and transform text values.
- Perform numeric calculations and rounding.
- Work with dates and time intervals.
- Convert data between different data types.
- Handle NULL values correctly.
- Combine multiple SQL functions in practical queries.

Author: Lucas Dutra Mendes
==============================================================================*/

-- LEN(text)
-- 1 Return the first name of every person and the number of characters in the first name.

SELECT 
    FirstName,
    LEN(FirstName) AS NameLength
FROM Person.Person;

-- 2 Return only employees whose first name has more than 8 characters.

SELECT
    Firstname
FROM Person.Person
WHERE  
    LEN(FirstName) > 8; 
   
-- 3 List every product name ordered from the shortest name to the longest.

SELECT
    Name
FROM Production.Product
ORDER BY
    LEN(Name) ASC,
    Name ASC;

-- UPPER(text)
-- 4 Return every first name in uppercase. 

SELECT
    UPPER(FirstName) AS FirstNameUpper
FROM Person.Person;

-- 5 Display the product name and another column showing the product name in uppercase.

SELECT
    ProductID,
    UPPER(Name) AS ProductNameUpper,
    ProductNumber
FROM Production.Product;

-- 6 Return only products whose color is Red. Compare using UPPER().
-- *** This exercise simulates the DB is case sensitive

SELECT
    ProductID,
    Name,
    ProductNumber,
    Color 
FROM Production.Product
WHERE
    UPPER(Color) = 'RED'; 

-- LOWER(text)
-- 7 Return every person's first name in lowercase and last name in uppercase.

SELECT 
    BusinessEntityID,
    LOWER(FirstName) AS FirstNameLower,
    MiddleName,
    UPPER(LastName) AS LastNameUpper
FROM Person.Person;

-- 8 Display the product name in lowercase and ProductNumber in uppercase.

SELECT
    ProductID,
    LOWER(Name) AS ProductNameLower,
    UPPER(ProductNumber) AS ProductNumberUpper
FROM Production.Product;

-- LEFT(text, endPoint)
-- 9 the first 2 characters of the ProductNumber

SELECT
    ProductID,
    ProductNumber,
    LEFT(ProductNumber, 5) AS TwoCharactersProduct
FROM Production.Product; 

-- 10 the first 5 characters of the product name.

SELECT  
    ProductID,
    Name,
    LEFT(Name, 5) AS FiveCharactersProduct
FROM Production.Product;

-- 11 The sales department wants to see only products whose ProductNumber starts with "BK".

SELECT
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE
    UPPER(LEFT(ProductNumber,2)) = 'BK';

-- RIGHT(text, endPoint)
-- 12 Return: ProductID - ProductNumber - the last 2 characters of the ProductNumber

SELECT
    ProductID,
    Name,
    ProductNumber,
    RIGHT(ProductNumber, 2) AS LastTwoCharacters
FROM Production.Product; 

-- 13 Return: ProductNumber ending in 42

SELECT
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE
    RIGHT(ProductNumber, 2) = '42'; 

-- SUBSTRING(text, startPoint,length) 

SELECT
    ProductID,
    Name,
    ProductNumber,
    SUBSTRING(ProductNumber, 4, 4) AS MiddleCode
FROM Production.Product;

-- 15 Return: ProductID - Name - the first 10 characters of the product name using 
-- SUBSTRING() (do not use LEFT())

SELECT
    ProductID,
    Name,
    SUBSTRING(Name, 1, 10) AS FirstTenCharacters
FROM Production.Product;

-- 16 The engineering department wants to see only products whose 4th character 
-- in ProductNumber is "M".

SELECT
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE   
    UPPER(SUBSTRING(ProductNumber, 4, 1)) = 'M';
    
-- CHARINDEX(expression, text, start position)
-- 17 Return: ProductID, ProductNumber 
-- the position of the first dash (-) in ProductNumber.

SELECT
    ProductID,
    ProductNumber,
    CHARINDEX('-', ProductNumber) AS FirstDashPosition
FROM Production.Product;

-- 18 Return: ProductID, ProductNumber
-- the position of the letter "M" in ProductNumber

SELECT
    ProductID,
    Name,
    ProductNumber,
    CHARINDEX('M', ProductNumber) AS MPosition
FROM Production.Product
WHERE
    CHARINDEX('M', ProductNumber) != 0
ORDER BY
    CHARINDEX('M', ProductNumber) DESC; 

-- 19 Return ProductID, ProductNumber - show only products where letter "L" exists in ProductNumber

SELECT
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE
    CHARINDEX('L', ProductNumber) != 0;  

-- 20 - Return ProductID and ProductNumber for products where the letter 'A' appears after position 2.

SELECT
    ProductID,
    Name,
    ProductNumber
FROM Production.Product
WHERE
    CHARINDEX('A', ProductNumber, 2) != 0;     

-- 21 — The business stores product codes in the following format: AA-1234-BB
-- AA = Product Category
-- 123456 = Product Identifier
-- BB = Product Version
-- 1 Display ProductID - ProductNumber
-- 2 Extract the ProductCategory and ProductIdentifier only
-- 3 Name the new columns accordingly.

SELECT
    ProductID,
    ProductNumber,
    LEFT(
        ProductNumber, 
        CHARINDEX('-', ProductNumber) - 1) 
        AS ProductCategory,   
    SUBSTRING(
        ProductNumber,
        CHARINDEX('-',ProductNumber) +1, 
        CHARINDEX('-',ProductNumber) +1)
        AS ProductIdentifier
FROM Production.Product; 

-- ROUND(12.4523, 2) = 12.45
-- 22 Return - ProductID, Name, ListPrice, RoundedPrice to 2 decimal places 
-- Display values higher than 0 DESC

SELECT
    ProductID,
    Name,
    ListPrice,
    ROUND(ListPrice, 2) AS RoundedPrice
FROM Production.Product
WHERE
    ListPrice > 0 
ORDER BY
    ListPrice DESC;

-- CEILING(12.11111) = 13 round up
-- 23 Return - ProductID, Name, Weight, RoundedUpWeight 

SELECT
    ProductID,
    Name,
    Weight,
    CEILING(Weight) AS RoundedUpWeight
FROM Production.Product
WHERE 
    Weight IS NOT NULL;

-- FLOOR(12.11111) = 12 round down
-- 24 Return - ProductID, Name, Weight, RoundedDownWeight 

SELECT
    ProductID,
    Name,
    Weight,
    FLOOR(Weight) AS RoundedDownWeight
FROM Production.Product
WHERE 
    Weight IS NOT NULL;

-- ABS(-25) = 25 - returns absolute value
-- 25 Imagine the ListPrice is 100 - show the ListPrice difference
-- Return ProductID, Name, ListPrice, DifferenceFrom100

SELECT
    ProductID,
    Name,
    ListPrice,
    ABS(Listprice - 100) AS DifferenceFrom100
FROM Production.Product
WHERE 
    ListPrice > 0; 

-- 26 Return Name, ListPrice, RoundedPrice, RoundedUpPrice, RoundedDownPrice

SELECT
    Name,
    ListPrice,
    ROUND(ListPrice, 1) AS RoundedPrice, 
    CEILING(ListPrice) AS RoundedUpPrice,
    FLOOR(ListPrice) AS RoundedDownPrice
FROM Production.Product
WHERE 
    ListPrice > 0; 

-- Date & Time
-- GETDATE() - YEAR() - MONTH - DAY
-- 27 Return CurrentDateTime - Year, Month, Day, Hour, Minute, Second

SELECT 
    GETDATE() AS CURRENTDATE,
    YEAR(GETDATE()) AS YEAR,
    MONTH(GETDATE()) AS MONTH,
    DAY(GETDATE()) AS DAY; 

-- 28 Return ProductID, Name, SellStartDate, SellYear, ModifiedDate, ModifiedMonth, ModifiedDay

SELECT
    ProductID,
    Name,
    SellStartDate,
    YEAR(SellStartDate) AS SellYear,
    ModifiedDate,
    MONTH(ModifiedDate) AS ModifiedMonth,
    DAY(ModifiedDate)  AS ModifiedDay
FROM Production.Product;

-- DATEADD(interval, quantity, data)
-- 29 Return CurrentDate - TenDaysLater - ThirtyDaysEarlier - OneYearLater - OneMonthLater

SELECT 
    GETDATE() AS CurrentDate,
    DATEADD(DAY, 10, GETDATE()) AS TenDaysLater,
    DATEADD(DAY, -30, GETDATE()) AS ThirtyDaysEarlier,
    DATEADD(YEAR, 1, GETDATE()) AS OneYearLater,
    DATEADD(MONTH, 1, GETDATE()) AS OneMonthLater;

-- 30 ProductID, Name, ModifiedDate, ModifiedDateMinus30Days

SELECT
    ProductID,
    Name,
    ModifiedDate,
    DATEADD(DAY, -30, ModifiedDate) AS ModifiedDateMinus30Days
FROM Production.Product
ORDER BY
    ModifiedDate DESC,
    Name;

-- 30.1 Real-world example
-- Return products modified in the last 30 days
SELECT
    ModifiedDate
FROM Production.Product
WHERE
    ModifiedDate >= DATEADD(DAY, -30, GETDATE());

-- DATEDIFF(interval, date_in, date_final)
-- 31 Return CurrentDate - Dayssince2020

SELECT
    GETDATE() AS CurrentDate,
    DATEDIFF(DAY, '2020-01-01', GETDATE()) AS Dayssince2020;

-- 32 ProductID, Name, SellStartDate, YearsSelling - How many years has passed since SellStartDate
-- MonthsSelling
SELECT
    ProductID,
    Name,
    SellStartDate,
    YEAR(SellStartDate) AS SellYear,
    DATEDIFF(YEAR, SellStartDate, GETDATE()) AS YearsSelling,
    DATEDIFF(MONTH, SellStartDate, GETDATE()) AS MonthsSelling
FROM Production.Product;

-- 33 DATEADD - DATEDIFF - Return ProductID, Name, ModifiedDate, ModifiedDateMinus30Days, DaysSinceModified

SELECT
    ProductID,
    Name,
    ModifiedDate,
    DATEADD(DAY, -30, ModifiedDate) AS ModifiedDateMinus30Days,
    DATEDIFF(DAY, ModifiedDate, GETDATE()) AS DaysSinceModified
FROM Production.Product;

-- 34 Return - Products modified last 30 days ProductID, Name, ModifiedDate - Use GETDATE() DATEADD() WHERE

SELECT  
    ProductID,
    Name,
    ModifiedDate
FROM Production.Product
WHERE
    ModifiedDate >= DATEADD(DAY, -30, GETDATE());

-- EOMONTH() - end of month
-- 35 Return CurrentDate - EndOfCurrentMonth - EndOfNextMonth

SELECT
    GETDATE() AS CurrentDate,
    EOMONTH(GETDATE()) AS EndOfCurrentMonth,
    EOMONTH(GETDATE(), 1);

-- 36 ProductID, Name, SellStartDate, SellMonthEnd - ModifiedDate - EndOfPreviousMonth

SELECT 
    ProductID,
    Name,
    SellStartDate,
    EOMONTH(SellStartDate) AS SellMonthEnd,
    ModifiedDate,
    EOMONTH(ModifiedDate, -1) AS EndOfPreviousMonth
FROM Production.Product;

-- DATEFROMPARTS(year, month, day)
-- 37 Return CustomDate 2026-12-25 - FirstDayOfCurrentYear

SELECT
    DATEFROMPARTS(2026, 12, 25) AS CustomDate,
    DATEFROMPARTS(YEAR(GETDATE()), 1, 1) AS FirstDayOfCurrentYear;  

-- 38 ProductID, Name, SellStartDate, SellYear
-- RebuiltDate(YEAR(SellStartDate), MONTH(SellStartDate) ,DAY(SellStartDate))

SELECT
    ProductID,
    Name,
    SellStartDate,
    YEAR(SellStartDate) AS SellYear,
    DATEFROMPARTS(
    YEAR(SellStartDate),
    MONTH(SellStartDate),
    DAY(SellStartDate)) AS RebuiltDate
FROM Production.Product;

-- CAST(expression AS data_type)
-- 39 Return: ProductID, Name, ListPrice, ListPriceAsInt, ModifiedDate, ModifiedDateOnly

SELECT
    ProductID,
    Name,
    ListPrice,
    CAST(ListPrice AS INT) AS ListPriceAsInt,
    ModifiedDate,
    CAST(ModifiedDate AS DATE) AS ModifiedDateOnly
FROM Production.Product
WHERE   
    ListPrice > 0
ORDER BY
    ListPrice ASC;

-- 40 Return ProductID, ProductIDText, Name, ListPrice, RoundedPrice

SELECT
    ProductID,
    CAST(ProductID AS VARCHAR(10)) AS ProductIDText,
    Name,
    ListPrice,
    CAST(ListPrice AS DECIMAL(10,2)) AS PriceDecimal
FROM Production.Product
WHERE   
    ListPrice > 0
ORDER BY
    ListPrice ASC;

-- CONVERT(data_type, expression [, style])
-- 101 = MM/DD/YYYY - 103 = DD/MM/YYYY - 120 = YYYY-MM-DD HH:MI:SS - 23 (ISO) = YYYY-MM-DD
-- 41 Return ProductID, Name, ModifiedDate, ModifiedDateOnly, BrazilianDate, ISODate 

SELECT
    ProductID,
    Name,
    ModifiedDate, 
    CONVERT(DATE, ModifiedDate) AS ModifiedDateOnly,
    CONVERT(VARCHAR(10), ModifiedDate, 103) AS BrazilianDate,
    CONVERT(VARCHAR(10), ModifiedDate, 23) AS ISODate
FROM Production.Product;

-- 42 Return ProductID, Name, SellStartDate, SellStartDateBR, SellStartDateISO

SELECT
    ProductID,
    Name,
    SellStartDate,
    CONVERT(VARCHAR(10), SellStartDate, 103) AS SellStartDateBR,
    CONVERT(VARCHAR(10), SellStartDate, 23) AS SellStartDateISO
FROM Production.Product;

-- ISNULL(expression, replacement_value)
-- 43 ProductId, Name, Weight, WeightNoNull, Color, ColorNoNull, SellEndDate, SellEndDateNoNull

SELECT
    ProductID,
    Name,
    Weight,
    ISNULL(Weight, 0) AS WeightNoNull,
    Color,
    ISNULL(Color, 'Unknown') AS ColorNoNull,
    SellEndDate,
    ISNULL(SellEndDate, GETDATE()) AS SellEndDateNoNull
FROM Production.Product;

-- COALESCE(expression1, expression2, expression3, ...)
-- 44 Return ProductID, Name, Color, ColorNoNull, WeightNoNull, SellEndDate, SellEndDateNoNull

SELECT
    ProductID,
    Name,
    Color,
    Weight,
    SellEndDate,
    COALESCE(Color, 'Unknown') AS ColorNoNull,
    COALESCE(Weight, 0) AS WeightNoNull,
    COALESCE(SellEndDate, GETDATE()) AS SellEndDateNoNull
FROM Production.Product;

-- 45 Return ProductID, Name, Color - ISNULL & COALESCE - COMPARE BOTH

SELECT
    ProductID,
    Name,
    Color,
    ISNULL(Color, 'Unknown') AS IsNullValue,
    COALESCE(Color, 'Unknown') AS CoalesceValue
FROM Production.Product;
