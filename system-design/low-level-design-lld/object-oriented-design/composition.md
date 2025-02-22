# Composition

## About

Composition is an **object-oriented design principle** where **one object contains another object** instead of inheriting from it. It is based on the **"has-a" relationship** rather than an **"is-a" relationship** (which is used in inheritance).

**Key Idea**: Instead of extending a class (inheritance), we create an instance of another class as a field inside our class and use its functionality.

{% hint style="danger" %}
Composition is not considered as one of the four fundamental OOP principles (Encapsulation, Abstraction, Inheritance, and Polymorphism). However, it is an important design concept within OOP.
{% endhint %}

## **Types of Composition**

There are two main types of composition:

### **1. Strong Composition (Composition) – "Lifelong Dependency"**

* **The contained object CANNOT exist without the containing object.**
* **Strong ownership**: If the main object is destroyed, the contained object is also destroyed.
* Represented by a **filled diamond** in UML.

**Example: A `Car` has an `Engine` (An Engine cannot exist without a Car)**

```java
class Engine {
    void start() { System.out.println("Engine starts"); }
}

class Car {
    private final Engine engine = new Engine(); // Engine belongs to Car
    
    void startCar() {
        engine.start();
    }
}
```

### **2. Weak Composition (Aggregation) – "Independent Relationship"**

* **The contained object CAN exist independently.**
* **Weak ownership**: If the main object is destroyed, the contained object can still exist.
* Represented by an **empty diamond** in UML.

**Example: A `University` has `Students`, but students can exist without a university.**

```java
class Student {
    String name;
    Student(String name) { this.name = name; }
}

class University {
    private List<Student> students = new ArrayList<>();
    
    void addStudent(Student student) {
        students.add(student);
    }
}
```

**Better Reusability**: Students can exist outside of a university.

### **Composition vs. Inheritance**

### **Comparison**

<table data-header-hidden data-full-width="true"><thead><tr><th width="220"></th><th></th><th></th></tr></thead><tbody><tr><td><em><strong>Feature</strong></em></td><td><em><strong>Composition</strong> (Preferred)</em></td><td><em><strong>Inheritance</strong> (Use with Caution)</em></td></tr><tr><td><strong>Relationship</strong></td><td><strong>"Has-a"</strong> (Car <strong>has-a</strong> Engine)</td><td><strong>"Is-a"</strong> (Car <strong>is-a</strong> Vehicle)</td></tr><tr><td><strong>Coupling</strong></td><td>Loosely Coupled</td><td>Tightly Coupled</td></tr><tr><td><strong>Code Reusability</strong></td><td>High</td><td>Moderate</td></tr><tr><td><strong>Flexibility</strong></td><td>More Flexible (can change components easily)</td><td>Less Flexible (inherited behavior is fixed)</td></tr><tr><td><strong>Encapsulation</strong></td><td>Strong (hides implementation details)</td><td>Weak (exposes superclass methods)</td></tr><tr><td><strong>Code Maintainability</strong></td><td>Easier</td><td>Harder (deep inheritance chains lead to complexity)</td></tr><tr><td><strong>Multiple Behaviour</strong></td><td>Can change behaviour at runtime</td><td>Fixed at compile time</td></tr><tr><td><strong>Example</strong></td><td>A <code>Car</code> contains an <code>Engine</code></td><td>A <code>Car</code> extends <code>Vehicle</code></td></tr></tbody></table>

### **When to Use Composition?**

* When we need **code reuse without tight coupling**.
* When we need **flexibility in changing object behaviour at runtime**.
* When **inheritance doesn’t make sense** (e.g., a `Car` is **not** an `Engine`, but it **has** an `Engine`).

{% hint style="success" %}
### **Why Composition is Preferred?**

* **More flexible** than inheritance (allows dynamic behavior changes).
* **Encapsulates implementation details** (avoids exposing unnecessary behavior).
* **Avoids tight coupling** (can replace contained objects without breaking existing code).
* **Enhances code reuse** (reusable independent components).
{% endhint %}

### **When to Use Inheritance?**

* When objects have a **clear hierarchical relationship** (`is-a`).
* When you need **default behaviour sharing** across multiple classes.

### **Code Example: Composition vs. Inheritance**

* **Bad Example (Using Inheritance Incorrectly)**

```java
class Engine {
    void start() { System.out.println("Engine starts"); }
}

// Incorrect: Car is not an Engine!
class Car extends Engine { }

public class Main {
    public static void main(String[] args) {
        Car car = new Car();
        car.start();  // Illogical: Car starts like an Engine?
    }
}
```

**Problem**: The `Car` class is not really an `Engine`, but it extends it, which breaks the **"is-a"** principle.

* **Good Example (Using Composition Correctly)**

```java
class Engine {
    void start() { System.out.println("Engine starts"); }
}

// Correct: Car has an Engine
class Car {
    private Engine engine; // Composition

    Car() { this.engine = new Engine(); } // Injecting dependency

    void startCar() { 
        System.out.println("Car is starting...");
        engine.start(); // Delegating functionality
    }
}

public class Main {
    public static void main(String[] args) {
        Car car = new Car();
        car.startCar();  // Outputs: Car is starting... Engine starts
    }
}
```

**Better Design**: `Car` contains an `Engine` but does not inherit from it. This keeps the **code flexible and maintainable**.





