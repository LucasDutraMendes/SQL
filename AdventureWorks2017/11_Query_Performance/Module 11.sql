/*
=============================================================
Module 11 - Query Performance
=============================================================

Description:
This module introduces SQL Server query performance analysis
and optimization using the AdventureWorks2017 sample database.

Topics Covered:
- Measuring Query Performance
- STATISTICS IO and STATISTICS TIME
- Logical and Physical Reads
- Actual Execution Plans
- Index Seek vs Index Scan
- Key Lookup
- SARGable vs Non-SARGable Predicates
- Estimated vs Actual Execution Plans
- Estimated Execution Costs
- Missing Index Recommendations
- Column Selection and SELECT *
- Sort Operator
- TOP and Sorting
- Join Operators
- Nested Loops
- Merge Join
- Hash Match
- Query Rewriting and Optimization
- Performance Measurement and Comparison
- Final Challenge

Database:
- AdventureWorks2017

Exercises:
18

Author:
Lucas Dutra Mendes

=============================================================
*/

-- 1 The sales team wants to measure the performance of a query that retrieves orders for a specific customer.
-- Enable STATISTICS IO and STATISTICS TIME.
-- Execute the query below.
-- Inspect the Messages tab.
-- Record the logical reads, CPU time, and elapsed time.
-- Disable STATISTICS IO and STATISTICS TIME after execution.

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;

/* Logical reads = 11
CPU Time = 0 ms
Elapsed Time = 16 ms    */
--------------------------------------------------------------------------------------------------------------

-- 2 Analyze the Actual Execution Plan for the query below. Identify the access operator used to retrieve the data.
-- Identify the index or table structure being accessed. 
-- Check whether a Key Lookup occurs.   
-- Explain how the execution plan helps you understand the logical reads recorded in Exercise 1. 
-- while STATISTICS IO and STATISTICS TIME report the logical reads and execution times

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

SET STATISTICS IO, TIME OFF;

/* Operator: Nonclustered Index Seek
Key Lookup: Clustered
The nonclustered index helps SQL Server find rows for CustomerID = 11000.
The clustered Key Lookup retrieves additional columns not available
in the nonclustered index.
The execution plan shows the access path, while STATISTICS IO and STATISTICS TIME report the logical reads and execution times.    */
--------------------------------------------------------------------------------------------------------------

-- 3 The sales team wants to analyze orders placed from January 1, 2013 onward.
-- Enable STATISTICS IO and STATISTICS TIME.
-- Execute the query below.
-- Record the number of rows returned, logical reads, CPU time,
-- and elapsed time.
-- Compare the results with Exercise 1.
-- Explain the differences in the measured performance.

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01';

SET STATISTICS IO, TIME OFF;

/* Rows returned: 25943 rows
Logical reads: 689
CPU time: 31 ms
Elapsed time: 100 ms   
The query returned significantly more rows and performed more logical reads.
CPU time and elapsed time also increased, reflecting the greater amount of work performed. Execution times may vary between runs.   */
--------------------------------------------------------------------------------------------------------------

-- 4 Enable the Actual Execution Plan.
-- Execute the query below.
-- Identify the access operator used by SQL Server.
-- Identify the index or table structure being accessed.
-- Explain how the access method relates to the 689 logical reads.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01';

/* Operator: Clustered Index Scan
Index: [PK_SalesOrderHeader]
The query returns many rows, so scanning the clustered index may be more efficient than seeking individual rows.
The scan accesses the table's data pages to evaluate the predicate.    */
--------------------------------------------------------------------------------------------------------------

-- 5 The sales team only needs the SalesOrderID values for a specific customer.
-- Enable STATISTICS IO and STATISTICS TIME.
-- Execute the query below with the Actual Execution Plan enabled.
-- Identify the access operator and the index being used.
-- Check whether a Key Lookup occurs.
-- Record the logical reads and compare them with Exercise 1.
-- Explain why selecting fewer columns may reduce data access operations.

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

SET STATISTICS IO, TIME OFF;

/* Access Operator: Nonclustered Index Seek
NonClustered Index
Key Lookup: Not present
Logical Reads: 2
CPU Time: 0 ms
Elapsed Time: 4 ms
Selecting fewer columns may reduce data access operations. In this case, the nonclustered index covers the query,
avoiding a Key Lookup and reducing logical reads from 11 to 2.         */
--------------------------------------------------------------------------------------------------------------

-- 6 Compare a SARGable predicate with a non-SARGable predicate. Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute both queries below. Record the access operator and logical reads for each query.
-- Compare the execution plans and performance metrics. Explain how applying a function to an indexed column
-- may affect index usage.

SET STATISTICS IO, TIME ON;

-- Query A: SARGable predicate

SELECT
    SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

-- Query B: Non-SARGable predicate
SELECT
    SalesOrderID
FROM Sales.SalesOrderHeader
WHERE CAST(CustomerID AS VARCHAR(10)) = '11000';

SET STATISTICS IO, TIME OFF;

/* Query A:
Operator: Index Seek
Logical reads: 2

Query B:
Operator: Index Scan
Logical reads: 57       
Applying CAST to the indexed column makes the predicate non-SARGable, preventing an efficient Index Seek in this case.
The Index Scan resulted in more logical reads.    */
--------------------------------------------------------------------------------------------------------------

-- 7 Compare two queries that retrieve orders placed during 2013.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute both queries and record the access operator and logical reads.
-- Compare the execution plans and explain the results.

SET STATISTICS IO, TIME ON;

-- Query A: Non-SARGable
SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013;

-- Query B: SARGable
SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101'
  AND OrderDate < '20140101';

SET STATISTICS IO, TIME OFF;

/* Query A:
Operator: Index Scan
Logical reads: 689
Elapsed Time: 67 ms
CPU Time: 0 ms

Query B:
Operator: Index Scan
Logical reads: 689
Elapsed Time: 72 ms
CPU Time: 0 ms

Query A applies YEAR() to OrderDate, making the predicate non-SARGable.
Query B uses a SARGable date range.
However, SQL Server chose an Index Scan for both queries.
Logical reads were identical, and the elapsed-time slightly different
is not sufficient to conclude that either query is faster.
A SARGable predicate does not guarantee an Index Seek.          */
--------------------------------------------------------------------------------------------------------------

-- 8 Analyze the Estimated and Actual Execution Plans.
-- Generate the Estimated Execution Plan before executing the query.
-- Then execute the query with the Actual Execution Plan enabled.
-- Identify the access operator.
-- Record the estimated and actual number of rows.
-- Compare the estimates with the actual results.
-- Explain why differences between estimated and actual rows
-- may affect query performance.

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101'
  AND OrderDate < '20140101';

SET STATISTICS IO, TIME OFF;

/* Access Operator: Clustered Index Scan

Clustered Index Scan:
Estimated Rows: 31465
Actual Rows: 31465

Filter:
Estimated Rows: 14182
Actual Rows: 14179
Difference: 3 rows

The Clustered Index Scan processed 31,465 rows.
The Filter estimated that 14,182 rows would match the date range,
but 14,179 rows actually matched.
The difference of 3 rows represents a small estimation error.
Differences between estimated and actual row counts can affect
the execution plan chosen by the Query Optimizer. */
--------------------------------------------------------------------------------------------------------------

-- 9 Inspect the properties of the Clustered Index Scan
-- in the execution plan from Exercise 8.
-- Identify the Estimated I/O Cost, Estimated CPU Cost,
-- and Estimated Subtree Cost.
-- Explain why the operator's cost percentage does not
-- represent its actual execution time.

/*
Estimated I/O Cost: 0.509792
Estimated CPU Cost: 0.034768
Estimated Subtree Cost: 0.54456
Estimated costs are optimizer estimates, not actual execution times.
They help compare alternative execution plans, while STATISTICS TIME
reports the actual CPU and elapsed times measured during execution.           */
--------------------------------------------------------------------------------------------------------------

-- 10 Analyze the execution plan for the query below.
-- Identify whether SQL Server displays a Missing Index recommendation.
-- Identify the suggested key column and included columns.
-- Explain why a Missing Index recommendation should be evaluated
-- before implementing it.

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '20130101'
  AND OrderDate < '20140101';

--Missing Index Recommendation: Create a nonclustered index on OrderDate and include TotalDue
--Key column: OrderDate
--Included columns: TotalDue
--Estimated impact: 94.0824

/* Conclusion:
SQL Server recommends a nonclustered index on OrderDate
with TotalDue as an included column. This index may improve
date-based queries, but the recommendation must be evaluated
against the overall workload and index maintenance costs.                 */
--------------------------------------------------------------------------------------------------------------

-- 11 The sales team only needs three columns from SalesOrderHeader.
-- Compare a query that selects specific columns with a query
-- that uses SELECT *.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute both queries using the same filter.
-- Record the logical reads and identify the access operators.
-- Check whether a Key Lookup occurs.
-- Explain why selecting only the required columns can improve performance.

SET STATISTICS IO, TIME ON;

-- Query A: Select only the required columns
SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

-- Query B: Select all columns
SELECT *
FROM Sales.SalesOrderHeader
WHERE CustomerID = 11000;

SET STATISTICS IO, TIME OFF;

/* Query A:
Operator: Index Seek
Logical reads: 11
Key Lookup: Clustered

Query B:
Operator: Index Seek
Logical reads: 11
Key Lookup: Clustered

Conclusion:
Both queries used an Index Seek followed by a Clustered Key Lookup.
Logical reads were identical because both queries accessed the same
number of pages in this execution.
SELECT * retrieves additional columns and may increase data transfer
and processing costs, even when logical reads remain unchanged.                          */
--------------------------------------------------------------------------------------------------------------

-- 12 The sales team wants to retrieve orders sorted by TotalDue
-- in descending order. Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below. Identify the Sort operator, if present.
-- Identify the access operator used to retrieve the data.
-- Record the logical reads, CPU time, and elapsed time.
-- Explain why sorting may add processing work to a query.

SET STATISTICS IO, TIME ON;

SELECT
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

SET STATISTICS IO, TIME OFF;

/* Access Operator: Clustered Index Scan
Sort Operator: Yes
Rows Sorted: 31465
Logical reads: 689
CPU time: 31 ms
Elapsed time: 148 ms
Conclusion: The Sort operator orders the 31,465 rows by TotalDue in descending order.
Sorting adds processing work because the clustered index does not provide
the requested order. The execution time includes this additional work.           */
--------------------------------------------------------------------------------------------------------------

-- 13 The sales team only needs the 10 orders with the highest TotalDue.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below.
-- Identify the access operator and the Sort operator.
-- Record the number of rows returned, logical reads, CPU time,
-- and elapsed time.
-- Compare the results with Exercise 12.
-- Explain how TOP affects the number of rows returned and
-- the work required to sort them.

SET STATISTICS IO, TIME ON;

SELECT TOP (10)
    SalesOrderID,
    OrderDate,
    TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

SET STATISTICS IO, TIME OFF;

/* Access Operator: Clustered Index Scan
Sort Operator: Yes
Rows Returned: 10
Logical Reads: 689
CPU Time: 0 ms
Elapsed Time: 26 ms
Conclusion: TOP (10) limits the number of rows returned, but SQL Server
still scans the data to identify the 10 highest TotalDue values.
Logical reads remain at 689 because the chosen access path
does not provide the requested order. The Sort operation
remains necessary, but the query returns fewer rows                   */
--------------------------------------------------------------------------------------------------------------

-- 14 The sales team wants to retrieve the products included in a customer's orders.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below.
-- Identify the join operator used by SQL Server.
-- Identify the access operators used for each table.
-- Record the logical reads, CPU time, and elapsed time.
-- Explain why SQL Server may choose this join strategy.

SET STATISTICS IO, TIME ON;

SELECT
    h.SalesOrderID,
    h.OrderDate,
    d.ProductID,
    d.OrderQty
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID
WHERE h.CustomerID = 11000;

SET STATISTICS IO, TIME OFF;

/* Join Operator: Nested Loops (Inner Join)
SalesOrderHeader:
Access Operators: Nonclustered Index Seek + Clustered Key Lookup
Logical Reads: 11
Physical Reads: 0

SalesOrderDetail:
Access Operator: Clustered Index Seek
Scan Count: 3
Logical Reads: 10
Physical Reads: 8   
Conclusion: SQL Server used Nested Loops to combine the three orders
with their corresponding order details. Index seeks located the related records, while the Key Lookup retrieved additional order information.   */
--------------------------------------------------------------------------------------------------------------

-- 15 The sales team wants to retrieve all orders and their corresponding order details.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below.
-- Identify the join operator used by SQL Server.
-- Identify the access operators used for each table.
-- Record the number of rows returned, logical reads, CPU time,
-- and elapsed time.
-- Compare the results with Exercise 14.
-- Explain how processing a larger dataset can affect the join strategy
-- and query performance.

SET STATISTICS IO, TIME ON;

SELECT
    h.SalesOrderID,
    h.OrderDate,
    d.ProductID,
    d.OrderQty
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID;

SET STATISTICS IO, TIME OFF;

/* Join Operator: Merge Join
SalesOrderHeader Access Operator: Clustered Index Scan
SalesOrderDetail Access Operator: Clustered Index Scan
Rows Returned: 121317
Logical Reads: SalesOrderDetail = 1248 - SalesOrderHeader = 689
CPU Time: 156 ms
Elapsed Time: 347 ms
Conclusion: SQL Server used a Merge Join to combine all orders with their corresponding order details. Both tables were accessed through 
Clustered Index Scans. The larger result set required more logical reads and processing time than the filtered query in Exercise 14.
Merge Join was suitable because the inputs were ordered by the join key                    */
--------------------------------------------------------------------------------------------------------------

-- 16 The sales team wants to retrieve customer information together with the associated person's first and last names.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below.
-- Identify the join operator selected by SQL Server.
-- Identify the access operators used for each table.
-- Record the number of rows returned, logical reads, CPU time,
-- and elapsed time.
-- Compare the join strategy with Exercises 14 and 15.
-- Explain why SQL Server may choose this join strategy.

SET STATISTICS IO, TIME ON;

SELECT
    c.CustomerID,
    c.PersonID,
    p.FirstName,
    p.LastName
FROM Sales.Customer AS c
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID;

SET STATISTICS IO, TIME OFF;

/* Join Operator: Hash Match
Sales.Customer Access Operator: Clustered Index Scan
Person.Person Access Operator: NonClustered Index Scan
Rows Returned:19119
Logical Reads: Person = 107 - Customer = 123
CPU Time: 62 ms
Elapsed Time: 116 ms
Conclusion:SQL Server used Hash Match to join Sales.Customer and Person.Person.
The input data was accessed through index scans. Hash Match builds
a hash structure on one input and uses it to find matching rows from the other input. It can be effective when the inputs are not
already ordered for a Merge Join.                          */
--------------------------------------------------------------------------------------------------------------

-- 17 The sales team wants to retrieve the 10 highest-value orders
-- placed in 2013, including the customer's name.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Execute the query below.
-- Identify the join operators and access operators.
-- Check whether a Sort operator is present.
-- Record the number of rows returned, logical reads, CPU time,
-- and elapsed time.
-- Explain which operations contribute to the query's workload.

SET STATISTICS IO, TIME ON;

SELECT TOP (10)
    h.SalesOrderID,
    h.OrderDate,
    h.TotalDue,
    c.CustomerID,
    p.FirstName,
    p.LastName
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.Customer AS c
    ON h.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
WHERE h.OrderDate >= '20130101'
  AND h.OrderDate < '20140101'
ORDER BY h.TotalDue DESC;

SET STATISTICS IO, TIME OFF;

/* Join Operators: Nested Loops
SalesOrderHeader Access Operator: Clustered Index Scan
Sales.Customer Access Operator: Clustered Index Seek
Person.Person Access Operator: Clustered Index Seek
Sort Operator: Yes
Rows Returned: 10
Logical Reads: Person = 139; Customer = 79; SalesOrderHeader = 689
CPU Time: 31 ms
Elapsed Time: 57 ms
Conclusion:
SQL Server used Nested Loops to join the three tables. SalesOrderHeader was scanned to find orders from 2013, while
the related customer and person records were retrieved using index seeks. The Sort operator orders the qualifying results
by TotalDue in descending order. TOP (10) limits the output to 10 rows, but the database still needs to process the relevant
orders to determine which have the highest TotalDue.                  */
--------------------------------------------------------------------------------------------------------------

-- 18 The sales team needs the 20 order lines with the highest line value
-- from orders placed in 2013.
-- Line value is calculated as OrderQty * UnitPrice.
-- Analyze the query's performance before attempting to optimize it.
-- Enable the Actual Execution Plan, STATISTICS IO, and STATISTICS TIME.
-- Identify the join and access operators.
-- Check whether a Sort operator is used.
-- Record the rows returned, logical reads, CPU time, and elapsed time.
-- Then rewrite the query to improve its efficiency without creating
-- new indexes or changing the business requirements.

SET STATISTICS IO, TIME ON;

SELECT TOP (20) *
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID
WHERE YEAR(h.OrderDate) = 2013
ORDER BY d.OrderQty * d.UnitPrice DESC;

SET STATISTICS IO, TIME OFF;

/* Join Operator: Merge Join
Access Operators: Clustered Index Scan
Sort Operator: Yes
Rows Returned: 20
Logical Reads: SalesOrderDetail 897 - SalesOrderHeader 689
CPU Time: 265 ms
Elapsed Time: 338 ms              */

SET STATISTICS IO, TIME ON;

SELECT TOP (20)
    h.SalesOrderID,
    h.OrderDate,
    d.ProductID,
    d.OrderQty,
    d.UnitPrice,
    d.OrderQty * d.UnitPrice AS LineValue
FROM Sales.SalesOrderHeader AS h
INNER JOIN Sales.SalesOrderDetail AS d
    ON h.SalesOrderID = d.SalesOrderID
WHERE h.OrderDate >= '20130101'
  AND h.OrderDate < '20140101'
ORDER BY LineValue DESC;

SET STATISTICS IO, TIME OFF;

/* Join Operator: Hash Match
Access Operators: SalesOrderHeader Clustered Index Scan - SalesOrderDetail NonClustered Index Scan
Sort Operator: Yes
Rows Returned: 20
Logical Reads: SalesOrderDetail 424 - SalesOrderHeader 689
CPU Time: 94 ms
Elapsed Time: 129 ms

Conclusion:
The optimized query selects only the required columns and uses a
SARGable date range instead of applying YEAR() to OrderDate.
The execution plan changed from Merge Join to Hash Match, and
SalesOrderDetail was accessed through a nonclustered index scan.
Logical reads decreased by approximately 29.8%, while CPU and
elapsed times also decreased in this execution. The Sort operator
remained necessary to identify the 20 order lines with the highest
calculated line value. Further repeated tests would be needed to
confirm the consistency of these performance improvements.                          */