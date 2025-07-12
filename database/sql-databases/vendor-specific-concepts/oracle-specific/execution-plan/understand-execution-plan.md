# Understand Execution Plan

## Information

### **Execution Plan Columns**

<table data-header-hidden data-full-width="true"><thead><tr><th width="111.36627197265625"></th><th></th></tr></thead><tbody><tr><td><strong>Column</strong></td><td><strong>Detailed Explanation</strong></td></tr><tr><td><strong>Id</strong></td><td>A numeric identifier assigned to each step in the execution plan. The steps form a <strong>hierarchical tree</strong>, where higher-level steps (lower IDs) depend on lower-level operations. Oracle begins execution from the <strong>innermost child</strong> node (highest ID) and proceeds upwards. Indentation or tree structure (in some tools) reflects parent-child relationships between operations.</td></tr><tr><td><strong>Operation</strong></td><td>Describes the <strong>type of action</strong> Oracle performs at that step. Examples include:<br>• <code>TABLE ACCESS FULL</code> – Full table scan<br>• <code>INDEX RANGE SCAN</code> – Accessing index via range<br>• <code>HASH JOIN</code> – Performing a join using hashing technique<br>• <code>SORT AGGREGATE</code> – Aggregate function with sorting<br>This is the most crucial column to understand <strong>how Oracle is accessing data</strong> and combining it.</td></tr><tr><td><strong>Name</strong></td><td>Indicates the <strong>name of the object</strong> (table, index, or view) used in that step.<br>This helps confirm whether Oracle is using the <strong>correct index</strong>, or if it's accessing the expected table (especially in views or synonyms). A blank value usually indicates that the operation does not directly access a named object (e.g., a scalar function or derived row).</td></tr><tr><td><strong>Rows</strong></td><td>Estimated number of rows that the step <strong>will output</strong> to its parent. This estimate is based on <strong>optimizer statistics</strong> (e.g., table size, data distribution, histograms). Accurate row estimates are crucial because they <strong>determine join methods, access paths, and overall cost</strong>. If the estimate is inaccurate, the optimizer may choose a <strong>suboptimal plan</strong>.</td></tr><tr><td><strong>Bytes</strong></td><td>Estimated size (in bytes) of the data output by this step. Calculated as: <code>Estimated Rows × Average Row Size</code>.<br>This helps the optimizer understand <strong>memory and I/O implications</strong>, especially for operations like sorting, joins, or aggregation. High byte estimates may trigger <strong>use of TEMP tablespace</strong> or reduce parallelism.</td></tr><tr><td><strong>Cost (%CPU)</strong></td><td>A <strong>relative measure of resource usage</strong>, used by Oracle to compare alternative execution plans. The value is derived from a combination of factors like I/O cost, CPU usage, and memory. The number in parentheses is the <strong>percentage of that cost attributed to CPU</strong>. This is not an actual runtime metric but a modeling approximation. Lower cost generally implies better efficiency <strong>relative to other paths</strong>, not absolute performance.</td></tr><tr><td><strong>Time</strong></td><td>Estimated execution time for the step in <code>HH:MM:SS</code> format. This is computed by Oracle using I/O and CPU cost formulas, <strong>assuming ideal conditions</strong>. This is <strong>not the actual time</strong> the step took in real execution—it is merely a projection. For real-time metrics, use <code>DBMS_XPLAN.DISPLAY_CURSOR</code> with actual execution statistics.</td></tr><tr><td><strong>Predicate Info (e.g., <code>*</code> asterisk)</strong></td><td>A <code>*</code> next to the ID or operation indicates that a <strong>filter or access predicate</strong> is applied at that step. These predicates can be seen in detail when using <code>DBMS_XPLAN.DISPLAY</code> with the <code>+PREDICATE</code> or <code>ALL</code> options. Predicates are key for understanding <strong>how efficiently Oracle is filtering data</strong>—either during access or after data is fetched.</td></tr></tbody></table>

## Example 1

{% code fullWidth="true" %}
```
| Id  | Operation                              | Name                    | Rows | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                       |                         |    1 |    63 |    32   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID           | USER_ENTITY             |    1 |    63 |     2   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN                    | CONSTRAINT_FB           |    1 |       |     1   (0)| 00:00:01 |
|   3 |  TABLE ACCESS BY INDEX ROWID BATCHED   | USER_ATTRIBUTE          |    1 |   102 |    30   (0)| 00:00:01 |
|*  4 |   INDEX SKIP SCAN                      | IDX_USER_ATTRIBUTE_NAME |    2 |       |    28   (0)| 00:00:01 |
```
{% endcode %}

Oracle uses **cost-based optimization (CBO)** to estimate query execution costs and choose the most efficient plan.

#### Explanation

**Step 0 (Top Level)**\
Oracle is executing a SELECT statement. The total estimated cost of the query is 32. That means Oracle expects this query to be relatively cheap, but not negligible.

**Step 1 and 2**\
Oracle is accessing the `USER_ENTITY` table using an index called `CONSTRAINT_FB`. The scan type is **INDEX UNIQUE SCAN**, which is very efficient. It means Oracle expects only one row to match. This is a good sign.

**Step 3 and 4**\
Oracle then accesses the `USER_ATTRIBUTE` table. It is using **Batched Rowid Access**, which is more efficient than individual row-by-row lookups. However, the index being used is `IDX_USER_ATTRIBUTE_NAME` with an **Index Skip Scan**.

An index skip scan is used when the leading column of a composite index is not part of the filter condition. Oracle skips through index blocks, which is more expensive than a range scan. This is where most of the cost lies — 28 for the index operation and 30 for the table access.

#### **Observations**

1. **Overall Cost is `32`**
   * This is the estimated total cost for Oracle to execute this query.
   * Lower is better, but it depends on the dataset size and indexing.
2. **INDEX UNIQUE SCAN (`CONSTRAINT_FB`) has Cost = `1`**
   * Since it's a **primary key lookup**, it's **extremely efficient**.
   * It retrieves `userentity0_.id` using the primary key.
3. **INDEX SKIP SCAN (`IDX_USER_ATTRIBUTE_NAME`) has Cost = `28`**
   * Oracle is skipping over indexed values instead of performing a full scan.
   * **Problem?** If `user_attribute.value` has **high cardinality (many distinct values)**, an **INDEX RANGE SCAN** would be better.
4. **TABLE ACCESS BY INDEX ROWID (`USER_ATTRIBUTE`) has Cost = `30`**
   * Fetching rows from `USER_ATTRIBUTE` based on the `INDEX SKIP SCAN` result.
   * The cost is high because **many rows may match** the filter on `value`.

#### **How to Improve This Query?**

**1. Improve Indexing Strategy**

*   **Use a Composite Index (`value`, `user_id`)**

    ```sql
    CREATE INDEX idx_user_attribute_value_userid 
    ON user_attribute(value, user_id);
    ```

    * This helps Oracle **directly locate `user_id`**, avoiding the **skip scan**.
    * Expected result: The optimizer should switch to **INDEX RANGE SCAN** instead.

**2. Force an Index Hint**

If Oracle keeps using **INDEX SKIP SCAN**, you can force it to use a better index:

```sql
SELECT /*+ INDEX(userattrib1_ idx_user_attribute_value_userid) */
    userentity0_.username
FROM user_entity userentity0_
INNER JOIN user_attribute userattrib1_ 
    ON userentity0_.id = userattrib1_.user_id
WHERE userattrib1_.value = '1311310003';
```

**3. Check Index Statistics**

Run:

```sql
SELECT table_name, num_rows FROM user_tables WHERE table_name IN ('USER_ENTITY', 'USER_ATTRIBUTE');
SELECT index_name, num_rows, distinct_keys FROM user_indexes WHERE table_name = 'USER_ATTRIBUTE';
```

* If `num_rows` is **large** but `distinct_keys` for `IDX_USER_ATTRIBUTE_NAME` is **low**, the **INDEX SKIP SCAN** is inefficient.
* In this case, a **new composite index** (`value`, `user_id`) will help.

