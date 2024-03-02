---
description: Overview of Java Generics.
---

# Generics

Java generics allows to write code that can work with different data types (String, Integer, etc., and user-defined types) without compromising on type safety. It is achieved by the concept of parameterized types.



## **What are generics?**

* Generics are basically templates for classes, interfaces, and methods.&#x20;
* These templates use type parameters, represented by letters like T or S, which act as placeholders for specific data types.&#x20;
* When using a generic class or method, provide the actual data type (e.g., Integer, String) to be used, which replaces the type parameter throughout the code.&#x20;
* The Object is the super-class of all other classes, and Object reference can refer to any object. These features lack type safety but Generics add that type of safety feature.

## **Benefits of using generics**

* **Increased code re-usability**: Single generic class/method can be written that can be used with different data types, reducing code duplication.&#x20;
* **Improved type safety**: The compiler takes care of type safety at compile time, preventing errors like mixing up different data types in the code.&#x20;
* **Reduced casting**: Generics eliminate the need for explicit type casting, making the code look cleaner and safer.

{% hint style="info" %}
Type safety refers to a programming language ability to ensure that data is only used in ways that are consistent with its declared type. This helps prevent errors and unexpected behavior that can arise from mixing up different data types at runtime.

**Type safety in Java**:

* **Static typing**: Java is a statically typed language, meaning the data type of a variable is declared at compile time and remains fixed throughout the program's execution.&#x20;
* **Type checking**: The Java compiler checks the types of expressions and operations to ensure they are compatible. For example, it wouldn't allow adding an integer and a string, as they have different data types.&#x20;
* **Type conversion**: Sometimes, controlled conversion between compatible types (e.g., casting an int to a double) might be necessary, but the compiler verifies its validity.



**How generics contribute to type safety?**

By declaring type parameters and requiring specific data types to be used with generics, the compiler can catch potential type mismatches early on. This prevents runtime errors like `ClassCastException`, which occurs when trying to cast an object to an incompatible type at runtime. Generics promote writing code that is clear about the expected data types, making it easier to understand, maintain, and debug.
{% endhint %}

## **Types of Java generics**

### **Generic classes**:

* **How to Declare:** Generic classes are blueprints/templates for creating objects with a specific data type. They declare one or more type parameters within angle brackets `< >` in the class declaration.

```java
public class Box<T> {
    private T data;
    // ... methods to access and manipulate data
}
```

* **How to Use:** Specify the actual data type when creating an instance

```java
Box<Integer> integerBox = new Box<>();
Box<String> stringBox = new Box<>();
```

* **Practical Use Case:** A generic `Stack` class can work with different types of elements (e.g., `IntegerStack`, `StringStack`).

### **Generic methods**:&#x20;

Similar to generic classes, these methods have type parameters in their signature, enabling them to operate on different data types. For instance, a swap(T a, T b) method can swap elements of any type.&#x20;

* **How to Declare:** Generic classes are blueprints/templates for creating objects with a specific data type. They declare one or more type parameters within angle brackets `< >` in the class declaration.

```java
public static <T> void swap(T a, T b) {
    T temp = a;
    a = b;
    b = temp;
}
```

* **How to Use:** Call the method with specific data types.

```java
swap(10, 20); // Swapping integers
swap("apple", "banana"); // Swapping strings
```

* **Practical Use Case:** A generic `sort` method can be used to sort arrays of different data types (e.g., `sort(int[] arr)`, `sort(String[] arr)`).

### **Generic interfaces**:&#x20;

These interfaces can also have type parameters, specifying the types of objects they can work with.

* **How to Declare:** Similar to generic classes, generic interfaces define the behavior of objects using type parameters. They specify the types of objects that can implement the interface.

```java
public interface Pair<K, V> {
    K getKey();
    V getValue();
}
```

* **How to Use:** Create concrete classes that implement the interface.

```java
public class NameValuePair implements Pair<String, String> {
    // ... implementation of methods
}
```

* **Practical Use Case:** A generic `Map` interface can be used to create different types of maps (e.g., `HashMap<String, Integer>`, `TreeMap<Integer, String>`).



## Examples

* Generic Stack class

```java
public class Stack<T> {
    private T[] elements;
    private int top;

    // ... methods to push, pop, and peek elements
}

public class Main {
    public static void main(String[] args) {
        Stack<Integer> intStack = new Stack<>();
        intStack.push(10);
        intStack.push(20);

        Stack<String> stringStack = new Stack<>();
        stringStack.push("Hello");
        stringStack.push("World");
    }
}
```

* Generic Sort method

```java
public class Util {
    public static <T extends Comparable<T>> void sort(T[] arr) {
        // ... sorting algorithm using array elements' compareTo method
    }

    public static void main(String[] args) {
        Integer[] numbers = {3, 1, 4, 2};
        String[] fruits = {"apple", "banana", "cherry"};

        sort(numbers);
        sort(fruits);
    }
}
```

* Generic Map Interface

```java
public interface Pair<K, V> {
    K getKey();
    V getValue();
}

public class NameValuePair implements Pair<String, String> {
    private String name;
    private String value;

    // ... implementation of methods
}

public class Main {
    public static void main(String[] args) {
        Pair<String, String> nameValue = new NameValuePair();
        nameValue.setKey("name");
        nameValue.setValue("John Doe");
    }
}
```
