# Spring Boot Specific

## About

Spring Boot provides several annotations that simplify configuration, auto-configuration, and conditional bean loading.

## **1. Core Spring Boot Annotations**

These annotations help in configuring and bootstrapping a Spring Boot application.

### **`@SpringBootApplication`**

* This is the main entry point for a Spring Boot application.
* It is a combination of:
  * `@Configuration` – Marks the class as a Spring configuration class.
  * `@EnableAutoConfiguration` – Enables automatic configuration based on dependencies.
  * `@ComponentScan` – Scans for components in the same package and sub-packages.

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

### **`@EnableAutoConfiguration`**

* Enables Spring Boot’s auto-configuration feature, which automatically configures beans based on the classpath.
* It is included in `@SpringBootApplication`.

```java
@Configuration
@EnableAutoConfiguration
public class MyConfig {
}
```

## **2. Conditional Annotations**

These annotations conditionally enable or disable beans based on various criteria.

### **`@ConditionalOnProperty`**

* Loads a bean only if a specified property exists in `application.properties` or `application.yml`.

```java
// If feature.enabled=true, MyFeature bean is created.
@ConditionalOnProperty(name = "feature.enabled", havingValue = "true")
@Bean
public MyFeature myFeature() {
    return new MyFeature();
}
```

### **`@ConditionalOnClass`**

* Loads a bean only if a specified class is present in the classpath.

```java
// If ExternalLibrary is available, myService() is registered.
@ConditionalOnClass(name = "com.example.ExternalLibrary")
@Bean
public MyService myService() {
    return new MyService();
}
```

### **`@ConditionalOnMissingBean`**

* Registers a bean only if no other bean of the same type exists.

```java
// If MyService is already defined elsewhere, this bean won’t be created.
@Bean
@ConditionalOnMissingBean(MyService.class)
public MyService defaultService() {
    return new MyService();
}
```

### **`@ConditionalOnBean`**

* Registers a bean only if another specified bean exists.

```java
// MyService is created only if MyDependency is present.
@Bean
@ConditionalOnBean(MyDependency.class)
public MyService myService() {
    return new MyService();
}
```



