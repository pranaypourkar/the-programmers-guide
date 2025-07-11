# Single SQL vs PLSQL Query

## Why Single SQL is Preferred Over PL/SQL for Large Data Processing ?

In relational database systems such as Oracle, developers often face a choice between writing a single SQL query or using PL/SQL (Procedural Language extensions to SQL) blocks to process large datasets.

SQL is a **declarative language** designed for **set-based processing**. It tells the database **what to do**, not **how to do it**. The database engine's optimizer decides the most efficient way to execute the statement.

PL/SQL, on the other hand, is **procedural** and **imperative**, meaning the developer writes code that explicitly defines the control flow and data access sequence. This imperative control becomes a bottleneck when dealing with large datasets, especially when rows are processed one at a time.

### **Set-Based vs Row-By-Row Processing**

* SQL operates on entire sets of rows at once.
* PL/SQL operates on one row at a time unless explicitly written using **bulk collect** and **FORALL** constructs.

In a large dataset scenario, processing millions of rows individually (row-by-row) is **orders of magnitude slower** than processing them as a set.

#### Example:

PL/SQL (row-wise):

```plsql
FOR r IN (SELECT emp_id FROM employees WHERE dept = 10) LOOP
    UPDATE employees SET salary = salary * 1.1 WHERE emp_id = r.emp_id;
END LOOP;
```

Single SQL (set-wise):

```sql
UPDATE employees SET salary = salary * 1.1 WHERE dept = 10;
```

The second version runs in one pass with optimized IO and execution plans.

### **PL/SQL and SQL Context Switching Overhead**

Oracle maintains **two separate engines**:

* **PL/SQL engine** (procedural execution)
* **SQL engine** (data access and manipulation)

Every time a PL/SQL block executes a SQL statement, control must **switch context** between the PL/SQL and SQL engines. This involves:

* Marshaling parameters
* Copying memory buffers
* Managing state transitions

When performed once, this overhead is negligible. But in a loop of a million iterations, **context switching becomes a major performance bottleneck**.

### **Optimizer Efficiency and Execution Planning**

The **Oracle Cost-Based Optimizer (CBO)** generates execution plans for SQL statements. It has deep knowledge of:

* Data statistics
* Indexes
* Joins
* Histograms
* Cardinality and selectivity

With a single SQL statement:

* The optimizer can **rewrite**, **reorder**, **combine**, or **parallelize** operations.
* It can push filters early, eliminate joins, or replace subqueries with joins.

PL/SQL blocks, however, execute SQL statements **one at a time**, and the optimizer sees them in isolation. It cannot **globally optimize** across all procedural steps.

### **Transactional Overhead and Undo/Redo Pressure**

* Each SQL statement inside a PL/SQL loop generates its own **undo** and **redo** entries.
* A single SQL statement generates these **once**, in a set-optimized fashion.

For large transactions, this difference can:

* Reduce **log file switch frequency**
* Lower **archive log generation**
* Improve **transaction commit performance**

### **Parallel Execution Support**

Oracle's engine can **automatically parallelize** a single SQL query if parallelism is enabled and the tables are eligible.

Example:

```sql
UPDATE /*+ parallel(4) */ orders SET status = 'CLOSED' WHERE created_date < SYSDATE - 30;
```

In PL/SQL, parallelism is **manual and complex**, requiring:

* DBMS\_PARALLEL\_EXECUTE
* Custom job splitting logic
* Additional synchronization and error handling

### **Memory and Temporary Segment Utilization**

Single SQL:

* Allows Oracle to optimize usage of **PGA**, **buffer cache**, and **temp space** based on cost models.
* Uses **internal sort and join algorithms** efficiently.

PL/SQL:

* Loads and processes rows in memory explicitly.
* May cause more temp space spills and memory fragmentation if not written with bulk operations.

### **Locking, Latching, and Concurrency**

A single SQL query applies:

* **Minimal locking**, often in bulk mode
* **Efficient row-level locking** through internal optimization
* **Latch management** for consistent read and write access

PL/SQL loops can:

* Lock rows individually
* Increase **row-level contention**
* Result in **deadlocks** if not designed carefully

### **Auditing, Logging, and Execution Tracking**

Single SQL is:

* Easy to audit using Oracle features like `V$SQL`, `DBA_HIST_SQLSTAT`
* Logged as a single SQL\_ID
* Easier to monitor and analyze for performance

PL/SQL introduces:

* Multiple statements, each with its own SQL\_ID
* Complex control structures, making runtime behavior harder to trace

### **Error Handling Considerations**

PL/SQL allows per-row error handling, which is sometimes necessary.

However, this benefit comes at the cost of performance. It’s better to:

* Try a **single SQL** and catch a global failure,
* Or batch process data using **FORALL with SAVE EXCEPTIONS** for efficiency with controlled fault-tolerance.

