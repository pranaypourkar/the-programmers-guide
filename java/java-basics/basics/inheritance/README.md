# Inheritance

## About

**Inheritance** is one of the four fundamental principles of Object-Oriented Programming (OOP), and it plays a crucial role in building organized, reusable, and maintainable code. It allows a new class (called a **subclass** or **child class**) to **acquire the properties and behaviors** (fields and methods) of an existing class (called a **superclass** or **parent class**).

In simpler terms, inheritance enables us to **create new classes based on existing ones**, allowing us to build upon and extend existing functionality without rewriting code.

In Java, inheritance is implemented using the `extends` keyword. The child class inherits all **non-private members** of the parent class and can:

* Use them directly,
* Modify them (by overriding methods), or
* Extend functionality by adding new members.

This principle helps developers avoid redundancy and build modular, maintainable code. For example, if we have a general `Vehicle` class, we can create more specific types like `Car` or `Bike` that inherit from `Vehicle`, sharing common behavior like `start()` or `stop()` while introducing their own specific behaviors.

{% hint style="success" %}
Think of inheritance like a family tree. A child inherits traits from their parents - eye color, height, etc. Similarly, in programming, a subclass inherits characteristics and behaviours from its superclass.
{% endhint %}

## Importance of Understanding Inheritance

Inheritance is not just a feature of object-oriented programming - it's a powerful design principle that helps build **reusable, extensible, and maintainable software**. Understanding inheritance is crucial for both writing clean code and understanding how real-world Java frameworks and libraries work.

**1. Promotes Code Reusability**

With inheritance, common functionality can be written once in a **base (parent) class** and reused in multiple **derived (child) classes**. This avoids code duplication and helps keep our codebase DRY (Don't Repeat Yourself).

> For example, if several classes share similar properties like `name`, `id`, or `createdAt`, we can move these to a common superclass.

**2. Enables Polymorphism**

Inheritance is the backbone of **runtime polymorphism** — where a subclass can override methods and be treated like the parent class. This makes our code **flexible and dynamic**.

> We can write code like `List<Animal>` and fill it with `Dog`, `Cat`, `Bird` objects — and call `animal.sound()` without knowing the exact type.

**3. Improves Maintainability and Extensibility**

Changes made in the parent class can automatically propagate to child classes, making it easier to **maintain or update** shared behavior.

> For example, fixing a bug or adding a feature in a base `User` class benefits all its subclasses like `AdminUser`, `Customer`, or `Vendor`.

**4. Models Real-World Relationships**

Inheritance lets us model **"is-a" relationships**, making our object model more intuitive.

> A `Car` is a `Vehicle`. A `Dog` is an `Animal`. These relationships help structure our code in a meaningful way.

**5. Prepares Us for Frameworks and Design Patterns**

Most real-world Java frameworks (like Spring, Hibernate, and JavaFX) rely heavily on inheritance and polymorphism. Understanding how inheritance works helps us:

* Extend base classes
* Override behavior
* Use abstract classes and interfaces effectively

**6. Encourages Modular Design**

By separating generic and specific behaviors into separate classes, inheritance helps build systems that are **modular and loosely coupled**, which aligns with good software design practices.

## How Inheritance Works in Java ?

In Java, inheritance allows a class to inherit fields and methods from another class. The class that inherits is called the **subclass** (or child class), and the class being inherited from is called the **superclass** (or parent class). Java uses the `extends` keyword to establish this relationship.

{% hint style="success" %}
* Constructors are **not inherited**, but the constructor of the superclass can be called using `super()`.
* If no `extends` keyword is used, the class implicitly extends `java.lang.Object`, which is the root class of all Java classes.
* We can override inherited methods in the subclass to provide specific behavior.
{% endhint %}

**Basic Syntax**

```java
class Superclass {
    // fields and methods
}

class Subclass extends Superclass {
    // additional fields and methods
}
```

The subclass automatically inherits all **non-private** members (fields and methods) of the superclass. This includes:

* Public and protected fields and methods
* Default (package-private) members if the subclass is in the same package

Private members are **not inherited**, but they can be accessed indirectly using public or protected methods (getters/setters).

```java
class Animal {
    void eat() {
        System.out.println("This animal eats food.");
    }
}

class Dog extends Animal {
    void bark() {
        System.out.println("The dog barks.");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.eat();   // inherited from Animal
        d.bark();  // defined in Dog
    }
}
```

In this example:

* `Dog` inherits the `eat()` method from `Animal`
* `Dog` also has its own method `bark()`

## Types of Inheritance in Java

Inheritance can take different forms depending on how classes are related to each other. While Object-Oriented Programming (OOP) supports various types of inheritance, Java only allows some of them through classes and others through **interfaces**.

### **1. Single Inheritance**

A class inherits from one superclass.

```java
class Animal {
    void eat() {}
}

class Dog extends Animal {
    void bark() {}
}
```

Here, `Dog` inherits from `Animal`. This is the most common form of inheritance in Java and is fully supported.

### **2. Multilevel Inheritance**

A class inherits from a class which itself inherits from another class.

```java
class Animal {
    void eat() {}
}

class Dog extends Animal {
    void bark() {}
}

class Puppy extends Dog {
    void weep() {}
}
```

In this case, `Puppy` inherits from `Dog`, and `Dog` inherits from `Animal`. Java supports this as well.

### **3. Hierarchical Inheritance**

Multiple classes inherit from the same parent class.

```java
class Animal {
    void eat() {}
}

class Dog extends Animal {
    void bark() {}
}

class Cat extends Animal {
    void meow() {}
}
```

Here, both `Dog` and `Cat` inherit from `Animal`. This is supported in Java and often used to model shared behavior in subclasses.

### **4. Multiple Inheritance (Using Interfaces Only)**

Java **does not support multiple inheritance with classes** to avoid ambiguity (commonly called the **diamond problem**). However, it does support multiple inheritance through **interfaces**.

```java
interface A {
    void methodA();
}

interface B {
    void methodB();
}

class C implements A, B {
    public void methodA() {}
    public void methodB() {}
}
```

Here, class `C` inherits from both interfaces `A` and `B`. This is allowed because interfaces only define method signatures, not implementations.

### **5. Hybrid Inheritance (Supported via Interfaces Only)**

Hybrid inheritance is a combination of two or more types of inheritance. In Java, **hybrid inheritance is only supported using interfaces** not classes due to the same ambiguity concerns.

### Comparison

| Inheritance Type         | Supported in Java (Classes) | Supported in Java (Interfaces) |
| ------------------------ | --------------------------- | ------------------------------ |
| Single Inheritance       | Yes                         | Yes                            |
| Multilevel Inheritance   | Yes                         | Yes                            |
| Hierarchical Inheritance | Yes                         | Yes                            |
| Multiple Inheritance     | No (with classes)           | Yes                            |
| Hybrid Inheritance       | No (with classes)           | Yes                            |

## **Use Cases**

Understanding the theory behind inheritance is important, but seeing how it's used in real-world applications helps solidify its purpose. Inheritance is widely used in both **core Java applications** and **enterprise-level frameworks** to promote code reuse, consistency, and modular design.

**1. Creating a Class Hierarchy**

Inheritance allows us to define a natural hierarchy between classes, starting from general to specific.

**Example**

```java
class Vehicle { void start() {} }

class Car extends Vehicle { void playMusic() {} }

class Bike extends Vehicle { void kickStart() {} }
```

Use Case: A transportation app can treat all vehicles the same way while allowing type-specific behaviors.

**2. Framework Extension and Customization**

Many Java frameworks (like **Spring**, **JUnit**, **Servlet API**) are built using inheritance. We often extend base classes to add or modify behavior.

**Example**

```java
public class MyServlet extends HttpServlet {
    protected void doGet(...) {
        // custom handling
    }
}
```

Use Case: In web development, we extend `HttpServlet` to build custom HTTP endpoints.

**3. Template Method Pattern**

Inheritance is key to implementing the **Template Method** design pattern, where a superclass defines the skeleton of an algorithm and subclasses override specific steps.

**Example**

```java
abstract class Game {
    void start() { load(), initialize(), play(); }
    abstract void load();
    abstract void initialize();
    abstract void play();
}
```

Use Case: Game engines, UI rendering frameworks, or workflow engines.

**4. Testing Utilities and Mocking**

In test code, we can use inheritance to extend a base test class that provides common setup or utility methods.

**Example**

```java
public class BaseTest {
    @BeforeEach void setupDatabase() { ... }
}

public class UserServiceTest extends BaseTest {
    // inherits setupDatabase()
}
```

Use Case: Reusing setup logic across multiple test classes.

**5. Code Organization and API Design**

Inheritance is often used when designing **SDKs or APIs**, grouping related classes under a parent to simplify usage and provide a clean public interface.

**Example:** In GUI frameworks like JavaFX or Swing:

```java
class Component { ... }
class Button extends Component { ... }
class Label extends Component { ... }
```

Use Case: Consistent behavior across different UI elements.
