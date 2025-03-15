# ApplicationContext

## About

In Spring, `ApplicationContext` is the **central interface for accessing Spring container functionalities**. It builds on `BeanFactory`, providing **advanced features** like event propagation, internationalization, and declarative bean creation using annotations.

Modern Spring applications, especially **Spring Boot applications**, rely on `ApplicationContext` as the **default container** for managing beans and dependencies.

Spring applications automatically create and use an `ApplicationContext` to manage all registered beans and services. It is the backbone of modern Spring-based applications, particularly Spring Boot.

{% hint style="warning" %}
* Use `ApplicationContext` in ALL modern Spring applications (Spring Boot, MVC, REST APIs).
* Use `BeanFactory` ONLY for lightweight applications where dependency injection alone is needed.
* For web applications, use `WebApplicationContext` instead of `BeanFactory`.
{% endhint %}

## Features of `ApplicationContext` (Compared to `BeanFactory`)

<table data-header-hidden data-full-width="true"><thead><tr><th width="339"></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>ApplicationContext</strong></td></tr><tr><td><strong>Full Dependency Injection (DI)</strong></td><td>Supports full DI, including constructor, setter, and field injection.</td></tr><tr><td><strong>Bean Lifecycle Management</strong></td><td>Handles initialization, destruction, and lifecycle callbacks.</td></tr><tr><td><strong>Annotation-Based Configuration</strong></td><td>Supports <code>@Component</code>, <code>@Bean</code>, <code>@Service</code>, etc.</td></tr><tr><td><strong>AOP Support</strong></td><td>Supports Aspect-Oriented Programming (AOP) via Spring proxies.</td></tr><tr><td><strong>Event Handling</strong></td><td>Supports publishing &#x26; listening to custom and built-in Spring events.</td></tr><tr><td><strong>Internationalization (i18n)</strong></td><td>Provides message source support for different locales.</td></tr><tr><td><strong>Environment and Property Support</strong></td><td>Reads properties from <code>.properties</code> and <code>.yaml</code> files.</td></tr><tr><td><strong>Resource Loading</strong></td><td>Supports file, URL, classpath, and stream-based resources.</td></tr><tr><td><strong>Spring Boot Integration</strong></td><td>Essential for Spring Boot applications (<code>SpringApplication.run()</code>).</td></tr></tbody></table>

## **How `ApplicationContext` Works Internally?**

### **The Lifecycle of `ApplicationContext`**

When a Spring application starts, `ApplicationContext` goes through several phases:

1. **Instantiation** – A concrete implementation of `ApplicationContext` is created.
2. **Configuration Parsing** – Reads XML, Java-based, or annotation-based configurations.
3. **Bean Definition Registration** – Stores metadata about beans and their dependencies.
4. **Bean Instantiation & Dependency Injection** – Creates bean instances and injects dependencies.
5. **Post-Processing** – Applies custom logic through `BeanPostProcessor`.
6. **Application Ready State** – The application is fully initialized and ready to process requests.
7. **Shutdown & Cleanup** – Releases resources and destroys beans when the application exits.

### **Components in `ApplicationContext`**

1. **BeanDefinitionRegistry**

Holds metadata about all beans before they are instantiated. Stores information like **bean class, scope, dependencies, lifecycle callbacks**.

Example:

```java
@Bean
public UserService userService() {
    return new UserService();
}
```

Here, Spring registers `UserService` in the `BeanDefinitionRegistry`.

2. **BeanFactory**

The **core dependency injection container** within `ApplicationContext`. Responsible for **instantiating and managing bean dependencies**. Unlike `ApplicationContext`, `BeanFactory` does not support AOP, events, and internationalization.

3. **ResourceLoader**

Handles loading of external resources like properties files, XML, and YAML.

Example:

```java
Resource resource = context.getResource("classpath:application.properties");
```

4. **ApplicationEventPublisher**

Allows publishing and subscribing to events.

Example:

```java
context.publishEvent(new CustomEvent(this, "User Registered"));
```

5. **MessageSource**

Supports **internationalization (i18n)**. Loads localized messages from properties files.

Example:

```java
String message = context.getMessage("welcome.message", null, Locale.ENGLISH);
```

## **Types of `ApplicationContext` Implementations**

Spring provides several `ApplicationContext` implementations, each tailored for different use cases:

### **1. Annotation-Based Configuration (Modern)**

✔ **`AnnotationConfigApplicationContext`**

Used for Java-based configuration (`@Configuration`, `@Bean`). Common in **Spring Boot applications**.

Example:

```java
ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
```

✔ **`AnnotationConfigWebApplicationContext`**

Specially designed for web applications (Spring MVC, Spring Boot).

Example:

```java
AnnotationConfigWebApplicationContext context = new AnnotationConfigWebApplicationContext();
context.register(AppConfig.class);
```

### **2. XML-Based Configuration (Legacy, Rarely Used)**

✔ **`ClassPathXmlApplicationContext`**

Loads Spring configuration from an XML file in the classpath.

Example:

```java
ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
```

✔ **`FileSystemXmlApplicationContext`**

Loads Spring XML configuration from an absolute file path.

Example:

```java
ApplicationContext context = new FileSystemXmlApplicationContext("C:/config/app.xml");
```

### **3. Web-Specific Contexts**

✔ **`WebApplicationContext`**

Sub-interface of `ApplicationContext` designed for web applications. Integrated with Spring MVC DispatcherServlet.

Example:

```java
WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
```

✔ **`GenericWebApplicationContext`**

Supports both **XML and annotation-based configurations**. Used when creating **programmatic** web applications.

## **Functionalities of `ApplicationContext`**

### **1. Bean Management & Dependency Injection**

`ApplicationContext` **automatically manages beans** by scanning for `@Component`, `@Service`, `@Repository`, and `@Bean` annotations. Supports **constructor, setter, and field injection**.

Example:

```java
@Component
public class UserService {
    private final UserRepository userRepository;

    @Autowired
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

### **2. Event Handling**

`ApplicationContext` **allows event publishing and listening** for handling system-wide events. Uses **`ApplicationEventPublisher`** to dispatch events.

Example:

```java
@Component
public class CustomEventListener {
    @EventListener
    public void handleEvent(ApplicationEvent event) {
        System.out.println("Event received: " + event);
    }
}
```

### **3. Internationalization (i18n)**

Supports **multi-language messages** via `MessageSource`.

Example (`messages.properties` file):

```
welcome.message = Welcome to Spring!
```

Fetching message dynamically:

```java
String message = context.getMessage("welcome.message", null, Locale.ENGLISH);
```

### **4. Environment & Property Management**

Reads **properties from external files** (`application.properties`, `application.yaml`).

Example:

```java
@Value("${server.port}")
private int port;
```

### **5. Resource Management**

Allows loading files from **classpath, filesystem, or URL**.

Example: Reading a file from the classpath:

```java
Resource resource = context.getResource("classpath:config.properties");
```







