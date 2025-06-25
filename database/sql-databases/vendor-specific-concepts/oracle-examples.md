# Oracle Examples

## 1. Timestamp to readable format

Suppose we have `created_timestamp` column of type `NUMBER(38,0)` and represents a **Unix timestamp** (i.e., number of seconds since `1970-01-01 00:00:00 UTC`), we need to convert it to an Oracle `TIMESTAMP` to make it human-readable.



For values like `1748649600` (10 digits or less)

```sql
SELECT
  created_timestamp,
  TO_CHAR(
    (TIMESTAMP '1970-01-01 00:00:00 UTC' + NUMTODSINTERVAL(created_timestamp, 'SECOND')),
    'YYYY-MM-DD HH24:MI:SS'
  ) AS created_readable
FROM your_table;
```

If created\_timestamp is in milliseconds and for values like 1748649600000

```sql
SELECT
  created_timestamp,
  TO_CHAR(
    TIMESTAMP '1970-01-01 00:00:00 UTC' +
    NUMTODSINTERVAL(created_timestamp / 1000, 'SECOND'),
    'YYYY-MM-DD HH24:MI:SS'
  ) AS created_readable
FROM your_table;
```

