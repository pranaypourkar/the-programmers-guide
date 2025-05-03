---
hidden: true
---

# Transactions

## About

A transaction is a sequence of operations performed as a single logical unit of work. A transaction has four key properties, commonly known as **ACID**:

* **Atomicity**: All operations in the transaction are completed; if one fails, all are rolled back.
* **Consistency**: The database remains in a consistent state before and after the transaction.
* **Isolation**: Transactions are isolated from each other.
* **Durability**: Once a transaction is committed, its effects are permanent.

## Spring Transaction Management

Spring provides **declarative transaction management** using the `@Transactional` annotation. We can also use programmatic transaction management using `PlatformTransactionManager`, but declarative is most common.

#### Basic Usage

```java
@Transactional
public void transferFunds(Account from, Account to, double amount) {
    from.debit(amount);
    to.credit(amount);
    accountRepository.save(from);
    accountRepository.save(to);
}
```

* If any exception is thrown, all operations are rolled back.
* By default, only **unchecked exceptions (RuntimeException, Error)** trigger rollback.
* To rollback on checked exceptions, specify it explicitly:

```java
@Transactional(rollbackFor = Exception.class)
```

## Important Terminology

### **1. Dirty Read**

A **dirty read** happens when a transaction reads data that has been modified by another transaction but not yet committed.

**Example:**

* Transaction A updates a row's value but hasn't committed yet.
* Transaction B reads the updated value (which is uncommitted).
* If Transaction A rolls back, Transaction B has read a value that never officially existed.

Prevented by: `READ_COMMITTED`, `REPEATABLE_READ`, `SERIALIZABLE`&#x20;

### **2. Non-Repeatable Read**

A **non-repeatable read** occurs when a transaction reads the same row twice and gets **different values**, because another transaction modified and committed changes in between the two reads.

**Example:**

* Transaction A reads a row.
* Transaction B updates and commits that same row.
* Transaction A reads the row again and sees a different value.

Prevented by: `REPEATABLE_READ`, `SERIALIZABLE`&#x20;

### **3. Phantom Read**

A **phantom read** occurs when a transaction runs the same query twice and gets **additional rows** the second time, due to another transaction inserting new data that matches the query criteria.

**Example:**

* Transaction A queries all employees with salary > 50k.
* Transaction B inserts a new employee with salary 60k and commits.
* Transaction A runs the query again and sees a new row it didn’t see before.

Prevented by: `SERIALIZABLE` (the strictest isolation level)

## Transactional Attributes

When we annotate a method or class with `@Transactional`, Spring manages the transaction boundaries for us. The annotation supports several key attributes that modify transactional behavior.

<table><thead><tr><th width="160.80078125">Attribute</th><th>Description</th></tr></thead><tbody><tr><td><code>propagation</code></td><td>Defines how transactions relate to each other.</td></tr><tr><td><code>isolation</code></td><td>Defines the isolation level for the transaction.</td></tr><tr><td><code>readOnly</code></td><td>Marks transaction as read-only for performance optimization.</td></tr><tr><td><code>timeout</code></td><td>Specifies the time in seconds before a transaction times out.</td></tr><tr><td><code>rollbackFor</code></td><td>Specifies which exceptions trigger a rollback.</td></tr></tbody></table>

### 1. Propagation

The `propagation` attribute in Spring's `@Transactional` annotation defines how a transactional method should behave when it is called from another transactional context. It determines whether the method should join an existing transaction, start a new one, or execute without any transaction. The default value, `REQUIRED`, means that the method will participate in the current transaction if one exists or start a new one if not.

#### **Why Propagation Matters?**

In a multi-layered application, service methods often call other service methods. These methods may or may not be transactional. Propagation determines:

* Whether a new transaction should be created.
* Whether the existing transaction should be used.
* Whether the current transaction should be suspended.
* Whether a transaction is even allowed.

#### Common Values:

<table><thead><tr><th width="185.61328125">Propagation Type</th><th>Description</th></tr></thead><tbody><tr><td><code>REQUIRED</code> (default)</td><td>Joins existing transaction or starts a new one if none exists.</td></tr><tr><td><code>REQUIRES_NEW</code></td><td>Suspends the current transaction and starts a new one.</td></tr><tr><td><code>SUPPORTS</code></td><td>Runs in a transaction if one exists; otherwise, runs non-transactionally.</td></tr><tr><td><code>NOT_SUPPORTED</code></td><td>Always runs non-transactionally, suspending any current transaction.</td></tr><tr><td><code>NEVER</code></td><td>Must not run in a transaction; throws exception if a transaction exists.</td></tr><tr><td><code>MANDATORY</code></td><td>Must run within an existing transaction; throws exception if none exists.</td></tr><tr><td><code>NESTED</code></td><td>Executes within a nested transaction (uses savepoints); rollback only affects inner scope.</td></tr></tbody></table>

#### Example:

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logAuditEvent(AuditEvent event) {
    auditRepo.save(event);
}
```

#### **1. Propagation.REQUIRED**

If a transaction already exists, the method will join that transaction. If there is no existing transaction, a new one will be started.

Most `create`, `update`, and `delete` operations should use `REQUIRED`. It's safe and ensures all database operations are rolled back together if something goes wrong.

```java
@Transactional(propagation = Propagation.REQUIRED)
public void saveEmployee(Employee emp) {
    employeeRepository.save(emp); // Uses existing transaction or starts a new one
}
```

Behavior:

* Outer method starts a transaction
* Inner method joins the same transaction
* If inner method fails, outer also rolls back

#### **2. Propagation.REQUIRES\_NEW**

Always starts a new transaction. If a transaction is already active, it will be suspended until the new one completes.

Logging, auditing, or sending notifications where the operation should be committed even if the main transaction fails.

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logAudit(String action) {
    auditRepository.save(new Audit(action));
}
```

```java
@Transactional
public void createEmployee(Employee emp) {
    employeeRepository.save(emp);
    logAudit("Employee created"); // Even if this fails, the employee is still saved
}
```

Behavior:

* Outer method has a transaction
* Inner method suspends outer transaction and runs in a new one
* Failure in outer does not affect committed inner transaction

#### **3. Propagation.SUPPORTS**

If a transaction exists, join it. If not, run the method non-transactionally.

Read-only methods or reports that can execute inside or outside a transaction.

```java
@Transactional(propagation = Propagation.SUPPORTS)
public List<Employee> getAllEmployees() {
    return employeeRepository.findAll();
}
```

#### Behavior:

* Adapts to the context
* Flexible for shared methods (read logic)

#### **4. Propagation.NOT\_SUPPORTED**

The method will never run inside a transaction. If a transaction exists, it will be suspended.

Reporting, batch export jobs, or read-only operations where you don’t want transactional overhead.

```java
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public void exportDataToCSV() {
    // Will not participate in a transaction
    performExport();
}
```

Behavior:

* Any existing transaction is suspended
* No rollback will occur on failure
* Can improve performance for long reads

#### **5. Propagation.NEVER**

The method must not run inside a transaction. If a transaction exists, Spring throws an exception.

Calls to third-party services or external systems that cannot be wrapped in a transaction.

```java
@Transactional(propagation = Propagation.NEVER)
public void callExternalService() {
    // Throws exception if there is an active transaction
    thirdPartyAPI.sendData();
}
```

#### Behavior:

* Enforces strict non-transactional context
* Guarantees no database locks or rollbacks happen

#### **6. Propagation.MANDATORY**

The method must be executed inside an existing transaction. If no transaction exists, an exception is thrown.

Utility methods that modify shared data and should always be part of a larger transaction.

```java
@Transactional(propagation = Propagation.MANDATORY)
public void updateStatistics() {
    // Fails if not called inside another transaction
    statisticsRepository.updateCounts();
}
```

Behavior:

* Only works if called from another method with a transaction
* Prevents accidental non-transactional writes

#### **7. Propagation.NESTED**

Runs inside a nested transaction. If the outer transaction rolls back, the nested one rolls back too. If the nested one fails, it can rollback independently using savepoints.

Use when you want part of a transaction to be rollback-safe without affecting the whole transaction.

```java
@Transactional(propagation = Propagation.NESTED)
public void adjustSalary() {
    // Can rollback independently using savepoints
    updateBonuses();
    updateDeductions();
}
```

```java
@Transactional
public void updateEmployeeDetails() {
    saveDetails();
    try {
        adjustSalary(); // Nested call
    } catch (Exception ex) {
        // Only salary changes rollback, not the entire employee update
    }
}
```

#### Behavior:

* Requires database support for nested transactions
* Useful when rollback granularity is needed

### 2. Isolation

The `isolation` attribute controls the level of visibility that one transaction has into the operations of another. It governs concurrency-related issues such as dirty reads, non-repeatable reads, and phantom reads. The attribute corresponds directly to isolation levels supported by the underlying database (e.g., `READ_COMMITTED`, `REPEATABLE_READ`, `SERIALIZABLE`).

#### Common Isolation Levels:

<table><thead><tr><th width="252.0703125">Isolation Level</th><th>Description</th></tr></thead><tbody><tr><td><code>DEFAULT</code></td><td>Uses the default isolation level of the underlying database.</td></tr><tr><td><code>READ_UNCOMMITTED</code></td><td>Allows dirty reads; no isolation.</td></tr><tr><td><code>READ_COMMITTED</code> (common)</td><td>Prevents dirty reads, but allows non-repeatable reads.</td></tr><tr><td><code>REPEATABLE_READ</code></td><td>Prevents dirty and non-repeatable reads; phantom reads may occur.</td></tr><tr><td><code>SERIALIZABLE</code></td><td>Highest isolation level; ensures full isolation, but has the lowest performance.</td></tr></tbody></table>

#### Example:

```java
@Transactional(isolation = Isolation.REPEATABLE_READ)
public Employee getEmployeeDetails(Long id) {
    return employeeRepo.findById(id).orElseThrow();
}
```

### 3. ReadOnly

The `readOnly` attribute indicates that the transaction is not intended to perform any data modifications. When set to `true`, it serves as a hint to the transaction manager and the underlying persistence provider (like Hibernate) to optimize performance—for example, by skipping dirty checks or using non-locking queries. Although it does not enforce immutability at the database level, using `readOnly = true` is a best practice for methods that only fetch data, as it can reduce overhead and improve response times.

#### Usage:

* Use it for service methods that **only read** data.
* Helps prevent accidental updates.

#### Example:

```java
@Transactional(readOnly = true)
public List<Employee> getAllEmployees() {
    return employeeRepo.findAll();
}
```

### 4. timeout

The `timeout` attribute specifies the maximum duration, in seconds, that the transaction is allowed to run. If the method execution exceeds this time, the transaction is automatically rolled back. This is particularly useful in high-load or time-sensitive applications, where long-running operations could lead to resource exhaustion or data contention. The default value is `-1`, which means no timeout. Setting an appropriate timeout helps prevent stalled transactions from holding database locks indefinitely.

#### Example:

```java
@Transactional(timeout = 5)
public void performLongTask() {
    // Will be rolled back if it takes longer than 5 seconds
}
```

### 5. RollbackFor and noRollbackFor

By default, Spring only rolls back transactions for unchecked exceptions (i.e., subclasses of `RuntimeException` and `Error`). The `rollbackFor` attribute allows customization of this behavior by explicitly declaring one or more exception types (including checked exceptions) that should trigger a rollback. This is useful when you want a transaction to roll back for business exceptions or application-specific errors that aren't runtime exceptions. It enhances control over transactional boundaries, especially in multi-layered applications.

#### By Default:

* **Unchecked exceptions** (`RuntimeException`, `Error`) → cause rollback
* **Checked exceptions** → do **not** cause rollback unless specified

#### Use `rollbackFor` to rollback for specific exceptions:

```java
@Transactional(rollbackFor = IOException.class)
public void updateFile() throws IOException {
    // Will rollback even on checked IOException
}
```

#### Use `noRollbackFor` to ignore rollback for specific exceptions:

```java
@Transactional(noRollbackFor = CustomWarningException.class)
public void updateData() throws CustomWarningException {
    // Will not rollback for CustomWarningException
}
```

### Combining Attributes

We can use multiple attributes together for fine-grained control:

#### Example:

```java
@Transactional(
    propagation = Propagation.REQUIRED,
    isolation = Isolation.READ_COMMITTED,
    timeout = 10,
    readOnly = false,
    rollbackFor = {SQLException.class}
)
public void processTransaction() {
    // your logic here
}
```

## Does Propagation Matters only when there are several methods calls inside a method ?

Propagation only matters when transactional methods call other transactional methods.\
It does not matter if you're making a direct call to a repository method without involving another service-level transactional method.

### **Case 1: Single transactional method with repository call**

```java
@Transactional(propagation = Propagation.REQUIRED)
public void createEmployee(Employee emp) {
    employeeRepository.save(emp); // Transaction starts here, managed by Spring
}
```

* There's **no method call** to another service.
* Here, propagation **does not come into play** meaningfully — `REQUIRED` is the default and it will simply begin a new transaction.

### **Case 2: Method A calls Method B (both annotated)**

```java
@Service
public class EmployeeService {

    @Transactional(propagation = Propagation.REQUIRED)
    public void methodA() {
        // do something
        methodB(); // Propagation rules apply here!
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void methodB() {
        // do something
    }
}
```

* **This is where propagation matters.**
* Spring checks if a transaction is already running when `methodA()` calls `methodB()`.
* Based on the propagation type, it will decide whether to reuse, suspend, or throw an exception.

**⚠️ Important Caveat – Internal method calls don’t trigger Spring’s proxy mechanism**

```java
public void methodA() {
    methodB(); // Even if methodB has @Transactional, it's not applied here
}
```

* If `methodA()` and `methodB()` are in the **same class**, and one calls the other **directly**, **Spring will not apply transaction propagation.**
* This is because Spring AOP uses **proxies**, and a direct internal method call bypasses the proxy.

> Workaround: Split methodB into a separate bean/service, or inject the current service into itself using a proxy-aware pattern.

