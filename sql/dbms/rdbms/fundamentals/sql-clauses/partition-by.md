# PARTITION BY

## Description

Window functions, also known as analytic functions, are a powerful feature in SQL that allows to perform calculations across a set of table rows that are somehow related to the current row. This is different from regular aggregate functions which return a single aggregate value for a set of rows. Window functions retain the individual rows while calculating aggregates, ranks, running totals, or other calculations. The `PARTITION BY` clause is used within window functions to divide the result set into partitions to which the window function is applied.

{% hint style="info" %}
Window functions are not supported by all Database Management Systems (DBMS). Oracle, Microsoft SQL Server, MySQL, etc supports.
{% endhint %}

## Syntax

```
SELECT column1,
       window_function() OVER ([PARTITION BY partition_expression] [ORDER BY order_expression]) AS alias
FROM table_name;
```

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





















