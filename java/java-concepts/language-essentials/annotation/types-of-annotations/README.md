# Types of Annotations

## About

Annotations in Java are not just syntactic sugar but they are a powerful mechanism to add metadata that the compiler, tools, or frameworks can interpret. Understanding their types helps us write more expressive, readable, and maintainable code.

We can classify Java annotations broadly into several types based on _purpose_, _structure_, and _usage scope_.

## 1. **Standard Annotations (Built-in Language Annotations)**

These are provided by Java itself and typically influence compiler behavior.

#### Examples

<table><thead><tr><th width="196.97308349609375">Annotation</th><th>Purpose</th></tr></thead><tbody><tr><td><code>@Override</code></td><td>Ensures a method is overriding a superclass method.</td></tr><tr><td><code>@Deprecated</code></td><td>Indicates that a method or class should no longer be used.</td></tr><tr><td><code>@SuppressWarnings</code></td><td>Tells the compiler to ignore specific warnings (like unchecked casts).</td></tr><tr><td><code>@FunctionalInterface</code></td><td>Marks an interface as having a single abstract method.</td></tr><tr><td><code>@SafeVarargs</code></td><td>Suppresses heap pollution warnings for varargs with generics.</td></tr></tbody></table>

These annotations improve **readability**, **compile-time safety**, and **documentation clarity**.

## 2. **Meta-Annotations**

Meta-annotations are annotations _on other annotations_. They define the behavior, scope, and life cycle of custom annotations.

#### Key Meta-Annotations

<table><thead><tr><th width="123.64410400390625">Annotation</th><th>Description</th></tr></thead><tbody><tr><td><code>@Target</code></td><td>Specifies where the annotation can be applied (method, field, class, etc.).</td></tr><tr><td><code>@Retention</code></td><td>Defines how long the annotation should be retained (SOURCE, CLASS, RUNTIME).</td></tr><tr><td><code>@Documented</code></td><td>Indicates that the annotation should appear in Javadocs.</td></tr><tr><td><code>@Inherited</code></td><td>Allows annotations to be inherited by subclasses.</td></tr><tr><td><code>@Repeatable</code></td><td>Allows an annotation to be applied multiple times to the same element.</td></tr></tbody></table>

These are crucial when **creating our own annotations**.

## 3. **Custom Annotations**

These are annotations **defined by the developer** for specific use cases, often processed using reflection or annotation processors.

#### Example

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface LogExecutionTime {
}
```

We can then process `@LogExecutionTime` in our application logic (e.g., with Spring AOP or a custom processor) to add behavior like measuring method execution time.

Custom annotations are often used in **frameworks, validations, event handling, or configuration**.

## 4. **Framework-Specific Annotations**

Modern Java frameworks (like Spring, JPA, Jackson) heavily rely on annotations to provide declarative programming.

#### Examples by Framework

* **Spring**: `@Component`, `@Autowired`, `@RequestMapping`, `@Transactional`
* **JPA (Hibernate)**: `@Entity`, `@Table`, `@Id`, `@Column`
* **Jackson (for JSON mapping)**: `@JsonProperty`, `@JsonIgnore`, `@JsonInclude`
* **JUnit**: `@Test`, `@BeforeEach`, `@AfterAll`

These annotations **configure application behavior**, **manage dependencies**, or **handle persistence**—all without writing boilerplate code.

## 5. **Marker Annotations**

Marker annotations are **annotations without any methods**. Their presence alone conveys meaning.

#### Examples:

* `@Deprecated`
* `@Override`
* Custom: `@Secure`, `@Trackable`, etc.

They act like **boolean flags**: the mere presence of the annotation is enough to trigger logic.

## 6. **Single-Value Annotations**

These annotations have **only one method**, usually named `value()`, allowing the user to omit the key when assigning a value.

```java
public @interface Role {
    String value();
}

@Role("ADMIN") // no need to write value = "ADMIN"
```

They provide a concise syntax while still carrying metadata.

## 7. **Multi-Value Annotations**

Multi-value annotations allow for **multiple named attributes**, making them versatile for complex metadata.

```java
public @interface Config {
    String name();
    int version();
}

@Config(name = "AppX", version = 2)
```

These are ideal for **declarative configuration**, such as defining API routes, validation rules, or policies.

## 8. **Repeatable Annotations**

Prior to Java 8, the same annotation couldn’t be applied more than once to the same element. With `@Repeatable`, this is now possible.

```java
@Schedule(day = "Monday")
@Schedule(day = "Friday")
public void generateReport() {}
```

We must mark the annotation with `@Repeatable(SomeContainer.class)` to enable this.
