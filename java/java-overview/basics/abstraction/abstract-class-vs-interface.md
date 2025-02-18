# Abstract Class vs Interface

## **Basic Definition**

* **Abstract Class**: A class that cannot be instantiated and may contain a mix of implemented (concrete) and unimplemented (abstract) methods. It’s used when you want to provide a base class with shared functionality that other classes can extend and enhance.
* **Interface**: A reference type in Java used to define a contract that other classes must follow. An interface primarily contains abstract methods but can also have default and static methods (since Java 8) and private methods (since Java 9).

## **Purpose and Use Case**

* **Abstract Class**: Used for **shared behavior** and **state** that will be common to all subclasses. Abstract classes allow code reuse by providing default behavior in concrete methods.
* **Interface**: Used to define a **contract** for unrelated classes to implement, ensuring that they provide specific methods. Interfaces are ideal for achieving polymorphism across classes that may not share any other relationship.

### **Example Use Case**:

* Abstract class: `Vehicle` (as a base class for `Car`, `Bike`), where `startEngine` might have a default implementation.
* Interface: `Drivable` or `Flyable`, where multiple unrelated classes (e.g., `Car`, `Drone`, `Plane`) can implement the ability to drive or fly.

## **Inheritance and Multiple Implementation**

* **Abstract Class**: Supports **single inheritance**. A class can extend only one abstract class, limiting the use of abstract classes in cases where multiple inheritance is needed.
* **Interface**: Supports **multiple inheritance** through multiple implementations, allowing a class to implement multiple interfaces simultaneously. This enables a class to gain behavior from multiple sources, achieving polymorphism and flexibility.

**Example**:

```java
public abstract class Animal {}
public class Dog extends Animal {}  // Dog can only extend one class, Animal.

public interface Pet {}
public interface Friendly {}

public class Dog extends Animal implements Pet, Friendly {}  // Multiple interfaces allowed
```

## **Methods and Implementation**

* **Abstract Class**:
  * Can have both **abstract and concrete methods** (implemented and unimplemented methods).
  * **Non-abstract methods** allow for shared default behaviors among subclasses.
  * Methods can have any access modifier (public, protected, private).
* **Interface**:
  * Typically contains only **abstract methods** (implicitly public).
  * Since Java 8, interfaces can also have **default methods** (with a body) and **static methods**.
  * Since Java 9, they can have **private methods** for internal reuse.

**Example**:

```java
// Abstract class with concrete and abstract methods
public abstract class Appliance {
    public abstract void turnOn();
    public void showStatus() { System.out.println("Appliance is working."); }
}

// Interface with abstract and default methods
public interface Operable {
    void operate();
    default void check() { System.out.println("Checking operability."); }
}
```

## **State (Instance Variables)**

* **Abstract Class**: Can have instance variables (fields) that store state information, which can be inherited by subclasses.
* **Interface**: Cannot have instance variables. It can only contain constants (implicitly `public`, `static`, and `final`).

**Example**:

```java
public abstract class Vehicle {
    protected int speed;  // Instance variable allowed
}

public interface Drivable {
    int MAX_SPEED = 120;  // Constant (public static final)
}
```

## **Constructors**

* **Abstract Class**: Can have constructors, which are called when a subclass is instantiated. This allows abstract classes to initialize common fields or perform setup tasks.
* **Interface**: Cannot have constructors, as interfaces do not hold state or instance variables that need initialization.

**Example**:

```java
public abstract class Animal {
    protected String name;
    public Animal(String name) { this.name = name; }  // Constructor allowed in abstract class
}

public interface Creature {}  // No constructors allowed in interface
```

## **Access Modifiers for Methods**

* **Abstract Class**: Allows control over access with any modifier (public, protected, private).
* **Interface**: Methods are `public` by default. Java 9 and above allow private methods within the interface for helper functions.

## **Design Patterns Usage**

* **Abstract Class**: Often foundational in patterns that require shared behavior and state, such as:
  * **Template Method**: Defines a template in an abstract class, with concrete steps overridden by subclasses.
  * **Factory Method**: An abstract class can provide a default factory method for creating instances of a particular type.
  * **Adapter Pattern**: Can be used as an adapter with some shared functionality.
* **Interface**: Common in patterns that emphasize flexibility and modularity, such as:
  * **Strategy Pattern**: Defines interchangeable algorithms as interfaces.
  * **Observer Pattern**: Typically, `Observer` and `Subject` are defined as interfaces to allow various implementations.
  * **Decorator Pattern**: Interfaces enable decorating objects with additional functionality dynamically.

## **Performance Considerations**

### 1. **Background on JVM and Method Calls**

In Java, method calls differ slightly between abstract classes and interfaces due to the way Java handles inheritance and polymorphism.

* **Abstract Class**: When a class extends an abstract class and overrides its methods, the JVM can more directly call these methods since they belong to a concrete inheritance chain. This can sometimes lead to minor efficiency gains because the JVM optimizes class inheritance structures more straightforwardly.
* **Interface**: Interfaces allow for multiple inheritance, which requires a more indirect lookup process, especially with older JVMs. When a class implements an interface and calls an interface method, the JVM often needs to look up the method through a “vtable” (a table of method pointers). This was initially slightly slower because it added an additional level of indirection.

However, modern **JVM optimizations** have made these differences minimal, almost negligible. Now, both abstract classes and interfaces are generally optimized equally well for performance, so this is rarely a deciding factor in design.

### 2. **Instance Variables vs. Constants**

* **Abstract Class**: Since abstract classes can hold state (instance variables), they don’t need to use `public static final` fields. This can sometimes save memory, especially when the values vary per instance or subclass.
* **Interface**: By contrast, interfaces only support constants (`public static final`). If a method in an interface relies heavily on constants, these values must be duplicated across classes or cannot be varied, leading to potential memory inefficiencies if not managed well.

### 3. **When Performance Could Be Notable**

In **performance-critical applications** or very **highly optimized systems**, an abstract class might be preferred if:

* We need instance variables for memory efficiency, as they allow storing shared state without relying on static constants.
* We’re aiming for faster method calls, though JVM optimizations largely mitigate this concern today.

## **When to Use Each ?**

<table data-full-width="true"><thead><tr><th width="243">Scenario</th><th width="299">Choose Abstract Class</th><th>Choose Interface</th></tr></thead><tbody><tr><td><strong>Need shared code across subclasses</strong></td><td>If multiple subclasses need common functionality</td><td>Not ideal, as interfaces can’t share implementations (use default only if lightweight)</td></tr><tr><td><strong>Multiple inheritance</strong></td><td>Limited (only supports single inheritance)</td><td>Recommended when multiple inheritance is needed</td></tr><tr><td><strong>Type hierarchy</strong></td><td>When classes share a strong is-a relationship</td><td>When unrelated classes need a common behavior</td></tr><tr><td><strong>Flexible contracts</strong></td><td>Less flexible for modifying contracts</td><td>Ideal for specifying a contract with minimal restrictions</td></tr><tr><td><strong>Backwards compatibility</strong></td><td>Adding methods can break subclasses without an override</td><td>Adding default methods preserves compatibility</td></tr><tr><td><strong>Memory/state</strong></td><td>Allows instance variables and state management</td><td>Does not support instance variables, only constants</td></tr></tbody></table>

