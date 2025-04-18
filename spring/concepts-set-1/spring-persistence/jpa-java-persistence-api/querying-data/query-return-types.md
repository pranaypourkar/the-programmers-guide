# Query Return Types

## About

In JPA, query return types refer to the kind of data you expect back when executing a query (JPQL, Criteria, or Native SQL). Depending on the query and the method used, JPA can return:

* Single entities
* Scalar values (like `Long`, `String`, `Integer`)
* DTOs (custom projections)
* Aggregates
* Tuples (multiple fields)
* Collections

## Characteristics

<table><thead><tr><th width="147.53515625">Return Type</th><th>Description</th></tr></thead><tbody><tr><td>Entity</td><td>Returns full entity objects (mapped to a table).</td></tr><tr><td>DTO/Projection</td><td>Returns only selected fields using constructor expressions or interfaces.</td></tr><tr><td>Scalar</td><td>Returns basic types (e.g., count, sum, string).</td></tr><tr><td>List</td><td>Returns multiple results.</td></tr><tr><td>Single Result</td><td>Returns one result or throws exception if not found or more than one.</td></tr><tr><td>Tuple/Array</td><td>Returns multiple selected columns (e.g., in projections).</td></tr></tbody></table>

## Syntax Structure

### **1. Entity Object (Default)**

```java
@Query("SELECT e FROM Employee e WHERE e.department = :dept")
List<Employee> findByDepartment(String dept);
```

### **2. Scalar Value**

```java
@Query("SELECT COUNT(e) FROM Employee e")
Long countEmployees();
```

### **3. Multiple Scalar Values (Array or Tuple)**

```java
@Query("SELECT e.name, e.salary FROM Employee e")
List<Object[]> findNameAndSalary();
```

```java
for (Object[] row : resultList) {
   String name = (String) row[0];
   Double salary = (Double) row[1];
}
```

### **4. DTO via Constructor Expression (JPQL)**

```java
@Query("SELECT new com.example.EmployeeDTO(e.name, e.salary) FROM Employee e")
List<EmployeeDTO> findEmployeeDTOs();
```

DTO class

```java
public class EmployeeDTO {
   public EmployeeDTO(String name, Double salary) {
       //...
   }
}
```

### **5. DTO via Interface (Spring Projections)**

```java
public interface EmployeeView {
    String getName();
    Double getSalary();
}
```

```java
List<EmployeeView> findByDepartment(String department);
```

### **6. Single Result**

```java
@Query("SELECT e FROM Employee e WHERE e.id = :id")
Employee findOneById(Long id);
```









