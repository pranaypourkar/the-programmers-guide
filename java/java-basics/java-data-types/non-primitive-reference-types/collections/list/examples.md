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

## 2. UnsupportedOperationException or NullPointerException when adding element

When working with `List` in Java, especially when calling `add()` on a list retrieved via a getter method, we might encounter the following issues:

**Scenario**

```java
productGroup.getCustomProducts().add(userAccounts.getCurrentAccount());
```

Even though `productGroup` is not null, this line can throw either:

* `NullPointerException`
* `UnsupportedOperationException`

#### **Root Causes**

**1. List is null**

If the list is not initialized, calling `add()` will throw a `NullPointerException`.

**Example:**

```java
private List<Product> customProducts; // not initialized
```

**2. List is immutable**

If the list is initialized using one of the following:

* `Collections.emptyList()`
* `List.of(...)` (Java 9+)
* `Collections.unmodifiableList(...)`

Then calling `add()` will throw an `UnsupportedOperationException`.

#### **Solutions**

**Ensure the list is initialized and modifiable**

**Option 1: Initialize in the class**

```java
private List<Product> customProducts = new ArrayList<>();
```

**Option 2: Lazily initialize before use**

```java
if (productGroup.getCustomProducts() == null) {
    productGroup.setCustomProducts(new ArrayList<>());
}
productGroup.getCustomProducts().add(userAccounts.getLoyaltyAccount());
```

**Option 3: Create a modifiable copy if the list is unmodifiable**

```java
List<Product> modifiableList = new ArrayList<>(productGroup.getCustomProducts());
modifiableList.add(userAccounts.getLoyaltyAccount());
productGroup.setCustomProducts(modifiableList);
```



