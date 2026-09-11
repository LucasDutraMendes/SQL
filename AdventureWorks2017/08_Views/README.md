# Module 08 - Views

## Overview

This module introduces SQL Views as reusable database objects built from
`SELECT` statements. Views can simplify complex queries, centralize business
logic, provide controlled access to data, and support reusable reporting.

The module progresses from basic Views and JOINs to aggregation, business
logic, CTEs, subqueries, security, database roles, and Indexed Views. The
final exercises combine multiple concepts into practical reporting scenarios.

---

## Topics Covered

- Creating and querying Views
- Views with JOINs and multiple JOINs
- Views with aggregation using `COUNT()` and `SUM()`
- Business logic with `CASE`
- `ALTER VIEW` and `DROP VIEW`
- Views with CTEs and subqueries
- Views and data security
- Database Roles and `GRANT SELECT`
- Indexed Views
- `SCHEMABINDING`
- `UNIQUE CLUSTERED INDEX`
- Practical reporting scenarios

---

## Views Workflow

```text
Base Tables
    ↓
SELECT / JOIN / Aggregation / Business Logic
    ↓
CREATE VIEW
    ↓
Reusable Database Object
    ↓
Query / Filter / Report
