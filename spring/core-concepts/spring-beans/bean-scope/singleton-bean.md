# Singleton Bean

## About

In Spring, a singleton bean is a bean that is instantiated only once per Spring container and shared across the entire application. By default, all beans in Spring are singleton-scoped, meaning Spring creates a single instance of the bean and returns the same instance whenever it is requested.

{% hint style="success" %}
Singleton in Spring is at the **container level**, not the JVM level. If multiple containers exist, each may have its own singleton instance.
{% endhint %}

## **How Singleton Beans Work in Spring?**

When a singleton bean is defined, Spring:

1. **Creates the bean instance once** during container startup.
2. **Stores it in a cache (BeanFactory registry).**
3. **Returns the same instance** whenever the bean is requested.
4. **Manages the lifecycle** (initialization, destruction, etc.).

#### **Example: Singleton Bean in Spring**

```java
@Component
public class UserService {
    public void serve() {
        System.out.println("Serving user...");
    }
}
```

Now, if multiple classes request this bean:

```java
@Autowired
private UserService userService1;

@Autowired
private UserService userService2;
```

`userService1` and `userService2` **will point to the same instance** of `UserService`.

## **Declaring Singleton Beans**

By default, Spring beans are singleton-scoped. You can explicitly declare a singleton bean using:

### **Using `@Component` (default singleton)**

```java
@Component
public class SingletonBean { }
```

### **Using `@Bean` in Java Configuration**

```java
@Configuration
public class AppConfig {
    @Bean
    public SingletonBean singletonBean() {
        return new SingletonBean();
    }
}
```

### **Using XML Configuration** (Legacy)

```xml
<bean id="singletonBean" class="com.example.SingletonBean" scope="singleton"/>
```

## **Singleton Scope vs JVM-Level Singleton**

A singleton in Java (using `static` or `enum`) ensures only one instance **per JVM**, while a **Spring singleton** ensures one instance **per Spring container**.

**Comparison**

| Feature                  | Spring Singleton         | Java Singleton (Static/Enum) |
| ------------------------ | ------------------------ | ---------------------------- |
| **Instance Count**       | One per Spring container | One per JVM                  |
| **Lazy Loading**         | Yes (if configured)      | No                           |
| **Dependency Injection** | Yes                      | No                           |
| **Thread Safety**        | Managed by Spring        | Needs manual handling        |
| **Flexibility**          | Configurable             | Hardcoded                    |

Example of a JVM singleton:

```java
public class Singleton {
    private static final Singleton INSTANCE = new Singleton();
    private Singleton() { }
    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

## **Singleton Beans in Multi-Threaded Environments**

Singleton beans are **shared across all threads**, potentially causing **race conditions**.

### **Thread Safety Concerns**

```java
@Component
public class SingletonCounter {
    private int count = 0;

    public void increment() {
        count++;
    }
}
```

Here, `count` **may be inconsistent** if multiple threads modify it simultaneously.

### **Thread-Safe Singleton**

* Use synchronized blocks
* Use ThreadLocal variables
* Use ConcurrentHashMap for shared state

Example:

```java
@Component
public class SingletonCounter {
    private final AtomicInteger count = new AtomicInteger(0);

    public void increment() {
        count.incrementAndGet();
    }
}
```

## **Singleton Beans in Microservices (Spring Boot)**

In **Spring Boot**, singleton beans are often used in:

* **Service Layer (`@Service`)** – Business logic layer
* **Repository Layer (`@Repository`)** – Database interactions
* **Controller Layer (`@RestController`)** – Handling HTTP requests

**Example: Singleton in Microservices**

```java
@RestController
@RequestMapping("/orders")
public class OrderController {
    private final OrderService orderService;

    @Autowired
    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping("/{id}")
    public Order getOrder(@PathVariable Long id) {
        return orderService.getOrder(id);
    }
}
```

Here, `OrderService` is **singleton**, ensuring a **single instance** handles all requests.
