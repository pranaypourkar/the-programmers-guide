# Controller Layer (Web & REST Controllers)

## About

Spring Boot provides a set of annotations for defining controllers in web applications, handling HTTP requests, and configuring response behaviors. These annotations are used to build **RESTful APIs** or **traditional MVC applications**.

## **1. Core Controller Annotations**

These annotations define the controller layer in a Spring Boot application.

### **`@Controller`**

* Marks a class as a Spring MVC controller.
* Used in **Spring MVC applications** that return HTML views.

```java
@Controller
public class MyController {
    @GetMapping("/home")
    public String home() {
        return "home";  // Returns a view name
    }
}
```

### **`@RestController`**

* Specialized version of `@Controller` that combines `@Controller` and `@ResponseBody`.
* Used in **RESTful APIs** where the response is JSON or XML instead of HTML.

{% hint style="success" %}
`@RestController = @Controller + @ResponseBody`
{% endhint %}

```java
@RestController
public class MyRestController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello, World!";  // Returns raw data, not a view
    }
}
```

## **2. Request Mapping Annotations**

These annotations map HTTP requests to controller methods.

### **`@RequestMapping`**

* Maps an HTTP request to a method or class.
* Supports various attributes like `value`, `method`, `produces`, `consumes`.
* Class-level `@RequestMapping` prefixes all method mappings.

**Example (Class-level and Method-level Mapping):**

```java
@RestController
@RequestMapping("/api")
public class MyApiController {
    
    @RequestMapping(value = "/users", method = RequestMethod.GET)
    public List<String> getUsers() {
        return List.of("Alice", "Bob");
    }
}
```

#### **Shortcuts for `@RequestMapping`**

Spring Boot provides specific annotations for each HTTP method:

| Annotation       | Purpose                      |
| ---------------- | ---------------------------- |
| `@GetMapping`    | Handles HTTP GET requests    |
| `@PostMapping`   | Handles HTTP POST requests   |
| `@PutMapping`    | Handles HTTP PUT requests    |
| `@DeleteMapping` | Handles HTTP DELETE requests |
| `@PatchMapping`  | Handles HTTP PATCH requests  |

### **`@GetMapping`**

* Maps HTTP **GET** requests.

```java
@GetMapping("/users")
public List<String> getUsers() {
    return List.of("Alice", "Bob");
}
```

### **`@PostMapping`**

* Maps HTTP **POST** requests (used for creating resources).

```java
@PostMapping("/users")
public String createUser(@RequestBody String user) {
    return "User created: " + user;
}
```

🔹 `@RequestBody` is used to extract JSON request payload.

### **`@PutMapping`**

* Maps HTTP **PUT** requests (used for updating resources).

```java
@PutMapping("/users/{id}")
public String updateUser(@PathVariable Long id, @RequestBody String user) {
    return "User " + id + " updated with: " + user;
}
```

### **`@DeleteMapping`**

* Maps HTTP **DELETE** requests.

**Example:**

```java
@DeleteMapping("/users/{id}")
public String deleteUser(@PathVariable Long id) {
    return "User " + id + " deleted";
}
```

#### **`@PatchMapping`**

* Maps HTTP **PATCH** requests (used for **partial updates**).

**Example:**

```java
@PatchMapping("/users/{id}")
public String updateUserPartially(@PathVariable Long id, @RequestBody String user) {
    return "User " + id + " partially updated with: " + user;
}
```





