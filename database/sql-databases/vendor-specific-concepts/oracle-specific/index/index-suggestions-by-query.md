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





