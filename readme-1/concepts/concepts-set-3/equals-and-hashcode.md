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





