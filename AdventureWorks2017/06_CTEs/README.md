# Module 06 - Common Table Expressions

## Overview

This module introduces Common Table Expressions (CTEs) used to organize and simplify complex SQL queries using the **AdventureWorks2017** sample database.

Topics include creating basic CTEs, combining CTEs with aggregation and joins, using multiple CTEs, combining CTEs with subqueries, applying conditional logic, and working with recursive CTEs.

---

## Topics Covered

- Basic CTEs
- CTE + Aggregation
- CTE + JOIN
- Multiple CTEs
- CTE + Subqueries
- Multi-Step Transformations
- CASE with CTEs
- Recursive CTEs

---

## SQL CTE Workflow

```text
                 Source Tables
                       │
                       ▼
                    CTE 1
                       │
              ┌────────┴────────┐
              ▼                 ▼
         Aggregation           JOIN
              │                 │
              └────────┬────────┘
                       ▼
                    CTE 2
                       │
              ┌────────┴────────┐
              ▼                 ▼
          Subquery             CASE
              │                 │
              └────────┬────────┘
                       ▼
                 Final Query
```

> **Note**
>
> A Common Table Expression (CTE) creates a named temporary result set that can be referenced by the statement that immediately follows it. CTEs are useful for organizing complex queries into logical steps and combining multiple transformations.

---

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Basic CTE | Create a report containing only products whose ListPrice is greater than 1000. |
| 2 | CTE + Aggregation | Identify customers whose total sales are greater than 10,000. |
| 3 | CTE + Aggregation | Identify customers whose average order value is greater than 1,000. |
| 4 | CTE + JOIN | Display each customer together with their total sales amount. |
| 5 | CTE + JOIN | Identify customers whose total sales are greater than 20,000. |
| 6 | CTE + JOIN | Identify customers who have placed at least 5 orders. |
| 7 | CTE + JOIN | Identify customers whose average order value is greater than 2,000. |
| 8 | CTE + Multiple Metrics | Identify customers whose total sales exceed 20,000 and whose average order value exceeds 2,000. |
| 9 | Multiple CTEs | Identify customers whose total sales are above the average total sales per customer. |
| 10 | Multiple CTEs + JOIN | Identify customers whose total sales are above the overall average and display their account number. |
| 11 | Multiple CTEs | Identify customers with more than 5 orders and total sales greater than 20,000. |
| 12 | CTE + Subquery | Identify customers whose total sales are greater than the average total sales across all customers. |
| 13 | CTE + Subquery | Identify customers whose total sales are greater than the average total sales of customers who placed more than 5 orders. |
| 14 | CTE + CASE | Classify customers based on their total sales. |
| 15 | CTE + CASE | Classify customers based on their total sales and number of orders. |
| 16 | Recursive CTE | Generate the employee hierarchy using OrganizationNode and OrganizationNode.GetAncestor(1). |

---

## Learning Objectives

After completing this module, you will be able to:

- Create and use Common Table Expressions.
- Use CTEs with aggregate functions.
- Combine CTEs with `JOIN`.
- Use multiple CTEs in the same query.
- Combine CTEs with subqueries.
- Break complex queries into logical transformation steps.
- Apply `CASE` expressions to values calculated in CTEs.
- Understand the structure and basic use of recursive CTEs.
- Build more organized and maintainable SQL queries.

---
