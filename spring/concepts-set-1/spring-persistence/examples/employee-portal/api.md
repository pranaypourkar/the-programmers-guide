# API

## Employee APIs

* `POST /employees` – Create new employee (with optional address and department)
* `GET /employees/{id}` – Get employee by ID
* `PUT /employees/{id}` – Update employee details
* `DELETE /employees/{id}` – Delete employee
* `GET /employees?name=John&department=HR&page=0&size=10&sortBy=hireDate` – Get paginated, sorted list of employees with optional filters (name, department, salary range, etc.)
* `GET /employees/by-department/{deptId}` – Get employees by department
* `GET /employees/{id}/projects` – Get all projects assigned to an employee
* `GET /employees/{id}/salaries` – Get all salaries for an employee
* `GET /employees/search` – Advanced search using specifications (name, date range, department, etc.)

### Controller

```java
@RestController
@RequestMapping("/employees")
@RequiredArgsConstructor
public class EmployeeController {
    private final EmployeeService employeeService;

    @PostMapping
    public ResponseEntity<EmployeeResponseDTO> create(@RequestBody EmployeeRequestDTO dto) {
        return new ResponseEntity<>(employeeService.createEmployee(dto), HttpStatus.CREATED);
    }

    @GetMapping("/{id}")
    public ResponseEntity<EmployeeResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(employeeService.getEmployeeById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<EmployeeResponseDTO> update(@PathVariable Long id, @RequestBody EmployeeRequestDTO dto) {
        return ResponseEntity.ok(employeeService.updateEmployee(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        employeeService.deleteEmployee(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping
    public Page<EmployeeResponseDTO> searchWithFilters(
            @RequestParam Optional<String> name,
            @RequestParam Optional<String> department,
            @RequestParam Optional<Double> salaryMin,
            @RequestParam Optional<Double> salaryMax,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "hireDate") String sortBy
    ) {
        return employeeService.getEmployees(name, department, salaryMin, salaryMax, page, size, sortBy);
    }

    @GetMapping("/by-department/{deptId}")
    public List<EmployeeResponseDTO> getByDepartment(@PathVariable Long deptId) {
        return employeeService.getByDepartment(deptId);
    }

    @GetMapping("/{id}/projects")
    public List<String> getProjects(@PathVariable Long id) {
        return employeeService.getProjectsForEmployee(id);
    }

    @GetMapping("/{id}/salaries")
    public List<String> getSalaries(@PathVariable Long id) {
        return employeeService.getSalariesForEmployee(id);
    }

    @GetMapping("/search")
    public Page<EmployeeResponseDTO> searchUsingSpecification(EmployeeSpecification spec, Pageable pageable) {
        return employeeService.advancedSearch(spec, pageable);
    }
}
```



## **Department APIs**

* `POST /departments` – Create a new department
* `GET /departments` – List all departments
* `GET /departments/{id}` – Get department details
* `PUT /departments/{id}` – Update department
* `DELETE /departments/{id}` – Delete department

## **Address APIs** (optional if tightly coupled to employee)

* `POST /addresses` – Add address
* `PUT /addresses/{id}` – Update address
* `GET /addresses/{id}` – Get address details

## **Project APIs**

* `POST /projects` – Create new project
* `GET /projects?client=Google&budgetMin=100000` – List all projects with filter
* `GET /projects/{id}` – Get project by ID
* `PUT /projects/{id}` – Update project details
* `DELETE /projects/{id}` – Delete project

## Relationship APIs

* `POST /employees/{empId}/assign-project/{projId}` – Assign a project to an employee
* `DELETE /employees/{empId}/remove-project/{projId}` – Remove project assignment

## **Salary APIs**

* `POST /salaries` – Add new salary record for employee
* `GET /salaries/employee/{empId}` – Get all salaries for an employee
* `GET /salaries?month=2024-02&status=PAID&employeeId=4` – Get salaries with pagination, filters (month/year/status/employeeId)
* `PUT /salaries/{id}` – Update salary
* `DELETE /salaries/{id}` – Delete salary

## **Payment History APIs**

* `POST /payments` – Add new payment history entry
* `GET /payments/salary/{salaryId}` – Get all payments for a salary
* `GET /payments` – Paginated list with filters (date range, payment mode, etc.)

## **Dashboard & Reports (Optional but Common in Portals)**

* `GET /dashboard/summary` – Show employee counts, department-wise summary, salary spend etc.
* `GET /reports/salary-summary?year=2024` – Salary paid per employee/month
* `GET /reports/department-overview` – Number of employees, active projects, total salary expense per department
