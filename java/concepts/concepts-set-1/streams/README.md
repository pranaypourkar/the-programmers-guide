# Streams

## About

Java Streams, introduced in Java 8, revolutionized how developers process collections and sequences of data. They provide a modern, functional approach to handling data manipulation tasks, making code more concise, readable, and expressive.

## What Are Streams?

Java **Streams API** is a powerful abstraction introduced in **Java 8** that allows functional-style operations on **collections, arrays, or I/O resources**. It enables **declarative** and **parallel** processing of data, making it easier to work with large datasets efficiently.

A **Stream** is a **sequence of elements** that supports various operations such as filtering, mapping, and reducing, without modifying the original data source.

{% hint style="success" %}
Streams reduce boilerplate code and improve readability
{% endhint %}

### **Example: Traditional Loop vs Stream Processing**

#### **Without Streams (Imperative Approach)**

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "David");
List<String> filteredNames = new ArrayList<>();
for (String name : names) {
    if (name.startsWith("A")) {
        filteredNames.add(name);
    }
}
System.out.println(filteredNames); // [Alice]
```

#### **With Streams (Declarative Approach)**

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "David");
List<String> filteredNames = names.stream()
                                  .filter(name -> name.startsWith("A"))
                                  .collect(Collectors.toList());
System.out.println(filteredNames); // [Alice]
```

## **Why use Streams?**

Streams offer several advantages over traditional iterative approaches (e.g., `for` loops):

1. **Readability**: Streams allow us to write code in a declarative style, focusing on **what** needs to be done rather than **how** to do it.
2. **Conciseness**: Streams reduce boilerplate code, making programs shorter and easier to maintain.
3. **Functional Programming**: Streams support functional programming constructs like lambda expressions and method references, enabling cleaner and more modular code.
4. **Parallel Processing**: Streams can easily be parallelized using the `parallelStream()` method, allowing efficient utilization of multi-core processors for large datasets.
5. **Lazy Evaluation**: Intermediate operations (e.g., `filter`, `map`) are only executed when a terminal operation (e.g., `collect`, `forEach`) is invoked. This improves performance by avoiding unnecessary computations.
6. **Immutability**: Streams do not modify the source data, promoting immutability and reducing side effects.

## **Key Characteristics of Streams**

### **1. Streams Do Not Store Data**

Streams **operate on a source** (Collection, Array, or I/O resource) and process data **without storing** it.

{% hint style="success" %}
&#x20;**No additional memory overhead** since it processes elements on-demand.
{% endhint %}

```java
Stream<String> stream = List.of("One", "Two", "Three").stream();
```

### **2. Streams Are Functional in Nature**

Streams allow **functional transformations** using methods like `map()`, `filter()`, and `reduce()`, without modifying the original data.

{% hint style="success" %}
**Original list remains unchanged.**
{% endhint %}

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);
List<Integer> squaredNumbers = numbers.stream()
                                      .map(n -> n * n)
                                      .collect(Collectors.toList());
```

### **3. Streams Are Lazy (Lazy Evaluation)**

Intermediate operations (`filter()`, `map()`) are **executed only when a terminal operation** (`collect()`, `forEach()`) is called.

{% hint style="success" %}
**Reduces unnecessary computations.**
{% endhint %}

```java
Stream<Integer> stream = List.of(1, 2, 3, 4, 5).stream()
                                               .filter(n -> {
                                                   System.out.println("Filtering: " + n);
                                                   return n > 2;
                                               });
System.out.println("No execution yet!");
stream.forEach(System.out::println);  // Now filtering starts
```

### **4. Streams Support Parallel Execution**

Streams support **parallel execution** via `.parallelStream()`, allowing tasks to be executed concurrently.

{% hint style="success" %}
**Utilizes multiple CPU cores** for faster processing.
{% endhint %}

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);
numbers.parallelStream().forEach(System.out::println);
```

### **5. Streams Support Pipeline Processing**

Streams allow **chained operations** where the output of one method is passed as input to the next.

{% hint style="success" %}
**Makes processing clear and structured.**
{% endhint %}

```java
List<String> names = List.of("John", "Jane", "Jack");
long count = names.stream()
                  .map(String::toUpperCase)
                  .filter(name -> name.startsWith("J"))
                  .count();
System.out.println(count);
```

### **6. Streams Have Two Types of Operations**

* **Intermediate Operations** (Return a Stream, lazy execution)
  * `filter()`, `map()`, `flatMap()`, `distinct()`, `sorted()`, `peek()`
* **Terminal Operations** (Trigger execution, consume the Stream)
  * `collect()`, `count()`, `forEach()`, `reduce()`, `min()`, `max()`

## Memory Usage

Memory usage by Java Streams is an important consideration, especially when dealing with large datasets or performance-critical applications. Streams are designed to be efficient, but their memory usage depends on several factors, including the data source, intermediate operations, and terminal operations.

### **Overview**

Streams themselves do not store data; they operate on a data source (e.g., a collection, array, or I/O channel). However, memory is used in the following ways:

**Data Source:** The memory usage of the data source (e.g., a collection or array) remains unchanged. Streams do not copy the data but instead provide a view or pipeline to process it.

**Intermediate Operations:** Intermediate operations (e.g., `filter`, `map`, `sorted`) create new streams but do not immediately process the data. They are lazily evaluated, meaning they only define the pipeline and do not consume memory until a terminal operation is invoked.

**Terminal Operations:** Terminal operations (e.g., `collect`, `forEach`, `reduce`) trigger the processing of the stream and may consume memory depending on the operation:

* Operations like `collect` may store results in a new collection.
* Operations like `reduce` or `forEach` process elements one at a time and typically use minimal additional memory.

**Parallel Streams:** Parallel streams divide the data into multiple chunks for concurrent processing, which may increase memory usage due to the overhead of managing multiple threads and intermediate results.

**Key Factors Affecting Memory Usage in Streams**

### **1️. Lazy Evaluation (Efficient Memory Usage)**

Streams process elements **only when needed**, reducing memory consumption compared to eager execution.

#### **Example: Lazy Execution (Efficient)**

<pre class="language-java"><code class="lang-java"><strong>// Memory Efficient → Elements are processed one by one, reducing memory load.
</strong><strong>Stream&#x3C;Integer> stream = Stream.of(1, 2, 3, 4, 5)
</strong>                               .map(n -> {
                                   System.out.println("Processing: " + n);
                                   return n * 2;
                               });
System.out.println("No processing yet!");
stream.forEach(System.out::println);
</code></pre>

#### **Example: Eager Execution (Memory-Intensive)**

```java
//  Higher Memory Usage → Stores the transformed list in memory.
List<Integer> list = Stream.of(1, 2, 3, 4, 5)
                           .map(n -> n * 2)
                           .collect(Collectors.toList()); // Stores all elements in memory
```

### **2️. Intermediate Operations and Memory Impact**

Intermediate operations (`map()`, `filter()`, `distinct()`, `sorted()`) **do not store** elements but **may require extra memory** under certain conditions.

**Operations with Minimal Memory Usage**

`map()`, `filter()`, `peek()` → Process elements one by one, no additional memory overhead.

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "David");
long count = names.stream()
                  .filter(name -> name.length() > 3)
                  .count(); // Uses constant memory O(1)
```

**Operations That Require More Memory**

`sorted()`, `distinct()`, `flatMap()` → Require extra memory for processing.

```java
List<Integer> numbers = List.of(5, 3, 1, 4, 2);
// Higher Memory Usage → Sorting requires holding all elements in memory to perform the sort operation.
List<Integer> sortedList = numbers.stream()
                                  .sorted() // Stores all elements in memory before sorting
                                  .collect(Collectors.toList());
```

### **3️. Parallel Streams and Memory Consumption**

Parallel Streams split data into **multiple threads** for faster execution but can **increase memory consumption** due to:

* **Thread creation overhead**
* **Higher temporary memory usage** for merging results

**Example: Memory Overhead in Parallel Streams**

```java
List<Integer> numbers = IntStream.range(1, 1000000)
                                 .parallel()
                                 .boxed()
                                 .collect(Collectors.toList());
```

{% hint style="success" %}
**Memory Usage Considerations**:

* Each thread holds **a portion of the dataset** in memory.
* More CPU threads = **more memory required**.
* Avoid **parallel streams for small datasets** (overhead is higher than benefit).
{% endhint %}

### **4️. Collecting Data (`collect()` & Memory Allocation)**

Using `collect()` stores **all stream elements in memory**, which can be problematic for **large datasets**.

**Example: Collecting Large Data**

```java
// High Memory Usage → Avoid collecting when possible.
List<Integer> bigList = IntStream.range(1, 1000000)
                                 .boxed()
                                 .collect(Collectors.toList()); // Stores 1M elements
```

**Better Approach: Use `forEach()` Instead**

```java
// Lower Memory Usage → No storage of elements.
IntStream.range(1, 1000000)
         .forEach(System.out::println); // Processes one element at a time
```

### **5️. Large Data Streams (Handling Gigabytes of Data)**

For large datasets (e.g., processing files, databases), **avoid materializing the entire dataset into memory**.

**1. Using `Stream.generate()` (Infinite Streams)**

Streams can generate **infinite sequences**, consuming memory **if not terminated**.

```java
// Memory Leak Risk → Use limit() to control size.
Stream<Double> infiniteStream = Stream.generate(Math::random); // Infinite stream
```

**Fix: Use `limit()` to Avoid Memory Overload**

```java
// Lower Memory Usage → Generates a finite dataset.
List<Double> limitedList = Stream.generate(Math::random)
                                 .limit(10) // Limits to 10 elements
                                 .collect(Collectors.toList());
```

**2. Streaming Large Files with `BufferedReader`**

Reading large files into a list causes **high memory usage**.

```java
// Problem: Huge files cause OutOfMemoryError.
List<String> lines = Files.readAllLines(Path.of("largefile.txt")); // Loads full file in memory
```

**Solution: Use `BufferedReader.lines()`**

```java
// Memory Efficient → Reads one line at a time.
Stream<String> fileStream = Files.lines(Path.of("largefile.txt")); // Processes line by line
fileStream.forEach(System.out::println);
```

### 6. Memory Allocation When Creating Multiple Streams

Each time we create a new Stream, memory is allocated for:

* **Stream object itself** (small overhead)
* **Pipeline of operations** (intermediate and terminal operations)
* **Data source reference** (list, array, file, etc.)

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);

// Creating multiple streams
Stream<Integer> stream1 = numbers.stream().map(n -> n * 2);
Stream<Integer> stream2 = numbers.stream().filter(n -> n % 2 == 0);
Stream<Integer> stream3 = numbers.stream().sorted();
```









