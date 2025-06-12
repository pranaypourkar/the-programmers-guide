# KEEP

## Description

While "KEEP" itself isn't a standalone function or clause in Oracle, it plays a crucial role in how certain aggregate functions interact with the `ORDER BY` clause. The `KEEP` in Oracle is used with aggregate functions to retain specific rows of data based on a given condition. It is typically used in conjunction with `DENSE_RANK` or `RANK` within an `AGGREGATE FUNCTION ... KEEP (DENSE_RANK ... ORDER BY ...)` construct.

## **Syntax**

```sql
AGGREGATE_FUNCTION (expression) KEEP (DENSE_RANK [FIRST|LAST] ORDER BY expression [ASC|DESC])
```

* **AGGREGATE\_FUNCTION :** This is the function we're using, like `MIN`, `MAX`, `SUM`, etc.
* **expression:** The column on which the aggregate function operates.
* **KEEP:** Keyword indicating you want to keep a specific value after sorting.
* **ranking\_function:** This can be `DENSE_RANK` or `RANK`, which assign ranking positions to rows based on the sorting criteria.
  * `DENSE_RANK`: Assigns consecutive ranks without gaps, even if there are ties.
  * `RANK`: Assigns ranks with gaps for ties (e.g., two employees with the same salary might get the same rank).
* **ORDER BY sort\_column:** This specifies the column used for sorting the rows before keeping the desired value.

{% hint style="info" %}
**KEEP FIRST vs. KEEP LAST:**

The `KEEP` keyword is followed by either `FIRST` or `LAST` to determine which row's value to retain after sorting:

* **KEEP FIRST:** This keeps the value from the row with the **lowest** rank (according to the ranking function).
* **KEEP LAST:** This keeps the value from the row with the **highest** rank (according to the ranking function).
{% endhint %}

## **Example**

### Sales Data

Suppose we have a `sales` table with `product_id`, `sale_date`, and `sale_amount`, and want to find the highest sale amount and the date it occurred for each product.

```sql
SELECT
    product_id,
    MAX(sale_amount) AS max_sale_amount,
    MAX(sale_date) KEEP (DENSE_RANK FIRST ORDER BY sale_amount DESC) AS sale_date_of_max_amount
FROM
    sales
GROUP BY
    product_id;
```

In this example:

* `MAX(sale_amount)` retrieves the maximum sale amount for each product.
* `MAX(sale_date) KEEP (DENSE_RANK FIRST ORDER BY sale_amount DESC)` fetches the sale date associated with the highest sale amount for each product.

### Employee Data

Finding the employee with the lowest salary within each department, while also considering their commission percentage.

```
SELECT department_id, 
    MIN(salary) KEEP (DENSE_RANK FIRST ORDER BY commission_pct) AS lowest_paid_by_commission
FROM employees
GROUP BY department_id;
```

This query:

1. Calculates the minimum salary (`MIN(salary)`) for each department.
2. Sorts employees within each department by their commission percentage (`ORDER BY commission_pct`).
3. Uses `KEEP (DENSE_RANK FIRST ORDER BY commission_pct)` to ensure the minimum salary is retrieved from the employee with the **lowest** commission percentage (**FIRST**) within each department.



