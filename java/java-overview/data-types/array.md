# Array

## About

An array is a container object that holds a fixed number of elements of a single data type. Each element can be accessed by its index.

* **Fixed Size:** The size of the array is defined when it is created and cannot be changed later.
* **Indexed Access:** Elements are accessed using zero-based indexing.
* **Homogeneous Data:** Arrays can only store elements of the same data type.
* **Memory Representation**
  1. **1D Array:** Contiguous block of memory.
  2. **2D Array:** Memory is allocated row by row, with each row being an array itself.
* **Arrays are Objects:** Arrays are treated as objects and inherit from `java.lang.Object`. We can call methods like `getClass()` on an array:

```java
int[] numbers = {1, 2, 3};
System.out.println(numbers.getClass().getName());  // Output: [I
```

* **Default Values in Arrays:** When an array is initialized, its elements are assigned default values:
  * `0` for numeric types (`int`, `float`, etc.).
  * `false` for `boolean`.
  * `null` for reference types (`String`, objects).
* **Multidimensional Arrays:** Java supports arrays of arrays. Example:

```java
int[][] matrix = new int[3][3];
matrix[0][0] = 1;
```

* **Exception**

**ArrayIndexOutOfBoundsException:** Occurs when accessing an index outside the valid range.

```java
int[] arr = {1, 2, 3};
System.out.println(arr[3]);  // Throws exception
```

**NullPointerException:** Accessing an uninitialized array.

```java
int[] arr = null;
System.out.println(arr.length);  // Throws exception
```

{% hint style="info" %}
**Consider Memory Usage:** Large arrays can lead to `OutOfMemoryError`. Monitor memory with tools like JVisualVM.
{% endhint %}

* **Performance Characteristics:** Arrays in Java are faster than many collection types like `ArrayList` due to:
  * **Contiguous Memory Allocation:** Accessing elements via index is O(1).
  * **No Boxing/Unboxing for Primitive Types:** Arrays of primitives avoid the overhead of wrapping values in objects.

## Declaration and Initialization of Arrays

### Declaration

```java
dataType[] arrayName;  // Recommended
dataType arrayName[];  // Also valid but less common
```

{% hint style="info" %}
**Creating Arrays with Reflection**

```java
Class<?> clazz = int.class;
Object array = java.lang.reflect.Array.newInstance(clazz, 5);
java.lang.reflect.Array.set(array, 0, 42);
System.out.println(java.lang.reflect.Array.get(array, 0));  // Output: 42
```
{% endhint %}

### Initialization

#### 1. Separate Declaration and Initialization:

```java
int[] numbers;
numbers = new int[5];  // Allocates memory for 5 integers
```

#### 2. Combined Declaration and Initialization:

```java
int[] numbers = new int[5];
```

#### 3. Array Literals:

```java
int[] numbers = {1, 2, 3, 4, 5};  // Automatically initializes and determines size
```

## Accessing and Modification of Array Elements

### **Accessing**

```java
System.out.println(numbers[0]);  // Access the first element
```

### **Modifying**

```java
numbers[0] = 10;  // Set the first element to 10
```

### **Iterating Through an Array**

* **For Loop:**

```java
for (int i = 0; i < numbers.length; i++) {
    System.out.println(numbers[i]);
}
```

* **Enhanced For Loop:**

```java
for (int number : numbers) {
    System.out.println(number);
}
```

## Properties and Methods of Arrays

### **Array Properties**

#### **`length`**

* Represents the number of elements in the array.
*   Syntax:

    ```
    int[] numbers = {1, 2, 3, 4, 5};
    System.out.println(numbers.length);  // Output: 5
    ```

{% hint style="info" %}
It is **not a method**, so parentheses `()` are not used.
{% endhint %}

### **Array Methods**

Java's built-in arrays do not have methods like objects of classes. However, the `java.util.Arrays` class provides many static methods to work with arrays.

#### **Methods in `java.util.Arrays`**

<table data-header-hidden data-full-width="true"><thead><tr><th width="195"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td><td><strong>Example</strong></td></tr><tr><td><strong><code>copyOf</code></strong></td><td>Copies the specified array, truncating or padding it to the specified length.</td><td><code>int[] newArray = Arrays.copyOf(original, newLength);</code></td></tr><tr><td><strong><code>copyOfRange</code></strong></td><td>Copies a range of elements from the original array.</td><td><code>int[] rangeArray = Arrays.copyOfRange(original, start, end);</code></td></tr><tr><td><strong><code>sort</code></strong></td><td>Sorts the elements of the array in ascending order.</td><td><code>Arrays.sort(array);</code></td></tr><tr><td><strong><code>binarySearch</code></strong></td><td>Searches for a specified value in a sorted array using the binary search algorithm.</td><td><code>int index = Arrays.binarySearch(array, value);</code></td></tr><tr><td><strong><code>equals</code></strong></td><td>Compares two arrays for equality (both length and content).</td><td><code>boolean isEqual = Arrays.equals(array1, array2);</code></td></tr><tr><td><strong><code>deepEquals</code></strong></td><td>Compares two multidimensional arrays for deep equality.</td><td><code>boolean isDeepEqual = Arrays.deepEquals(array1, array2);</code></td></tr><tr><td><strong><code>toString</code></strong></td><td>Returns a string representation of the array.</td><td><code>System.out.println(Arrays.toString(array));</code></td></tr><tr><td><strong><code>deepToString</code></strong></td><td>Returns a string representation of a multidimensional array.</td><td><code>System.out.println(Arrays.deepToString(array));</code></td></tr><tr><td><strong><code>fill</code></strong></td><td>Fills the array with a specified value.</td><td><code>Arrays.fill(array, value);</code></td></tr><tr><td><strong><code>setAll</code></strong></td><td>Sets all elements in the array based on a generator function.</td><td><code>Arrays.setAll(array, i -> i * 2);</code></td></tr><tr><td><strong><code>asList</code></strong></td><td>Converts an array to a <code>List</code>.</td><td><code>List&#x3C;Integer> list = Arrays.asList(array);</code></td></tr><tr><td><strong><code>hashCode</code></strong></td><td>Returns the hash code of the array.</td><td><code>int hash = Arrays.hashCode(array);</code></td></tr><tr><td><strong><code>deepHashCode</code></strong></td><td>Returns the hash code of a multidimensional array.</td><td><code>int hash = Arrays.deepHashCode(array);</code></td></tr><tr><td><strong><code>stream</code></strong></td><td>Converts the array into a <code>Stream</code> for functional programming.</td><td><code>IntStream stream = Arrays.stream(array);</code></td></tr><tr><td><strong><code>parallelSort</code></strong></td><td>Sorts the array using parallel sorting algorithms for large datasets.</td><td><code>Arrays.parallelSort(array);</code></td></tr><tr><td><strong><code>spliterator</code></strong></td><td>Returns a <code>Spliterator</code> for the array, which can be used for parallel processing.</td><td><code>Spliterator&#x3C;Integer> split = Arrays.spliterator(array);</code></td></tr></tbody></table>

## **Types of Arrays**

### **1D Array**

A single row of elements.

```java
int[] numbers = {1, 2, 3, 4, 5};
```

### **2D Array**

An array of arrays, useful for matrices

```java
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};
System.out.println(matrix[1][2]);  // Accesses element in 2nd row, 3rd column (6)
```

### **Jagged Array**

An array with rows of varying lengths.

```java
int[][] jaggedArray = {
    {1, 2},
    {3, 4, 5},
    {6}
};
System.out.println(jaggedArray[1][2]);  // Output: 5
```

## **Array is Not thread-safe**

Arrays in Java do not enforce synchronization for read or write operations. If two or more threads modify an array concurrently, the behavior depends on the timing of these modifications and may cause data corruption.

```java
// Concurrent Modification Scenarios of Thread-Safety Issues

int[] numbers = {1, 2, 3};

Runnable task = () -> {
    for (int i = 0; i < numbers.length; i++) {
        numbers[i]++;  // Concurrent modification
    }
};

Thread t1 = new Thread(task);
Thread t2 = new Thread(task);

t1.start();
t2.start();

// Issue: The operations like numbers[i]++ are not atomic, and threads may interfere with each other.
// Result: The array values may not be incremented correctly.
```

### Making Arrays Thread-Safe

#### **Use Synchronization**

Wrap array operations in synchronized blocks or methods.

```java
int[] numbers = {1, 2, 3};

synchronized (numbers) {
    for (int i = 0; i < numbers.length; i++) {
        numbers[i]++;
    }
}
```

#### **Use `java.util.concurrent` Utilities**

Use thread-safe alternatives like `CopyOnWriteArrayList` .

```java
CopyOnWriteArrayList<Integer> list = new CopyOnWriteArrayList<>(Arrays.asList(1, 2, 3));
list.add(4);  // Thread-safe addition
```

#### **Use Atomic Variables**

For arrays of integers or longs, use `AtomicIntegerArray` or `AtomicLongArray`

```java
AtomicIntegerArray atomicArray = new AtomicIntegerArray(new int[] {1, 2, 3});

Runnable task = () -> {
    for (int i = 0; i < atomicArray.length(); i++) {
        atomicArray.incrementAndGet(i);  // Thread-safe increment
    }
};

Thread t1 = new Thread(task);
Thread t2 = new Thread(task);

t1.start();
t2.start();
```

#### **Immutability**

Make arrays immutable by copying them and sharing only the copy.

```java
int[] immutableArray = Arrays.copyOf(originalArray, originalArray.length);
```

## Arrays with Generics

Java arrays and generics don’t integrate quite well because arrays are **covariant** and generics are **invariant**. This mismatch introduces potential type-safety issues.







## **Best Practices**

1. Always check the array length before accessing elements.
2. Use enhanced for-loops for readability when traversing arrays.
3. Prefer `Arrays` utility methods for common operations like copying, filling, or sorting.

