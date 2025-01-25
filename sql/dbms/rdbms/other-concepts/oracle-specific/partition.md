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
    PARTITION p_feb2025 VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD'))
);

ALTER TABLE sales
ADD PARTITION p_mar2025 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD'));
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
    PARTITION p_west VALUES ('WEST')
);

ALTER TABLE customer_data
ADD PARTITION p_east VALUES ('EAST');
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

// We cannot simply add a new partition, but can split existing partitions to increase the total number
ALTER TABLE employees SPLIT PARTITION FOR (1);
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

ALTER TABLE orders
ADD SUBPARTITION sp_east_jan2025 VALUES ('EAST');
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

ALTER TABLE orders
ADD PARTITION p_april VALUES LESS THAN (TO_DATE('2025-05-01', 'YYYY-MM-DD'));
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

## Partition Maintenance

### Check the partitions in the database

```sql
SELECT partition_name, high_value 
FROM user_tab_partitions 
WHERE table_name = 'MY_PARTITIONED_TABLE';
```

### Dropping a partition

When we drop a partition from a partitioned table, only the partition and its data are removed. The tablespace in which the partition was stored remains intact and can still hold other data, objects, or partitions.

**Example:** Suppose we have a table with range partitions, and each partition is stored in a different tablespace

```sql
CREATE TABLE sales (
    sale_id NUMBER,
    sale_date DATE
)
PARTITION BY RANGE (sale_date) (
    PARTITION p_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')) 
    TABLESPACE ts_2024,
    PARTITION p_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')) 
    TABLESPACE ts_2025
);
```

If we drop the `p_2024` partition:

```sql
ALTER TABLE sales DROP PARTITION p_2024;
```

* The data and metadata associated with the `p_2024` partition will be removed.&#x20;
* The tablespace `ts_2024` will **not** be dropped. It remains available for use by other objects or partitions.
* Once a partition is dropped, the data in that partition is permanently deleted, and reusing the same tablespace does not bring the data back. If we later attach the same tablespace to a new partition, it is treated as a new and empty storage area. The data previously stored in the dropped partition is not retained or restored.

{% hint style="info" %}
**Manual Cleanup**: If we want to completely remove the tablespace (and it's no longer needed for other objects), you can drop the tablespace manually:

```sql
DROP TABLESPACE ts_2024 INCLUDING CONTENTS AND DATAFILES;
```
{% endhint %}

### **Partition Must Exist for the Data**

If the DBA is manually creating new partitions each month, it's important that:

* The partition for the current month exists before our service tries to insert records with dates corresponding to that partition.
* If the partition is missing, Oracle will throw an error (e.g., `ORA-14400: inserted partition key does not map to any partition`).

## How Tablespaces Work with Partitions?

When we create partitions in a table, we can specify a **tablespace** for each partition. This allows us to distribute the data for different partitions across multiple tablespaces and physical storage devices.

{% hint style="success" %}
A **tablespace** is a logical storage unit in an Oracle database. It is used to organize and manage the physical storage of data. Tablespaces group together related database objects, such as tables, indexes, and partitions, and map them to one or more physical files called **datafiles**.

1. A tablespace can contain multiple datafiles, and each datafile is a physical file on the disk.
2. A database can have multiple tablespaces to separate and organize data logically.
3. Tablespaces make it easier to manage storage, control disk space usage, and optimize performance.
{% endhint %}

{% hint style="info" %}
When we create a table with a custom tablespace and then create partitions with a different tablespace, the behavior is as follows:

1. The **table-level tablespace** acts as the **default tablespace** for all partitions if no explicit tablespace is provided for the partitions.
2. If we explicitly specify a different tablespace for a partition, that partition will be stored in the specified tablespace, overriding the table-level default.
{% endhint %}

### **Specifying Tablespaces for Partitions**

When creating a partitioned table, we can assign each partition to a specific tablespace using the `TABLESPACE` clause.

#### **Example: Range Partitioning with Tablespaces**

```sql
CREATE TABLE sales (
    sale_id NUMBER,
    sale_date DATE,
    amount NUMBER
)
PARTITION BY RANGE (sale_date) (
    PARTITION p_jan2025 VALUES LESS THAN (TO_DATE('2025-02-01', 'YYYY-MM-DD')) TABLESPACE ts_january,
    PARTITION p_feb2025 VALUES LESS THAN (TO_DATE('2025-03-01', 'YYYY-MM-DD')) TABLESPACE ts_february,
    PARTITION p_mar2025 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD')) TABLESPACE ts_march
);
```

Here:

* Partition `p_jan2025` is stored in tablespace `ts_january`.
* Partition `p_feb2025` is stored in tablespace `ts_february`.
* Partition `p_mar2025` is stored in tablespace `ts_march`.

#### **Example: Hash Partitioning with Tablespaces**

For hash-partitioned tables, we can distribute partitions across multiple tablespaces:

```sql
CREATE TABLE employees (
    emp_id NUMBER,
    department_id NUMBER,
    name VARCHAR2(100)
)
PARTITION BY HASH (department_id) PARTITIONS 4
STORE IN (ts_part1, ts_part2, ts_part3, ts_part4);
```

Here:

* The hash partitions are automatically distributed across the tablespaces `ts_part1`, `ts_part2`, `ts_part3`, and `ts_part4`.

#### **Example: Composite Partitioning with Tablespaces**

For composite partitioning (e.g., range and list), we can specify tablespaces for subpartitions:

```sql
CREATE TABLE orders (
    order_id NUMBER,
    sale_date DATE,
    region VARCHAR2(50)
)
PARTITION BY RANGE (sale_date)
SUBPARTITION BY LIST (region) (
    PARTITION p_2025 VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION sp_north TABLESPACE ts_north,
        SUBPARTITION sp_south TABLESPACE ts_south
    ),
    PARTITION p_2026 VALUES LESS THAN (TO_DATE('2027-01-01', 'YYYY-MM-DD')) (
        SUBPARTITION sp_east TABLESPACE ts_east,
        SUBPARTITION sp_west TABLESPACE ts_west
    )
);
```

### **Managing Tablespaces for Partitions**

* **Checking Partition Tablespaces**: To see which tablespace a partition is stored in:

```sql
SELECT partition_name, tablespace_name
FROM user_tab_partitions
WHERE table_name = 'SALES';
```

* **Moving Partitions to a New Tablespace**: We can move a partition to a different tablespace using `ALTER TABLE`.

```sql
ALTER TABLE sales
MOVE PARTITION p_jan2025 TABLESPACE ts_new_january;
```

* **Dropping a Tablespace**: If a tablespace is no longer needed, ensure it does not contain any partitions before dropping it:

```sql
DROP TABLESPACE ts_february INCLUDING CONTENTS AND DATAFILES;
```

* **Resizing Tablespace**: If a tablespace is running out of space, we can add more datafiles or resize existing ones:

```sql
ALTER DATABASE DATAFILE '/path/to/datafile.dbf' RESIZE 1G;
```

### **Benefits of Using Tablespaces with Partitions:**

1. **Data Distribution**: Store different partitions on different disks for better I/O performance.
2. **Storage Management**: Allocate specific storage resources for partitions with high data growth.
3. **Backup and Recovery**: Manage backups at the tablespace level for specific partitions.
4. **Performance Optimization**: Reduce contention and improve query performance by isolating partitions

## Best practices to follow for partitions

Partitioning in Oracle databases is a powerful feature that improves performance, manageability, and scalability.

### **1. Design Partitions Based on Access Patterns**

* **Understand Query Patterns**: Partition the table using the column most frequently used in filters or joins (e.g., `sale_date` for time-based queries).
* **Avoid Over-Partitioning**: Keep the number of partitions manageable. Too many partitions can lead to overhead in metadata management.

**Example:**

For a sales table, if most queries are time-based (e.g., monthly sales), use **Range Partitioning** on the `sale_date` column.

```sql
PARTITION BY RANGE (sale_date)
```

### **2. Choose the Right Partitioning Strategy**

Select the appropriate partitioning type based on your data and requirements:

* **Range Partitioning**: For sequential data, such as dates.
* **List Partitioning**: For specific categories, such as regions or product types.
* **Hash Partitioning**: To distribute data evenly when values are unpredictable (e.g., customer IDs).
* **Composite Partitioning**: Combine strategies (e.g., range and hash) for better granularity.

### **3. Partition Key Selection**

* Use a **highly selective column** (a column with diverse values) as the partition key.
* Avoid frequently updated columns as partition keys to minimize maintenance overhead.
* Ensure the partition key aligns with your business logic (e.g., partitions by region for regional sales data).

### **4. Use Tablespaces Effectively**

* **Distribute Partitions Across Tablespaces**: Spread partitions across different tablespaces for better I/O performance.
* **Separate Hot and Cold Data**: Use faster storage for current (hot) partitions and slower storage for historical (cold) partitions.

**Example:**

```sql
PARTITION BY RANGE (sale_date) (
    PARTITION p_2025 TABLESPACE ts_fast_storage,
    PARTITION p_2024 TABLESPACE ts_slow_storage
);
```

### **5. Manage Partition Growth**

* Plan for future data growth by pre-creating partitions or using **interval partitioning**.
* For example, automatically create monthly partitions:

```sql
PARTITION BY RANGE (sale_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
```

### **6. Partition Pruning**

Ensure queries benefit from **partition pruning** by including the partition key in WHERE clauses. This avoids scanning unnecessary partitions.

**Example:**

Good Query (Uses Partition Pruning):

```sql
SELECT * FROM sales WHERE sale_date >= TO_DATE('2025-01-01', 'YYYY-MM-DD');
```

Bad Query (No Partition Pruning):

```sql
SELECT * FROM sales WHERE TO_CHAR(sale_date, 'YYYY-MM') = '2025-01';
```

### **7. Use Global and Local Indexes Appropriately**

* **Local Indexes**: Partitioned indexes align with table partitions and improve partition-specific queries.
* **Global Indexes**: Use for queries spanning multiple partitions but require additional maintenance.

### **8. Partition Maintenance**

* **Add/Drop Partitions**: Manage historical or new data by adding or dropping partitions as needed.

```sql
ALTER TABLE sales ADD PARTITION p_2026 VALUES LESS THAN (TO_DATE('2027-01-01', 'YYYY-MM-DD'));
ALTER TABLE sales DROP PARTITION p_2023;
```

* **Merge Small Partitions**: Consolidate small partitions to reduce metadata overhead.

```sql
ALTER TABLE sales MERGE PARTITIONS p_2023, p_2024 INTO PARTITION p_2023_2024;
```

### **9. Monitor Partition Usage**

* Use `DBA_TAB_PARTITIONS` and `DBA_TAB_SUBPARTITIONS` views to monitor partition sizes and data distribution.
* Regularly check tablespace usage and adjust tablespaces if necessary.

### **10. Drop Unused Partitions**

Remove partitions with outdated or unnecessary data to reclaim storage space:

```sql
ALTER TABLE sales DROP PARTITION p_2015;
```

## **Benefits of Partitioning**

1. **Improved Query Performance**: Partition pruning ensures that only the relevant partitions are scanned for queries, reducing I/O overhead.
2. **Scalability**: Large datasets are broken into smaller partitions, making them easier to manage.
3. **Enhanced Manageability**: Partitions can be added, dropped, or archived individually.
4. **Backup and Recovery**: Partitions stored in different tablespaces can be backed up and recovered independently.
5. **Parallel Processing**: Enables parallel execution of queries and operations across partitions.
6. **Data Lifecycle Management**: Makes it easy to manage "hot" (frequently accessed) and "cold" (historical) data using separate partitions.

