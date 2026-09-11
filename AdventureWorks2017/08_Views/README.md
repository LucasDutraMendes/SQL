# Module 08 - Views

## Overview

This module introduces SQL Views used to create reusable database objects based on `SELECT` statements using the **AdventureWorks2017** sample database.

Topics include creating and querying Views, combining Views with JOINs and aggregations, implementing business logic with `CASE`, modifying and removing Views, using CTEs and subqueries, applying Views for controlled data access, managing permissions with database roles, and creating Indexed Views.

---

## Topics Covered

- CREATE VIEW
- Querying Views
- Views + JOINs
- Views + Multiple JOINs
- Views + Aggregation
- Views + CASE
- Business Logic in Views
- ALTER VIEW
- DROP VIEW
- Views + CTEs
- Views + Subqueries
- Views + Security
- Database Roles
- GRANT SELECT
- Indexed Views
- SCHEMABINDING
- UNIQUE CLUSTERED INDEX
- Practical Scenarios

---

## SQL Views Workflow

```text
                         Base Tables
                              │
                              ▼
                         SELECT Query
                              │
              ┌───────────────┼────────────────┐
              ▼               ▼                ▼
            JOIN         Aggregation       CASE Logic
              │               │                │
              ▼               ▼                ▼
        Multiple JOINs    COUNT() / SUM()   Business Rules
              │               │                │
              └───────────────┼────────────────┘
                              ▼
                         CREATE VIEW
                              │
              ┌───────────────┼────────────────┐
              ▼               ▼                ▼
         Query View       ALTER VIEW       DROP VIEW
              │               │
              ▼               ▼
         CTE / Subquery    Modify Logic
              │
              ▼
        Controlled Access
              │
              ▼
         Roles / GRANT
              │
              ▼
         Indexed Views
              │
              ▼
      SCHEMABINDING + INDEX
```

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Basic View | Create a reusable product information View. |
| 2 | Querying Views | Filter and sort products using an existing View. |
| 3 | View + JOIN | Join a View with the product subcategory table. |
| 4 | View + Multiple JOINs | Combine product, subcategory, and category information. |
| 5 | View + Aggregation | Count orders for each customer. |
| 6 | View + Aggregation | Calculate total sales for each customer. |
| 7 | View + CASE | Classify products based on ListPrice. |
| 8 | View + Business Logic | Classify customers based on total sales. |
| 9 | ALTER VIEW | Add ProductNumber to an existing View. |
| 10 | ALTER VIEW + CASE | Modify the pricing classification logic. |
| 11 | DROP VIEW | Remove an existing View. |
| 12 | View + CTE | Identify customers whose total sales are above the average customer sales. |
| 13 | View + Subquery | Identify products whose ListPrice is above the overall average. |
| 14 | Views + Security | Expose only selected customer information through a View. |
| 15 | Roles + GRANT | Manage View access through a database role. |
| 16 | Indexed Views | Create and index an aggregated View using SCHEMABINDING. |
| 17 | Practical Scenario | Create a reusable customer sales report. |
| 18 | Practical Scenario | Create a customer sales performance report. |
| 19 | Final Challenge | Build a complete customer performance report. |

## Extra Queries

| # | Topic | Description |
|---:|--------|-------------|
| 20 | System Information | Retrieve the current SQL Server login and database user. |
| 21 | System Catalogs | List Views available in the database, including their schemas. |

---

## Learning Objectives

After completing this module, you will be able to:

- Create and query reusable SQL Views.
- Combine Views with JOINs, aggregations, and business logic.
- Modify and remove Views using `ALTER VIEW` and `DROP VIEW`.
- Combine Views with CTEs and subqueries.
- Use Views as a controlled layer for exposing data.
- Manage View access through database roles and `GRANT SELECT`.
- Understand the purpose and structure of Indexed Views.
- Use `SCHEMABINDING` and `UNIQUE CLUSTERED INDEX` when creating Indexed Views.
- Build reusable reporting solutions by combining multiple SQL concepts.

---
