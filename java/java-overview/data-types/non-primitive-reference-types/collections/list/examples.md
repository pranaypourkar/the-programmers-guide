# Examples

## 1. Return a list from a single object

{% hint style="info" %}
**Immutability**:\
An **immutable list** is a list whose **contents cannot be changed** after it is created.

* We **cannot add, remove, or modify** elements.
* Examples: `List.of()`, `Collections.singletonList()`

**Mutability**:\
A **mutable list** is a list we **can modify**.

* We **can add, remove, or update** elements.
* Examples: `new ArrayList<>()`, `Arrays.asList()` (partially mutable)
{% endhint %}

**Option 1:** Using `Collections.singletonList(product)`

Returns an **immutable** list containing exactly one element.

```
Product product = new Product();
List<Product> list = Collections.singletonList(product);
```

**Option 2:** Using `List.of(product)` (Java 9+)

Returns an **immutable list** with the given element(s).

```
List<Product> list = List.of(product);
```

**Option 3**: Using `Arrays.asList(product)`&#x20;

Returns a **mutable fixed-size list** backed by an array.

```
List<Product> list = Arrays.asList(product);
```

**Option 4**: Using `new ArrayList<>(List.of(product))` (Java 9+)

Creates a **mutable list** with one element.

```java
List<Product> list = new ArrayList<>(List.of(product));
```

**Option 5**: Using `new ArrayList<>(Collections.singletonList(product))`

Similar to above, but compatible with Java 8. Useful if we are working in Java 8 but want a **mutable** list.

```java
List<Product> list = new ArrayList<>(Collections.singletonList(product));
```

#### Recommended Approach

* If we want **immutability**, prefer `Collections.singletonList()` or `List.of()`.
* If we want a **modifiable list**, wrap it in `new ArrayList<>()`.





