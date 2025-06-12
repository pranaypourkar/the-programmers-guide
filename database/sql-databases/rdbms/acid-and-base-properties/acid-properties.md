# ACID Properties

## About

ACID stands for **Atomicity, Consistency, Isolation, and Durability**, which are the key properties ensuring **data integrity, reliability, and correctness** in a database system. These properties are fundamental to **transaction management** in **Relational Database Management Systems (RDBMS)** such as **MySQL, PostgreSQL, Oracle, and SQL Server**.

{% hint style="success" %}
#### **What is a Transaction?**

A **transaction** is a set of database operations that must be executed as a **single unit of work**. It follows the **all-or-nothing rule**—either all operations in the transaction succeed, or none of them take effect.

**Example of a Transaction (Money Transfer)**

Imagine transferring **₹1000 from Alice’s bank account to Bob’s bank account**:

1. **Debit ₹1000 from Alice’s account**
2. **Credit ₹1000 to Bob’s account**
{% endhint %}

## **1. Atomicity**

Atomicity ensures that a transaction is treated as a single, indivisible unit.

* If all operations in the transaction **succeed**, the transaction is **committed**.
* If any operation **fails**, the entire transaction is **rolled back**.

### **Example**

Imagine transferring **₹500 from Alice’s account to Bob’s account**:

1. **Debit ₹500 from Alice’s account**
2. **Credit ₹500 to Bob’s account**

**Scenario 1: Successful Transaction**

✅ Both steps complete → Transaction is committed.

**Scenario 2: Failure in Step 2 (e.g., system crash)**

❌ **If only Alice's account is debited** but Bob's account is not credited, the system **must roll back** the entire transaction to prevent inconsistencies.

### **Implementation in SQL (Atomicity using Transactions)**

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1; -- Debit Alice
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2; -- Credit Bob
COMMIT; -- Commit if successful
```

If an error occurs:

```sql
ROLLBACK; -- Undo changes
```

## **2. Consistency**

Consistency ensures that a database moves from one valid state to another.\
A transaction should not violate any **database constraints, rules, or integrity conditions**.

### **Example**

* A transaction **should not leave the database in an invalid state**.
* If the bank rule says **"Account balance cannot be negative"**, then a transaction must **enforce this rule** and not allow negative balances.

**Scenario**

❌ If Alice has ₹400 and tries to transfer ₹500, the transaction should fail, ensuring data consistency.

### **SQL Example (Ensuring Consistency with Constraints)**

```sql
ALTER TABLE accounts ADD CONSTRAINT chk_balance CHECK (balance >= 0);
```

This prevents transactions that would cause negative balances.

{% hint style="success" %}
#### **Real-World Example of Consistency**

1. In an e-commerce app, if we add an item to our cart but it is out of stock, the system prevents the purchase.
2. In a bank, if a transfer makes an account negative, the transaction is not allowed.
{% endhint %}

## **3. Isolation**

Isolation ensures that multiple transactions executing at the same time do not affect each other.

{% hint style="success" %}
Isolation  -> Concurrent Transactions Don’t Interfere
{% endhint %}

### Problems in Concurrent Transactions

The problems that occur when multiple transactions run at the same time.

#### **1. Dirty Read**

* A transaction reads **uncommitted data** from another transaction.
* If the first transaction **rolls back**, the second transaction has read incorrect data.

**Example of Dirty Read**

1. Transaction A updates **Alice’s balance from ₹5000 to ₹4000**, but has **not committed**.
2. Transaction B reads **₹4000** (uncommitted value).
3. **Transaction A rolls back** (Alice’s balance goes back to ₹5000).
4. But **Transaction B already used ₹4000**, leading to incorrect calculations.

```sql
-- Transaction A
START TRANSACTION;
UPDATE accounts SET balance = 4000 WHERE account_id = 1; -- Not committed yet

-- Transaction B
SELECT balance FROM accounts WHERE account_id = 1; -- Reads ₹4000 (Dirty Read!)
```

**2. Non-Repeatable Read**

* A transaction reads the same row **twice** but gets **different values**.
* Another transaction **modifies and commits changes** between the two reads.

**Example of Non-Repeatable Read**

1. Transaction A reads **Alice’s balance (₹5000)**.
2. Transaction B updates **Alice’s balance to ₹4000** and **commits**.
3. Transaction A reads Alice’s balance **again** → Now it is ₹4000 (inconsistent data!).

```sql
-- Transaction A
START TRANSACTION;
SELECT balance FROM accounts WHERE account_id = 1; -- Reads ₹5000

-- Transaction B
START TRANSACTION;
UPDATE accounts SET balance = 4000 WHERE account_id = 1;
COMMIT; -- Transaction B commits

-- Transaction A
SELECT balance FROM accounts WHERE account_id = 1; -- Now reads ₹4000 (Non-Repeatable Read!)
```

#### **3. Phantom Read**

* A transaction reads a **set of rows** that changes when it reads again.
* Another transaction **inserts or deletes rows**, causing different results.

**Example of Phantom Read**

1. Transaction A selects **all employees with salary > ₹10,000** (5 rows).
2. Transaction B **inserts a new employee** with ₹12,000 salary and commits.
3. Transaction A **runs the same query again** but now **gets 6 rows instead of 5**.

```sql
-- Transaction A
START TRANSACTION;
SELECT * FROM employees WHERE salary > 10000; -- Returns 5 rows

-- Transaction B
START TRANSACTION;
INSERT INTO employees (name, salary) VALUES ('New Employee', 12000);
COMMIT; -- Transaction B commits

-- Transaction A
SELECT * FROM employees WHERE salary > 10000; -- Now returns 6 rows (Phantom Read!)
```

### SQL Isolation Levels

To control these issues, SQL provides **four isolation levels**.

<table data-full-width="true"><thead><tr><th>Isolation Level</th><th>Dirty Read</th><th>Non-Repeatable Read</th><th>Phantom Read</th></tr></thead><tbody><tr><td>Read Uncommitted</td><td>❌ Allowed</td><td>❌ Allowed</td><td>❌ Allowed</td></tr><tr><td>Read Committed</td><td>✅ Prevented</td><td>❌ Allowed</td><td>❌ Allowed</td></tr><tr><td>Repeatable Read</td><td>✅ Prevented</td><td>✅ Prevented</td><td>❌ Allowed</td></tr><tr><td>Serializable</td><td>✅ Prevented</td><td>✅ Prevented</td><td>✅ Prevented</td></tr></tbody></table>

#### **1. Read Uncommitted (Lowest Isolation Level)**

**Allows:** Dirty Reads, Non-Repeatable Reads, Phantom Reads.

* Transactions can read **uncommitted data** from other transactions.
* **Fastest but least safe** – used when **speed is more important than accuracy**.

#### **Example: Read Uncommitted in SQL**

```sql
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
SELECT * FROM accounts WHERE account_id = 1;
```

* A transaction **can read changes from other uncommitted transactions**.
* **Risky for financial transactions** (e.g., banking, e-commerce).

#### **2. Read Committed (Default in Most Databases)**

**Prevents:** Dirty Reads\
**Allows:** Non-Repeatable Reads, Phantom Reads&#x20;

* Transactions **can only read committed data**.
* A row being modified **is locked until the transaction commits**.

**Example: Read Committed in SQL**

```sql
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT balance FROM accounts WHERE account_id = 1;
```

* A transaction **waits until other transactions commit** before reading.
* **Used in PostgreSQL, Oracle (default level).**

#### **3. Repeatable Read (Prevents Non-Repeatable Reads)**

**Prevents:** Dirty Reads, Non-Repeatable Reads\
**Allows:** Phantom Reads

* Ensures **consistent reads for a single transaction**.
* **Locks** rows being read so other transactions **cannot modify** them.
* **Used in MySQL (default level).**

#### **Example: Repeatable Read in SQL**

```sql
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT balance FROM accounts WHERE account_id = 1;
-- This ensures balance remains same throughout the transaction
```

* **Other transactions cannot modify the row until commit.**
* **Does NOT prevent Phantom Reads** (new rows can still be inserted).

#### **4. Serializable (Highest Isolation Level)**

**Prevents:** Dirty Reads, Non-Repeatable Reads, Phantom Reads&#x20;

* **Full transaction isolation** – transactions are **executed one after another**.
* Uses **locks** or **MVCC (Multi-Version Concurrency Control)**.
* **Slowest but safest** – used in **critical systems** (e.g., financial applications).

**Example: Serializable in SQL**

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT balance FROM accounts WHERE account_id = 1;
```

* Prevents all concurrent modifications.
* Other transactions must wait until the first transaction finishes.

### **Comparison of Isolation Levels**

<table data-full-width="true"><thead><tr><th>Isolation Level</th><th width="197">Performance</th><th>Use Case</th></tr></thead><tbody><tr><td>Read Uncommitted</td><td>Fastest (Least Safe)</td><td>Log analysis, testing, caching</td></tr><tr><td>Read Committed</td><td>Good Balance</td><td>Most OLTP databases, financial transactions</td></tr><tr><td>Repeatable Read</td><td>Slower, safer</td><td>E-commerce, inventory management</td></tr><tr><td>Serializable</td><td>Slowest, safest</td><td>Banking, flight reservations</td></tr></tbody></table>

### **Example**

Imagine two users trying to book the last movie ticket at the same time:

1. User A sees 1 available seat
2. User B sees 1 available seat
3. Both users book at the same time → Double Booking Issue! **❌**\
   Isolation prevents this.

### **SQL Example Using Isolation Levels**

We can prevent double booking by **locking** the row:

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE tickets SET status = 'Booked' WHERE seat_id = 1;
COMMIT;
```

This ensures **only one user can book the seat**.

## **4. Durability**

Durability ensures that once a transaction is committed, it remains in the database even in case of a system crash.

* Data is permanently stored on disk.
* Even if the system fails, data can be recovered.

{% hint style="success" %}
## **Durability -> Data is Permanently Saved**
{% endhint %}

### **Example**

Online Purchase Confirmation

1. We buy a mobile phone online.
2. Payment is processed.
3. System crashes.
4. When the system restarts, our order should still be confirme&#x64;**.**

### **How Databases Ensure Durability?**

1. **Write-Ahead Logging (WAL):** Changes are written to a log before applying to the database.
2. **Checkpointing:** The database periodically saves its current state.
3. **Redo Logs:** Transactions are stored so they can be replayed after a crash.

### **SQL Example of Durability (WAL in PostgreSQL)**

```sql
SHOW wal_level; -- Displays the durability settings
```

This ensures that even if the system **crashes**, committed transactions are **not lost**.

