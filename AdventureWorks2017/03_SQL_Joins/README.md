# Module 03 - SQL JOINs

## Overview

This module introduces SQL JOIN operations using the AdventureWorks2017 sample database.

JOINs are one of the most important concepts in relational databases, allowing data stored in multiple related tables to be combined into meaningful query results.

The objective of this module is to understand how different JOIN types work and when each one should be used in real-world SQL queries.

---

## SQL JOIN Types

<p align="center">
  <img src="https://github.com/user-attachments/assets/2687c00f-3460-4b6f-9311-5e14456aac21" width="1200" alt="SQL JOINs Explained">
</p>

---

---
## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | INNER JOIN | Retrieve the customer ID, sales order ID, and order date for every order. |
| 2 | INNER JOIN | Retrieve the sales order ID, product ID, and product name. |
| 3 | INNER JOIN | Retrieve the customer ID, sales order ID, order date, and total due. |
| 4 | INNER JOIN | Retrieve the product name, order quantity, and unit price. |
| 5 | INNER JOIN | Retrieve employee information including job title. |
| 6 | INNER JOIN | Retrieve customer account information for each sales order. |
| 7 | INNER JOIN | Retrieve sales order details together with product information. |
| 8 | INNER JOIN | Combine customers, orders, order details, and products. |
| 9 | INNER JOIN | Display complete sales order information including products. |
| 10 | LEFT JOIN | Display all customers, including those who have never placed an order. |
| 11 | LEFT JOIN | Display only customers who have never placed an order. |
| 12 | LEFT JOIN | Display all products, including products that have never been sold. |
| 13 | LEFT JOIN | Display only products that have never been sold. |
| 14 | LEFT JOIN | Display customers and orders with `TotalDue > 1000`, preserving all customers. |
| 15 | LEFT JOIN | Display customers with no orders greater than 1000. |
| 16 | LEFT JOIN | Display every product, including products that have never been sold. |
| 17 | RIGHT JOIN | Display every sales order, even if the corresponding customer record is missing. |
| 18 | FULL OUTER JOIN | Display every customer and every sales order. |
| 19 | FULL OUTER JOIN | Display records without a matching record in the other table. |
| 20 | FULL OUTER JOIN | Identify records without matching related records. |
| 21 | FULL OUTER JOIN | Identify customers who have never placed an order. |
| 22 | CROSS JOIN | Generate every possible combination between sales territories and salespeople. |
| 23 | CROSS JOIN | Generate every possible combination between products and sales territories. |
| - | SELF JOIN | Concept reference demonstrating how a table can be joined to itself using different aliases. |
---

---
## Learning Objectives

By completing this module, you will be able to:

- Understand relationships between database tables.
- Combine data using different JOIN types.
- Retrieve matching and non-matching records.
- Select the appropriate JOIN for different business scenarios.
- Write efficient and readable JOIN queries.
- Interpret query results involving multiple tables.
---

---

## Topics Covered

### INNER JOIN

### LEFT JOIN

### RIGHT JOIN

### FULL OUTER JOIN

### LEFT JOIN (Excluding Matches)

### RIGHT JOIN (Excluding Matches)

### CROSS JOIN

### SELF JOIN

---

## Exercises

Each topic includes:

- Concept introduction
- Practical examples
- Hands-on exercises
- Solutions
- Real-world SQL scenarios
