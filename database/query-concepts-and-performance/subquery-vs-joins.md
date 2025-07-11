# Subquery vs Joins

## Scenario 1

### **Query Under Analysis**

```sql
SELECT
    COUNT(1)
FROM
    devicemanagementservice.device
WHERE
    device_user_id IN (
        SELECT
            user_id
        FROM
            segmentservice.audiences_by_user
        WHERE
            audience_id = '01903B19116B7CE396877DA3E164F51C'
    )
    AND push_token IS NOT NULL
    AND status = 'ENABLED';
```

### **What This Query Does**

This query counts how many rows in the `device` table satisfy the following:

* `device_user_id` is found in the result set of the subquery (users belonging to a specific audience),
* `push_token` is not null,
* `status` is `'ENABLED'`.

The subquery fetches all `user_id`s from `audiences_by_user` with a specific `audience_id`.

### **Why This Can Be a Performance Problem**

#### 1. **Subquery Returns Large Result Set**

If the audience contains **millions of users**, then the `IN` clause will internally expand into a very large list for comparison.

Most databases convert `IN (SELECT ...)` to a **semi-join** operation, but:

* If the optimizer decides not to convert it into a join, the comparison becomes inefficient.
* It may end up checking each row in `device` against a large in-memory hash or temp structure.

#### 2. **Lack of Indexes**

If proper indexes do not exist:

* The subquery will scan a large portion (or all) of the `audiences_by_user` table.
* The outer query will have to compare each `device_user_id` by scanning the device table.

#### 3. **Query Cannot Be Pushed Down Efficiently**

The filtering on `audience_id` happens deep inside the subquery. If the database cannot **push down** filters or optimize join paths, it might perform redundant scans or materializations.

### **Optimization Strategy**

#### A. **Rewrite the Query Using a JOIN**

Using a `JOIN` often performs better because the optimizer can:

* Perform **hash join** or **merge join**
* Use indexes on join columns
* Push filters earlier in the execution plan

**Rewritten Query:**

```sql
SELECT COUNT(1)
FROM devicemanagementservice.device d
JOIN segmentservice.audiences_by_user au
    ON d.device_user_id = au.user_id
WHERE
    au.audience_id = '01903B19116B7CE396877DA3E164F51C'
    AND d.push_token IS NOT NULL
    AND d.status = 'ENABLED';
```

**Why it's better:**

* It allows the optimizer to choose **join algorithms** that scale with large data.
* Filtering by `audience_id` happens before the join, reducing the amount of data joined.
* Indexes on `audiences_by_user.user_id` and `audiences_by_user.audience_id` can be used together.

### Expected Oracle Execution Plan

* **Step 1:** Oracle applies filter on `au.audience_id = '...'`
  * If indexed on `audience_id`, this will quickly reduce from 1M → say 50K.
* **Step 2:** Oracle uses the filtered user\_ids to **join with `device` on `device_user_id = user_id`**.
  * If `device_user_id` is indexed, this join can use **index nested loop** or **hash join**, depending on statistics and cardinality.
* **Step 3:** Filters on `status` and `push_token IS NOT NULL` are applied.
* **Step 4:** Aggregation (`COUNT(1)`).

### **Recommended Indexes**

To support and speed up this query pattern, create the following indexes:

#### On `segmentservice.audiences_by_user`

```sql
CREATE INDEX idx_abu_audience_user ON audiences_by_user(audience_id, user_id);
```

Reason: Supports filtering by `audience_id` and joining on `user_id`.

#### On `devicemanagementservice.device`

```sql
CREATE INDEX idx_device_userid_status_token ON device(device_user_id, status, push_token);
```

Reason:

* Helps locate rows with matching `device_user_id`
* Includes filter on `status = 'ENABLED'`
* Makes `push_token IS NOT NULL` more efficient by avoiding full table scans

