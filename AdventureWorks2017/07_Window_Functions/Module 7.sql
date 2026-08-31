/*
=============================================================
Module 07 - Window Functions
=============================================================

Description:
This module introduces SQL window functions used to perform
calculations across related rows without collapsing the result
set.

Topics Covered:
- OVER()
- PARTITION BY
- ORDER BY
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- SUM() OVER()
- Running Totals
- Moving Averages
- FIRST_VALUE()
- LAST_VALUE()
- Window Frames
- Window Functions + CTEs

Database:
- AdventureWorks2017

Exercises:
18

Author:
Lucas Dutra Mendes

=============================================================
*/

-- OVER()
-- 1 The production manager wants a report showing every product together with the average ListPrice of all products.
-- Use a window function with AVG() and OVER(). Return: ProductID ProductName ListPrice AverageListPrice.
-- Do not use GROUP BY. Order by ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice,
    AVG(ListPrice) OVER() AS AverageListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- OVER(PARTITION BY)
-- 2 The production manager wants a report showing every product together with the average ListPrice
-- of products in the same ProductSubcategoryID. Use AVG() with OVER() and PARTITION BY ProductSubcategoryID.
-- Return: ProductID ProductName ListPrice ProductSubcategoryID AverageSubcategoryPrice.
-- Do not use GROUP BY. Order by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ListPrice,
    ProductSubCategoryID,
    AVG(ListPrice) OVER(PARTITION BY ProductSubCategoryID) AS AverageSubcategoryPrice
FROM Production.Product
ORDER BY ProductSubCategoryID, 
         ListPrice DESC; 

-- ROW_NUMBER()
-- 3 The production manager wants to rank products from the most expensive to the cheapest within each ProductSubcategoryID.
-- Use ROW_NUMBER() with PARTITION BY ProductSubcategoryID and ORDER BY ListPrice DESC.
-- Return: ProductID ProductName ProductSubcategoryID ListPrice ProductRank.
-- Order the final result by ProductSubcategoryID, then ProductRank.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubcategoryID,
    ListPrice,
    ROW_NUMBER() OVER(
        PARTITION BY ProductSubCategoryID
        ORDER BY ListPrice DESC) AS ProductRank
FROM Production.Product
ORDER BY
    ProductSubcategoryID,
    ProductRank;

-- RANK() - DENSE_RANK()
-- 4 The production manager wants to compare three ranking methods for products within each ProductSubcategoryID.
-- Use ROW_NUMBER(), RANK(), and DENSE_RANK(), each partitioned by ProductSubcategoryID and ordered by ListPrice DESC.
-- Return: ProductID ProductName ProductSubcategoryID ListPrice RowNumberRank RankValue DenseRankValue.
-- Order the final result by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubcategoryID,
    ListPrice,
    ROW_NUMBER() OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS RowNumberRank,
    RANK() OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS RankValue,
    DENSE_RANK() OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS DenseRankValue
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
ORDER BY
    ProductSubcategoryID,
    ListPrice DESC; 

-- LAG()
-- 5 The production manager wants to compare each product's ListPrice with the ListPrice
-- of the previous product within the same ProductSubcategoryID.
-- Use LAG() with PARTITION BY ProductSubcategoryID and ORDER BY ListPrice DESC.
-- Return: ProductID ProductName ProductSubcategoryID ListPrice PreviousListPrice.
-- Order the final result by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubcategoryID,
    ListPrice,
    LAG(ListPrice) OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS PreviousListPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
ORDER BY
    ProductSubcategoryID,
    ListPrice DESC; 

-- LEAD()
-- 6 The production manager wants to compare each product's ListPrice with the ListPrice
-- of the next product within the same ProductSubcategoryID.
-- Use LEAD() with PARTITION BY ProductSubcategoryID and ORDER BY ListPrice DESC.
-- Return: ProductID ProductName ProductSubcategoryID ListPrice NextListPrice.
-- Order the final result by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubcategoryID,
    ListPrice,
    LEAD(ListPrice) OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS NextListPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
ORDER BY
    ProductSubcategoryID,
    ListPrice DESC;

-- SUM() OVER()
-- 7 The sales manager wants to analyze cumulative sales over time.
-- Use SUM() as a window function with ORDER BY OrderDate and SalesOrderID.
-- Calculate a running total of TotalDue. Return: SalesOrderID OrderDate TotalDue RunningTotal.
-- Use Sales.SalesOrderHeader. Order the final result by OrderDate, then SalesOrderID.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue,
    SUM(TotalDue) OVER(ORDER BY OrderDate, SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader
ORDER BY OrderDate, SalesOrderID; 

-- 8 The sales manager wants to analyze cumulative sales for each customer over time.
-- Use SUM() as a window function with PARTITION BY CustomerID and ORDER BY OrderDate and SalesOrderID.
-- Calculate a running total of TotalDue for each customer. Return:
-- CustomerID SalesOrderID OrderDate TotalDue CustomerRunningTotal.
-- Use Sales.SalesOrderHeader. Order the final result by CustomerID, then OrderDate, then SalesOrderID.

SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    TotalDue,
    SUM(TotalDue) OVER(PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID) AS CustomerRunningTotal    
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, OrderDate, SalesOrderID; 

-- Moving Average - ROWS BETWEEN
-- 9 The sales manager wants to analyze the average order value over a rolling window of the current order
-- and the two previous orders. Use AVG() as a window function with ORDER BY OrderDate and SalesOrderID.
-- Use ROWS BETWEEN 2 PRECEDING AND CURRENT ROW to define the window.
-- Return: SalesOrderID OrderDate TotalDue MovingAverage.
-- Use Sales.SalesOrderHeader. Order the final result by OrderDate, then SalesOrderID.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue,
    AVG(TotalDue) OVER(ORDER BY OrderDate, SalesOrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM Sales.SalesOrderHeader
ORDER BY OrderDate, SalesOrderID;

-- 10 The sales manager wants to analyze each customer's recent order values using a rolling average.
-- Use AVG() as a window function with PARTITION BY CustomerID and ORDER BY OrderDate and SalesOrderID.
-- Use ROWS BETWEEN 2 PRECEDING AND CURRENT ROW to calculate the average of the current order and the two previous orders
-- for each customer. Return: CustomerID SalesOrderID OrderDate TotalDue CustomerMovingAverage.
-- Use Sales.SalesOrderHeader. Order the final result by CustomerID, then OrderDate, then SalesOrderID.

SELECT
    CustomerID,
    SalesOrderID,
    OrderDate,
    TotalDue,
    AVG(TotalDue) OVER(PARTITION BY CustomerID ORDER BY OrderDate, SalesOrderID
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, OrderDate, SalesOrderID;

-- 11 The sales manager wants to analyze how each order value changes compared with the previous order.
-- Use LAG() with ORDER BY OrderDate and SalesOrderID to retrieve the previous order's TotalDue.
-- Calculate the difference between the current TotalDue and the previous TotalDue.
-- Return: SalesOrderID OrderDate TotalDue PreviousTotalDue OrderDifference.
-- Use Sales.SalesOrderHeader. Order the final result by OrderDate, then SalesOrderID.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue,
    LAG(TotalDue) OVER(
        ORDER BY OrderDate, SalesOrderID
    ) AS PreviousTotalDue,
    TotalDue - LAG(TotalDue) OVER(
        ORDER BY OrderDate, SalesOrderID
    ) AS OrderDifference
FROM Sales.SalesOrderHeader
ORDER BY
    OrderDate,
    SalesOrderID;

-- 12 The sales manager wants to analyze the percentage change in order value compared with the previous order.
-- Use LAG() with ORDER BY OrderDate and SalesOrderID to retrieve the previous TotalDue.
-- Calculate the percentage difference between the current TotalDue and the previous TotalDue.
-- Return: SalesOrderID OrderDate TotalDue PreviousTotalDue OrderPercentageChange.
-- Use Sales.SalesOrderHeader. Order the final result by OrderDate, then SalesOrderID.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue,
    LAG(TotalDue) OVER(
        ORDER BY OrderDate, SalesOrderID) AS PreviousTotalDue,
    (TotalDue - LAG(TotalDue) OVER(ORDER BY OrderDate, SalesOrderID)) 
        / LAG(TotalDue) OVER(ORDER BY OrderDate, SalesOrderID)
        * 100 AS OrderPercentageChange
FROM Sales.SalesOrderHeader
ORDER BY
    OrderDate,
    SalesOrderID;

-- FIRST_VALUE()
-- 13 The production manager wants to show each product together with the highest ListPrice
-- within its ProductSubcategoryID. Use FIRST_VALUE() with PARTITION BY ProductSubcategoryID
-- and ORDER BY ListPrice DESC. Return: ProductID ProductName ProductSubcategoryID ListPrice
-- HighestSubcategoryPrice. Use Production.Product. Exclude products without a ProductSubcategoryID.
-- Order the final result by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubCategoryID,
    ListPrice,
    FIRST_VALUE(ListPrice) OVER(
    PARTITION BY ProductSubcategoryID
    ORDER BY ListPrice DESC)  AS HighestSubcategoryPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
ORDER BY 
    ProductSubcategoryID,
    ListPrice DESC;

-- LAST_VALUE()
-- 14 The production manager wants to show each product together with the lowest ListPrice
-- within its ProductSubcategoryID. Use LAST_VALUE() with PARTITION BY ProductSubcategoryID,
-- ORDER BY ListPrice DESC, and an explicit window frame using ROWS BETWEEN UNBOUNDED PRECEDING
-- AND UNBOUNDED FOLLOWING. Return: ProductID ProductName ProductSubcategoryID ListPrice
-- LowestSubcategoryPrice. Use Production.Product. Exclude products without a ProductSubcategoryID.
-- Order the final result by ProductSubcategoryID, then ListPrice DESC.

SELECT
    ProductID,
    Name AS ProductName,
    ProductSubCategoryID,
    ListPrice,
    LAST_VALUE(ListPrice) OVER(
    PARTITION BY ProductSubcategoryID
    ORDER BY ListPrice DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LowestSubcategoryPrice
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
ORDER BY 
    ProductSubcategoryID,
    ListPrice DESC;

-- 15 The sales manager wants to rank customers based on their total sales.
-- Use a CTE to calculate TotalSales for each CustomerID using SUM(TotalDue) and GROUP BY CustomerID.
-- In the outer query, use RANK() to rank customers by TotalSales DESC.
-- Return: CustomerID TotalSales SalesRank. Use Sales.SalesOrderHeader.
-- Order the final result by SalesRank, then CustomerID.

WITH CustomerSales AS
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
    RANK() OVER(
        ORDER BY TotalSales DESC
    ) AS SalesRank
FROM CustomerSales
ORDER BY SalesRank, CustomerID;

-- 16 The sales manager wants to identify how each customer's total sales compare with the average total sales across all customers.
-- Use a CTE to calculate TotalSales for each CustomerID using SUM(TotalDue) and GROUP BY CustomerID.
-- In the outer query, use AVG(TotalSales) as a window function with OVER() to calculate the overall average.
-- Return: CustomerID TotalSales AverageTotalSales DifferenceFromAverage. Use Sales.SalesOrderHeader.
-- Order by DifferenceFromAverage DESC.

WITH CustomerSales AS
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
    AVG(TotalSales) OVER() AS AverageTotalSales,
    TotalSales - AVG(TotalSales) OVER() AS DifferenceFromAverage
FROM CustomerSales
ORDER BY DifferenceFromAverage DESC;

-- 17 The production manager wants to identify the three most expensive products within each ProductSubcategoryID.
-- Use ROW_NUMBER() with PARTITION BY ProductSubcategoryID and ORDER BY ListPrice DESC.
-- Use a CTE to calculate the product ranking. Return only products with ProductRank <= 3.
-- Return: ProductID ProductName ProductSubcategoryID ListPrice ProductRank.
-- Use Production.Product. Exclude products without a ProductSubcategoryID.
-- Order the final result by ProductSubcategoryID, then ProductRank.

WITH RankedProducts AS
(
    SELECT
        ProductID,
        Name AS ProductName,
        ProductSubCategoryID,
        ListPrice,
        ROW_NUMBER() OVER(
            PARTITION BY ProductSubcategoryID
            ORDER BY ListPrice DESC
        ) AS ProductRank
    FROM Production.Product
    WHERE ProductSubcategoryID IS NOT NULL
)
SELECT
    ProductID,
    ProductName,
    ProductSubCategoryID,
    ListPrice,
    ProductRank
FROM RankedProducts
WHERE ProductRank <= 3
ORDER BY
    ProductSubcategoryID,
    ProductRank;

-- 18 The sales manager wants to identify the top 3 customers by total sales
-- within each year. Use Sales.SalesOrderHeader. Calculate total sales for each
-- CustomerID and OrderYear. Rank customers within each year based on TotalSales.
-- Return: OrderYear CustomerID TotalSales CustomerRank. Return only the top 3
-- customers for each year. Order by OrderYear, then CustomerRank.

WITH CustomerSalesByYear AS
(
    SELECT
        YEAR(OrderDate) AS OrderYear,
        CustomerID,
        SUM(TotalDue) AS TotalSales
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        CustomerID
),
RankedCustomers AS
(
    SELECT
        OrderYear,
        CustomerID,
        TotalSales,
        RANK() OVER(
            PARTITION BY OrderYear
            ORDER BY TotalSales DESC
        ) AS CustomerRank
    FROM CustomerSalesByYear
)
SELECT
    OrderYear,
    CustomerID,
    TotalSales,
    CustomerRank
FROM RankedCustomers
WHERE CustomerRank <= 3
ORDER BY
    OrderYear,
    CustomerRank;
