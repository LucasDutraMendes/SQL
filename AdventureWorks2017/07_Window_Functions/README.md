# Module 07 - Window Functions

## Overview

This module introduces SQL window functions used to perform calculations across related rows without collapsing the result set using the **AdventureWorks2017** sample database.

Topics include window functions with `OVER()`, partitioning and ordering data, ranking rows, comparing values across rows, running totals, moving averages, and retrieving first and last values within a window.

---

## Topics Covered

- OVER()
- PARTITION BY
- ORDER BY
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- SUM() OVER()
- Running Totals
- Moving Averages
- FIRST_VALUE()
- LAST_VALUE()
- Window Frames
- Window Functions + CTEs

---

## SQL Window Functions Workflow

```text
                     Source Data
                          │
                          ▼
                    Window Function
                          │
             ┌────────────┼────────────┐
             ▼            ▼            ▼
          OVER()     PARTITION BY   ORDER BY
             │            │            │
             └────────────┼────────────┘
                          ▼
                 Window Calculation
                          │
          ┌───────────────┼────────────────┐
          ▼               ▼                ▼
       Ranking        Row Comparison    Aggregation
          │               │                │
          ▼               ▼                ▼
 ROW_NUMBER()         LAG() / LEAD()    SUM() / AVG()
 RANK()                                FIRST_VALUE()
 DENSE_RANK()                          LAST_VALUE()
          │               │                │
          └───────────────┼────────────────┘
                          ▼
                  Original Rows Preserved
```

> **Note**
>
> Window functions perform calculations across a set of related rows while preserving the individual rows in the result set. `PARTITION BY` defines the groups within the window, while `ORDER BY` defines the sequence used by the window function.

---

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | OVER() | Display every product together with the average ListPrice of all products. |
| 2 | PARTITION BY | Display every product together with the average ListPrice of its ProductSubcategoryID. |
| 3 | ROW_NUMBER() | Rank products from the most expensive to the cheapest within each ProductSubcategoryID. |
| 4 | RANK() / DENSE_RANK() | Compare ROW_NUMBER(), RANK(), and DENSE_RANK() within each ProductSubcategoryID. |
| 5 | LAG() | Compare each product's ListPrice with the previous product within the same ProductSubcategoryID. |
| 6 | LEAD() | Compare each product's ListPrice with the next product within the same ProductSubcategoryID. |
| 7 | SUM() OVER() | Calculate a running total of TotalDue over time. |
| 8 | SUM() OVER() + PARTITION BY | Calculate a running total of TotalDue for each customer. |
| 9 | Moving Average | Calculate a rolling average using the current order and the two previous orders. |
| 10 | Moving Average + PARTITION BY | Calculate a rolling average for each customer. |
| 11 | LAG() | Calculate the difference between the current order value and the previous order value. |
| 12 | LAG() + Percentage Change | Calculate the percentage change in order value compared with the previous order. |
| 13 | FIRST_VALUE() | Display the highest ListPrice within each ProductSubcategoryID. |
| 14 | LAST_VALUE() | Display the lowest ListPrice within each ProductSubcategoryID using an explicit window frame. |
| 15 | Window Functions + CTE | Rank customers based on their total sales using a CTE and RANK(). |
| 16 | Window Functions + CTE | Compare each customer's total sales with the average total sales across all customers. |
| 17 | ROW_NUMBER() + CTE | Identify the three most expensive products within each ProductSubcategoryID. |
| 18 | Final Challenge | Identify the top 3 customers by total sales within each year. |

---

## Learning Objectives

After completing this module, you will be able to:

- Use window functions with `OVER()`.
- Divide calculations into groups using `PARTITION BY`.
- Control the order of rows within a window using `ORDER BY`.
- Rank rows using `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
- Compare values across rows using `LAG()` and `LEAD()`.
- Calculate running totals and moving averages.
- Retrieve first and last values within a window.
- Define window frames using `ROWS BETWEEN`.
- Combine window functions with CTEs.
- Solve analytical problems while preserving the original row-level detail.

---
