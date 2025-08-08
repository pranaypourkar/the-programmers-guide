# Inheritance vs. Composition

## About

In object-oriented programming, **Inheritance** and **Composition** are two fundamental techniques used to achieve **code reuse** and build relationships between classes. Though they aim for similar goals, they approach the problem differently and each has its own advantages and trade-offs.

## **What is Inheritance ?**

**Inheritance** is a mechanism where a class (subclass or child) derives from another class (superclass or parent), inheriting its fields and methods.

* Defines an "**is-a**" relationship.
* Promotes code reuse by allowing subclasses to inherit behaviour.
* Supports method overriding for polymorphism.

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
```

**Usage**

```java
Dog d = new Dog();
d.eat();   // inherited from Animal
d.bark();  // defined in Dog
```

## **What is Composition?**

**Composition** is a design technique in which a class is composed of one or more objects of other classes, allowing you to build complex types by combining simpler ones.

* Defines a "**has-a**" relationship.
* Offers greater flexibility and modularity.
* Behavior is achieved by delegating tasks to internal objects.

```java
class Engine {
    void start() {
        System.out.println("Engine starts");
    }
}

class Car {
    private Engine engine = new Engine();

    void startCar() {
        engine.start();  // delegation
        System.out.println("Car is running");
    }
}
```

**Usage**

```java
Car car = new Car();
car.startCar();
```

## Comparison

<table><thead><tr><th width="179.984375">Feature</th><th width="274.78125">Inheritance</th><th>Composition</th></tr></thead><tbody><tr><td>Relationship Type</td><td>"is-a"</td><td>"has-a"</td></tr><tr><td>Coupling</td><td>Tightly coupled (inherits implementation)</td><td>Loosely coupled (uses delegation)</td></tr><tr><td>Flexibility</td><td>Less flexible; tightly bound hierarchy</td><td>More flexible; can switch components</td></tr><tr><td>Code Reuse</td><td>Achieved through superclass</td><td>Achieved through composed objects</td></tr><tr><td>Method Overriding</td><td>Supports polymorphism</td><td>Doesn’t support overriding, but can delegate</td></tr><tr><td>Runtime Changes</td><td>Difficult</td><td>Easier to modify components</td></tr><tr><td>Hierarchy Depth</td><td>Can become deep and complex</td><td>Flatter and easier to manage</td></tr><tr><td>Example</td><td>Dog <strong>is-a</strong> Animal</td><td>Car <strong>has-a</strong> Engine</td></tr></tbody></table>

## **When to Use Inheritance & Composition ?**

Use inheritance when:

* The subclass is a **specialized version** of the superclass.
* There is a clear **is-a** relationship.
* We want to leverage **polymorphism** for method overriding.
* The base class provides **stable and reusable behavior**.

Use composition when:

* We need **flexibility** and **maintainability**.
* We want to change behavior at **runtime**.
* We want to **reuse functionality** without forming a strict hierarchy.
* We want to avoid the problems of deep inheritance trees.
