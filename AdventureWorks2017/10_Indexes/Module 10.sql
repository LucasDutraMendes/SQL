/*
=============================================================
Module 10 - Indexes
=============================================================

Description:
This module introduces SQL Server Indexes used to improve
query performance and optimize data access.

Topics Covered:
- Inspecting Existing Indexes
- Creating Indexes
- Clustered Indexes
- Nonclustered Indexes
- Clustered vs Nonclustered
- Execution Plans
- Estimated vs Actual Execution Plans
- Index Seek vs Index Scan
- Key Lookup
- Included Columns
- Covering Indexes
- Statistics
- Composite Indexes
- Index Column Order
- Redundant Indexes
- Dropping Indexes
- Indexing Strategies
- Practical Scenarios
- Final Challenge

Database:
- AdventureWorks2017

Exercises:
19

Author:
Lucas Dutra Mendes

=============================================================
*/

-- 1 The database administrator wants to inspect the indexes defined on Production.Product.
-- List the indexes associated with Production.Product.
-- Return: IndexName, IndexType.
-- Use sys.indexes.
-- Order the results by IndexName.

SELECT
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE object_id = OBJECT_ID('Production.Product')
  AND name IS NOT NULL
ORDER BY name;

-- 2 The production manager frequently searches for products using ProductNumber.
-- Create a nonclustered index named IX_Product_ProductNumber.
-- Create the index on Production.Product using the ProductNumber column.

CREATE NONCLUSTERED INDEX IX_Product_ProductNumber
ON Production.Product(ProductNumber);

SELECT
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE object_id = OBJECT_ID('Production.Product')
  AND name = 'IX_Product_ProductNumber';

-- 3 Inspect the indexes on Production.Product.
-- Identify which index is clustered.
-- Identify which indexes are nonclustered.
-- Then explain why Production.Product can have only one clustered index
-- but can have multiple nonclustered indexes.

SELECT
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE object_id = OBJECT_ID('Production.Product')
  AND name IS NOT NULL
ORDER BY name;

-- Answer
-- A table can have only one clustered index because the clustered index determines the physical order of the rows. 
-- In Production.Product the Primary Key ProductID is the clustered index.  
-- A nonclustered index is a separate structure that stores index keys and pointers to the actual rows. 
-- A table can have multiple nonclustered indexes.  

-- 4 The sales team frequently searches products by ListPrice.
-- Create a nonclustered index named IX_Product_ListPrice.
-- Create the index on Production.Product using the ListPrice column.
-- Then query sys.indexes to verify that the index was created.

CREATE NONCLUSTERED INDEX IX_Product_ListPrice
    ON Production.Product (ListPrice); 

-- Validating 
SELECT
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE object_id = OBJECT_ID('Production.Product')
  AND name = 'IX_Product_ListPrice'
ORDER BY name;

-- 5 Consider the two queries above.
-- For Query A, identify which existing index can support the search.
-- For Query B, identify which existing index can support the search.
-- For each query, state whether the index is clustered or nonclustered.
-- Explain why both indexes can coexist on the same table.

-- Query A
SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ProductID = 100;

-- Query B
SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ProductNumber = 'AR-5381';

-- Query A uses ProductID, which has a clustered index.
-- Query B uses ProductNumber, which has a nonclustered index.
-- Both indexes can coexist because a table can have only one clustered index but multiple nonclustered indexes.

-- 5.5 Inspect the indexes on Production.Product.
-- Identify the column associated with each index.
-- Pay special attention to the clustered index and the
-- nonclustered indexes.

SELECT
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    ic.key_ordinal AS KeyOrdinal
FROM sys.indexes i
INNER JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
INNER JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Production.Product')
  AND i.name IS NOT NULL
ORDER BY
    i.name,
    ic.key_ordinal;

-- 6 The sales team frequently searches products by ProductNumber. They also search products by ListPrice, but ProductNumber is the
-- most important lookup column.
-- Based on the current indexes on Production.Product:
-- 1. Which column should remain associated with the clustered index?
-- 2. Which columns should use nonclustered indexes?
-- 3. Explain why creating a clustered index on every frequently searched column is not possible.

-- 1 ProductID should still be associated with the Custered Index
-- 2 ListPrice and ProductNumber
-- 3 A table can have only one clustered index because the clustered index determines the physical order of the rows.

-- 7 Enable the Actual Execution Plan in SSMS.
-- Execute the query below:
-- Inspect the Execution Plan.
-- Identify which operator is used to access the data.
-- State whether the plan uses the clustered index or not. ctrl + m - to enable actual execution plan

SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ProductID = 1;

-- Operator: Clustered Index Seek
-- Index: PK_Product_ProductID
-- Type: Clustered  

-- 8 Retrieve the ProductID, Name, and ListPrice
-- from Production.Product.
-- Filter the results using ProductNumber = 'AR-5381'.
-- Enable the Actual Execution Plan before executing the query.
-- Identify the execution operator used to access the data.
-- Identify which index was used.
-- State whether the index is clustered or nonclustered.

SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ProductNumber = 'AR-5381';

-- Operator: NonClustered Index Seek
-- Index: IX_Product_ProductNumber
-- Type: NonClustered  

-- 9 Execute the query below with the Actual Execution Plan enabled.
-- Inspect the execution plan.
-- Identify the Index Seek operator.
-- Identify the Key Lookup operator.
-- Explain why SQL Server performs the Key Lookup after the Index Seek.

SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ProductNumber = 'AR-5381';

-- Index Seek: Nonclustered
-- Key Lookup: Clustered
-- The Key Lookup is performed because the nonclustered index
-- provides the ProductNumber, but the query also requests
-- additional columns that are not available in that index.

-- Included Columns
-- 10 The query below frequently searches products by ProductNumber
-- and returns Name and ListPrice.
-- Create a nonclustered index named IX_Product_ProductNumber_Covering
-- on Production.Product using ProductNumber as the index key.
-- Include Name and ListPrice as included columns.
-- Then execute the query below with the Actual Execution Plan enabled:
-- Compare the new execution plan with the previous one.
-- Identify whether the Key Lookup is still present.

CREATE NONCLUSTERED INDEX IX_Product_ProductNumber_Covering
ON Production.Product(ProductNumber)
INCLUDE (Name,ListPrice);

SELECT
   ProductID,
   Name,
   ListPrice
FROM Production.Product
WHERE ProductNumber = 'AR-5381';

-- Index Seek = NonClustered 
-- Index = IX_Product_ProductNumber_Covering
-- Type = NonClustered 
-- SQL Server used only the new nonclustered index to query the select above

-- 11 Enable the Actual Execution Plan.
-- Execute the query below and Inspect the Execution Plan.
-- Identify whether SQL Server uses an Index Seek or an Index Scan.
-- Identify which index or table structure is being accessed.
-- Explain why SQL Server may choose this access method for this query.

SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice >= 1;

-- Index Scan
-- Index: IX_Product_ProductNumber_Covering
-- Type: Nonclustered
-- SQL Server may choose an Index Scan because the predicate
-- matches a large portion of the rows, making a Seek less selective.
-- The selected nonclustered index also covers the columns required
-- by the query, making the scan relatively efficient.

-- 12 Enable the Actual Execution Plan.
-- Execute the query below Inspect the Execution Plan.
-- Identify whether SQL Server uses an Index Seek or an Index Scan.
-- Identify which index is being accessed.
-- Compare this execution plan with Exercise 11.
-- Explain how the selectivity of the predicate may affect the
-- access method chosen by SQL Server.

SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice = 3578.27;

-- Index Scan
-- Index: IX_Product_ProductNumber_Covering
-- Type: Nonclustered
-- Explanation:
-- An equality filter does not guarantee an Index Seek.
-- SQL Server chooses the access method based on estimated cost.
-- In this case, scanning the covering nonclustered index was considered cheaper.

-- 13 Generate the Estimated Execution Plan for the query below.
-- Do not execute the query yet.
-- Identify:
-- 1. The access operator.
-- 2. The estimated number of rows.
-- Then execute the query with the Actual Execution Plan enabled.
-- Compare the estimated and actual number of rows.
-- Explain whether the optimizer estimated the row count accurately.

SELECT
    SalesOrderID,
    ProductID,
    OrderQty,
    UnitPrice
FROM Sales.SalesOrderDetail
WHERE ProductID = 707;

-- Estimated: Nonclustered Index Scan
-- Actual: Clustered Index Scan
-- Estimated Rows: many
-- Actual Rows: 3083
-- The optimizer significantly underestimated the number of rows.
-- This can lead to a less efficient execution plan.

-- 14 Inspect the statistics associated with ProductID
-- on Sales.SalesOrderDetail.
-- Identify:
-- 1. The total number of rows = 121317
-- 2. The number of rows sampled = 121317
-- 3. The number of histogram steps = 200
-- 4. Explain in one sentence how this information
--    helps the Query Optimizer estimate row counts = Statistics provide information about the data distribution,
-- helping the Query Optimizer estimate how many rows a query may return.

DBCC SHOW_STATISTICS
(
    'Sales.SalesOrderDetail',
    'IX_SalesOrderDetail_ProductID'
)
WITH STAT_HEADER, HISTOGRAM;

-- 15 Inspect the indexes on Production.Product.
-- Identify the indexes that use ProductNumber as an index key.
-- Compare their key columns and included columns.
-- Determine whether any indexes are redundant.
-- Explain why redundant indexes can increase storage usage
-- and the maintenance cost of INSERT, UPDATE, and DELETE operations.

-- ProductNumber has multiple overlapping indexes.
-- IX_Product_ProductNumber is redundant for learning purposes.
-- IX_Product_ProductNumber_Covering is different because it includes
-- additional columns used by queries.
-- AK_Product_ProductNumber should not be treated as simply redundant
-- because it also enforces uniqueness.
-- Redundant indexes increase storage usage and maintenance overhead.

SELECT
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    ic.key_ordinal,
    ic.is_included_column
FROM sys.indexes i
INNER JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
INNER JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Production.Product')
  AND i.name IS NOT NULL
ORDER BY
    i.name,
    ic.key_ordinal,
    ic.is_included_column;

-- Composite Index
-- 16 The production team frequently searches products by Name
-- and sometimes filters those products by ListPrice.
-- Create a nonclustered composite index named
-- IX_Product_Name_ListPrice.
-- Use Name as the first key column
-- and ListPrice as the second key column.
-- Then inspect the index and verify the key column order.

CREATE NONCLUSTERED INDEX IX_Product_Name_ListPrice
ON Production.Product(Name,ListPrice);

SELECT
    i.name AS IndexName,
    c.name AS ColumnName,
    ic.key_ordinal
FROM sys.indexes i
INNER JOIN sys.index_columns ic
    ON i.object_id = ic.object_id
    AND i.index_id = ic.index_id
INNER JOIN sys.columns c
    ON ic.object_id = c.object_id
    AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('Production.Product')
  AND i.name = 'IX_Product_Name_ListPrice'
ORDER BY ic.key_ordinal;

-- 17 Use the Actual Execution Plan.
-- Execute both queries below.
-- Query 1:
-- Search products using Name and ListPrice.

-- Query 2:
-- Search products using ListPrice only.

-- Compare the execution plans.
-- Identify whether the composite index
-- IX_Product_Name_ListPrice is used by both queries.
-- Explain how the position of Name and ListPrice
-- in the index affects its usefulness.

-- Query 1
SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE Name = 'Bearing Ball'
  AND ListPrice = 1.00;

-- Query 2
SELECT
    ProductID,
    Name,
    ListPrice
FROM Production.Product
WHERE ListPrice = 1.00;

-- Query 1: Index Seek
-- The query filters on the first key column (Name),
-- allowing SQL Server to seek into the composite index.

-- Query 2: Index Scan
-- The query filters only on ListPrice, which is the second key column.
-- Because Name is the leading key, SQL Server cannot seek directly by ListPrice.

-- 18 The index IX_Product_ProductNumber was created for learning purposes
-- and is no longer required.
-- Remove the index from Production.Product.
-- Then query sys.indexes to verify that the index was removed.

DROP INDEX IX_Product_ProductNumber
ON Production.Product;

-- 19 The sales system frequently searches Sales.SalesOrderDetail by ProductID.
-- The following query is executed frequently:

-- Design and implement an index strategy for this query.

-- 1. Decide whether a nonclustered index should be created.
-- 2. Use ProductID as the index key.
-- 3. Decide which additional columns, if any, should be included.
-- 4. Create the index.
-- 5. Execute the query with the Actual Execution Plan enabled.
-- 6. Check whether the Key Lookup is eliminated.
-- 7. Explain why your index design is appropriate for this workload.

-- Query
SELECT
    SalesOrderID,
    ProductID,
    OrderQty,
    UnitPrice
FROM Sales.SalesOrderDetail
WHERE ProductID = 707;

CREATE NONCLUSTERED INDEX IX_Sales_Order
ON Sales.SalesOrderDetail(ProductID)
INCLUDE (SalesOrderID, OrderQty, UnitPrice);
