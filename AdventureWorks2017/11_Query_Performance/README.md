# Module 11 - Query Performance

## Overview

This module introduces SQL Server query performance analysis and optimization using the **AdventureWorks2017** sample database.

Topics include measuring query performance, analyzing logical reads and execution times, interpreting Actual and Estimated Execution Plans, understanding Index Seek and Index Scan operations, identifying Key Lookups, comparing SARGable and non-SARGable predicates, analyzing estimated execution costs and missing index recommendations, understanding sorting and TOP operations, comparing join strategies, and rewriting queries to improve performance.

---

## Topics Covered

- Measuring Query Performance
- STATISTICS IO
- STATISTICS TIME
- Logical and Physical Reads
- Actual Execution Plans
- Index Seek vs Index Scan
- Key Lookup
- SARGable vs Non-SARGable Predicates
- Estimated vs Actual Execution Plans
- Estimated Row Counts
- Actual Row Counts
- Estimated Execution Costs
- Missing Index Recommendations
- Column Selection
- SELECT *
- Sort Operator
- TOP and Sorting
- Nested Loops
- Merge Join
- Hash Match
- Query Rewriting and Optimization
- Performance Measurement and Comparison
- Practical Scenarios

---

## Query Performance Workflow

```text
                     SQL Query
                         │
                         ▼
                Measure Performance
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
       STATISTICS IO          STATISTICS TIME
              │                     │
              ▼                     ▼
       Logical Reads          CPU / Elapsed Time
              │                     │
              └──────────┬──────────┘
                         ▼
                 Execution Plans
                         │
             ┌───────────┴───────────┐
             ▼                       ▼
       Index Seek              Index Scan
             │                       │
             └───────────┬───────────┘
                         ▼
                    Key Lookup
                         │
                         ▼
               Predicate Analysis
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
          SARGable              Non-SARGable
                         │
                         ▼
             Estimated vs Actual Rows
                         │
                         ▼
                Estimated Costs
                         │
                         ▼
              Missing Index Analysis
                         │
                         ▼
                Sorting and TOP
                         │
                         ▼
                   Join Operators
                         │
            ┌────────────┼────────────┐
            ▼            ▼            ▼
       Nested Loops   Merge Join   Hash Match
                         │
                         ▼
                 Query Rewriting
                         │
                         ▼
              Performance Comparison
                         │
                         ▼
                  Final Challenge
```

## Notes

Query performance analysis helps identify how SQL Server retrieves, filters, joins, sorts, and processes data. `STATISTICS IO` reports information about data access, while `STATISTICS TIME` reports CPU and elapsed execution times. Execution Plans help identify the operators and access methods selected by the Query Optimizer.

Performance measurements may vary between executions. Estimated execution costs are optimizer estimates rather than actual execution times, and a SARGable predicate does not guarantee an Index Seek. Missing index recommendations should also be evaluated against the overall workload and index maintenance costs.

Effective query optimization requires comparing execution plans and performance metrics, understanding the work performed by each operator, and evaluating whether rewriting a query improves its efficiency without changing the business requirements.

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Measuring Query Performance | Measure logical reads, CPU time, and elapsed time for a query retrieving orders for a specific customer. |
| 2 | Actual Execution Plans | Identify the access operator, the index being used, and whether a Key Lookup occurs. |
| 3 | Performance Measurement | Measure the performance of a query retrieving orders placed from January 1, 2013 onward and compare the results with Exercise 1. |
| 4 | Index Scan | Analyze a Clustered Index Scan and explain how the access method relates to logical reads. |
| 5 | Index Seek | Analyze a nonclustered Index Seek and explain how selecting fewer columns can avoid a Key Lookup. |
| 6 | SARGable vs Non-SARGable Predicates | Compare a direct filter on `CustomerID` with a predicate applying `CAST()` to the indexed column. |
| 7 | Date Predicates | Compare `YEAR(OrderDate) = 2013` with a SARGable date range and analyze the execution plans and logical reads. |
| 8 | Estimated vs Actual Execution Plans | Compare estimated and actual row counts for the execution plan and analyze differences in cardinality estimates. |
| 9 | Estimated Execution Costs | Inspect Estimated I/O Cost, Estimated CPU Cost, and Estimated Subtree Cost and explain why these costs do not represent actual execution time. |
| 10 | Missing Index Recommendations | Analyze a Missing Index recommendation, identify the suggested key and included columns, and evaluate potential maintenance costs. |
| 11 | Column Selection and SELECT * | Compare selecting specific columns with `SELECT *` and analyze the access operators, Key Lookups, and logical reads. |
| 12 | Sort Operator | Analyze a query sorting all orders by `TotalDue` and identify the additional work performed by the Sort operator. |
| 13 | TOP and Sorting | Retrieve the 10 orders with the highest `TotalDue` and compare the workload with the full sorting query from Exercise 12. |
| 14 | Nested Loops | Analyze a filtered join between sales orders and order details and identify the join and access operators. |
| 15 | Merge Join | Analyze a join returning all orders and their corresponding order details and compare its workload with Exercise 14. |
| 16 | Hash Match | Analyze a join between `Sales.Customer` and `Person.Person` and explain the selected join strategy. |
| 17 | Multiple Joins and TOP | Retrieve the 10 highest-value orders placed in 2013, including customer information, and analyze the join operators and sorting work. |
| 18 | Final Challenge | Rewrite a query to retrieve the 20 order lines with the highest calculated line value for orders placed in 2013, compare execution plans and performance metrics, and optimize without creating new indexes or changing the business requirements. |

---

## Learning Objectives

After completing this module, you will be able to:

- Measure query performance using `STATISTICS IO` and `STATISTICS TIME`.
- Interpret logical reads, CPU time, and elapsed time.
- Analyze Actual and Estimated Execution Plans.
- Distinguish between Index Seek and Index Scan operations.
- Understand why Key Lookups occur and how they affect query execution.
- Recognize SARGable and non-SARGable predicates.
- Compare estimated and actual row counts and understand the impact of estimation differences.
- Interpret estimated execution costs and Missing Index recommendations.
- Understand how column selection and `SELECT *` affect query processing.
- Identify Sort operators and understand how `TOP` interacts with sorting.
- Understand the differences between Nested Loops, Merge Join, and Hash Match.
- Compare alternative query implementations using execution plans and performance metrics.
- Rewrite SQL queries to improve performance while preserving business requirements.
- Apply query performance analysis and optimization techniques to practical SQL Server scenarios.
