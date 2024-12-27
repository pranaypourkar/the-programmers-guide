# OVER

## Description

Window functions, also known as analytic functions, are a powerful feature in SQL that allows to perform calculations across a set of table rows that are somehow related to the current row. This is different from regular aggregate functions which return a single aggregate value for a set of rows. Window functions retain the individual rows while calculating aggregates, ranks, running totals, or other calculations. The `PARTITION BY` clause is used within window functions to divide the result set into partitions to which the window function is applied.

{% hint style="info" %}
Window functions are not supported by all Database Management Systems (DBMS). Oracle, Microsoft SQL Server, MySQL, etc supports it.
{% endhint %}

## Syntax

```
SELECT column1,
       window_function() OVER ([PARTITION BY partition_expression] [ORDER BY order_expression] [RANGE|ROWS BETWEEN start_expr AND end_expr]) AS alias
FROM table_name;
```

* **window\_function()**: This is a placeholder for any window function, such as `SUM()`, `AVG()`, `ROW_NUMBER()`, `RANK()`, etc.
* **OVER**: Indicates the use of a window function.
* **\[PARTITION BY partition\_expression]**: (Optional) Divides the result set into partitions to which the window function is applied. Each partition is processed separately.
* **\[ORDER BY order\_expression]**: (Optional) Specifies the order of rows within each partition or within the entire result set if `PARTITION BY` is not used. This is necessary for functions that depend on the order, like cumulative sums or rankings.
* **\[RANGE BETWEEN start\_expr AND end\_expr]**: (Optional) Defines a window frame, which is a set of rows relative to the current row. `RANGE` considers rows within a certain range of values, while `ROWS` considers a specific number of rows. This can be especially useful for cumulative sums, moving averages, or other types of running totals.

{% hint style="info" %}
Keywords useful when using `RANGE`

**INTERVAL**: Specifies a time interval. Used with date or timestamp columns to define the range in terms of days, months, years, etc.

RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND CURRENT ROW

**PRECEDING**: Indicates that the boundary of the frame is before the current row.

RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND CURRENT ROW

**FOLLOWING**: Indicates that the boundary of the frame is after the current row.

RANGE BETWEEN CURRENT ROW AND INTERVAL '1' DAY FOLLOWING

**CURRENT ROW**: Refers to the current row being processed.

RANGE BETWEEN INTERVAL '1' DAY PRECEDING AND CURRENT ROW

**UNBOUNDED PRECEDING**: Specifies the start of the frame from the first row of the partition.

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

**UNBOUNDED FOLLOWING**: Specifies the end of the frame to the last row of the partition.

RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
{% endhint %}

## Common Window Functions

### **Ranking Functions:**

* **`ROW_NUMBER()`:** Assigns a unique, sequential number to each row within a partition or ordered result set. It's useful for assigning row positions or creating custom ordering.
* **`RANK()`:** Assigns a rank to each row based on a specified ordering criteria (e.g., descending sales amount). Rows with the same value share the same rank, and subsequent ranks might skip numbers.
* **`DENSE_RANK()`:** Similar to `RANK()` but assigns consecutive ranks without gaps, even if multiple rows share the same value in the ordering criteria.

### **Aggregate Window Functions:**

* **`SUM(expression) OVER (...)`:** Calculates the running or cumulative sum of an expression over a window. It's useful for tracking totals within partitions or ordered sets.
* **`AVG(expression) OVER (...)`:** Calculates the running or cumulative average of an expression over a window. It's helpful for analyzing trends within groups of data.
* **`MIN(expression) OVER (...)`:** Identifies the minimum value of an expression within a window. It can be used to find the lowest value within a specific range of rows.
* **`MAX(expression) OVER (...)`:** Identifies the maximum value of an expression within a window. It can be used to find the highest value within a specific range of rows.

### **Other Window Functions:**

* **`FIRST_VALUE(expression) OVER (...)`:** Retrieves the first value of an expression encountered within a window. It's useful for grabbing the initial value within a partition or ordered set.
* **`LAST_VALUE(expression) OVER (...)`:** Retrieves the last value of an expression encountered within a window. It's helpful for grabbing the final value within a partition or ordered set.
* **`LEAD(expression, offset) OVER (...)`:** Looks ahead a specified number of rows (`offset`) and returns the value of the expression at that position. It's useful for comparing values with future positions within the window.
* **`LAG(expression, offset) OVER (...)`:** Looks behind a specified number of rows (`offset`) and returns the value of the expression at that position. It's useful for comparing values with past positions within the window.
* **`RATIO_TO_REPORT(expression)`**: It is an analytic function used to calculate the ratio of a value to the sum of a set of values. It is commonly used to determine the proportion of a value within a group relative to the total for that group.

{% hint style="info" %}
All these window functions require the `OVER (...)` clause to define the window for the calculation.
{% endhint %}

## Examples

### **Calculating ROW\_NUMBER() with PARTITION BY**

We want to assign a unique row number to each sale within each product.

#### Table `sales`:

<table><thead><tr><th width="141">sale_id</th><th>product_id</th><th>customer_id</th><th>sale_amount</th><th>sale_date</th></tr></thead><tbody><tr><td>1</td><td>101</td><td>1001</td><td>500</td><td>2024-01-01</td></tr><tr><td>2</td><td>102</td><td>1002</td><td>300</td><td>2024-01-01</td></tr><tr><td>3</td><td>101</td><td>1001</td><td>700</td><td>2024-01-02</td></tr><tr><td>4</td><td>103</td><td>1003</td><td>200</td><td>2024-01-02</td></tr><tr><td>5</td><td>102</td><td>1002</td><td>400</td><td>2024-01-03</td></tr></tbody></table>

```
SELECT sale_id, product_id, sale_amount, 
       ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY sale_date) AS row_num
FROM sales;
```

#### Output:

| sale\_id | product\_id | sale\_amount | row\_num |
| -------- | ----------- | ------------ | -------- |
| 1        | 101         | 500          | 1        |
| 3        | 101         | 700          | 2        |
| 2        | 102         | 300          | 1        |
| 5        | 102         | 400          | 2        |
| 4        | 103         | 200          | 1        |

### **Calculating SUM() with PARTITION BY**

We want to calculate the total sales amount for each customer.

#### Table `sales`:

<table><thead><tr><th width="141">sale_id</th><th>product_id</th><th>customer_id</th><th>sale_amount</th><th>sale_date</th></tr></thead><tbody><tr><td>1</td><td>101</td><td>1001</td><td>500</td><td>2024-01-01</td></tr><tr><td>2</td><td>102</td><td>1002</td><td>300</td><td>2024-01-01</td></tr><tr><td>3</td><td>101</td><td>1001</td><td>700</td><td>2024-01-02</td></tr><tr><td>4</td><td>103</td><td>1003</td><td>200</td><td>2024-01-02</td></tr><tr><td>5</td><td>102</td><td>1002</td><td>400</td><td>2024-01-03</td></tr></tbody></table>

```
SELECT customer_id, sale_amount, 
       SUM(sale_amount) OVER (PARTITION BY customer_id) AS total_sales
FROM sales;
```

#### Output:

| customer\_id | sale\_amount | total\_sales |
| ------------ | ------------ | ------------ |
| 1001         | 500          | 1200         |
| 1001         | 700          | 1200         |
| 1002         | 300          | 700          |
| 1002         | 400          | 700          |
| 1003         | 200          | 200          |

### Example: Using `RANGE BETWEEN` with `SUM`

Sample Input

<figure><img src="../../../../../.gitbook/assets/image (393).png" alt="" width="489"><figcaption></figcaption></figure>

We want to calculate the cumulative sales amount within the last 90 days for each row.

```
SELECT
    sales_date,
    sales_amount,
    SUM(sales_amount) OVER (
        ORDER BY sales_date
        RANGE BETWEEN INTERVAL '90' DAY PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM
    sales;
```

<figure><img src="../../../../../.gitbook/assets/image (394).png" alt="" width="563"><figcaption></figcaption></figure>

### Example with `ROWS BETWEEN`

For considering the last 3 rows instead of a time interval, we would use `ROWS BETWEEN`

```
SELECT
    sales_date,
    sales_amount,
    SUM(sales_amount) OVER (
        ORDER BY sales_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM
    sales;
```

### Example using `PARTITION BY` with `RANGE`

We want to calculate cumulative sales within each year and the cumulative sales should be within the last 90 days for each year.

```
SELECT
    sales_date,
    sales_amount,
    SUM(sales_amount) OVER (
        PARTITION BY EXTRACT(YEAR FROM sales_date)
        ORDER BY sales_date
        RANGE BETWEEN INTERVAL '90' DAY PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM
    sales;
```

### Example using RATIO\_TO\_REPORT

Suppose we have a table `sales` with the following structure:

| product\_id | region\_id | sales\_amount |
| ----------- | ---------- | ------------- |
| 1           | 1          | 100           |
| 1           | 2          | 150           |
| 2           | 1          | 200           |
| 2           | 2          | 250           |

We want to calculate the ratio of each `sales_amount` to the total `sales_amount` for each `region_id`

```
SELECT
    product_id,
    region_id,
    sales_amount,
    RATIO_TO_REPORT(sales_amount) OVER (PARTITION BY region_id) AS ratio_to_total
FROM
    sales;
```

**Output**

| product\_id | region\_id | sales\_amount | ratio\_to\_total |
| ----------- | ---------- | ------------- | ---------------- |
| 1           | 1          | 100           | 0.3333           |
| 2           | 1          | 200           | 0.6667           |
| 1           | 2          | 150           | 0.3750           |
| 2           | 2          | 250           | 0.6250           |
