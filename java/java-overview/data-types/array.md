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

### **What Is Allowed**

1. &#x20;**Creating Generic Arrays with a Wildcard**

We can create arrays of wildcards (`?`).

```java
List<?>[] listArray = new List<?>[10];  // Allowed
```

2. **Creating Generic Arrays with Raw Types**

We can create arrays of raw types (though it is not recommended due to loss of type safety).

```javascript
List[] listArray = new List[10];  // Allowed
```

3. **Using Reflection to Create Generic Arrays**

Reflection can bypass generic array restrictions.

```java
import java.lang.reflect.Array;

public class GenericArray {
    public static <T> T[] createArray(Class<T> clazz, int size) {
        return (T[]) Array.newInstance(clazz, size);
    }
}
```

4. **Generic Arrays as Fields**

We can declare a generic array field, but the actual instantiation must avoid direct generic array creation.

```java
class Example<T> {
    private T[] elements;

    public Example(Class<T> clazz, int size) {
        elements = (T[]) Array.newInstance(clazz, size);  // Allowed
    }
}
```

5. **Using Arrays as Generic Collections**

Although we cannot create a generic array directly, we can use collections like `List` or `ArrayList`.

```java
List<String> list = new ArrayList<>();  // Use this instead of a generic array
```

### **What Is Not Allowed**

1. &#x20;**Direct Creation of Generic Arrays**

We cannot directly create arrays with a generic type.

```java
T[] array = new T[10];  // Not Allowed
```

2. **Generic Arrays of Specific Parameterized Types**

You cannot create an array of a specific generic type (e.g., `List<String>`).

```java
List<String>[] stringListArray = new List<String>[10];  // Not Allowed
```

3. **Mixing Arrays and Generics**

You cannot mix arrays and generic types in assignments without warnings.

```java
List<Integer>[] arrayOfLists = (List<Integer>[]) new List[10];  // Allowed with warning
```

{% hint style="info" %}
**Reason for Restrictions**

* **Covariance of Arrays:** Arrays in Java are covariant, meaning `String[]` is a subtype of `Object[]`.

```
Object[] objArray = new String[10];
objArray[0] = 10;  // Throws ArrayStoreException at runtime
```

* **Invariance of Generics:** Generics are invariant, so `List<String>` is not a subtype of `List<Object>`. This ensures type safety at compile time.
* **Type Erasure:** Generic types are erased at runtime, leaving no information about the actual type parameter. This makes it impossible to enforce type safety for generic arrays.
{% endhint %}

## **Example**

Arrays can be created for almost all primitive and reference data types.

#### **Primitive Data Types**

<table data-full-width="true"><thead><tr><th width="240">Data Type</th><th width="261">Description</th><th>Example Declaration</th></tr></thead><tbody><tr><td><code>byte</code></td><td>8-bit integer</td><td><code>byte[] byteArray = new byte[5];</code></td></tr><tr><td><code>short</code></td><td>16-bit integer</td><td><code>short[] shortArray = new short[5];</code></td></tr><tr><td><code>int</code></td><td>32-bit integer</td><td><code>int[] intArray = {1, 2, 3};</code></td></tr><tr><td><code>long</code></td><td>64-bit integer</td><td><code>long[] longArray = new long[5];</code></td></tr><tr><td><code>float</code></td><td>32-bit floating-point number</td><td><code>float[] floatArray = new float[5];</code></td></tr><tr><td><code>double</code></td><td>64-bit floating-point number</td><td><code>double[] doubleArray = new double[5];</code></td></tr><tr><td><code>char</code></td><td>16-bit Unicode character</td><td><code>char[] charArray = {'A', 'B'};</code></td></tr><tr><td><code>boolean</code></td><td>1-bit, can store <code>true</code> or <code>false</code> values</td><td><code>boolean[] boolArray = new boolean[5];</code></td></tr></tbody></table>

#### **Reference Data Types**

<table data-full-width="true"><thead><tr><th width="176">Data Type</th><th width="360">Description</th><th>Example Declaration</th></tr></thead><tbody><tr><td><code>String</code></td><td>Stores sequences of characters</td><td><code>String[] strArray = {"A", "B", "C"};</code></td></tr><tr><td><code>Object</code></td><td>Parent class of all Java classes</td><td><code>Object[] objArray = new Object[5];</code></td></tr><tr><td>Custom Class</td><td>Any user-defined class can be used as an array type</td><td><code>Student[] studentArray = new Student[5];</code></td></tr></tbody></table>

#### **Generic Types**

<table data-full-width="true"><thead><tr><th width="197">Data Type</th><th width="317">Description</th><th>Example Declaration</th></tr></thead><tbody><tr><td><code>List&#x3C;?></code></td><td>Array of wildcard lists (requires unchecked cast)</td><td><code>List&#x3C;?>[] listArray = new List&#x3C;?>[5];</code></td></tr><tr><td><code>Map&#x3C;?, ?></code></td><td>Array of maps</td><td><code>Map&#x3C;String, Integer>[] mapArray = new Map[5];</code></td></tr></tbody></table>

```java
public class ArrayExamples {
    public static void main(String[] args) {
        // Declaring and initializing a one-dimensional array
        int[] numbers = {10, 20, 30, 40, 50};
        System.out.println("1D Array: ");
        for (int number : numbers) {
            System.out.print(number + " ");
        }
        System.out.println();

        // Declaring and initializing a two-dimensional array
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        System.out.println("\n2D Array (Matrix): ");
        for (int[] row : matrix) {
            for (int col : row) {
                System.out.print(col + " ");
            }
            System.out.println();
        }

        // Using arrays of strings
        String[] fruits = {"Apple", "Banana", "Cherry"};
        System.out.println("\nString Array: ");
        for (String fruit : fruits) {
            System.out.println(fruit);
        }

        // Accessing and modifying elements
        numbers[2] = 35; // Modify the third element
        System.out.println("\nModified Array: ");
        for (int number : numbers) {
            System.out.print(number + " ");
        }

        // Dynamic initialization of an array
        double[] prices = new double[5]; // Create an array with a size of 5
        prices[0] = 10.99;
        prices[1] = 5.49;
        prices[2] = 3.79;
        prices[3] = 12.99;
        prices[4] = 7.49;
        System.out.println("\n\nPrices Array: ");
        for (double price : prices) {
            System.out.print(price + " ");
        }

        // Finding the length of an array
        System.out.println("\n\nLength of Numbers Array: " + numbers.length);

        // Copying arrays
        int[] copiedNumbers = java.util.Arrays.copyOf(numbers, numbers.length);
        System.out.println("\nCopied Array: ");
        for (int num : copiedNumbers) {
            System.out.print(num + " ");
        }

        // Using Arrays class utility methods
        java.util.Arrays.sort(numbers); // Sort the array
        System.out.println("\n\nSorted Array: ");
        for (int number : numbers) {
            System.out.print(number + " ");
        }

        // Multidimensional array with irregular (jagged) dimensions
        int[][] jaggedArray = {
            {1, 2},
            {3, 4, 5},
            {6}
        };
        System.out.println("\n\nJagged Array: ");
        for (int[] row : jaggedArray) {
            for (int col : row) {
                System.out.print(col + " ");
            }
            System.out.println();
        }

        // Array of objects
        Student[] students = new Student[3];
        students[0] = new Student("Alice", 20);
        students[1] = new Student("Bob", 22);
        students[2] = new Student("Charlie", 19);
        System.out.println("\nArray of Objects (Students): ");
        for (Student student : students) {
            System.out.println(student);
        }
    }
}

class Student {
    String name;
    int age;

    Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Student{name='" + name + "', age=" + age + "}";
    }
}
```

## **Best Practices**

1. Always check the array length before accessing elements.
2. Use enhanced for-loops for readability when traversing arrays.
3. Prefer `Arrays` utility methods for common operations like copying, filling, or sorting.

