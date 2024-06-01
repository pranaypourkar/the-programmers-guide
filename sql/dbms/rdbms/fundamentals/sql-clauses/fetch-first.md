# FETCH FIRST

## &#x20;Description

The `FETCH FIRST` clause is used to limit the number of rows returned by a query. This is similar to the `LIMIT` clause in other SQL databases like MySQL. It allows to retrieve only a specific number of rows from the result set, which can be useful for pagination or for getting the top N records.

## **Syntax**

```sql
SELECT ...
FROM ...
ORDER BY ...
FETCH FIRST N ROWS ONLY;
```

* **N**: The number of rows to fetch.

## **Example**

To get the first 5 rows from the `employees` table ordered by `hire_date`, you can use:

```sql
SELECT
    employee_id,
    first_name,
    last_name,
    hire_date
FROM
    employees
ORDER BY
    hire_date
FETCH FIRST 5 ROWS ONLY;
```
