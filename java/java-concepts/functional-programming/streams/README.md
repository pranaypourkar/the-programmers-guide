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

## **Stream Operations Overview**

Java Streams API consists of **Intermediate** and **Terminal** operations that work together to process data efficiently. Understanding these operations and the **Stream Pipeline** is essential for writing clean, functional, and performant code.

### **1. What Are Intermediate and Terminal Operations?**

Stream operations are categorized into two types:

1. **Intermediate Operations** – Transform a stream and return a new Stream. They are **lazy** (executed only when a terminal operation is called).
2. **Terminal Operations** – Consume the stream and **produce a result** (such as a collection, count, or boolean value). Terminal operations **trigger** execution of intermediate operations.

#### **Intermediate Operations (Lazy and Return a Stream)**

These operations **do not process elements immediately**; instead, they build up a pipeline and execute only when a **terminal operation** is encountered.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>filter(Predicate&#x3C;T>)</code></td><td>Filters elements based on a condition.</td></tr><tr><td><code>map(Function&#x3C;T, R>)</code></td><td>Transforms each element in the stream.</td></tr><tr><td><code>flatMap(Function&#x3C;T, Stream&#x3C;R>>)</code></td><td>Flattens multiple nested streams into a single stream.</td></tr><tr><td><code>distinct()</code></td><td>Removes duplicate elements.</td></tr><tr><td><code>sorted(Comparator&#x3C;T>)</code></td><td>Sorts elements in natural or custom order.</td></tr><tr><td><code>peek(Consumer&#x3C;T>)</code></td><td>Debugging tool; applies an action to each element.</td></tr><tr><td><code>limit(n)</code></td><td>Limits the number of elements in the stream.</td></tr><tr><td><code>skip(n)</code></td><td>Skips the first <code>n</code> elements.</td></tr></tbody></table>

#### **Terminal Operations (Trigger Execution and Produce a Result)**

Once a terminal operation is called, the stream pipeline is **executed in one pass** and cannot be reused.

<table data-header-hidden data-full-width="true"><thead><tr><th width="377"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>forEach(Consumer&#x3C;T>)</code></td><td>Iterates over each element.</td></tr><tr><td><code>collect(Collector&#x3C;T, A, R>)</code></td><td>Converts stream elements into a collection (List, Set, Map).</td></tr><tr><td><code>count()</code></td><td>Returns the total number of elements.</td></tr><tr><td><code>reduce(BinaryOperator&#x3C;T>)</code></td><td>Aggregates elements into a single result (sum, max, etc.).</td></tr><tr><td><code>min(Comparator&#x3C;T>)</code></td><td>Finds the minimum element.</td></tr><tr><td><code>max(Comparator&#x3C;T>)</code></td><td>Finds the maximum element.</td></tr><tr><td><code>anyMatch(Predicate&#x3C;T>)</code></td><td>Checks if <strong>at least one</strong> element matches the condition.</td></tr><tr><td><code>allMatch(Predicate&#x3C;T>)</code></td><td>Checks if <strong>all</strong> elements match the condition.</td></tr><tr><td><code>noneMatch(Predicate&#x3C;T>)</code></td><td>Checks if <strong>no elements</strong> match the condition.</td></tr><tr><td><code>toArray()</code></td><td>Converts a stream into an array.</td></tr></tbody></table>

### **2. Understanding the Stream Pipeline**

A **Stream Pipeline** consists of **three stages**:

#### **1. Data Source**

A stream is created from a data source like a **Collection, Array, or I/O Channel**.

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "David");
Stream<String> stream = names.stream();
```

#### **2. Intermediate Operations (Lazy)**

Intermediate operations **transform** the data but do **not execute immediately**.

```java
Stream<String> filteredStream = stream.filter(name -> name.startsWith("A"));
Stream<String> mappedStream = filteredStream.map(String::toUpperCase);
```

{% hint style="success" %}
**No execution happens yet because Streams are lazy**
{% endhint %}

#### **3. Terminal Operation (Triggers Execution)**

Once a terminal operation is called, the pipeline is **executed in a single pass**.

```java
List<String> result = mappedStream.collect(Collectors.toList());
System.out.println(result);
```

**Now execution happens!** The output will be:

```
[Alice]
```

#### &#x20;**Complete Stream Pipeline Example**

```java
List<String> names = List.of("Alice", "Bob", "Charlie", "David");

List<String> result = names.stream()
                           .filter(name -> name.startsWith("A"))   // Intermediate
                           .map(String::toUpperCase)               // Intermediate
                           .sorted()                               // Intermediate
                           .collect(Collectors.toList());         // Terminal

System.out.println(result);  // Output: [ALICE]
```

#### **Pipeline Execution Order (Optimization)**

Streams process data **in one pass**, applying operations **only to elements that reach the terminal operation.**

```java
// Example
List<String> names = List.of("Alice", "Bob", "Charlie", "David");
names.stream()
     .filter(name -> {
         System.out.println("Filtering: " + name);
         return name.startsWith("A");
     })
     .map(name -> {
         System.out.println("Mapping: " + name);
         return name.toUpperCase();
     })
     .collect(Collectors.toList());
 // Notice that only "Alice" reaches map(). The rest are skipped after filter().
 // Output
```

```
Filtering: Alice
Mapping: Alice
Filtering: Bob
Filtering: Charlie
Filtering: David
```

## **Creating Streams in Java**

Java provides multiple ways to create streams from different data sources, such as **Collections, Arrays, and Generators**.

### **1. Creating Streams from Collections**

Java Collections (like `List`, `Set`) have a built-in `stream()` method that allows easy stream creation.

<pre class="language-java"><code class="lang-java">// Example: Creating a Stream from a List
List&#x3C;String> names = List.of("Alice", "Bob", "Charlie", "David");
Stream&#x3C;String> nameStream = names.stream();
nameStream.forEach(System.out::println);

// Output
<strong>// Alice  
</strong>// Bob  
// Charlie  
// David 
</code></pre>

#### **Parallel Stream from a Collection**

If we want to process elements **in parallel**, use `parallelStream()`. **Parallel streams are useful for large datasets** but can have overhead for small ones.

```java
Stream<String> parallelStream = names.parallelStream();
```

### **2. Creating Streams from Arrays**

We can create a stream from an array using `Arrays.stream()` or `Stream.of()`.

```java
// Example: Creating a Stream from an Array
String[] colors = {"Red", "Green", "Blue"};
Stream<String> colorStream = Arrays.stream(colors);
colorStream.forEach(System.out::println);

// Red  
// Green  
// Blue 
```

#### **Stream from a Primitive Array**

Use `IntStream`, `LongStream`, or `DoubleStream` for primitives:

```java
int[] numbers = {1, 2, 3, 4, 5};
IntStream intStream = Arrays.stream(numbers);
intStream.forEach(System.out::print);
// 12345
```

### **3. Using `Stream.of()`, `Stream.generate()`, and `Stream.iterate()`**

#### **`Stream.of()` – Creating Streams from Values**

The `Stream.of()` method can be used to create a stream from multiple values.

```java
Stream<String> stream = Stream.of("Java", "Python", "C++");
stream.forEach(System.out::println);
// Java  
// Python  
// C++
```

#### **`Stream.generate()` – Infinite Stream with Supplier**

`Stream.generate()` produces an **infinite stream** using a `Supplier<T>`.

<pre class="language-java"><code class="lang-java"><strong>// limit(n) is necessary to prevent infinite execution.
</strong><strong>Stream&#x3C;Double> randomStream = Stream.generate(Math::random).limit(5);
</strong>randomStream.forEach(System.out::println);

// Output: (Random values each time)
// 0.78965  
// 0.23451  
// 0.98732  
// 0.45678  
// 0.12345 
</code></pre>

#### **`Stream.iterate()` – Infinite Stream with Iteration**

`Stream.iterate()` generates an **infinite stream** using a function and an initial value.

```java
Stream<Integer> evenNumbers = Stream.iterate(2, n -> n + 2).limit(5);
evenNumbers.forEach(System.out::println);

// 2  
// 4  
// 6  
// 8  
// 10  
```

🔹 **Java 9+ introduced a predicate-based `Stream.iterate()`**

```java
Stream.iterate(2, n -> n < 20, n -> n * 2).forEach(System.out::println);
// 2  
// 4  
// 8  
// 16  
```

## **Intermediate Operations in Java Streams**

Intermediate operations **transform** a stream and return another **stream**. They are **lazy**—executing only when a terminal operation is called.

### **1. Filtering with `filter()`**

Used to **retain** elements that satisfy a condition.

```java
List<Integer> numbers = List.of(10, 15, 20, 25, 30);
Stream<Integer> filteredStream = numbers.stream().filter(n -> n > 15);
filteredStream.forEach(System.out::println);

/*
Output:
20
25
30
*/
```

### **2. Transforming with `map()`**

Used to **transform** each element in a stream.

```java
List<String> names = List.of("john", "jane", "doe");
Stream<String> upperCaseNames = names.stream().map(String::toUpperCase);
upperCaseNames.forEach(System.out::println);

/*
Output:
JOHN
JANE
DOE
*/
```

### **3. Flattening with `flatMap()`**

Used when elements themselves contain **collections**—it flattens them into a single stream.

```java
List<List<String>> listOfLists = List.of(
    List.of("A", "B"),
    List.of("C", "D")
);
Stream<String> flattenedStream = listOfLists.stream().flatMap(List::stream);
flattenedStream.forEach(System.out::println);

/*
Output:
A
B
C
D
*/
```

### **4. Removing Duplicates with `distinct()`**

Removes **duplicate** elements based on `.equals()`.

```java
List<Integer> nums = List.of(1, 2, 2, 3, 3, 4, 5, 5);
Stream<Integer> uniqueStream = nums.stream().distinct();
uniqueStream.forEach(System.out::print);

/*
Output:
12345
*/
```

### **5. Sorting Elements with `sorted()`**

Sorts elements **naturally** or using a **custom comparator**.

```java
List<String> words = List.of("banana", "apple", "cherry");
Stream<String> sortedStream = words.stream().sorted();
sortedStream.forEach(System.out::println);

/*
Output:
apple
banana
cherry
*/
```

#### **Custom Sorting**

```java
Stream<String> reverseSortedStream = words.stream().sorted(Comparator.reverseOrder());
reverseSortedStream.forEach(System.out::println);

/*
Output:
cherry
banana
apple
*/
```

### **6. Debugging with `peek()`**

Useful for **debugging**—allows inspecting elements **without modifying them**.

```java
List<Integer> values = List.of(1, 2, 3, 4);
Stream<Integer> debugStream = values.stream()
    .peek(n -> System.out.println("Before filter: " + n))
    .filter(n -> n % 2 == 0)
    .peek(n -> System.out.println("After filter: " + n));

debugStream.forEach(System.out::println);

/*
Output:
Before filter: 1
Before filter: 2
After filter: 2
2
Before filter: 3
Before filter: 4
After filter: 4
4
*/
```

## **Terminal Operations in Java Streams**

Terminal operations **consume** the stream and **produce a result** (e.g., a collection, a value, or a side effect). After a terminal operation, the stream **cannot be reused**.

### **1. Iterating with `forEach()`**

Executes an action for each element in the stream.

{% hint style="success" %}
**Note:** Avoid using `forEach()` for modifying elements since streams are immutable.
{% endhint %}

```java
List<String> names = List.of("Alice", "Bob", "Charlie");
names.stream().forEach(System.out::println);

/*
Output:
Alice
Bob
Charlie
*/
```

### **2. Collecting with `collect()`**

Converts the stream into a **collection** (List, Set, Map) or another structure.

```java
List<String> names = List.of("Alice", "Bob", "Charlie");
List<String> upperCaseNames = names.stream()
    .map(String::toUpperCase)
    .collect(Collectors.toList());
System.out.println(upperCaseNames);
/*
Output:
[ALICE, BOB, CHARLIE]
*/

Set<String> uniqueNames = names.stream().collect(Collectors.toSet());
System.out.println(uniqueNames);
/*
Output:
[Alice, Bob, Charlie]
(Order may vary since Set does not guarantee order)
*/

Set<String> sortedNames = names.stream()
    .collect(Collectors.toCollection(TreeSet::new));
System.out.println(sortedNames);
/*
Output:
[Alice, Bob, Charlie]
(Natural sorting applied)
*/

Map<String, Integer> nameLengthMap = names.stream()
    .collect(Collectors.toMap(name -> name, String::length));
System.out.println(nameLengthMap);
/*
Output:
{Alice=5, Bob=3, Charlie=7}
*/

// If duplicate keys exist, we must provide a merge function to handle collisions.
List<String> words = List.of("apple", "banana", "apple", "orange");
Map<String, Integer> wordCount = words.stream()
    .collect(Collectors.toMap(
        word -> word,  // Key: Word itself
        word -> 1,  // Value: Initial count
        Integer::sum // Merge function: Sum duplicate values
    ));
System.out.println(wordCount);
/*
Output:
{apple=2, banana=1, orange=1}
*/
```

#### **Grouping elements**

The `Collectors.groupingBy()` method **groups elements** of a stream based on a classifier function and returns a `Map<K, List<T>>`, where:

* **K** → The grouping key (e.g., length of a string).
* **List\<T>** → The list of elements sharing the same key.

{% hint style="info" %}
**Basic Syntax**

`Collectors.groupingBy(classifier)`

**classifier** → A function that determines the grouping key.



**Syntax with Downstream Collector**

`Collectors.groupingBy(classifier, downstreamCollector)`

**downstreamCollector** → Used for further operations like counting, mapping, or reducing.

\
**Syntax with Custom Map Type**

`Collectors.groupingBy(classifier, mapFactory, downstreamCollector)`

**mapFactory** → Specifies the type of `Map<K, List<T>>` (e.g., `TreeMap` instead of `HashMap`).
{% endhint %}

```java
Map<Integer, List<String>> groupedByLength = names.stream()
    .collect(Collectors.groupingBy(String::length));
System.out.println(groupedByLength);
/*
Output:
{3=[Bob], 5=[Alice], 7=[Charlie]}
*/

List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6);
Map<String, List<Integer>> groupedByEvenOdd = numbers.stream()
    .collect(Collectors.groupingBy(n -> n % 2 == 0 ? "Even" : "Odd"));
System.out.println(groupedByEvenOdd);
/*
Output:
{Odd=[1, 3, 5], Even=[2, 4, 6]}
*/

// If we want to count how many elements fall into each group
Map<Integer, Long> lengthCounts = names.stream()
    .collect(Collectors.groupingBy(String::length, Collectors.counting()));
System.out.println(lengthCounts);
/*
Output:
{3=1, 5=1, 7=1}
*/
```

### **3. Counting with `count()`**

Counts the number of elements in a stream.

```java
List<Integer> numbers = List.of(10, 20, 30, 40);
long count = numbers.stream().count();
System.out.println(count);
/*
Output:
4
*/
```

### **4. Finding Min/Max with `min()` and `max()`**

Finds the **smallest** or **largest** element based on a comparator.

```java
List<Integer> numbers = List.of(10, 20, 30, 40);
Optional<Integer> minValue = numbers.stream().min(Integer::compareTo);
Optional<Integer> maxValue = numbers.stream().max(Integer::compareTo);

System.out.println("Min: " + minValue.orElse(-1));
System.out.println("Max: " + maxValue.orElse(-1));

/*
Output:
Min: 10
Max: 40
*/
```

### **5. Reducing with `reduce()`**

It is used to **combine elements** of a stream into a single result. It performs **reduction** using an **accumulator function**, optionally with an **identity value** and/or a **combiner function**.

{% hint style="info" %}
**Syntax of `reduce()`**

#### **1. Without Identity (Returns `Optional<T>`)**

```java
Optional<T> reduce(BinaryOperator<T> accumulator)
```

* **Used when no default value is needed.**
* Returns an **`Optional<T>`** because the stream could be empty.

***

#### **2. With Identity (Returns `T`)**

```java
T reduce(T identity, BinaryOperator<T> accumulator)
```

* **Identity** → A default value used when the stream is empty.
* **Accumulator** → A function to combine elements.

***

#### **3. With Identity and Combiner (For Parallel Streams)**

```java
<U> U reduce(U identity, BiFunction<U, ? super T, U> accumulator, BinaryOperator<U> combiner)
```

* **Accumulator** → Processes each element.
* **Combiner** → Merges results (used in parallel streams).
{% endhint %}

#### **Sum of all elements**

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);
int sum = numbers.stream().reduce(0, Integer::sum);
System.out.println(sum);

/*
Output:
15
*/
```

#### **Concatenating Strings**

```java
List<String> words = List.of("Java", "Streams", "Example");
String sentence = words.stream().reduce("", (a, b) -> a + " " + b);
System.out.println(sentence.trim());

/*
Output:
Java Streams Example
*/
```

### **6. Matching Elements with `anyMatch()`, `allMatch()`, `noneMatch()`**

Used to **test conditions** on elements.

#### **`anyMatch()` – At least one element matches**

```java
List<String> names = List.of("Alice", "Bob", "Charlie");
boolean hasShortName = names.stream().anyMatch(name -> name.length() == 3);
System.out.println(hasShortName);

/*
Output:
true
*/
```

#### **`allMatch()` – All elements match**

```java
boolean allStartWithA = names.stream().allMatch(name -> name.startsWith("A"));
System.out.println(allStartWithA);

/*
Output:
false
*/
```

#### **`noneMatch()` – No elements match**

```java
boolean noneStartWithZ = names.stream().noneMatch(name -> name.startsWith("Z"));
System.out.println(noneStartWithZ);

/*
Output:
true
*/
```

## **Parallel Streams in Java**

Parallel Streams in Java allow for **concurrent processing** of data by utilizing multiple CPU cores. This enables faster execution for large datasets by dividing the workload across threads in the **Fork/Join framework**.

### **1. What are Parallel Streams?**

A **parallel stream** processes elements **simultaneously** in multiple threads rather than sequentially. It **splits** the data into **smaller chunks** and processes them in parallel using Java's **ForkJoinPool**.

#### **How to Create a Parallel Stream?**

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);

// Creating a parallel stream. Elements are processed on different threads instead of one.
numbers.parallelStream()
    .forEach(n -> System.out.println(n + " " + Thread.currentThread().getName()));

/*
Output (order may vary):
1 ForkJoinPool.commonPool-worker-1
2 ForkJoinPool.commonPool-worker-2
3 main
4 ForkJoinPool.commonPool-worker-3
5 ForkJoinPool.commonPool-worker-4
*/
```

### **2. When to Use Parallel Streams?**

Parallel streams are **useful** when:\
**Large datasets** → Parallelism benefits large collections.\
**Independent tasks** → Operations should not depend on each other.\
**CPU-intensive tasks** → Parallel execution benefits **complex computations**.\
**Multi-core processors** → Takes advantage of **multi-threading**.

#### **Example: Using Parallel Stream for Sum Calculation**

```java
List<Integer> numbers = List.of(1, 2, 3, 4, 5);

// Uses reduce() in parallel for summing elements.
int sum = numbers.parallelStream()
    .reduce(0, Integer::sum);

System.out.println(sum); // Output: 15
```

### **3. Performance Considerations for Parallel Execution**

While parallel streams **improve performance**, they have **overhead costs**. Consider:

#### **When Parallel Streams are Beneficial:**

✔ **CPU-bound operations** → Complex computations (e.g., matrix multiplication).\
✔ **Large collections** → Overhead is negligible when processing thousands of elements.\
✔ **Stateless operations** → Operations do not modify shared data.

#### **When NOT to Use Parallel Streams:**

✖ **Small datasets** → Thread management overhead outweighs benefits.\
✖ **I/O-bound tasks** → Parallel execution does not speed up database or network calls.\
✖ **Mutable shared state** → Can cause race conditions and inconsistent results.

#### **Example: Incorrect Use of Parallel Streams (Race Condition)**

<pre class="language-java"><code class="lang-java"><strong>// Problem: ArrayList is not thread-safe, so concurrent modifications may cause data corruption.
</strong><strong>List&#x3C;Integer> numbers = List.of(1, 2, 3, 4, 5);
</strong>
List&#x3C;Integer> results = new ArrayList&#x3C;>();

numbers.parallelStream().forEach(n -> results.add(n * 2));

System.out.println(results); // Output may be inconsistent (due to race conditions)
</code></pre>

```java
// Fix: Use ConcurrentLinkedQueue Instead
ConcurrentLinkedQueue<Integer> results = new ConcurrentLinkedQueue<>();

numbers.parallelStream().forEach(n -> results.add(n * 2));

System.out.println(results);
```

## **Primitive Streams (IntStream, LongStream, DoubleStream)**

Java provides specialized **primitive streams** (`IntStream`, `LongStream`, `DoubleStream`) to efficiently process numerical data without the overhead of boxing/unboxing found in `Stream<Integer>`, `Stream<Long>`, and `Stream<Double>`.

### **1. Why Use Primitive Streams?**

Using `Stream<Integer>` creates unnecessary **autoboxing** (conversion from `int` to `Integer`), which **impacts performance**.

```java
Stream<Integer> numberStream = Stream.of(1, 2, 3, 4, 5);
int sum = numberStream.mapToInt(Integer::intValue).sum();  // Converts to IntStream
```

Instead of using `Stream<Integer>`, we can directly use `IntStream.` `IntStream` avoids `Integer` objects, reducing memory usage.

```java
IntStream numberStream = IntStream.of(1, 2, 3, 4, 5);
int sum = numberStream.sum();  // More efficient
```

### **2. Creating and Processing Primitive Streams**

#### **2.1 Creating Primitive Streams**

Primitive streams can be created from **arrays, ranges, or generators**.

**(a) From Arrays**

```java
int[] numbers = {1, 2, 3, 4, 5};
IntStream streamFromArray = Arrays.stream(numbers);
```

**(b) Using `IntStream.of()` and `range()`**

```java
IntStream stream = IntStream.of(1, 2, 3, 4, 5);  // From values
IntStream rangeStream = IntStream.range(1, 6);   // 1 to 5 (excludes 6)
IntStream rangeClosedStream = IntStream.rangeClosed(1, 5); // 1 to 5 (inclusive)
```

**(c) Using `generate()` and `iterate()`**

```java
IntStream randomInts = IntStream.generate(() -> new Random().nextInt(100)).limit(5);
IntStream evenNumbers = IntStream.iterate(2, n -> n + 2).limit(5);
```

🔹 **`generate()`** generates infinite values (hence `limit(5)`).\
🔹 **`iterate()`** applies a function (`n -> n + 2`) to generate values.

### **3. Specialized Operations for Numeric Streams**

Primitive streams provide specialized **numeric operations** that are **not available in normal `Stream<T>`**.

#### **3.1 Summing Elements (`sum()`)**

```java
// More efficient than reduce(0, Integer::sum)
int total = IntStream.of(1, 2, 3, 4, 5).sum();
System.out.println(total); // Output: 15
```

#### **3.2 Finding Min and Max (`min()`, `max()`)**

```java
OptionalInt min = IntStream.of(3, 1, 4, 5, 2).min();
OptionalInt max = IntStream.of(3, 1, 4, 5, 2).max();
System.out.println(min.getAsInt() + ", " + max.getAsInt()); // Output: 1, 5
```

#### **3.3 Finding the Average (`average()`)**

```java
OptionalDouble avg = IntStream.of(1, 2, 3, 4, 5).average();
System.out.println(avg.getAsDouble()); // Output: 3.0
```

#### **3.4 Collecting Statistics (`summaryStatistics()`)**

```java
// Provides count, sum, min, max, and average in one call.
IntSummaryStatistics stats = IntStream.of(1, 2, 3, 4, 5).summaryStatistics();
System.out.println(stats);
/*
Output:
IntSummaryStatistics{count=5, sum=15, min=1, average=3.000000, max=5}
*/
```

#### **3.5 Boxing Back to `Stream<Integer>` (`boxed()`)**

The `boxed()` method is used to **convert a primitive stream** (`IntStream`, `LongStream`, or `DoubleStream`) **into a stream of wrapper objects** (`Stream<Integer>`, `Stream<Long>`, `Stream<Double>`). Primitive streams (`IntStream`, `LongStream`, `DoubleStream`) provide **specialized operations** like `sum()`, `min()`, `average()`, and `summaryStatistics()`, but they **cannot be used with collectors like `Collectors.toList()`** because collectors expect **a Stream of objects (`Stream<T>`)**.

<pre class="language-java"><code class="lang-java"><strong>// Converts IntStream → Stream&#x3C;Integer>.
</strong><strong>Stream&#x3C;Integer> boxedStream = IntStream.range(1, 5).boxed();
</strong>boxedStream.forEach(System.out::println); // Output: 1 2 3 4
</code></pre>

## **Working with `Collectors` (Collectors Utility Class)**

The `Collectors` class in Java **(java.util.stream.Collectors)** provides a set of predefined collectors that can be used to accumulate elements from a stream into various data structures such as **List, Set, Map, or even summary statistics**. It is widely used with the `collect()` terminal operation.

### **1. Collecting to `List`, `Set`, and `Map`**

#### **Collecting Stream Elements into a `List`**

The `Collectors.toList()` method collects elements into a `List<>`.

```java
List<String> names = Stream.of("Alice", "Bob", "Charlie")
                           .collect(Collectors.toList());
System.out.println(names);
/*
Output:
[Alice, Bob, Charlie]
*/
```

#### **Collecting Stream Elements into a `Set`**

The `Collectors.toSet()` method collects elements into a `Set<>`, which **removes duplicates** and does **not guarantee order**.

```java
Set<String> uniqueNames = Stream.of("Alice", "Bob", "Charlie", "Alice")
                                .collect(Collectors.toSet());
System.out.println(uniqueNames);
/*
Output (Order may vary):
[Alice, Bob, Charlie]
*/
```

#### **Collecting Stream Elements into a `Map`**

The `Collectors.toMap()` method collects elements into a `Map<>` with **a key-value mapping function**.

```java
Map<Integer, String> nameMap = Stream.of("Alice", "Bob", "Charlie")
                                     .collect(Collectors.toMap(String::length, name -> name));
System.out.println(nameMap);
/*
Output (may vary):
{3=Bob, 5=Alice, 7=Charlie}
*/
```

**Key = String length, Value = String itself**\
If duplicate keys exist, it throws an exception unless a **merge function** is provided.

```java
// Use a merge function to handle duplicate keys.
Map<Integer, String> nameMap = Stream.of("Alice", "Bob", "Charlie", "David")
    .collect(Collectors.toMap(String::length, name -> name, (existing, replacement) -> existing));
System.out.println(nameMap);
/*
Output (may vary):
{3=Bob, 5=Alice, 7=Charlie}
*/
```

### **2. Grouping and Partitioning Data**

#### **Grouping Elements using `groupingBy()`**

The `Collectors.groupingBy()` method groups elements by a classifier function.

```java
Collectors.groupingBy(Function<? super T, ? extends K> classifier)
Collectors.groupingBy(Function<? super T, ? extends K> classifier, Collector<? super T, A, D> downstream)
Collectors.groupingBy(Function<? super T, ? extends K> classifier, Supplier<Map<K, List<T>>> mapFactory, Collector<? super T, A, D> downstream)
```

```java
// Basic Grouping
Map<Integer, List<String>> groupedByLength = Stream.of("Alice", "Bob", "Charlie")
    .collect(Collectors.groupingBy(String::length));
System.out.println(groupedByLength);
/*
Output:
{3=[Bob], 5=[Alice], 7=[Charlie]}
*/

// Grouping with Downstream Collector
List<String> words = Arrays.asList("apple", "bat", "banana", "cat", "dog", "elephant");
Map<Integer, Set<String>> groupedByLength = words.stream()
    .collect(Collectors.groupingBy(String::length, Collectors.toSet()));
// {3=[bat, cat, dog], 5=[apple], 6=[banana], 8=[elephant]}

// Grouping and Counting Elements
Map<Integer, Long> groupedByLengthCount = words.stream()
    .collect(Collectors.groupingBy(String::length, Collectors.counting()));
// {3=3, 5=1, 6=1, 8=1}    

// Grouping with Custom Map (LinkedHashMap) to maintain insertion order and counts occurrences
Map<Integer, LinkedHashMap<String, Long>> groupedWithCount = words.stream()
    .collect(Collectors.groupingBy(
        String::length, 
        LinkedHashMap::new, 
        Collectors.mapping(word -> word, Collectors.toMap(w -> w, w -> 1L, Long::sum, LinkedHashMap::new))
    ));
// {5={apple=1}, 3={bat=1, cat=1, dog=1}, 6={banana=1}, 8={elephant=1}}
```

Groups names based on **length**.\
Returns a `Map<Integer, List<String>>` where the key is the length and the value is a list of names.

#### **Partitioning Elements using `partitioningBy()`**

The `Collectors.partitioningBy()` method divides elements into two groups (true/false) based on a predicate. It is used when data needs to be divided into two categories.

```java
Map<Boolean, List<Integer>> partitioned = Stream.of(10, 15, 20, 25, 30)
    .collect(Collectors.partitioningBy(n -> n % 2 == 0));
System.out.println(partitioned);
/*
Output:
{false=[15, 25], true=[10, 20, 30]}
*/
```

Two partitions:

* `true` → Even numbers
* `false` → Odd numbers

### **3. Summarizing Data with `Collectors`**

#### **Summing Elements using `summingInt()`**

```java
int total = Stream.of(5, 10, 15, 20)
                  .collect(Collectors.summingInt(n -> n));
System.out.println(total);
/*
Output:
50
*/
```

#### **Calculating Average using `averagingInt()`**

```java
double avg = Stream.of(5, 10, 15, 20)
                   .collect(Collectors.averagingInt(n -> n));
System.out.println(avg);
/*
Output:
12.5
*/
```

#### **Getting Summary Statistics using `summarizingInt()`**

```java
IntSummaryStatistics stats = Stream.of(5, 10, 15, 20)
    .collect(Collectors.summarizingInt(n -> n));
System.out.println(stats);
/*
Output:
IntSummaryStatistics{count=4, sum=50, min=5, average=12.500000, max=20}
*/
```
