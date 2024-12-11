# Primitive Types

## About

Primitive types are the most basic data types in Java, directly supported by the language. They represent simple values rather than objects and are stored in stack memory for efficient access. Java provides eight primitive types, grouped based on the kind of data they represent.

Java's primitive types are categorized as follows:

<table data-header-hidden data-full-width="true"><thead><tr><th width="153"></th><th width="121"></th><th width="166"></th><th width="155"></th><th></th></tr></thead><tbody><tr><td><strong>Category</strong></td><td><strong>Type</strong></td><td><strong>Size</strong></td><td><strong>Default Value</strong></td><td><strong>Examples</strong></td></tr><tr><td><strong>Integer Types</strong></td><td><code>byte</code></td><td>1 byte (8 bits)</td><td>0</td><td><code>-128</code> to <code>127</code></td></tr><tr><td></td><td><code>short</code></td><td>2 bytes (16 bits)</td><td>0</td><td><code>-32,768</code> to <code>32,767</code></td></tr><tr><td></td><td><code>int</code></td><td>4 bytes (32 bits)</td><td>0</td><td><code>-2^31</code> to <code>(2^31)-1</code></td></tr><tr><td></td><td><code>long</code></td><td>8 bytes (64 bits)</td><td>0L</td><td><code>-2^63</code> to <code>(2^63)-1</code></td></tr><tr><td><strong>Floating Point</strong></td><td><code>float</code></td><td>4 bytes (32 bits)</td><td>0.0f</td><td><code>3.40282347e+38</code></td></tr><tr><td></td><td><code>double</code></td><td>8 bytes (64 bits)</td><td>0.0</td><td><code>1.79769313486231570e+308</code></td></tr><tr><td><strong>Character</strong></td><td><code>char</code></td><td>2 bytes (16 bits)</td><td>'\u0000'</td><td>Unicode characters (e.g., 'A')</td></tr><tr><td><strong>Boolean</strong></td><td><code>boolean</code></td><td>1 bit</td><td><code>false</code></td><td><code>true</code> or <code>false</code></td></tr></tbody></table>

## **Characteristics of Primitive Types**

1. **Memory Efficiency**: Stored in stack memory, primitives are lightweight and fast to access.
2. **Immutable**: Values of primitive types cannot be changed after initialization.
3. **No Methods**: Unlike objects, primitives do not have associated methods (e.g., `int` cannot call `.toString()`directly).
4. **Default Values**:
   * For instance variables, primitives are initialized to their default values.
   * For local variables, explicit initialization is required; otherwise, the compiler throws an error.

## **Type Conversion and Promotion**

### **Implicit Conversion**

* Smaller types (e.g., `byte`, `short`) are automatically converted to larger types (`int`, `long`, `float`, or `double`).
*   Example:

    ```java
    int num = 100;
    double d = num; // Implicit widening
    ```

### **Explicit Conversion (Casting)**

* Larger types must be explicitly cast to smaller types, which may result in loss of precision.
*   Example:

    ```java
    double d = 100.99;
    int num = (int) d; // Explicit narrowing
    ```

## **Wrapper Classes**

Each primitive type has a corresponding wrapper class in `java.lang` to provide object-like behavior. Examples include:

* `int -> Integer`
* `double -> Double`
* `boolean -> Boolean`
* `char -> Character`
* `long -> Long`
* `byte -> Byte`
* `short -> Short`

Wrapper classes are used in:

* Collections (e.g., `ArrayList<Integer>`)
* Autoboxing and Unboxing

## **Best Practices**

1. Use primitives for performance-critical applications.
2. Use wrapper classes when working with collections or requiring nullability.
3. Choose the appropriate type based on memory and precision requirements.

## **Common Use Cases**

1. **Counters and Indices**: `int` is often used in loops.
2. **Flags**: `boolean` variables for control flow.
3. **Numeric Calculations**: `float` and `double` for mathematical operations.
