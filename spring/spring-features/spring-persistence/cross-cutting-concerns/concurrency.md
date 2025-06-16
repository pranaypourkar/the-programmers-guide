# Concurrency

## About

Concurrency in the context of Spring JPA deals with the scenario where multiple users or processes might try to access and modify the same data simultaneously. This is important because without proper management, we could end up with **race conditions** (where multiple transactions interfere with each other) or **lost updates** (where one transaction overwrites another).

Concurrency Handling can be achieved through -

1. Optimistic Locking
2. Pessimistic Locking
3. Versioning
4. Transaction Isolation Levels

## **Optimistic Locking**

Optimistic Locking is used when you assume that conflicts are rare, and so, transactions are allowed to proceed without locks. When a transaction commits, it checks whether another transaction has modified the data in the meantime.

* **How it works:**
  * Add a version field to the entity, typically using `@Version`.
  * When a transaction is committed, the database checks whether the version of the entity being saved is the same as the one it loaded earlier.
  * If the versions don’t match, a `OptimisticLockException` is thrown.
* **Example:**

```java
@Entity
public class Employee {

    @Id
    private Long id;

    @Version
    private Long version;

    private String name;
    private Double salary;

    // Getters and Setters
}
```

* **In practice:**
  * When two users attempt to update the same entity simultaneously, **one of them will fail** with an `OptimisticLockException`.
  * It’s ideal for systems where conflicts are infrequent and performance is a concern.

## **Pessimistic Locking**

Pessimistic Locking is used when you expect conflicts to be frequent, and therefore, you explicitly lock the data during the transaction to prevent other transactions from modifying it.

* **How it works:**
  * You explicitly lock a record in the database, either by row or table level.
  * The database will prevent other transactions from modifying the locked data until the transaction is committed.
* **Types of Pessimistic Locks:**
  * **Pessimistic Read:** Locks the record for reading, allowing no other transaction to write it.
  * **Pessimistic Write:** Locks the record for both reading and writing, disallowing other transactions from reading or writing the locked record.
* **Example (Pessimistic Write):**

```java
public Employee getEmployeeForUpdate(Long id) {
    return entityManager.createQuery("SELECT e FROM Employee e WHERE e.id = :id", Employee.class)
            .setParameter("id", id)
            .setLockMode(LockModeType.PESSIMISTIC_WRITE)
            .getSingleResult();
}
```

* **In practice:**
  * This locks the selected record for writing, and no other transactions can update this row until the lock is released.
  * Pessimistic locking can lead to deadlocks if not managed properly.

## **Versioning**

Versioning is a technique where a field (usually annotated with `@Version`) is maintained in the database schema and incremented with each update to the entity. It is closely related to **Optimistic Locking**.

* **How it works:**
  * You define a field (typically of type `Long` or `Integer`) in the entity and annotate it with `@Version`.
  * Each time the entity is updated, the version number is incremented automatically by JPA.
  * This version field is then checked during updates to see if the version matches the current value in the database.
* **Example:**

```java
@Entity
public class Order {

    @Id
    private Long id;

    @Version
    private Long version;

    private String product;
    private int quantity;

    // Getters and setters
}
```

* **In practice:**
  * The `version` column will be updated every time the entity is modified.
  * If two transactions attempt to update the same entity, the version will prevent one of them from committing.

## **Transaction Isolation Levels**

The isolation level defines how transactions are isolated from one another, impacting the behavior of concurrent transactions. The following are the common isolation levels:

* **READ\_UNCOMMITTED:**
  * Allows transactions to read data that hasn't been committed yet (dirty reads).
  * This isolation level is rarely used, as it can lead to inconsistent results.
* **READ\_COMMITTED:**
  * A transaction can only read data that has been committed by other transactions.
  * Prevents dirty reads but still allows non-repeatable reads (where a value can change during a transaction).
* **REPEATABLE\_READ:**
  * Ensures that if a transaction reads a value, it will see the same value even if another transaction changes the data.
  * Prevents dirty reads and non-repeatable reads, but phantom reads can still occur.
* **SERIALIZABLE:**
  * The highest level of isolation. It prevents dirty reads, non-repeatable reads, and phantom reads.
  * Ensures transactions are executed in a serial manner, which can have a significant performance impact.
* **In Spring JPA:**
  * We can set the isolation level on a `@Transactional` annotation, and Spring will manage the transaction according to the specified isolation level.

```java
@Transactional(isolation = Isolation.REPEATABLE_READ)
public void updateSalary(Long employeeId, Double newSalary) {
    Employee employee = employeeRepository.findById(employeeId).get();
    employee.setSalary(newSalary);
    employeeRepository.save(employee);
}
```

* **In practice:**
  * Higher isolation levels such as `SERIALIZABLE` can lead to **performance bottlenecks** due to locking and waiting.

## **Deadlock**

A **deadlock** happens when two or more transactions are waiting for each other to release locks, causing the system to be in a perpetual state of waiting.

* **In practice:**
  * This is most common when **pessimistic locks** are used excessively.
  * Proper transaction management (e.g., always locking resources in the same order) can help prevent deadlocks.
  * Database engines like Oracle and MySQL detect and resolve deadlocks by aborting one of the transactions.

## Concurrency Best Practices in Spring JPA

1. **Use Optimistic Locking** for most scenarios where conflicts are unlikely to occur, as it provides better performance and is easier to scale.
2. **Use Pessimistic Locking** only when you're certain that conflicts are frequent and need to prevent them at all costs.
3. **Choose the right Isolation Level** for your application:
   * If you're working with critical data, use `REPEATABLE_READ` or `SERIALIZABLE`.
   * For most applications, `READ_COMMITTED` provides a good balance of consistency and performance.
4. **Avoid Long Transactions** as they increase the risk of locking and deadlocks.
5. **Use `@Version` for optimistic concurrency control** to handle version-based checks automatically.
6. **Be mindful of deadlocks** — always ensure locks are acquired in a consistent order, especially when using **pessimistic locking**.

