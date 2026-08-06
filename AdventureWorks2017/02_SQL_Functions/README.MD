# Module 02 - SQL Functions

## Overview

This module introduces the most commonly used SQL Server functions for manipulating, transforming, formatting, and converting data.

These functions are essential for writing efficient SQL queries and are widely used in Data Analysis, Business Intelligence, and Data Engineering.

---

## Exercises

Each topic includes:

- Concept introduction
- Practical examples
- Hands-on exercises
- Solutions
- Real-world SQL scenarios

| # | Topic | Description |
|---:|--------|-------------|
| 1 | LEN() | Return the first name of every person and its length. |
| 2 | LEN() | Return employees whose first name has more than 8 characters. |
| 3 | LEN() | Order product names by length. |
| 4 | UPPER() | Return every first name in uppercase. |
| 5 | UPPER() | Display the product name in uppercase. |
| 6 | UPPER() | Filter products with color "RED" using UPPER(). |
| 7 | LOWER() | Display first names in lowercase and last names in uppercase. |
| 8 | LOWER() | Display product names in lowercase and product numbers in uppercase. |
| 9 | LEFT() | Extract the first characters of ProductNumber. |
| 10 | LEFT() | Extract the first characters of the product name. |
| 11 | LEFT() | Filter ProductNumbers starting with "BK". |
| 12 | RIGHT() | Extract the last two characters of ProductNumber. |
| 13 | RIGHT() | Filter ProductNumbers ending in "42". |
| 14 | SUBSTRING() | Extract the middle section of ProductNumber. |
| 15 | SUBSTRING() | Extract the first ten characters of the product name. |
| 16 | SUBSTRING() | Filter ProductNumbers whose fourth character is "M". |
| 17 | CHARINDEX() | Locate the first dash in ProductNumber. |
| 18 | CHARINDEX() | Locate the first occurrence of "M". |
| 19 | CHARINDEX() | Return products containing the letter "L". |
| 20 | CHARINDEX() | Return products where "A" appears after position 2. |
| 21 | LEFT() + SUBSTRING() + CHARINDEX() | Extract product category and identifier from ProductNumber. |
| 22 | ROUND() | Round product prices to two decimal places. |
| 23 | CEILING() | Round product weight up. |
| 24 | FLOOR() | Round product weight down. |
| 25 | ABS() | Calculate the absolute difference from a reference price. |
| 26 | ROUND(), CEILING(), FLOOR() | Compare different rounding functions. |
| 27 | GETDATE(), YEAR(), MONTH(), DAY() | Return the current date and its components. |
| 28 | YEAR(), MONTH(), DAY() | Extract date components from product dates. |
| 29 | DATEADD() | Add and subtract dates. |
| 30 | DATEADD() | Calculate dates relative to ModifiedDate. |
| 30.1 | DATEADD() | Real-world example: products modified in the last 30 days. |
| 31 | DATEDIFF() | Calculate days since January 1, 2020. |
| 32 | DATEDIFF() | Calculate years and months since SellStartDate. |
| 33 | DATEADD() + DATEDIFF() | Combine date calculations. |
| 34 | DATEADD() | Filter products modified in the last 30 days. |
| 35 | EOMONTH() | Return the end of the current and next month. |
| 36 | EOMONTH() | Return month-end dates for product dates. |
| 37 | DATEFROMPARTS() | Build custom dates. |
| 38 | DATEFROMPARTS() | Rebuild SellStartDate. |
| 39 | CAST() | Convert prices and dates to different data types. |
| 40 | CAST() | Convert ProductID to text. |
| 41 | CONVERT() | Format dates using different styles. |
| 42 | CONVERT() | Display SellStartDate in multiple formats. |
| 43 | ISNULL() | Replace NULL values with default values. |
| 44 | COALESCE() | Handle NULL values using COALESCE(). |
| 45 | ISNULL() vs COALESCE() | Compare both NULL-handling functions. |

---

## Learning Objectives

By the end of this module, you will be able to:

- Manipulate and transform text values
- Perform mathematical calculations and rounding
- Work with dates and time intervals
- Convert values between different data types
- Handle NULL values correctly
- Combine multiple SQL functions in practical queries
- Write cleaner and more maintainable SQL queries

---

## Topics Covered

### String Functions
- LEN()
- LEFT()
- RIGHT()
- SUBSTRING()
- UPPER()
- LOWER()
- CHARINDEX()

### Mathematical Functions
- ROUND()
- CEILING()
- FLOOR()
- ABS()

### Date & Time Functions
- GETDATE()
- YEAR()
- MONTH()
- DAY()
- DATEADD()
- DATEDIFF()
- EOMONTH()
- DATEFROMPARTS()

### Data Type Conversion
- CAST()
- CONVERT()

### NULL Handling
- ISNULL()
- COALESCE()

