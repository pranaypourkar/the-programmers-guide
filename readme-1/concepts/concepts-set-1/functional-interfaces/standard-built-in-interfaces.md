---
description: Details about standard built-in functional interfaces in Java.
---

# Standard Built-In Interfaces

Java `java.util.function` package provides a set of built-in functional interfaces. Let's see some of the most commonly used.

### **Function\<T, R>**

* **Description:** This interface represents a function that takes one argument of type `T` and returns a result of type `R`.
* **Abstract method:** `R apply(T t)`
* **Common Use Cases:**
  * Data transformation: Convert one type of data to another (e.g., String to Integer, Integer to String).
  * Calculations: Perform operations on a single value (e.g., squaring a number, finding the absolute value).
* **Example:**

```java
Function<String, Integer> stringToInt = str -> Integer.parseInt(str);

String numberString = "10";
int number = stringToInt.apply(numberString); 
// Value of number will be 10
```



### **Predicate\<T>**

* **Description:** This interface represents a function that takes one argument of type `T` and returns a boolean value (true or false).
* **Abstract method:** `boolean test(T t)`
* **Common Use Cases:**
  * Filtering: Select elements from a collection based on a condition.
  * Validation: Check if an object meets specific criteria.
* **Example:**

```java
Predicate<Integer> isEven = num -> num % 2 == 0;

List<Integer> numbers = List.of(1, 2, 3, 4, 5);
numbers.stream()
        .filter(isEven)
        .forEach(System.out::println);
// Result output: 2 4
```



### **Consumer\<T>**

* **Description:** This interface represents a function that takes one argument of type `T` but doesn't return a value (void).
* **Abstract method:** `void accept(T t)`
* **Common Use Cases:**
  * Performing side effects: Printing to console, logging data, modifying state.
  * Iterating over collections and performing actions on each element.
* **Example:**

```java
Consumer<String> printString = str -> System.out.println(str);

printString.accept("Hello, world!"); 
// Result output: Hello, world!
```



### **Supplier\<T>**

* **Description:** This interface represents a function that **doesn't** take any arguments but returns a value of type `T`.
* **Abstract method:** `T get()`
* **Common Use Cases:**
  * Generating values: Creating new objects, initializing variables with random values.
  * Lazy evaluation: Delaying the creation of a value until it's actually needed.
* **Example:**

```java
Supplier<Double> randomDouble = Math::random;

double randomNumber = randomDouble.get();
System.out.println(randomNumber); 
// Result output: a random double between 0.0 and 1.0
```





{% hint style="info" %}
BiFunction, BiConsumer and BiPredicate follow a similar structure as their single-argument counterparts but operate on two arguments.
{% endhint %}

### **BiFunction\<T, U, R>**

* **Description:** Represents a function that takes two arguments of type `T` and `U` and returns a result of type `R`.
* **Abstract method:** `R apply(T t, U u)`
* **Common Use Cases:**
  * Combining values from two sources: Calculate the sum of two numbers, concatenate two strings.
  * Performing operations on pairs of elements: Comparing two objects based on multiple criteria.
* **Example:**

```java
BiFunction<Integer, Integer, Double> calculateArea = (width, height) -> (double) width * height;

int rectangleWidth = 5;
int rectangleHeight = 10;
double area = calculateArea.apply(rectangleWidth, rectangleHeight); 
// Result area will be 50.0
```



### **BiConsumer\<T, U>**

* **Description:** Represents a function that takes two arguments of type `T` and `U` but **doesn't** return a value (void).
* **Abstract method:** `void accept(T t, U u)`
* **Common Use Cases:**
  * Processing pairs of elements: Modifying two objects based on their relationship.
  * Logging: Logging two values together.
* **Example:**

```java
BiConsumer<String, Integer> printPersonInfo = (name, age) -> System.out.println(name + ", " + age);

String personName = "John";
int personAge = 35;

printPersonInfo.accept(personName, personAge); 
// Result output will be John, 35
```



### **BiPredicate\<T, U>**

* **Description:** Represents a function that takes two arguments of type `T` and `U` and returns a boolean value (true or false).
* **Abstract method:** `boolean test(T t, U u)`
* **Common Use Cases:**
  * Conditional logic involving two arguments: Checking if two elements are equal, comparing two objects based on multiple criteria.
  * Filtering based on two conditions: Selecting elements from a collection that satisfy conditions on both attributes.
* **Example:**

```java
BiPredicate<String, String> isEqualLength = (str1, str2) -> str1.equals(str2) && str1.length() == str2.length();

String strA = "hello";
String strB = "hello";

boolean areEqual = isEqualLength.test(strA, strB); 
// Result output will be true
```





{% hint style="info" %}
IntFunction\<R>, LongFunction\<R>, DoubleFunction\<R> (and their BiFunction counterparts) focus on working with primitive data types as inputs and returning a value of any type.
{% endhint %}

### IntFunction\<R>, LongFunction\<R>, DoubleFunction\<R>

* **Input type:** These interfaces take a primitive data type as an argument:
  * `IntFunction<R>`: Takes an `int` argument.
  * `LongFunction<R>`: Takes a `long` argument.
  * `DoubleFunction<R>`: Takes a `double` argument.
* **Return type:** They return a value of any type (`R`).
* **Common Use Cases:**
  * **Converting primitive values to objects:** These functions are useful when you need to create objects based on primitive data values.
  * **Performing operations with primitive inputs:** You can implement custom logic to operate on primitive data types and return objects as results.
* **Example:**

```java
IntFunction<String> intToString = num -> Integer.toString(num);

int number = 123;
String stringNumber = intToString.apply(number); 
// Result output will be "123"
```



### BiFunction\<int, U, R>, BiFunction\<long, U, R>, BiFunction\<double, U, R>

* `BiFunction<int, U, R>`: Takes two arguments, an `int` and one of any type (`U`), and returns a value of type `R`.
* `BiFunction<long, U, R>`: Takes two arguments, a `long` and one of any type (`U`), and returns a value of type `R`.
* `BiFunction<double, U, R>`: Takes two arguments, a `double` and one of any type (`U`), and returns a value of type `R`.
* **Common Use Cases:**
  * **Converting primitive values to objects:** These functions are useful when you need to create objects based on primitive data values.
  * **Performing operations with primitive inputs:** You can implement custom logic to operate on primitive data types and return objects as results.
* **Example:**

```java
// BiFunction example
BiFunction<int, String, String> formatNameAge = (age, name) -> "Name: " + name + ", Age: " + age;

int anotherAge = 25;
String formattedInfo = formatNameAge.apply(anotherAge, "Charlie");
// Result output will be "Name: Charlie, Age: 25"
```



### **ToIntFunction\<T>, ToLongFunction\<T>, ToDoubleFunction\<T> and BiFunction counterparts**

These interfaces are designed for primitive type conversions and are related to the `Function` interface. They differ in the following ways:

* **Input type:** These interfaces take an argument of any type (`T`).
* **Return type:** They specialize in returning primitive data types:
  * `ToIntFunction<T>`: Returns an `int`.
  * `ToLongFunction<T>`: Returns a `long`.
  * `ToDoubleFunction<T>`: Returns a `double`.
* **BiFunction counterparts:**
  * `BiToIntFunction<T, U>`: Takes two arguments of any type (`T`, `U`) and returns an `int`.
  * `BiToLongFunction<T, U>`: Takes two arguments of any type (`T`, `U`) and returns a `long`.
  * `BiToDoubleFunction<T, U>`: Takes two arguments of any type (`T`, `U`) and returns a `double`.
* **Common Use Cases:**
  * **Primitive stream operations:** These functions are commonly used in conjunction with primitive streams (`IntStream`, `LongStream`, `DoubleStream`) to map elements to primitive data types.
  * **Custom conversion logic:** You can implement custom logic to convert objects of any type to specific primitive data types.
* **Example**:

```java
ToIntFunction<String> stringToIntLength = str -> str.length();

String name = "Alice";
int nameLength = stringToIntLength.applyAsInt(name); 
// Result output will be 5

// BiFunction example
BiToIntFunction<String, Integer> nameAndAgeSum = (name, age) -> name.length() + age;

String anotherName = "Bob";
int sum = nameAndAgeSum.applyAsInt(anotherName, 30); 
// Result output will be 33 (length + age)
```



