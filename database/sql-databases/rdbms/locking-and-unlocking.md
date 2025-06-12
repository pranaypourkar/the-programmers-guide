# Locking and Unlocking

## About

### What is Locking in Databases?

Locking in a database is a mechanism used to manage access to data when multiple users or transactions are trying to read or modify the same data at the same time. When a piece of data (like a row in a table) is being used by one transaction, the database "locks" it to prevent others from changing it at the same time. This ensures that the data remains consistent and accurate.

### What is Unlocking in Databases?

Unlocking happens when a transaction is finished, either successfully (committed) or unsuccessfully (rolled back). Once a transaction is done, the database releases the lock on the data, allowing other transactions to access it.

### Why is Locking Necessary in Databases?

Locking is necessary to maintain **data consistency** and **transaction integrity**. Here’s why:

#### **1. Preventing Simultaneous Modifications (Lost Updates)**

Imagine two users trying to update the same bank account balance at the same time. Without locking, both could read the balance, and both could apply their updates without knowing about the other’s changes. This could lead to errors like:

* Both users thinking they are updating the same value independently, leading to lost updates or incorrect data. Locking ensures that when one transaction is updating the data, others have to wait until it is done.

#### **2. Avoiding Dirty Reads**

A **dirty read** happens when one transaction reads data that another transaction is in the process of changing, but hasn’t committed yet. This could result in reading incomplete or incorrect data. For example:

* User A is transferring money from one account to another. Before the transaction is completed, User B reads the balance, which may not reflect the final amount. Locking prevents other transactions from accessing data that is in the middle of being updated, ensuring that they only see fully committed, correct data.

#### **3. Preventing Non-Repeatable Reads**

A **non-repeatable read** happens when a transaction reads data, and then reads the same data again later, but it has changed in the meantime because of another transaction. For example:

* Transaction A reads a record and begins processing it. Meanwhile, Transaction B updates that record. Transaction A then reads the record again and gets a different value. Locking ensures that data a transaction is working with doesn’t change during its process, providing consistent results.

#### **4. Avoiding Phantom Reads**

**Phantom reads** occur when a transaction reads a set of rows that meet certain criteria, but another transaction inserts, deletes, or updates rows that would change the result set. This leads to inconsistencies in the data being processed. Locking can ensure that no rows are inserted or deleted during a transaction, maintaining the integrity of the result set.

#### **5. Maintaining Isolation Between Transactions**

Databases support multiple transactions running simultaneously. **Transaction isolation** is a principle that ensures that one transaction doesn’t interfere with another. Without locking, different transactions could access or modify the same data at the same time, leading to conflicts and errors. By locking data, a database can make sure that each transaction is isolated from others, either fully or partially, depending on the level of isolation defined by the system.

## Types of Locks

In a database, **locks** are used to control access to data to ensure that multiple transactions can work concurrently without conflicting with each other. Different types of locks are used depending on the situation, balancing **data consistency** with **concurrency**. Here are the main types of locks used in RDBMS (Relational Database Management Systems):

### **1. Shared Lock (S-Lock)**

* **Purpose:** Allows multiple transactions to **read** the data concurrently but **prevents any transaction** from modifying the data.
* **Use case:** When a transaction only needs to **read** data and does not want to modify it, a shared lock can be placed on the data.
* **Example:** If multiple users want to read the same product's details but not update it, a shared lock allows them to read the data without interference.

### **2. Exclusive Lock (X-Lock)**

* **Purpose:** Prevents any other transactions from **reading or modifying** the data. This lock is placed when a transaction is updating or deleting data.
* **Use case:** When a transaction is performing a **write operation** (insert, update, delete), an exclusive lock is applied to ensure no other transaction can access the data until the lock is released.
* **Example:** If one user is updating the price of a product, no other user can read or update the price until the operation is completed and the lock is released.

### **3. Intent Lock (I-Lock)**

* **Purpose:** This is a **higher-level lock** that indicates a transaction intends to acquire a shared or exclusive lock at a finer level (like row-level or page-level).
* **Use case:** Prevents conflicts when transactions are planning to acquire locks at a more granular level (e.g., row-level locks). It’s used to signal the intention to lock resources in a way that prevents other transactions from acquiring conflicting locks.
* **Example:** If a transaction intends to lock multiple rows, it might first acquire an intent lock on the table before locking specific rows.

### **4. Update Lock (U-Lock)**

* **Purpose:** A special type of lock used when a transaction intends to update data but wants to avoid conflicts with other transactions that might also be attempting to update the same data.
* **Use case:** Typically used in **serializable isolation level** to avoid deadlocks. It’s a kind of **hybrid** between shared and exclusive locks, allowing a transaction to read data but preventing other transactions from writing to it.
* **Example:** When a transaction reads data and plans to modify it, it may apply an update lock to prevent other transactions from modifying the same data concurrently.

### **5. Bulk Update Lock (BU-Lock)**

* **Purpose:** Specifically used in situations where **bulk update operations** are performed. It allows for more efficient handling of large-scale update transactions.
* **Use case:** When an operation affects many rows or data items at once (like an update to all rows in a table), a bulk update lock can be applied to optimize performance and reduce the overhead of individual row locks.
* **Example:** Updating all records in a sales table where the product price is changed across many entries.

### **6. Row-Level Lock**

* **Purpose:** Locks a **specific row** in a table, allowing other transactions to access different rows concurrently.
* **Use case:** Row-level locking is ideal when the transaction needs to modify a single row without affecting other rows.
* **Example:** When a user updates their account balance, only the row related to that user is locked, allowing other users to update their own account balances at the same time.

### **7. Page-Level Lock**

* **Purpose:** A page-level lock locks an entire **data page** in memory (which can hold multiple rows).
* **Use case:** This is used when a transaction is updating a group of rows that are stored in the same page. It provides a balance between concurrency and performance but can limit parallelism.
* **Example:** When a transaction is performing updates to several rows stored on the same database page, a page-level lock would be applied.

### **8. Table-Level Lock**

* **Purpose:** Locks the **entire table**, preventing any other transactions from reading or modifying the data in that table until the lock is released.
* **Use case:** This is used when a transaction is performing large-scale operations that involve many or all rows of the table, such as schema changes or bulk operations.
* **Example:** A database administrator might lock the entire table when performing maintenance operations, such as adding an index or altering the table structure.

### **9. Schema Lock**

* **Purpose:** Prevents changes to the **structure** of a database (like altering tables, adding indexes, etc.) while the lock is held.
* **Use case:** Typically used when there is a need to change the database schema, such as adding a new column or changing a constraint, and no other operations should interfere with these changes.
* **Example:** When an ALTER TABLE operation is happening, a schema lock prevents any other changes to the table schema.

## Locking Mechanisms

A **locking mechanism** is the internal system that a database uses to **control how and when locks are acquired, held, and released** during concurrent access to data.

It ensures:

* **Data integrity** (no conflicting updates),
* **Isolation** (transactions don’t interfere),
* **Concurrency** (multiple users can work simultaneously).

Here are the most commonly used locking mechanisms in relational database systems:

### 1. Pessimistic Locking

**"Assume conflict will happen, so block others now."**

* **How it works:** A transaction locks the data as soon as it reads it — no one else can modify (and sometimes even read) that data until the lock is released.
* **Used in:** Systems where **conflicts are likely**, and **data consistency is critical**.
* **Pros:** Prevents dirty reads, lost updates, and ensures data safety.
* **Cons:** Reduces concurrency and performance (others may have to wait).
* **Example:** Bank transactions, seat booking systems.

### 2. Optimistic Locking

**"Assume no conflict, but check before committing."**

* **How it works:** No lock is taken during read. When trying to update, the system checks if someone else has modified the data in the meantime (using a **version number** or **timestamp**). If yes, the update fails or retries.
* **Used in:** Systems where **conflicts are rare** and **performance is more important**.
* **Pros:** Higher concurrency, fewer locks = better performance.
* **Cons:** May require retrying transactions if conflicts are detected.
* **Example:** Web applications with many readers but few writers.

### 3. Read/Write Locking (Shared/Exclusive)

This is a combination of **Shared Locks** (for reading) and **Exclusive Locks** (for writing):

* **Read (Shared) Lock:** Many can read, but no one can write.
* **Write (Exclusive) Lock:** Only one can write, and no one else can read or write.
* **Use Case:** Used in most databases to manage access at **row**, **page**, or **table** level.

### 4. Two-Phase Locking (2PL)

**"All locks before releasing any."**

* **How it works:** A transaction follows two phases:
  1. **Growing Phase** – It **acquires** all locks (no release).
  2. **Shrinking Phase** – It **releases** locks but **cannot acquire new ones**.
* **Guarantees:** Ensures **serializability** (the strictest isolation level).
* **Used in:** High-integrity transaction systems (banking, accounting).

### 5. Deadlock Detection and Prevention Mechanisms

Locking can cause **deadlocks**, where two transactions wait for each other forever.

To handle this, DBMSs use:

* **Timeouts** – Abort transactions if they wait too long.
* **Wait-for Graphs** – Detect circular waits and resolve them.
* **Prevention techniques** – Enforce lock ordering or priorities.

### 6. Granular Locking (Lock Levels)

Databases support **different levels of locking**, depending on the granularity of data:

* **Row-level Lock** – Highest concurrency, least blocking.
* **Page-level Lock** – A middle ground.
* **Table-level Lock** – Simpler but reduces concurrency.

Some systems even support **column-level locks**, but it's rare.

## Locking Protocols

### About

**Locking protocols** are **rules followed by transactions** to **acquire and release locks** on data items to ensure **consistency** and **isolation**.

They help prevent problems like:

* Dirty reads,
* Lost updates,
* Inconsistent data,
* Deadlocks (in some cases).

> Think of them as traffic rules that all transactions must follow when accessing shared data.

### Why Are Locking Protocols Important?

* Enforce **transaction isolation** (especially SERIALIZABLE level).
* Prevent **conflicts** in multi-user environments.
* Ensure **data consistency**.
* Avoid **anomalies** in concurrent transactions.

{% hint style="info" %}
- Most modern DBMSs use **strict two-phase locking** or a **hybrid** of these protocols internally.
- As a developer or DBA, understanding locking protocols helps in:
  * Optimizing queries and transactions,
  * Tuning isolation levels,
  * Avoiding performance issues and deadlocks.
{% endhint %}

### 1. Two-Phase Locking (2PL)

**Most used protocol** for serializability.

* **Phases:**
  1. **Growing phase:** Transaction can acquire locks but **not release** them.
  2. **Shrinking phase:** Transaction can release locks but **not acquire** any new ones.
* **Variants:**
  * **Strict 2PL:** Keeps all **exclusive (write) locks until commit**, preventing cascading rollbacks.
  * **Rigorous 2PL:** Keeps **all locks (read/write)** until commit.
* **Pros:** Guarantees **serializability** (transactions appear to run in sequence).
* **Cons:** Can cause **deadlocks**.

### 2. Timestamp Ordering Protocol

**No locks**, but orders operations using **timestamps**.

* Each transaction gets a **unique timestamp**.
* The DBMS allows operations only if they **don’t violate the timestamp order**.
* Conflicting operations are **aborted** and retried if order is violated.
* **Pros:** No deadlocks.
* **Cons:** Higher chances of **transaction restarts**.

### 3. Validation-Based Protocol (Optimistic Concurrency Control)

**Transactions execute without locking**, and only **validate before committing**.

* **Phases:**
  1. **Read phase** – Read data without locking.
  2. **Validation phase** – Check if conflict occurred.
  3. **Write phase** – If valid, commit changes; else rollback.
* **Pros:** High performance with **low contention**.
* **Cons:** Wasted work if validation fails.

### 4. Multiple Granularity Locking Protocol

Manages **locks at different levels** – database, table, page, row.

* Uses **intention locks** like:
  * **Intention Shared (IS)**,
  * **Intention Exclusive (IX)**,
  * To inform what kind of locks are needed at finer levels.
* **Example:** Locking a row must first get intention locks on page and table.
* **Pros:** Flexible and supports **hierarchical locking**.
* **Cons:** Adds complexity.

## Deadlock and Its Resolution

### About

A **deadlock** occurs when **two or more transactions are waiting for each other** to release resources (like locks), and **none of them can proceed**.

> It’s like two people trying to cross a narrow bridge from opposite sides, both refusing to back up.

Imagine two transactions:

* **T1** locks **Row A** and wants **Row B**
* **T2** locks **Row B** and wants **Row A**

Both are waiting for each other to release the row, and **neither can proceed** = **deadlock**!

### Conditions for Deadlock (All must be true)

1. **Mutual Exclusion** – Only one transaction can use a resource at a time.
2. **Hold and Wait** – Transactions hold some locks and wait for more.
3. **No Preemption** – Locks cannot be forcibly taken away.
4. **Circular Wait** – Transaction A waits for B, B waits for C, and C waits for A.

### Deadlock Detection and Resolution Techniques

#### **1. Deadlock Detection**

* DBMS checks for **circular wait** using a **wait-for graph**.
* If a cycle is detected, **one transaction is rolled back**.

**Advantage**: High concurrency\
**Disadvantage**: Needs monitoring overhead

#### **2. Deadlock Prevention**

* The DBMS is designed to **prevent the four conditions** from happening.

Examples:

* **Resource Ordering**: Always acquire locks in a fixed order.
* **Wait-Die / Wound-Wait** Schemes:
  * **Wait-Die**: Older transaction waits; younger dies (rolls back).
  * **Wound-Wait**: Older transaction preempts younger one.

**Advantage**: No deadlocks\
**Disadvantage**: May cause more rollbacks

#### **3. Deadlock Avoidance**

* DBMS checks **before granting a lock** if it might lead to a deadlock.

Example:

* **Wait-For Graph Prediction**: Simulate if a new lock request causes a cycle.

**Advantage**: No deadlocks, fewer rollbacks\
**Disadvantage**: Complex, more checks needed

#### **4. Timeout Approach**

* If a transaction waits too long, it is **automatically rolled back**.

**Simple** and low overhead\
May cause **false positives** (not actual deadlocks)

## Unlocking and Release of Locks

Unlocking is the process of **releasing a previously held lock** on a data item (like a row, table, or page) so that **other transactions can access** that data.

It’s a critical part of maintaining **concurrency control** and ensuring that other transactions are not blocked indefinitely.

### Why Unlocking Is Important

* Prevents **unnecessary blocking** of other transactions.
* Avoids **deadlocks** by freeing resources on time.
* Ensures better **resource utilization**.
* Essential for maintaining **ACID properties**—especially **Isolation** and **Durability**.

### When Are Locks Released?

It depends on the **locking protocol** or **isolation level** used. Common release points:

1. **At the end of a transaction (commit or rollback)**
   * Used in **strict two-phase locking (Strict 2PL)**.
   * Ensures data consistency but may reduce concurrency.
2. **During the transaction (early unlock)**
   * Used in **basic 2PL** or **non-strict protocols**.
   * Increases concurrency but can cause cascading rollbacks.

### Types of Unlocking Approaches

#### 1. Automatic Unlocking by DBMS

* Most RDBMS systems **automatically release locks** when:
  * The transaction **commits** or **rolls back**.
  * A query finishes execution (in some read locks).
* This is the **safest and most common** method.

#### 2. Manual Unlocking (Explicit Release)

* Some databases allow **manual control** over lock release.
* Rare in practice; mostly used in **low-level or custom DBMS implementations**.

### Lock Release Examples

#### Example 1 – Write Lock Released at Commit

```sql
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE id = 101;
/* Lock on account 101 is held */
COMMIT;
/* Lock is released after commit */
```

#### Example 2 – Read Lock Released After Query (in some systems)

```sql
SELECT * FROM customers WHERE id = 201;
/* Shared lock may be released immediately after the query */
```

## Best Practices

#### 1. Keep Transactions Short and Focused

* Don’t hold locks longer than necessary.
* Avoid performing user interactions, I/O, or long computations inside a transaction.

#### 2. Always Close Transactions (Commit or Rollback)

* A transaction that is left open keeps its locks active and may block other operations.
* Make sure to **explicitly commit or rollback**.

#### 3. Acquire Locks in a Consistent Order

* Always lock resources in the same sequence to avoid circular waits and deadlocks.
* This is especially important in systems handling multiple resources per transaction.

#### 4. Use the Smallest Lock Scope Possible

* Lock **only what is needed** (e.g., a row instead of a whole table) to maximize concurrency.
* Avoid table-level locks unless necessary.

#### 5. Choose the Right Isolation Level

* Higher isolation levels (like `SERIALIZABLE`) use more locks and can reduce concurrency.
* Use lower isolation levels (`READ COMMITTED`, `REPEATABLE READ`) when possible, depending on consistency needs.

#### 6. Avoid Manual Lock Management

* Let the DBMS manage locks unless you have a strong reason to do otherwise.
* Manual locking is error-prone and harder to maintain.

#### 7. Monitor Lock Usage

* Use database tools to analyze lock waits, timeouts, and deadlocks.
* Identify queries or transactions that frequently hold locks too long.

#### 8. Handle Deadlocks Gracefully

* Design transactions to handle failures and retries if a deadlock occurs.
* Most DBMS will abort one of the transactions automatically—your code should be ready to retry.

#### 9. Avoid Lock Escalation

* When too many row-level locks are held, some DBMS escalate to page- or table-level locks.
* This can reduce concurrency. Use indexing and batching to avoid holding too many locks.

#### 10. Avoid Unnecessary Locks

* For **read-only operations**, use `WITH (NOLOCK)` (SQL Server) or equivalent if dirty reads are acceptable.
* Be cautious: it may lead to reading uncommitted or inconsistent data.
