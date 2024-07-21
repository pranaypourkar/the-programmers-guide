# SOLID Principles

## Description

SOLID is a set of five principles that help developers design object-oriented code that's easier to understand, maintain, and extend. They were introduced by Robert C. Martin to promote better software design.

## **S - Single Responsibility Principle (SRP)**

### About

This principle states that a class should have only one reason to change, meaning that it should have only one responsibility or job. If a class does more than one thing, it becomes harder to understand, maintain, and reuse.

### Advantage

* **Improved Readability:** Each class has a single responsibility, making it easier to understand and follow.
* **Easier Maintenance:** Changes in requirements affect only the specific class responsible for that functionality, minimizing the risk of unintended side effects.
* **Enhanced Reusability:** Classes are more focused and can be reused in different contexts.

### Examples

**Example 1**: Consider a class called `Employee` that manages both employee information and payroll calculations. According to SRP, this violates the principle because the class has multiple responsibilities. Instead, we could split it into two classes: one for managing employee information (`Employee`) and another for handling payroll calculations (`Payroll`).

**Example 2**: Imagine a class `UserManager` that's responsible for both creating new users and sending them welcome emails. If the logic for sending emails changes, we'd need to modify the `UserManager` class even though its core functionality of creating users remains the same. This violates SRP. A better approach would be to have separate classes: `UserManager` for creating users and `EmailService` for sending emails.

## **O - Open/Closed Principle (OCP)**&#x20;

### About

This principle suggests that software entities (such as classes, modules, functions, etc.) should be open for extension but closed for modification. In other words, we should be able to extend the behavior of a module without modifying its source code.

### Advantage

* **Ease of Extension:** New functionality can be added by extending existing classes without modifying their code, reducing the risk of introducing bugs.
* **Better Modularity:** Systems are more modular, making it easier to isolate and understand different parts of the application.
* **Facilitates Testing:** New features can be tested independently from the existing code, improving test coverage and reliability.

### **Examples**

**Example 1**: Suppose we have a class `Shape` with a method `calculateArea()`, and we want to add support for new shapes without modifying the `Shape` class. We can achieve this by creating a new subclass for each shape (e.g., `Circle`, `Square`) and implementing the `calculateArea()` method in each subclass. This way, we extend the behavior without modifying existing code.

## **L - Liskov Substitution Principle (LSP)**&#x20;

### About

Named after Barbara Liskov, this principle states that objects of a superclass should be replaceable with objects of a subclass without affecting the correctness of the program. In simpler terms, if S is a subtype of T, then objects of type T may be replaced with objects of type S without altering any of the desirable properties of the program.

{% hint style="info" %}
**Substitutability:** You should be able to use a subclass wherever a superclass is expected without the program failing.

**Behavioral Compatibility:** The subclass should enhance or extend the behavior of the superclass without changing its expected behavior.
{% endhint %}

### **Advantage**

* **Ensures Correctness:** Subtypes can be used in place of their base types without affecting the correctness of the program, ensuring that the system behaves as expected.
* **Enhances Polymorphism:** Promotes the use of polymorphism and interface-based design, enabling flexible and interchangeable components.
* **Improves Maintainability:** Reduces unexpected behaviors and errors, making the system easier to maintain and evolve.

### **Examples**

**Example 1**: Consider a `Rectangle` class with a `setWidth` and `setHeight` method. We might have a `Square` class that inherits from `Rectangle`. However, if we try to set a different width and height for a `Square` object, it would violate its square property. LSP ensures that subclasses adhere to the contract established by their superclass. In this case, the `Square` class should have its own logic to ensure both width and height are always the same.

<table data-full-width="true"><thead><tr><th>Incorrect (LSP Violation):</th><th>Correct (LSP Adherence)</th></tr></thead><tbody><tr><td><pre class="language-java"><code class="lang-java">class Rectangle {
  private int width;
  private int height;

  public void setWidth(int width) {
    this.width = width;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  public int getArea() {
    return width * height;
  }
}

class Square extends Rectangle { // Square inherits from Rectangle (violation)
  @Override
  public void setWidth(int width) {
    super.setWidth(width); // Sets width in parent class
    super.setHeight(width); // Sets height to match width (incorrect for Square)
  }

  @Override
  public void setHeight(int height) {
    super.setHeight(height); // Sets height in parent class
    super.setWidth(height); // Sets width to match height (incorrect for Square)
  }
}

public class Main {
  public static void main(String[] args) {
    Rectangle rectangle = new Rectangle();
    rectangle.setWidth(5);
    rectangle.setHeight(10);
    System.out.println("Rectangle Area: " + rectangle.getArea()); // 50 (correct)

    Square square = new Square();
    square.setWidth(10); // This will also set height to 10 (incorrect)
    System.out.println("Square Area: " + square.getArea()); // 100 (incorrect, should be 100)
    
    // substituting a Square for a Rectangle violates the Liskov Substitution Principle 
    // because it changes the expected behavior of Rectangle
  }
}
</code></pre></td><td><pre class="language-java" data-full-width="true"><code class="lang-java">class Shape {
  public int getArea() {
    return 0; // Default implementation (can be overridden)
  }
}

class Rectangle extends Shape {
  private int width;
  private int height;

  public void setWidth(int width) {
    this.width = width;
  }

  public void setHeight(int height) {
    this.height = height;
  }

  @Override
  public int getArea() {
    return width * height;
  }
}

class Square extends Shape {
  private int side;

  public void setSide(int side) {
    this.side = side;
  }

  @Override
  public int getArea() {
    return side * side;
  }
}

public class Main {
  public static void main(String[] args) {
    Rectangle rectangle = new Rectangle();
    rectangle.setWidth(5);
    rectangle.setHeight(10);
    System.out.println("Rectangle Area: " + rectangle.getArea()); // 50 (correct)

    Square square = new Square();
    square.setSide(10); // Sets both width and height internally
    System.out.println("Square Area: " + square.getArea()); // 100 (correct)
  }
}
</code></pre></td></tr></tbody></table>

**Example 2:** Consider other example involving birds.

**Without LSP**

Here, substituting an `Ostrich` for a `Bird` violates LSP because it changes the expected behavior (flying).

```java
class Bird {
    public void fly() {
        System.out.println("Bird is flying");
    }
}

class Ostrich extends Bird {
    @Override
    public void fly() {
        throw new UnsupportedOperationException("Ostriches can't fly");
    }
}
```

**With LSP**

To adhere to LSP, we can redesign our hierarchy to properly reflect capabilities. Now, `Sparrow` can fly, and `Ostrich` does not pretend to be able to fly, maintaining LSP.

```java
class Bird {
    public void eat() {
        System.out.println("Bird is eating");
    }
}

interface Flyable {
    void fly();
}

class Sparrow extends Bird implements Flyable {
    @Override
    public void fly() {
        System.out.println("Sparrow is flying");
    }
}

class Ostrich extends Bird {
    // Ostrich doesn't implement Flyable, hence no fly method
}
```

## **I - Interface Segregation Principle (ISP)**&#x20;

### About

This principle emphasizes that clients should not be forced to depend on interfaces they do not use. It suggests that you should break interfaces that are too large into smaller, more specific ones so that clients only need to know about the methods that are relevant to them.

### Advantage

* **Reduced Complexity:** Clients are not forced to depend on interfaces they do not use, leading to simpler and more focused interfaces.
* **Increased Flexibility:** Smaller, specific interfaces allow for more flexible and decoupled designs.
* **Enhanced Clarity:** Interfaces are easier to implement, understand, and maintain due to their focused nature.

### Examples

**Example 1**: Consider an interface called `Worker` that has methods for both manual labor (`workWithHands()`) and office work (`workWithComputer()`). However, not all classes that implement `Worker` need to perform both types of work. Instead, we can split the interface into smaller, more specific interfaces like `ManualWorker` and `OfficeWorker`, allowing classes to implement only the methods they need.

**Example 2**: Imagine an interface `Animal` with methods for `makeSound()`, `fly()`, and `swim()`. A `Fish` class would only implement `swim()`, but it would still be forced to implement the empty `makeSound()` and `fly()` methods. ISP suggests creating smaller, more specific interfaces like `Swimmer` with just a `swim()` method. This reduces unnecessary code for classes like `Fish`.

## **D - Dependency Inversion Principle (DIP)**&#x20;

### About

This Principle is about decoupling high-level and low-level components by introducing an abstraction layer. This principle states that high-level modules should not depend on low-level modules; both should depend on abstractions. It also suggests that abstractions should not depend on details; rather, details should depend on abstractions. This helps in achieving decoupling and allows for easier changes and substitutions.

The main goal of DIP is to reduce the dependency between components, making the system more modular, flexible, and easier to maintain or extend.

{% hint style="info" %}
**High-Level Modules:** These are modules that contain the core business logic.

**Low-Level Modules:** These are modules that provide utility functions and specific implementations.

**Abstractions:** Interfaces or abstract classes that define contracts without specifying implementation details.
{% endhint %}

### **Advantage**

* **Decouples Components:** High-level modules are not dependent on low-level modules but on abstractions, reducing the coupling between different parts of the system.
* **Increases Flexibility:** Makes it easier to replace or change the low-level implementations without affecting high-level modules.
* **Improves Testability:** Dependencies can be easily mocked or stubbed, facilitating unit testing and improving test coverage.

### **Examples**

**Example 1**: Suppose we have a `FileLogger` class that logs messages to a file. Instead of directly creating an instance of `FileLogger` within another class, we can use dependency injection to pass an instance of `Logger` (an abstraction) to the dependent class. This way, the dependent class doesn't depend on the concrete implementation (`FileLogger`), but on an abstraction (`Logger`). This makes it easier to switch to a different logging mechanism in the future without modifying the dependent class

**Example 2:** Let's say a class `PaymentProcessor` directly depends on a specific payment gateway like `PayPalGateway` to process payments. If we want to switch to a different gateway (e.g., `StripeGateway`), we'd need to modify the `PaymentProcessor` class. DIP suggests using an abstraction like a `PaymentGateway` interface that both `PayPalGateway` and `StripeGateway` implement. The `PaymentProcessor` would then depend on the `PaymentGateway` interface, allowing us to switch between gateways easily without modifying the core logic.
