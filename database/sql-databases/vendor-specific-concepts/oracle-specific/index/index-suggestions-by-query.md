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

### Query 6

```
SELECT
    COUNT(DISTINCT case0_.ecase_key) AS col_0_0_
FROM
    eflow_case case0_
WHERE
        case0_.ecase_definition_schema_id = 'dummy'
    AND case0_.ecase_definition_schema_version = 4
    AND case0_.epreliminary = 0
    AND case0_.earchived = 0
```

Query is counting **distinct** `case_key` values based on several filtering conditions.

#### **Ensure we Have the Right Indexes**

*   The `WHERE` conditions suggest that the following **composite index** could be beneficial:

    ```sql
    CREATE INDEX idx_flw_case_filters 
    ON eflow_case (ecase_definition_schema_id, ecase_definition_schema_version, epreliminary, earchived, ecase_key);
    ```

    **Why?**

    * The index covers all filtering conditions, improving lookup efficiency.
    * Including `ecase_key` in the index helps with the `DISTINCT` count.
*   If **`ecase_key` is already unique**, we may only need:

    ```sql
    CREATE INDEX idx_flw_case_filters 
    ON eflow_case (ecase_definition_schema_id, ecase_definition_schema_version, epreliminary, earchived);
    ```

    * This ensures efficient filtering, and `DISTINCT` will have fewer rows to process.

### Query 7

```
SELECT
    COUNT(case0_.ecase_key) AS col_0_0_
FROM
         eflow_case case0_
    INNER JOIN eflow_case_def casedefini1_ ON case0_.ecase_definition_schema_id = casedefini1_.eschema_id
                                            AND case0_.ecase_definition_schema_version = casedefini1_.eschema_version
WHERE
        casedefini1_.eschema_id = 'dummy'
    AND casedefini1_.eschema_version = '40'
    AND case0_.ecreated_date > TO_TIMESTAMP('2023-08-07 08:21:15.497369', 'YYYY-MM-DD HH24:MI:SS.FF6')
    AND case0_.earchived = 0
```

```
| Id  | Operation          | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
-------------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |          |     1 |    14 |  4425   (1)| 00:00:01 |
|   1 |  SORT AGGREGATE    |          |     1 |    14 |            |          |
|*  2 |   TABLE ACCESS FULL| EFLOW_CASE |   400 |  5600 |  4425   (1)| 00:00:01 |
    
```

* The `JOIN` condition is on `schema_id` and `schema_version`, so this helps in lookups.

#### **Suggested Indexes**

#### **Composite Index on `FLW_CASE`**

Create an index covering the `WHERE` clause conditions:

```sql
CREATE INDEX idx_flw_case_optimization
ON flw_case (archived, created_date, case_definition_schema_id, case_definition_schema_version);
```

**Why?**

* `archived` is a filtering condition (`= 0`), which makes it a good leading column.
* `created_date` has a range condition (`> TO_TIMESTAMP(...)`), so it should be next.
* `case_definition_schema_id` and `case_definition_schema_version` help with the join.

#### **Index on `FLW_CASE_DEF`**

To speed up the `JOIN`, create an index on `FLW_CASE_DEF`:

```sql
CREATE INDEX idx_flw_case_def
ON flw_case_def (schema_id, schema_version);
```

**Why?**

* The `JOIN` condition is on `schema_id` and `schema_version`, so this helps in lookups.

**Optimized Query**

After creating indexes, rewrite the query to encourage **INDEX RANGE SCAN**:

```sql
SELECT /*+ INDEX(case0_ idx_flw_case_optimization) */
    COUNT(case0_.ecase_key) AS col_0_0_
FROM eflow_case case0_
INNER JOIN eflow_case_def casedefini1_ 
    ON case0_.ecase_definition_schema_id = casedefini1_.eschema_id
    AND case0_.ecase_definition_schema_version = casedefini1_.eschema_version
WHERE casedefini1_.eschema_id = 'dummy'
AND casedefini1_.eschema_version = '4'
AND case0_.ecreated_date > TO_TIMESTAMP('2023-08-07 08:21:15.497369', 'YYYY-MM-DD HH24:MI:SS.FF6')
AND case0_.earchived = 0;
```

**Why Use a Hint (`/*+ INDEX(...) */`)?**

* Forces Oracle to use the index (`idx_flw_case_optimization`), helping in query optimization

### Query 8

```
SELECT
    casestatus1_.estatus_value AS col_0_0_,
    COUNT(case0_.ecase_key)    AS col_1_0_
FROM
    eflow_case        case0_
    LEFT OUTER JOIN eflow_case_status casestatus1_ ON case0_.ecase_key = casestatus1_.ecase_key
WHERE
        case0_.ecase_definition_schema_id = 'dummy'
    AND case0_.ecase_definition_schema_version = 40
    AND casestatus1_.estatus_name = 'status'
    AND case0_.ecreated_date > TO_TIMESTAMP('2023-08-07 08:21:15.497369', 'YYYY-MM-DD HH24:MI:SS.FF6')
    AND case0_.earchived = 0
    AND case0_.epreliminary = 0
GROUP BY
    casestatus1_.estatus_value
```

```
| Id  | Operation                     | Name               | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |                      |     4 |   536 |  4530   (1)| 00:00:01 |
|   1 |  HASH GROUP BY                |                      |     4 |   536 |  4530   (1)| 00:00:01 |
|   2 |   NESTED LOOPS                |                      |   236 | 31624 |  4529   (1)| 00:00:01 |
|   3 |    NESTED LOOPS               |                      |   236 | 31624 |  4529   (1)| 00:00:01 |
|*  4 |     TABLE ACCESS FULL         | EFLOW_CASE           |   236 | 15812 |  4425   (1)| 00:00:01 |
|*  5 |     INDEX UNIQUE SCAN         | PK_FLW_CASE_STATUS   |     1 |       |     0   (0)| 00:00:01 |
|   6 |    TABLE ACCESS BY INDEX ROWID| EFLOW_CASE_STATUS    |     1 |    67 |     1   (0)| 00:00:01 |
```

#### **Suggested Indexes**

#### **Composite Index on `EFLOW_CASE`**

Create a composite index covering the `WHERE` clause conditions:

```sql
CREATE INDEX idx_flw_case_query 
ON eflow_case (earchived, epreliminary, ecreated_date, ecase_definition_schema_id, ecase_definition_schema_version);
```

**Why?**

* `earchived` and `epreliminary` are filtering conditions (`= 0`), so they should be **leading columns**.
* `ecreated_date` has a **range filter (`> TO_TIMESTAMP(...)`)**, making it the next best column.
* `ecase_definition_schema_id` and `ecase_definition_schema_version` **help with lookups**.

#### **Index on `EFLOW_CASE_STATUS`**

Create an index on `eflow_case_status` to speed up the `JOIN`:

```sql
CREATE INDEX idx_flw_case_status
ON eflow_case_status (ecase_key, estatus_name, estatus_value);
```

**Why?**

* `ecase_key` is used in the `JOIN` condition.
* `estatus_name = 'status'` is **highly selective**, making it a good column to include.
* `estatus_value` is being **grouped**, so including it avoids extra lookups.

### Query 9

```
SELECT
    case0_.ecase_key                       AS case_key1_1_,
    case0_.earchived                       AS archived2_1_,
    case0_.ecase_data                      AS case_data3_1_,
    case0_.ecase_definition_schema_id      AS case_definition_s10_1_,
    case0_.ecase_definition_schema_version AS case_definition_s11_1_,
    case0_.ecreated_date                   AS created_date4_1_,
    case0_.elast_modified_by               AS last_modified_by5_1_,
    case0_.elast_modified_date             AS last_modified_date6_1_,
    case0_.epreliminary                    AS preliminary7_1_,
    case0_.etitle                          AS title8_1_,
    case0_.eversion                        AS version9_1_
FROM
    eflow_case case0_
WHERE
        case0_.epreliminary = 0
    AND case0_.ecreated_date < TO_TIMESTAMP('2023-08-07 08:21:15.497369', 'YYYY-MM-DD HH24:MI:SS.FF6');
```

#### **Suggested Index**

Since we are filtering by **`ecreated_date`**, a good index to improve query performance is:

```sql
CREATE INDEX idx_flw_case_created_date
ON eflow_case (ecreated_date);
```

**Why?**

* `ecreated_date` is used in a **range condition (`< TO_TIMESTAMP(...)`)**, so indexing it helps **avoid full table scans**.

#### Query 10

```
SELECT DISTINCT
    party0_.id          AS col_0_0_,
    lower(party0_.name) AS col_1_0_
FROM
         user_party party0_
    INNER JOIN user_account_information accounts1_ ON party0_.id = accounts1_.party_id
WHERE
    ( party0_.service_agreement_id = '189'
      AND party0_.access_context_scope = 0
      OR party0_.legal_entity_id = '183'
      AND party0_.access_context_scope = 0
      OR party0_.bb_id = '612a77f7-4d76-4bd3-a299-076fb7c9bed4'
      AND party0_.access_context_scope = 0 )
    AND ( lower(party0_.name) LIKE 's sc om ch'
          OR lower(party0_.alias) LIKE 'Apple'
          OR lower(accounts1_.name) LIKE 's sc om ch'
          OR lower(accounts1_.alias) LIKE 'Apple'
          OR lower(accounts1_.iban) LIKE '5100005097904'
          OR lower(accounts1_.account_number) LIKE 's'
          OR lower(accounts1_.phone_number) LIKE '1'
          OR lower(accounts1_.email) LIKE 'www'
          OR lower(accounts1_.other_identifier) LIKE 'ff' )
    AND ( party0_.status IN ( 'ACTIVE' ) )
ORDER BY
    lower(party0_.name) ASC
FETCH FIRST 100 ROWS ONLY
```

```
| Id  | Operation                | Name                | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT         |                     |   100 | 17700 |    18  (12)| 00:00:01 |
|*  1 |  VIEW                    |                     |   100 | 17700 |    18  (12)| 00:00:01 |
|*  2 |   WINDOW SORT PUSHED RANK|                     |     5 |   820 |    18  (12)| 00:00:01 |
|   3 |    VIEW                  |                     |     5 |   820 |    17   (6)| 00:00:01 |
|   4 |     HASH UNIQUE          |                     |     5 |  1850 |    17   (6)| 00:00:01 |
|*  5 |      HASH JOIN           |                     |     5 |  1850 |    16   (0)| 00:00:01 |
|*  6 |       TABLE ACCESS FULL  | USER_PARTY               |    57 |  9918 |     9   (0)| 00:00:01 |
|   7 |       TABLE ACCESS FULL  | USER_ACCOUNT_INFORMATION |   435 | 85260 |     7   (0)| 00:00:01 |
```

#### **Issues Identified**

#### **1. Full Table Scans on `USER_PARTY` and `USER_ACCOUNT_INFORMATION`**

* The optimizer is **not using indexes**, leading to slow performance.
* This is likely because:
  * No indexes exist on the filtering columns.
  * The `LOWER()` function **prevents index usage** on `party0_.name`, `party0_.alias`, and `accounts1_` columns.

#### **2. OR Conditions Without Parentheses**

* `(party0_.service_agreement_id = X AND party0_.access_context_scope = 0 OR party0_.legal_entity_id = Y AND party0_.access_context_scope = 0 OR party0_.bb_id = Z AND party0_.access_context_scope = 0 )`
* This may be interpreted incorrectly. We should **group conditions properly** using parentheses.

#### **3. LIKE Conditions on Large Columns**

* `LOWER(column) LIKE '%value%'` prevents index usage.
* If leading wildcards (`%value`) are used, indexes cannot help.

#### **Optimizations**

#### **1. Add Indexes for Better Performance**

**Index on Filtering Columns**

```sql
CREATE INDEX idx_party_sa_scope ON user_party (service_agreement_id, access_context_scope);
CREATE INDEX idx_party_legal_scope ON user_party (legal_entity_id, access_context_scope);
CREATE INDEX idx_party_bb_scope ON user_party (bb_id, access_context_scope);
CREATE INDEX idx_party_status ON user_party (status);
CREATE INDEX idx_accounts_party ON user_account_information (party_id);
```

**Index on Searchable Columns (With Functional Index)**

* Since `LOWER(column)` prevents index usage, create functional indexes:

```sql
CREATE INDEX idx_party_name ON user_party (LOWER(name));
CREATE INDEX idx_party_alias ON user_party (LOWER(alias));
CREATE INDEX idx_accounts_name ON user_account_information (LOWER(name));
CREATE INDEX idx_accounts_alias ON user_account_information (LOWER(alias));
CREATE INDEX idx_accounts_iban ON user_account_information (LOWER(iban));
CREATE INDEX idx_accounts_account_number ON user_account_information (LOWER(account_number));
CREATE INDEX idx_accounts_phone_number ON user_account_information (LOWER(phone_number));
CREATE INDEX idx_accounts_email ON user_account_information (LOWER(email));
CREATE INDEX idx_accounts_other_identifier ON user_account_information (LOWER(other_identifier));
```

If Oracle is not using the function-based indexes, a **composite index** might help, but it depends on how the optimizer processes our query. Before creating composite indexes, let's go through some key checks and options.

#### **1. Verify Oracle is Aware of Function-Based Indexes**

Run the following query to ensure the function-based indexes exist and are usable:

```sql
SELECT INDEX_NAME, TABLE_NAME, COLUMN_EXPRESSION, VISIBILITY, STATUS 
FROM USER_IND_EXPRESSIONS 
WHERE TABLE_NAME IN ('USER_PARTY', 'USER_ACCOUNT_INFORMATION');
```

* If the function-based indexes **are not listed**, Oracle is **not recognizing** them.
*   If the index **status is UNUSABLE**, rebuild them using:

    ```sql
    ALTER INDEX idx_party_name_lower REBUILD;
    ```

&#x20;**2. Gather Statistics on Indexed Columns**

Oracle may not use the indexes if table statistics are outdated. Run:

```sql
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS('YOUR_SCHEMA', 'USER_PARTY');
  DBMS_STATS.GATHER_TABLE_STATS('YOUR_SCHEMA', 'USER_ACCOUNT_INFORMATION');
  DBMS_STATS.GATHER_INDEX_STATS('YOUR_SCHEMA', 'IDX_PARTY_NAME_LOWER');
  DBMS_STATS.GATHER_INDEX_STATS('YOUR_SCHEMA', 'IDX_ACCOUNT_NAME_LOWER');
END;
/
```

#### **3. Consider Composite Index**

If the optimizer still doesn't use function-based indexes, try a **composite index** covering frequently queried columns together.

**Option 1: Composite Function-Based Index**

Create a **multi-column functional index** on frequently filtered columns:

```sql
CREATE INDEX idx_party_composite_lower 
ON user_party (LOWER(name), LOWER(alias));

CREATE INDEX idx_account_composite_lower
ON user_account_information (LOWER(name), LOWER(alias), LOWER(iban), LOWER(account_number),
                         LOWER(phone_number), LOWER(email), LOWER(other_identifier));
```

* This is useful **if multiple columns are always queried together**.
* If filtering only one column at a time, **individual function-based indexes are better**.

