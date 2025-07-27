# GRASP Principles

## About

GRASP (General Responsibility Assignment Software Patterns) is a set of **nine fundamental principles** used in Object-Oriented Design (OOD) to guide responsibility assignment in software systems. These principles help determine **which class should handle which responsibility**, ensuring a well-structured, maintainable, and scalable design.

{% hint style="success" %}
### **Why GRASP?**

In Object-Oriented Design, one of the most critical decisions is **how to assign responsibilities to classes and objects.** GRASP provides a systematic approach to make these decisions based on best practices.
{% endhint %}

## **The 9 GRASP Principles**

<table data-header-hidden data-full-width="true"><thead><tr><th width="246"></th><th></th></tr></thead><tbody><tr><td><strong>Principle</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>1. Information Expert</strong></td><td>Assign responsibility to the class that has the <strong>most information</strong> required to fulfil it.</td></tr><tr><td><strong>2. Creator</strong></td><td>The class that <strong>contains, aggregates, or closely uses</strong> another object should create it.</td></tr><tr><td><strong>3. Controller</strong></td><td>Assign system operations to a <strong>controller</strong> that handles incoming requests from the UI.</td></tr><tr><td><strong>4. Low Coupling</strong></td><td>Reduce dependencies between classes to improve maintainability.</td></tr><tr><td><strong>5. High Cohesion</strong></td><td>Keep related behavior within a single class to ensure clarity and reusability.</td></tr><tr><td><strong>6. Polymorphism</strong></td><td>Use interfaces or abstract classes to allow different implementations without modifying the calling code.</td></tr><tr><td><strong>7. Pure Fabrication</strong></td><td>Introduce a new class (not representing a real-world entity) to improve cohesion and reuse (e.g., a Service class).</td></tr><tr><td><strong>8. Indirection</strong></td><td>Use an intermediary to reduce direct coupling (e.g., a DAO class for database access).</td></tr><tr><td><strong>9. Protected Variations</strong></td><td>Use abstraction to protect the system from changes (e.g., Strategy Pattern, Factory Pattern).</td></tr></tbody></table>

## **1. Information Expert**

Assign a responsibility to the class that **has the necessary information** to fulfill it.

#### **Applicability:**

* If an object has **direct access** to the required data, it should handle the responsibility.
* Helps to **reduce dependencies** and keep behavior close to the data.

#### **Example:**

_A `Student` object calculates its own GPA instead of an external class doing it._

```java
class Student {
    private List<Double> grades;

    public double calculateGPA() {
        double total = grades.stream().mapToDouble(Double::doubleValue).sum();
        return total / grades.size();
    }
}
```

_Encapsulation is maintained: The data and logic stay in the same class._

## **2. Creator**

Assign the responsibility of creating an object to a class that has the **most logical** reason to do so.

#### **Applicability:**

A class **should create an instance** of another class if:

* It **contains** objects of that class.
* It **uses** the created object heavily.
* It has **the necessary data** to initialize the object.

#### **Example:**

_A `Customer` object creates an `Order` object since it logically owns orders._

```java
class Customer {
    List<Order> orders = new ArrayList<>();

    public Order createOrder() {
        Order order = new Order();
        orders.add(order);
        return order;
    }
}
```

## **3. Controller**

Assign the responsibility of **handling system events** to a dedicated **Controller** class.

#### **Applicability:**

* When designing the **entry point of a system (UI layer, API, service layer)**.
* A **Controller** class should delegate tasks to the relevant domain classes.

#### **Example:**

_A `BankController` class manages user transactions instead of the UI directly handling them._

```java
class BankController {
    private BankService bankService;

    public void deposit(int accountId, double amount) {
        bankService.deposit(accountId, amount);
    }
}
```

_Ensures separation of concerns between UI and business logic._

## **4. Low Coupling**

Reduce **dependencies** between classes to improve maintainability and flexibility.

#### **Applicability:**

* Avoid making changes in **one class** that require changes in multiple other classes.
* Use **dependency injection** and **interfaces** instead of hard dependencies.

#### **Example:**

_Using an interface instead of direct implementation in a service._

```java
interface PaymentGateway {
    void processPayment(double amount);
}

class PayPalPayment implements PaymentGateway {
    public void processPayment(double amount) {
        System.out.println("Processing via PayPal: $" + amount);
    }
}

class Order {
    private PaymentGateway paymentGateway;

    public Order(PaymentGateway paymentGateway) {
        this.paymentGateway = paymentGateway;
    }

    public void checkout(double amount) {
        paymentGateway.processPayment(amount);
    }
}
```

_Low Coupling allows switching from PayPal to Other without modifying the `Order` class._

## **5. High Cohesion**

Ensure that a class **focuses on a single responsibility** and avoids doing unrelated tasks.

#### **Applicability:**

* If a class handles **too many responsibilities**, break it into smaller classes.
* Classes should **group related functionality together**.

#### **Example:**

_Splitting `User` and `UserLogger` classes instead of mixing authentication & logging._

```java
class User {
    private String name;
    private String email;

    public void login(String password) {
        // Login logic
    }
}

class UserLogger {
    public static void logLoginAttempt(User user) {
        System.out.println("User logged in: " + user.getEmail());
    }
}
```

_High Cohesion ensures better readability and maintainability._

## **6. Polymorphism**

Use **interfaces and abstract classes** to allow different implementations to be handled uniformly.

#### **Applicability:**

* When multiple classes share **common behaviour but differ in implementation**.
* Enables **open-closed principle** (adding new behaviour without modifying existing code).

#### **Example:**

_Multiple payment methods implementing a common interface._

```java
interface Payment {
    void process(double amount);
}

class CreditCardPayment implements Payment {
    public void process(double amount) {
        System.out.println("Processing Credit Card payment: $" + amount);
    }
}

class PayPalPayment implements Payment {
    public void process(double amount) {
        System.out.println("Processing PayPal payment: $" + amount);
    }
}

class PaymentProcessor {
    public void pay(Payment payment, double amount) {
        payment.process(amount);
    }
}
```

## **7. Pure Fabrication**

Introduce a class that **does not represent a real-world object** but exists **purely for better separation of concerns**.

#### **Applicability:**

* When behaviour **doesn’t fit naturally into an existing class**.
* To **reduce coupling** and **increase cohesion**.

#### **Example:**

_A `Logger` class doesn’t represent a real-world entity but handles logging separately._

```java
class Logger {
    public static void log(String message) {
        System.out.println("[LOG] " + message);
    }
}
```

_Keeps logging concerns separate from business logic. Allows adding new payment methods without modifying `PaymentProcessor`._

## **8. Indirection**

Use an intermediate class to mediate between components to avoid direct coupling.

#### **Applicability:**

* When a **mediator** is needed to control interactions.
* Used in **event-driven architectures** or **dependency injection frameworks**.

#### **Example:**

_Using a `MessageBus` instead of direct communication between modules._

```java
class MessageBus {
    public static void send(String message) {
        System.out.println("Message sent: " + message);
    }
}

class Order {
    public void placeOrder() {
        MessageBus.send("Order placed!");
    }
}
```

_Allows flexibility in handling notifications or event-driven design._

## **9. Protected Variations**

Shield parts of a system from **unwanted changes** by using **abstractions, encapsulation, and interfaces**.

#### **Applicability:**

* When system components should be **extendable without modification**.
* Helps in following **Open-Closed Principle** (OCP).

#### **Example:**

_Using a database interface instead of hardcoding database logic in services._

```java
interface Database {
    void connect();
}

class MySQLDatabase implements Database {
    public void connect() {
        System.out.println("Connected to MySQL");
    }
}

class Application {
    private Database database;

    public Application(Database database) {
        this.database = database;
    }

    public void start() {
        database.connect();
    }
}
```

_Now we can switch databases without modifying `Application`._

