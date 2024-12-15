# byte

## About

* **Definition:**\
  `byte` is a primitive data type in Java, mainly used for saving memory in large arrays or handling raw binary data like file contents or streams. It represents an 8-bit signed integer.
* **Size:**\
  Occupies **1 byte** (8 bits) in memory.
* **Value Range:**\
  `-128` to `127` (`-2^7` to `2^7 - 1`).
* **Default Value:**\
  The default value of `byte` is `0`.
* **Wrapper Class:**\
  The wrapper class for `byte` is `Byte`, located in `java.lang`.

## **Characteristics of `byte`**

1. **Signed Integer Representation:** The `byte` type is signed, allowing both positive and negative values.
2. **Memory Efficiency:** Saves memory compared to `int`, especially useful for storing large datasets of small values.
3. **Binary Data Handling:** Commonly used in file I/O, image processing, and network protocols to handle binary data streams.
4.  **Promotion in Expressions:** In arithmetic operations, `byte` values are promoted to `int` before calculations. Example:

    ```java
    byte a = 10, b = 20;
    int result = a + b; // Promoted to int
    ```
5. **Interoperability:** Often used for interoperability with legacy systems or protocols requiring compact data representation.
6. **Bitwise Operations:** Supports bitwise operations such as AND, OR, XOR, and shift operations.

## **Memory and Implementation Details**

* **Memory Usage:** Requires **8 bits (1 byte)** per value, stored in signed 2’s complement representation.

## **Operations with `byte`**

### **Arithmetic and Logical Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="233"></th><th width="324"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Example</strong></td><td><strong>Description</strong></td></tr><tr><td>Arithmetic Operations</td><td><code>byte result = (byte)(a + b);</code></td><td>Addition, subtraction, multiplication, division.</td></tr><tr><td>Comparison Operations</td><td><code>a > b</code></td><td>Compares two <code>byte</code> values.</td></tr><tr><td>Casting</td><td><code>(byte) largeValue</code></td><td>Explicitly cast larger types like <code>int</code> to <code>byte</code>.</td></tr></tbody></table>

### **Conversion Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="207"></th><th width="279"></th><th></th></tr></thead><tbody><tr><td><strong>Conversion</strong></td><td><strong>Method</strong></td><td><strong>Example</strong></td></tr><tr><td><code>byte</code> to <code>String</code></td><td><code>String.valueOf(byte)</code></td><td><code>String.valueOf((byte) 100)</code> → <code>"100"</code></td></tr><tr><td><code>String</code> to <code>byte</code></td><td><code>Byte.parseByte(String)</code></td><td><code>Byte.parseByte("12")</code> → <code>12</code></td></tr><tr><td><code>byte</code> to <code>int</code></td><td>Implicit conversion</td><td><code>int value = byteVar;</code></td></tr><tr><td><code>int</code> to <code>byte</code></td><td>Explicit cast <code>(byte)</code></td><td><code>(byte) 300</code> → Overflow behavior</td></tr></tbody></table>

## **Common Mistakes**

1.  **Overflow Issues:** Casting a larger integer to `byte` causes data loss due to overflow.

    ```java
    int largeValue = 130;
    byte overflowed = (byte) largeValue; 
    System.out.println("Overflowed Value: " + overflowed); // Overflowed Value: -126
    ```
2.  **Automatic Promotion:** Arithmetic operations promote `byte` to `int`, leading to type mismatch without explicit casting.

    ```java
    byte a = 10, b = 20;
    byte sum = a + b; // Compilation error
    ```

## Examples

### **Basic Example**

```java
public class ByteExample {
    public static void main(String[] args) {
        byte num1 = 50;
        byte num2 = 20;

        // Arithmetic operations
        byte sum = (byte) (num1 + num2); 
        System.out.println("Sum: " + sum); // Sum: 70

        // Comparing values
        System.out.println("Is num1 greater than num2? " + (num1 > num2)); // Is num1 greater than num2? true

        // Casting
        int largeValue = 200;
        byte castedValue = (byte) largeValue; 
        System.out.println("Casted Value: " + castedValue); // Casted Value: -56
    }
}
```

### **Using `byte` in Arrays**

```java
public class ByteArrayExample {
    public static void main(String[] args) {
        byte[] byteArray = {10, 20, 30};

        for (byte b : byteArray) {
            System.out.println(b); // 10, 20, 30
        }
    }
}
```

### **Converting `byte` to `String`**

```java
public class ByteConversion {
    public static void main(String[] args) {
        byte num = 25;
        String str = Byte.toString(num); 
        System.out.println("Byte as String: " + str); // Byte as String: 25
    }
}
```

### **Using `byte` with Streams**

```java
import java.util.stream.IntStream;

public class ByteStreamExample {
    public static void main(String[] args) {
        byte[] byteArray = {5, 10, 15};

        IntStream.range(0, byteArray.length)
                 .map(i -> byteArray[i])
                 .forEach(System.out::println); // 5, 10, 15
    }
}
```

### **Byte as Bit Fields**

```java
public class ByteBitExample {
    public static void main(String[] args) {
        byte value = 0b0110; // Binary representation
        System.out.println("Bitwise AND: " + (value & 0b0011)); // Bitwise AND: 2
    }
}
```

### **Handling Byte Buffers**

```java
import java.nio.ByteBuffer;

public class ByteBufferExample {
    public static void main(String[] args) {
        ByteBuffer buffer = ByteBuffer.allocate(4);
        buffer.put((byte) 10);
        buffer.put((byte) 20);
        buffer.flip();

        while (buffer.hasRemaining()) {
            System.out.println(buffer.get()); // 10, 20
        }
    }
}
```

