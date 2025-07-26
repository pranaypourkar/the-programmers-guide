# Annotation

## About

Annotations are one of Java’s most powerful language features introduced in **Java 5**. They enable a **declarative programming style** by allowing developers to embed metadata directly into the source code. Instead of writing complex logic or maintaining large configuration files (like XML), annotations let you **describe behavior**, **attach rules**, or **delegate responsibilities** to compilers, tools, and frameworks — all with just a few lines of markup.

Annotations are a form of metadata that provide **data about the program**, but **they are not part of the program logic itself**. In simpler terms, annotations are **tags** or **labels** that we can attach to code elements like classes, methods, variables, parameters, and packages.

These tags are used by:

* The **compiler** (for compile-time instructions or warnings)
* The **runtime environment** (for behavior modification via reflection)
* **Frameworks and tools** (like Spring, Hibernate, JUnit, etc.)

Annotations do not change what the code does, but they **influence how the code is processed**.

## Why Annotations Matter

Before annotations, configuration was often done using XML or verbose code. Annotations made it easier to:

* Make code **self-descriptive** and **declarative**
* Eliminate external configuration files
* Reduce boilerplate code
* Help frameworks like Spring, Hibernate, JUnit, etc., act automatically

Annotations enable **cleaner**, **more maintainable**, and **readable** code - especially in modern Java development.

## Characteristics

* **Annotations are passive**

They **don’t perform any action** themselves — they are just markers or metadata. The behavior is determined by the tools or code that **interprets them** (such as Spring, JUnit, Hibernate, or annotation processors).

* **They reduce boilerplate**

Annotations can **simplify logic** that otherwise would require repetitive setup, reflection, or configuration files.

* **They improve readability**

Code becomes more **self-explanatory**. For example:

```java
@Entity
public class User { ... }
```

Immediately tells the reader: “This class represents a database entity.”

* **They support tools and frameworks**

Tools like **Lombok**, frameworks like **Spring**, and libraries like **Jackson** rely heavily on annotations to work without needing verbose logic.

* **They work with reflection and processing**

At runtime or compile time, annotations can be accessed using **reflection APIs** or **annotation processors** to dynamically alter behavior, generate code, validate constraints, or apply custom rules.

## Processing Annotations

Annotations by themselves are just **metadata** — they don’t _do_ anything until some **processor or tool acts upon them**. Processing annotations means writing code (or using a framework) that **reads, interprets, and reacts to annotations**, either during **compile-time** or **runtime**.

This is where annotations truly shine — enabling features like dependency injection, automatic configuration, validation, object mapping, and more.

#### Two Types of Annotation Processing

### 1. **Compile-Time Annotation Processing**

At compile time, you can use **Annotation Processors** (via the Java Compiler API or tools like Lombok and AutoValue) to:

* Generate new source files
* Validate annotated elements
* Modify or augment code
* Enforce coding constraints

These processors implement the `javax.annotation.processing.Processor` interface (or extend `AbstractProcessor`) and are registered via the `META-INF` services mechanism.

**Example Use Case**:\
A custom `@Builder` annotation might generate a builder class at compile time.

**Tools/Frameworks that use compile-time processing**:

* Lombok
* Dagger
* AutoValue
* MapStruct

### 2. **Runtime Annotation Processing**

At runtime, Java provides **Reflection APIs** to inspect annotations and act on them dynamically.

This is common in frameworks like:

* Spring (e.g., `@Autowired`, `@RequestMapping`)
* Hibernate (`@Entity`, `@Id`)
* JUnit (`@Test`, `@BeforeEach`)

We can use methods like `.getAnnotations()`, `.isAnnotationPresent()`, or `.getAnnotation()` on classes, methods, fields, etc.

## Example

### **Compile Time** Annotation - `@Override`

```java
class Animal {
    void makeSound() {
        System.out.println("Animal sound");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Bark");
    }
}
```

#### What's Happening Here ?

* The annotation `@Override` is applied on the `makeSound()` method in `Dog` class.
* This tells the **compiler**:\
  “Ensure this method is overriding a method from the superclass.”

#### How It Works ?

**1. At the Compiler Level**

* The Java compiler sees the `@Override` annotation and checks if the method:
  * Exists in a superclass or interface.
  * Matches the method signature exactly.
*   If the method does **not** override a valid method (say we misspell it as `makeSoun()`), the compiler throws an error:

    ```
    method does not override or implement a method from a supertype
    ```
* **No special bytecode is added** for `@Override`. It **exists only at compile-time**. It’s not stored in the `.class` file.

**2. At Runtime**

* `@Override` **does not exist at runtime** because it has no `@Retention(RetentionPolicy.RUNTIME)`.
*   We **cannot access it via reflection**.

    ```java
    Method m = Dog.class.getMethod("makeSound");
    Annotation[] annotations = m.getAnnotations(); // @Override will not appear
    ```

**3. Why It’s Useful**

* Prevents bugs caused by mistyped method names.
* Helps document intent clearly — readers know this method is overriding a parent one.
* Improves tooling support (like showing warnings in IDEs).

### Runtime Annotation - Custom

#### Create the Annotation

```java
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.annotation.ElementType;

// Custom annotation available at runtime
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface MyLog {
    String value() default "default-log";
}
```

#### Apply the Annotation

```java
public class Service {

    @MyLog("fetching-user-data")
    public void getUser() {
        System.out.println("Inside getUser()");
    }

    @MyLog
    public void updateUser() {
        System.out.println("Inside updateUser()");
    }
}
```

#### Step 3: Read and Use the Annotation at Runtime (via Reflection)

```java
import java.lang.reflect.Method;

public class AnnotationProcessor {
    public static void main(String[] args) throws Exception {
        Service service = new Service();

        Method[] methods = service.getClass().getDeclaredMethods();
        for (Method method : methods) {
            if (method.isAnnotationPresent(MyLog.class)) {
                MyLog annotation = method.getAnnotation(MyLog.class);
                System.out.println("Calling method: " + method.getName() +
                                   " | Log Tag: " + annotation.value());
                method.invoke(service); // actually call the method
            }
        }
    }
}
```

#### What’s Happening Internally ?

<table data-full-width="true"><thead><tr><th width="199.0694580078125">Stage</th><th>What Happens</th></tr></thead><tbody><tr><td>Annotation Declared</td><td>The annotation is marked with <code>@Retention(RUNTIME)</code> so it is kept at runtime</td></tr><tr><td>Annotation Used</td><td>The annotation is added to methods like <code>getUser()</code> and <code>updateUser()</code></td></tr><tr><td>During Execution</td><td>Java Reflection reads the annotation from the method</td></tr><tr><td>Effect</td><td>We can dynamically control behavior based on the annotation (e.g., logging)</td></tr></tbody></table>

#### Why Runtime Annotations ?

* Frameworks like **Spring**, **JPA**, **Hibernate**, **Jackson**, and **JUnit** use runtime annotations to add behavior dynamically.
* Examples:
  * `@Entity` in JPA
  * `@Test` in JUnit
  * `@RestController` in Spring Boot

These annotations **do not change the logic themselves**, but **external tools and frameworks** interpret them to apply behavior.

## Where Are Annotations Used ?

<table data-header-hidden data-full-width="true"><thead><tr><th width="167.150146484375"></th><th width="270.83856201171875"></th><th width="220.1119384765625"></th><th></th></tr></thead><tbody><tr><td><strong>Use Case</strong></td><td><strong>Purpose</strong></td><td><strong>Common Annotations</strong></td><td><strong>Example</strong></td></tr><tr><td><strong>Code Metadata</strong></td><td>Marking information about code for documentation or tooling</td><td><code>@Override</code>, <code>@Deprecated</code>, <code>@SuppressWarnings</code></td><td><code>@Override</code> on a method to ensure proper overriding</td></tr><tr><td><strong>Dependency Injection</strong></td><td>Injecting objects into classes at runtime</td><td><code>@Autowired</code>, <code>@Inject</code>, <code>@Resource</code></td><td>Spring injects a bean using <code>@Autowired</code></td></tr><tr><td><strong>Configuration</strong></td><td>Declaring how components should behave or be wired</td><td><code>@Component</code>, <code>@Configuration</code>, <code>@Bean</code></td><td>Spring defines a configuration class with <code>@Configuration</code></td></tr><tr><td><strong>Validation</strong></td><td>Enforcing field constraints</td><td><code>@NotNull</code>, <code>@Min</code>, <code>@Email</code>, <code>@Valid</code></td><td><code>@NotNull</code> ensures a field is not left empty</td></tr><tr><td><strong>Persistence (ORM)</strong></td><td>Mapping Java objects to database tables</td><td><code>@Entity</code>, <code>@Id</code>, <code>@Column</code>, <code>@Table</code></td><td>JPA maps a class to a DB table with <code>@Entity</code></td></tr><tr><td><strong>Testing</strong></td><td>Marking test methods or lifecycle hooks</td><td><code>@Test</code>, <code>@BeforeEach</code>, <code>@AfterAll</code></td><td>JUnit runs test methods annotated with <code>@Test</code></td></tr><tr><td><strong>Security</strong></td><td>Defining access restrictions</td><td><code>@PreAuthorize</code>, <code>@RolesAllowed</code></td><td>Spring Security uses <code>@PreAuthorize("hasRole('ADMIN')")</code></td></tr><tr><td><strong>Web (REST APIs)</strong></td><td>Mapping HTTP routes to methods</td><td><code>@RequestMapping</code>, <code>@GetMapping</code>, <code>@PostMapping</code></td><td>Spring maps an endpoint using <code>@GetMapping("/users")</code></td></tr><tr><td><strong>Serialization</strong></td><td>Controlling how objects are converted to/from JSON/XML</td><td><code>@JsonProperty</code>, <code>@XmlElement</code></td><td>Jackson uses <code>@JsonProperty</code> to rename JSON fields</td></tr><tr><td><strong>Concurrency</strong></td><td>Marking thread-safe or guarded regions</td><td><code>@GuardedBy</code>, <code>@ThreadSafe</code> (from JSR-305)</td><td>IDEs can understand concurrency behavior</td></tr><tr><td><strong>Custom Logic/Control</strong></td><td>Triggering actions or logic in frameworks</td><td>Custom annotations (e.g., <code>@Retry</code>, <code>@Cacheable</code>)</td><td>Spring retries a method call using <code>@Retryable</code></td></tr><tr><td><strong>Compile-Time Processing</strong></td><td>Generating code or validating usage during compilation</td><td><code>@Builder</code>, <code>@AutoValue</code>, <code>@Generated</code></td><td>Lombok generates code using <code>@Builder</code></td></tr><tr><td><strong>Logging / Monitoring</strong></td><td>Intercepting methods for logging or metrics</td><td>Custom annotations + AOP (e.g., <code>@LogExecutionTime</code>)</td><td>Spring AOP intercepts methods using annotation-based advice</td></tr></tbody></table>

