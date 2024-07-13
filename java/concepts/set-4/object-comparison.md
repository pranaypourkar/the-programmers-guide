# Object Comparison

## About

Object comparison in Java refers to the process of determining whether two objects are considered equal or not based on specific criteria. Comparing two objects in Java can be approached differently depending on the type of objects being compared.

1. **Equality**:
   * **Reference Equality (`==`)**: Compares whether two references point to the same memory address.
   * **Value Equality (`equals()`)**: Compares whether the internal state or content of two objects is the same.
2. **Methods for Comparison**:
   * **`==` Operator**: Tests reference equality, i.e., whether two references point to the same object instance in memory.
   * **`equals()` Method**: Tests value equality, which compares the contents or state of two objects. By default, the `equals()` method in Java checks for reference equality (same as `==`), but it can be overridden in custom classes to compare based on object contents.
3. **Implementing `equals()` Method**:
   * When implementing the `equals()` method in a custom class, it's important to override it to provide a meaningful comparison based on the properties (fields) of the class.
   * The `equals()` method should adhere to the following principles:
     * **Reflexive**: `x.equals(x)` should always return true.
     * **Symmetric**: If `x.equals(y)` returns true, then `y.equals(x)` should also return true.
     * **Transitive**: If `x.equals(y)` and `y.equals(z)` both return true, then `x.equals(z)` should also return true.
     * **Consistent**: Repeatedly calling `x.equals(y)` should consistently return true or consistently return false, provided that the objects are not modified.
     * **Null Comparison**: `x.equals(null)` should return false.
4. **Comparison Strategies**:
   * **Primitive Types**: Compared using their respective `==` operators for value comparison.
   * **Wrapper Classes**: Compared using `equals()` for value comparison.
   * **String**: Compared using `equals()` for content comparison.
   * **Arrays**: Compared using `Arrays.equals()` or `Arrays.deepEquals()` for content comparison.
   * **Collections (`List`, `Set`, `Map`)**: Compared using `equals()` for content comparison.
   * **Custom Objects**: Implement `equals()` and `hashCode()` methods for meaningful comparison based on object properties.

## 1. `Object` Superclass

Every class in Java implicitly inherits from the `Object` class, which provides the basic methods for comparison: `equals()` and `==`.

* **`==` Operator**: Checks for reference equality, i.e., whether two references point to the same object in memory.
* **`equals()` Method**: Checks for value equality. By default, it behaves like the `==` operator (reference equality), but it can be overridden in custom classes to provide meaningful value comparison.

#### Example

```java
Object obj1 = new Object();
Object obj2 = new Object();

System.out.println(obj1 == obj2); // false, different references
System.out.println(obj1.equals(obj2)); // false, different objects (default behavior)
```

## 2. Primitive Types

Primitive types in Java are the most basic data types and they directly hold the values. They are not objects and are stored in the stack memory, which makes them fast and efficient.

<table data-header-hidden data-full-width="true"><thead><tr><th width="126"></th><th width="142"></th><th width="114"></th><th width="136"></th><th></th></tr></thead><tbody><tr><td>Primitive Type</td><td>Description</td><td>Size (bits)</td><td>Default Value</td><td>Example Comparison Using <code>==</code></td></tr><tr><td><code>byte</code></td><td>8-bit integer</td><td>8</td><td><code>0</code></td><td><code>byte a = 1; byte b = 1; System.out.println(a == b); // true</code></td></tr><tr><td><code>short</code></td><td>16-bit integer</td><td>16</td><td><code>0</code></td><td><p><code>short a = 1; short b = 1;</code></p><p><code>System.out.println(a == b); // true</code></p></td></tr><tr><td><code>int</code></td><td>32-bit integer</td><td>32</td><td><code>0</code></td><td><p><code>int a = 1; int b = 1;</code> </p><p><code>System.out.println(a == b); // true</code></p></td></tr><tr><td><code>long</code></td><td>64-bit integer</td><td>64</td><td><code>0L</code></td><td><code>long a = 1L; long b = 1L; System.out.println(a == b); // true</code></td></tr><tr><td><code>float</code></td><td>32-bit floating point</td><td>32</td><td><code>0.0f</code></td><td><code>float a = 1.0f; float b = 1.0f; System.out.println(a == b); // true</code></td></tr><tr><td><code>double</code></td><td>64-bit floating point</td><td>64</td><td><code>0.0d</code></td><td><code>double a = 1.0; double b = 1.0; System.out.println(a == b); // true</code></td></tr><tr><td><code>char</code></td><td>16-bit Unicode</td><td>16</td><td><code>\u0000</code></td><td><code>char a = 'a'; char b = 'a'; System.out.println(a == b); // true</code></td></tr><tr><td><code>boolean</code></td><td>true/false</td><td>1</td><td><code>false</code></td><td><code>boolean a = true; boolean b = true; System.out.println(a == b); // true</code></td></tr></tbody></table>





