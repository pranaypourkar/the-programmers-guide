# Functional Interfaces

## **About**

* A **functional interface** is an interface that has exactly one abstract method. Functional interfaces are ideal for use with **lambda expressions** and **method references** in Java 8 and beyond.
* The `@FunctionalInterface` annotation is used to indicate a functional interface, but it is optional. When annotation is provided, the compiler ensures that a functional interface contains only one abstract method.
* Examples: `Runnable`, `Callable`, `Comparator`, and custom single-method interfaces.
* **Lambda Expressions**: Since Java 8, lambdas are used to instantiate functional interfaces, which greatly simplifies code and improves readability.

```java
@FunctionalInterface
interface Greeting {
    void sayHello(String name);
}

public class Main {
    public static void main(String[] args) {
        Greeting greeting = name -> System.out.println("Hello, " + name);
        greeting.sayHello("Alice");
    }
}
```

```java
// Compilation error - Multiple non-overriding abstract methods found in interface test. SomeMain. Greeting
@FunctionalInterface
interface Greeting {
    void sayHello(String name);
    String sayBye();
}
```



For more details, refer to the below page -

{% content-ref url="../../../../concepts/concepts-set-1/functional-interfaces/" %}
[functional-interfaces](../../../../concepts/concepts-set-1/functional-interfaces/)
{% endcontent-ref %}

