# Equals and HashCode

## `equals` Method

### **Purpose**

* The `equals` method is used to check for logical equality between two objects, not reference equality.
* By default, `equals` in the `Object` class checks if two references point to the same memory address (`this == obj`).

### **Overriding `equals`**

When overriding `equals`, it’s essential to ensure that it satisfies certain properties:

* **Reflexive**: For any non-null reference `x`, `x.equals(x)` should return `true`.
* **Symmetric**: For any non-null references `x` and `y`, `x.equals(y)` should return `true` if and only if `y.equals(x)` is `true`.
* **Transitive**: For any non-null references `x`, `y`, and `z`, if `x.equals(y)` is `true` and `y.equals(z)` is `true`, then `x.equals(z)` should be `true`.
* **Consistent**: Multiple calls to `x.equals(y)` should consistently return `true` or `false`, provided that no fields used in the comparison are modified.
* **Non-null**: For any non-null reference `x`, `x.equals(null)` should return `false`.

### **Implementing `equals`**

A typical `equals` implementation in Java involves the following steps:

1. **Reference Check**: Return `true` if the references are identical (`this == obj`).
2. **Null Check**: Return `false` if the object is null.
3. **Class Check**: Return `false` if the classes differ, ensuring `equals` works only within the same class.
4. **Cast and Field Comparison**: Cast the object to the correct type, then compare fields.

Example:

```java
public class Person {
    private String name;
    private int age;

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Person person = (Person) o;
        return age == person.age && Objects.equals(name, person.name);
    }
}
```

## `hashCode` Method

### **Purpose**

* The `hashCode` method returns an integer hash code that represents the object’s address in memory (default behavior) or a calculated value based on its fields.
* Hash-based collections like `HashMap` and `HashSet` rely on `hashCode` for quickly locating and storing objects.

### **`hashCode` Contract**

When overriding `equals`, we **must also override `hashCode`** to maintain consistency in hash-based collections. The `hashCode` contract states:

* **If two objects are equal according to `equals`, they must return the same `hashCode`.**
* **If two objects are not equal, their `hashCode` can be the same or different.**

**Implementing `hashCode`**

* A good `hashCode` function should evenly distribute hash codes across the hash table to minimize collisions.
* Use prime numbers in hash code calculations, such as `31`, to reduce hash collisions and improve distribution.

{% hint style="info" %}
**Auto-Generated `equals` and `hashCode`**

Modern IDEs (like IntelliJ and Eclipse) can auto-generate `equals` and `hashCode` based on fields we select. This reduces the chance of errors and ensures a correct initial implementation.

**Libraries (Lombok)**

Lombok’s `@EqualsAndHashCode` annotation can automatically generate `equals` and `hashCode`, helping simplify our code.

```java
import lombok.EqualsAndHashCode;

@EqualsAndHashCode
public class Person {
    private String name;
    private int age;
}
```
{% endhint %}



Here’s a basic implementation using `name` and `age`:

```java
@Override
public int hashCode() {
    return Objects.hash(name, age); // Generates a hash code for a sequence of input values. The hash code is generated as if all the input values were placed into an array, and that array were hashed by calling Arrays. hashCode(Object[]
}
```

Or manually:

```java
@Override
public int hashCode() {
    int result = 17; // Non-zero constant
    result = 31 * result + (name != null ? name.hashCode() : 0);
    result = 31 * result + age;
    return result;
}
```

## Using `equals` and `hashCode` in Collections

* **Hash-based Collections**: Collections like `HashMap`, `HashSet`, and `Hashtable` use `hashCode` for efficient storage and retrieval.
  * **Example**: When we add an object to a `HashSet`, its `hashCode` determines the bucket it’s placed in. `equals`checks if an object with the same key already exists.
  * **Collisions**: If two objects have the same `hashCode` but aren’t equal, they’re stored in the same bucket (collision), and `equals` checks help identify distinct objects within the bucket.

{% hint style="info" %}
**HashSet**: `HashSet` uses `hashCode` to place objects in buckets. When checking for duplicates, it first checks `hashCode` to locate the bucket, then uses `equals` to confirm object equality within the bucket.

**HashMap**: In `HashMap`, the `hashCode` of the key is used to locate the correct bucket. Within the bucket, `equals` is used to find the exact key.
{% endhint %}



{% hint style="info" %}
**Mutable Fields**

* Using mutable fields in `equals` and `hashCode` is risky. If a field changes, the object’s `hashCode` will change, making it “disappear” from collections like `HashMap` or `HashSet`.
* Solution: Use immutable fields in your `equals` and `hashCode` implementations. If this isn’t possible, avoid modifying fields while the object is in a hash-based collection.

**Consistency in Subclasses**

* If `equals` and `hashCode` are overridden in a subclass, you risk breaking symmetry if both subclass and superclass instances are compared.
* Solution: If a class hierarchy uses `equals` and `hashCode`, consider marking `equals` as `final` or using delegation.
{% endhint %}

## **Custom Hashing Strategies**

For advanced scenarios where default hash code algorithms don’t perform well, we can use custom hashing strategies or external libraries like Google Guava’s `Hashing` class, especially for complex objects.

**Effective Use in Large Hash-Based Collections**

To optimize performance in large collections:

* Ensure a balanced distribution by selecting fields that offer a unique representation of the object.
* Benchmark and analyze hash collisions if the collection is very large or performance-sensitive.

## Testing `equals` and `hashCode`

Testing `equals` and `hashCode` helps ensure correctness. Here’s how to test them:

* **Equality Tests**: Check that `equals` adheres to reflexive, symmetric, and transitive properties.
* **Hash Code Consistency**: Verify that equal objects have the same hash code.
* **Non-equality**: Ensure that different objects or objects with different values in significant fields return `false` for `equals` and have different hash codes.

```java
import java.util.Objects;

public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Person person = (Person) o;
        return age == person.age && Objects.equals(name, person.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }
}
```

{% hint style="success" %}
Pom dependency for test framework

```
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter-engine</artifactId>
    <scope>test</scope>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
```
{% endhint %}

```java
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

import org.junit.jupiter.api.Test;
import test.Person;

class PersonTest {

    @Test
    void testEqualsAndHashCode() {
        Person p1 = new Person("John", 25);
        Person p2 = new Person("John", 25);
        Person p3 = new Person("Doe", 30);

        assertEquals(p1, p2);
        assertEquals(p1.hashCode(), p2.hashCode());

        assertNotEquals(p1, p3);
        assertNotEquals(p1.hashCode(), p3.hashCode());
    }
}
```

## Best Practices

1. Always override `hashCode` when we override `equals`.
2. Use immutable fields in `equals` and `hashCode` whenever possible.
3. Avoid using transient or derived fields (fields that change frequently or aren’t part of the core identity of the object).
4. Use IDE auto-generation or Lombok annotations to simplify correct implementation.
5. Test `equals` and `hashCode` to confirm they fulfill their contracts.

## Additional Info

{% content-ref url="../../../concepts/set-4/comparison-and-ordering/object-equality-check.md" %}
[object-equality-check.md](../../../concepts/set-4/comparison-and-ordering/object-equality-check.md)
{% endcontent-ref %}

