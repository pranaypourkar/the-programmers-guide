# Rownum vs Rowid

## What is ROWID ?

* ROWID is a pseudo column in a table which store and return row address in HEXADECIMAL format with database tables. ROWID is the permanent unique identifiers for each row in the database
* ROWID consists of 18 character string with the format. BBBBBBBBB.RRRR.FFFF Where B is Block, R is Row, F is FIle

{% hint style="info" %}
**What is pseudocolumn ?**

A pseudocolumn behaves like a table column, but is not actually stored in the table. We can select from pseudocolumns, but cannot insert, update, or delete their values
{% endhint %}

An example query would be:

```
SELECT ROWID, first_name  
   FROM employees
   WHERE department_id = 30;
```

* A user can access a row quickly and easily using its row ID.
* ROWID can also be used to delete the duplicate records from a tame

## What is ROWNUM ?

* For each row returned by a query, the ROWNUM pseudo column returns a number which indicates the order in which a row was selected from a table. For example, the 1st row gets the number 1, 2nd gets the number 2 and so on.
* ROWNUM can be used to limit the number of rows returned by a query, as shown in the example below:

```
SELECT * FROM employees WHERE ROWNUM < 10;
```

* The row numbers of the records might change if order by clause is used in the query.
* ROWNUM can also be used for assigning unique values for every row in a table.
* The user can also use ROWNUM to present the dataset in a report with serial numbers.

<figure><img src="../../../../../.gitbook/assets/image (5) (1) (1) (1) (1).png" alt="" width="488"><figcaption></figcaption></figure>

