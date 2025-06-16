# Native SQL Queries

## About

A **Native SQL Query** is a way to use **SQL** (Structured Query Language) directly within the **JPA** framework. Unlike **JPQL** or **Criteria API**, which are object-oriented and abstract from the underlying database, a **Native SQL Query** lets you write the exact **SQL syntax** (such as SELECT, INSERT, UPDATE, DELETE) specific to your relational database.

With native queries, you can execute **complex SQL statements** that might be difficult or impossible to express with **JPQL** or **Criteria API**, such as **database-specific functions**, **complex joins**, and **performance optimizations** (e.g., using database indexes or hints).

## Characteristics

<table data-full-width="true"><thead><tr><th width="239.23046875">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>Direct SQL</strong></td><td>You write raw SQL queries, exactly as you would in your database.</td></tr><tr><td><strong>Database-Specific</strong></td><td>Native SQL can be customized to specific database features and syntax.</td></tr><tr><td><strong>No Object Mapping</strong></td><td>Unlike JPQL, native queries work directly with tables and columns, not entities.</td></tr><tr><td><strong>Performance Optimization</strong></td><td>Allows fine-grained control for performance by using specific SQL optimizations (indexes, joins, etc.).</td></tr><tr><td><strong>Flexibility</strong></td><td>You can use all SQL features (like complex joins, unions, and aggregate functions).</td></tr></tbody></table>

## Syntax Structure

In JPA, native SQL queries are executed using the `EntityManager` and `createNativeQuery` method.

#### Basic Syntax Example

```java
String sql = "SELECT * FROM Employee WHERE department = :dept";
Query query = entityManager.createNativeQuery(sql);
query.setParameter("dept", "Sales");
List<Object[]> result = query.getResultList();
```

#### Example with Native Query and Mapping to Entity

```java
String sql = "SELECT * FROM Employee WHERE department = :dept";
Query query = entityManager.createNativeQuery(sql, Employee.class);
query.setParameter("dept", "Sales");
List<Employee> result = query.getResultList();
```

In this case, the `Employee` entity class is mapped to the result of the query.

## Examples

### Prerequisites

**Entity Class** - `Employee.java`

```java
import jakarta.persistence.*;

@Entity
@Table(name = "employee")
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String department;

    private double salary;

    // Constructors
    public Employee() {}

    public Employee(String name, String department, double salary) {
        this.name = name;
        this.department = department;
        this.salary = salary;
    }

    // Getters and setters
    public Long getId() { return id; }
    public String getName() { return name; }
    public String getDepartment() { return department; }
    public double getSalary() { return salary; }

    public void setId(Long id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setDepartment(String department) { this.department = department; }
    public void setSalary(double salary) { this.salary = salary; }
}
```

**Repository Layer** (`EmployeeRepository.java`)

```java
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.Query;

import java.util.List;

@Repository
public class EmployeeRepository {

    @PersistenceContext
    private EntityManager entityManager;

    /**
    public List<Employee> findEmployeesWithSalaryGreaterThan(double amount) {
        String sql = "SELECT * FROM employee WHERE salary > :amount";
        Query query = entityManager.createNativeQuery(sql, Employee.class);
        query.setParameter("amount", amount);
        return query.getResultList();
    }
    **/
}
```



### 1. Basic SELECT Query

```java
public List<Employee> findEmployeesWithSalaryGreaterThan(double amount) {
    String sql = "SELECT * FROM employee WHERE salary > :amount";
    Query query = entityManager.createNativeQuery(sql, Employee.class);
    query.setParameter("amount", amount);
    return query.getResultList();
}
```

_Get all employees with salary greater than 50,000._

### 2. JOIN Query

```java
public List<Object[]> findEmployeeNamesByDepartment(String dept) {
    String sql = "SELECT e.name, d.name " +
                 "FROM employee e " +
                 "JOIN department d ON e.department_id = d.id " +
                 "WHERE d.name = :dept";

    Query query = entityManager.createNativeQuery(sql);
    query.setParameter("dept", dept);

    List<Object[]> result = query.getResultList(); // Each Object[] contains [employeeName, departmentName]
    return result;
}
```

_Get employee names and their department names in the HR department._

### 3. Aggregations

```java
public Double getAverageSalary() {
    String sql = "SELECT AVG(salary) FROM employee";
    Query query = entityManager.createNativeQuery(sql);
    return (Double) query.getSingleResult();
}
```

_Get the average salary of all employees._

### 4. Update Query

```java
public int increaseSalaryByDepartment(String dept) {
    String sql = "UPDATE employee SET salary = salary + 5000 WHERE department = :dept";
    Query query = entityManager.createNativeQuery(sql);
    query.setParameter("dept", dept);
    return query.executeUpdate(); // returns number of rows affected
}
```

_Increase salary by 5,000 for all employees in the IT department._

### 5. Delete Query

```java
public int deleteInactiveEmployeesBefore(LocalDate date) {
    String sql = "DELETE FROM employee WHERE last_login < :date";
    Query query = entityManager.createNativeQuery(sql);
    query.setParameter("date", date);
    return query.executeUpdate(); // returns number of rows deleted
}
```

_Delete employees who have not logged in since January 1, 2020._

### 6. Using SQL Functions

```java
public Double getMaxSalary() {
    String sql = "SELECT MAX(salary) FROM employee";
    Query query = entityManager.createNativeQuery(sql);
    return (Double) query.getSingleResult();
}
```

_Get the highest salary from all employees._

### 7. Subqueries

```java
public List<Employee> findEmployeesWithAboveAverageSalary() {
    String sql = "SELECT * FROM employee WHERE salary > (SELECT AVG(salary) FROM employee)";
    Query query = entityManager.createNativeQuery(sql, Employee.class);
    return query.getResultList();
}
```

_Get all employees whose salary is above the average salary._

### 8. Batch Operations (Insert/Update/Delete)

```java
public void insertEmployee(int id, String name, String department, double salary) {
    String sql = "INSERT INTO employee (id, name, department, salary) VALUES (?, ?, ?, ?)";
    Query query = entityManager.createNativeQuery(sql);
    query.setParameter(1, id);
    query.setParameter(2, name);
    query.setParameter(3, department);
    query.setParameter(4, salary);
    query.executeUpdate();
}
```

_Insert a new employee record into the database._

## How Native SQL Queries Compare with JPQL and Criteria API ?

<table data-full-width="true"><thead><tr><th>Feature</th><th>Native SQL</th><th>JPQL</th><th>Criteria API</th></tr></thead><tbody><tr><td><strong>SQL Syntax</strong></td><td>✅ Uses exact SQL syntax</td><td>❌ Does not use SQL syntax</td><td>❌ Does not use SQL syntax</td></tr><tr><td><strong>Database-Specific</strong></td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td></tr><tr><td><strong>Type-Safety</strong></td><td>❌ No</td><td>❌ No</td><td>✅ Yes</td></tr><tr><td><strong>Dynamic Query Support</strong></td><td>✅ Yes</td><td>✅ Yes</td><td>✅ Yes</td></tr><tr><td><strong>Portability</strong></td><td>❌ Database-specific</td><td>✅ High</td><td>✅ High</td></tr><tr><td><strong>Complex Queries</strong></td><td>✅ Best</td><td>⚠️ Moderate</td><td>⚠️ Moderate</td></tr></tbody></table>



















