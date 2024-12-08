# BigInteger

## About

The `BigInteger` class in Java provides the capability to work with **arbitrarily large integers**. This is particularly useful in scenarios where the primitive integer types (`byte`, `short`, `int`, `long`) cannot store large values due to their fixed size.

### Features

* **Unlimited Precision**:
  * Unlike primitive types, `BigInteger` does not have a fixed bit size. It dynamically allocates memory based on the value being stored.
  * Internally, it uses a **two's complement representation** to store values in an array of integers.
* **Immutability**:
  * All operations on `BigInteger` return a new `BigInteger` object. The original object remains unchanged, making it **thread-safe** and suitable for concurrent environments.
* **Mathematical Modeling**:
  * `BigInteger` models integers as mathematical entities, including **positive**, **negative**, and **zero**.
  * It supports a wide range of operations, including arithmetic, bitwise, modular, and number-theoretic functions.
* **Extensibility**:
  * It can be combined with `BigDecimal` (for decimals) and `MathContext` (for precision control) to enable arbitrary precision arithmetic across integers and floating-point values.

### **How it differs from Primitive Types ?**

<table data-full-width="true"><thead><tr><th width="200">Feature</th><th>Primitive Types</th><th>BigInteger</th></tr></thead><tbody><tr><td>Size</td><td>Fixed (e.g., 64 bits for <code>long</code>)</td><td>Dynamically allocated (virtually unlimited)</td></tr><tr><td>Precision</td><td>Limited by size</td><td>Arbitrary</td></tr><tr><td>Mutability</td><td>Mutable</td><td>Immutable</td></tr><tr><td>Thread-Safety</td><td>Not inherently safe</td><td>Thread-safe</td></tr><tr><td>Arithmetic Support</td><td>Basic operations</td><td>Advanced (modular, bitwise, number-theoretic)</td></tr></tbody></table>

### How Immutability Works in `BigInteger` ?

* **Internal State Representation**:
  * A `BigInteger` object maintains its value in an internal array (`magnitude`) and a sign field (`sign`).
  * These fields are `final`, meaning they cannot be reassigned after the object is constructed.
* **Operation Behavior**:
  * Every method in `BigInteger` that performs an operation (e.g., `add`, `multiply`, `mod`) returns a new `BigInteger`object.
  * The existing object remains unchanged because operations work on a copy of the internal state rather than modifying it.
* **No Setters**:
  * The absence of "setter" methods ensures that no external code can alter the internal state of a `BigInteger` object once it is created.
* **Example**:

```java
BigInteger big1 = new BigInteger("100");
BigInteger big2 = big1.add(BigInteger.valueOf(50)); // Adds 50 to big1
big2 = big2.add(BigInteger.valueOf(23)); // Adds 23 to big2

System.out.println("big1: " + big1); // Outputs 100 (unchanged)
System.out.println("big2: " + big2); // Outputs 173 (new object)
```

### When and Why to Use `BigInteger` ?

#### **When?**

* **Overflow Risk**: Use when primitive types are inadequate due to size constraints. For example:
  * The maximum value of `long` is 263−1263−1, or approximately 9.22×10189.22×1018. `BigInteger` handles values far beyond this range.
* **High Precision**: Situations demanding absolute precision without rounding errors (e.g., factorials of large numbers).

#### **Why?**

* **No Upper Limit**: The only limit to the size of a `BigInteger` is the amount of memory available on the JVM.
* **Advanced Operations**: Supports features not available in primitive types, such as:
  * Modular arithmetic
  * GCD computation
  * Prime number generation
* **Interoperability**: Works seamlessly with other mathematical libraries and can represent numbers in various bases (binary, octal, hexadecimal, etc.).

## Creating a `BigInteger` Object

### **Using Constructors**

*   `BigInteger(String val)`: Constructs a `BigInteger` from a string.

    ```java
    BigInteger big1 = new BigInteger("123456789123456789");
    ```
*   `BigInteger(String val, int radix)`: Parses a `String` with a given radix.

    ```java
    BigInteger big2 = new BigInteger("101", 2); // Binary to BigInteger
    ```
* `BigInteger(byte[] val)`: Converts a byte array to `BigInteger`.

### **Static Factory Methods**

*   `BigInteger.valueOf(long val)`: For small `long` values.

    ```java
    BigInteger big3 = BigInteger.valueOf(12345L);
    ```
* `BigInteger.ZERO`, `BigInteger.ONE`, `BigInteger.TEN`: Constants for commonly used values.

## **Operations on** `BigInteger`

### **Arithmetic Operations**

* `add(BigInteger val)`: Addition.
* `subtract(BigInteger val)`: Subtraction.
* `multiply(BigInteger val)`: Multiplication.
* `divide(BigInteger val)`: Division.
* `remainder(BigInteger val)`: Modulus.

### **Other Arithmetic Operations**

*   `modPow(BigInteger exponent, BigInteger modulus)`: Computes `(this^exponent) % modulus`.

    ```java
    BigInteger result = big1.modPow(exponent, modulus);
    ```
* `gcd(BigInteger val)`: Computes the greatest common divisor.
* `modInverse(BigInteger modulus)`: Computes the modular multiplicative inverse.

### **Bitwise Operations**

* `and(BigInteger val)`, `or(BigInteger val)`, `xor(BigInteger val)`: Logical bitwise operations.
* `not()`: Inverts bits.
* `shiftLeft(int n)`, `shiftRight(int n)`: Shifts bits.

### **Comparison**

* `compareTo(BigInteger val)`: Compares values (-1, 0, 1).
* `equals(Object x)`: Checks equality.

### **Number Conversion**

* `toString(int radix)`: Converts to a string in the specified radix.
* `toByteArray()`: Converts to a byte array.
* `intValue()`, `longValue()`, `doubleValue()`: Converts to primitives.

### **Custom Base Conversion**

We can work with custom bases (binary, hexadecimal, etc.).

```java
BigInteger hexNumber = new BigInteger("FF", 16); // Hexadecimal to BigInteger
System.out.println(hexNumber); // Prints 255
```

### **Random Number Generation**

*   `BigInteger(int numBits, Random rnd)`: Generates a random number with specified bits.

    ```java
    BigInteger randomBig = new BigInteger(100, new Random());
    ```
* `BigInteger.probablePrime(int bitLength, Random rnd)`: Generates a probable prime.

## **Limitations of** `BigInteger`

* No direct support for floating-point values. For arbitrary-precision decimal operations, `BigDecimal` should be used.
* Cannot represent numbers smaller than zero directly in some radix systems (e.g., base 2).

## **Use Cases of** `BigInteger`

### **Cryptography**

* Modular arithmetic (e.g., RSA encryption/decryption).
* Prime number generation for public/private keys.

### **Precision Arithmetic**

* Scientific computations where precision is critical.

### **Factorial and Combinatorics**

*   Computing large factorials and combinations without overflow.

    ```java
    BigInteger factorial = BigInteger.ONE;
    for (int i = 1; i <= 100; i++) {
        factorial = factorial.multiply(BigInteger.valueOf(i));
    }
    ```







