# float

## About

* **Definition:** The `float` data type is a primitive data type in Java used to represent a 32-bit single-precision floating-point number. It is mainly used for saving memory in large arrays of floating-point numbers where precision is not a critical concern.
* **Size:** Occupies **4 bytes** (32 bits) in memory.
* **Value Range:** Approximately `1.4E-45` to `3.4E+38` for positive values (from `-3.4E+38` to `3.4E+38` for negative and positive values combined), with about 6-7 decimal digits of precision.
* **Default Value:** The default value of `float` is `0.0f`.
* **Wrapper Class:** The wrapper class for `float` is `Float`, located in `java.lang`.

## **Characteristics of `float`**

1. **Floating-Point Representation:** `float` is used to represent numbers that require fractional values but where memory efficiency is a concern.
2. **Memory Usage:** It consumes **4 bytes (32 bits)** of memory, which is smaller than `double`, which uses **8 bytes** (64 bits).
3. **Precision:** `float` has a precision of about **6-7 decimal places**, which is less than `double`, which can represent up to **15 decimal places**. It is suitable when precise accuracy is not crucial.
4. **Scientific Notation:** `float` values can be represented in scientific notation, such as `3.14e2`, which represents `314.0`.
5. **IEEE 754 Standard:** `float` in Java follows the IEEE 754 standard for floating-point arithmetic. It includes special values like `NaN`(Not-a-Number), `Infinity`, and `-Infinity`.
6. **Promotion in Expressions:** If a `float` is mixed with a `double`, the `float` is promoted to a `double` in arithmetic expressions, as `double`has a larger range and higher precision.
7. **Performance Considerations:** `float` is generally faster and uses less memory compared to `double`, but its lower precision may result in rounding errors in calculations.
8. **Avoiding Precision Loss:** For calculations requiring higher precision, `double` is often preferred over `float`. But for memory-constrained applications (e.g., graphics, scientific calculations), `float` is useful.
9. **Memory Usage:** A `float` occupies **4 bytes** (32 bits). This is smaller compared to `double`'s 8 bytes, making `float` more memory-efficient.

## **Operations with `float`**

### **Arithmetic and Logical Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="258"></th><th width="295"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>float sum = a + b;</code></td><td>Addition, subtraction, multiplication, division.</td></tr><tr><td>Comparison Operations</td><td><code>a == b</code>, <code>a > b</code>, etc.</td><td>Compares two <code>float</code> values.</td></tr><tr><td>Bitwise Operations</td><td>Not supported directly on <code>float</code></td><td><code>float</code> does not support bitwise operators like <code>&#x26;</code>, `</td></tr></tbody></table>

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="221"></th><th width="294"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>float</code> to <code>String</code></td><td><code>String.valueOf(float)</code></td><td><code>String.valueOf(12.34f)</code> → <code>"12.34"</code></td></tr><tr><td><code>String</code> to <code>float</code></td><td><code>Float.parseFloat(String)</code></td><td><code>Float.parseFloat("12.34")</code> → <code>12.34f</code></td></tr><tr><td><code>float</code> to <code>double</code></td><td>Implicit conversion</td><td><code>double result = 12.34f;</code></td></tr><tr><td><code>double</code> to <code>float</code></td><td>Explicit cast <code>(float)</code></td><td><code>(float) 12.34</code> → <code>12.34f</code></td></tr></tbody></table>

### **Wrapper Class Example (`Float`)**

<table data-header-hidden data-full-width="true"><thead><tr><th width="358"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Float.valueOf(float f)</code></td><td>Returns a <code>Float</code> object for the given <code>float</code> value.</td></tr><tr><td><code>Float.parseFloat(String s)</code></td><td>Parses the string argument as a <code>float</code>.</td></tr><tr><td><code>Float.toString(float f)</code></td><td>Converts <code>float</code> to its <code>String</code> representation.</td></tr><tr><td><code>Float.isNaN(float f)</code></td><td>Checks if the <code>float</code> value is <code>NaN</code>.</td></tr><tr><td><code>Float.isInfinite(float f)</code></td><td>Checks if the <code>float</code> value is positive or negative infinity.</td></tr></tbody></table>

## **Common Mistakes**

1.  **Loss of Precision:** Since `float` has only about 6-7 decimal digits of precision, rounding errors can occur in calculations that require higher precision. For example:

    ```java
    float num1 = 0.1f;
    float num2 = 0.2f;
    System.out.println(num1 + num2); // Output might not be exactly 0.3
    ```
2. **Mixing with `double`:** `float` values are automatically promoted to `double` in expressions that involve both `float` and `double`. This could result in unnecessary memory usage or unexpected results if not carefully managed.
3.  **Comparison with `NaN`:** `NaN` (Not a Number) is not equal to any number, including itself. So, comparing `NaN` to any value directly may not behave as expected:

    ```java
    float nanValue = Float.NaN;
    System.out.println(nanValue == nanValue); // Output: false
    ```

## Examples

### **Basic Example**

```java
public class FloatExample {
    public static void main(String[] args) {
        float num1 = 10.5f;
        float num2 = 20.25f;

        // Arithmetic operations
        float sum = num1 + num2; 
        System.out.println("Sum: " + sum); // Sum: 30.75

        // Comparing values
        System.out.println("Is num1 greater than num2? " + (num1 > num2)); // Is num1 greater than num2? false

        // Casting
        int smallerValue = (int) num1; // Cast float to int
        System.out.println("Casted Value: " + smallerValue); // Casted Value: 10
    }
}
```

### **Using `float` in Arrays**

```java
public class FloatArrayExample {
    public static void main(String[] args) {
        float[] floatArray = {10.5f, 20.25f, 30.75f};

        for (float value : floatArray) {
            System.out.println(value); // 10.5, 20.25, 30.75
        }
    }
}
```

### **Converting `float` to `String`**

```java
public class FloatConversion {
    public static void main(String[] args) {
        float num = 12.34f;
        String str = Float.toString(num); 
        System.out.println("Float as String: " + str); // Float as String: 12.34
    }
}
```

### **Using `float` in Streams**

```java
import java.util.stream.FloatStream;

public class FloatStreamExample {
    public static void main(String[] args) {
        float[] values = {1.2f, 3.4f, 5.6f, 7.8f};

        float average = FloatStream.of(values)
                                   .average()
                                   .orElse(0.0f);

        System.out.println("Average: " + average); // Average: 4.5
    }
}
```

### **Wrapper Class Example**

```java
public class FloatWrapperExample {
    public static void main(String[] args) {
        String strValue = "12.34";
        float parsedValue = Float.parseFloat(strValue); 
        System.out.println("Parsed Value: " + parsedValue); // Parsed Value: 12.34

        float minValue = Float.MIN_VALUE; 
        float maxValue = Float.MAX_VALUE; 
        System.out.println("Min Value: " + minValue); // Min Value: 1.4E-45
        System.out.println("Max Value: " + maxValue); // Max Value: 3.4028235E38
    }
}
```
