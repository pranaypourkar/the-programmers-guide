# Dead Lock

## Problem 1:

I have a spring boot service (Say Service A) connected to a Oracle database. There is a table with id as unique. And their is an API with accepts bulk id and update/insert those records. My another service (Say Service B) is callig that API parallely in multiple threads. I am seeing some deadlock issues.

### **Why Deadlocks might occur**

1. **Concurrent Updates/Inserts**:
   * If multiple threads try to insert/update the **same set of IDs**, they may lock rows in different order and wait on each other → deadlock.
2. **Transaction Isolation Levels**:
   * High isolation levels (like `REPEATABLE_READ` or `SERIALIZABLE`) can increase the likelihood of deadlocks in concurrent access.
3. **Batch Updates Without Partitioning**:
   * Sending overlapping or interdependent ID batches to the API may result in resource contention.
4. **Database Constraints/Indexes**:
   * Inserts with `UNIQUE` constraints can lead to locking behavior when concurrent inserts are attempted for the same ID.

If unqiue batch of ids are sent then -

### **Why we may still get Deadlocks in Oracle**

Even with unique ID batches, Oracle can deadlock due to:

#### 1. **Row Lock Contention on Insert/Update**

* Oracle uses **row-level locking**, but if multiple transactions insert into the same table, **index-level locks** (especially on primary/unique keys) can cause contention.

#### 2. **Unindexed Foreign Keys**

* If our table has foreign key constraints **without proper indexes**, Oracle may place **table-level locks** on parent/child tables, causing deadlocks.

#### 3. **Concurrent Insert Into Same Table with Unique Constraints**

* Even if IDs are unique, the underlying **index structure** (like B-tree) can be locked in a way that multiple inserts collide internally.

### **Possible Solutions**

#### 1. **Ensure Foreign Key Columns Are Indexed**

Oracle recommends: **"Every foreign key should have an index."**

```sql
CREATE INDEX fk_index ON your_table(foreign_key_column);
```

Lack of this can lead to table-level locks on deletes/updates, even if IDs are unique.

#### 2. **Sort IDs Consistently Before Insert/Update**

Oracle can deadlock if:

* Thread A inserts IDs \[9,10,11]
* Thread B inserts \[11,10,9]

If both touch shared internal index nodes in **different order**, deadlocks can occur.

**Solution**: Always **sort IDs before processing** (e.g., ascending order).

#### 3. **Reduce Batch Size**

Too large a batch → large transaction scope → higher chance of conflict.\
Try limiting batches to **50–100 records**.

#### 4. **Set Oracle Deadlock Retry Logic (App Side)**

Implement retry logic when deadlocks (ORA-00060) occur:

```java
@Retryable(
  value = {DeadlockLoserDataAccessException.class, OptimisticLockingFailureException.class},
  maxAttempts = 3,
  backoff = @Backoff(delay = 500)
)
```

#### 5. **Avoid Mixing Insert and Update in Same Batch**

Split bulk operations:

* One API call for insert-only
* One API call for update-only

This avoids internal conflicts and simplifies transaction paths.

#### 6. **Capture Deadlock Details**

Run this query in Oracle to check the last deadlock:

```sql
SELECT * FROM dba_ddl_locks WHERE session_id IN (SELECT sid FROM v$session WHERE blocking_session IS NOT NULL);
```

Or check:

```sql
SELECT * FROM v$locked_object;
SELECT * FROM dba_blockers;
```

### Can DBA help to check the deadlocks?

**Yes**, **DBA (Database Administrator)** is the best person to help **analyze and resolve deadlocks** in Oracle. In fact, DBAs have access to powerful tools and logs that can precisely identify:

* Which sessions were involved
* What SQL statements caused the deadlock
* Which locks were being held or waited for
* Table/index details involved

What we can ask DBA to Check ?

**1. Deadlock Trace Files**

> Can you check the `alert.log` or trace files under `USER_DUMP_DEST` for any ORA-00060 (deadlock detected) errors?

Oracle writes deadlock details in trace files, including:

* SQL statements involved
* Row/resource lock information
* Blocked and blocking sessions

**2. Recent Deadlocks (v$ tables)**

> Can you query `v$session`, `v$locked_object`, `v$lock`, or `dba_blockers` to find which sessions and objects are involved?

Example:

```sql
SELECT 
    s.sid, s.serial#, s.username, l.object_id, o.object_name, l.locked_mode
FROM 
    v$session s
JOIN 
    v$locked_object l ON s.sid = l.session_id
JOIN 
    all_objects o ON l.object_id = o.object_id;
```

**3. Index & Constraint Health**

> Can you verify that all foreign key columns on table `XYZ` have indexes?

Missing FK indexes are a **common cause** of deadlocks on updates/deletes.

**4. Blocking Session Analysis**

> Can you monitor for blocking sessions and their SQL using `v$session` and `v$session_wait`?

```sql
SELECT
    blocking_session, sid, serial#, wait_class, seconds_in_wait
FROM
    v$session
WHERE
    blocking_session IS NOT NULL;
```

**5. AWR / ADDM Reports**

If we have access to **Oracle Enterprise Edition** with AWR/ADDM, the DBA can run:

> Please generate an AWR report for the timeframe of the deadlocks.

This helps detect:

* Frequent deadlock patterns
* Hot blocks/indexes
* Expensive SQL statements

### Will the system become normal after a deadlock?

**Yes — eventually, but with consequences:**

* **Oracle detects the deadlock**, usually within a few seconds.
* It then **kills one of the sessions/transactions** involved to **break the deadlock cycle**.
* The killed transaction receives an error (`ORA-00060: deadlock detected while waiting for resource`) — this is the exception we are seeing.
* Other transaction(s) involved may proceed.

> So the system does **recover**, but **one or more of our threads will fail** their database operation, and **we must handle that failure gracefully** in our code.

