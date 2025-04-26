# Example - Employee Portal

## About

Here is an example of building an **Employee Search API** using **Spring Boot + JPA Specifications**. This includes filtering (name, department, salary range), pagination, and sorting.

## Project Structure

```
com.example.employeeportal
│
├── controller
│   └── EmployeeController.java
├── model
│   └── Employee.java
├── repository
│   └── EmployeeRepository.java
├── specification
│   └── EmployeeSpecification.java
├── service
│   └── EmployeeService.java
└── EmployeePortalApplication.java
```

## Entity: `Employee.java`

```java
package com.example.employeeportal.model;

import jakarta.persistence.*;

@Entity
public class Employee {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String department;
    private Double salary;

    // Getters and Setters
}
```

## Repository: `EmployeeRepository.java`

```java
package com.example.employeeportal.repository;

import com.example.employeeportal.model.Employee;
import org.springframework.data.jpa.repository.*;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long>, JpaSpecificationExecutor<Employee> {
}
```

## Specification: `EmployeeSpecification.java`

```java
package com.example.employeeportal.specification;

import com.example.employeeportal.model.Employee;
import org.springframework.data.jpa.domain.Specification;

public class EmployeeSpecification {

    public static Specification<Employee> hasName(String name) {
        return (root, query, builder) ->
            name != null ? builder.like(builder.lower(root.get("name")), "%" + name.toLowerCase() + "%") : null;
    }

    public static Specification<Employee> hasDepartment(String department) {
        return (root, query, builder) ->
            department != null ? builder.equal(root.get("department"), department) : null;
    }

    public static Specification<Employee> hasSalaryBetween(Double min, Double max) {
        return (root, query, builder) -> {
            if (min != null && max != null) {
                return builder.between(root.get("salary"), min, max);
            } else if (min != null) {
                return builder.greaterThanOrEqualTo(root.get("salary"), min);
            } else if (max != null) {
                return builder.lessThanOrEqualTo(root.get("salary"), max);
            } else {
                return null;
            }
        };
    }
}
```

## Service: `EmployeeService.java`

```java
package com.example.employeeportal.service;

import com.example.employeeportal.model.Employee;
import com.example.employeeportal.repository.EmployeeRepository;
import com.example.employeeportal.specification.EmployeeSpecification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public Page<Employee> search(String name, String dept, Double salaryMin, Double salaryMax,
                                 int page, int size, String sortBy, String sortDir) {

        Specification<Employee> spec = Specification.where(EmployeeSpecification.hasName(name))
                .and(EmployeeSpecification.hasDepartment(dept))
                .and(EmployeeSpecification.hasSalaryBetween(salaryMin, salaryMax));

        Sort sort = Sort.by(Sort.Direction.fromString(sortDir), sortBy);
        Pageable pageable = PageRequest.of(page, size, sort);

        return employeeRepository.findAll(spec, pageable);
    }
}
```

## Controller: `EmployeeController.java`

```java
package com.example.employeeportal.controller;

import com.example.employeeportal.model.Employee;
import com.example.employeeportal.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/employees")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    @GetMapping
    public ResponseEntity<Page<Employee>> getEmployees(
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String department,
            @RequestParam(required = false) Double salaryMin,
            @RequestParam(required = false) Double salaryMax,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String sortDir
    ) {
        Page<Employee> employees = employeeService.search(name, department, salaryMin, salaryMax, page, size, sortBy, sortDir);

        if (employees.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(employees);
    }
}
```

## Sample URL

{% code overflow="wrap" %}
```
GET /api/employees?name=John&department=IT&salaryMin=40000&salaryMax=80000&page=0&size=5&sortBy=salary&sortDir=desc
```
{% endcode %}

## Output (JSON)

```json
{
  "content": [
    {
      "id": 12,
      "name": "John Doe",
      "department": "IT",
      "salary": 75000.0
    },
    {
      "id": 15,
      "name": "Johnny",
      "department": "IT",
      "salary": 65000.0
    }
  ],
  "pageable": {
    "pageNumber": 0,
    "pageSize": 5
  },
  "totalElements": 2,
  "totalPages": 1,
  "last": true
}
```

