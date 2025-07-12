# Index Suggestions by Query

## About

This page is designed to help developers, DBAs, and data engineers analyze SQL queries and determine the most effective indexing strategies for performance optimization.\
It provides practical guidance on what types of indexes should be created based on the structure of a query, the WHERE clause, JOINs, ORDER BY, and GROUP BY conditions.

### Query 1

```sql
SELECT
    d.device_id         AS device_id,
    du.device_id        AS user_device_id,
    d.created_date_time AS device_created_time,
    du.login_date_time  AS user_login_time,
    du.user_id          AS user_id
FROM
    device d
    LEFT OUTER JOIN device_user du ON d.device_id = du.device_id
WHERE
    d.user_id = ?
ORDER BY
    du.login_date_time DESC NULLS LAST;
```

**On `device` table**

**a. Index on `user_id` column**

```sql
CREATE INDEX idx_device_userid ON device(user_id);
```

Reason: Helps with the `WHERE d.user_id = ?` condition.

**b. Composite index on `user_id` and `device_id` (optional)**

```sql
CREATE INDEX idx_device_userid_deviceid ON device(user_id, device_id);
```

Reason: Helps with both filtering and joining to `device_user`.

**On `device_user` table**

**a. Index on `device_id` column**

```sql
CREATE INDEX idx_deviceuser_deviceid ON device_user(device_id);
```

Reason: Improves performance of the join `ON d.device_id = du.device_id`.

**b. Composite index on `device_id` and `login_date_time`**

```sql
CREATE INDEX idx_deviceuser_deviceid_logindate ON device_user(device_id, login_date_time DESC);
```

Reason: Helps both the join and the `ORDER BY du.login_date_time DESC`

### Query 2

```
SELECT
    COUNT(logent0_.id) AS col_0_0_
FROM
    log_entry logent0_
WHERE
        logent0_.request_timestamp >= :1
    AND logent0_.request_timestamp <= :2
    AND logent0_.cif = :3
```

To optimize this query in Oracle, we should create indexes on the columns used in the `WHERE` clause to improve the performance of the filtering conditions.

#### **Suggested Indexes:**

1.  **Composite Index** _(Recommended)_

    ```sql
    CREATE INDEX idx_log_entry_cif_timestamp ON log_entry (cif, request_timestamp);
    ```

    * This will help optimize queries filtering by `cif` and `request_timestamp` together.
2.  **Alternative: Individual Indexes** _(If composite index is not possible)_

    ```sql
    CREATE INDEX idx_log_entry_long_cif ON log_entry (cif);
    CREATE INDEX idx_log_entry_timestamp ON log_entry (request_timestamp);
    ```

    * The optimizer may use both indexes for filtering, but a composite index is usually more efficient.

#### Does this order matters (cif, request\_timestamp) ?

Yes, the order of columns in a **composite index** matters because Oracle stores and searches the index in the order the columns are defined. The order impacts how the index is used in queries.

#### **Choosing the Right Order**

1. **Most Selective Column First**
   * If `cif` has **high cardinality** (many unique values), placing it first makes sense.
   * If `request_timestamp` is more selective (e.g., filtering for a small date range retrieves fewer rows), it might be better as the leading column.
2. **Query Usage Pattern**
   * Your query filters on `cif` **and** `request_timestamp`, so `(cif, request_timestamp)` is a good choice.
   * If you frequently query by `request_timestamp` **alone**, the index should be `(request_timestamp, cif)` for better efficiency.
3. **Index Range Scan Efficiency**
   * `(cif, request_timestamp)`: Optimized for queries that **start with `cif` in the `WHERE` clause\`**.
   * `(request_timestamp, cif)`: Better for queries primarily filtering by `request_timestamp`.

### Query 3

Using NVL(someColumn, 0) = 1 in where clause

Using `NVL(someColumn, 0) = 1` in a **WHERE** clause can negatively impact performance because it prevents Oracle from using an **index on `someColumn`** efficiently.

* **`NVL(someColumn, 0)` applies a function on the column**, making Oracle evaluate it for every row.
* This **disables index usage** unless we have a **function-based index**.

#### **Optimized Alternatives**

**1. Use `someColumn IS NULL OR someColumn = 1` (If NULLs Exist)**

Instead of:

```sql
WHERE NVL(someColumn, 0) = 1
```

Use:

```sql
WHERE someColumn = 1 OR someColumn IS NULL
```

**Benefits**:\
Uses index on `someColumn`\
Avoids function-based filtering

**2. Create a Function-Based Index (If NVL is Unavoidable)**

If `NVL(someColumn, 0)` is mandatory, create an **index that includes the function**:

```sql
CREATE INDEX idx_someColumn_nvl ON table_name (NVL(someColumn, 0));
```

**Benefits**:\
Oracle can use the index even with `NVL(someColumn, 0) = 1`.

**3. Store Defaults in the Table (Best for New Data)**

If `someColumn` has many NULLs but should default to `0`, consider:

*   **Updating existing rows**:

    ```sql
    UPDATE table_name SET someColumn = 0 WHERE someColumn IS NULL;
    ```
*   **Enforcing a default at the schema level**:

    ```sql
    ALTER TABLE table_name MODIFY someColumn DEFAULT 0;
    ```

This way, you can safely use:

```sql
WHERE someColumn = 1
```

### Query 4

Composite Index or Single Column Index in below query

```
SELECT
    COUNT(rangemen0_.id)
FROM
    rangement rangemen0_
WHERE
        rangemen0_.parent_id = :1
    AND ( rangemen0_.is_deleted = :"SYS_B_1"
          OR rangemen0_.is_deleted IS NULL );
```

We need to decide between:

1. **Index on `parent_id` only**
2. **Composite index on (`parent_id`, `is_deleted`)**

#### **Index on `parent_id` Only**

```sql
CREATE INDEX idx_rangement_parent ON rangement (parent_id);
```

**Pros:**

* Helps efficiently filter rows **by `parent_id`**.
* If `parent_id` has high selectivity (few matching rows), Oracle can **quickly fetch the relevant rows**.

**Cons:**

* **`is_deleted` filtering still requires a table scan** or post-filtering step.
* If `parent_id` returns a **large number of rows**, Oracle must still **filter `is_deleted` separately**, making the query slower.

**Best suited when**:

* `parent_id` **alone is highly selective** (e.g., fetching a few rows).
* `is_deleted` is **not used often in queries**.

#### **Composite Index on (`parent_id`, `is_deleted`)**

```sql
CREATE INDEX idx_rangement_parent_deleted ON rangement (parent_id, is_deleted);
```

**Pros:**

* **Oracle can filter on both `parent_id` and `is_deleted` directly** in an **INDEX RANGE SCAN**, avoiding unnecessary table scans.
* If `parent_id` fetches many rows, `is_deleted` filtering is **optimized at the index level**.
* Covers both **existing and future queries filtering `parent_id` and `is_deleted`**.

**Cons:**

* Slightly larger index size compared to a single-column index.

**Best suited when**:

* Queries frequently filter on both `parent_id` and `is_deleted`.
* `parent_id` retrieves **many rows**, and `is_deleted` helps narrow them down.

#### **Which One Should we Choose?**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Best Index Choice</strong></td></tr><tr><td>Query filters <strong>only <code>parent_id</code></strong></td><td><code>CREATE INDEX idx_rangement_parent (parent_id);</code></td></tr><tr><td>Query filters <strong>both <code>parent_id</code> and <code>is_deleted</code></strong> frequently</td><td><code>CREATE INDEX idx_rangement_parent_deleted (parent_id, is_deleted);</code></td></tr><tr><td><code>parent_id</code> retrieves <strong>many rows</strong>, but <code>is_deleted</code> significantly reduces them</td><td><strong>Composite index (<code>parent_id</code>, <code>is_deleted</code>)</strong> is better</td></tr><tr><td><code>parent_id</code> retrieves <strong>few rows</strong> (highly selective)</td><td>Index on <strong>just <code>parent_id</code></strong> is sufficient</td></tr></tbody></table>

### Query 5

```
SELECT
    userentity0_.username AS col_0_0_
FROM
         user_entity userentity0_
    INNER JOIN user_attribute userattrib1_ ON ( userentity0_.id = userattrib1_.user_id )
WHERE
    userattrib1_.value = '1311310003'
```

#### **Ensure Indexes on Join and Filter Conditions**

The biggest performance bottlenecks are:

* The **JOIN** on `userentity0_.id = userattrib1_.user_id`
* The **filter condition** `userattrib1_.value = '1311310003'`

**Recommended Indexes**

1.  **Index on `user_attribute.user_id` (helps JOIN performance)**

    ```sql
    CREATE INDEX idx_user_attribute_userid ON user_attribute(user_id);
    ```
2.  **Index on `user_attribute.value` (helps WHERE condition)**

    ```sql
    CREATE INDEX idx_user_attribute_value ON user_attribute(value);
    ```
3.  **Composite Index on (`value`, `user_id`)**

    ```sql
    CREATE INDEX idx_user_attribute_value_userid ON user_attribute(value, user_id);
    ```

    * This helps the **WHERE clause first**, then efficiently fetches `user_id`.
4.  **Ensure `user_entity.id` is the PRIMARY KEY**

    * If it's not indexed already:

    ```sql
    CREATE INDEX idx_user_entity_id ON user_entity(id);
    ```



