# Covariance and Invariance

## **About**

Covariance and invariance are concepts in type systems that describe how types relate to each other in the context of inheritance or generic typing.

## **Covariance**

Covariance allows a child type (`Subclass`) to be used where a parent type (`Superclass`) is expected. It maintains the **"is-a" relationship**.

### **Example: Covariance in Arrays**

In Java, arrays are covariant. This means an array of a subtype can be assigned to an array of its supertype.

```
String[] strings = {"one", "two"};
Object[] objects = strings; // Allowed due to covariance
```

**Potential Runtime Exceptions:** While covariance allows this assignment, it is unsafe:

```
Object[] objects = strings;
objects[0] = 10; // ArrayStoreException at runtime
```

**Why?** At runtime, the JVM enforces that the array actually contains `String` elements.

### **Covariance in Generics**

Generics in Java support covariance using **wildcards (`? extends T`)**.

```
List<? extends Number> numbers = new ArrayList<Integer>();
```

* `? extends Number` means "a list of some subtype of `Number`".
* We can read elements as `Number`, but we **cannot add elements**, as the exact subtype is unknown.

## **Invariance**

Invariance means that a type and its subtypes are **not interchangeable**. This is stricter than covariance.

**Example: Invariance in Generics**

In Java, generic types are invariant. This means a `List<String>` is **not a subtype** of `List<Object>`, even though `String` is a subtype of `Object`.

```
List<String> strings = new ArrayList<>();
List<Object> objects = strings; // Compilation error: incompatible types
```

**Why?** If this were allowed, it would break type safety:

```
List<Object> objects = new ArrayList<String>();
objects.add(10); // Violates the type safety of `String` elements.
```

## **Comparison Table**

<table data-header-hidden data-full-width="true"><thead><tr><th width="163"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Covariant</strong></td><td><strong>Invariant</strong></td></tr><tr><td><strong>Definition</strong></td><td>Subtypes can be used where supertypes are expected.</td><td>Types are not interchangeable, even with subtyping.</td></tr><tr><td><strong>Example</strong></td><td><code>String[]</code> can be assigned to <code>Object[]</code>.</td><td><code>List&#x3C;String></code> cannot be assigned to <code>List&#x3C;Object></code>.</td></tr><tr><td><strong>Flexibility</strong></td><td>More flexible but less type-safe.</td><td>Stricter but safer.</td></tr><tr><td><strong>Usage in Java</strong></td><td>Arrays (<code>T[]</code>) are covariant.</td><td>Generics (<code>List&#x3C;T></code>) are invariant.</td></tr></tbody></table>
