# Unusable Index

## Problem Statement

During runtime of select query with indexed column search, the following Oracle error was encountered:

{% code overflow="wrap" %}
```
ORA-01502: index 'CUSTOM_LOG.PK_LOG_ENTRY_IDX' or partition of such index is in unusable state
```
{% endcode %}

This error means that the index or one of its partitions is marked as **UNUSABLE** and cannot be used by the Oracle optimizer. Queries that rely on it may fail or degrade in performance.

{% code overflow="wrap" %}
```log
2025-03-24T19:46:10.856Z WARN  --- o.h.engine.jdbc.spi.SqlExceptionHelper : SQL Error: 1502, SQLState: 72000
2025-03-24T19:46:10.856Z ERROR --- o.h.engine.jdbc.spi.SqlExceptionHelper : ORA-01502: index 'CUSTOM_LOG.PK_LOG_ENTRY_IDX' or partition of such index is in unusable state
```
{% endcode %}

## Root Cause

The index became **UNUSABLE** because **some partitions were dropped** earlier. This broke the structural integrity of the index, especially if it's partitioned or dependent on the dropped segments.

Common causes include:

* Dropping or truncating table partitions.
* Moving or altering the base table.
* Bulk inserts using `APPEND` hint.
* Manual index-related DDL failures.

## Resolution: Rebuild the Index

### Rebuild the Index

Since this was a full index and not just one partition, we attempted a full rebuild:

```sql
ALTER INDEX CUSTOM_LOG.PK_LOG_ENTRY_IDX REBUILD;
```

This command:

* Recreates the index.
* Marks its state as `VALID`.
* Makes it available again for queries.

### Verification Steps

If we don't have access to `DBA_INDEXES`, we use **user-level views**.

#### 1. Check Index Status (Non-partitioned or Global Index)

```sql
SELECT INDEX_NAME, STATUS 
FROM USER_INDEXES 
WHERE INDEX_NAME = 'PK_LOG_ENTRY_IDX';
```

* `VALID` = the index is usable.
* `UNUSABLE` = the index is still broken.

#### 2. If Partitioned, Check Each Partition

```sql
SELECT INDEX_NAME, PARTITION_NAME, STATUS 
FROM USER_IND_PARTITIONS 
WHERE INDEX_NAME = 'PK_LOG_ENTRY_IDX';
```

If any rows return with `STATUS = 'UNUSABLE'`, rebuild that specific partition:

```sql
ALTER INDEX CUSTOM_LOG.PK_LOG_ENTRY_IDX REBUILD PARTITION <partition_name>;
```

### Confirm Index Usage in Queries

We can validate that the index is now used by Oracle in actual query plans:

```sql
EXPLAIN PLAN FOR 
SELECT * FROM CUSTOM_LOG WHERE <indexed_column> = 'some_value';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
```

Look for terms like:

* `INDEX RANGE SCAN`
* `INDEX UNIQUE SCAN`
