/*
=============================================================
Module 09 - Stored Procedures
=============================================================

Description:
This module introduces SQL Stored Procedures used to create
reusable and executable database programs.

Topics Covered:
- CREATE PROCEDURE
- Executing Stored Procedures
- Input Parameters
- Multiple Parameters
- Filtering with Parameters
- Variables
- IF / ELSE
- CASE
- OUTPUT Parameters
- RETURN Values
- ALTER PROCEDURE
- DROP PROCEDURE
- INSERT
- UPDATE
- Transactions
- Practical Scenarios
- System Catalogs
- Final Challenge

Database:
- AdventureWorks2017

Exercises:
20

Author:
Lucas Dutra Mendes

=============================================================
*/

-- 1 The production manager wants a reusable procedure that returns basic product information.
-- Create a stored procedure named GetProductList.
-- Use Production.Product.
-- Return: ProductID, Name AS ProductName, ProductNumber, ListPrice.
-- After creating the procedure, execute it using EXEC.

CREATE PROCEDURE GetProductList AS
SELECT
	ProductID,
	Name AS ProductName,
	ProductNumber,
	ListPrice
FROM Production.Product; 

EXEC GetProductList;

-- 2 The production manager wants to reuse the GetProductList procedure for different reporting needs.
-- Execute the GetProductList procedure.
-- Store the returned result in your understanding as the procedure output.
-- No modifications to the procedure are required.

EXEC GetProductList;

-- 3 The production manager wants to search for products above a minimum price.
-- Create a stored procedure named GetProductsByMinPrice.
-- Add an input parameter named @MinPrice.
-- Use Production.Product.
-- Return: ProductID, Name AS ProductName, ProductNumber, ListPrice.
-- Return only products whose ListPrice is greater than or equal to @MinPrice.
-- Execute the procedure using a minimum price of 1000.

CREATE PROCEDURE GetProductsByMinPrice 
	@MinPrice MONEY
AS
SELECT
	ProductID,
	Name AS ProductName,
	ProductNumber,
	ListPrice
FROM Production.Product
WHERE ListPrice >= @MinPrice;

EXEC GetProductsByMinPrice @MinPrice = 1000;

-- 4 The production manager wants to search for products within a price range.
-- Create a stored procedure named GetProductsByPriceRange.
-- Add two input parameters: @MinPrice and @MaxPrice.
-- Use Production.Product.
-- Return: ProductID, Name AS ProductName, ProductNumber, ListPrice.
-- Return only products whose ListPrice is between @MinPrice and @MaxPrice.
-- Execute the procedure using a minimum price of 100 and a maximum price of 500.

CREATE PROCEDURE GetProductsByPriceRange
	@MinPrice MONEY, @MaxPrice MONEY AS
SELECT
	ProductID,
	Name AS ProductName,
	ProductNumber,
	ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN @MinPrice AND @MaxPrice;

EXEC GetProductsByPriceRange 
@MinPrice = 100,
@MaxPrice = 500;

-- 5 The sales manager wants to retrieve all orders for a specific customer.
-- Create a stored procedure named GetCustomerOrders.
-- Add an input parameter named @CustomerID with type INT.
-- Use Sales.SalesOrderHeader.
-- Return: SalesOrderID, OrderDate, TotalDue.
-- Return only orders belonging to the customer specified by @CustomerID.
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE GetCustomerOrders 
	@CustomerID INT AS
SELECT
	SalesOrderID,
	OrderDate,
	TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = @CustomerID; 

EXEC GetCustomerOrders @CustomerID = 11000;

-- 6 The sales manager wants a procedure that calculates the total sales for a specific customer.
-- Create a stored procedure named GetCustomerTotalSales.
-- Add an input parameter named @CustomerID with type INT.
-- Declare a variable named @TotalSales with type MONEY.
-- Store the customer's total sales in @TotalSales using SUM(TotalDue).
-- Return CustomerID and TotalSales.
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE GetCustomerTotalSales
	@CustomerID INT AS
BEGIN
	DECLARE @TotalSales MONEY;

	SELECT
		@TotalSales = SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;

	SELECT
		@CustomerID AS CustomerID,
		@TotalSales AS TotalSales;
END;

EXEC GetCustomerTotalSales @CustomerID = 11000;

-- 7 The sales manager wants to evaluate the sales level of a specific customer.
-- Create a stored procedure named EvaluateCustomerSales.
-- Add an input parameter named @CustomerID with type INT.
-- Declare a variable named @TotalSales with type MONEY.
-- Calculate the customer's total sales using SUM(TotalDue) and store the result in @TotalSales.
-- Use IF / ELSE to classify the customer:
--   TotalSales >= 50000 → 'High'
--   Otherwise → 'Low'
-- Return CustomerID, TotalSales, and SalesCategory.
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE EvaluateCustomerSales
	@CustomerID INT AS
BEGIN
	DECLARE @TotalSales MONEY;

	SELECT
		@TotalSales = SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;

	IF @TotalSales >= 50000
	BEGIN
        SELECT
            @CustomerID AS CustomerID,
            @TotalSales AS TotalSales,
            'High' AS SalesCategory;
	END
	ELSE
	BEGIN
        SELECT
            @CustomerID AS CustomerID,
            @TotalSales AS TotalSales,
            'Low' AS SalesCategory;
	END;
END;

EXEC EvaluateCustomerSales @CustomerID = 11000;

-- 8 The sales manager wants to classify a specific customer based on total sales.
-- Create a stored procedure named EvaluateCustomerSalesCase.
-- Add an input parameter named @CustomerID with type INT.
-- Declare a variable named @TotalSales with type MONEY.
-- Calculate the customer's total sales using SUM(TotalDue) and store the result in @TotalSales.
-- Return CustomerID, TotalSales, and SalesCategory.
-- Use CASE to classify the customer:
--   TotalSales >= 50000 → 'High'
--   TotalSales >= 10000 → 'Medium'
--   Otherwise → 'Low'
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE EvaluateCustomerSalesCase
	@CustomerID INT AS
BEGIN
	DECLARE @TotalSales MONEY;

	SELECT
		@TotalSales = SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;

	SELECT
		@CustomerID AS CustomerID,
		@TotalSales AS TotalSales,
		CASE
		    WHEN @TotalSales >= 50000 THEN 'High'
            WHEN @TotalSales >= 10000 THEN 'Medium'
            ELSE 'Low'
		END AS SalesCategory;
END;

EXEC EvaluateCustomerSalesCase @CustomerID = 11000;

-- 9 The sales manager wants to retrieve the total sales of a specific customer through an OUTPUT parameter.
-- Create a stored procedure named GetCustomerTotalSalesOutput.
-- Add an input parameter named @CustomerID with type INT.
-- Add an OUTPUT parameter named @TotalSales with type MONEY.
-- Calculate the customer's total sales using SUM(TotalDue).
-- Store the result in @TotalSales.
-- Execute the procedure using CustomerID = 11000.
-- Store the returned value in a local variable named @Sales.
-- Display @Sales after executing the procedure.

CREATE PROCEDURE GetCustomerTotalSalesOutPut
	@CustomerID INT,
	@TotalSales MONEY OUTPUT
AS
BEGIN
	SELECT
		@TotalSales = SUM(TotalDue)		
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;
END;

DECLARE @Sales MONEY;

EXEC GetCustomerTotalSalesOutPut
    @CustomerID = 11000,
    @TotalSales = @Sales OUTPUT;

SELECT @Sales AS TotalSales;

-- 10 The sales manager wants to verify whether a specific customer exists.
-- Create a stored procedure named CheckCustomer.
-- Add an input parameter named @CustomerID with type INT.
-- Check whether the customer exists in Sales.Customer.
-- Return 1 if the customer exists.
-- Return 0 if the customer does not exist.
-- Execute the procedure using CustomerID = 11000.
-- Capture the returned value in a variable named @Result.
-- Display @Result.

CREATE PROCEDURE CheckCustomer 
	@CustomerID INT AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM Sales.Customer
	    WHERE CustomerID = @CustomerID)
	BEGIN
		RETURN 1;
	END
	ELSE
	BEGIN
		RETURN 0;
	END;
END;

DECLARE @Result INT;

EXEC @Result = CheckCustomer
	@CustomerID = 11000;

SELECT @Result AS Result;

-- 11 The sales manager wants to modify the status codes returned by the CheckCustomer procedure.
-- Alter the existing CheckCustomer procedure.
-- Keep the same @CustomerID parameter and customer existence check.
-- Change the return values:
--   11 if the customer exists.
--   00 if the customer does not exist.
-- Execute the procedure using CustomerID = 11000 and capture the result in @Result.

ALTER PROCEDURE CheckCustomer 
	@CustomerID INT AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM Sales.Customer
	    WHERE CustomerID = @CustomerID)
	BEGIN
		RETURN 11;
	END
	ELSE
	BEGIN
		RETURN 00;
	END;
END;

DECLARE @Result INT;

EXEC @Result = CheckCustomer
	@CustomerID = 11000;

SELECT @Result AS Result;

-- 12 The sales manager wants the CheckCustomer procedure to return a text-based status.
-- Alter the existing CheckCustomer procedure.
-- Keep the @CustomerID input parameter.
-- Add an OUTPUT parameter named @Result with type CHAR(1).
-- Return 'T' if the customer exists.
-- Return 'F' if the customer does not exist.
-- Do not use RETURN to provide the result.
-- Use the OUTPUT parameter instead.
-- Execute the procedure using CustomerID = 11000.
-- Store the returned value in a local variable named @CustomerResult.
-- Display @CustomerResult.

ALTER PROCEDURE CheckCustomer
    @CustomerID INT,
    @Result CHAR(1) OUTPUT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Sales.Customer
        WHERE CustomerID = @CustomerID
    )
    BEGIN
        SET @Result = 'T';
    END
    ELSE
    BEGIN
        SET @Result = 'F';
    END;
END;

DECLARE @CustomerResult CHAR(1);

EXEC CheckCustomer
    @CustomerID = 11000,
    @Result = @CustomerResult OUTPUT;

SELECT @CustomerResult AS Result;

-- 13 The sales manager no longer needs the GetProductList procedure.
-- Drop the existing GetProductList procedure.
-- After dropping it, attempt to execute the procedure to confirm that it no longer exists.

DROP PROCEDURE GetProductList;

EXEC GetProductList;

-- 14 The sales team wants a procedure to register a new customer.
-- Create a stored procedure named AddCustomer.
-- Add an input parameter named @TerritoryID with type INT.
-- Add an input parameter named @PersonID with type INT.
-- Insert a new row into Sales.Customer.
-- Insert values into PersonID and TerritoryID.
-- Leave StoreID as NULL.
-- Execute the procedure using TerritoryID = 1 and PersonID = NULL.

CREATE PROCEDURE AddCustomer
	@TerritoryID INT,
	@PersonID INT AS
BEGIN
	INSERT INTO Sales.Customer
	(
		PersonID,
		TerritoryID
	)
	VALUES
	(
		@PersonID,
		@TerritoryID
	);
END;

EXEC AddCustomer
	@TerritoryID = 1,
	@PersonID    = NULL;

SELECT TOP 1 *
FROM Sales.Customer
ORDER BY CustomerID DESC;

-- 15 The sales manager wants a procedure to update the sales territory of a customer.
-- Create a stored procedure named UpdateCustomerTerritory.
-- Add an input parameter named @CustomerID with type INT.
-- Add an input parameter named @TerritoryID with type INT.
-- Update Sales.Customer.
-- Set TerritoryID to the value provided by @TerritoryID.
-- Update only the customer specified by @CustomerID.
-- Execute the procedure using CustomerID = 30119 and TerritoryID = 2.

CREATE PROCEDURE UpdateCustomerTerritory
	@CustomerID INT,
	@TerritoryID INT AS
BEGIN
	UPDATE Sales.Customer
	SET TerritoryID = @TerritoryID
	WHERE CustomerID = @CustomerID;
END;

EXEC UpdateCustomerTerritory
	@CustomerID = 30119,
	@TerritoryID = 2; 

-- 16 The sales manager wants to update a customer's territory using a transaction.
-- Create a stored procedure named UpdateCustomerTerritoryTransactional.
-- Add an input parameter named @CustomerID with type INT.
-- Add an input parameter named @TerritoryID with type INT.
-- Begin a transaction.
-- Update Sales.Customer using the provided CustomerID and TerritoryID.
-- Commit the transaction.
-- Execute the procedure using CustomerID = 30119 and TerritoryID = 3.
-- Verify that the customer's TerritoryID was updated.

CREATE PROCEDURE UpdateCustomerTerritoryTransactional
	@CustomerID INT,
	@TerritoryID INT AS
BEGIN
	BEGIN TRANSACTION;
		UPDATE Sales.Customer
		SET TerritoryID = @TerritoryID
		WHERE CustomerID = @CustomerID;
	COMMIT;
END;

EXEC UpdateCustomerTerritoryTransactional
	@CustomerID = 30119,
	@TerritoryID = 3;

-- 17 The sales manager wants a reusable procedure to retrieve customer order information.
-- Create a stored procedure named GetCustomerOrderSummary.
-- Add an input parameter named @CustomerID with type INT.
-- Return:
--   CustomerID
--   AccountNumber
--   TotalOrders
--   TotalSales
--   AverageOrderValue
-- Use Sales.Customer and Sales.SalesOrderHeader.
-- Calculate TotalOrders using COUNT().
-- Calculate TotalSales using SUM(TotalDue).
-- Calculate AverageOrderValue using TotalSales / TotalOrders.
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE GetCustomerOrderSummary
	@CustomerID INT AS
BEGIN
	DECLARE @TotalOrders INT,
	        @TotalSales MONEY; 
	
	SELECT
		@TotalOrders = COUNT(*),
		@TotalSales =  SUM(TotalDue)
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;

	SELECT
		sc.CustomerID,
		sc.AccountNumber,
		@TotalOrders AS TotalOrders,
        @TotalSales AS TotalSales,
        @TotalSales / @TotalOrders AS AverageOrderValue
	FROM Sales.Customer AS sc
	WHERE CustomerID = @CustomerID;
END;

EXEC GetCustomerOrderSummary
	@CustomerID = 11000;

SELECT TOP 1 * FROM Sales.SalesOrderHeader

-- 18 Do the exercise 17 using JOIN

CREATE PROCEDURE GetCustomerOrderSummary2
    @CustomerID INT
AS
BEGIN
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        COUNT(*) AS TotalOrders,
        SUM(ss.TotalDue) AS TotalSales,
        SUM(ss.TotalDue) / COUNT(*) AS AverageOrderValue
    FROM Sales.Customer AS sc
    INNER JOIN Sales.SalesOrderHeader AS ss
        ON ss.CustomerID = sc.CustomerID
    WHERE sc.CustomerID = @CustomerID
    GROUP BY
        sc.CustomerID,
        sc.AccountNumber;
END;

EXEC GetCustomerOrderSummary2
    @CustomerID = 11000;

-- 19 Extra - List Stored Procedures and their definitions

SELECT TOP (1) * FROM sys.procedures;

SELECT TOP (1) * FROM sys.sql_modules;

SELECT
    p.name AS ProcedureName,
    m.definition AS ProcedureDefinition
FROM sys.procedures AS p
INNER JOIN sys.sql_modules AS m
    ON p.object_id = m.object_id
ORDER BY p.name;

-- 20 Final Challenge
-- The sales manager wants a stored procedure to evaluate a customer's sales performance.
-- Create a stored procedure named EvaluateCustomerPerformance.
-- Add an input parameter named @CustomerID with type INT.
-- Calculate:
--   TotalOrders
--   TotalSales
--   AverageOrderValue
-- Return:
--   CustomerID
--   TotalOrders
--   TotalSales
--   AverageOrderValue
--   SalesCategory
-- Classify the customer:
--   TotalSales >= 50000 → 'High'
--   TotalSales >= 10000 → 'Medium'
--   Otherwise → 'Low'
-- Use the customer specified by @CustomerID.
-- Execute the procedure using CustomerID = 11000.

CREATE PROCEDURE EvaluateCustomerPerformance
	@CustomerID INT AS
BEGIN
    SELECT
        sc.CustomerID,
        sc.AccountNumber,
        COUNT(*) AS TotalOrders,
        SUM(ss.TotalDue) AS TotalSales,
        SUM(ss.TotalDue) / COUNT(*) AS AverageOrderValue,
		CASE
			WHEN SUM(ss.TotalDue) >= 50000 THEN 'High'
			WHEN SUM(ss.TotalDue) >= 10000 THEN 'Medium'
			ELSE 'Low'
		END AS SalesCategory
    FROM Sales.Customer AS sc
    INNER JOIN Sales.SalesOrderHeader AS ss
        ON ss.CustomerID = sc.CustomerID
    WHERE sc.CustomerID = @CustomerID
    GROUP BY
        sc.CustomerID,
        sc.AccountNumber;
END;

EXEC EvaluateCustomerPerformance
    @CustomerID = 11000;