# Working with Multiple Tables

## Stacking One Rowset atop Another (Union All)

We want to return data stored in more than one table, conceptually stacking one result set atop the other. The tables do not necessarily have a common key, but their columns do have the same data types. For example

<figure><img src="../../../../.gitbook/assets/image (95).png" alt="" width="199"><figcaption></figcaption></figure>

```
select ename as ename_and_dname, deptno from emp where deptno = 10
union all
select '----------', null from t1
union all
select dname, deptno from dept;
```

{% hint style="info" %}
UNION ALL will include duplicates if they exist. If we want to filter out duplicates, use the UNION operator. It uses distinct to filter duplicate record.
{% endhint %}

## Joins

Joins are used to combine data from multiple tables based on a related column. They allow you to retrieve comprehensive information that spans across different tables.

### Types of Joins

#### **Inner Join (Simple Join):**

Returns rows where there's a match in the join condition between the tables.

```
SELECT *
FROM table1
INNER JOIN table2 ON table1.column_name = table2.column_name;
```

**Example:** Find all orders (Orders table) with customer details (Customers table) based on matching customer IDs.

```
SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;
```

{% hint style="info" %}
The conditions\
`Orders.CustomerID = Customers.CustomerID` and `Customers.CustomerID = Orders.CustomerID` are equivalent and will produce the same results.

However, there can be subtle performance differences in certain scenarios depending on the optimizer's strategy. While both conditions are functionally equivalent, the order you choose might influence how the optimizer decides to access the tables and perform the join. In most cases, these differences are negligible.

It's generally considered good practice to write the join condition in a way that reads more naturally, often placing the table with the primary key (assumed to be Customers in this case) on the left side of the comparison. For complex joins with multiple conditions, the order of comparisons within the ON clause can become more relevant for optimization.
{% endhint %}

