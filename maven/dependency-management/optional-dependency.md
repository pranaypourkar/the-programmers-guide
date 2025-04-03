# Optional Dependency

## About

In a **Maven Spring Boot project**, some dependencies are **not always required** by default. However, they may be needed **only in specific scenarios**.

To avoid **forcing transitive dependencies** onto other projects, Maven provides the **Optional Dependency** mechanism.

When a Maven dependency is marked as **optional**, it means -

* **It will NOT be included as a transitive dependency** in projects that depend on your project.
* The dependency is **only needed for specific use cases**.
* It **must be explicitly added** by the consuming project if required.

**Without `optional=true`, the dependency would be included transitively.**

## When to Use Optional Dependencies?

### **Scenario 1 – Avoiding Unwanted Transitive Dependencies**

Some libraries provide **additional functionality** that **not all users need**. Instead of forcing them to use it, you can make it **optional**.

### **Scenario 2 – Supporting Plugins or Extensions**

If a project provides an **extension system**, optional dependencies can be used to include them only when needed.

### **Scenario 3 – Avoiding Conflicts**

A library might have **multiple implementations** (e.g., different logging frameworks), and you want to **let the user choose** which one to use.

## How to Define an Optional Dependency ?

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>example-library</artifactId>
    <version>1.0.0</version>
    <optional>true</optional>
</dependency>
```

The above dependency will NOT be transitively included in any project that depends on yours.

## How Optional Dependencies Work in a Dependency Hierarchy ?

### **Example – A Library with Optional Dependencies**

Imagine we have **Project A** and **Project B**.

* **Project A** depends on **Library X**.
* **Library X** has **Library Y** as an **optional dependency**.

**Project A's `pom.xml`**

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>library-x</artifactId>
    <version>1.0.0</version>
</dependency>
```

{% hint style="warning" %}
**Question: Will Project A get Library Y?**\
**No!** Since Library Y is marked as **optional**, Maven will NOT include it automatically.
{% endhint %}

**If Project A wants Library Y, it must explicitly add it:**

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>library-y</artifactId>
    <version>1.0.0</version>
</dependency>
```

This gives **Project A full control** over whether to include **Library Y**.
