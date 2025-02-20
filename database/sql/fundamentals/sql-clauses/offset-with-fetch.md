# OFFSET with FETCH

## Description

The `OFFSET` and `FETCH` clauses are used for pagination in Oracle SQL, allowing to skip a specific number of rows and fetch the next set of rows.

## **Syntax**

```sql
SELECT columns
FROM table
ORDER BY column
OFFSET n ROWS FETCH NEXT m ROWS ONLY;
```

* **OFFSET n ROWS**: Skips the first `n` rows.
* **FETCH NEXT m ROWS ONLY**: Fetches the next `m` rows after skipping `n` rows.

## **Example**

Suppose we have an `employees` table and want to retrieve rows 11 to 20 ordered by `employee_id`.

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date
FROM
    employees
ORDER BY
    employee_id
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;
```
