# long

## About

* **Definition:** The `long` data type is a primitive data type in Java used to represent a 64-bit signed integer. It is typically used when a wider range of integer values is needed, beyond the limits of the `int` type.
* **Size:** Occupies **8 bytes** (64 bits) in memory.
* **Value Range:**\
  `-9,223,372,036,854,775,808` to `9,223,372,036,854,775,807` (`-2^63` to `2^63 - 1`).
* **Default Value:** The default value of `long` is `0L`.
* **Wrapper Class:** The wrapper class for `long` is `Long`, located in `java.lang`.

## **Characteristics of `long`**

1. **Signed Integer Representation:**
   * The `long` type is signed, allowing both positive and negative values.
2. **Memory Usage:**
   * It consumes **8 bytes (64 bits)** of memory, which provides a much larger range than `int`.
3. **Default Choice for Large Numbers:**
   * `long` is chosen when working with numbers that exceed the limits of the `int` type, particularly in financial calculations, timestamps, and large data processing.
4.  **Promotion in Expressions:** In expressions involving `long` and other numeric types, Java promotes the `long` to a larger type (`double`) when necessary, but `long` is not promoted to `int` to avoid loss of precision. Example:

    ```java
    long a = 10L;
    double result = a / 2.0; // Promoted to double
    ```
5. **Performance:** Although `long` requires more memory (8 bytes compared to `int`'s 4 bytes), it is still quite efficient in most modern systems and is optimized for use in operations that require large numbers.
6. **Interoperability:** `long` is used in many systems for time-based calculations (e.g., Unix timestamps), database IDs, and large counters that go beyond the capacity of `int`.

## **Memory**

* **Memory Usage:** Each `long` occupies **8 bytes** of memory (64 bits). This allows for a significantly larger range of values compared to `int`.

## **Operations with `long`**

### **Arithmetic and Logical Operations**

| **Operation**         | **Example**             | **Description**                                  |
| --------------------- | ----------------------- | ------------------------------------------------ |
| Arithmetic Operations | `long sum = a + b;`     | Addition, subtraction, multiplication, division. |
| Comparison Operations | `a == b`, `a > b`, etc. | Compares two `long` values.                      |
| Bitwise Operations    | `a & b`, \`a            | b\`, etc.                                        |

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="189"></th><th width="256"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>long</code> to <code>String</code></td><td><code>String.valueOf(long)</code></td><td><code>String.valueOf(123456L)</code> → <code>"123456"</code></td></tr><tr><td><code>String</code> to <code>long</code></td><td><code>Long.parseLong(String)</code></td><td><code>Long.parseLong("123456")</code> → <code>123456</code></td></tr><tr><td><code>long</code> to <code>int</code></td><td>Explicit cast <code>(int)</code></td><td><code>(int) 123456L</code> → <code>123456</code></td></tr><tr><td><code>int</code> to <code>long</code></td><td>Implicit conversion</td><td><code>long largeValue = 123456;</code></td></tr></tbody></table>

### **Wrapper Class Example (`Long`)**

<table data-header-hidden data-full-width="true"><thead><tr><th width="328"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Long.valueOf(long l)</code></td><td>Returns a <code>Long</code> object for the given <code>long</code> value.</td></tr><tr><td><code>Long.parseLong(String s)</code></td><td>Parses the string argument as a <code>long</code>.</td></tr><tr><td><code>Long.toString(long l)</code></td><td>Converts <code>long</code> to its <code>String</code> representation.</td></tr><tr><td><code>Long.compare(long x, y)</code></td><td>Compares two <code>long</code> values.</td></tr><tr><td><code>Long.MIN_VALUE</code></td><td>Minimum value of <code>long</code> (-9,223,372,036,854,775,808).</td></tr><tr><td><code>Long.MAX_VALUE</code></td><td>Maximum value of <code>long</code> (9,223,372,036,854,775,807).</td></tr></tbody></table>

## **Common Mistakes**

1.  **Integer Overflow:** If an operation exceeds the range of `long`, it can cause overflow:

    ```java
    long max = Long.MAX_VALUE;
    max = max + 1; // Overflow
    System.out.println(max); // Output: -9223372036854775808
    ```
2.  **Implicit Type Conversion:** When performing operations involving `long` and other types, Java will promote `long` to a `double` if mixed with floating-point numbers:

    ```java
    long a = 10L;
    double b = 5.5;
    double result = a + b; // Promoted to double
    System.out.println(result); // Output: 15.5
    ```

## Examples

### **Basic Example**

```java
public class LongExample {
    public static void main(String[] args) {
        long num1 = 100000L;
        long num2 = 200000L;

        // Arithmetic operations
        long sum = num1 + num2; 
        System.out.println("Sum: " + sum); // Sum: 300000

        // Comparing values
        System.out.println("Is num1 greater than num2? " + (num1 > num2)); // Is num1 greater than num2? false

        // Casting
        int smallerValue = (int) num1; // Cast long to int
        System.out.println("Casted Value: " + smallerValue); // Casted Value: 100000
    }
}
```

### **Using `long` in Arrays**

```java
public class LongArrayExample {
    public static void main(String[] args) {
        long[] longArray = {10L, 20L, 30L};

        for (long value : longArray) {
            System.out.println(value); // 10, 20, 30
        }
    }
}
```

### **Converting `long` to `String`**

```java
public class LongConversion {
    public static void main(String[] args) {
        long num = 123456L;
        String str = Long.toString(num); 
        System.out.println("Long as String: " + str); // Long as String: 123456
    }
}
```

### **Using `long` in Streams**

```java
import java.util.stream.LongStream;

public class LongStreamExample {
    public static void main(String[] args) {
        long[] longArray = {100L, 200L, 300L};

        LongStream.of(longArray)
                  .map(x -> x * 2)
                  .forEach(System.out::println); // 200, 400, 600
    }
}
```

### **Bitwise Operations with `long`**

```java
public class LongBitwiseExample {
    public static void main(String[] args) {
        long a = 5L;  // 0101 in binary
        long b = 3L;  // 0011 in binary

        System.out.println("Bitwise AND: " + (a & b)); // Bitwise AND: 1
        System.out.println("Bitwise OR: " + (a | b));  // Bitwise OR: 7
        System.out.println("Bitwise XOR: " + (a ^ b)); // Bitwise XOR: 6
    }
}
```

### **Using `long` with Collections (Boxed `Long`)**

```java
import java.util.*;

public class LongCollectionExample {
    public static void main(String[] args) {
        List<Long> list = Arrays.asList(100L, 200L, 300L);
        list.forEach(System.out::println); // 100, 200, 300
    }
}
```

### **Wrapper Class Example**

```java
public class LongWrapperExample {
    public static void main(String[] args) {
        String strValue = "123456789";
        long parsedValue = Long.parseLong(strValue); 
        System.out.println("Parsed Value: " + parsedValue); // Parsed Value: 123456789

        long minValue = Long.MIN_VALUE; 
        long maxValue = Long.MAX_VALUE; 
        System.out.println("Min Value: " + minValue); // Min Value: -9223372036854775808
        System.out.println("Max Value: " + maxValue); // Max Value: 9223372036854775807
    }
}
```
