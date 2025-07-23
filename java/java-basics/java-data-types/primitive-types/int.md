# int

## About

* **Definition:** `int` is one of the most commonly used primitive data types in Java, representing a 32-bit signed integer. It is used for handling general integer values in both mathematical computations and for data storage.
* **Size:** Occupies **4 bytes** (32 bits) in memory.
* **Value Range:**\
  `-2,147,483,648` to `2,147,483,647` (`-2^31` to `2^31 - 1`).
* **Default Value:** The default value of `int` is `0`.
* **Wrapper Class:** The wrapper class for `int` is `Integer`, located in `java.lang`.

## **Characteristics of `int`**

1. **Signed Integer Representation:** The `int` type is signed, allowing both positive and negative values.
2. **Memory Usage:** It consumes **32 bits (4 bytes)** of memory, which provides a large range of integer values.
3. **Most Common Type:** `int` is the default data type for integers in Java and is widely used in loops, counters, and mathematical operations.
4.  **Promotion in Expressions:** In expressions involving `int` and other numeric types, Java promotes the `int` to larger types (like `long` or `double`) as needed. Example:

    ```java
    int a = 5;
    double result = a / 2.0; // Promoted to double
    ```
5. **Performance:** `int` is typically faster than larger data types like `long` or `double` for most applications, and is especially preferred when performance is critical and values are within the range of `int`.
6. **Interoperability:** It is often used in APIs, databases, and frameworks as the default integer type due to its wide range and performance efficiency.

## **Memory and Implementation Details**

* **Memory Usage:** Each `int` occupies **4 bytes** of memory (32 bits). This allows for the representation of a wide range of integer values.
* **Bytecode Representation:** The `int` type in Java is efficiently represented in the JVM as a 32-bit integer. All operations on `int` values are performed using the JVM's native integer arithmetic instructions.

## **Operations with `int`**

### **Arithmetic and Logical Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="246"></th><th width="272"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>int sum = a + b;</code></td><td>Addition, subtraction, multiplication, division.</td></tr><tr><td>Comparison Operations</td><td><code>a == b</code>, <code>a > b</code>, etc.</td><td>Compares two <code>int</code> values.</td></tr><tr><td>Bitwise Operations</td><td><code>a &#x26; b</code>, `a</td><td>b`, etc.</td></tr></tbody></table>

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="261"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>int</code> to <code>String</code></td><td><code>String.valueOf(int)</code></td><td><code>String.valueOf(123)</code> → <code>"123"</code></td></tr><tr><td><code>String</code> to <code>int</code></td><td><code>Integer.parseInt(String)</code></td><td><code>Integer.parseInt("123")</code> → <code>123</code></td></tr><tr><td><code>int</code> to <code>long</code></td><td>Implicit conversion</td><td><code>long l = 123L</code></td></tr><tr><td><code>long</code> to <code>int</code></td><td>Explicit cast <code>(int)</code></td><td><code>(int) 123456789L</code> → <code>123456789</code></td></tr></tbody></table>

## **Common Mistakes**

1.  **Integer Overflow:** If an operation exceeds the range of an `int`, it can lead to overflow or underflow:

    ```java
    int max = Integer.MAX_VALUE;
    max = max + 1; // Integer overflow
    System.out.println(max); // Output: -2147483648
    ```
2.  **Implicit Type Conversion:** When performing operations involving `int` and other types, Java promotes the `int` to a larger data type (like `long` or `double`):

    ```java
    int a = 10;
    double b = 5.5;
    double result = a + b; // Implicit conversion to double
    System.out.println(result); // Output: 15.5
    ```

## **Examples**

### **Basic Example**

```java
public class IntExample {
    public static void main(String[] args) {
        int num1 = 50;
        int num2 = 20;

        // Arithmetic operations
        int sum = num1 + num2; 
        System.out.println("Sum: " + sum); // Sum: 70

        // Comparing values
        System.out.println("Is num1 greater than num2? " + (num1 > num2)); // Is num1 greater than num2? true

        // Casting
        long largeValue = 200L;
        int castedValue = (int) largeValue; 
        System.out.println("Casted Value: " + castedValue); // Casted Value: 200
    }
}
```

### **Using `int` in Arrays**

```java
public class IntArrayExample {
    public static void main(String[] args) {
        int[] intArray = {10, 20, 30};

        for (int i : intArray) {
            System.out.println(i); // 10, 20, 30
        }
    }
}
```

### **Converting `int` to `String`**

```java
public class IntConversion {
    public static void main(String[] args) {
        int num = 25;
        String str = Integer.toString(num); 
        System.out.println("Int as String: " + str); // Int as String: 25
    }
}
```

### **Using `int` in Streams**

```java
import java.util.stream.IntStream;

public class IntStreamExample {
    public static void main(String[] args) {
        int[] intArray = {5, 10, 15};

        IntStream.of(intArray)
                 .map(x -> x * 2)
                 .forEach(System.out::println); // 10, 20, 30
    }
}
```

### **Bitwise Operations with `int`**

```java
public class IntBitwiseExample {
    public static void main(String[] args) {
        int a = 5; // 0101 in binary
        int b = 3; // 0011 in binary

        System.out.println("Bitwise AND: " + (a & b)); // Bitwise AND: 1
        System.out.println("Bitwise OR: " + (a | b));  // Bitwise OR: 7
        System.out.println("Bitwise XOR: " + (a ^ b)); // Bitwise XOR: 6
    }
}
```

### **Using `int` with Collections (Boxed `Integer`)**

```java
import java.util.List;
import java.util.ArrayList;

public class IntegerListExample {
    public static void main(String[] args) {
        List<Integer> intList = new ArrayList<>();
        intList.add(10);
        intList.add(20);
        intList.add(30);

        intList.forEach(System.out::println); // 10, 20, 30
    }
}
```

