# Bean Definition & Naming

## About

In Spring, a _bean_ is an object that is managed by the Spring IoC (Inversion of Control) container. **Bean definition** refers to the metadata that tells Spring **what object to create, how to configure it, and how to manage its lifecycle**.\
Every bean must have an **identifier (name)** within the Spring context, which allows the container and us to refer to it unambiguously when needed.

Even when we don't explicitly name a bean, Spring will generate a default name according to specific rules, which is important to understand because bean naming affects:

* Autowiring
* Bean overriding
* Conflict resolution
* Qualifier usage

## **Ways to Define a Bean**

Spring provides two main approaches:

### **A. Component Scanning (Stereotype Annotations)**

Classes can be marked with annotations such as:

* `@Component` (generic)
* `@Service` (business service layer)
* `@Repository` (persistence layer)
* `@Controller` (web MVC controller)
* `@RestController` (RESTful API controller)

Example:

```java
@Component
public class OrderService {
    // Bean logic
}
```

Here, the bean name defaults to **orderService** (class name with the first letter lowercased).

### **B. Java-Based Configuration with `@Bean`**

Beans can be defined in a `@Configuration` class with explicit `@Bean` methods.

```java
@Configuration
public class AppConfig {

    @Bean
    public OrderService orderService() {
        return new OrderService();
    }
}
```

Here, the bean name defaults to the **method name**: `"orderService"`.

## **Bean Naming Rules**

### **1. Default Naming**

**From Stereotype Annotations**

* Default name is **the simple class name with the first letter lowercased**.
  * `MyService` → `"myService"`
  * `XMLParser` → `"XMLParser"` (unchanged because second letter is uppercase follows JavaBeans `Introspector.decapitalize()` rules).

**From `@Bean` Methods**

* Default name is **the method name** exactly as written.

### **2. Explicit Naming**

We can explicitly set a bean name in both styles:

**With Stereotype Annotations**

```java
@Component("customOrderService")
public class OrderService { }
```

**With `@Bean` Methods**

```java
@Bean(name = "customOrderService")
public OrderService orderService() {
    return new OrderService();
}
```

### **3. Multiple Names (Aliases)**

Spring allows multiple names (aliases) for the same bean.

```java
@Component({"primaryOrderService", "mainOrderService", "defaultOrderService"})
public class OrderService { }
```

Or with `@Bean`:

```java
@Bean(name = {"primaryOrderService", "mainOrderService"})
public OrderService orderService() {
    return new OrderService();
}
```

Aliases allow us to refer to the same bean by different names in different contexts useful for migrations or backward compatibility.

## Bean Name Uniqueness

Within a **single** Spring `ApplicationContext`, **every bean name must be unique**.

* The **bean name** is the _primary key_ by which the IoC container registers and retrieves bean instances.
* Even if two beans have **different types** but share the same name, Spring treats it as a **collision** because the name is the first-level identifier.

Spring's `BeanFactory` (and its subclass `DefaultListableBeanFactory`) uses an **internal `Map<String, BeanDefinition>`** to store all beans.

* **Key** = bean name
* **Value** = bean definition metadata

Since `Map` keys must be unique, registering two beans with the same name overwrites the entry or triggers an exception depending on configuration.

### **Default Behavior**

In **Spring Boot 2.x+** (and Spring Framework 5.x+ by default):

* Bean definition overriding is **disabled**.
*   If a bean with the same name is already registered, the container throws:

    ```
    BeanDefinitionOverrideException: Invalid bean definition with name 'X'
    ```

In **older Spring versions** or if explicitly enabled, later definitions **overwrite** earlier ones, which can cause subtle bugs if not intended.

### **Collision Scenarios in Annotation-Based Config**

**A. Component Scanning Collision**

Two `@Component` classes in the scanned packages with the same name:

```java
@Component("paymentService")
public class FastPaymentService implements PaymentService { }

@Component("paymentService")
public class SlowPaymentService implements PaymentService { } // ❌ Collision
```

Here, even though they are different classes, Spring sees `"paymentService"` twice.

**B. `@Bean` Method vs. Component**

A bean declared via `@Bean` with a name that already exists from a `@Component`:

```java
@Component
public class PaymentService { }

@Configuration
public class AppConfig {
    @Bean
    public PaymentService paymentService() { // ❌ Same name as @Component
        return new PaymentService();
    }
}
```

**C. Multiple `@Bean` Methods with Same Name**

```java
@Configuration
public class AppConfig {
    @Bean
    public PaymentService paymentService() { return new FastPaymentService(); }

    @Bean
    public PaymentService paymentService() { return new SlowPaymentService(); } // ❌ Duplicate method name
}
```

## Bean Definition **Override**

`spring.main.allow-bean-definition-overriding=true` is a **Spring Boot property** that controls whether **later bean definitions can replace earlier ones** in the same `ApplicationContext`.

{% hint style="danger" %}
Overriding can cause silent misconfigurations, especially if auto-configuration beans get replaced unintentionally.
{% endhint %}

### **Default Behavior**

* **Before Spring Boot 2.1** → Overriding was **allowed by default**.\
  If we defined two beans with the same name, the later one (by loading order) silently replaced the earlier one.
* **Spring Boot 2.1+** → Overriding is **disabled by default**.\
  If a duplicate bean name is detected, the container throws a `BeanDefinitionOverrideException`.

{% hint style="warning" %}
### **Why Spring Boot Disabled It ?**

Overriding was **too error-prone** in large apps, especially with auto-configuration.

* We might **accidentally** replace a bean defined by Spring Boot (e.g., an auto-configured `DataSource`) without realizing it.
* Bugs could appear only in certain environments, depending on bean loading order.
{% endhint %}

### **What Happens When We Set It to `true`  ?**

When `spring.main.allow-bean-definition-overriding=true`:

* If a new bean with the same name is registered, it **replaces** the existing one.
* No exception is thrown.
* The later definition wins _last in, first out_.

```java
// Auto-configured bean
@Bean
public PaymentService paymentService() {
    return new FastPaymentService();
}

// Custom bean with same name
@Bean
public PaymentService paymentService() {
    return new MockPaymentService();
}
```

Without the property:

```
BeanDefinitionOverrideException: Invalid bean definition with name 'paymentService'
```

With the property:

```
No error — MockPaymentService replaces FastPaymentService
```
