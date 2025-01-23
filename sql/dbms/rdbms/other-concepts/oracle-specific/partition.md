# Partition

## About

Partitioning in Oracle is a database design technique that involves dividing a large table, index, or table-partitioned object into smaller, more manageable pieces, called **partitions**, while retaining it as a single logical entity. Each partition stores a subset of the data and can be managed and accessed individually, which improves performance, manageability, and scalability of large datasets.

{% hint style="info" %}
**How Partitioning Works?**

1. **Partition Key**: A column (or set of columns) is designated as the partition key to determine how the data is distributed across partitions.
2. **Storage**: Partitions can be stored in separate tablespaces, enabling storage optimization.
3. **Access**: Queries and DML (Data Manipulation Language) operations automatically identify the relevant partitions to work on, ensuring optimal performance.
{% endhint %}

{% hint style="success" %}
**Partition pruning** in Oracle works effectively when the partition key is included in the `WHERE` clause of the query. This ensures that Oracle can identify and access only the relevant partitions instead of scanning the entire table. Without referencing the partition key, Oracle cannot take full advantage of partitioning, and the query may need to scan all partitions.
{% endhint %}

## **Key Features**

1. **Logical Transparency**: To users and applications, a partitioned table appears as a single table.
2. **Partition Independence**: Each partition can be accessed and managed individually without affecting others.
3. **Automatic Pruning**: Oracle automatically determines which partitions to access based on query conditions, reducing the amount of data scanned.
4. **Partition-Wise Operations**: Queries, updates, and maintenance can be parallelized at the partition level.
5. **Data Organization**: Data is segmented based on business logic (e.g., time ranges, regions), improving query performance.

## **Types of Partitioning**

Oracle supports several types of partitioning.

### **1. Range Partitioning**

* Partitions data based on a range of values in a column (e.g., dates, numeric ranges).
* Commonly used for time-series data.

```sql
CREATE TABLE sales (
    sale_id NUMBER,
    sale_date DATE,
    amount NUMBER
)
PARTITION BY RANGE (sale_date) (
    PARTITION p_jan2025 VALUES LESS THAN (TO_DATE('2025-02-01', 'YYYY-MM-DD')),
    PARTITION p_feb2025 VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD')),
    PARTITION p_mar2025 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD'))
);
```

### **2. List Partitioning**

* Partitions data based on discrete values.
* Suitable for categorical data (e.g., regions, product categories).

```sql
CREATE TABLE customer_data (
    customer_id NUMBER,
    region VARCHAR2(50),
    data VARCHAR2(100)
)
PARTITION BY LIST (region) (
    PARTITION p_north VALUES ('NORTH'),
    PARTITION p_south VALUES ('SOUTH'),
    PARTITION p_east VALUES ('EAST'),
    PARTITION p_west VALUES ('WEST')
);
```

### **3. Hash Partitioning**

* Distributes rows across partitions using a hash function on a column value.
* Useful for evenly distributing data when partition key values are not sequential or range-based.

```sql
CREATE TABLE employees (
    emp_id NUMBER,
    department_id NUMBER,
    name VARCHAR2(100)
)
PARTITION BY HASH (department_id) PARTITIONS 4;
```

{% hint style="info" %}
One of the use case will be suppose the `employees` table is very large, and queries frequently filter by `department_id`. Using hash partitioning reduces the amount of data scanned for such queries.&#x20;

```sql
SELECT * FROM employees WHERE department_id = 10;
```

This query will only scan the partition that contains `department_id = 10`, not the entire table.
{% endhint %}

{% hint style="info" %}
* The `PARTITIONS 4` clause specifies that the table will be divided into 4 partitions. Each partition will store a subset of rows, aiming to distribute the rows approximately evenly across all partitions.
* When a new row is inserted, Oracle applies a hash function to the value of `department_id` in that row. The result of the hash function determines which of the 4 partitions the row will belong to.
* The hash value is mapped to a specific partition using modulo arithmetic:

Partition\_Number=(Hash\_Value mod  Number\_of\_Partitions) + 1

For example: If the hash value is `23` and there are 4 partitions, the partition number is:(23mod  4)+1=3 . This row would be placed in **Partition 3**.
{% endhint %}

### **4. Composite Partitioning**

* Combines two partitioning strategies, like range and hash or range and list.
* Useful for advanced use cases.

```sql
CREATE TABLE orders (
    order_id NUMBER,
    order_date DATE,
    region VARCHAR2(50)
)
PARTITION BY RANGE (order_date)
SUBPARTITION BY LIST (region) (
    PARTITION p_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION sp_north VALUES ('NORTH'),
        SUBPARTITION sp_south VALUES ('SOUTH')
    ),
    PARTITION p_2026 VALUES LESS THAN (TO_DATE('2027-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION sp_east VALUES ('EAST'),
        SUBPARTITION sp_west VALUES ('WEST')
    )
);
```

### **5. Interval Partitioning**

* Extends range partitioning by automatically creating new partitions as data arrives.
* Eliminates the need for manually creating partitions.

```sql
CREATE TABLE sales_data (
    sale_id NUMBER,
    sale_date DATE,
    amount NUMBER
)
PARTITION BY RANGE (sale_date) INTERVAL (NUMTOYMINTERVAL(1, 'MONTH')) (
    PARTITION p_initial VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
);
```

{% hint style="success" %}
`NUMTOYMINTERVAL` is a built-in Oracle SQL function used to create an **interval of time** in terms of **years** or **months**. It converts a numeric value into an interval datatype that represents either years or months, which is commonly used in partitioning or date/time arithmetic.

```sql
NUMTOYMINTERVAL(n, 'unit')
```

**Parameters:**

* **`n`**: A numeric value representing the quantity of the interval.
* **`unit`**: Specifies the type of interval. It must be one of the following:
  * `'YEAR'`: The interval represents a number of years.
  * `'MONTH'`: The interval represents a number of months.

Example -

SELECT NUMTOYMINTERVAL(1, 'YEAR') AS year\_interval FROM DUAL; //+01-00

SELECT NUMTOYMINTERVAL(6, 'MONTH') AS month\_interval FROM DUAL; //+00-06
{% endhint %}

{% hint style="info" %}
Partition Name Rules

1. **Explicit Partition**:
   *   The explicitly defined partition  (`p_initial`) will use the name provided in the `PARTITION` clause:

       ```sql
       PARTITION p_initial VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD'))
       ```
   * Partition name: **p\_initial**
2. **Automatically Created Partitions**:
   * Oracle assigns system-generated names to automatically created partitions for intervals.
   * These names usually follow a pattern like `SYS_P<number>`, where `<number>` is an auto-incremented value.
{% endhint %}

### **6. Reference Partitioning**

* Partitions a table based on the partitioning of a parent table in a foreign key relationship.
* Ensures related data is stored in the same partition.

```sql
CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE
)
PARTITION BY RANGE (order_date) (
    PARTITION p_jan VALUES LESS THAN (TO_DATE('2025-02-01', 'YYYY-MM-DD')),
    PARTITION p_feb VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD'))
);

CREATE TABLE order_items (
    order_id NUMBER,
    item_id NUMBER,
    quantity NUMBER,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
)
PARTITION BY REFERENCE (orders);
```

{% hint style="info" %}
* The `order_items` table inherits the partitioning scheme of the `orders` table.
* Each row in `order_items` is placed in the same partition as the corresponding row in the `orders` table based on the `order_id`
* Example - If an order with `order_date = '2025-01-15'` is stored in partition `p_jan`, all associated items in `order_items` will also go into `p_jan`.
{% endhint %}

### **7. System Partitioning**

* Allows manual assignment of data to partitions without any partition key.
* Rarely used as it requires custom logic for data insertion.

```sql
CREATE TABLE system_part_table (
    id NUMBER,
    data VARCHAR2(100)
)
PARTITION BY SYSTEM (
    PARTITION p1,
    PARTITION p2
);
```

## Querying a partitioned table

When querying a partitioned table in Oracle, we use a `SELECT` statement just as we would with a non-partitioned table. Oracle handles partition pruning and optimization internally, based on the query's filter conditioions. However, to make the most of partitioning, ensure our `SELECT` statement aligns with the partitioning column.

### Basic Usage

If our table is partitioned by a `DATE` column (e.g., `record_date`), we can query it like this:

```sql
SELECT *
FROM my_partitioned_table
WHERE record_date = TO_DATE('2025-01-15', 'YYYY-MM-DD');
```

{% hint style="info" %}
How It Works?&#x20;

**Partition Pruning**: Oracle will identify the relevant partition(s) based on the `record_date` condition and retrieve data only from those partitions. This improves query performance by avoiding a full table scan.
{% endhint %}

### Optimized Select Queries

* **Use Partition Key in WHERE Clause**: To enable partition pruning, include the partition key (e.g., `record_date`) in our `WHERE` clause:

```sql
SELECT *
FROM my_partitioned_table
WHERE record_date BETWEEN TO_DATE('2025-01-01', 'YYYY-MM-DD')
                      AND TO_DATE('2025-01-31', 'YYYY-MM-DD');
```

* **Query Specific Partitions (Optional)**: If we know the partition name and want to query it directly, use the `PARTITION` clause:

```sql
SELECT *
FROM my_partitioned_table PARTITION (p_jan_2025);
```

* **Avoid Functions on Partition Columns**: Using functions on the partitioning column can prevent partition pruning. For example, avoid this:

```sql
-- This may prevent pruning:
SELECT *
FROM my_partitioned_table
WHERE TRUNC(record_date) = TO_DATE('2025-01-15', 'YYYY-MM-DD');
```

Instead, rewrite the query to allow pruning:

```sql
SELECT *
FROM my_partitioned_table
WHERE record_date >= TO_DATE('2025-01-15', 'YYYY-MM-DD')
  AND record_date < TO_DATE('2025-01-16', 'YYYY-MM-DD');
```

* **Dynamic Range Queries**: If we need to fetch data for the current month dynamically, we can use Oracle's date functions:

```sql
SELECT *
FROM my_partitioned_table
WHERE record_date >= TRUNC(SYSDATE, 'MM') -- Start of the current month
  AND record_date < ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 1); -- Start of the next month
```



## Partition Management

### Check the partitions in the database

```sql
SELECT partition_name, high_value 
FROM user_tab_partitions 
WHERE table_name = 'MY_PARTITIONED_TABLE';
```

_Partition Creation_

_Since the DBA is manually creating new partitions each month, it's important that:_

* _The partition for the current month exists before your service tries to insert records with dates corresponding to that partition._
* _If the partition is missing, Oracle will throw an error (e.g., `ORA-14400: inserted partition key does not map to any partition`)._



## Performance Suggestions

* **Indexing**: If querying across multiple partitions, consider creating global or local indexes on frequently used columns to optimize performance.
* **Explain Plan**: Use `EXPLAIN PLAN` to check whether your query benefits from partition pruning:

```sql
EXPLAIN PLAN FOR
SELECT *
FROM my_partitioned_table
WHERE record_date = TO_DATE('2025-01-15', 'YYYY-MM-DD');

SELECT * FROM table(DBMS_XPLAN.DISPLAY);
```

## **Benefits of Partitioning**

1. **Improved Query Performance**: Partition pruning ensures that only the relevant partitions are scanned for queries, reducing I/O overhead.
2. **Scalability**: Large datasets are broken into smaller partitions, making them easier to manage.
3. **Enhanced Manageability**: Partitions can be added, dropped, or archived individually.
4. **Backup and Recovery**: Partitions stored in different tablespaces can be backed up and recovered independently.
5. **Parallel Processing**: Enables parallel execution of queries and operations across partitions.
6. **Data Lifecycle Management**: Makes it easy to manage "hot" (frequently accessed) and "cold" (historical) data using separate partitions.

