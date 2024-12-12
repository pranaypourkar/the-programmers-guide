# Non-Primitive (Reference) Types

## About

Non-primitive types, also known as reference types, are Java objects that provide more flexibility and functionality compared to primitive types. They include classes, arrays, collections, interfaces, enums, and more. Unlike primitive types, reference types store references (memory addresses) to the actual data rather than the data itself.

## **Characteristics of Non-Primitive Types**

1. **Reference-Based**: Variables of non-primitive types store memory addresses pointing to their actual values.
2. **Heap Storage**: Non-primitive objects are stored in heap memory.
3. **Nullable**: Unlike primitives, reference variables can be assigned `null` to indicate the absence of a value.
4. **Object-Oriented**: Most non-primitive types are derived from the `Object` class, allowing access to methods like `toString()`, `equals()`, and `hashCode()`.
5. **Dynamic Behavior**: Can be used to store and manipulate complex data structures.

## **Categories of Non-Primitive Types**

### **A. Arrays**

* **Definition**: Fixed-size, indexed collection of elements of the same type.
*   **Syntax**:

    ```java
    int[] numbers = {1, 2, 3, 4};
    String[] names = new String[3];
    ```

### **B. Strings**

* **Definition**: Immutable sequence of characters represented by the `String` class.
*   **Syntax**:

    ```java
    String greeting = "Hello, World!";
    ```

### **C. Collections**

Java provides the **Collection Framework** for handling dynamic data structures. It includes:

1.  **Lists**:

    * Ordered and allows duplicate elements.
    * Examples: `ArrayList`, `LinkedList`.
    * Use Case: Maintaining ordered data with frequent access or insertion.

    ```java
    List<String> fruits = new ArrayList<>();
    fruits.add("Apple");
    fruits.add("Banana");
    ```
2.  **Queues**:

    * Follows FIFO (First In, First Out) or LIFO (Last In, First Out) for processing.
    * Examples: `PriorityQueue`, `ArrayDeque`.
    * Use Case: Task scheduling and buffering.

    ```java
    Queue<Integer> numbers = new LinkedList<>();
    numbers.add(10);
    numbers.poll();
    ```
3.  **Maps**:

    * Stores key-value pairs.
    * Examples: `HashMap`, `TreeMap`.
    * Use Case: Fast retrieval of data based on keys.

    ```java
    Map<String, Integer> scores = new HashMap<>();
    scores.put("Alice", 90);
    scores.put("Bob", 85);
    ```
4.  **Sets**:

    * Stores unique elements.
    * Examples: `HashSet`, `TreeSet`.
    * Use Case: Handling collections with no duplicates.

    ```java
    eSet<String> uniqueNames = new HashSet<>();
    uniqueNames.add("John");
    uniqueNames.add("John"); // Duplicate ignored
    ```

## Type Conversion and Promotion

In Java, **type conversion** and **promotion** often deal with converting data from one type to another. With non-primitive types, this process is distinct from primitives because reference types involve objects and memory addresses.

1. **Type Conversion**:
   * Involves converting one reference type into another.
   * Achieved via **casting** or type-related methods.
   * Typically used with inheritance hierarchies or interfaces.

**Example**:

```java
Object obj = "Hello"; // Upcasting: String to Object
String str = (String) obj; // Downcasting: Object back to String
```

2. **Type Promotion**:
   * Non-primitive types don’t have promotion in the same sense as primitives.
   * The closest equivalent is **upcasting** (assigning a derived type to its base type).

**Example**:

```java
List<String> list = new ArrayList<>(); // ArrayList promoted to List
```

## **Boxing and Unboxing**

**Boxing**: Conversion of a primitive type into its corresponding wrapper class object.\
**Unboxing**: Conversion of a wrapper class object back into its corresponding primitive.

Java performs this automatically in most cases, known as **autoboxing** and **auto-unboxing**.

1. **Boxing**:
   * Wraps a primitive in its corresponding reference type (e.g., `int` to `Integer`).
   * Enables primitives to be used in collections, generics, and objects.

**Example**:

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(5); // Autoboxing: int -> Integer
```

2. **Unboxing**:
   * Extracts the primitive value from its wrapper.
   * Common in arithmetic operations or assignments.

**Example**:

```java
Integer wrappedInt = 10;
int primitiveInt = wrappedInt; // Auto-unboxing: Integer -> int
```

## **Best Practices Compared to Primitive Types**

While reference types offer flexibility and additional features, they come with performance trade-offs compared to primitives. Below are some best practices to consider:

### **1. Use primitives for performance-critical operations**

* Primitives are faster as they store raw values and avoid heap memory usage.
* Wrappers incur boxing/unboxing overhead and additional memory allocation.

**Example**:

```java
int sum = 0; // Faster
Integer boxedSum = 0; // Slower due to boxing/unboxing
```

### **2. Use wrappers for collections and nullability**

* Wrapper classes (`Integer`, `Double`, etc.) allow null values, enabling better handling of optional data.
* Essential for generics as Java collections cannot work with primitives directly.

**Example**:

```java
List<Integer> scores = new ArrayList<>();
scores.add(null); // Allowed with Integer
```

### **3. Avoid unnecessary boxing/unboxing**

* Frequent boxing/unboxing in loops or arithmetic can degrade performance.
* Use primitives directly where possible.

**Example (Avoid Boxing)**:

```java
Integer total = 0;
for (int i = 0; i < 100; i++) {
    total += i; // Unnecessary boxing/unboxing
}
// Better:
int totalPrimitive = 0;
for (int i = 0; i < 100; i++) {
    totalPrimitive += i; // No overhead
}
```

### **4. Prefer `Optional` over null**

* Instead of using wrapper types to handle nulls, consider using `Optional` for better readability and safety.

**Example**:

```java
Optional<Integer> optionalValue = Optional.ofNullable(null);
optionalValue.ifPresent(value -> System.out.println(value));
```

### **5. Use caching for frequently used values**

* Wrapper classes like `Integer` cache commonly used values (e.g., `-128 to 127`).
* Avoid creating unnecessary new objects.

**Example**:

```java
Integer a = 100; // Uses cached object
Integer b = 100;
System.out.println(a == b); // true
```

### **6. Understand memory implications**

* Primitives are stack-allocated, while wrapper objects are heap-allocated.
* Use profiling tools to identify unnecessary memory usage.

**Example (Memory Efficiency)**:

```java
int[] nums = new int[1000]; // 1000 primitives in stack
Integer[] wrappedNums = new Integer[1000]; // 1000 objects in heap
```



