# count(1) vs count(\*)

## About

The `COUNT` function in SQL is used to return the number of rows in a result set. Two common variants used in practice are:

* `COUNT(*)`
* `COUNT(1)`

These are often used interchangeably, but there are subtle differences and common misconceptions about their performance and behavior.

## What is `COUNT(*)`?

* Counts **all rows** in a table or result set, **including rows with NULL values**.
* It includes **every column**, but it doesn't actually fetch the column values.
* This is the most **accurate and standard** way to count rows.

#### Example:

```sql
SELECT COUNT(*) FROM employees;
```

This returns the total number of rows in the `employees` table.

## What is `COUNT(1)`?

* Counts **all rows** like `COUNT(*)`, but uses the constant `1` as a placeholder.
* The database evaluates the expression `1` for every row.
* Like `COUNT(*)`, it **includes rows with NULLs**.
* `COUNT(1)` does **not** count the value `1` in any column; it simply counts rows where `1` can be evaluated (which is always true).

#### Example:

```sql
SELECT COUNT(1) FROM employees;
```

This also returns the total number of rows in the `employees` table.

## Key Differences

<table data-header-hidden data-full-width="true"><thead><tr><th width="191.7265625"></th><th width="239.17620849609375"></th><th></th></tr></thead><tbody><tr><td>Aspect</td><td><code>COUNT(*)</code></td><td><code>COUNT(1)</code></td></tr><tr><td>Row counting</td><td>Counts all rows</td><td>Counts all rows</td></tr><tr><td>NULL handling</td><td>Includes NULLs</td><td>Includes NULLs</td></tr><tr><td>Column dependency</td><td>No</td><td>No</td></tr><tr><td>Expression eval</td><td>No evaluation needed</td><td>Evaluates constant <code>1</code> per row</td></tr><tr><td>Index use</td><td>Can use index (if exists)</td><td>Can also use index (depends on optimizer)</td></tr><tr><td>Performance</td><td>Typically same as COUNT(1)</td><td>Typically same as COUNT(*)</td></tr></tbody></table>

## Common Misconceptions

1. **Myth**: `COUNT(1)` is faster than `COUNT(*)`
   * **Reality**: In modern databases like MySQL, PostgreSQL, Oracle, or SQL Server, there is **no meaningful difference** in performance.
   * The optimizer treats both similarly and uses the most efficient execution plan.
2. **Myth**: `COUNT(*)` scans all columns
   * **Reality**: It does **not** fetch any column values; it just counts rows.
3. **Myth**: `COUNT(1)` only counts rows where column `1` exists
   * **Reality**: It doesn’t refer to a column; `1` is just a constant value.

## When to Use What ?

* Prefer **`COUNT(*)`** for clarity, readability, and standard behavior.
* Use `COUNT(1)` or any other constant only when it serves a **special logic**, which is rare.

## What About `COUNT(column_name)`?

Just for clarity:

* `COUNT(column_name)` **only counts non-NULL values** in that column.

Example:

```sql
SELECT COUNT(email) FROM users;
```

Counts only users where the `email` is not NULL.

## Performance Benchmarks

* On large tables, `COUNT(*)` and `COUNT(1)` typically perform **equally well**.
* If a table has **no WHERE clause**, databases may use metadata or indexes to speed up `COUNT(*)`
