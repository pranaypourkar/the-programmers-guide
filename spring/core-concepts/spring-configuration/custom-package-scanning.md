# Custom Package Scanning

## About

In Spring Boot, annotations like `@ComponentScan`, `@EnableJpaRepositories`, and `@EntityScan` are used to **automatically detect and register beans, repositories, and entities** during application startup.

By default, these annotations scan the packages from the **location of the `@SpringBootApplication` class and below**. In modular or layered applications, especially when using external modules or JARs, it is often necessary to **explicitly specify additional packages to scan**, especially when we **cannot modify the base project**.

## Why Custom Package Scanning Is Needed

We may need custom scanning when:

* We add a new module with additional repositories or entities.
* The main application class (in a base JAR) does not scan our current module.
* We want to keep modules loosely coupled and modular.
* We have split our domain, persistence, and business logic into separate packages or modules.

If we don’t configure it correctly:

* Spring will not detect our new `@Entity` classes.
* `@Repository` interfaces in our module will not be instantiated.
* Beans from our new packages will not be registered.

## Common Scenarios

* We are working on an **extension or feature module** that includes:
  * New `@Entity` classes (e.g., `com.my.module.entity`)
  * New `@Repository` interfaces (e.g., `com.my.module.repository`)
  * New `@Service` or `@Component` classes (e.g., `com.my.module.service`)
* The main application class resides in a base library or core project that we **cannot modify**.

## Solution: Define a Local Configuration Class

Instead of modifying the base application class, define a **new configuration class** in our module to declare custom scanning behavior.

#### Example

```java
@Configuration
@ComponentScan(basePackages = "com.my.module")
@EntityScan(basePackages = "com.my.module.entity")
@EnableJpaRepositories(basePackages = "com.my.module.repository")
public class MyModuleScanConfig {
    // We can leave this empty. Spring will do the scanning.
}
```

#### Where to Place This Configuration

* Place this config class in our own module.
* It will be picked up automatically if:
  * It is in a package scanned by the base application.
  * Or we import it manually using `@Import(MyModuleScanConfig.class)` from any scanned configuration.

If not automatically scanned, we can register it manually:

```java
@SpringBootApplication
@Import(MyModuleScanConfig.class)
public class ExtensionApplication {
    public static void main(String[] args) {
        SpringApplication.run(ExtensionApplication.class, args);
    }
}
```

Or, if even this is not possible (e.g., we're adding to an existing WAR), we can create a new `@Configuration` class that is picked up as part of Spring’s component scanning from a `META-INF/spring.factories` file in more advanced setups.



## 1. ComponentScan

### About

`@ComponentScan` is a Spring annotation used to **automatically discover and register beans** in the Spring application context.\
It tells Spring **which packages to scan** for classes annotated with:

* `@Component`
* `@Service`
* `@Repository`
* `@Controller`
* `@RestController`
* `@Configuration`

These annotated classes are automatically **detected and registered** as Spring beans without needing to declare them manually.

### Default Behavior

When we use `@SpringBootApplication`, it **implicitly includes** `@ComponentScan`.

By default, it scans all packages **starting from the package of the class annotated with `@SpringBootApplication`** and downward (i.e., all subpackages).

```java
@SpringBootApplication // includes @ComponentScan
public class MyApp {
    public static void main(String[] args) {
        SpringApplication.run(MyApp.class, args);
    }
}
```

So if our `@SpringBootApplication` class is in the package `com.example`, all components under `com.example.*` will be scanned automatically.

### Syntax and Usage

#### 1. Scanning Specific Packages

```java
@ComponentScan(basePackages = "com.my.module")
```

We can also provide multiple packages:

```java
@ComponentScan(basePackages = {
    "com.my.module.service",
    "com.my.module.controller"
})
```

#### 2. Scanning by Class Reference

We can also reference a class instead of using a string:

```java
@ComponentScan(basePackageClasses = MyService.class)
```

This is type-safe and avoids hardcoding package names.

#### Example with Filters

```java
@ComponentScan(
    basePackages = "com.my.module",
    includeFilters = @ComponentScan.Filter(type = FilterType.ANNOTATION, classes = MyMarker.class),
    excludeFilters = @ComponentScan.Filter(type = FilterType.REGEX, pattern = ".*Internal.*")
)
```

* This includes only components marked with `@MyMarker`.
* It excludes components whose class names match `.*Internal.*`.

### Attributes

<table data-full-width="true"><thead><tr><th width="219.13458251953125">Attribute</th><th>Description</th></tr></thead><tbody><tr><td><code>basePackages</code></td><td>One or more package names to scan.</td></tr><tr><td><code>basePackageClasses</code></td><td>One or more classes; Spring scans the packages of those classes.</td></tr><tr><td><code>includeFilters</code></td><td>Filters for including specific component types (with <code>@Filter</code>).</td></tr><tr><td><code>excludeFilters</code></td><td>Filters for excluding specific types or patterns.</td></tr><tr><td><code>lazyInit</code></td><td>If <code>true</code>, beans are created lazily instead of at startup.</td></tr><tr><td><code>nameGenerator</code></td><td>Custom bean name generator.</td></tr><tr><td><code>useDefaultFilters</code></td><td>If <code>false</code>, disables default <code>@Component</code>, etc. scanning.</td></tr><tr><td><code>scopedProxy</code></td><td>Scope proxy options (used for advanced scoping like session/request).</td></tr></tbody></table>

### Common Issues and Fixes

<table data-full-width="true"><thead><tr><th width="287.0364990234375">Problem</th><th>Cause</th><th>Solution</th></tr></thead><tbody><tr><td>My service/controller is not getting injected</td><td>Not in a scanned package</td><td>Add the package to <code>@ComponentScan</code></td></tr><tr><td>Unwanted beans getting created</td><td>Default scanning includes everything</td><td>Use <code>excludeFilters</code> or disable <code>useDefaultFilters</code></td></tr><tr><td>Slow startup or memory issues in large apps</td><td>Scanning too many unnecessary packages</td><td>Limit <code>basePackages</code> to only what's needed</td></tr><tr><td>Duplicated beans with same name</td><td>Scanning same package in multiple modules</td><td>Check overlapping scan configurations</td></tr></tbody></table>

## 2. EntityScan

### About

`@EntityScan` is a Spring Boot-specific annotation used to **explicitly specify the packages to scan for JPA entities** (`@Entity`, `@Embeddable`, `@MappedSuperclass`).

Spring Boot, by default, only scans entity classes in the package (and subpackages) where the `@SpringBootApplication` class resides. If our entity classes are located **outside of that package**, we need `@EntityScan`.

{% hint style="success" %}
`@ComponentScan` does **not** include or cover `@EntityScan`.

They serve **completely different purposes**, and in the context of **Spring Boot** and **multi-module projects**, we must declare **both separately** if our **external module contains both components and JPA entities**.
{% endhint %}

### Why `@EntityScan` is Needed ?

By default:

```java
@SpringBootApplication // includes @ComponentScan, @EnableAutoConfiguration
public class MainApp {}
```

Only scans entities under `com.example` if this class is in `com.example`.

If our entities are in:

```java
package com.external.module.entity;
```

They will not be discovered automatically. We will encounter runtime errors such as:

* `Not a managed type`
* `Unable to locate entity`

To fix this, use:

```java
@EntityScan(basePackages = "com.external.module.entity")
```

#### Where to Place `@EntityScan`

*   On our main application class:

    ```java
    @SpringBootApplication
    @EntityScan(basePackages = "com.my.module.entity")
    public class MyApplication {}
    ```
*   Or in a separate `@Configuration` class:

    ```java
    @Configuration
    @EntityScan(basePackages = "com.my.module.entity")
    public class EntityScanConfig {}
    ```

    And register using:

    ```java
    @SpringBootApplication
    @Import(EntityScanConfig.class)
    public class MyApp {}
    ```

### Syntax

Single Package

```java
@EntityScan(basePackages = "com.example.entity")
```

Multiple Packages

```java
@EntityScan(basePackages = {
    "com.example.entity",
    "com.shared.common.entity"
})
```

Type-Safe with Class Reference

```java
@EntityScan(basePackageClasses = MyEntity.class)
```

This is safer during refactoring as it avoids hardcoded package strings.

### Attributes

<table><thead><tr><th width="207.381103515625">Attribute</th><th>Description</th></tr></thead><tbody><tr><td><code>basePackages</code></td><td>Array of package names to scan for entities.</td></tr><tr><td><code>basePackageClasses</code></td><td>Type-safe way to scan the package of the given class.</td></tr></tbody></table>

## 3. EnableJpaRepositories

### About

`@EnableJpaRepositories` is a Spring Data annotation used to enable **scanning and registration of Spring Data JPA repository interfaces**, such as those extending:

* `JpaRepository`
* `CrudRepository`
* `PagingAndSortingRepository`

It is responsible for **detecting our repository interfaces**, generating proxy implementations, and **integrating them with the JPA entity manager**.

{% hint style="success" %}
**Does `@EnableJpaRepositories` include `@EntityScan`?**

**No**, it does **not**.

* `@EnableJpaRepositories` only scans for repository interfaces like `UserRepository extends JpaRepository<User, Long>`.
* It **does not scan or register JPA entity classes** (`@Entity` annotated classes).
* If our entities are outside the default scan path, we **must** use `@EntityScan` explicitly.

\


**Does `@EntityScan` include `@EnableJpaRepositories`?**

**No**, it does **not**.

* `@EntityScan` only registers entity classes (`@Entity`, `@Embeddable`, `@MappedSuperclass`) so that JPA can map them to database tables.
* It **does not scan or register repository interfaces**.
* We still need `@EnableJpaRepositories` if the repository interfaces are outside the main package.

\


**Does `@ComponentScan` include `@EnableJpaRepositories`?**

**No**, it does **not**.

* `@ComponentScan` detects and registers Spring beans annotated with `@Component`, `@Service`, `@Controller`, `@RestController`, etc.
* It **does not process repository interfaces** or generate their implementations.
* Repository interfaces are not annotated with `@Component`, so `@ComponentScan` will **not register them**.
{% endhint %}

### Why is it Needed ?

Spring Boot, by default, scans repositories in the **same package or subpackages of our main application class** (`@SpringBootApplication`). If our repository interfaces are located **outside of this default scope**, we must explicitly specify the package using `@EnableJpaRepositories`.

### Default Behavior

If we don’t specify `@EnableJpaRepositories`, Spring Boot still scans for repositories, but only under the default package (where our main class resides).

If we need to include repositories from another module, library, or unrelated package, we must declare:

```java
@EnableJpaRepositories(basePackages = "com.external.module.repository")
```

### Example

```java
@EnableJpaRepositories(basePackages = "com.my.module.repository")
```

Type-Safe Alternative

```java
@EnableJpaRepositories(basePackageClasses = MyRepository.class)
```

With Additional Configuration

```java
@EnableJpaRepositories(
    basePackages = "com.my.module.repository",
    entityManagerFactoryRef = "myEntityManagerFactory",
    transactionManagerRef = "myTransactionManager"
)
```

### Attributes

<table data-full-width="true"><thead><tr><th width="274.64239501953125">Attribute</th><th>Description</th></tr></thead><tbody><tr><td><code>basePackages</code></td><td>Array of package names to scan for repository interfaces.</td></tr><tr><td><code>basePackageClasses</code></td><td>Type-safe alternative to <code>basePackages</code>, scans package of the given class.</td></tr><tr><td><code>includeFilters</code></td><td>Used to include specific types.</td></tr><tr><td><code>excludeFilters</code></td><td>Used to exclude certain classes from being registered as repositories.</td></tr><tr><td><code>repositoryFactoryBeanClass</code></td><td>Custom factory bean to create repositories.</td></tr><tr><td><code>entityManagerFactoryRef</code></td><td>Bean name of the <code>EntityManagerFactory</code> to associate with these repositories.</td></tr><tr><td><code>transactionManagerRef</code></td><td>Bean name of the <code>PlatformTransactionManager</code> for this repository group.</td></tr><tr><td><code>considerNestedRepositories</code></td><td>Whether nested interfaces should be considered. Default is <code>false</code>.</td></tr></tbody></table>

### **Does** `@ComponentScan` **register** JPA repository **interfaces**

No

For example:

```java
public interface UserRepository extends JpaRepository<User, Long> {
    // no implementation provided
}
```

Even though Spring dynamically creates a proxy clas**s** and marks it as a `@Repository`, this behavior is triggered by:

```java
@EnableJpaRepositories
```

Because `@ComponentScan` works with actual class files annotated with `@Component`, `@Repository`, etc. It does not dynamically generate or proxy anything.

But `@EnableJpaRepositories` activates Spring Data’s infrastructure, which:

* Scans for repository interfaces
* Dynamically generates proxy beans
* Registers them in the application context

## 4. Import

### About

`@Import` is a Spring annotation used to **manually import one or more `@Configuration` classes** (or component classes) into the Spring application context.

It gives us a way to **programmatically include configurations or beans** that are **not automatically picked up by component scanning**.

{% hint style="success" %}
* `@Import` does **not scan** packages. It **registers specific classes**.
* It is often used to **bridge between modules** in a modular project.
* It can also import **non-`@Configuration` classes** such as regular components or `ImportSelector`/`ImportBeanDefinitionRegistrar` implementations.
{% endhint %}

### Why and When to Use ?

We use `@Import` when:

* We have configuration classes in **external modules or libraries**.
* We want to load **Java-based configuration** from other packages or jars.
* We **do not want to rely on `@ComponentScan`** to find those classes.
* We want **explicit, modular control** over what configuration gets loaded.
* We are registering beans dynamically or combining multiple configuration sources.

### Example

#### Importing a Single Configuration Class

```java
@Configuration
public class MyConfig {
    @Bean
    public MyService myService() {
        return new MyService();
    }
}
```

Then in our main class:

```java
@SpringBootApplication
@Import(MyConfig.class)
public class MyApp {}
```

This tells Spring Boot to include `MyConfig` during context initialization even if it is not in a scanned package.

#### Importing Multiple Classes

```java
@Import({MyConfig.class, AnotherConfig.class, SecurityConfig.class})
```

### Best Practices

* Prefer `@Import` for **fine-grained and modular inclusion** of configurations.
* Use `@Import` instead of `@ComponentScan` for **external libraries or JARs** where scanning may not be desirable.
* Avoid excessive or scattered usage of `@Import`; centralize imports logically.
