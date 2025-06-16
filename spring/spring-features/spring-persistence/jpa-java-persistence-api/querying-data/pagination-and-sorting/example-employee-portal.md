# Example - Employee Portal

## About

We have a **Employee Portal** where we can manage employee data, search using various fields, and sort in a paginated manner, the key is to build an **efficient and scalable Spring Boot API** that supports:

* Storing and retrieving employee data.
* Searching and filtering by multiple fields.
* Sorting by one or more fields.
* Paginated results.

## Solution

### **1. Entity Model: Employee**

We will begin by defining an `Employee` entity class. It will have fields like `id`, `name`, `department`, `salary`, etc.

```java
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Employee {

    @Id
    private Long id;
    private String name;
    private String department;
    private Double salary;
    private String email;
    private String phoneNumber;

    // Getters and Setters
}
```

### **2. Repository Layer**

Spring Data JPA provides a powerful mechanism to interact with the database without needing to write explicit SQL or JPQL queries. We will use `JpaRepository` to handle basic CRUD operations and enable custom queries.

```java
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    // Additional custom query methods can be added as needed
}
```

### **3. Service Layer for Pagination, Sorting, and Searching**

In the service layer, we will define methods for retrieving paginated, sorted, and filtered employee data.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    // Fetch all employees with pagination, sorting, and filtering
    public Page<Employee> getEmployees(String name, String department, Double salaryMin, Double salaryMax, Pageable pageable) {
        return employeeRepository.findAll(EmployeeSpecifications.withFilters(name, department, salaryMin, salaryMax), pageable);
    }
}
```

### **4. Specification for Filtering**

To support dynamic filtering based on user input, we can use **JPA Specifications**. This allows us to build flexible queries without writing JPQL or SQL manually.

```java
import org.springframework.data.jpa.domain.Specification;
import javax.persistence.criteria.*;

public class EmployeeSpecifications {

    public static Specification<Employee> withFilters(String name, String department, Double salaryMin, Double salaryMax) {
        return (root, query, criteriaBuilder) -> {
            Predicate predicate = criteriaBuilder.conjunction();

            if (name != null && !name.isEmpty()) {
                predicate = criteriaBuilder.and(predicate, criteriaBuilder.like(root.get("name"), "%" + name + "%"));
            }

            if (department != null && !department.isEmpty()) {
                predicate = criteriaBuilder.and(predicate, criteriaBuilder.equal(root.get("department"), department));
            }

            if (salaryMin != null) {
                predicate = criteriaBuilder.and(predicate, criteriaBuilder.greaterThanOrEqualTo(root.get("salary"), salaryMin));
            }

            if (salaryMax != null) {
                predicate = criteriaBuilder.and(predicate, criteriaBuilder.lessThanOrEqualTo(root.get("salary"), salaryMax));
            }

            return predicate;
        };
    }
}
```

### **5. Controller Layer**

In the controller, we expose the API endpoints to search, filter, sort, and paginate employee data.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/employees")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    // Get employees with pagination, sorting, and filtering
    @GetMapping
    public ResponseEntity<Page<Employee>> getEmployees(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String department,
            @RequestParam(required = false) Double salaryMin,
            @RequestParam(required = false) Double salaryMax,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDirection
    ) {
        try {
            // Create Sort and Pageable objects
            Sort sort = Sort.by(Sort.Order.by(sortBy).with(Sort.Direction.fromString(sortDirection)));
            Pageable pageable = PageRequest.of(page, size, sort);

            // Fetch employees based on provided filters
            Page<Employee> employees = employeeService.getEmployees(name, department, salaryMin, salaryMax, pageable);

            // If the employees page is empty, return a 204 No Content response
            if (employees.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            // Return employees with a 200 OK status
            return new ResponseEntity<>(employees, HttpStatus.OK);

        } catch (Exception e) {
            // If there is any error, return a 500 Internal Server Error
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
```

### **API Example**

* **GET `/employees`**: Retrieves a paginated, filtered, and sorted list of employees.

**Example Request**

{% code overflow="wrap" %}
```http
GET /employees?name=John&department=Engineering&salaryMin=50000&page=1&size=10&sortBy=name&sortDirection=desc
```
{% endcode %}

**Example Response**

```json
{
    "content": [
        {
            "id": 1,
            "name": "John Doe",
            "department": "Engineering",
            "salary": 60000,
            "email": "john.doe@example.com",
            "phoneNumber": "123-456-7890"
        },
        {
            "id": 2,
            "name": "John Smith",
            "department": "Engineering",
            "salary": 55000,
            "email": "john.smith@example.com",
            "phoneNumber": "098-765-4321"
        }
    ],
    "pageable": {
        "sort": {
            "unsorted": false,
            "sorted": true,
            "empty": false
        },
        "pageSize": 10,
        "pageNumber": 1,
        "offset": 10,
        "unpaged": false,
        "paged": true
    },
    "totalPages": 5,
    "totalElements": 50,
    "last": false,
    "first": false,
    "numberOfElements": 10,
    "size": 10,
    "number": 1,
    "sort": {
        "sorted": true,
        "unsorted": false,
        "empty": false
    }
}
```

