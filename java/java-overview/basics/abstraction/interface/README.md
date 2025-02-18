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

Interface methods are implicitly `public`. We cannot have non-public methods in an interface.

```java
public interface Animal {
    void makeSound();  // Implicitly public
}
```

## **Interface Inheritance**

Interfaces can extend other interfaces. This means one interface can inherit the abstract methods of another interface. A class implementing the extended interface must implement all methods from both the parent and the child interfaces.

{% hint style="info" %}
**How would we handle method conflicts when a class implements multiple interfaces with the same method signature?**

* If two interfaces define the same method signature without a default implementation, there’s no conflict; the implementing class must simply provide its own implementation of the method.

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

* If both interfaces have a default implementation for the same method, the implementing class must override the method to resolve the conflict. This is done by explicitly calling the desired interface’s method using `InterfaceName.super.methodName()` syntax within the overridden method, allowing you to specify which default method to use.

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
