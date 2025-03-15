# Lazy & Eager Initialization

## About

In Spring, bean initialization determines when a bean is created and initialized in the application context. The two main strategies are:

1. **Eager Initialization** (default) – Beans are created at application startup.
2. **Lazy Initialization** – Beans are created only when requested.

## What is Eager Initialization ?

Eager initialization means that **Spring creates all singleton beans during application startup**, regardless of whether they are needed immediately or not.

#### **How It Works?**

* By default, Spring initializes all **singleton beans** eagerly at startup.
* The moment the **ApplicationContext** is loaded, Spring scans for beans and initializes them.
* This ensures that all dependencies are properly wired and available before any request is processed.

#### **Example of Eager Initialization**

```java
@Component
public class EagerBean {
    public EagerBean() {
        System.out.println("EagerBean Initialized");
    }
}
```

* Since this is a singleton bean (default scope), it will be created at startup, **even if never used**.

{% hint style="info" %}
**Eager Initialization helps -**

* **Early Failure Detection**: If a bean has a misconfiguration or an error, it will fail fast at startup, preventing runtime failures.
* **Ensures Availability**: All required dependencies are ready before processing any request.
* **Better for Core Components**: Essential components (e.g., security configurations, database connections) are ready beforehand.

**However it causes -**

* **Slower Application Startup**: Since all beans are created upfront, startup time increases.
* **Increased Memory Usage**: Beans that may never be used still consume memory and resources.
{% endhint %}

## **What is Lazy Initialization ?**

Lazy initialization means that **Spring defers the creation of a bean until it is first requested**. Instead of creating all beans at startup, Spring only initializes them when a method or another bean explicitly calls for it.

#### **How It Works?**

* When using `@Lazy`, Spring **does not** create the bean at application startup.
* The bean is **only instantiated when needed** (i.e., when accessed for the first time).
* This improves startup performance by skipping unnecessary bean initialization.

#### **Example of Lazy Initialization**

```java
@Component
@Lazy
public class LazyBean {
    public LazyBean() {
        System.out.println("LazyBean Initialized");
    }
}
```

* Here, the `LazyBean` is **not initialized** at startup.
* The moment we call `context.getBean(LazyBean.class)`, **only then** will it be instantiated.

**Explicit Lazy Initialization in Configuration Class**

```java
@Configuration
public class AppConfig {
    @Bean
    @Lazy
    public LazyBean lazyBean() {
        return new LazyBean();
    }
}
```

* This delays the initialization of `LazyBean` until it is **first used**.

{% hint style="info" %}
**Lazy Initialization helps -**

* **Faster Application Startup**: Since beans are only created when needed, startup time is reduced.
* **Lower Memory Consumption**: Unused beans don’t consume memory, improving resource management.
* **Useful for Optional Beans**: Helps in situations where some beans may not always be needed (e.g., feature toggles).

**However it causes -**&#x20;

* **Potential Runtime Errors**: If a required bean fails to initialize later, it may cause failures during runtime rather than at startup.
* **Delayed Performance Issues**: If a bean takes time to initialize, it can introduce latency during the first request.
{% endhint %}

## **Applying Lazy Initialization at Different Levels**

### **A. At the Bean Level**

Use `@Lazy` at the individual bean level:

```java
@Component
@Lazy
public class LazyService {
    public LazyService() {
        System.out.println("LazyService Initialized");
    }
}
```

### **B. At the Configuration Level**

All beans in a specific configuration class can be lazily initialized:

```java
@Configuration
@Lazy
public class LazyConfig {
    @Bean
    public SomeBean someBean() {
        return new SomeBean();
    }
}
```

* This makes **all beans in this configuration class** lazy.

### **C. At the Application Level**

To make **all singleton beans lazy by default**, use:

```java
@SpringBootApplication
@Lazy
public class SpringLazyApplication {
    public static void main(String[] args) {
        SpringApplication.run(SpringLazyApplication.class, args);
    }
}
```

* This ensures that every bean in the application follows lazy initialization unless explicitly marked otherwise.

## **When to Use Eager vs. Lazy Initialization?**

### **Use Eager Initialization when**

* When beans are **critical to application startup** (e.g., security configurations, database connections).
* When we **want to fail fast** in case of errors.
* When **response time matters** (e.g., API services that must be ready instantly).

### **Use Lazy Initialization when**

* When beans are **not always required** (e.g., feature toggles, optional services).
* When **reducing startup time is important** (e.g., microservices with fast boot time).
* When dealing with **heavy beans that consume resources** (e.g., large caches, third-party API clients).
