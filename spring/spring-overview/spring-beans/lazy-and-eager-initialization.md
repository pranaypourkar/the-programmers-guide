---
hidden: true
---

# Lazy & Eager Initialization

## About

In Spring, bean initialization determines when a bean is created and initialized in the application context. The two main strategies are:

1. **Eager Initialization** (default) – Beans are created at application startup.
2. **Lazy Initialization** – Beans are created only when requested.

## What is Eager Initialization?

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
