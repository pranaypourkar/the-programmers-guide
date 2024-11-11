# Interface

## **What is an Interface?**

Java interfaces are one of the core concepts of Java programming, providing a mechanism for defining a contract that classes must adhere to. A **Java Interface** is a reference type in Java, similar to a class, but it is a collection of abstract methods (methods without implementations) and constants. An interface provides a way to define a contract that classes can implement, meaning that any class that implements an interface must provide concrete implementations for the methods defined in the interface.

{% hint style="success" %}
*   **Reference Type**: In Java, both **classes** and **interfaces** are reference types. This means that they do not hold data directly (like primitive types do), but rather reference or point to objects in memory. When we declare a variable of a class or interface type, it can reference an object of that type.

    ```java
    MyClass obj = new MyClass(); // obj is a reference of type MyClass
    MyInterface obj2 = new MyClass(); // obj2 is a reference of type MyInterface
    ```
*   **Key Differences**:

    * **Classes** define both the behavior (methods) and the structure (fields) of objects.
    * **Interfaces** define only method signatures (and constants), without any implementation. A class that implements an interface must provide the actual implementation for the abstract methods declared in the interface.

    While an interface can define **constants** and **abstract methods**, it **cannot** define instance fields (variables that hold data). Additionally, interfaces can have **default** methods with implementations, starting from Java 8, and **static methods**. However, they still serve to provide a contract for what behaviors a class should implement, rather than dictating how those behaviors are implemented.
{% endhint %}

```java
public interface InterfaceName {
    // abstract method
    void someMethod();

    // default method
    default void defaultMethod() {
        System.out.println("Default implementation");
    }

    // static method
    static void staticMethod() {
        System.out.println("Static method");
    }
}
```

## **Purpose of Interfaces**

The primary purpose of interfaces is to define a **contract** that classes can implement. A class that implements an interface must provide concrete implementations for all the abstract methods declared in the interface (unless the class is abstract).

Interfaces enable:

* **Abstraction**: By separating the definition of a method from its implementation, interfaces allow different implementations of the same functionality.
* **Multiple Inheritance**: While Java doesn't allow multiple inheritance with classes, a class can implement multiple interfaces. This allows a class to inherit different behaviors from multiple sources.
* **Loose Coupling**: Interfaces help in decoupling code. The client code doesn’t need to know the details of the class implementing the interface, only the interface itself.



