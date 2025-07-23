# short

## About

* **Definition:** `short` is one of the eight primitive data types in Java used to store integer values with a smaller range compared to `int`. It is particularly useful when memory usage is a concern and the values fit within its range.
* **Size:** Occupies **2 bytes** (16 bits) in memory.
* **Value Range:**\
  `-32,768` to `32,767` (`-2^15` to `2^15 - 1`).
* **Default Value:** The default value of `short` is `0`.
* **Wrapper Class:** The wrapper class for `short` is `Short`, located in `java.lang`.

## **Characteristics**

1. **Signed Integer Representation:** The `short` type is signed, meaning it can represent both positive and negative integers.
2. **Compact Data Type:** Compared to `int`, it saves memory, especially useful for large arrays of small numbers.
3. **Arithmetic Operations:** Like other numeric types, `short` supports arithmetic operations such as addition, subtraction, multiplication, and division.
4.  **Promotion in Expressions:** In arithmetic expressions, `short` values are automatically promoted to `int` before any operation. Example:

    ```java
    short a = 10;
    short b = 20;
    int result = a + b; // Promoted to int
    ```
5. **Usage in Streams:** Since Java Streams operate on `int`, `short` values must be converted or boxed to work with streams.
6. **Interoperability:** Often used in file handling, network protocols, and legacy systems where compact data representation is required.
7. **Memory Usage:** Requires **16 bits (2 bytes)** per value, stored in signed 2’s complement representation.

## **Operations with `short`**

### **Arithmetic and Logical Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="238"></th><th width="242"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>short a = 10 + 20;</code></td><td>Addition, subtraction, multiplication, division.</td></tr><tr><td>Comparison Operations</td><td><code>a > b</code></td><td>Compares two <code>short</code> values.</td></tr><tr><td>Casting</td><td><code>(short) largeValue</code></td><td>Explicitly cast larger types like <code>int</code> to <code>short</code>.</td></tr></tbody></table>

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="221"></th><th width="286"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>short</code> to <code>String</code></td><td><code>String.valueOf(short)</code></td><td><code>String.valueOf(100)</code> → <code>"100"</code></td></tr><tr><td><code>String</code> to <code>short</code></td><td><code>Short.parseShort(String)</code></td><td><code>Short.parseShort("123")</code> → <code>123</code></td></tr><tr><td><code>short</code> to <code>int</code></td><td>Implicit conversion</td><td><code>int value = shortVar;</code></td></tr><tr><td><code>int</code> to <code>short</code></td><td>Explicit cast <code>(short)</code></td><td><code>(short) 50000</code> → Overflow behavior</td></tr><tr><td><code>short</code> to <code>double</code></td><td>Implicit conversion</td><td><code>double value = shortVar;</code></td></tr></tbody></table>

### **Short Wrapper Class (`Short`)**

<table data-header-hidden data-full-width="true"><thead><tr><th width="335"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>Short.valueOf(short s)</code></td><td>Returns a <code>Short</code> instance for the given <code>short</code> value.</td></tr><tr><td><code>Short.parseShort(String s)</code></td><td>Parses the string argument as a <code>short</code>.</td></tr><tr><td><code>Short.toString(short s)</code></td><td>Converts <code>short</code> to its <code>String</code> representation.</td></tr><tr><td><code>Short.compare(short x, y)</code></td><td>Compares two <code>short</code> values.</td></tr><tr><td><code>Short.MIN_VALUE</code></td><td>Minimum value of <code>short</code> (-32,768).</td></tr><tr><td><code>Short.MAX_VALUE</code></td><td>Maximum value of <code>short</code> (32,767).</td></tr></tbody></table>

## **Common Mistakes**

1.  **Overflow Issues:** Casting a larger integer to `short` can cause data loss due to overflow.

    ```java
    int largeValue = 70000;
    short overflowed = (short) largeValue; // Value wraps around
    ```
2.  **Automatic Promotion:** Arithmetic operations promote `short` to `int`, which can lead to unexpected results.

    ```java
    short a = 10;
    short b = 20;
    short c = a + b; // Compilation error (needs cast)
    ```

## Examples

### Basic example

```java
short num1 = 100;
short num2 = 200;

// Arithmetic operations
short sum = (short) (num1 + num2); // Explicit cast required as + results in int type
System.out.println("Sum: " + sum); // Sum: 300
short a = 10 + 20; // 30

// Comparing values
System.out.println("Is num1 greater than num2? " + (num1 > num2)); // false

// Casting
int largerValue = 50000;
short castedValue = (short) largerValue; // Overflow occurs
System.out.println("Casted Value: " + castedValue); // -15536
```

### **Using `short` in Arrays**

```java
public class ShortArrayExample {
    public static void main(String[] args) {
        short[] numbers = {10, 20, 30, 40, 50};

        for (short num : numbers) {
            System.out.println(num);
        }
    }
}
```

### **Converting `short` to `String`**

```java
public class ShortConversion {
    public static void main(String[] args) {
        short num = 25;
        String str = Short.toString(num);
        System.out.println("Short as String: " + str);
    }
}
```

### **Using `short` with Streams**

```java
import java.util.stream.IntStream;

public class ShortStreamExample {
    public static void main(String[] args) {
        short[] numbers = {10, 20, 30};

        IntStream.range(0, numbers.length)
                 .map(i -> numbers[i])
                 .forEach(System.out::println);
    }
}
```

### **Short as Bit Fields**

```java
public class ShortBitExample {
    public static void main(String[] args) {
        short value = 0b0101; // Binary representation
        System.out.println("Bitwise AND: " + (value & 0b0011)); // 0001
    }
}
```

### **Handling Large Short Arrays**

```java
public class ShortArrayMemory {
    public static void main(String[] args) {
        short[] largeArray = new short[1_000_000]; // 2 MB memory
        System.out.println("Array Length: " + largeArray.length);
    }
}
```

{% hint style="info" %}
The number `1_000_000` is **1 million**, and the underscores (`_`) in numeric literals are a feature introduced in **Java 7** to improve readability of numbers.
{% endhint %}

### **Wrapper Class Example**

```java
public class ShortWrapperExample {
    public static void main(String[] args) {
        String strValue = "1234";
        short parsedValue = Short.parseShort(strValue);

        System.out.println("Parsed Value: " + parsedValue);

        short minValue = Short.MIN_VALUE;
        short maxValue = Short.MAX_VALUE;

        System.out.println("Min Value: " + minValue);
        System.out.println("Max Value: " + maxValue);
    }
}
```

