---
description: Overview of meta-annotation in Java.
---

# Meta Annotation

## About

In Java, **meta-annotations** are annotations **that apply to other annotations**. They define how custom annotations behave and are an essential part of building a clean, consistent annotation-based system in any Java application or framework.

Just like classes can be described by annotations, annotations themselves can also be described—this is what meta-annotations are for.

## Why Meta-Annotations?

When creating **custom annotations**, we often need to define:

* Where it can be applied (e.g., on methods, classes, fields)
* How long it should be retained (e.g., only in source code or also at runtime)
* Whether it should be inherited
* Whether it can be repeated
* Whether it should appear in the generated Javadocs

These aspects are controlled using **meta-annotations**.

## Available Meta-Annotations in Java

Java provides five core meta-annotations in the `java.lang.annotation` package

<table><thead><tr><th width="141.14404296875">Meta-Annotation</th><th>Description</th></tr></thead><tbody><tr><td><code>@Target</code></td><td>Specifies where the annotation can be applied.</td></tr><tr><td><code>@Retention</code></td><td>Defines how long the annotation is retained (source, class, or runtime).</td></tr><tr><td><code>@Inherited</code></td><td>Allows the annotation to be inherited by subclasses.</td></tr><tr><td><code>@Documented</code></td><td>Marks the annotation to be included in Javadocs.</td></tr><tr><td><code>@Repeatable</code></td><td>Allows an annotation to be applied multiple times to the same element.</td></tr></tbody></table>

### `@Target`

Specifies the **valid locations** (or elements) where the annotation can be used, such as methods, fields, constructors, parameters, etc.

```java
@Target(ElementType.METHOD)
public @interface MyAnnotation {}
```

#### Possible `ElementType` values

<table><thead><tr><th width="269.9288330078125">ElementType</th><th>Description</th></tr></thead><tbody><tr><td><code>TYPE</code></td><td>Class, interface, or enum</td></tr><tr><td><code>FIELD</code></td><td>Fields (instance variables)</td></tr><tr><td><code>METHOD</code></td><td>Methods</td></tr><tr><td><code>PARAMETER</code></td><td>Method parameters</td></tr><tr><td><code>CONSTRUCTOR</code></td><td>Constructors</td></tr><tr><td><code>LOCAL_VARIABLE</code></td><td>Local variables inside methods</td></tr><tr><td><code>ANNOTATION_TYPE</code></td><td>Other annotations</td></tr><tr><td><code>PACKAGE</code></td><td>Java packages</td></tr><tr><td><code>TYPE_USE</code></td><td>Any use of a type (generics, casts, etc.)</td></tr><tr><td><code>MODULE</code></td><td>Java 9 modules</td></tr></tbody></table>

#### Example

```java
@Target({ElementType.METHOD, ElementType.TYPE})
public @interface AuditLog {}
```

### `@Retention`

Defines **how long** the annotation is retained in the program lifecycle.

```java
@Retention(RetentionPolicy.RUNTIME)
public @interface Loggable {}
```

#### Retention policies

<table><thead><tr><th width="154.28643798828125">Policy</th><th>Description</th></tr></thead><tbody><tr><td><code>SOURCE</code></td><td>Available only in source code. Removed during compilation.</td></tr><tr><td><code>CLASS</code></td><td>Present in the <code>.class</code> file but not accessible at runtime via reflection.</td></tr><tr><td><code>RUNTIME</code></td><td>Present in the <code>.class</code> file and available via reflection at runtime.</td></tr></tbody></table>

#### Example

```java
@Retention(RetentionPolicy.CLASS)
public @interface CompileOnly {}
```

### `@Inherited`

Specifies that **if a class is annotated**, then its **subclasses will automatically inherit the annotation**.

> Note: This only applies to class-level annotations, not methods or fields.

```java
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Secured {}

@Secured
public class BaseService {}

public class UserService extends BaseService {}
```

Here, `UserService` will be treated as if it has `@Secured` even though it is not explicitly annotated.

### `@Documented`

Indicates that the annotation should be included in the **generated Javadoc**.

Without this, annotations are not visible in Javadoc output by default.

```java
@Documented
@Target(ElementType.METHOD)
public @interface DeveloperNote {
    String value();
}
```

### `@Repeatable`

Allows the same annotation to be used **multiple times** on the same element.

Prior to Java 8, an annotation could be applied only once on a target.

#### How it works ?

We must define a **container annotation** to hold the repeated annotations.

```java
// Repeatable annotation
@Repeatable(Schedules.class)
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Schedule {
    String day();
}

// Container annotation
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Schedules {
    Schedule[] value();
}
```

Usage

```java
@Schedule(day = "Monday")
@Schedule(day = "Friday")
public void generateReport() {}
```

{% hint style="warning" %}
With Repeatable, we can apply the same annotation **multiple times** to the same element. Java will group these annotations into a container annotation (which we define). We (or the framework we use) are responsible for checking all the annotations and acting on them.



If we want some logic to execute based on each annotation, **we must write code to loop through the annotations**:

```java
Method method = MyClass.class.getMethod("generateReport");
Schedule[] schedules = method.getAnnotationsByType(Schedule.class);

for (Schedule schedule : schedules) {
    System.out.println("Execute logic for: " + schedule.day());
}
```
{% endhint %}
