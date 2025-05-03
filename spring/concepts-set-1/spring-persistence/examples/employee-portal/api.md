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

### DTO

#### `EmployeeRequestDTO`

This is used for creating or updating an employee.

```java
public class EmployeeRequestDTO {
    private String name;
    private String email;
    private String phone;
    private LocalDate hireDate;
    private Long departmentId;
    private AddressDTO address; // embedded sub-object
}
```

#### `EmployeeResponseDTO`

This is used for returning employee data to the client, including resolved department name, address details, and project names (if needed).

```java
public class EmployeeResponseDTO {
    private Long id;
    private String name;
    private String email;
    private String phone;
    private LocalDate hireDate;

    private String departmentName;
    private AddressDTO address;

    private List<String> projects; // Optional: populate from Project list
}
```

#### `AddressDTO`

Used for both request and response to nest address within employee DTOs.

```java
public class AddressDTO {
    private String street;
    private String city;
    private String state;
    private String zip;
    private String country;
}
```

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

### Repository

```java
public interface EmployeeRepository extends JpaRepository<Employee, Long>, JpaSpecificationExecutor<Employee> {
    List<Employee> findByDepartmentId(Long deptId);
}

public interface DepartmentRepository extends JpaRepository<Department, Long> {
    // findById(Long id) is inherited from JpaRepository
    Optional<Department> findByName(String name);
}

public interface SalaryRepository extends JpaRepository<Salary, Long> {
    List<Salary> findByEmployeeId(Long employeeId);
}
```

### Specification Class

```java
public class EmployeeSpecifications {

    public static Specification<Employee> nameContains(String name) {
        return (root, query, cb) ->
                cb.like(cb.lower(root.get("name")), "%" + name.toLowerCase() + "%");
    }

    public static Specification<Employee> departmentEquals(String departmentName) {
        return (root, query, cb) ->
                cb.equal(root.get("department").get("name"), departmentName);
    }

    public static Specification<Employee> salaryGte(Double minSalary) {
        return (root, query, cb) ->
                cb.greaterThanOrEqualTo(root.join("salaries").get("baseSalary"), minSalary);
    }

    public static Specification<Employee> salaryLte(Double maxSalary) {
        return (root, query, cb) ->
                cb.lessThanOrEqualTo(root.join("salaries").get("baseSalary"), maxSalary);
    }
}
```

### **Mapper Interface**

We can use MapStruct or manual mapping. Example using MapStruct:

```java
@Mapper(componentModel = "spring")
public interface EmployeeMapper {
    Employee toEntity(EmployeeRequestDTO dto);
    EmployeeResponseDTO toDto(Employee entity);
    void updateEntityFromDto(EmployeeRequestDTO dto, @MappingTarget Employee entity);
}
```

### Service Interface

```java
public interface EmployeeService {
    EmployeeResponseDTO createEmployee(EmployeeRequestDTO dto);
    EmployeeResponseDTO getEmployeeById(Long id);
    EmployeeResponseDTO updateEmployee(Long id, EmployeeRequestDTO dto);
    void deleteEmployee(Long id);
    Page<EmployeeResponseDTO> getEmployees(Optional<String> name, Optional<String> dept, Optional<Double> minSal, Optional<Double> maxSal, int page, int size, String sortBy);
    List<EmployeeResponseDTO> getByDepartment(Long deptId);
    List<String> getProjectsForEmployee(Long id);
    List<String> getSalariesForEmployee(Long id);
    Page<EmployeeResponseDTO> advancedSearch(Specification<Employee> spec, Pageable pageable);
}
```

### Service Implementation

```java
@Service
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {

    private final EmployeeRepository employeeRepository;
    private final DepartmentRepository departmentRepository;
    private final SalaryRepository salaryRepository;
    private final EmployeeMapper employeeMapper;

    @Override
    public EmployeeResponseDTO createEmployee(EmployeeRequestDTO dto) {
        Employee employee = employeeMapper.toEntity(dto);
        // Set relationships
        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department not found"));
        employee.setDepartment(department);

        Employee saved = employeeRepository.save(employee);
        return employeeMapper.toDto(saved);
    }

    @Override
    public EmployeeResponseDTO getEmployeeById(Long id) {
        Employee emp = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));
        return employeeMapper.toDto(emp);
    }

    @Override
    public EmployeeResponseDTO updateEmployee(Long id, EmployeeRequestDTO dto) {
        Employee existing = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));
        employeeMapper.updateEntityFromDto(dto, existing);
        Department department = departmentRepository.findById(dto.getDepartmentId())
                .orElseThrow(() -> new ResourceNotFoundException("Department not found"));
        existing.setDepartment(department);
        return employeeMapper.toDto(employeeRepository.save(existing));
    }

    @Override
    public void deleteEmployee(Long id) {
        if (!employeeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Employee not found");
        }
        employeeRepository.deleteById(id);
    }

    @Override
    public Page<EmployeeResponseDTO> getEmployees(Optional<String> name, Optional<String> dept,
                                                  Optional<Double> minSal, Optional<Double> maxSal,
                                                  int page, int size, String sortBy) {

        Pageable pageable = PageRequest.of(page, size, Sort.by(sortBy));
        Specification<Employee> spec = Specification.where(null);

        if (name.isPresent()) {
            spec = spec.and(EmployeeSpecifications.nameContains(name.get()));
        }
        if (dept.isPresent()) {
            spec = spec.and(EmployeeSpecifications.departmentEquals(dept.get()));
        }
        if (minSal.isPresent()) {
            spec = spec.and(EmployeeSpecifications.salaryGte(minSal.get()));
        }
        if (maxSal.isPresent()) {
            spec = spec.and(EmployeeSpecifications.salaryLte(maxSal.get()));
        }

        return employeeRepository.findAll(spec, pageable)
                .map(employeeMapper::toDto);
    }

    @Override
    public List<EmployeeResponseDTO> getByDepartment(Long deptId) {
        List<Employee> employees = employeeRepository.findByDepartmentId(deptId);
        return employees.stream().map(employeeMapper::toDto).collect(Collectors.toList());
    }

    @Override
    public List<String> getProjectsForEmployee(Long id) {
        Employee employee = employeeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Employee not found"));
        return employee.getProjects().stream().map(Project::getName).collect(Collectors.toList());
    }

    @Override
    public List<String> getSalariesForEmployee(Long id) {
        List<Salary> salaries = salaryRepository.findByEmployeeId(id);
        return salaries.stream()
                .map(s -> String.format("%s %s: %.2f", s.getMonth(), s.getYear(), s.getBaseSalary()))
                .collect(Collectors.toList());
    }

    @Override
    public Page<EmployeeResponseDTO> advancedSearch(Specification<Employee> spec, Pageable pageable) {
        return employeeRepository.findAll(spec, pageable).map(employeeMapper::toDto);
    }
}
```

## **Department APIs**

* `POST /departments` – Create a new department
* `GET /departments` – List all departments
* `GET /departments/{id}` – Get department details
* `PUT /departments/{id}` – Update department
* `DELETE /departments/{id}` – Delete department

### Controller

```java
@RestController
@RequestMapping("/departments")
@RequiredArgsConstructor
public class DepartmentController {

    private final DepartmentService departmentService;

    @PostMapping
    public ResponseEntity<DepartmentResponseDTO> createDepartment(@RequestBody DepartmentRequestDTO dto) {
        DepartmentResponseDTO created = departmentService.createDepartment(dto);
        return new ResponseEntity<>(created, HttpStatus.CREATED);
    }

    @GetMapping
    public List<DepartmentResponseDTO> getAllDepartments() {
        return departmentService.getAllDepartments();
    }

    @GetMapping("/{id}")
    public ResponseEntity<DepartmentResponseDTO> getDepartment(@PathVariable Long id) {
        return ResponseEntity.ok(departmentService.getDepartmentById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<DepartmentResponseDTO> updateDepartment(@PathVariable Long id,
                                                                  @RequestBody DepartmentRequestDTO dto) {
        return ResponseEntity.ok(departmentService.updateDepartment(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDepartment(@PathVariable Long id) {
        departmentService.deleteDepartment(id);
        return ResponseEntity.noContent().build();
    }
}
```

### Service Interface

```java
public interface DepartmentService {
    DepartmentResponseDTO createDepartment(DepartmentRequestDTO dto);
    DepartmentResponseDTO getDepartmentById(Long id);
    List<DepartmentResponseDTO> getAllDepartments();
    DepartmentResponseDTO updateDepartment(Long id, DepartmentRequestDTO dto);
    void deleteDepartment(Long id);
}
```

### Service Implementation

```java
@Service
@RequiredArgsConstructor
public class DepartmentServiceImpl implements DepartmentService {

    private final DepartmentRepository departmentRepository;
    private final DepartmentMapper departmentMapper;

    @Override
    public DepartmentResponseDTO createDepartment(DepartmentRequestDTO dto) {
        Department department = departmentMapper.toEntity(dto);
        return departmentMapper.toDto(departmentRepository.save(department));
    }

    @Override
    public DepartmentResponseDTO getDepartmentById(Long id) {
        Department dept = departmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Department not found"));
        return departmentMapper.toDto(dept);
    }

    @Override
    public List<DepartmentResponseDTO> getAllDepartments() {
        return departmentRepository.findAll().stream()
                .map(departmentMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public DepartmentResponseDTO updateDepartment(Long id, DepartmentRequestDTO dto) {
        Department dept = departmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Department not found"));
        dept.setName(dto.getName());
        dept.setLocation(dto.getLocation());
        return departmentMapper.toDto(departmentRepository.save(dept));
    }

    @Override
    public void deleteDepartment(Long id) {
        Department dept = departmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Department not found"));
        departmentRepository.delete(dept);
    }
}
```

### Repository

```java
public interface DepartmentRepository extends JpaRepository<Department, Long> {
}
```

### DTO

#### `DepartmentRequestDTO`

```java
public record DepartmentRequestDTO(
    String name,
    String location
) {}
```

#### `DepartmentResponseDTO`

```java
public record DepartmentResponseDTO(
    Long id,
    String name,
    String location
) {}
```

### Error Handling

```java
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String msg) {
        super(msg);
    }
}
```

### Mapper Interface

```java
@Mapper(componentModel = "spring")
public interface DepartmentMapper {

    Department toEntity(DepartmentRequestDTO dto);

    DepartmentResponseDTO toDto(Department department);
}
```

## **Address APIs**

* `POST /addresses` – Add address
* `PUT /addresses/{id}` – Update address
* `GET /addresses/{id}` – Get address details

### **Controller**

```java
@RestController
@RequestMapping("/addresses")
@RequiredArgsConstructor
public class AddressController {

    private final AddressService addressService;

    @PostMapping
    public ResponseEntity<AddressResponseDTO> create(@RequestBody AddressRequestDTO dto) {
        return new ResponseEntity<>(addressService.createAddress(dto), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<AddressResponseDTO> update(@PathVariable Long id, @RequestBody AddressRequestDTO dto) {
        return ResponseEntity.ok(addressService.updateAddress(id, dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AddressResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(addressService.getAddressById(id));
    }
}
```

### **Service Interface**

```java
public interface AddressService {
    AddressResponseDTO createAddress(AddressRequestDTO dto);
    AddressResponseDTO updateAddress(Long id, AddressRequestDTO dto);
    AddressResponseDTO getAddressById(Long id);
}
```

### **Service Implementation**

```java
@Service
@RequiredArgsConstructor
public class AddressServiceImpl implements AddressService {

    private final AddressRepository addressRepository;
    private final AddressMapper addressMapper;

    @Override
    public AddressResponseDTO createAddress(AddressRequestDTO dto) {
        Address address = addressMapper.toEntity(dto);
        return addressMapper.toDto(addressRepository.save(address));
    }

    @Override
    public AddressResponseDTO updateAddress(Long id, AddressRequestDTO dto) {
        Address existing = addressRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Address not found with id " + id));
        existing.setStreet(dto.street());
        existing.setCity(dto.city());
        existing.setState(dto.state());
        existing.setZip(dto.zip());
        existing.setCountry(dto.country());
        return addressMapper.toDto(addressRepository.save(existing));
    }

    @Override
    public AddressResponseDTO getAddressById(Long id) {
        Address address = addressRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Address not found with id " + id));
        return addressMapper.toDto(address);
    }
}
```

### **Mapper Interface**

```java
@Mapper(componentModel = "spring")
public interface AddressMapper {
    Address toEntity(AddressRequestDTO dto);
    AddressResponseDTO toDto(Address address);
}
```

MapStruct will auto-generate the implementation `AddressMapperImpl`.

### **Repository**

```java
public interface AddressRepository extends JpaRepository<Address, Long> {
}
```

### **DTO**

#### `AddressRequestDTO.java`

```java
public record AddressRequestDTO(
    String street,
    String city,
    String state,
    String zip,
    String country
) {}
```

#### `AddressResponseDTO.java`

```java
public record AddressResponseDTO(
    Long id,
    String street,
    String city,
    String state,
    String zip,
    String country
) {}
```

## **Project APIs**

* `POST /projects` – Create new project
* `GET /projects?client=Google&budgetMin=100000` – List all projects with filter
* `GET /projects/{id}` – Get project by ID
* `PUT /projects/{id}` – Update project details
* `DELETE /projects/{id}` – Delete project

### **Controller**

```java
@RestController
@RequestMapping("/projects")
@RequiredArgsConstructor
public class ProjectController {

    private final ProjectService projectService;

    @PostMapping
    public ResponseEntity<ProjectResponseDTO> create(@RequestBody ProjectRequestDTO dto) {
        return new ResponseEntity<>(projectService.createProject(dto), HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<ProjectResponseDTO>> getAll(
            @RequestParam(required = false) String client,
            @RequestParam(required = false) Double budgetMin) {
        return ResponseEntity.ok(projectService.getProjects(client, budgetMin));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ProjectResponseDTO> getById(@PathVariable Long id) {
        return ResponseEntity.ok(projectService.getById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProjectResponseDTO> update(@PathVariable Long id, @RequestBody ProjectRequestDTO dto) {
        return ResponseEntity.ok(projectService.updateProject(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        projectService.deleteProject(id);
        return ResponseEntity.noContent().build();
    }
}
```

### **Service Interface**

```java
public interface ProjectService {
    ProjectResponseDTO createProject(ProjectRequestDTO dto);
    ProjectResponseDTO updateProject(Long id, ProjectRequestDTO dto);
    ProjectResponseDTO getById(Long id);
    void deleteProject(Long id);
    List<ProjectResponseDTO> getProjects(String client, Double budgetMin);
}
```

### **Service Implementation**

```java
@Service
@RequiredArgsConstructor
public class ProjectServiceImpl implements ProjectService {

    private final ProjectRepository projectRepository;
    private final ProjectMapper projectMapper;

    @Override
    public ProjectResponseDTO createProject(ProjectRequestDTO dto) {
        Project project = projectMapper.toEntity(dto);
        return projectMapper.toDto(projectRepository.save(project));
    }

    @Override
    public ProjectResponseDTO updateProject(Long id, ProjectRequestDTO dto) {
        Project project = projectRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Project not found: " + id));
        project.setName(dto.name());
        project.setClient(dto.client());
        project.setBudget(dto.budget());
        return projectMapper.toDto(projectRepository.save(project));
    }

    @Override
    public ProjectResponseDTO getById(Long id) {
        return projectRepository.findById(id)
                .map(projectMapper::toDto)
                .orElseThrow(() -> new EntityNotFoundException("Project not found: " + id));
    }

    @Override
    public void deleteProject(Long id) {
        if (!projectRepository.existsById(id)) {
            throw new EntityNotFoundException("Project not found: " + id);
        }
        projectRepository.deleteById(id);
    }

    @Override
    public List<ProjectResponseDTO> getProjects(String client, Double budgetMin) {
        Specification<Project> spec = Specification.where(null);

        if (client != null && !client.isBlank()) {
            spec = spec.and(ProjectSpecifications.clientEquals(client));
        }

        if (budgetMin != null) {
            spec = spec.and(ProjectSpecifications.budgetGreaterThanEqual(budgetMin));
        }

        return projectRepository.findAll(spec)
                .stream()
                .map(projectMapper::toDto)
                .collect(Collectors.toList());
    }
}
```

### **Repository**

```java
public interface ProjectRepository extends JpaRepository<Project, Long>, JpaSpecificationExecutor<Project> {
}
```

### **Mapper Interface**

```java
@Mapper(componentModel = "spring")
public interface ProjectMapper {
    Project toEntity(ProjectRequestDTO dto);
    ProjectResponseDTO toDto(Project project);
}
```

### **DTO**

#### `ProjectRequestDTO.java`

```java
public record ProjectRequestDTO(
    String name,
    String client,
    Double budget
) {}
```

#### `ProjectResponseDTO.java`

```java
public record ProjectResponseDTO(
    Long id,
    String name,
    String client,
    Double budget
) {}
```

### **Specifications**

```java
public class ProjectSpecifications {

    public static Specification<Project> clientEquals(String client) {
        return (root, query, cb) ->
                cb.equal(cb.lower(root.get("client")), client.toLowerCase());
    }

    public static Specification<Project> budgetGreaterThanEqual(Double minBudget) {
        return (root, query, cb) ->
                cb.greaterThanOrEqualTo(root.get("budget"), minBudget);
    }
}
```

## Relationship APIs

* `POST /employees/{empId}/assign-project/{projId}` – Assign a project to an employee
* `DELETE /employees/{empId}/remove-project/{projId}` – Remove project assignment

### **Controller**

```java
@RestController
@RequestMapping("/employees")
@RequiredArgsConstructor
public class EmployeeProjectController {

    private final EmployeeProjectService employeeProjectService;

    @PostMapping("/{empId}/assign-project/{projId}")
    public ResponseEntity<Void> assignProject(@PathVariable Long empId, @PathVariable Long projId) {
        employeeProjectService.assignProjectToEmployee(empId, projId);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/{empId}/remove-project/{projId}")
    public ResponseEntity<Void> removeProject(@PathVariable Long empId, @PathVariable Long projId) {
        employeeProjectService.removeProjectFromEmployee(empId, projId);
        return ResponseEntity.noContent().build();
    }
}
```

### Service Interface

```java
public interface EmployeeProjectService {
    void assignProjectToEmployee(Long employeeId, Long projectId);
    void removeProjectFromEmployee(Long employeeId, Long projectId);
}
```

### Service Implementation

```java
@Service
@RequiredArgsConstructor
public class EmployeeProjectServiceImpl implements EmployeeProjectService {

    private final EmployeeRepository employeeRepository;
    private final ProjectRepository projectRepository;

    @Override
    public void assignProjectToEmployee(Long employeeId, Long projectId) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found: " + employeeId));
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new EntityNotFoundException("Project not found: " + projectId));

        employee.getProjects().add(project); // ManyToMany
        employeeRepository.save(employee);
    }

    @Override
    public void removeProjectFromEmployee(Long employeeId, Long projectId) {
        Employee employee = employeeRepository.findById(employeeId)
                .orElseThrow(() -> new EntityNotFoundException("Employee not found: " + employeeId));
        Project project = projectRepository.findById(projectId)
                .orElseThrow(() -> new EntityNotFoundException("Project not found: " + projectId));

        employee.getProjects().remove(project); // ManyToMany
        employeeRepository.save(employee);
    }
}
```

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



## **Dashboard & Reports**

* `GET /dashboard/summary` – Show employee counts, department-wise summary, salary spend etc.
* `GET /reports/salary-summary?year=2024` – Salary paid per employee/month
* `GET /reports/department-overview` – Number of employees, active projects, total salary expense per department



