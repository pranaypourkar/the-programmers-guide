# BitSet

## About

The `BitSet` class in Java is a part of the `java.util` package and provides an efficient way to work with a sequence of bits. It represents a vector of bits that grows dynamically as needed. Each bit in the `BitSet` can either be `true` (set) or `false` (unset), making it an ideal choice for tasks such as manipulating sets of flags, managing collections of Boolean values, or performing operations on binary data.

Internally, `BitSet` uses a long array to store bits, which allows it to be memory efficient, especially compared to using an array of `boolean` primitives.

{% hint style="info" %}
#### **How `BitSet` Stores Bits Internally**

* A `BitSet` uses an array of `long` values (`long[]`) to store the bits.
* Each `long` in Java is 64 bits wide, meaning one `long` can store the state of **64 bits** (`true` or `false` values).
* If you need to store, say, 128 bits, a `BitSet` will use **2 longs** (`128 / 64 = 2`).

#### **How `boolean[]` Stores Values Internally**

* In a `boolean[]`, each element represents one bit of information (`true` or `false`), but due to memory alignment and storage constraints, Java does not store booleans as single bits.
* Instead, Java typically uses **1 byte (8 bits)** to store each `boolean` value in an array, because most hardware cannot directly address individual bits.
* So, a `boolean[]` of size 128 will use **128 bytes** (1 byte per `boolean`).
{% endhint %}

## **Features**

1. **Dynamic Sizing:** The size of a `BitSet` is not fixed and can grow automatically as bits are set or cleared.
2. **Memory Efficiency:** `BitSet` is much more memory efficient than a `boolean[]` array since it stores bits compactly using long integers.
3. **Bitwise Operations:** It supports logical operations such as `AND`, `OR`, `XOR`, and `AND NOT`.
4. **Index-Based Access:** Bits can be accessed and manipulated using their zero-based index.
5. **Stream and Lambda Support:** Java 8 and later versions added support for streaming through `BitSet` using methods like `stream()`.
6. **Automatic Growth:** When setting a bit at an index that exceeds the current size, the `BitSet` automatically resizes to accommodate the new index.
7. **Default State:** All bits in a `BitSet` are initially `false`.
8. **Serialization:** The `BitSet` class implements `Serializable`, allowing it to be serialized and deserialized.

## **Declaration & Functions**

### **Declaration**

To use a `BitSet`, simply import it and create an instance:

```java
import java.util.BitSet;

// Creating a BitSet with no specified size
BitSet bitSet = new BitSet();

// Creating a BitSet with an initial size (e.g., 64 bits)
BitSet bitSetWithSize = new BitSet(64);
```

### **Key Methods and Functions**

1.  **Setting and Clearing Bits:**

    ```java
    bitSet.set(int index);              // Sets the bit at the specified index to true
    bitSet.set(int fromIndex, int toIndex); // Sets all bits in a range to true
    bitSet.clear(int index);            // Clears the bit at the specified index
    bitSet.clear(int fromIndex, int toIndex); // Clears all bits in a range
    bitSet.clear();                     // Clears all bits in the BitSet
    ```
2.  **Getting Bit Values:**

    ```java
    boolean value = bitSet.get(int index);          // Gets the value of the bit at the specified index
    BitSet subSet = bitSet.get(int fromIndex, int toIndex); // Gets a subset of bits as a new BitSet
    ```
3.  **Checking State:**

    ```java
    boolean isEmpty = bitSet.isEmpty();      // Checks if all bits are false
    int cardinality = bitSet.cardinality(); // Returns the number of bits set to true
    int length = bitSet.length();           // Returns the index of the highest set bit + 1
    ```
4.  **Logical Operations:**

    ```java
    bitSet.and(BitSet set);       // Performs logical AND with another BitSet
    bitSet.or(BitSet set);        // Performs logical OR with another BitSet
    bitSet.xor(BitSet set);       // Performs logical XOR with another BitSet
    bitSet.andNot(BitSet set);    // Clears all bits in the current BitSet that are set in another BitSet
    ```
5.  **Stream Support (Java 8+):**

    ```java
    bitSet.stream().forEach(System.out::println); // Streams the indices of bits set to true
    ```
6.  **Miscellaneous:**

    ```java
    int size = bitSet.size();     // Returns the number of bits the BitSet can hold
    bitSet.flip(int index);       // Toggles the bit at the specified index
    bitSet.flip(int fromIndex, int toIndex); // Toggles all bits in a range
    ```

## **Usage**

### **1. Flags and Binary Representations:**

* `BitSet` is often used to represent flags or enable/disable states in an application.

```java
BitSet flags = new BitSet();
flags.set(0); // Enable first flag
flags.set(2); // Enable third flag
System.out.println(flags); // Prints: {0, 2}
```

### **2. Efficient Membership Testing:**

* It can be used to represent sets and perform operations like intersection and union.

```java
BitSet set1 = new BitSet();
BitSet set2 = new BitSet();
set1.set(1);
set1.set(2);
set2.set(2);
set2.set(3);
set1.and(set2);
System.out.println(set1); // Prints: {2}
```

### **3. Data Compression:**

* To store large numbers of Boolean values in minimal memory.

### **4. Prime Number Generation (Sieve of Eratosthenes):**

* `BitSet` is used to efficiently implement algorithms for generating prime numbers.

```java
int n = 50;
BitSet primes = new BitSet(n);
primes.set(0, n + 1);
primes.clear(0);
primes.clear(1);
for (int i = 2; i * i <= n; i++) {
    if (primes.get(i)) {
        for (int j = i * i; j <= n; j += i) {
            primes.clear(j);
        }
    }
}
System.out.println(primes); // Prints: {2, 3, 5, 7, 11, ...}
```

### **5. Stream-Based Processing:**

* Using `BitSet` in conjunction with streams for advanced data processing.

```java
bitSet.stream()
      .mapToObj(i -> "Bit: " + i)
      .forEach(System.out::println);
```

