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



