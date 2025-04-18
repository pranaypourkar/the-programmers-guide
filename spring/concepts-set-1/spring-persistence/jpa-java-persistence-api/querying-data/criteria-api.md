# Criteria API

## About

The **Criteria API** is a **type-safe**, **object-oriented** API in JPA used to create dynamic queries programmatically. Instead of writing queries as strings (like JPQL), it lets you build queries using Java objects and methods.

It was introduced in **JPA 2.0** to address issues like:

* Lack of compile-time checking in JPQL
* Difficulty in building dynamic queries using string concatenation

## Characteristics of Criteria API

<table><thead><tr><th width="275.79296875">Feature</th><th>Description</th></tr></thead><tbody><tr><td>Type-Safe</td><td>Uses Java types; errors are caught at compile time.</td></tr><tr><td>Dynamic</td><td>You can build queries conditionally at runtime.</td></tr><tr><td>Object-Oriented</td><td>Constructs queries using objects, not string-based syntax.</td></tr><tr><td>Complex Query Support</td><td>Good for building queries with complex filters and conditions.</td></tr><tr><td>Integrated with EntityManager</td><td>Uses <code>EntityManager</code> to execute queries like JPQL.</td></tr></tbody></table>

## Syntax Structure

Here’s how a typical Criteria API query looks:

```java
// 1. Get CriteriaBuilder from EntityManager
CriteriaBuilder cb = entityManager.getCriteriaBuilder();

// 2. Create CriteriaQuery
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);

// 3. Define root entity
Root<Employee> root = cq.from(Employee.class);

// 4. Add predicates and select
cq.select(root).where(cb.equal(root.get("department"), "IT"));

// 5. Execute query
List<Employee> result = entityManager.createQuery(cq).getResultList();
```

### **Step 1: Get `CriteriaBuilder` from `EntityManager`**

```java
CriteriaBuilder cb = entityManager.getCriteriaBuilder();
```

`CriteriaBuilder` is a factory object that helps create different parts of the query — like conditions (`where`), sorting (`orderBy`), grouping (`groupBy`), etc.

All Criteria queries start with a `CriteriaBuilder`. It provides methods like `equal()`, `greaterThan()`, `and()`, etc. — just like we would write in JPQL/SQL, but in an object-oriented way.

### **Step 2: Create `CriteriaQuery`**

```java
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
```

Creates the actual query object that will return `Employee` objects.

We must tell JPA what _type_ of data we’re querying. This also sets the **return type** of your query.

### **Step 3: Define the Root Entity**

```java
Root<Employee> root = cq.from(Employee.class);
```

Defines the **main entity/table** we're querying from — in SQL terms, this is like saying `FROM employee`.

It’s our main data source for the query. The `root` is what we use to access the entity fields like `root.get("department")`.

### **Step 4: Add Select and Filter Conditions (Predicates)**

```java
cq.select(root).where(cb.equal(root.get("department"), "IT"));
```

* `cq.select(root)`: selects the entire Employee entity.
* `cb.equal(...)`: builds a condition where `department = 'IT'`.
* `.where(...)`: applies that condition to the query.

We are telling JPA

> “I want all employees where department is 'IT'.”

We can also chain multiple conditions here using `cb.and()` or `cb.or()`.

### **Step 5: Execute the Query**

```java
List<Employee> result = entityManager.createQuery(cq).getResultList();
```

* Converts the CriteriaQuery to an executable JPA query.
* Runs it and fetches the result as a list of `Employee` objects.

This is where the query is actually **run on the database**, and you get your data back.

### Final Output

After all the steps, `result` will hold something like:

```java
[
  Employee{id=1, name="Alice", department="IT"},
  Employee{id=5, name="Bob", department="IT"}
]
```

### Breakdown (like SQL)

| Criteria API Equivalent                  | SQL Equivalent            |
| ---------------------------------------- | ------------------------- |
| `cb.createQuery(Employee.class)`         | `SELECT *`                |
| `cq.from(Employee.class)`                | `FROM Employee`           |
| `cb.equal(root.get("department"), "IT")` | `WHERE department = 'IT'` |

## Examples

### Prerequisites

<pre class="language-java"><code class="lang-java"><strong>// Entity Class
</strong>import jakarta.persistence.*;

<strong>@Entity
</strong>public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String department;
    private double salary;

    // Getters and Setters
}

// Repository Interface
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmployeeRepository extends JpaRepository&#x3C;Employee, Long> {
    // Empty - we will use Criteria API in service
}

// Service with Criteria API Logic

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class EmployeeService {

    @PersistenceContext
    private EntityManager entityManager;

    // Our methods
}
</code></pre>

### 1. Basic SELECT

```java
public List<Employee> getAllEmployees() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);
    cq.select(root);
    return entityManager.createQuery(cq).getResultList();
}
```

_Fetch all employees._

### 2. SELECT with WHERE

```java
public List<Employee> getEmployeesByDepartment(String department) {
        CriteriaBuilder cb = entityManager.getCriteriaBuilder();
        CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);

        Root<Employee> root = cq.from(Employee.class);
        Predicate deptPredicate = cb.equal(root.get("department"), department);

        cq.select(root).where(deptPredicate);

        return entityManager.createQuery(cq).getResultList();
    }
```

_Get employees in Sales department._

### 3. Using Multiple Conditions

```java
public List<Employee> getEmployeesFromITWithHighSalary() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);

    Predicate p1 = cb.equal(root.get("department"), "IT");
    Predicate p2 = cb.greaterThan(root.get("salary"), 50000);

    cq.select(root).where(cb.and(p1, p2));

    return entityManager.createQuery(cq).getResultList();
}
```

_IT employees with salary > 50,000._

### 4. Ordering

```java
public List<Employee> getAllEmployeesSortedBySalaryDesc() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);

    cq.select(root);
    cq.orderBy(cb.desc(root.get("salary")));

    return entityManager.createQuery(cq).getResultList();
}
```

_Order employees by salary descending._

### 5. Selecting Specific Fields (Projection)

```java
public List<String> getAllEmployeeNames() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<String> nameQuery = cb.createQuery(String.class);
    Root<Employee> empRoot = nameQuery.from(Employee.class);
    nameQuery.select(empRoot.get("name"));

    return entityManager.createQuery(nameQuery).getResultList();
}
```

_Fetch employee names._

### 6. Joins

{% hint style="info" %}
Our `Employee` entity has a field like



@ManyToOne\
private Department department;
{% endhint %}

```java
public List<Employee> getEmployeesFromFinanceDepartment() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);

    Join<Employee, Department> deptJoin = root.join("department");
    cq.select(root).where(cb.equal(deptJoin.get("name"), "Finance"));

    return entityManager.createQuery(cq).getResultList();
}
```

_Get employees in the Finance department._

### 7. Aggregate Functions

```java
public Double getAverageSalary() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Double> avgSalaryQuery = cb.createQuery(Double.class);
    Root<Employee> root = avgSalaryQuery.from(Employee.class);

    avgSalaryQuery.select(cb.avg(root.get("salary")));

    return entityManager.createQuery(avgSalaryQuery).getSingleResult();
}
```

_Get average salary._

### 8. Group By and Having

```java
public List<Object[]> getDepartmentsWithMoreThan5Employees() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Object[]> groupQuery = cb.createQuery(Object[].class);
    Root<Employee> root = groupQuery.from(Employee.class);

    groupQuery.multiselect(root.get("department"), cb.count(root))
              .groupBy(root.get("department"))
              .having(cb.gt(cb.count(root), 5));

    return entityManager.createQuery(groupQuery).getResultList();
}
```

_Departments with more than 5 employees._

{% hint style="info" %}
* **`multiselect()`**: Selects multiple values (in this case, the department and the count of employees).
* **`groupBy()`**: Groups the results by department.
* **`having()`**: Filters the grouped results, in this case to return only those departments with more than 5 employees.
{% endhint %}

### 9. Using IN Clause

```java
public List<Employee> getEmployeesInDepartments() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);

    Predicate inClause = root.get("department").in("IT", "HR", "Finance");
    cq.select(root).where(inClause);

    return entityManager.createQuery(cq).getResultList();
}
```

_Employees in IT, HR, or Finance._

### 10. Subqueries

```java
public List<Employee> getEmployeesWithSalaryGreaterThanAvg() {
    CriteriaBuilder cb = entityManager.getCriteriaBuilder();
    CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
    Root<Employee> root = cq.from(Employee.class);

    // Subquery to calculate the average salary
    Subquery<Double> sub = cq.subquery(Double.class);
    Root<Employee> subRoot = sub.from(Employee.class);
    sub.select(cb.avg(subRoot.get("salary")));

    // Main query selects employees where their salary is greater than the average
    cq.select(root).where(cb.greaterThan(root.get("salary"), sub));

    return entityManager.createQuery(cq).getResultList();
}
```

_Employees earning more than average salary._

### Criteria API vs JPQL vs SQL

<table data-full-width="true"><thead><tr><th>Feature</th><th>Criteria API</th><th>JPQL</th><th>SQL</th></tr></thead><tbody><tr><td>Type-Safety</td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td></tr><tr><td>Object-Oriented</td><td>✅ Yes</td><td>✅ Yes</td><td>❌ No</td></tr><tr><td>Complex Queries</td><td>✅ Yes</td><td>⚠️ Moderate</td><td>✅ Yes</td></tr><tr><td>Dynamic Building</td><td>✅ Best</td><td>❌ Hard</td><td>⚠️ Manual string concat</td></tr><tr><td>Compile-Time Check</td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td></tr><tr><td>Portability</td><td>✅ High</td><td>✅ High</td><td>⚠️ DB-specific syntax</td></tr><tr><td>Learning Curve</td><td>⚠️ Steep</td><td>✅ Simple</td><td>⚠️ Moderate to Hard</td></tr></tbody></table>
