# Abstraction

## Description

Abstraction is one of the key concepts in object-oriented programming (OOP) that allows to represent complex real-world entities in a simplified manner. It involves hiding the complex implementation details of a system or object and exposing only the essential features or functionalities to the outside world. Abstraction focuses on what an object does rather than how it accomplishes its tasks.

{% hint style="info" %}
Abstraction is a broader principle, while abstract classes are a specific tool used to implement abstraction.
{% endhint %}

## Key Points about Abstraction

1. **Hiding Complexity**: Abstraction hides the complex implementation details of a system or object, allowing users to interact with it at a higher level without needing to understand the intricacies of its internal workings.
2. **Essential Features**: Abstraction exposes only the essential features or behaviors of an object, providing a simplified interface for users to work with. This reduces complexity and improves usability.
3. **Generalization**: Abstraction involves identifying common patterns and characteristics among different objects or entities and representing them using a generalized form or concept. This helps in organizing and structuring code in a more modular and reusable manner.
4. **Encapsulation**: Abstraction is often achieved through encapsulation, which involves bundling data (attributes) and methods (behaviors) that operate on the data into a single unit, known as a class. Encapsulation hides the internal state of an object and exposes a controlled interface for interacting with it.
5. **Levels of Abstraction**: Abstraction can occur at multiple levels, ranging from high-level conceptual abstractions to low-level implementation details. For example, a high-level abstraction of a car might focus on its functionality (e.g., driving, braking), while a low-level abstraction might involve the specific mechanics of its engine.

## **Types of Abstraction in OOP**

1. **Data Abstraction:** This is primarily achieved through encapsulation. You hide data (fields) within a class and provide controlled access methods (getters and setters). Users interact with the object through these methods without worrying about the internal data structures.

```java
class Account {
  private double balance; // Private field to store balance

  public void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
    } else {
      // Handle invalid deposit attempt (e.g., throw an exception)
    }
  }

  public double getBalance() {
    return balance;
  }
}
```

In this example, the `balance` field is private, preventing direct access to the raw data. The `deposit` method allows controlled addition of funds, potentially performing validation. The `getBalance` method provides a way to retrieve the balance without exposing the ability to modify it directly.

Here, data abstraction is achieved by hiding the internal representation of the `balance` and providing controlled access methods.

2. **Procedural Abstraction:** This involves creating functions or methods that encapsulate a specific task or behavior. The method signature (name and parameters) defines the functionality, while the internal implementation details are hidden from the caller.

```java
public class MathUtils {

  public static int add(int a, int b) {
    return a + b;
  }

  public static double calculateArea(double radius) {
    return Math.PI * radius * radius;
  }
}
```

This example defines two static methods. `add` encapsulates the simple addition operation. `calculateArea` hides the formula and Math library usage for calculating the area of a circle. Both methods provide specific functionalities without revealing their internal implementation details.

3. **Class Abstraction:** A class itself is an abstraction. It defines a blueprint for creating objects with specific attributes (fields) and behaviors (methods). Users interact with objects of that class without needing to know the intricate details of how the class is implemented.

```
public class Car {
  private String model;
  private String color;

  public void startEngine() {
    System.out.println("Engine started");
  }

  public void accelerate() {
    System.out.println("Car is accelerating");
  }
}
```

The `Car` class defines a blueprint for creating car objects. It hides the complexities of a real car's engine, wheels, etc., focusing on the functionalities users interact with (start, accelerate). Users can create `Car` objects and call these methods without needing to know the underlying mechanics.

{% hint style="info" %}
#### Example of Abstraction:

Consider the concept of a `Vehicle` in a transportation system. From a user's perspective, a `Vehicle` can be abstracted as follows:

* **High-level Abstraction**: Users interact with a `Vehicle` by performing actions such as `drive`, `stop`, and `refuel`. They don't need to know the internal mechanisms of how these actions are implemented.
* **Low-level Abstraction**: Internally, a `Vehicle` might consist of various components such as an engine, wheels, and fuel tank. Each component has its own functionality and interacts with other components to achieve the desired behavior of the `Vehicle`. However, users interact with the `Vehicle` at a higher level, without needing to understand the details of each componen
{% endhint %}



## What is Abstract class?

### Description

An abstract class in Java is a class that cannot be instantiated directly, meaning you cannot create objects of an abstract class using the `new` keyword. Instead, it serves as a blueprint for other classes and may contain both abstract and concrete methods.

{% hint style="info" %}
#### Rules for Abstract Classes:

1. If a class contains at least one abstract method, it must be declared as abstract.
2. Abstract methods cannot have a body (implementation) and end with a semicolon (;).
3. Abstract classes cannot be instantiated directly with the `new` keyword.
4. Subclasses of an abstract class must either provide implementations for all abstract methods or be declared abstract themselves.
{% endhint %}

{% hint style="warning" %}
Thread is not a abstract class.

Opposite of Abstract class is concrete class.

Abstract class supports multilevel inheritance.

Interface is also used to achieve abstraction.
{% endhint %}

### **Key Characteristics**

1. **Abstract Keyword:** An abstract class is declared using the `abstract` keyword before the class name.

```java
// Abstract class
public abstract class Shape {
    // Abstract method
    public abstract double area();

    // Concrete method
    public void display() {
        System.out.println("This is a shape.");
    }
}
```

2. **Abstract Methods:** Abstract methods are method declarations that **don't have a body** (implementation). They are declared using the `abstract` keyword before the method return type. Subclasses that inherit from the abstract class **must provide implementations** for all inherited abstract methods. Abstract methods define the functionality that subclasses must adhere to, promoting a common interface within the class hierarchy.

```java
// Abstract class with abstract method
abstract class AbstractShape {
    // Abstract method without implementation
    public abstract double area();
}

// Concrete subclass implementing AbstractShape
class Circle extends AbstractShape {
    private double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    // Implementing abstract method
    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
}
```

3. **Non-Abstract Methods:** Abstract classes can also have concrete methods (methods with a body) that provide default implementations for common functionalities. Subclasses can inherit and potentially override these methods to customize behavior.

```java
// Abstract class with both abstract and concrete methods
abstract class AbstractShape {
    // Abstract method without implementation
    public abstract double area();

    // Concrete method with implementation
    public void display() {
        System.out.println("This is a shape.");
    }
}

// Concrete subclass implementing AbstractShape
class Circle extends AbstractShape {
    private double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    // Implementing abstract method
    @Override
    public double area() {
        return Math.PI * radius * radius;
    }
}
```

4. **Instantiation:** You cannot create objects directly from an abstract class using the `new` keyword. Subclasses, which are not abstract, can be instantiated.

```java
// Abstract class
abstract class AbstractShape {
    // Abstract method without implementation
    public abstract double area();
}

// Main class
public class Main {
    public static void main(String[] args) {
        // Cannot instantiate AbstractShape directly
        // AbstractShape shape = new AbstractShape(); // Error: Cannot instantiate abstract class

        // But can use polymorphism with concrete subclasses
        AbstractShape circle = new Circle(5);
        System.out.println("Area of circle: " + circle.area());
    }
}
```

5. **Can Contain Fields**: Abstract classes can contain fields (variables), constructors, static methods, and instance methods, similar to regular classes.

```java
// Abstract class with fields
abstract class Animal {
    private String name;

    // Constructor
    public Animal(String name) {
        this.name = name;
    }

    // Getter method for name
    public String getName() {
        return name;
    }

    // Abstract method
    public abstract void makeSound();
}

// Concrete subclass
class Dog extends Animal {
    // Constructor
    public Dog(String name) {
        super(name);
    }

    // Implementation of abstract method
    @Override
    public void makeSound() {
        System.out.println(getName() + " barks!");
    }
}

// Main class
public class Main {
    public static void main(String[] args) {
        Animal dog = new Dog("Buddy");
        dog.makeSound(); // Output: Buddy barks!
    }
}
```



### Other Details

#### Abstract class in Java can contain inner abstract classes, inner concrete classes, and static methods within it.

```java
abstract class OuterAbstract {
    // Abstract inner class
    abstract class InnerAbstract {
        public abstract void abstractMethod();
    }

    // Concrete inner class
    class InnerConcrete {
        public void concreteMethod() {
            System.out.println("Concrete method in InnerConcrete class.");
        }
    }

    // Static method
    public static void staticMethod() {
        System.out.println("Static method in OuterAbstract class.");
    }
}

public class Main {
    public static void main(String[] args) {
        // Accessing static method
        OuterAbstract.staticMethod(); // Output: Static method in OuterAbstract class.

        // Creating instance of concrete inner class
        OuterAbstract outer = new OuterAbstract() {
            // Anonymous subclass of OuterAbstract
        };
        OuterAbstract.InnerConcrete innerConcrete = outer.new InnerConcrete();
        innerConcrete.concreteMethod(); // Output: Concrete method in InnerConcrete class.

        // Creating instance of abstract inner class (needs to be extended)
        OuterAbstract.InnerAbstract innerAbstract = outer.new InnerAbstract() {
            @Override
            public void abstractMethod() {
                System.out.println("Abstract method implementation in InnerAbstract class.");
            }
        };
        innerAbstract.abstractMethod(); // Output: Abstract method implementation in InnerAbstract class.
    }
}
```

