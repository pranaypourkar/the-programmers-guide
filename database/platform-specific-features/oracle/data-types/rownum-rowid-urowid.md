# Rownum, Rowid, Urowid

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

## What is UROWID ?

`UROWID` (Universal ROWID) is a **data type in Oracle** used to store the **address (location) of a row** in the database. It represents the **physical or logical address** of a row in a table and is primarily used when dealing with tables that use **rowid-based addressing**, including those with **index-organized tables (IOTs)** or **foreign tables** (like those accessed via Oracle's object-relational features).

The main purpose of `UROWID` is to provide a **uniform way to store any type of rowid**, including those from:

* Heap-organized tables (`ROWID`)
* Index-organized tables
* External tables
* Tables from remote or non-Oracle systems (via gateways)

It generalizes the older `ROWID` datatype, which only works with heap tables.

{% hint style="info" %}
Limitations

* `UROWID` values are mostly meaningful internally to Oracle.
* Cannot use `UROWID` to retrieve a row from a table unless the value was originally obtained from that specific table type.
* Comparing UROWIDs across different tables is generally not meaningful.
{% endhint %}

#### Declaration Example

```sql
DECLARE
    my_rowid UROWID;
BEGIN
    SELECT rowid INTO my_rowid FROM employees WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('Row ID: ' || my_rowid);
END;
```

Here, `rowid` is stored into a variable of type `UROWID`.

#### Using UROWID in a Table

```sql
CREATE TABLE rowid_tracker (
    id NUMBER PRIMARY KEY,
    ref_id UROWID
);
```

We can store the `UROWID` of a row in this table for reference or auditing purposes.

```sql
INSERT INTO rowid_tracker (id, ref_id)
SELECT 1, rowid FROM employees WHERE employee_id = 100;
```

#### Retrieving UROWID

```sql
SELECT ref_id FROM rowid_tracker;
```

## Row Identifiers – Comparison Table

{% hint style="info" %}
* **ROWNUM**: Use it when we want to **limit results**, like "first N rows".
* **ROWID**: Use it when we want to **identify and access a specific row** physically (heap-organized tables only).
* **UROWID**: Use it when dealing with **index-organized, foreign, or logical rows**; it's **more flexible** than `ROWID`.
{% endhint %}

<table data-header-hidden data-full-width="true"><thead><tr><th width="149.37890625"></th><th width="152.40625"></th><th width="214.796875"></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><code>ROWNUM</code></td><td><code>ROWID</code></td><td><code>UROWID</code></td></tr><tr><td><strong>Type</strong></td><td>Pseudocolumn</td><td>Pseudocolumn / Data type</td><td>Data type</td></tr><tr><td><strong>Meaning</strong></td><td>Returns the position of a row in query result</td><td>Physical address of a row in a heap-organized table</td><td>Logical address of a row (works for all table types)</td></tr><tr><td><strong>Data Type</strong></td><td>Number (generated per query)</td><td>VARCHAR2 (usually 18 characters, base64-encoded)</td><td>VARCHAR2 (variable length, up to 4000 bytes)</td></tr><tr><td><strong>Usage Scope</strong></td><td>Used to limit rows in result sets</td><td>Can be used to uniquely identify and fetch rows</td><td>Generalized form of <code>ROWID</code>, supports IOTs, foreign tables</td></tr><tr><td><strong>Persistence</strong></td><td>Exists only during a query execution</td><td>Permanently associated with a row in a heap table</td><td>Can store logical row addresses across table types</td></tr><tr><td><strong>Modifiable</strong></td><td>No</td><td>No</td><td>Can be stored as a column or variable</td></tr><tr><td><strong>Used In WHERE?</strong></td><td>Yes, e.g. <code>WHERE ROWNUM &#x3C;= 10</code></td><td>Yes, e.g. <code>WHERE ROWID = 'AAAC3zAABAAAYz9AAA'</code></td><td>Yes, e.g. <code>WHERE some_urowid_column = :val</code></td></tr><tr><td><strong>Index Support</strong></td><td>No</td><td>Indexed indirectly (via row structure)</td><td>No direct index, but can be compared or stored</td></tr><tr><td><strong>Applicable Tables</strong></td><td>All SQL queries</td><td>Heap-organized tables only</td><td>All table types (heap, IOT, external, remote)</td></tr><tr><td><strong>Example Use</strong></td><td><code>SELECT * FROM emp WHERE ROWNUM = 1</code></td><td><code>SELECT * FROM emp WHERE ROWID = 'AAAC...'</code></td><td><code>SELECT * FROM emp_audit WHERE row_ref = :urowid_val</code></td></tr><tr><td><strong>Readability</strong></td><td>Simple integer</td><td>Encoded string (base64-like)</td><td>Longer encoded string (can exceed ROWID length)</td></tr><tr><td><strong>Introduced In</strong></td><td>Early Oracle versions</td><td>Original Oracle versions</td><td>Oracle 9i onwards</td></tr></tbody></table>

## Example

```sql
-- Use ROWNUM to get first 5 employees
SELECT * FROM employees WHERE ROWNUM <= 5;

-- Use ROWID to fetch a row by physical ID
SELECT * FROM employees WHERE ROWID = 'AAAFfZAAFAAAACHAAA';

-- Declare and store UROWID from index-organized table
DECLARE
  my_rowid UROWID;
BEGIN
  SELECT rowid INTO my_rowid FROM iot_table WHERE id = 1;
  DBMS_OUTPUT.PUT_LINE(my_rowid);
END;
```





