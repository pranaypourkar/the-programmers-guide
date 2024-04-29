---
description: Details about functional interfaces in Java.
---

# Functional Interfaces

**What is Functional Interface in Java?**

* A functional interface is an interface that contains exactly one abstract method.
* It plays a important role in implementing functional style programming.
* Functional interface is usually marked with `@FunctionalInterface` annotation. While optional, this annotation helps the compiler verify that the interface adheres to the "single abstract method" rule.
* Java's `java.util.function` package provides several built-in functional interfaces.



**Sample Example**

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
        Calculator addition = Integer::sum;

        // Use the custom functional interface
        log.info("Addition: {}", addition.calculate(5, 3));
    }
}
```

Execute the program

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>
