# Model as an Interface or abstract class ?

## Model as an interface instead of an abstract class

In Java, we would model something as an interface instead of an abstract class in a situation where we need to define a contract that multiple, potentially unrelated classes can implement. Here are a few specific scenarios:

### **1. Multiple Inheritance of Type**

Java supports single inheritance for classes but allows a class to implement multiple interfaces. If we foresee that a class might need to implement multiple types, using an interface is the way to go. For example, a class `FlyingCar` might need to implement both `Vehicle` and `Flyable` interfaces:

```java
public interface Vehicle {
    void drive();
}

public interface Flyable {
    void fly();
}

public class FlyingCar implements Vehicle, Flyable {
    @Override
    public void drive() {
        // implementation
    }

    @Override
    public void fly() {
        // implementation
    }
}
```

### **2. Defining Capabilities Without Implementation**

Interfaces are ideal for defining capabilities that can be shared across different classes without any concern for how these capabilities are implemented. For example, if we have different classes like `Dog`, `Bird`, and `Fish`, and we want to define a capability `Moveable`, we would use an interface:

```java
public interface Moveable {
    void move();
}

public class Dog implements Moveable {
    @Override
    public void move() {
        // Dog-specific movement
    }
}

public class Bird implements Moveable {
    @Override
    public void move() {
        // Bird-specific movement
    }
}

public class Fish implements Moveable {
    @Override
    public void move() {
        // Fish-specific movement
    }
}
```

### **3. Contract for Service Providers**

When creating a service provider framework, interfaces are commonly used to define the contract that service providers must adhere to. This allows us to switch implementations easily without changing the client code. For instance, a `PaymentProcessor` interface could have different implementations like `PayPalProcessor` and `StripeProcessor`:

```java
public interface PaymentProcessor {
    void processPayment(double amount);
}

public class PayPalProcessor implements PaymentProcessor {
    @Override
    public void processPayment(double amount) {
        // PayPal-specific payment processing
    }
}

public class StripeProcessor implements PaymentProcessor {
    @Override
    public void processPayment(double amount) {
        // Stripe-specific payment processing
    }
}
```

In summary, we would choose an interface over an abstract class when we need to define a set of methods that can be implemented by any class, regardless of its place in the class hierarchy, and especially when we need to leverage Java's capability to implement multiple interfaces.

## Model as an abstract instead of an interface class

Modeling something as an abstract class instead of an interface is appropriate in situations where we want to provide a common base with shared code, default implementations, or shared state while still allowing for some methods to be overridden. Here are specific scenarios where an abstract class is preferred:

### **1. Providing Common Behavior**

If we need to provide some common behavior that multiple classes share, use an abstract class. For example, if several types of animals share some behavior like `eat` and `sleep`, but each has a different `makeSound` method, we could use an abstract class:

```java
public abstract class Animal {
    public void eat() {
        // common eating behavior
    }

    public void sleep() {
        // common sleeping behavior
    }

    public abstract void makeSound();
}

public class Dog extends Animal {
    @Override
    public void makeSound() {
        // Dog-specific sound
    }
}

public class Cat extends Animal {
    @Override
    public void makeSound() {
        // Cat-specific sound
    }
}
```

### **2. Sharing State**

If we need to share some common state or fields among different subclasses, an abstract class is the right choice. For example, we might have a `Shape` abstract class that has a `color` field:

```java
public abstract class Shape {
    protected String color;

    public Shape(String color) {
        this.color = color;
    }

    public String getColor() {
        return color;
    }

    public abstract double area();
}

public class Circle extends Shape {
    private double radius;

    public Circle(String color, double radius) {
        super(color);
        this.radius = radius;
    }

    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
}

public class Rectangle extends Shape {
    private double length;
    private double width;

    public Rectangle(String color, double length, double width) {
        super(color);
        this.length = length;
        this.width = width;
    }

    @Override
    public double area() {
        return length * width;
    }
}
```

### **3. Providing Partial Implementation**

If we want to provide a partial implementation that other classes can build upon, an abstract class is suitable. This allows us to enforce certain methods to be implemented while providing default implementations for others. For example, in a template method pattern:

```java
public abstract class DataProcessor {
    public void process() {
        readData();
        processData();
        writeData();
    }

    protected abstract void readData();

    protected abstract void processData();

    protected void writeData() {
        // default implementation for writing data
        System.out.println("Writing data to file");
    }
}

public class CSVDataProcessor extends DataProcessor {
    @Override
    protected void readData() {
        // CSV-specific data reading
        System.out.println("Reading CSV data");
    }

    @Override
    protected void processData() {
        // CSV-specific data processing
        System.out.println("Processing CSV data");
    }
}

public class JSONDataProcessor extends DataProcessor {
    @Override
    protected void readData() {
        // JSON-specific data reading
        System.out.println("Reading JSON data");
    }

    @Override
    protected void processData() {
        // JSON-specific data processing
        System.out.println("Processing JSON data");
    }
}
```



