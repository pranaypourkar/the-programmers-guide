# Set 2 - Core Spring

## Java POJO vs Bean vs Spring Bean?

### POJO

A **POJO** (Plain Old Java Object) is a simple Java object that doesn’t follow any special rules or requirements. It’s often used to represent data structures without any dependencies on specific frameworks or libraries.

#### Key Characteristics of a POJO

1. **No Special Restrictions**: Unlike JavaBeans, POJOs don’t have to follow conventions like having private fields, getter and setter methods, or a no-argument constructor.
2. **Framework Independence**: POJOs aren’t bound to any framework, annotations, or specific inheritance requirements.
3. **Lightweight**: POJOs are meant to be simple, lightweight objects, typically just holding data.

#### Example of a POJO

POJO of a `Book`

```java
public class Book {

    public String title;
    public String author;
    public int publicationYear;

    public Book(String title, String author, int publicationYear) {
        this.title = title;
        this.author = author;
        this.publicationYear = publicationYear;
    }

    @Override
    public String toString() {
        return "Book [title=" + title + ", author=" + author + ", publicationYear=" + publicationYear + "]";
    }
}
```

### Bean

In Java, a **bean** is simply an object that is managed and instantiated by a framework or container, often adhering to specific conventions like having a no-argument constructor, and getter/setter methods for properties. Beans are a key component in many Java applications due to their simplicity, configurability, and ease of reuse.

#### Characteristics of a Java Bean

1. **Public No-Argument Constructor**: A Java Bean should have a public no-argument constructor.
2. **Private Fields**: Properties are private and accessed through public getter and setter methods.
3. **Serializable**: Java Beans are usually serializable, allowing their state to be saved or transferred.

#### Example of a Simple Java Bean

Java Bean called `Person`

```java
import java.io.Serializable;

public class Person implements Serializable {
    
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;

    // No-argument constructor
    public Person() {
    }

    // Constructor with parameters
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Getter and Setter for name
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    // Getter and Setter for age
    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    // Optional: toString method for easy display
    @Override
    public String toString() {
        return "Person [name=" + name + ", age=" + age + "]";
    }
}
```

#### Explanation of the Example

* **No-Argument Constructor**: The no-argument constructor allows easy instantiation of the bean.
* **Private Fields**: Fields `name` and `age` are private, following encapsulation principles.
* **Getters and Setters**: The `getName`, `setName`, `getAge`, and `setAge` methods provide access to the private fields, allowing controlled modification.
* **Serializable**: The class implements `Serializable`, which is optional but useful for Java Beans in distributed applications where objects might need to be transferred across networks.

#### Using the Java Bean

Here’s how we can create and use the `Person` Java Bean

```java
public class Main {
    public static void main(String[] args) {
        // Using the no-argument constructor
        Person person = new Person();
        person.setName("Alice");
        person.setAge(30);

        // Using the constructor with parameters
        Person person2 = new Person("Bob", 25);

        System.out.println(person);   // Output: Person [name=Alice, age=30]
        System.out.println(person2);  // Output: Person [name=Bob, age=25]
    }
}
```

{% hint style="info" %}
**All JavaBeans are POJOs**, but not all POJOs are JavaBeans. JavaBeans are a specialized form of POJOs that follow stricter conventions to ensure they can be easily used by frameworks and tools.
{% endhint %}

#### How POJOs Differ from JavaBeans

<table data-full-width="true"><thead><tr><th width="165">Feature</th><th>POJO</th><th>JavaBean</th></tr></thead><tbody><tr><td><strong>Constructor</strong></td><td>Can have any constructor</td><td>Should have a no-arg constructor</td></tr><tr><td><strong>Field Access</strong></td><td>Can use public fields</td><td>Fields should be private and accessed via getters/setters</td></tr><tr><td><strong>Serializable</strong></td><td>Serialization is optional</td><td>Often implements <code>Serializable</code></td></tr><tr><td><strong>Framework Agnostic</strong></td><td>Independent of any specific Java framework</td><td>Often designed to be compatible with frameworks (like Spring)</td></tr></tbody></table>

#### When to use POJOs and JavaBeans?

* **POJOs** are ideal for representing simple data structures and are commonly used when you need lightweight, framework-independent objects.
* **JavaBeans** are often preferred in scenarios where we want managed or reusable components with controlled access to data, as well as in frameworks like Spring or Java EE where frameworks might depend on certain conventions like getters, setters, and no-arg constructors.

### Spring Bean

In the context of **Spring**, the term "Spring Bean" has a more specific meaning. A **Spring Bean** is any Java object that is instantiated, configured, and managed by the Spring **Inversion of Control (IoC)** container. When a class is declared as a Spring Bean, it becomes part of the Spring container, which manages its lifecycle, dependencies, and configurations.

#### Key Characteristics of Spring Beans

1. **Managed by the IoC Container**:
   * In Spring, the IoC container controls the entire lifecycle of a bean, from instantiation and dependency injection to destruction.
   * Spring beans are typically created, initialized, and destroyed by the container as needed.
2. **Defined via Configuration**:
   * Beans can be defined in Spring using annotations, XML configurations, or Java configuration classes. Common annotations to define beans include `@Component`, `@Service`, `@Repository`, and `@Controller`, which Spring will automatically detect during component scanning.
   * For explicit bean definitions, the `@Bean` annotation can also be used in Java configuration classes.
3. **Scope**:
   * Beans in Spring can have different scopes that define their lifecycle and availability, such as:
     * **Singleton**: A single instance of the bean is created (the default).
     * **Prototype**: A new instance is created each time it’s requested.
     * **Request**: One instance per HTTP request (used in web applications).
     * **Session**: One instance per HTTP session (used in web applications).
   * You specify the scope using the `@Scope` annotation or in XML configuration.
4. **Dependency Injection (DI)**:
   * Spring Beans rely heavily on dependency injection. The IoC container injects dependencies (other beans or resources) into a bean, which decouples classes and makes them more modular.
   * This can be done through constructor injection, setter injection, or field injection.
5. **Lifecycle Methods**:
   * Spring Beans can have lifecycle callback methods, such as `@PostConstruct` and `@PreDestroy`, or methods configured through `initMethod` and `destroyMethod` attributes, to perform actions after creation or before destruction.

#### Example of a Spring Bean

A Spring Bean in Java using annotations

```java
import org.springframework.stereotype.Component;

@Component // Declares this class as a Spring Bean
public class UserService {

    public void registerUser(String username) {
        System.out.println("Registering user: " + username);
    }
}
```

In this example,

* The `@Component` annotation marks `UserService` as a Spring Bean. When the application context loads, Spring automatically detects this bean and manages it.
* The bean can now be injected wherever it’s needed.

#### Configuration and Retrieval of a Spring Bean

Beans are often injected using the `@Autowired` annotation or via constructor injection in other Spring Beans. For instance:

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserRegistrationController {

    private final UserService userService;

    @Autowired // Dependency injection of the UserService bean
    public UserRegistrationController(UserService userService) {
        this.userService = userService;
    }

    public void register(String username) {
        userService.registerUser(username);
    }
}
```



## @Component vs @Service

In Spring, both `@Component` and `@Service` are used to declare a class as a Spring-managed bean. However, they have different roles and intended purposes.

### `@Component`

* **Purpose**: General-purpose stereotype for a Spring-managed component.
* **Usage**: Typically used for classes that don’t fall under any specific layer, such as utility classes, helpers, or custom components.
* **Role in Architecture**: `@Component` is the most generic stereotype annotation and can be used in any part of the application.

Example:

```java
import org.springframework.stereotype.Component;

@Component
public class UtilityClass {
    public void doSomething() {
        // some logic
    }
}
```

### `@Service`

* **Purpose**: Specifically designed to indicate that the class is part of the service layer.
* **Usage**: Used to annotate classes that contain business logic. This annotation helps in identifying the intent and role of the bean as a service within the application architecture.
* **Additional Semantics**: `@Service` adds a semantic meaning to the class, signaling to other developers and tools that the class holds business logic or service functionality. While Spring doesn’t apply different behavior for `@Service`out of the box, some frameworks or libraries can leverage it for cross-cutting concerns (like transactions or logging).

Example:

```java
import org.springframework.stereotype.Service;

@Service
public class UserService {
    public void registerUser(String username) {
        // registration logic
    }
}
```

### Key Differences

<table><thead><tr><th width="157">Annotation</th><th>Purpose</th><th>Typical Use Case</th></tr></thead><tbody><tr><td><code>@Component</code></td><td>General-purpose stereotype</td><td>Utility, helper, or any generic Spring component</td></tr><tr><td><code>@Service</code></td><td>Service-layer stereotype</td><td>Business logic, service operations</td></tr></tbody></table>

### Practical Guidelines

* Use `@Service` for service-layer classes containing business logic, to make the code's purpose clearer and better organized.
* Use `@Component` for general-purpose classes or components that don’t strictly belong to the service layer, such as custom utilities or classes that aren’t part of a specific layer in your application architecture.



