# Module 10 - Indexes

## Overview

This module introduces SQL Server Indexes used to improve query performance and optimize data access using the **AdventureWorks2017** sample database.

Topics include inspecting and creating indexes, understanding clustered and nonclustered indexes, analyzing execution plans, comparing index seeks and scans, working with key lookups, included columns and covering indexes, analyzing statistics, creating composite indexes, understanding index column order, identifying redundant indexes, and applying practical indexing strategies.

---

## Topics Covered

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

---

## Indexes Workflow

```text
                      Existing Tables
                             │
                             ▼
                      Inspect Indexes
                             │
                             ▼
                      Create Indexes
                             │
              ┌──────────────┴──────────────┐
              ▼                             ▼
       Clustered Index              Nonclustered Index
              │                             │
              └──────────────┬──────────────┘
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
                    Included Columns
                             │
                             ▼
                     Covering Index
                             │
                             ▼
                        Statistics
                             │
                             ▼
                    Composite Indexes
                             │
                             ▼
                   Index Column Order
                             │
                             ▼
                    Redundant Indexes
                             │
                             ▼
                     Drop / Maintain
                             │
                             ▼
                   Indexing Strategy

```

## Notes

Indexes can improve query performance by providing efficient access paths to data. However, indexes also require storage and maintenance during `INSERT`, `UPDATE`, and `DELETE` operations. Effective indexing requires balancing query performance with index maintenance costs.

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Inspecting Existing Indexes | Inspect the indexes defined on `Production.Product` using `sys.indexes`. |
| 2 | Creating Indexes | Create a nonclustered index on `ProductNumber` and verify that it was created. |
| 3 | Clustered vs Nonclustered | Identify clustered and nonclustered indexes and explain why a table can have only one clustered index. |
| 4 | Creating Indexes | Create a nonclustered index on `ListPrice` and verify the index. |
| 5 | Index Selection | Identify which existing indexes can support searches using `ProductID` and `ProductNumber`. |
| 5.5 | Index Columns | Inspect the columns associated with each index and identify key column order. |
| 6 | Indexing Strategy | Determine which columns should use clustered and nonclustered indexes based on query patterns. |
| 7 | Execution Plans | Analyze an Actual Execution Plan and identify a clustered index seek. |
| 8 | Nonclustered Index Seek | Analyze a nonclustered index seek and identify the index being used. |
| 9 | Key Lookup | Identify a Key Lookup and explain why SQL Server performs it after an index seek. |
| 10 | Included Columns | Create a covering nonclustered index using included columns and compare the execution plan. |
| 11 | Index Scan | Analyze an Index Scan and explain why SQL Server may choose a scan for a query. |
| 12 | Index Seek vs Index Scan | Compare execution plans and analyze how predicate selectivity can affect the access method. |
| 13 | Estimated vs Actual Execution Plans | Compare estimated and actual row counts and analyze differences in optimizer estimates. |
| 14 | Statistics | Inspect statistics and understand how information about data distribution helps estimate row counts. |
| 15 | Redundant Indexes | Identify overlapping indexes and analyze storage and maintenance costs. |
| 16 | Composite Indexes | Create a composite index and verify the order of its key columns. |
| 17 | Index Column Order | Compare execution plans using different filtering patterns against a composite index. |
| 18 | Dropping Indexes | Remove an unnecessary index and verify that it was deleted. |
| 19 | Final Challenge | Design and implement a covering index strategy to improve a frequently executed query and eliminate a Key Lookup. |

---

## Learning Objectives

After completing this module, you will be able to:

- Inspect existing indexes and identify their associated columns.
- Create and remove clustered and nonclustered indexes.
- Understand the differences between clustered and nonclustered indexes.
- Analyze Actual and Estimated Execution Plans.
- Distinguish between Index Seek and Index Scan operations.
- Understand why Key Lookups occur and how they affect query execution.
- Use included columns to create covering indexes.
- Understand how SQL Server Statistics help estimate row counts.
- Create and analyze composite indexes.
- Understand how the order of columns affects composite index usage.
- Identify redundant indexes and understand their storage and maintenance costs.
- Design indexing strategies based on query patterns and workload requirements.
- Apply indexing concepts to practical SQL Server performance scenarios.
