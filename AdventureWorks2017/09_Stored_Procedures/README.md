# Module 09 - Stored Procedures

## Overview

This module introduces SQL Stored Procedures used to create reusable and executable database programs using the **AdventureWorks2017** sample database.

Topics include creating and executing Stored Procedures, using input parameters, multiple parameters, variables, conditional logic with `IF / ELSE` and `CASE`, returning values with `OUTPUT` parameters and `RETURN`, modifying and removing Procedures, performing `INSERT` and `UPDATE` operations, working with transactions, and building practical database operations.

---

## Topics Covered

- CREATE PROCEDURE
- Executing Stored Procedures
- Input Parameters
- Multiple Parameters
- Filtering with Parameters
- Variables
- IF / ELSE
- CASE
- OUTPUT Parameters
- RETURN Values
- ALTER PROCEDURE
- DROP PROCEDURE
- INSERT
- UPDATE
- Transactions
- Practical Scenarios
- System Catalogs

---

## Stored Procedures Workflow

```text
                         Input Parameters
                                │
                                ▼
                      Stored Procedure Call
                                │
                                ▼
                       Procedure Execution
                                │
               ┌────────────────┼────────────────┐
               ▼                ▼                ▼
           Variables       Conditional Logic   Data Access
               │                │                │
               ▼                ▼                ▼
          DECLARE / SET     IF / ELSE / CASE   SELECT
                                                    │
                                                    ▼
                                              INSERT / UPDATE
               │                │                │
               └────────────────┼────────────────┘
                                ▼
                         Result / Output
                                │
                 ┌──────────────┼──────────────┐
                 ▼              ▼              ▼
             Result Set      OUTPUT         RETURN
                 │           Parameter        Value
                 └──────────────┼──────────────┘
                                ▼
                           Transactions
                                │
                         ┌──────┴──────┐
                         ▼             ▼
                      COMMIT       ROLLBACK
```

## Exercises

| # | Topic | Description |
|---:|--------|-------------|
| 1 | Basic Procedure | Create a reusable Stored Procedure that returns product information. |
| 2 | Executing Procedures | Execute an existing Stored Procedure. |
| 3 | Parameters | Create a Procedure using an input parameter to filter products by minimum price. |
| 4 | Multiple Parameters | Create a Procedure using minimum and maximum price parameters. |
| 5 | Filtering with Parameters | Retrieve orders for a specific customer using an input parameter. |
| 6 | Variables | Calculate and store a customer's total sales using a local variable. |
| 7 | IF / ELSE | Classify a customer based on total sales using conditional logic. |
| 8 | CASE | Classify a customer based on total sales using `CASE`. |
| 9 | OUTPUT Parameters | Return a customer's total sales through an `OUTPUT` parameter. |
| 10 | RETURN Values | Return an integer status indicating whether a customer exists. |
| 11 | ALTER PROCEDURE | Modify the return status values of an existing Procedure. |
| 12 | ALTER PROCEDURE + OUTPUT | Modify a Procedure to return a text-based status through an `OUTPUT` parameter. |
| 13 | DROP PROCEDURE | Remove an existing Stored Procedure. |
| 14 | INSERT | Create a Procedure to register a new customer. |
| 15 | UPDATE | Create a Procedure to update a customer's sales territory. |
| 16 | Transactions | Update customer data using a transaction and `COMMIT`. |
| 17 | Practical Scenario | Build a customer order summary using variables and multiple queries. |
| 18 | Practical Scenario | Recreate the customer order summary using an `INNER JOIN`. |
| 19 | System Catalogs | List Stored Procedures and their definitions using system catalog views. |
| 20 | Final Challenge | Build a complete customer sales performance evaluation Procedure. |

---

## Learning Objectives

After completing this module, you will be able to:

- Create and execute reusable SQL Stored Procedures.
- Use input parameters to make Procedures reusable and dynamic.
- Declare and use local variables within Procedures.
- Implement conditional logic using `IF / ELSE` and `CASE`.
- Return values using `OUTPUT` parameters and `RETURN`.
- Modify and remove Stored Procedures using `ALTER PROCEDURE` and `DROP PROCEDURE`.
- Use Stored Procedures to perform `INSERT` and `UPDATE` operations.
- Manage database changes using transactions and `COMMIT`.
- Combine multiple SQL concepts to build reusable database operations.
- Inspect Stored Procedures and their definitions using SQL Server system catalogs.

---
