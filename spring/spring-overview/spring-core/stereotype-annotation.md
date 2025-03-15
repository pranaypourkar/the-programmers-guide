# Stereotype Annotation

## About

Stereotype annotations in Spring are **meta-annotations** used to define **Spring-managed components**. These annotations serve as **indicators** for Spring to **automatically detect, register, and manage beans** in the application context.

{% hint style="success" %}
The term "stereotype" means a predefined role or category. In Spring, these annotations define the role of a class in the application, such as a service, controller, or repository.
{% endhint %}

## **List of Stereotype Annotations in Spring**

<table data-full-width="true"><thead><tr><th width="188">Annotation</th><th>Purpose</th></tr></thead><tbody><tr><td><code>@Component</code></td><td>Generic annotation to mark any class as a Spring-managed bean.</td></tr><tr><td><code>@Service</code></td><td>Used for service-layer components, indicating business logic processing.</td></tr><tr><td><code>@Repository</code></td><td>Used for data access components, integrates with JPA, Hibernate, and exception translation.</td></tr><tr><td><code>@Controller</code></td><td>Used in Spring MVC to handle web requests.</td></tr><tr><td><code>@RestController</code></td><td>A specialization of <code>@Controller</code> that returns JSON/XML responses.</td></tr></tbody></table>

### **`@Component` – The Base Stereotype Annotation**

`@Component` is the **most generic** stereotype annotation. It marks a class as a **Spring-managed bean**, making it eligible for **dependency injection**.

**Example**

```java
@Component
public class EmailService {
    public void sendEmail(String message) {
        System.out.println("Email sent: " + message);
    }
}
```

* Spring **automatically registers** `EmailService` as a bean, without requiring `@Bean`.
* Injecting `EmailService` in another class:

```java
@Service
public class NotificationService {
    private final EmailService emailService;

    @Autowired
    public NotificationService(EmailService emailService) {
        this.emailService = emailService;
    }
}
```

### **`@Service` – Business Logic Layer**

`@Service` is a specialization of `@Component` used for business logic services. It provides semantic clarity and can be extended in the future for AOP (Aspect-Oriented Programming) or transaction management.

#### **Example**

```java
@Service
public class OrderService {
    public void processOrder() {
        System.out.println("Processing order...");
    }
}
```

* Functionally, it behaves like `@Component`, but it clearly represents business logic.

### **`@Repository` – Data Access Layer**

`@Repository` is used for **DAO (Data Access Object) components**. It provides **exception translation**, converting database exceptions into **Spring’s `DataAccessException` hierarchy**.

#### **Example**

```java
@Repository
public class ProductRepository {
    private final Map<Integer, String> products = new HashMap<>();

    public String findProductById(int id) {
        return products.get(id);
    }
}
```

* Spring **automatically translates database-related exceptions** when using `@Repository`.
* Works seamlessly with **JPA, Hibernate, and JDBC**.

### **`@Controller` – MVC Controller Layer**

`@Controller` is used in **Spring MVC** to handle **HTTP requests** and return **views (JSP, Thymeleaf, etc.)**.

#### **Example**

```java
@Controller
public class HomeController {
    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("message", "Welcome!");
        return "home"; // Returns view name
    }
}
```

* Returns **a view name** instead of a response body.
* Should be used in **Spring MVC applications**.

### **`@RestController` – REST API Layer**

`@RestController` is a combination of **`@Controller` + `@ResponseBody`**. It is used to build **RESTful APIs**.

**Example**

```java
@RestController
@RequestMapping("/users")
public class UserController {
    @GetMapping("/{id}")
    public User getUser(@PathVariable int id) {
        return new User(id, "John Doe");
    }
}
```

* Eliminates the need for `@ResponseBody`.
* Returns **JSON/XML** directly instead of a view.

## **Why Use Stereotype Annotations?**

* **Eliminates the need for manual bean registration** – Spring **auto-detects** and registers beans.
* **Promotes clear separation of concerns** – Different annotations represent different layers (e.g., `@Service` for business logic).
* **Enhances maintainability** – Easy to locate and manage different components.
* **Works seamlessly with Spring Boot** – Enables component scanning, reducing XML configuration.

## **How Stereotype Annotations Enable Component Scanning?**

Spring automatically scans for these annotations using **component scanning**.

* **Enable Component Scanning** (If not using Spring Boot):

```java
@Configuration
@ComponentScan(basePackages = "com.example")
public class AppConfig { }
```

* Spring Boot automatically enables scanning for the main package and sub-packages.

## **Custom Stereotype Annotations**

We can create custom stereotype annotations by combining existing ones.

* **Example: Custom `@UseCase` Annotation**

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Component
public @interface UseCase {
}
```

* **Usage**

```java
@UseCase
public class PaymentProcessing { }
```

Now, `PaymentProcessing` is a Spring bean, but with better semantics.

