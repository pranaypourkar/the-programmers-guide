# Polymorphism

## About

Polymorphism is one of the core concepts of Object-Oriented Programming (OOP) in Java. The term “polymorphism” comes from the Greek words _poly_ (meaning “many”) and _morph_ (meaning “forms”), which literally translates to “many forms.” In the context of Java, polymorphism refers to the ability of a single interface, method, or operation to behave differently based on the object that invokes it.

In simpler terms, polymorphism allows us to write code that can work with objects of multiple types, enabling a single action to produce different results depending on the runtime type of the object. This flexibility not only promotes cleaner and more maintainable code but also aligns closely with other OOP principles such as inheritance and abstraction.

Polymorphism is deeply integrated into Java’s type system and is fundamental to its design philosophy. It’s the mechanism that enables frameworks, APIs, and large-scale applications to be extensible, reusable, and adaptable without requiring modifications to existing code.

## Importance of Understanding Polymorphism

Polymorphism is not just a theoretical OOP concept - it’s a practical tool that shapes how real-world Java applications are designed and maintained. Understanding it is crucial for any Java developer because it impacts code reusability, extensibility, and maintainability.

**1. Code Reusability**\
Polymorphism allows the same code to work with different data types or class hierarchies without modification. This reduces code duplication and simplifies development.

**2. Flexibility and Extensibility**\
When applications are designed with polymorphism in mind, new classes can be introduced without changing the existing code that depends on them. This supports scalability in software projects.

**3. Easier Maintenance**\
By using polymorphic references, code changes are localized to the classes that require modification, leaving the rest of the system untouched. This minimizes the risk of introducing new bugs when extending functionality.

**4. Decoupling and Abstraction**\
Polymorphism works hand-in-hand with abstraction to reduce coupling between components. Code can depend on interfaces or abstract classes, making it independent of the specific implementations.

**5. Real-World Problem Solving**\
Polymorphism mirrors real-world systems where a single action may produce different results depending on the situation. This makes software design more intuitive and aligned with real-world modeling.

**6. Backbone of Frameworks and APIs**\
Java’s core libraries, frameworks (like Spring, Hibernate), and APIs rely heavily on polymorphism to provide flexible and extensible functionality without the need to rewrite core logic.

## Types of Polymorphism

Polymorphism in Java can be broadly classified into two main types: **Compile-time Polymorphism** and **Runtime Polymorphism**. Each works differently and serves different purposes in program design.

### **1. Compile-Time Polymorphism (Static Polymorphism)**

Compile-time polymorphism occurs when the method to be invoked is determined at compile time. It is typically achieved through **method overloading**.

* **Key Characteristics**
  * Decision about which method to call is made during compilation.
  * Involves multiple methods with the same name but different parameter lists (number, type, or order of parameters).
  * Improves readability by grouping logically similar actions under one method name.
* **Example: Method Overloading**

```java
class Calculator {
    int add(int a, int b) {
        return a + b;
    }

    double add(double a, double b) {
        return a + b;
    }

    int add(int a, int b, int c) {
        return a + b + c;
    }
}

public class Main {
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        System.out.println(calc.add(5, 10));        // Calls int version
        System.out.println(calc.add(5.5, 3.2));    // Calls double version
        System.out.println(calc.add(1, 2, 3));     // Calls three-argument version
    }
}
```

### **2. Runtime Polymorphism (Dynamic Polymorphism)**

Runtime polymorphism occurs when the method to be invoked is determined at runtime. It is achieved through **method overriding**.

* **Key Characteristics**
  * Decision about which method to call is made during program execution.
  * Involves a superclass reference pointing to a subclass object.
  * Enables flexible and extensible system design.
* **Example: Method Overriding**

```java
class Animal {
    void sound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    @Override
    void sound() {
        System.out.println("Dog barks");
    }
}

class Cat extends Animal {
    @Override
    void sound() {
        System.out.println("Cat meows");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal a;

        a = new Dog();
        a.sound(); // Dog barks

        a = new Cat();
        a.sound(); // Cat meows
    }
}
```

### Comparison

<table data-full-width="true"><thead><tr><th width="165.40625">Aspect</th><th>Compile-Time Polymorphism</th><th>Runtime Polymorphism</th></tr></thead><tbody><tr><td><strong>Decision Time</strong></td><td>Determined during compilation</td><td>Determined during execution</td></tr><tr><td><strong>Implementation</strong></td><td>Method Overloading</td><td>Method Overriding</td></tr><tr><td><strong>Performance</strong></td><td>Slightly faster (no runtime lookup)</td><td>Slightly slower (due to dynamic method dispatch)</td></tr><tr><td><strong>Flexibility</strong></td><td>Less flexible</td><td>Highly flexible</td></tr></tbody></table>

## How Polymorphism Works in Java ?

Polymorphism in Java is the ability of an object to take on many forms. While the concept is simple at the surface level, the mechanism behind it involves compile-time checks, runtime object type resolution, and method table lookups within the JVM.

Polymorphism operates in **two main ways**

1. **Compile-Time (Static) Polymorphism** – method resolution happens during compilation.
2. **Runtime (Dynamic) Polymorphism** – method resolution happens during program execution.

#### **1. Compile-Time Polymorphism (Method Overloading Mechanism)**

When using **method overloading**, the Java compiler decides which method to call **based on**:

* The method name.
* The number of parameters.
* The type and order of parameters.

**Process at Compile-Time**

1. The compiler scans all methods with the same name.
2. It matches the best method signature based on arguments provided.
3. The actual method call is hard-coded into the bytecode.

```java
class MathUtils {
    int multiply(int a, int b) { return a * b; }
    double multiply(double a, double b) { return a * b; }
}

public class Main {
    public static void main(String[] args) {
        MathUtils m = new MathUtils();
        System.out.println(m.multiply(5, 3));       // int version
        System.out.println(m.multiply(4.5, 2.2));  // double version
    }
}
```

**Note:** No runtime decision is made here; the compiler embeds direct calls.

#### **2. Runtime Polymorphism (Method Overriding Mechanism)**

In **method overriding**, the decision about which method to call is made **at runtime**, depending on the **actual object type**, not the reference type.

**How It Works Under the Hood ?**

1. **Reference Variable and Object Creation**
   * We can have a **parent class reference** pointing to a **child class object**.
   * The reference type decides **which methods are accessible**, but **the object type decides which overridden method will run**.
2. **Virtual Method Table (vtable)**
   * Each class has a **method table** that stores addresses of methods the class can execute.
   * When we override a method, the child class **replaces** the parent’s method entry in this table.
   * At runtime, when the method is called through a reference, the JVM **looks up the method in the vtable** of the object’s class and executes it.
3. **Dynamic Method Dispatch**
   * This is the process where the call to an overridden method is **resolved at runtime**.
   * The JVM determines the actual method implementation based on the object the reference points to.

**Example: Dynamic Method Dispatch in Action**

```java
class Animal {
    void speak() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    @Override
    void speak() {
        System.out.println("Dog barks");
    }
}

class Cat extends Animal {
    @Override
    void speak() {
        System.out.println("Cat meows");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal a; // reference type

        a = new Dog(); // object type Dog
        a.speak(); // Dog's method called

        a = new Cat(); // object type Cat
        a.speak(); // Cat's method called
    }
}
```

## Use Cases of Polymorphism

Polymorphism isn’t just a language feature - it’s a design enabler. It allows Java developers to write code that’s **extensible, reusable, and easy to maintain**.

#### **1. Implementing Flexible APIs**

* **Scenario**: We want a single interface that can accept multiple data types or object behaviors.
* **How Polymorphism Helps**: We can accept a **parent class** or **interface** as a method parameter, and pass any subclass object.
* **Example:**

```java
void processPayment(PaymentMethod method) {
    method.pay();
}
// Can accept CreditCard, UPI, PayPal, etc.
```

#### **2. Code Reuse and Extensibility**

* **Scenario**: We need to add new functionality without modifying existing code.
* **How Polymorphism Helps**: New subclasses can override methods without changing calling logic.
* **Example**: Adding a new `Shape` type (`Triangle`) without changing the drawing code:

```java
for (Shape s : shapes) {
    s.draw(); // works for Circle, Square, Triangle, etc.
}
```

#### **3. Frameworks and Libraries**

* **Scenario**: Libraries like Spring, Hibernate, and JUnit depend heavily on polymorphism.
* **How Polymorphism Helps**: We can pass in any object implementing a required interface, and the framework calls overridden methods at runtime.
* **Example**: In Spring MVC, a controller method can return any object that implements `ModelAndView`.

#### **4. Dependency Injection**

* **Scenario**: Swap out one implementation for another without changing client code.
* **How Polymorphism Helps**: Use interfaces and inject different concrete classes.
* **Example**:

```java
public class ReportService {
    private ReportGenerator generator;
    public ReportService(ReportGenerator generator) {
        this.generator = generator;
    }
    public void generate() { generator.generate(); }
}
// Can pass PdfReportGenerator, ExcelReportGenerator, etc.
```

#### **5. Implementing Design Patterns**

Many GoF design patterns rely on polymorphism:

* **Strategy Pattern** – Swap algorithms at runtime.
* **Command Pattern** – Different commands implement the same interface.
* **Template Method Pattern** – Subclasses override certain steps of an algorithm.
* **Observer Pattern** – Different listener types respond to the same event method.

#### **6. Testability (Unit Testing & Mocking)**

* **Scenario**: We want to test code without depending on real implementations.
* **How Polymorphism Helps**: Replace actual objects with mocks or stubs implementing the same interface.
* **Example**: Mockito can mock service interfaces for testing.

#### **7. Unified Collections and Data Processing**

* **Scenario**: Store different object types in a single collection and process them in a uniform way.
* **Example**:

```java
List<Animal> animals = List.of(new Dog(), new Cat(), new Cow());
for (Animal a : animals) {
    a.speak(); // Each speaks differently
}
```

#### **8. Event Handling and Callbacks**

* **Scenario**: Different components respond differently to the same event.
* **How Polymorphism Helps**: Each listener class overrides the same method.
* **Example**: Java Swing event listeners (`actionPerformed`) or Android’s `onClick`.

#### **9. Runtime Behavior Customization**

* **Scenario**: We want to determine behavior at runtime based on object type, without hardcoding conditions.
* **Example**:

```java
Shape shape = getRandomShape();
shape.draw(); // runtime decision
```
