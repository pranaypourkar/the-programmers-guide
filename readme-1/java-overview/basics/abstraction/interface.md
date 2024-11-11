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

## **Abstract Methods**

By default, all methods declared in an interface are abstract (i.e., they do not have a body). Any class implementing the interface must provide a concrete implementation of these methods.

```java
interface Animal {
    void sound(); // abstract method
}

class Dog implements Animal {
    @Override
    public void sound() {
        System.out.println("Bark");
    }
}
```

## **Default Methods**

Introduced in Java 8, default methods allow interfaces to provide method implementations. This feature was introduced to ensure backward compatibility when new methods are added to interfaces.

```java
interface Animal {
    default void sleep() {
        System.out.println("Sleeping");
    }
}
```

## **Static Methods**

Interfaces can define static methods that are independent of any instance. These methods are called using the interface name.

```java
interface Animal {
    static void showInfo() {
        System.out.println("Animal Information");
    }
}
```

## **Constants**

All fields declared in an interface are implicitly `public`, `static`, and `final`. They are treated as constants.

```java
interface Animal {
    int MAX_AGE = 100; // constant
}
```

## **Private Methods**

Since Java 9, interfaces can have private methods. These are used to share common code between default methods.

```java
interface Animal {
    private void printInfo() {
        System.out.println("Animal Info");
    }

    default void show() {
        printInfo();
    }
}
```

## **Access Modifiers**

Interface methods are implicitly `public`. We cannot have non-public methods in an interface.

```java
public interface Animal {
    void makeSound();  // Implicitly public
}
```

## **Interface Inheritance**

Interfaces can extend other interfaces. This means one interface can inherit the abstract methods of another interface. A class implementing the extended interface must implement all methods from both the parent and the child interfaces.

```java
interface Animal {
    void sound();
}

interface Mammal extends Animal {
    void walk();
}

class Dog implements Mammal {
    @Override
    public void sound() {
        System.out.println("Bark");
    }

    @Override
    public void walk() {
        System.out.println("Walks on four legs");
    }
}
```

## **Functional Interfaces**

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

## **Marker Interfaces**

A **marker interface** is an interface that does not contain any methods or fields. Its purpose is purely to mark a class that it is associated with some specific behavior.

*   **Example**: `Serializable`, `Cloneable`, and `Remote` are marker interfaces in Java.

    ```java
    interface Serializable { }
    class Person implements Serializable { }
    ```

