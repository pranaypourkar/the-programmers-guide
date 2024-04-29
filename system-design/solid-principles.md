# SOLID Principles

## Description

SOLID is a set of five principles that help developers design object-oriented code that's easier to understand, maintain, and extend. They were introduced by Robert C. Martin to promote better software design.

## **S - Single Responsibility Principle (SRP)**

This principle states that a class should have only one reason to change, meaning that it should have only one responsibility or job. If a class does more than one thing, it becomes harder to understand, maintain, and reuse.

**Example**: Consider a class called `Employee` that manages both employee information and payroll calculations. According to SRP, this violates the principle because the class has multiple responsibilities. Instead, we could split it into two classes: one for managing employee information (`Employee`) and another for handling payroll calculations (`Payroll`).

## **O - Open/Closed Principle (OCP)**&#x20;

This principle suggests that software entities (such as classes, modules, functions, etc.) should be open for extension but closed for modification. In other words, we should be able to extend the behavior of a module without modifying its source code.

**Example**: Suppose we have a class `Shape` with a method `calculateArea()`, and we want to add support for new shapes without modifying the `Shape` class. We can achieve this by creating a new subclass for each shape (e.g., `Circle`, `Square`) and implementing the `calculateArea()` method in each subclass. This way, we extend the behavior without modifying existing code.

## **L - Liskov Substitution Principle (LSP)**&#x20;

Named after Barbara Liskov, this principle states that objects of a superclass should be replaceable with objects of a subclass without affecting the correctness of the program. In simpler terms, if S is a subtype of T, then objects of type T may be replaced with objects of type S without altering any of the desirable properties of the program.

**Example**: Let's say we have a class hierarchy for shapes, with `Rectangle` and `Square` as subclasses. According to LSP, we should be able to substitute a `Square` object wherever a `Rectangle` object is expected without affecting the behavior of the program. However, if `Square` overrides the width and height properties of `Rectangle` and prevents them from being independent, it violates LSP.

## **I - Interface Segregation Principle (ISP)**&#x20;

This principle emphasizes that clients should not be forced to depend on interfaces they do not use. It suggests that you should break interfaces that are too large into smaller, more specific ones so that clients only need to know about the methods that are relevant to them.

**Example**: Consider an interface called `Worker` that has methods for both manual labor (`workWithHands()`) and office work (`workWithComputer()`). However, not all classes that implement `Worker` need to perform both types of work. Instead, we can split the interface into smaller, more specific interfaces like `ManualWorker` and `OfficeWorker`, allowing classes to implement only the methods they need.

## **D - Dependency Inversion Principle (DIP)**&#x20;

This principle states that high-level modules should not depend on low-level modules; both should depend on abstractions. It also suggests that abstractions should not depend on details; rather, details should depend on abstractions. This helps in achieving decoupling and allows for easier changes and substitutions.

**Example**: Suppose we have a `FileLogger` class that logs messages to a file. Instead of directly creating an instance of `FileLogger` within another class, we can use dependency injection to pass an instance of `Logger` (an abstraction) to the dependent class. This way, the dependent class doesn't depend on the concrete implementation (`FileLogger`), but on an abstraction (`Logger`). This makes it easier to switch to a different logging mechanism in the future without modifying the dependent class

