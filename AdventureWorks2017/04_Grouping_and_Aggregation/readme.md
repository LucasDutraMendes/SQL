# Module 04 - Grouping and Aggregation

## Overview

This module introduces SQL aggregation techniques used to summarize and analyze data using the **AdventureWorks2017** sample database.

Topics include grouping records, applying aggregate functions, filtering aggregated results, and using `CASE` expressions to build dynamic business reports.

---

## Topics Covered

- GROUP BY
- COUNT()
- SUM()
- AVG()
- MIN()
- MAX()
- HAVING
- CASE
- SUM(CASE...)
- COUNT(CASE...)

---

## SQL Aggregation Workflow

```text
                Production.Product
        +-------------------------------+
        | Product | Color | ListPrice   |
        +-------------------------------+
        | A       | Red   | 100         |
        | B       | Blue  | 200         |
        | C       | Red   | 150         |
        | D       | Black | 300         |
        +-------------------------------+
                     │
                     ▼
                GROUP BY Color
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
     Red            Blue          Black
   A     C            B             D
      │              │              │
      └──────┬───────┴───────┬──────┘
             ▼
     Aggregate Functions
 COUNT(*)   SUM()   AVG()   MIN()   MAX()
             │
             ▼
        +---------------------------+
        | Color | Count | AvgPrice |
        +---------------------------+
        | Red   |   2   | 125.00   |
        | Blue  |   1   | 200.00   |
        | Black |   1   | 300.00   |
        +---------------------------+
```

> **Note**
>
> Aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`) operate on the groups created by the `GROUP BY` clause.

---

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | GROUP BY | Count the number of products for each color. |
| 2 | SUM() | Calculate the total sales amount for each customer. |
| 3 | AVG() | Calculate the average order value for each customer. |
| 4 | MIN() | Find the cheapest product price for each product subcategory. |
| 5 | MAX() | Find the most expensive product price for each product subcategory. |
| 6 | SUM() | Calculate total sales for each customer by year. |
| 7 | HAVING | Find customers with more than 10 orders. |
| 8 | HAVING | Find customers with more than 5 orders after January 1, 2013. |
| 9 | CASE | Classify products by price category. |
| 10 | SUM(CASE...) | Calculate high-value and regular sales for each customer. |
| 11 | COUNT(CASE...) | Count high-value and regular orders for each customer. |
| 12 | CASE + GROUP BY | Count the number of products in each price category. |
| 13 | CASE + Aggregation | Calculate the number of products and average price for each price category. |

---

## Learning Objectives

After completing this module, you will be able to:

- Group records using `GROUP BY`.
- Apply aggregate functions to grouped data.
- Filter grouped results using `HAVING`.
- Create conditional columns using `CASE`.
- Combine `CASE` with aggregate functions.
- Build business-oriented summary reports.

---

