# Auto Configuration

## About

Auto-configuration is a feature in Spring Boot that **automatically configures our application based on the dependencies present in the classpath**.

We don’t have to manually configure beans for commonly used components like:

* DataSource
* Spring MVC
* Security
* JPA
* RabbitMQ, Kafka, etc.

If Spring Boot detects related libraries in the classpath, it tries to auto-configure them with sensible defaults.

{% hint style="info" %}
* `@EnableAutoConfiguration`: Tells Spring Boot to start auto-configuring beans.
* `@SpringBootApplication`: Includes `@EnableAutoConfiguration`, `@ComponentScan`, and `@Configuration`.
* `@ConditionalOnClass`, `@ConditionalOnMissingBean`, `@ConditionalOnProperty`: Used in internal auto-config classes to decide what should be created.
{% endhint %}

## Why Is It Useful?

Auto-Configuration:

* Reduces boilerplate code
* Speeds up development
* Helps beginners start with minimal setup
* Makes applications cleaner and easier to manag

## How It Works ?

1. We annotate our main class with `@SpringBootApplication`, which includes `@EnableAutoConfiguration`.
2. Spring Boot scans the classpath and configuration properties.
3.  It loads auto-configuration classes declared in:

    ```
    META-INF/spring.factories (Spring Boot 2.x)
    ```

    or

    ```
    META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports (Spring Boot 3.x)
    ```
4. Each auto-configuration class has a series of `@Conditional...` annotations.
5. If conditions match (e.g., a class is present, a property is set), Spring Boot applies that configuration.

### Example

If we include **Spring Web** in our project (`spring-boot-starter-web`), Spring Boot will:

* Detect `spring-webmvc` on the classpath
* Auto-configure:
  * DispatcherServlet
  * Default error pages
  * Jackson for JSON serialization
  * Tomcat server setup

No need for us to declare those manually.

## How to Disable Auto-Configuration ?

We can selectively disable specific auto-configurations like this:

```java
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
```

## Best Practices

* Rely on Spring Boot’s default auto-configs as much as possible.
* Only create our own when needed (e.g., for reusable modules or libraries).
* Use `@Conditional` annotations to avoid overriding user-defined beans.
* Use `debug=true` to understand what’s going on.
