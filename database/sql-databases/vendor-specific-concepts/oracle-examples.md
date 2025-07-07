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

## 2. **Search records where `ext_id` has exactly 14 digits**

This ensures the `ext_id` has a **length of 14**:

**If `ext_id` is a `VARCHAR2`:**

```sql
SELECT *
FROM pqr
WHERE LENGTH(ext_id) = 14;
```

**If `ext_id` is a `NUMBER`:**

```sql
SELECT *
FROM pqr
WHERE LENGTH(TO_CHAR(ext_id)) = 14;
```

## **3. Ensure `ext_id` contains only digits 0–9**

We can use `REGEXP_LIKE` to verify the content:

**Works for both `VARCHAR2` or `NUMBER` (with conversion):**

```sql
SELECT *
FROM pqr
WHERE REGEXP_LIKE(TO_CHAR(ext_id), '^[0-9]+$');
```

## 4. Create a table with different column types

#### CLOB

```sql
CREATE TABLE my_table (
    id NUMBER,
    text_data CLOB
);
```

### 5. Get current timestamp

In Oracle, we can get the current timestamp using the `CURRENT_TIMESTAMP` function, which returns the current date and time including fractional seconds.

Here’s a basic example:

```sql
SELECT CURRENT_TIMESTAMP FROM dual;
```

If we need a specific format or to use it in a different way, we can use `SYSTIMESTAMP` as well:

```sql
SELECT SYSTIMESTAMP FROM dual;
```

* `CURRENT_TIMESTAMP` returns the current timestamp in the session’s timezone.
* `SYSTIMESTAMP` returns the current timestamp in the database timezone.



