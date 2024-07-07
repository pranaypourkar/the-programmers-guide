---
description: Details about functional interfaces in Java.
---

# Functional Interfaces

## **What is Functional Interface in Java?**

* A functional interface is an interface that contains exactly one abstract method.
* It plays a important role in implementing functional style programming.
* Functional interface is usually marked with `@FunctionalInterface` annotation. While optional, this annotation helps the compiler verify that the interface adheres to the "single abstract method" rule.
* Java's `java.util.function` package provides several built-in functional interfaces.

## **Sample Example**

Create a custom functional interface and add sample logic in the main application to use the newly created interface

```java
package org.example;

import lombok.extern.slf4j.Slf4j;

@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

@Slf4j
public class Application {
    public static void main(String[] args) {
        // Define a lambda expression for addition
        Calculator additionWithMethodReference = Integer::sum;
        Calculator additionWithLambdaExpression = (a,b) -> Integer.sum(a,b);

        // Use the custom functional interface
        log.info("Addition: {}", additionWithMethodReference.calculate(5, 3));
        log.info("Addition: {}", additionWithLambdaExpression.calculate(5, 3));
    }
}
```

Execute the program

<figure><img src="../../../.gitbook/assets/image (2) (1).png" alt="" width="563"><figcaption></figcaption></figure>

## Functional Interface vs Normal Interface

Here's a comparison table between Functional Interface and Normal Interface -

<table data-full-width="true"><thead><tr><th width="216">Aspect</th><th>Functional Interface</th><th>Normal Interface</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>Interfaces with a single abstract method</td><td>Interfaces with one or more abstract methods</td></tr><tr><td><strong>Annotation</strong></td><td>Often annotated with <code>@FunctionalInterface</code></td><td>No specific annotation required</td></tr><tr><td><strong>Number of Methods</strong></td><td>Exactly one abstract method</td><td>One or more abstract methods</td></tr><tr><td><strong>Default/Static Methods</strong></td><td>Can have default and static methods</td><td>Can have default and static methods</td></tr><tr><td><strong>Use Case</strong></td><td>Designed for lambda expressions and method references</td><td>Used for general abstraction and polymorphism</td></tr><tr><td><strong>Example</strong></td><td><code>java.util.function.Predicate&#x3C;T></code></td><td><code>java.util.List</code>, <code>java.util.Map</code></td></tr><tr><td><strong>Syntax with Lambda</strong></td><td>Can be instantiated using lambda expressions</td><td>Cannot be directly instantiated using lambda expressions</td></tr><tr><td><strong>Java 8 and Later</strong></td><td>Introduced in Java 8</td><td>Existing since the initial versions of Java</td></tr><tr><td><strong>Simplicity</strong></td><td>Simplifies the creation of instances</td><td>More verbose to implement</td></tr><tr><td><strong>Primary Purpose</strong></td><td>To provide target types for lambda expressions and method references</td><td>To define a contract that classes must follow</td></tr></tbody></table>



### Functional Interface Example

```java
@FunctionalInterface
public interface MyFunctionalInterface {
    void perform();

    // default method
    default void log(String message) {
        System.out.println("Logging: " + message);
    }

    // static method
    static void print(String message) {
        System.out.println("Printing: " + message);
    }
}

public class FunctionalInterfaceExample {
    public static void main(String[] args) {
        MyFunctionalInterface funcInterface = () -> System.out.println("Performing action");
        funcInterface.perform();  // Output: Performing action
        funcInterface.log("Test Log");  // Output: Logging: Test Log
        MyFunctionalInterface.print("Test Print");  // Output: Printing: Test Print
    }
}
```

### Normal Interface Example

```java
public interface MyNormalInterface {
    void method1();
    void method2();

    // default method
    default void log(String message) {
        System.out.println("Logging: " + message);
    }

    // static method
    static void print(String message) {
        System.out.println("Printing: " + message);
    }
}

public class NormalInterfaceImplementation implements MyNormalInterface {
    @Override
    public void method1() {
        System.out.println("Method 1 implementation");
    }

    @Override
    public void method2() {
        System.out.println("Method 2 implementation");
    }

    public static void main(String[] args) {
        NormalInterfaceImplementation obj = new NormalInterfaceImplementation();
        obj.method1();  // Output: Method 1 implementation
        obj.method2();  // Output: Method 2 implementation
        obj.log("Test Log");  // Output: Logging: Test Log
        MyNormalInterface.print("Test Print");  // Output: Printing: Test Print
    }
}
```
