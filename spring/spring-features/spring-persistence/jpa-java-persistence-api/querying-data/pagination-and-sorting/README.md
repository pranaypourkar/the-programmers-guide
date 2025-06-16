# Pagination & Sorting

## About

**Pagination** is the process of dividing large sets of data into manageable “pages” rather than loading everything at once. It improves performance and user experience, especially in web apps and REST APIs.

**Sorting** is the process of arranging data in a specific order, either ascending or descending, based on a field or multiple fields. It is commonly used in querying databases to improve the user experience and ensure that data is displayed in an organized, predictable manner.

### **Why Pagination?**

* Prevents memory overload from loading thousands of records.
* Enhances performance by querying only what is needed.
* Enables efficient data browsing on front-end UIs.
* Reduces response size in API results.

### **Why Sorting?**

* **Enhances User Experience**: Sorting data allows users to find relevant information easily (e.g., sorting by date, price, or name).
* **Improves Readability**: Organized data is easier to read and interpret, especially for large datasets.
* **Optimizes Data Processing**: In some cases, sorted data can improve the performance of certain queries or algorithms.
* **Supports Better Data Analysis**: Sorting helps in finding trends and making sense of large volumes of data by looking at ordered sequences.

## **Characteristics**

<table><thead><tr><th width="218.125">Feature</th><th>Description</th></tr></thead><tbody><tr><td>Page Numbering</td><td>Typically zero-based (Page 0 = first page).</td></tr><tr><td>Page Size</td><td>Defines how many records per page (e.g., 10, 20, 50).</td></tr><tr><td>Sorting</td><td>Can be applied along with pagination.</td></tr><tr><td>Total Pages and Elements</td><td>Useful metadata returned by pagination logic.</td></tr><tr><td>Navigability</td><td>Allows going to next, previous, first, or last pages.</td></tr></tbody></table>

## **Pagination in JPA**

JPA provides pagination using the `javax.persistence.Query` API via:

```java
import jakarta.persistence.*;
import java.util.List;

// Entity class
@Entity
@Table(name = "employees")
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String firstName;
    private String lastName;
    private String department;

    // Constructors, getters, setters
    public Employee() {}

    public Employee(String firstName, String lastName, String department) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.department = department;
    }

    // Getters and setters omitted for brevity
}
```

```java
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import java.util.List;

public class EmployeeRepository {

    private final EntityManager entityManager;

    public EmployeeRepository(EntityManager entityManager) {
        this.entityManager = entityManager;
    }

    public List<Employee> findPaginatedEmployees(int page, int pageSize) {
        int offset = page * pageSize;

        Query query = entityManager.createQuery("SELECT e FROM Employee e");
        query.setFirstResult(offset);     // starting point
        query.setMaxResults(pageSize);    // number of records to fetch

        return query.getResultList();
    }
}
```

* `setFirstResult(int startPosition)` — Offset (zero-based).
* `setMaxResults(int maxResult)` — Limit.

{% hint style="info" %}
Use this when using native JPA (not Spring Data).
{% endhint %}

## **Pagination in Spring Data JPA**

Spring Data makes pagination very simple using the `PagingAndSortingRepository` or `JpaRepository`:

```java
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    // Inherits: Page<Employee> findAll(Pageable pageable);
}
```

#### Create Pageable and Return of Type: `Page<T>`

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> getPaginatedEmployees(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);           // Page index starts from 0
        Page<Employee> resultPage = employeeRepository.findAll(pageable);
        return resultPage.getContent();                           // Extract list from Page
    }
}
```

## **Sorting with Pagination**

We can combine pagination and sorting easily:

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    // No custom methods needed for basic pagination + sorting
}
```

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> getEmployeesSortedBySalaryDesc(int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("salary").descending());
        Page<Employee> employeePage = employeeRepository.findAll(pageable);
        return employeePage.getContent();
    }

    public List<Employee> getEmployeesSortedByDeptThenSalary(int page, int size) {
        Sort sort = Sort.by("department").ascending().and(Sort.by("salary").descending());
        Pageable pageable = PageRequest.of(page, size, sort);
        Page<Employee> employeePage = employeeRepository.findAll(pageable);
        return employeePage.getContent();
    }
}
```

## **Custom Query with Pagination**

We can paginate custom queries too

```java
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    @Query("SELECT e FROM Employee e WHERE e.department = :dept")
    Page<Employee> findByDepartment(@Param("dept") String dept, Pageable pageable);
}
```

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> getPaginatedEmployeesByDepartment(String department, int page, int size) {
        Pageable pageable = PageRequest.of(page, size); // no sorting
        Page<Employee> resultPage = employeeRepository.findByDepartment(department, pageable);
        return resultPage.getContent();
    }

    public List<Employee> getSortedEmployeesByDepartment(String department, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("salary").descending());
        Page<Employee> resultPage = employeeRepository.findByDepartment(department, pageable);
        return resultPage.getContent();
    }
}
```

Spring Data automatically applies `LIMIT` and `OFFSET`.

## **Native Query Pagination (JPA + Spring Data)**

```java
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    @Query(
        value = "SELECT * FROM employee WHERE department = :dept",
        countQuery = "SELECT count(*) FROM employee WHERE department = :dept",
        nativeQuery = true
    )
    Page<Employee> findByDeptNative(@Param("dept") String dept, Pageable pageable);
}
```

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Employee> getNativePaginatedEmployeesByDepartment(String dept, int page, int size) {
        Pageable pageable = PageRequest.of(page, size); // No sort
        Page<Employee> resultPage = employeeRepository.findByDeptNative(dept, pageable);
        return resultPage.getContent();
    }

    public List<Employee> getNativeSortedEmployeesByDepartment(String dept, int page, int size) {
        Pageable pageable = PageRequest.of(page, size, Sort.by("salary").descending());
        Page<Employee> resultPage = employeeRepository.findByDeptNative(dept, pageable);
        return resultPage.getContent();
    }
}
```

We must manually supply a `countQuery` when using native SQL.

## **Pagination with Criteria API**

The **Criteria API** in JPA is a programmatic way to build dynamic, type-safe queries and it also supports pagination using the same concept as regular JPQL: `setFirstResult()` and `setMaxResults()` on the `TypedQuery`.

### **Basic Pagination with Criteria API**

```java
CriteriaBuilder cb = entityManager.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> root = cq.from(Employee.class);
cq.select(root);

// Create the query
TypedQuery<Employee> query = entityManager.createQuery(cq);

// Apply pagination
query.setFirstResult(0);     // offset (e.g., page 1 => 0)
query.setMaxResults(10);     // limit (e.g., 10 records per page)

List<Employee> employees = query.getResultList();
```

### **Custom Pagination Example**

```java
int page = 2;
int pageSize = 20;
int offset = page * pageSize;

CriteriaBuilder cb = entityManager.getCriteriaBuilder();
CriteriaQuery<Product> cq = cb.createQuery(Product.class);
Root<Product> root = cq.from(Product.class);

// Apply filter or sort if needed
cq.where(cb.equal(root.get("category"), "Electronics"));
cq.orderBy(cb.asc(root.get("price")));

// Query with pagination
TypedQuery<Product> query = entityManager.createQuery(cq);
query.setFirstResult(offset);      // skip previous records
query.setMaxResults(pageSize);     // limit

List<Product> results = query.getResultList();
```

### **Pagination + Count Query (Total Records)**

To get the **total number of records** for the result (needed to compute total pages), we must run a separate count query

```java
CriteriaQuery<Long> countQuery = cb.createQuery(Long.class);
countQuery.select(cb.count(countQuery.from(Product.class)));
countQuery.where(cb.equal(root.get("category"), "Electronics"));

Long totalCount = entityManager.createQuery(countQuery).getSingleResult();
```

Then we can calculate

```java
int totalPages = (int) Math.ceil((double) totalCount / pageSize);
```

### **Sort with Criteria API**

```java
cq.orderBy(cb.asc(root.get("lastName")), cb.desc(root.get("salary")));
```

## **Recommended Approach for Complex Queries with Pagination and Sorting**

### **1. Use JPQL for Moderate Complexity Queries**

If our query can be expressed in JPQL (and we don’t need advanced SQL-specific features), **JPQL** is the most straightforward option. It’s simple to write, type-safe, and integrates seamlessly with Spring Data JPA.

### **2. Use Criteria API for Highly Dynamic Queries**

If we need to **dynamically build queries** or work with complex conditions and filters at runtime, **Criteria API** is the best choice. It provides a lot of flexibility and is great for queries that depend on runtime conditions.

### **3. Use Native SQL for Performance-Critical Queries**

When we need **raw performance** or need to use **specific database features** (e.g., advanced SQL functions, custom DB optimizations), then **native SQL** is ideal. This is particularly useful for very complex, non-standard queries.

### **4. Use Spring Data JPA Derived Queries for Simple Cases**

For simple queries where no joins or complex logic are needed, **Spring Data JPA’s derived query methods** are the easiest and most convenient solution.

### **5. Use Named Queries for Reusable Static Queries**

If we have **predefined queries** that will be used repeatedly across your app, consider using **named queries**. They can be more efficient and maintainable for repeated use.

## **Paging vs Slicing**

<table data-header-hidden><thead><tr><th width="123.27734375"></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><code>Page&#x3C;T></code></td><td><code>Slice&#x3C;T></code></td></tr><tr><td>Contains</td><td>Content + total elements, pages</td><td>Only content + hasNext flag</td></tr><tr><td>Performance</td><td>Heavier due to total count query</td><td>Lighter, no total count query</td></tr><tr><td>Use Case</td><td>When total pages/info needed</td><td>When just next/previous navigation</td></tr></tbody></table>
