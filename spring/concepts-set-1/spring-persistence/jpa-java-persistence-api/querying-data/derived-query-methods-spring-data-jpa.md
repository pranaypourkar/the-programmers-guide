# Derived Query Methods (Spring Data JPA)

## About

**Derived Query Methods** are a powerful feature of **Spring Data JPA** that allow developers to define queries by simply declaring method names in repository interfaces. Spring Data JPA parses the method name and automatically generates the appropriate JPQL or SQL query behind the scenes.

This means:

* **No need to write JPQL or native SQL**
* **Method name = Query definition**

## Characteristics

<table data-full-width="true"><thead><tr><th width="266.5703125">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>Convention over Configuration</strong></td><td>We follow naming conventions instead of writing queries.</td></tr><tr><td><strong>Auto-generated Queries</strong></td><td>Spring parses method names and creates queries automatically.</td></tr><tr><td><strong>Readable &#x26; Declarative</strong></td><td>Method names are self-explanatory and easy to understand.</td></tr><tr><td><strong>Less Boilerplate Code</strong></td><td>No need for custom query implementations.</td></tr><tr><td><strong>Integration with Entities</strong></td><td>Works seamlessly with JPA entity models.</td></tr><tr><td><strong>Customizable with Keywords</strong></td><td>Support for <code>And</code>, <code>Or</code>, <code>Between</code>, <code>Like</code>, <code>In</code>, <code>OrderBy</code>, etc.</td></tr></tbody></table>

## Syntax Structure

Derived query methods follow this structure

```java
<ReturnType> findBy<PropertyName><Condition>(<ParameterType> param);
```

Spring will convert this into a JPA query based on the entity's fields.

### Common Keywords Used

| Keyword                   | Meaning            |
| ------------------------- | ------------------ |
| `findBy`                  | Select data        |
| `countBy`                 | Count rows         |
| `existsBy`                | Check existence    |
| `deleteBy`                | Delete rows        |
| `And`, `Or`               | Logical operations |
| `Between`                 | Range checks       |
| `LessThan`, `GreaterThan` | Comparison         |
| `Like`, `NotLike`         | Pattern matching   |
| `In`, `NotIn`             | Collections        |
| `OrderBy`                 | Sorting            |
| `Top`, `First`            | Limit results      |

## Examples

### Prerequisites

Assume the following `Employee` entity:

```java
@Entity
public class Employee {
    @Id
    private Long id;

    private String name;
    private String department;
    private Double salary;
    private LocalDate joinDate;
}
```

And a repository interface:

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
}
```

### Basic Queries

```java
import com.example.demo.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    // Derived Query
    List<Employee> findByDepartment(String department);
}
```

_Find employees in a specific department._

```java
Employee findByName(String name);
```

_Find employee by exact name._

### Combined Conditions

```java
List<Employee> findByDepartmentAndSalaryGreaterThan(String department, Double salary);
```

_Find employees in a department with salary above a threshold._

```java
List<Employee> findByNameOrDepartment(String name, String department);
```

_Find employees either by name or department._

### Comparison Operators

```java
List<Employee> findBySalaryLessThan(Double salary);
List<Employee> findByJoinDateAfter(LocalDate date);
```

_Filter employees based on salary or join date._

### Pattern Matching

```java
List<Employee> findByNameContaining(String keyword);
List<Employee> findByNameStartingWith(String prefix);
List<Employee> findByNameEndingWith(String suffix);
```

_Partial match on name field._

### Sorting & Limiting

```java
List<Employee> findTop5ByOrderBySalaryDesc();
Employee findFirstByDepartmentOrderByJoinDateAsc();
```

_Top N queries and sorting._

### Date Ranges & Collection Checks

```java
List<Employee> findByJoinDateBetween(LocalDate start, LocalDate end);
List<Employee> findByDepartmentIn(List<String> departments);
```

_Filter employees by date range or multiple departments._

### Boolean Checks

```java
Boolean existsByName(String name);
Long countByDepartment(String department);
```

_Check if a record exists or count employees in a department._

## Comparison: Derived Query vs JPQL vs Native SQL

<table data-full-width="true"><thead><tr><th width="178.6328125">Feature</th><th width="144.7421875">Derived Query</th><th width="189.6171875">JPQL</th><th>Native SQL</th></tr></thead><tbody><tr><td><strong>Ease of Use</strong></td><td>✅ Easiest</td><td>⚠️ Moderate</td><td>❌ Requires SQL knowledge</td></tr><tr><td><strong>Custom Logic</strong></td><td>❌ Limited</td><td>✅ Moderate</td><td>✅ Full control</td></tr><tr><td><strong>Portability</strong></td><td>✅ High</td><td>✅ High</td><td>❌ Database-specific</td></tr><tr><td><strong>Type-Safety</strong></td><td>✅ Yes</td><td>❌ No</td><td>❌ No</td></tr><tr><td><strong>Complex Queries</strong></td><td>❌ Hard</td><td>⚠️ Manageable</td><td>✅ Best option</td></tr></tbody></table>







