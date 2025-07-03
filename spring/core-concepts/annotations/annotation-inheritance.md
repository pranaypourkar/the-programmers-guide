# Annotation Inheritance

## About

Annotation inheritance refers to the **ability of a subclass or implementing class to inherit annotations** declared on its superclass or interface.

In Java, annotation inheritance **does not occur by default**. That means, if a superclass has an annotation, the subclass **does not automatically inherit** that annotation **unless the annotation itself is explicitly marked as inheritable** using the `@Inherited` meta-annotation.

This concept is crucial when working with annotations in frameworks like **Spring**, where many behaviors are driven by reflection and annotations.

## `@Inherited` Meta-Annotation

`@Inherited` is a **meta-annotation** (an annotation applied to another annotation) provided by Java in the `java.lang.annotation` package.

```java
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface MyCustomAnnotation {}
```

When an annotation is marked with `@Inherited`, and it is applied to a **class**, then **subclasses** of that class will automatically **inherit the annotation**.

## Constraints of `@Inherited`

1. **Only works for class-level annotations** (`ElementType.TYPE`).\
   It does **not** apply to annotations on methods, fields, constructors, or parameters.
2. **Only applies to inheritance via class extension**, not via interfaces.
3. The inheritance is only visible **via reflection** using `Class.getAnnotations()` — not `getDeclaredAnnotations()`.

## Example: Inheriting a Custom Annotation

#### Step 1: Define an Inheritable Annotation

```java
import java.lang.annotation.*;

@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Auditable {}
```

#### Step 2: Apply it to a Base Class

```java
@Auditable
public class BaseEntity {}
```

#### Step 3: Extend the Base Class

```java
public class User extends BaseEntity {}
```

#### Step 4: Access via Reflection

```java
System.out.println(User.class.isAnnotationPresent(Auditable.class)); // true
```

Without `@Inherited`, the result would be `false`.

### What if `@Inherited` Is Missing?

If `@Inherited` is **not** used, the subclass **does not see the annotation** via standard Java reflection.

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface NonInheritedMarker {}

@NonInheritedMarker
public class Parent {}

public class Child extends Parent {}
```

```java
System.out.println(Child.class.isAnnotationPresent(NonInheritedMarker.class)); // false
```

## Annotation Inheritance in Spring

Spring makes extensive use of reflection and annotations, and **it respects Java’s `@Inherited` rules** for class-level annotations.

However, Spring also often uses **custom logic** to detect annotations on superclasses, interfaces, and meta-annotations — which sometimes goes beyond plain Java reflection.

#### Examples in Spring:

1. **`@Transactional` is `@Inherited`**\
   This allows subclasses to inherit transactional behavior if the base class is annotated with `@Transactional`.
2. **`@Component` is not `@Inherited`**\
   Subclasses do not inherit `@Component` — you must annotate each class explicitly if you want them to be picked up by component scanning.

### Misconception: Method-Level Inheritance

Annotations on methods are **never inherited automatically**, even if the annotation is marked with `@Inherited`.

For example:

```java
public class Base {
    @MyMethodAnnotation
    public void process() {}
}

public class Child extends Base {
    @Override
    public void process() {}
}
```

The overridden `process()` method in `Child` does **not inherit** `@MyMethodAnnotation`.

If you want annotation behavior to apply to the subclass’s method, you must **re-declare the annotation** explicitly on the overridden method.

## Subclass of a test class like `BaseIT` **doesn't need to redeclare annotations such as** `@SpringBootTest`

A subclass of a test class like `BaseIT` **doesn't need to redeclare annotations such as** `@SpringBootTest`, `@Testcontainers`, or `@ActiveProfiles` — **even though many of those annotations are not marked with Java’s `@Inherited`**.

This works due to how **Spring TestContext Framework** and **JUnit** handle annotations in test classes.

#### Example

```java
@ActiveProfiles("it")
@Testcontainers
@SpringBootTest(webEnvironment = RANDOM_PORT)
public class BaseIT {
}
```

```java
public class UserApiIT extends BaseIT {
    // No annotations here, still works!
}
```

Even though annotations like `@SpringBootTest` are not marked `@Inherited`, `UserApiIT` still **inherits** the configuration behavior.

#### **JUnit + Spring TestContext Framework Use Meta-Reflection**

Spring's `TestContextManager` does **custom recursive introspection** to detect annotations on:

* The test class
* Its superclasses
* Meta-annotations
* Interfaces (for some cases)

Unlike Java's basic `Class.getAnnotations()`, Spring uses deeper resolution strategies such as:

```java
AnnotationUtils.findAnnotation(Class<?> clazz, Class<A> annotationType)
```

This method traverses up the class hierarchy and also checks for meta-annotations, not just what's directly present.

#### 2. **Spring Boot’s `@SpringBootTest`, `@ActiveProfiles`, etc.**

* These are **test configuration annotations**.
* Spring intentionally **resolves them from superclasses** to support reusable test base classes.

So even though annotations like:

* `@SpringBootTest`
* `@Testcontainers`
* `@ActiveProfiles`

are **not** `@Inherited`, Spring still detects and uses them.

{% hint style="info" %}
This behavior is **not the same in production code** — in our application (non-test classes), if we want annotation inheritance, only those with `@Inherited` and applied on `@Target(TYPE)` will behave that way.
{% endhint %}
