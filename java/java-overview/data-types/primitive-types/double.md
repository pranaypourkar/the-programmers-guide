# double

## About

* **Definition:** The `double` data type is a primitive data type in Java used to represent double-precision floating-point numbers. It provides a larger range and higher precision than `float` and is commonly used for calculations that require higher accuracy, such as scientific computations.
* **Size:** Occupies **8 bytes** (64 bits) in memory.
* **Value Range:** From approximately `4.9E-324` to `1.8E+308` for positive values (from `-1.8E+308` to `1.8E+308` for negative and positive values combined), with about **15 decimal digits of precision**.
* **Default Value:** The default value of `double` is `0.0d`.
* **Wrapper Class:** The wrapper class for `double` is `Double`, located in `java.lang`.

## **Characteristics of `double`**

1. **Floating-Point Representation:** `double` is used to represent numbers that require fractional values with a high level of precision.
2. **Memory Usage:** It occupies **8 bytes (64 bits)** of memory, which is larger than `float`, making it suitable for more precise calculations but at the cost of increased memory usage.
3. **Precision:** `double` has a precision of about **15 decimal digits**, which is higher than `float`, which only provides **6-7 decimal digits** of precision. `double` is generally used when higher accuracy is needed, such as in scientific and financial calculations.
4. **Scientific Notation:** `double` values can be represented in scientific notation, such as `2.34e3`, which represents `2340.0`.
5. **IEEE 754 Standard:** `double` in Java follows the IEEE 754 standard for floating-point arithmetic, which includes special values like `NaN` (Not-a-Number), `Infinity`, and `-Infinity`.
6. **Promotion in Expressions:** If a `double` is mixed with a `float`, the `float` is automatically promoted to a `double` in arithmetic expressions because `double` has a larger range and precision.
7. **Performance Considerations:** While `double` provides greater precision, it can be slower in certain cases due to its larger memory footprint. However, for many modern CPUs, the performance difference between `double` and `float` is often negligible unless handling large datasets or running performance-critical code.
8. **Avoiding Precision Loss:** For calculations that require higher precision (e.g., currency calculations, scientific calculations), `double` is typically the preferred type.&#x20;
9. **Memory Usage:** A `double` occupies **8 bytes** (64 bits). The extra memory compared to `float` allows `double` to represent a much wider range of values with higher precision.

## **Operations with `double`**

### **Arithmetic and Logical Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="240"></th><th width="304"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>double sum = a + b;</code></td><td>Addition, subtraction, multiplication, division.</td></tr><tr><td>Comparison Operations</td><td><code>a == b</code>, <code>a > b</code>, etc.</td><td>Compares two <code>double</code> values.</td></tr><tr><td>Bitwise Operations</td><td>Not supported directly on <code>double</code></td><td><code>double</code> does not support bitwise operators like <code>&#x26;</code>, `</td></tr></tbody></table>

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="225"></th><th width="299"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>double</code> to <code>String</code></td><td><code>String.valueOf(double)</code></td><td><code>String.valueOf(12.34)</code> → <code>"12.34"</code></td></tr><tr><td><code>String</code> to <code>double</code></td><td><code>Double.parseDouble(String)</code></td><td><code>Double.parseDouble("12.34")</code> → <code>12.34</code></td></tr><tr><td><code>double</code> to <code>float</code></td><td>Explicit cast <code>(float)</code></td><td><code>(float) 12.34</code> → <code>12.34f</code></td></tr><tr><td><code>float</code> to <code>double</code></td><td>Implicit conversion</td><td><code>double result = 12.34f;</code></td></tr></tbody></table>

### **Wrapper Class Example (`Double`)**

<table data-header-hidden data-full-width="true"><thead><tr><th width="383"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Double.valueOf(double d)</code></td><td>Returns a <code>Double</code> object for the given <code>double</code> value.</td></tr><tr><td><code>Double.parseDouble(String s)</code></td><td>Parses the string argument as a <code>double</code>.</td></tr><tr><td><code>Double.toString(double d)</code></td><td>Converts <code>double</code> to its <code>String</code> representation.</td></tr><tr><td><code>Double.isNaN(double d)</code></td><td>Checks if the <code>double</code> value is <code>NaN</code>.</td></tr><tr><td><code>Double.isInfinite(double d)</code></td><td>Checks if the <code>double</code> value is positive or negative infinity.</td></tr></tbody></table>

## **Common Mistakes**

1.  **Loss of Precision:** When performing operations involving `double` values, especially with large datasets or iterative processes, precision may be lost, leading to small rounding errors. This is particularly problematic for financial calculations.

    ```java
    double num1 = 0.1;
    double num2 = 0.2;
    System.out.println(num1 + num2); // Might not exactly be 0.3 due to floating-point precision errors
    ```
2.  **Comparison with `NaN`:** `NaN` (Not-a-Number) is not equal to any value, including itself. Comparing `NaN` with `double` values may lead to unexpected results.

    ```java
    double nanValue = Double.NaN;
    System.out.println(nanValue == nanValue); // Output: false
    ```
3. **Mixing `double` with `float`:** When mixing `double` with `float` in expressions, the `float` value is promoted to a `double`, leading

## **Examples**

### **Basic Example**

```java
public class DoubleExample {
    public static void main(String[] args) {
        double num1 = 10.5;
        double num2 = 20.25;

        // Arithmetic operations
        double sum = num1 + num2; 
        System.out.println("Sum: " + sum); // Sum: 30.75

        // Comparing values
        System.out.println("Is num1 greater than num2? " + (num1 > num2)); // Is num1 greater than num2? false

        // Casting
        int smallerValue = (int) num1; // Cast double to int
        System.out.println("Casted Value: " + smallerValue); // Casted Value: 10
    }
}
```

### **Using `double` in Arrays**

```java
public class DoubleArrayExample {
    public static void main(String[] args) {
        double[] doubleArray = {10.5, 20.25, 30.75};

        for (double value : doubleArray) {
            System.out.println(value); // 10.5, 20.25, 30.75
        }
    }
}
```

### **Converting `double` to `String`**

```java
public class DoubleConversion {
    public static void main(String[] args) {
        double num = 12.34;
        String str = Double.toString(num); 
        System.out.println("Double as String: " + str); // Double as String: 12.34
    }
}
```

### **Wrapper Class Example**

```java
public class DoubleWrapperExample {
    public static void main(String[] args) {
        String strValue = "12.34";
        double parsedValue = Double.parseDouble(strValue); 
        System.out.println("Parsed Value: " + parsedValue); // Parsed Value: 12.34

        double minValue = Double.MIN_VALUE; 
        double maxValue = Double.MAX_VALUE; 
        System.out.println("Min Value: " + minValue); // Min Value: 4.9E-324
        System.out.println("Max Value: " + maxValue); // Max Value: 1.7976931348623157E308
    }
}
```



