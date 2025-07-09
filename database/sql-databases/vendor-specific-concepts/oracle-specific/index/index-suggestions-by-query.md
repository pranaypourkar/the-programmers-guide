# Index Suggestions by Query

## About

This page is designed to help developers, DBAs, and data engineers analyze SQL queries and determine the most effective indexing strategies for performance optimization.\
It provides practical guidance on what types of indexes should be created based on the structure of a query, the WHERE clause, JOINs, ORDER BY, and GROUP BY conditions.

#### Query 1

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

