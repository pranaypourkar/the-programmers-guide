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

{% hint style="info" %}
**How do default methods in interfaces work, and why were they introduced?**

* **Mechanics of Default Methods**: Default methods are regular methods with a body in an interface, marked with the `default` keyword. They allow interfaces to provide a standard implementation for a method, which implementing classes can either use as-is or override.
* **Purpose of Introduction**: Default methods were introduced in Java 8 to ensure backward compatibility, especially in cases like the Java Collections API. Adding new methods (e.g., `forEach`) to interfaces without breaking existing code was made possible by default methods.
* **Avoiding Code Duplication**: Default methods also help avoid code duplication by allowing common functionality across multiple classes to be defined directly within the interface.
{% endhint %}

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

All methods in an interface are implicitly `public` and `abstract` (unless they are `default` or `static`). Private methods were introduced in Java 9 for use inside the interface only. Protected and default (package-private) methods are not allowed in interfaces and will cause compilation error.

```java
interface MyInterface {

    // Implicitly public and abstract
    void abstractMethod();

    // Public method (explicitly mentioned)
    public void publicMethod();

    // Default method (Introduced in Java 8)
    default void defaultMethod() {
        System.out.println("Default Method: Allowed in interface since Java 8");
        privateMethod(); // Private methods can be called inside interface
    }

    // Static method (Introduced in Java 8)
    static void staticMethod() {
        System.out.println("Static Method: Allowed in interface since Java 8");
    }

    // Private method (Introduced in Java 9) - Used for internal logic
    private void privateMethod() {
        System.out.println("Private Method: Only callable inside interface");
    }

    // ❌ Not Allowed: Protected and Default (Package-Private) methods
    // protected void protectedMethod();  // Compilation Error
    // void packagePrivateMethod();       // Compilation Error
}

// Implementing class
class MyClass implements MyInterface {

    @Override
    public void abstractMethod() {
        System.out.println("Overriding abstractMethod");
    }

    @Override
    public void publicMethod() {
        System.out.println("Overriding publicMethod");
    }
}

public class Main {
    public static void main(String[] args) {
        MyClass obj = new MyClass();

        obj.abstractMethod();  // Works
        obj.publicMethod();    // Works
        obj.defaultMethod();   // Works

        // Static method call (only via interface name)
        MyInterface.staticMethod();

        // ❌ Private methods cannot be called outside interface
        // obj.privateMethod(); // Compilation Error

        // ❌ Protected and default (package-private) methods are not allowed
    }
}

```

## **Interface Inheritance**

Interfaces can extend other interfaces. This means one interface can inherit the abstract methods of another interface. A class implementing the extended interface must implement all methods from both the parent and the child interfaces.

{% hint style="info" %}
**How would we handle method conflicts when a class implements multiple interfaces with the same method signature?**

If two interfaces define the same method signature without a default implementation, there’s no conflict; the implementing class must simply provide its own implementation of the method.

```java
interface InterfaceA {
    void printMessage();
}

interface InterfaceB {
    void printMessage();
}

class MyClass implements InterfaceA, InterfaceB {
    @Override
    public void printMessage() {
        System.out.println("MyClass implementation of printMessage");
    }
}

public class Main {
    public static void main(String[] args) {
        MyClass obj = new MyClass();
        obj.printMessage(); // Output: MyClass implementation of printMessage
    }
}
```

If both interfaces have a default implementation for the same method, the implementing class must override the method to resolve the conflict. This is done by explicitly calling the desired interface’s method using `InterfaceName.super.methodName()` syntax within the overridden method, allowing you to specify which default method to use.

```java
interface InterfaceA {
    default void printMessage() {
        System.out.println("InterfaceA default implementation");
    }
}

interface InterfaceB {
    default void printMessage() {
        System.out.println("InterfaceB default implementation");
    }
}

class MyClass implements InterfaceA, InterfaceB {
    @Override
    public void printMessage() {
        // Resolving the conflict by calling the specific interface's default implementation
        InterfaceA.super.printMessage();
        InterfaceB.super.printMessage();
        System.out.println("MyClass custom implementation");
    }
}

public class Main {
    public static void main(String[] args) {
        MyClass obj = new MyClass();
        obj.printMessage();
        // InterfaceA default implementation
        // InterfaceB default implementation
        // MyClass custom implementation
    }
}
```
{% endhint %}



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

## **Nested Interface**

A **nested interface** is an interface declared inside another interface or class. It is useful when we want to logically group interfaces together or restrict their scope to a particular enclosing class. They must be implemented by another class just like a normal interface.

### **Types of Nested Interfaces**

#### **1. Interface inside another Interface**

When an interface is declared inside another interface, it is implicitly public and static. The nested interface can be accessed using OuterInterface.InnerInterface.

```java
// Outer Interface
interface OuterInterface {

    // Abstract method in OuterInterface
    void outerMethod();

    // Nested Interface (implicitly public and static)
    interface InnerInterface {
        void innerMethod();
    }
}

// Implementing OuterInterface
class OuterClass implements OuterInterface {

    @Override
    public void outerMethod() {
        System.out.println("Implemented outerMethod from OuterInterface");
    }
}

// Implementing InnerInterface
class InnerClass implements OuterInterface.InnerInterface {

    @Override
    public void innerMethod() {
        System.out.println("Implemented innerMethod from InnerInterface");
    }
}

public class Main {
    public static void main(String[] args) {
        // Implementing OuterInterface
        OuterInterface outerObj = new OuterClass();
        outerObj.outerMethod();

        // Implementing InnerInterface
        OuterInterface.InnerInterface innerObj = new InnerClass();
        innerObj.innerMethod();
        
        /* Output:
        Implemented outerMethod from OuterInterface
        Implemented innerMethod from InnerInterface
        */
    }
}
```

#### **2. Interface inside a Class**

When an interface is declared inside a **class**, it can have **any access modifier** (`public`, `private`, `protected`, or default). It is used when the interface should only be used within that class.

{% hint style="success" %}
* `public interface PublicInner` - Can be accessed and implemented from anywhere.
* `protected interface ProtectedInner` - Can be accessed and implemented within the same package or subclasses.
* `interface DefaultInner` _(Package-Private) -_ Can be accessed and implemented only within the same package.
* `private interface PrivateInner` - Cannot be directly implemented outside `OuterClass`, so it's accessed through a method that returns an anonymous class.
{% endhint %}

```java
// Outer class
class OuterClass {

    // Public Nested Interface
    public interface PublicInner {
        void publicMethod();
    }

    // Protected Nested Interface
    protected interface ProtectedInner {
        void protectedMethod();
    }

    // Default (Package-Private) Nested Interface
    interface DefaultInner {
        void defaultMethod();
    }

    // Private Nested Interface
    private interface PrivateInner {
        void privateMethod();
    }

    // Method to return an instance of PrivateInner using an anonymous class
    public PrivateInner getPrivateInner() {
        return new PrivateInner() {
            @Override
            public void privateMethod() {
                System.out.println("Implemented privateMethod() from PrivateInner");
            }
        };
    }
}

// Implementing the Public Nested Interface
class PublicClass implements OuterClass.PublicInner {
    @Override
    public void publicMethod() {
        System.out.println("Implemented publicMethod() from PublicInner");
    }
}

// Implementing the Protected Nested Interface
class ProtectedClass implements OuterClass.ProtectedInner {
    @Override
    public void protectedMethod() {
        System.out.println("Implemented protectedMethod() from ProtectedInner");
    }
}

// Implementing the Default (Package-Private) Nested Interface
class DefaultClass implements OuterClass.DefaultInner {
    @Override
    public void defaultMethod() {
        System.out.println("Implemented defaultMethod() from DefaultInner");
    }
}

public class Main {
    public static void main(String[] args) {
        // Public Nested Interface
        OuterClass.PublicInner publicObj = new PublicClass();
        publicObj.publicMethod();

        // Protected Nested Interface
        OuterClass.ProtectedInner protectedObj = new ProtectedClass();
        protectedObj.protectedMethod();

        // Default Nested Interface
        OuterClass.DefaultInner defaultObj = new DefaultClass();
        defaultObj.defaultMethod();

        // Accessing Private Nested Interface via OuterClass method
        OuterClass outer = new OuterClass();
        OuterClass.PrivateInner privateObj = outer.getPrivateInner();
        privateObj.privateMethod();
        
        /* Output:
        Implemented publicMethod() from PublicInner
        Implemented protectedMethod() from ProtectedInner
        Implemented defaultMethod() from DefaultInner
        Implemented privateMethod() from PrivateInner
        */
    }
}
```

## **Interface in Design Patterns**

Interface are often foundational in design patterns, particularly in cases like the _Strategy Pattern_, _Observer Pattern_, and _Decorator Pattern_.

### **Strategy Pattern**

The **Strategy Pattern** defines a family of algorithms, encapsulates each one, and makes them interchangeable. This pattern lets the algorithm vary independently from clients that use it. Interfaces are often used here to define a "strategy" interface that various concrete implementations (strategies) can adhere to.

**Example:**

Imagine a context where we have different payment methods (e.g., `CreditCardPayment` and `PayPalPayment`) that follow the same `PaymentStrategy` interface.

```java
// Strategy interface
public interface PaymentStrategy {
    void pay(double amount);
}

// Concrete Strategy 1
public class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;

    public CreditCardPayment(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    @Override
    public void pay(double amount) {
        System.out.println("Paid " + amount + " using Credit Card.");
    }
}

// Concrete Strategy 2
public class PayPalPayment implements PaymentStrategy {
    private String email;

    public PayPalPayment(String email) {
        this.email = email;
    }

    @Override
    public void pay(double amount) {
        System.out.println("Paid " + amount + " using PayPal.");
    }
}

// Context class
public class ShoppingCart {
    private PaymentStrategy paymentStrategy;

    // Set the payment strategy at runtime
    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }

    public void checkout(double amount) {
        paymentStrategy.pay(amount);
    }
}

public class Main {
    public static void main(String[] args) {
        ShoppingCart cart = new ShoppingCart();

        // Using credit card payment
        cart.setPaymentStrategy(new CreditCardPayment("1234-5678-9012-3456"));
        cart.checkout(150.0);  // Output: Paid 150.0 using Credit Card.

        // Switching to PayPal payment
        cart.setPaymentStrategy(new PayPalPayment("user@example.com"));
        cart.checkout(150.0);  // Output: Paid 150.0 using PayPal.
    }
}
```

### **Observer Pattern**

The **Observer Pattern** defines a one-to-many dependency between objects, so when one object changes state, all its dependents are notified and updated automatically. Interfaces allow defining the `Observer` interface that can be implemented by different types of observers.

**Example:**

Consider a `WeatherStation` that notifies various `Observer` objects (like a `MobileDevice` and `WebApp`) whenever weather data changes.

```java
// Observer interface
public interface Observer {
    void update(double temperature, double humidity);
}

// Concrete Observer 1
public class MobileDevice implements Observer {
    @Override
    public void update(double temperature, double humidity) {
        System.out.println("Mobile Device - Temperature: " + temperature + ", Humidity: " + humidity);
    }
}

// Concrete Observer 2
public class WebApp implements Observer {
    @Override
    public void update(double temperature, double humidity) {
        System.out.println("Web App - Temperature: " + temperature + ", Humidity: " + humidity);
    }
}

// Subject class
public class WeatherStation {
    private List<Observer> observers = new ArrayList<>();
    private double temperature;
    private double humidity;

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    public void setMeasurements(double temperature, double humidity) {
        this.temperature = temperature;
        this.humidity = humidity;
        notifyObservers();
    }

    private void notifyObservers() {
        for (Observer observer : observers) {
            observer.update(temperature, humidity);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        WeatherStation station = new WeatherStation();

        Observer mobileDevice = new MobileDevice();
        Observer webApp = new WebApp();

        station.addObserver(mobileDevice);
        station.addObserver(webApp);

        station.setMeasurements(28.5, 65.0);
        // Output:
        // Mobile Device - Temperature: 28.5, Humidity: 65.0
        // Web App - Temperature: 28.5, Humidity: 65.0
    }
}
```

### **Decorator Pattern**

The **Decorator Pattern** allows behavior to be added to individual objects, dynamically, without affecting the behavior of other objects from the same class. The `Component` interface allows for interchangeable decorations.

**Example:**

Consider a scenario where we have a `Coffee` interface, and different coffee types can have additional options like `Milk` or `Sugar`.

```java
// Component interface
public interface Coffee {
    String getDescription();
    double getCost();
}

// Concrete Component
public class SimpleCoffee implements Coffee {
    @Override
    public String getDescription() {
        return "Simple coffee";
    }

    @Override
    public double getCost() {
        return 5.0;
    }
}

// Abstract Decorator class implementing the same interface
public abstract class CoffeeDecorator implements Coffee {
    protected Coffee decoratedCoffee;

    public CoffeeDecorator(Coffee coffee) {
        this.decoratedCoffee = coffee;
    }

    @Override
    public String getDescription() {
        return decoratedCoffee.getDescription();
    }

    @Override
    public double getCost() {
        return decoratedCoffee.getCost();
    }
}

// Concrete Decorators
public class MilkDecorator extends CoffeeDecorator {
    public MilkDecorator(Coffee coffee) {
        super(coffee);
    }

    @Override
    public String getDescription() {
        return decoratedCoffee.getDescription() + ", Milk";
    }

    @Override
    public double getCost() {
        return decoratedCoffee.getCost() + 1.5;
    }
}

public class SugarDecorator extends CoffeeDecorator {
    public SugarDecorator(Coffee coffee) {
        super(coffee);
    }

    @Override
    public String getDescription() {
        return decoratedCoffee.getDescription() + ", Sugar";
    }

    @Override
    public double getCost() {
        return decoratedCoffee.getCost() + 0.5;
    }
}

public class Main {
    public static void main(String[] args) {
        // Simple coffee
        Coffee coffee = new SimpleCoffee();
        System.out.println(coffee.getDescription() + " $" + coffee.getCost());
        // Output: Simple coffee $5.0

        // Coffee with milk
        coffee = new MilkDecorator(coffee);
        System.out.println(coffee.getDescription() + " $" + coffee.getCost());
        // Output: Simple coffee, Milk $6.5

        // Coffee with milk and sugar
        coffee = new SugarDecorator(coffee);
        System.out.println(coffee.getDescription() + " $" + coffee.getCost());
        // Output: Simple coffee, Milk, Sugar $7.0
    }
}
```

## **How does the JVM handle interfaces internally, and how does it resolve method calls for default and static methods?**

* **Interface Table (ITable)**: When a class implements an interface, the JVM creates an **interface table** (ITable) that links methods declared in the interface to the actual implementation in the class. This enables polymorphic behavior.
* **Default Method Resolution**: When a default method is invoked, the JVM first checks if the class overrides the method. If not, it checks the ITable to resolve the default method in the interface. If multiple interfaces contain conflicting default methods, the JVM throws an error unless the implementing class resolves the conflict by overriding the method.
* **Static Methods**: Static methods in interfaces are resolved based on the interface name, as they belong to the interface itself and cannot be called on instances of implementing classes. The JVM doesn’t look for static methods in the ITable; it simply invokes them directly on the interface.
