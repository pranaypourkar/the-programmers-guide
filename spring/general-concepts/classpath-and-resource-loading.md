# Classpath and Resource Loading

## What is the Classpath?

**Classpath** is the list of locations (folders or JARs) where the Java Virtual Machine (JVM) and Spring Framework search for class files and resources (like `.properties`, `.yml`, `.xml`, etc.).

#### It includes:

* `/src/main/java` → compiled into `/target/classes`
* `/src/main/resources` → also copied to `/target/classes`
* Dependencies → JARs included via Maven/Gradle

Everything inside `/target/classes` and JARs in your dependencies becomes part of the runtime classpath.

## Why Classpath Matters in Spring ?

Spring uses the classpath to:

* Load configuration files (`application.properties`, YAML, XML)
* Locate and register beans via classpath scanning
* Perform conditional configurations (via `@ConditionalOnClass`)
* Load static resources, templates, and files
* Handle features like internationalization (loading `.properties`)

{% hint style="info" %}
### `src/main/resources` and the Classpath

Everything inside the `src/main/resources` directory is automatically copied into `target/classes` during the build.

At runtime, the `target/classes` directory is part of the classpath. So when we place something like `application.properties` in `src/main/resources`, Spring can load it using:

```java
classpath:application.properties
```

No extra configuration needed — it’s just part of the classpath.
{% endhint %}

## How Classpath Impacts Spring Features ?

### a. **@ComponentScan**

Spring uses classpath scanning to automatically discover and register beans with annotations like `@Component`, `@Service`, etc.

```java
@ComponentScan("com.example")
```

### b. **@ConditionalOnClass**

Used in Spring Boot’s auto-configuration to conditionally create beans if a class is present on the classpath.

```java
@Configuration
@ConditionalOnClass(name = "com.example.SomeLibrary")
public class SomeAutoConfig {
    // Loaded only if SomeLibrary is present
}
```

### c. **spring.factories / spring.autocOnfiguration.imports**

Auto-configuration is triggered based on the presence of classes on the classpath.

## How Spring Loads Resources from the Classpath ?

Spring abstracts away resource loading using the `org.springframework.core.io.Resource` interface. We don’t have to worry about where the resource is stored — Spring handles it based on the given prefix.

### Using `ResourceLoader`

```java
@Autowired
private ResourceLoader resourceLoader;

public void readResource() throws IOException {
    Resource resource = resourceLoader.getResource("classpath:config/app.properties");
    InputStream inputStream = resource.getInputStream();
    // Do something with the stream
}
```

### Using `@Value`

```java
@Value("classpath:config/app.properties")
private Resource resource;
```

### Using `ClassPathResource` Directly

```java
Resource resource = new ClassPathResource("config/app.properties");
```

## Common Classpath Prefixes

<table><thead><tr><th width="156.375">Prefix</th><th>Description</th></tr></thead><tbody><tr><td><code>classpath:</code></td><td>Load a single resource from the root of the classpath.</td></tr><tr><td><code>classpath*:</code></td><td>Load <strong>multiple resources</strong> matching a pattern (used for scanning JARs too).</td></tr></tbody></table>

```java
resourceLoader.getResource("classpath:application.yml");
resourceLoader.getResource("classpath*:META-INF/spring.factories");
```

## Resource Loading Example

Assume a file exists at:

```
src/main/resources/config/settings.properties
```

We can load it using:

```java
Resource resource = new ClassPathResource("config/settings.properties");
Properties props = new Properties();
props.load(resource.getInputStream());
```
