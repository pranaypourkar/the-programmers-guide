# Object-Oriented Design

## About

Object-Oriented Design (OOD) is the process of planning a system of interacting objects to solve a software problem while following object-oriented programming (OOP) principles.

It involves:

* Identifying the key objects and their interactions.
* Applying principles like **encapsulation, abstraction, inheritance, and polymorphism**.
* Designing scalable, maintainable, and efficient systems.

## **Why is OOD Important in Software Development?**

OOD is a **fundamental** part of software development because it provides a structured and maintainable way to design software systems.

### **1. Improves Code Maintainability**

* Easier Debugging & Updates
* Encapsulation ensures that changes in one class **don’t break** other parts of the system.
* If a bug is found, it’s localized to a specific **object or class**, making it easier to fix.

**Example:**\
Imagine a banking system where `BankAccount` is encapsulated:

```java
public class BankAccount {
    private double balance;
    
    public void deposit(double amount) {
        if (amount > 0) balance += amount;
    }
    
    public double getBalance() { return balance; }
}
```

If we later **change** how balances are stored (e.g., switch to BigDecimal), other parts of the code **won’t break** since they interact only through `getBalance()`.

### **2. Enhances Code Reusability**

* **Write Once, Use Multiple Times**
* With **inheritance and polymorphism**, you can reuse existing code instead of rewriting it.
* Avoids **duplicate logic**, reducing the risk of bugs.

**Example:**\
If we have different types of users in a system, we can create a base `User` class and extend it for different roles:

```java
class User { 
    String name; 
    void login() { System.out.println("Logging in..."); } 
}

class Admin extends User { 
    void accessAdminPanel() { System.out.println("Accessing admin panel..."); } 
}

class Customer extends User { 
    void browseProducts() { System.out.println("Browsing products..."); } 
}
```

`Admin` and `Customer` **reuse** `login()`, reducing code duplication.

### **3. Supports Scalability & Extensibility**

* **Easy to add new features** without modifying existing code.
* Ensures **long-term scalability** as systems grow.

**Example:**\
If we need to add **more vehicle types** to our `ParkingLot`, we can do so **without changing existing code**:

```java
abstract class Vehicle {
    String licensePlate;
}

class Car extends Vehicle { }
class Bike extends Vehicle { }
class Truck extends Vehicle { }  // Newly added vehicle type!
```

The system **easily extends** without breaking anything.

### **4. Enhances Team Collaboration**

* **Modular Design:** Teams can work on different classes **independently**.
* **Clear Responsibilities:** Each class has a single job (**SRP - Single Responsibility Principle**).

**Example:**\
In a **shopping app**, different teams can work on separate modules:

* **Order Management Team** → `Order`, `Payment` classes.
* **User Management Team** → `User`, `Authentication` classes.
* **Product Management Team** → `Product`, `Inventory` classes.

Teams can work **simultaneously** without interfering with each other.

### **5. Improves Code Readability & Understanding**

* **OOD makes complex systems more intuitive.**
* A properly designed **class hierarchy** makes it easy for **new developers** to understand the system.

**Example:**\
Which is easier to understand?

**Without OOD:**

```java
void processOrder(String userType, double amount) { 
    if (userType.equals("Admin")) { 
        // Admin discount logic
    } else if (userType.equals("Customer")) { 
        // Regular discount logic
    }
}
```

**With OOD:**

```java
abstract class User { abstract double getDiscount(); }

class Admin extends User { double getDiscount() { return 0.2; } }
class Customer extends User { double getDiscount() { return 0.1; } }

void processOrder(User user, double amount) { 
    double discount = user.getDiscount();
}
```

The second approach is **cleaner, easier to extend, and eliminates if-else clutter**.

### **6. Enables Better Testing**

* **Modular testing** becomes easier when code follows **OOD principles**.
* Unit tests can be written **independently** for each class.

**Example:**

* If a bug occurs in the `Payment` class, we can test **just that class** without affecting `User` or `Order`.
* **Mocking dependencies** is easier in OOD-based designs.

**Better separation = Easier testing**.

### **7. Encourages the Use of Design Patterns**

* OOD naturally aligns with **design patterns**, which solve common software design problems.
  * **Factory Pattern** → Used for object creation.
  * **Strategy Pattern** → Used for dynamic behavior selection.
  * **Singleton Pattern** → Used for **one-instance** objects (e.g., database connections).

**Example (Factory Pattern for creating shapes):**

```java
interface Shape { void draw(); }

class Circle implements Shape {
    public void draw() { System.out.println("Drawing Circle"); }
}

class Rectangle implements Shape {
    public void draw() { System.out.println("Drawing Rectangle"); }
}

class ShapeFactory {
    public static Shape getShape(String type) {
        if (type.equals("Circle")) return new Circle();
        if (type.equals("Rectangle")) return new Rectangle();
        return null;
    }
}

public class Main {
    public static void main(String[] args) {
        Shape shape = ShapeFactory.getShape("Circle");
        shape.draw();
    }
}
```

**Factory Pattern** simplifies object creation and makes the system **more flexible**.

### **8. Promotes Security & Data Protection**

* **Encapsulation hides** sensitive data.
* Users can only access data **via controlled methods**.

**Example:**

```java
public class SecureUser {
    private String password;
    
    public void setPassword(String password) {
        this.password = hashPassword(password);
    }
    
    private String hashPassword(String password) {
        // Hashing logic here...
        return "hashedValue";
    }
}
```

The raw password is **never exposed** outside the class.

### **9. Makes Code More Adaptable to Change**

* **OOD reduces "ripple effects"** when making changes.
* If we update a **single class**, the rest of the system remains stable.

**Example:**\
If we need to **change** the `Payment` processing method, we just modify **one class** instead of changing multiple parts of the system.

## Object-Oriented Concepts in OOD

### OOP Principles

* Encapsulation
* Abstraction
* Inheritance
* Polymorphism

{% content-ref url="../../../java/java-overview/basics/" %}
[basics](../../../java/java-overview/basics/)
{% endcontent-ref %}

### **Use Design Patterns**

{% content-ref url="../design-pattern/" %}
[design-pattern](../design-pattern/)
{% endcontent-ref %}

### **UML Diagrams for OOD**

UML (Unified Modeling Language) diagrams help visualize OOD.

#### **Common UML Diagrams**

* **Class Diagram** → Shows class relationships.
* **Sequence Diagram** → Shows object interactions.
* **Use Case Diagram** → Defines user interactions.
* **Component Diagram** → Illustrates system components.

{% content-ref url="../../diagrams.md" %}
[diagrams.md](../../diagrams.md)
{% endcontent-ref %}



## **Steps in Object-Oriented Design**

### **Step 1: Understand Requirements**

Before jumping into code, ask **clarifying questions** to refine the problem:

* What are the **core functionalities** of the system?
* What are the **inputs and outputs**?
* Should it handle **concurrency** or **scalability**?

### **Step 2: Identify Key Objects & Classes**

Extract **nouns** from the problem statement (these often become classes).

* Example: **"A parking lot has multiple floors, each with different parking spots."**
  * **Classes:** `ParkingLot`, `Floor`, `ParkingSpot`, `Vehicle`.
  * **Attributes:** `floorNumber`, `spotNumber`, `isAvailable`.
  * **Methods:** `parkCar()`, `removeCar()`, `findNearestSpot()`.

### **Step 3: Define Relationships Between Objects**

Different classes **interact** in various ways:

* **Inheritance (`is-a`)** → A `Truck` **is-a** `Vehicle`.
* **Composition (`has-a`)** → A `ParkingLot` **has** multiple `Floors`.
* **Association** → `Driver` is associated with `Vehicle`.
* **Aggregation** → `Library` contains multiple `Books`, but books can exist independently.

### **Step 4: Define Behaviours & Interactions**

* Which objects communicate with each other?
* What **methods** should each class have?
* What **design patterns** can help?

## **Example: Design a Parking Lot**

#### **Requirements:**

* A parking lot has **multiple floors**.
* Each floor has different **types of spots** (compact, large, handicapped).
* A `Vehicle` can `park()` and `leave()`.

#### **Class Diagram Approach**

```java
class ParkingLot {
    private List<Floor> floors;
}

class Floor {
    private List<ParkingSpot> spots;
}

class ParkingSpot {
    private boolean isAvailable;
    private Vehicle parkedVehicle;
}

abstract class Vehicle {
    String licensePlate;
}

class Car extends Vehicle { }
class Bike extends Vehicle { }
```

`ParkingLot` **has-a** `Floor`, which **has-a** `ParkingSpot`.
