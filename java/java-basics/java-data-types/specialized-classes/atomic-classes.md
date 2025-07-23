# Atomic Classes

## About

The **Atomic classes** in Java, part of the `java.util.concurrent.atomic` package, provide a way to perform atomic operations on variables. These operations are thread-safe without requiring synchronization, making them a cornerstone of concurrent programming.

* Atomic classes are designed to update variables atomically in a multi-threaded environment, ensuring that operations like incrementing, setting, or comparing are performed as a single, indivisible operation.
* They use low-level hardware instructions such as Compare-And-Swap (CAS) to ensure thread safety without locks.
* They provide a non-blocking alternative to traditional synchronization, resulting in better performance for specific use cases.

## **Features**

1. **Thread Safety:** Operations on atomic variables are thread-safe without requiring explicit synchronization.
2. **Non-Blocking:** Uses CAS (Compare-And-Swap) to perform updates, avoiding locking mechanisms.
3. **Scalability:** Provides better performance and scalability compared to synchronized blocks for fine-grained operations.
4. **Flexible Range of Types:** Atomic classes support a variety of data types and structures, such as integers, booleans, arrays, and references.
5. **High Performance:** Ideal for low-latency applications where synchronization overhead must be minimized.

## **Declaration**

To use atomic classes, we need to import the `java.util.concurrent.atomic` package:

```java
import java.util.concurrent.atomic.*;
```

### **Common Atomic Classes**

1. **Basic Types:**
   * `AtomicBoolean`: Atomic operations for a boolean value.
   * `AtomicInteger`: Atomic operations for an integer value.
   * `AtomicLong`: Atomic operations for a long value.
   * `AtomicReference<V>`: Atomic operations for object references.
2. **Advanced Types:**
   * `AtomicIntegerArray`: Atomic operations on arrays of integers.
   * `AtomicLongArray`: Atomic operations on arrays of longs.
   * `AtomicReferenceArray<E>`: Atomic operations on arrays of references.
   * `AtomicStampedReference<V>`: Atomic operations with a version or stamp to prevent the ABA problem.
   * `AtomicMarkableReference<V>`: Atomic operations with a boolean marker for reference values.

## **Key Methods**

### **Get and Set**

* `get()`: Retrieves the current value.
* `set(value)`: Sets the value unconditionally.
* `lazySet(value)`: Sets the value but may delay the write for optimization.

### **Atomic Updates**

* `getAndIncrement()`: Atomically increments and returns the previous value.
* `getAndDecrement()`: Atomically decrements and returns the previous value.
* `incrementAndGet()`: Atomically increments and returns the new value.
* `decrementAndGet()`: Atomically decrements and returns the new value.

### **Compare-And-Swap**

* `compareAndSet(expectedValue, newValue)`: Atomically sets a new value if the current value matches the expected value.

### **Arithmetic and Bitwise**

* `addAndGet(delta)`: Adds a delta to the value atomically.
* `getAndAdd(delta)`: Adds a delta and returns the old value.
* `getAndUpdate(UnaryOperator)` or `updateAndGet(UnaryOperator)`: Applies a function atomically.

## **Usage**

### **Basic Usage of `AtomicInteger`**

```java
import java.util.concurrent.atomic.AtomicInteger;

public class AtomicExample {
    public static void main(String[] args) {
        AtomicInteger counter = new AtomicInteger(0);

        System.out.println("Initial value: " + counter.get());
        
        // Increment
        System.out.println("After increment: " + counter.incrementAndGet());
        
        // Add a value
        System.out.println("After adding 5: " + counter.addAndGet(5));
        
        // Compare-And-Swap
        boolean success = counter.compareAndSet(6, 10);
        System.out.println("CAS success: " + success);
        System.out.println("Final value: " + counter.get());
    }
}
```

### **Using `AtomicReference`**

```java
import java.util.concurrent.atomic.AtomicReference;

public class AtomicReferenceExample {
    public static void main(String[] args) {
        AtomicReference<String> atomicString = new AtomicReference<>("Initial Value");

        System.out.println("Original: " + atomicString.get());

        atomicString.set("Updated Value");
        System.out.println("Updated: " + atomicString.get());

        // Compare-And-Swap
        boolean updated = atomicString.compareAndSet("Updated Value", "Final Value");
        System.out.println("CAS success: " + updated);
        System.out.println("Final: " + atomicString.get());
    }
}
```

### **Using `AtomicIntegerArray`**

```java
import java.util.concurrent.atomic.AtomicIntegerArray;

public class AtomicArrayExample {
    public static void main(String[] args) {
        int[] values = {1, 2, 3};
        AtomicIntegerArray atomicArray = new AtomicIntegerArray(values);

        System.out.println("Original value at index 0: " + atomicArray.get(0));

        atomicArray.incrementAndGet(0);
        System.out.println("After incrementing index 0: " + atomicArray.get(0));

        atomicArray.compareAndSet(1, 2, 5);
        System.out.println("After CAS at index 1: " + atomicArray.get(1));
    }
}
```

### **Preventing ABA Problem with `AtomicStampedReference`**

```java
import java.util.concurrent.atomic.AtomicStampedReference;

public class AtomicStampedExample {
    public static void main(String[] args) {
        AtomicStampedReference<Integer> atomicStamped = new AtomicStampedReference<>(100, 1);

        int stamp = atomicStamped.getStamp();
        int value = atomicStamped.getReference();

        System.out.println("Original: Value = " + value + ", Stamp = " + stamp);

        atomicStamped.compareAndSet(100, 200, stamp, stamp + 1);
        System.out.println("Updated: Value = " + atomicStamped.getReference() + ", Stamp = " + atomicStamped.getStamp());
    }
}
```

{% hint style="info" %}
The **ABA problem** is a common issue in multithreaded programming and specifically in **lock-free algorithms**. It occurs when a thread reads a shared variable's value (e.g., `A`), performs some operations assuming the value hasn't changed, but during that time, another thread changes the value to something else (e.g., `B`) and then back to `A`. This makes it appear as though the value hasn't changed, but in reality, an intermediate state occurred that the first thread is unaware of.
{% endhint %}

## **Applications and Real-World Usage**

1. **Counters and Metrics:** Use `AtomicInteger` or `AtomicLong` for thread-safe counters in web servers, logging systems, and monitoring tools.
2. **Non-Blocking Data Structures:** Use `AtomicReference` for building lock-free stacks, queues, and other data structures.
3. **Preventing ABA Problem:** Use `AtomicStampedReference` to handle scenarios where the same value is set multiple times without indicating intermediate changes.
4. **Atomic Arrays:** Use `AtomicIntegerArray` for managing shared resources in high-concurrency environments.
5. **Configuration Updates:** Dynamically update configurations in multi-threaded systems using atomic references.
