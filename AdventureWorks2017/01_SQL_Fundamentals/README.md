# Module 01 - SQL Fundamentals

This module covers the fundamental concepts of SQL using the **AdventureWorks2017** sample database.

The objective is to build a solid foundation before moving on to more advanced topics such as SQL Functions, Joins, Window Functions, and Query Optimization.

---

## Topics Covered

### Data Retrieval

- SELECT
- DISTINCT
- TOP

### Filtering Data

- WHERE
- LIKE
- BETWEEN
- IN
- IS NULL
- IS NOT NULL

### Sorting Data

- ORDER BY
- ASC
- DESC

---

## Exercises

This module contains practical exercises using the following AdventureWorks tables:

- Person.Person
- Person.Address
- Production.Product
- HumanResources.Employee
- Sales.Customer
- Sales.SalesOrderHeader

This module contains **26 progressive exercises** covering the fundamental SQL statements used in everyday querying.

| # | Topic | Description |
|---:|--------|-------------|
| 1 | SELECT + ORDER BY | Return people's first name, last name, and email promotion. |
| 1.1 | DISTINCT | Return unique first names. |
| 2 | DISTINCT | Return all distinct cities. |
| 3 | WHERE | Return products costing more than 100. |
| 4 | TOP | Return the 20 most expensive products. |
| 5 | LIKE | Find products whose name starts with "Mountain". |
| 6 | LIKE | Find products whose name contains "Road". |
| 7 | LIKE | Find products whose name ends with "Bike". |
| 8 | BETWEEN | Return employees hired between 2012 and 2013. |
| 9 | IN | Return customers belonging to specific territories. |
| 10 | BETWEEN | Return products priced between 500 and 1500. |
| 11 | IS NULL | Return products without a color assigned. |
| 11.1 | COUNT() | Count products without a color. |
| 12 | IS NOT NULL | Return products with a color assigned. |
| 12.1 | COUNT() | Count products with a color. |
| 13 | IN | Return products whose color is Black, Red, or Silver. |
| 14 | TOP | Return the first 15 products alphabetically. |
| 15 | LIKE | Return people whose last name starts with "S". |
| 16 | LIKE | Return people whose first name contains "an". |
| 17 | WHERE | Return sales orders placed after January 1, 2013. |
| 18 | TOP | Return the 25 largest sales orders. |
| 19 | WHERE | Combine multiple filtering conditions. |
| 20 | WHERE | Create a business report using multiple conditions. |
| 21 | TOP | Return the 10 cheapest finished products. |
| 22 | COUNT(DISTINCT) | Count the number of distinct cities. |
| 23 | LIKE | Find products containing Helmet, Road, or Touring. |
| 24 | WHERE | Return employees hired before 2010. |
| 25 | TOP | Return the 50 oldest sales orders. |
| 26 | BETWEEN | Return products whose weight is between 500 and 700. |

---

## Learning Objectives

By the end of this module, you will be able to:

- Retrieve data using `SELECT`.
- Filter records using `WHERE`.
- Sort results using `ORDER BY`.
- Remove duplicate values using `DISTINCT`.
- Limit result sets using `TOP`.
- Search text using `LIKE`.
- Filter ranges using `BETWEEN`.
- Filter multiple values using `IN`.
- Handle `NULL` values correctly.
- Count records using `COUNT()` and `COUNT(DISTINCT)`.
- Combine multiple filtering conditions to solve business problems.


