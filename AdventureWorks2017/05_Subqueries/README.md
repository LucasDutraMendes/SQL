# Module 05 - Subqueries

## Overview

This module introduces SQL subqueries used to build more advanced queries by using the result of one query inside another query with the **AdventureWorks2017** sample database.

Topics include scalar subqueries, multiple-row subqueries, nested subqueries, subqueries in the `SELECT` and `FROM` clauses, `EXISTS`, `NOT EXISTS`, and correlated subqueries.

---

## Topics Covered

- Scalar Subqueries
- Multiple-Row Subqueries
- IN
- NOT IN
- Nested Subqueries
- Subqueries in the SELECT clause
- Subqueries in the FROM clause
- EXISTS
- NOT EXISTS
- Correlated Subqueries

---

## SQL Subquery Workflow

```text
                         Outer Query
                              │
                              ▼
                           Subquery
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
       Single Value      Multiple Values    Row Existence
            │                 │                 │
            ▼                 ▼                 ▼
         Scalar          IN / NOT IN     EXISTS / NOT EXISTS
            │
            └─────────────────┬─────────────────┘
                              ▼
                     Result for Outer Query


                    Correlated Subquery
                              │
                              ▼
                         Outer Query
                              │
                              ▼
                          Current Row
                              │
                              ▼
                    Inner Query uses
                    outer-row values
                              │
                              ▼
                       Calculated Value
                              │
                              ▼
                          Comparison
```

> **Note**
>
> A subquery can return a single value, multiple values, or be used to check whether related rows exist. A correlated subquery references values from the outer query.

---

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Scalar Subquery | Identify products that are more expensive than the average product price. |
| 2 | Scalar Subquery | Identify the most expensive product in the catalog. |
| 3 | Scalar Subquery | Identify products that are cheaper than the average product price. |
| 4 | Scalar Subquery | Identify the cheapest product in the catalog. |
| 5 | Multiple-Row Subquery | Identify customers who have placed at least one sales order. |
| 6 | Multiple-Row Subquery | Identify products that have been sold at least once. |
| 7 | Multiple-Row Subquery | Identify products that have never been sold. |
| 8 | Nested Subquery | Identify customers who have placed an order whose value is greater than the average order value. |
| 9 | SELECT Subquery | Display each product together with the average product price. |
| 10 | SELECT Subquery | Display each product together with the highest product price. |
| 11 | SELECT Subquery | Display each product together with the lowest product price. |
| 12 | FROM Subquery | Create a derived table containing products whose price is greater than 1000. |
| 13 | FROM Subquery | Calculate the average total sales amount per customer. |
| 14 | FROM Subquery | Identify the highest total sales made by a single customer. |
| 15 | EXISTS | Identify customers who have placed at least one order. |
| 16 | EXISTS | Identify customers who have placed at least one high-value order. |
| 17 | NOT EXISTS | Identify customers who have never placed an order. |
| 18 | NOT EXISTS | Identify customers who do not have any high-value orders. |
| 19 | Correlated Subquery | Identify products whose price is higher than the average price of their subcategory. |
| 20 | Correlated Subquery | Identify products whose price is lower than the average price of their subcategory. |
| 21 | Correlated Subquery | Identify the product(s) with the highest price in each subcategory. |
| 22 | Correlated Subquery | Compare each product with the average price of the other products in its subcategory. |
| 23 | Final Challenge | Identify customers who have never placed an order greater than the average order value. |

---

## Learning Objectives

After completing this module, you will be able to:

- Use scalar subqueries with aggregate functions.
- Use multiple-row subqueries with `IN` and `NOT IN`.
- Build nested subqueries.
- Use subqueries in the `SELECT` and `FROM` clauses.
- Use `EXISTS` and `NOT EXISTS` to check for related records.
- Understand how correlated subqueries reference the outer query.
- Compare individual rows with aggregate values calculated from related rows.
- Select an appropriate subquery strategy based on the problem requirements.

---
