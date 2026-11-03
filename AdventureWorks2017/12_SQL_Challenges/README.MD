# Module 12 - SQL Advanced Challenges

## Overview

This module consolidates SQL Server skills through 20 practical exercises and business scenarios using the **AdventureWorks2017** sample database.

It covers SQL functions and data formatting, table relationships and joins, aggregations, subqueries, correlated `EXISTS` and `NOT EXISTS`, Common Table Expressions (CTEs), window functions, views, stored procedures, nonclustered indexes, execution plan analysis, and query performance optimization. The module concludes with an integrated customer sales performance report that combines aggregations, multiple CTEs, joins, window ranking, and conditional classification.

---

## Topics Covered

- SQL Functions and Data Formatting
- `CAST()` and `CONVERT()`
- `YEAR()` and `MONTH()`
- `CASE`, `COALESCE()`, `TRIM()`, `UPPER()`, and `LEFT()`
- INNER JOIN and LEFT JOIN
- Table Relationships and Foreign Keys
- `COUNT()`, `SUM()`, `AVG()`, and `MAX()`
- `GROUP BY` and `HAVING`
- Scalar Subqueries
- Correlated Subqueries
- `EXISTS` and `NOT EXISTS`
- Common Table Expressions (CTEs)
- Multiple CTEs and Query Decomposition
- Window Functions
- `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`
- `PARTITION BY` and Window Ordering
- Views
- Stored Procedures and Input Parameters
- Nonclustered Indexes
- Included Columns (`INCLUDE`)
- Actual Execution Plans
- `STATISTICS IO` and `STATISTICS TIME`
- Logical Reads, CPU Time, and Elapsed Time
- SARGable vs. Non-SARGable Predicates
- Query Performance Diagnosis and Optimization
- Performance Comparison Before and After Indexing
- Integrated Customer Sales Performance Reporting

---

## SQL Advanced Challenges Workflow

```text
                 SQL Fundamentals
                and Scalar Functions
                         |
                         v
                JOINs and Relationships
                         |
                         v
                 Aggregations and
                GROUP BY / HAVING
                         |
                         v
                 Subqueries and
                EXISTS / NOT EXISTS
                         |
                         v
                 Common Table
                  Expressions
                         |
                         v
                 Window Functions
          ROW_NUMBER / RANK / DENSE_RANK
                         |
                         v
                Database Objects
                  /         \
                 v           v
              Views     Stored Procedures
                  \         /
                   v       v
                 Indexes and
               Execution Plans
                         |
                         v
              Query Performance Analysis
                         |
                         v
           SARGable Query Rewriting and
             Performance Comparison
                         |
                         v
                Final Integrated
                     Challenge

```markdown
## Notes

This module uses SQL Server syntax and the **AdventureWorks2017** sample database. Exercises build progressively from individual query constructs to multi-step reporting scenarios.

Date filters that use a half-open range (for example, `OrderDate >= '20130101' AND OrderDate < '20140101'`) include all times on the selected dates and allow SQL Server to consider index access on the date column. Applying functions such as `YEAR()` and `MONTH()` directly to a filtered column is used in the performance exercises as a non-SARGable comparison against a date-range predicate.

The ranking functions have different tie behavior: `ROW_NUMBER()` assigns a unique sequential number, `RANK()` preserves ties and leaves gaps, and `DENSE_RANK()` preserves ties without gaps. In the final challenge, `DENSE_RANK()` is used to return the top 10 sales ranks including ties, so the result may contain more than 10 customers.

Views and stored procedures are created as database objects, and the index created in Exercise 18 is also persistent. Running the module again may require checking whether these objects already exist. Exercise 18 compares the query plan before and after index creation, while Exercise 19 reuses that index to compare a non-SARGable predicate with a SARGable date range. Actual plans and performance measurements can vary with data, statistics, caching, and the execution environment; compare execution operators and logical reads together with CPU and elapsed time.

---

## Exercises

| # | Topic | Description |
|---:|---|---|
| 1 | Customer Sales Analysis | Aggregate customer orders during 2013 using `COUNT()`, `SUM()`, and `AVG()`, returning customers with at least five orders and sorting by total sales. |
| 2 | Order Classification | Format order dates, extract year and month, cast `TotalDue`, and classify 2013 orders into value categories using `CASE`. |
| 3 | Product Catalog Analysis | Prepare a product catalog using string functions, replace NULL colors with `COALESCE()`, cast list prices, and classify products by price. |
| 4 | Product Subcategory Analysis | Join products with their subcategories, filter products with a positive list price, and sort by subcategory and price. |
| 5 | Product Subcategory Summary | Aggregate product counts, average prices, and highest prices by subcategory, returning subcategories with at least 10 qualifying products. |
| 6 | Customers Without Orders | Use a `LEFT JOIN` and `IS NULL` to identify customers who have never placed a sales order. |
| 7 | Sales by Territory | Join sales orders with territories, calculate order and sales metrics for 2013, and return territories with at least 100 orders. |
| 8 | Product Category Analysis | Join products, subcategories, and categories to aggregate product counts and price metrics by category. |
| 9 | Products Above Average Price | Use a scalar subquery to identify products priced above the average list price of all products with a positive price. |
| 10 | Customers Without Orders in 2013 | Use correlated `EXISTS` and `NOT EXISTS` subqueries to find customers with order history but no orders during 2013. |
| 11 | Customer Sales Summary Using a CTE | Use a CTE to calculate customer order counts, total sales, and average order value for 2013, then filter by order count and sales. |
| 12 | Product Sales Analysis Using Multiple CTEs | Use two CTEs to calculate order-line revenue, aggregate quantity and revenue by product, and return the 10 highest-revenue products from 2013. |
| 13 | Ranking Customer Orders | Apply `ROW_NUMBER()` to rank each customer's orders from 2013 by order value. |
| 14 | `ROW_NUMBER()` vs. `RANK()` | Compare unique sequential numbering with ranking that preserves ties for each customer's 2013 orders. |
| 15 | Comparing Ranking Functions | Compare `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` for each customer's 2013 orders. |
| 16 | Customer Sales Summary View | Create a view that aggregates order count, total sales, and average order value by customer, then query customers meeting the specified thresholds. |
| 17 | Customer Orders Stored Procedure | Create and execute a parameterized stored procedure that returns a customer's orders sorted by order date. |
| 18 | Indexes and Execution Plans | Compare the execution plan for a date-filtered sales order query before and after creating a nonclustered index on `OrderDate` with included columns. |
| 19 | Query Performance Diagnosis and Optimization | Compare a query using `YEAR()` and `MONTH()` with a SARGable date-range rewrite, reusing the index from Exercise 18 and evaluating execution plans and performance metrics. |
| 20 | Final Challenge - Customer Sales Performance Report | Build a 2013 customer sales report using CTEs, aggregations, `DENSE_RANK()`, a join to `Sales.Customer`, and `CASE` classification; return the top 10 sales ranks including ties. |

---

## Learning Objectives

After completing this module, you will be able to:

- Apply SQL Server scalar functions to format, transform, and classify data.
- Combine related tables using INNER JOIN and LEFT JOIN.
- Summarize data with aggregate functions, `GROUP BY`, and `HAVING`.
- Use scalar and correlated subqueries, including `EXISTS` and `NOT EXISTS`.
- Structure queries using one or multiple CTEs.
- Apply `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` and explain their different handling of ties.
- Create and query views for reusable data summaries.
- Create and execute stored procedures with input parameters.
- Create nonclustered indexes with included columns and inspect their impact on query access paths.
- Analyze Actual Execution Plans and compare operators before and after index creation.
- Measure query work using logical reads, CPU time, and elapsed time.
- Identify non-SARGable predicates and rewrite them using SARGable date ranges.
- Compare alternative query implementations while preserving the requested business results.
- Combine aggregations, CTEs, joins, window functions, and conditional logic in an integrated SQL Server report.
