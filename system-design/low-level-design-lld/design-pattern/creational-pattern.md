# Creational Pattern

## Description

Creational patterns in software engineering deal with the process of object creation in a flexible and reusable manner. They aim to provide mechanisms to instantiate objects in various situations while promoting loose coupling between the creator and the created objects. Creational patterns often involve hiding the object creation logic and making the system more independent of how its objects are created, composed, and represented

## Types of Creational Pattern

### **Singleton Pattern**

#### Description

The Singleton Pattern ensures a <mark style="background-color:yellow;">class</mark> has only one instance and provides a global point of access to that instance. It involves creating a class with a method that returns the same instance of the class every time it's called, thus restricting the instantiation of the class to a single object. It's like having a single source of truth for a specific concept within your application.

Imagine a scenario where we only need one instance of a class throughout the application. For example, a system might have a single `Logger` object to handle all logging activities, or a configuration manager to hold all application settings. The Singleton Pattern ensures this by:

1. **Restricting object creation:** The constructor of the Singleton class is typically private or protected, preventing direct instantiation from outside the class.
2. **Providing a static method:** A public static method, often named `getInstance()`, is used to access the single instance. If the instance doesn't exist, it's created on the first call and returned. Subsequent calls reuse the same instance.

#### **Benefits of Singleton Pattern**

* **Global access point:** Provides a centralized and consistent way to access the single instance.
* **Resource management:** Ensures only one instance exists, which can be helpful for managing resources like file handles or database connections.
* **Enforces single instance:** Guarantees that there's only one instance of the class, preventing conflicts or inconsistencies.

#### **Drawbacks of Singleton Pattern**

* **Tight coupling:** Code that relies on the Singleton class becomes tightly coupled to it, making testing and refactoring more challenging.
* **Global state:** The Singleton instance holds global state, which can be difficult to manage and reason about in complex applications.
* **Limited flexibility:** It might be difficult to create multiple instances for testing or special scenarios.

#### Example

```java
public class Logger {
    // Private static instance variable
    private static Logger instance;
    
    // Private constructor to prevent instantiation
    private Logger() {
        // Initialization logic
    }
    
    // Public static method to get the singleton instance
    public static Logger getInstance() {
        // Lazy initialization: Create the instance if it doesn't exist
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }
    
    // Public method to log messages
    public void log(String message) {
        System.out.println("Logging: " + message);
        // Additional logging logic
    }
}
```

{% hint style="info" %}
In a Spring Boot application, the Singleton pattern is utilized extensively due to the nature of Spring's bean management. By default, Spring manages beans as singletons within the container, meaning that only one instance of a bean is created per container context.

**Example: UserService in a Spring Boot Application**

Suppose we have a UserService class responsible for managing user-related operations, such as fetching user data from a database, performing user authentication, and so on. We want to ensure that there's only one instance of UserService throughout the application, so we annotate it with `@Service` (or `@Component`) to let Spring manage it as a singleton:

```java
import org.springframework.stereotype.Service;

@Service
public class UserService {

    public void fetchUserData() {
        // Code to fetch user data from the database
        System.out.println("Fetching user data...");
    }

    public void authenticateUser() {
        // Code to authenticate user
        System.out.println("Authenticating user...");
    }
}
```

By default, Spring will create a single instance of `UserService` and manage it as a singleton bean within the application context. Let's use the `UserService` in a controller. We inject the `UserService` dependency using constructor injection. When the Spring Boot application starts up, Spring creates a single instance of `UserService` and manages it as a singleton bean within the application context. Whenever the `UserController` is instantiated, it receives the same instance of `UserService`. This ensures that all requests to `/userdata` endpoint is handled by the same instance of `UserService`, maintaining consistency and preventing unnecessary object creation.

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
public class UserController {

    private final UserService userService;

    @GetMapping("/userdata")
    public String getUserData() {
        userService.fetchUserData();
        return "User data fetched successfully!";
    }
}
```
{% endhint %}

### **Factory Method Pattern**

#### Description

The Factory Method Pattern is a creational design pattern that provides an interface for creating objects in a superclass but allows subclasses to alter the type of objects that will be created. It defines an interface for creating an object, but subclasses are responsible for instantiating the appropriate concrete class. This pattern promotes loose coupling between the creator and the created objects, allowing the creator to defer object creation to its subclasses.

Imagine a scenario where you need to create different types of objects based on certain conditions, but you want to keep the client code (code that uses the objects) decoupled from the specific object creation logic. The Factory Method Pattern achieves this by:

1. **Defining a Factory Interface:** This interface declares a method (often named `createProduct()`) that all concrete factory classes must implement. This method returns an instance of a product (the object to be created).
2. **Creating Concrete Factory Classes:** These classes implement the `FactoryInterface` and provide specific implementations for the `createProduct()` method. Each concrete factory creates a specific type of product.
3. **Client Code Uses Factory:** The client code interacts with a factory object (often obtained through a static method or dependency injection) and calls the `createProduct()` method to get the desired product instance. It doesn't need to know the concrete class of the product being created.

#### **Benefits of Factory Method Pattern**

* **Decouples object creation:** Separates object creation logic from the client code, promoting loose coupling.
* **Flexibility in object creation:** Allows for creating different types of objects based on runtime conditions.
* **Open/Closed Principle compliance:** New concrete factories can be added without modifying existing client code.

#### **Drawbacks of Factory Method Pattern**

* **Introduces an extra layer of abstraction:** The factory classes add complexity compared to direct object creation.
* **Might not be necessary for simple scenarios:** If only a few object types exist, simpler approaches might be sufficient.

#### Example 1

```java
// Interface for creating Pizzas
public interface PizzaFactory {
  Pizza createPizza(String type);
}

// Concrete Factory Class for Margherita Pizza
public class MargheritaPizzaFactory implements PizzaFactory {
  @Override
  public Pizza createPizza(String type) {
    if (type.equals("Margherita")) {
      return new MargheritaPizza();
    } else {
      throw new IllegalArgumentException("Invalid pizza type");
    }
  }
}

// Concrete Factory Class for Hawaiian Pizza (similar structure)
public class HawaiianPizzaFactory implements PizzaFactory {
  @Override
  public Pizza createPizza(String type) {
    // ... (implementation to create Hawaiian Pizza)
  }
}

// Client Code (doesn't know concrete Pizza classes)
public class PizzaOrder {
  public Pizza orderPizza(String type, PizzaFactory factory) {
    return factory.createPizza(type);
  }
}

public class Main {
  public static void main(String[] args) {
    PizzaOrder order = new PizzaOrder();
    PizzaFactory factory = new MargheritaPizzaFactory(); // Choose factory
    Pizza pizza = order.orderPizza("Margherita", factory);
    // ... (use the pizza)
  }
}
```

#### Example 2

Create a Shape interface and concrete classes implementing the Shape interface.

<figure><img src="../../../.gitbook/assets/image (308).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../../../.gitbook/assets/image (309).png" alt="" width="311"><figcaption></figcaption></figure>

```java
// Shape interface
package src.main.java.shape;

public interface Shape {
    public void draw();
}


// Circle class
package src.main.java.shape;

public class Circle implements Shape{
    @Override
    public void draw() {
        System.out.println("Drawing Circle");
    }
}


// Square class
package src.main.java.shape;

public class Square implements Shape{
    @Override
    public void draw() {
        System.out.println("Drawing Square");
    }
}


// Rectangle class
package src.main.java.shape;

public class Rectangle implements Shape{
    @Override
    public void draw() {
        System.out.println("Drawing Rectangle");
    }
}


// ShapeFactory
package src.main.java.shape;

public class ShapeFactory {
    public static Shape getShape(String shapeType) {
        return switch (shapeType) {
            case "CIRCLE" -> new Circle();
            case "SQUARE" -> new Square();
            case "RECTANGLE" -> new Rectangle();
            default -> null;
        };
    }
}


// Main Application class
package src.main.java;

import src.main.java.shape.Shape;
import src.main.java.shape.ShapeFactory;

public class Application {
    public static void main(String[] args) {
        Shape shape1 = ShapeFactory.getShape("SQUARE");
        shape1.draw();

        Shape shape2 = ShapeFactory.getShape("CIRCLE");
        shape2.draw();

        Shape shape3 = ShapeFactory.getShape("RECTANGLE");
        shape3.draw();
    }
}
```

The Factory Method Pattern allows for flexible object creation by delegating the responsibility of creating objects to subclasses, making the system more extensible and maintainable. Each subclass can determine the type of object to create based on its specific requirements.

### **Abstract Factory Pattern**

The Abstract Factory Pattern is a creational design pattern that builds upon the Factory Method Pattern. It provides a way to create families of related objects without specifying their concrete types. The Abstract Factory Pattern is useful when we need to create multiple families of related objects or when we want to provide a level of abstraction for creating objects.

Imagine we have a scenario where we need to create multiple objects that belong to a specific family (e.g., a family of shapes like circle, square, or a family of UI elements like button, checkbox). The Abstract Factory Pattern helps create these families without exposing the concrete implementation details. Here's the approach:

* **Defining an Abstract Factory Interface:** This interface declares methods for creating each product within the family (e.g., `createShape()` and `createColor()` for shapes and colors).
* **Creating Concrete Factory Classes:** These classes implement the `AbstractFactoryInterface` and provide specific implementations for creating each product in the family. Each concrete factory creates a related set of products (e.g., a ShapeFactory might create Circle and Square, while a UIFactory might create Button and Checkbox).
* **Client Code Uses Factory:** The client code interacts with a concrete factory object (often obtained through a static method or dependency injection) and calls the specific create methods to get the desired product instances. Similar to the Factory Method Pattern, the client doesn't need to know the concrete class of the products being created.

#### **Benefits of Abstract Factory Pattern**

* **Creates families of objects:** Ensures consistent creation of related objects within a family.
* **Decouples object creation:** Separates object creation logic from the client code, promoting loose coupling.
* **Flexibility in product types:** Allows for creating different families of objects (shapes and colors, UI elements and data providers) without modifying existing code.

#### **Drawbacks of Abstract Factory Pattern**

* **More complex:** Introduces additional abstraction compared to the Factory Method Pattern.
* **Might be overkill for simple scenarios:** If you only need to create a few unrelated objects, simpler approaches might be more suitable.

#### Example 1

Consider a drawing application with shapes (circle, square) and colors (red, green). The Abstract Factory Pattern can be used to create these objects together. The `ShapeColorFactory` interface defines methods for creating shapes and colors. Concrete factories (`CircleRedFactory`, etc.) implement the interface and create related shapes and colors. The client code (`Drawing`) uses a factory object to get both a shape and a color without knowing their concrete classes.

```java
// Abstract Factory Interface for creating Shapes and Colors
public interface ShapeColorFactory {
  Shape createShape(String type);
  Color createColor(String type);
}

// Concrete Factory Class for creating Circle and Red objects
public class CircleRedFactory implements ShapeColorFactory {
  @Override
  public Shape createShape(String type) {
    if (type.equals("Circle")) {
      return new Circle();
    } else {
      throw new IllegalArgumentException("Invalid shape type");
    }
  }

  @Override
  public Color createColor(String type) {
    if (type.equals("Red")) {
      return new Red();
    } else {
      throw new IllegalArgumentException("Invalid color type");
    }
  }
}

// Concrete Factory Class for creating Square and Green objects (similar structure)
public class SquareGreenFactory implements ShapeColorFactory {
  // ... (implementations for creating Square and Green)
}

// Client Code (doesn't know concrete Shape or Color classes)
public class Drawing {
  public void draw(String shapeType, String colorType, ShapeColorFactory factory) {
    Shape shape = factory.createShape(shapeType);
    Color color = factory.createColor(colorType);
    // ... (use the shape and color for drawing)
  }
}

public class Main {
  public static void main(String[] args) {
    Drawing drawing = new Drawing();
    ShapeColorFactory factory = new CircleRedFactory(); // Choose factory
    drawing.draw("Circle", "Red", factory);
    // ... (draw other shapes and colors using different factories)
  }
}
```

#### Example 2

We have abstract product interfaces `Button` and `TextField` representing UI components. And concrete product classes `LightThemeButton`, `DarkThemeButton`, `LightThemeTextField`, and `DarkThemeTextField` that implement the abstract product interfaces with specific implementations for each theme. We have an abstract factory interface `GUIFactory` with factory methods `createButton()` and `createTextField()` for creating UI components. Also, we created concrete factory classes `LightThemeFactory` and `DarkThemeFactory` that implement the abstract factory interface and provide implementations for creating UI components for the Light Theme and Dark Theme, respectively.

We create instances of `LightThemeFactory` and `DarkThemeFactory` to represent factories for creating UI components for the Light Theme and Dark Theme, respectively. We use the factory methods `createButton()` and `createTextField()` to create UI components for the respective themes. The concrete factory classes (`LightThemeFactory` and `DarkThemeFactory`) internally handle the creation of UI components based on the specific theme.

```java
// Abstract Product A: Button
interface Button {
    void paint();
}

// Concrete Products A1: LightThemeButton
class LightThemeButton implements Button {
    @Override
    public void paint() {
        System.out.println("Rendering button in Light Theme");
        // Rendering logic for button in Light Theme
    }
}

// Concrete Products A2: DarkThemeButton
class DarkThemeButton implements Button {
    @Override
    public void paint() {
        System.out.println("Rendering button in Dark Theme");
        // Rendering logic for button in Dark Theme
    }
}

// Abstract Product B: TextField
interface TextField {
    void paint();
}

// Concrete Products B1: LightThemeTextField
class LightThemeTextField implements TextField {
    @Override
    public void paint() {
        System.out.println("Rendering text field in Light Theme");
        // Rendering logic for text field in Light Theme
    }
}

// Concrete Products B2: DarkThemeTextField
class DarkThemeTextField implements TextField {
    @Override
    public void paint() {
        System.out.println("Rendering text field in Dark Theme");
        // Rendering logic for text field in Dark Theme
    }
}

// Abstract Factory: GUIFactory
interface GUIFactory {
    Button createButton();
    TextField createTextField();
}

// Concrete Factories: LightThemeFactory and DarkThemeFactory
class LightThemeFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new LightThemeButton();
    }

    @Override
    public TextField createTextField() {
        return new LightThemeTextField();
    }
}

class DarkThemeFactory implements GUIFactory {
    @Override
    public Button createButton() {
        return new DarkThemeButton();
    }

    @Override
    public TextField createTextField() {
        return new DarkThemeTextField();
    }
}

public class Application {
    public static void main(String[] args) {
        // Create a Light Theme GUI
        GUIFactory lightThemeFactory = new LightThemeFactory();
        Button lightThemeButton = lightThemeFactory.createButton();
        TextField lightThemeTextField = lightThemeFactory.createTextField();

        // Render UI components
        lightThemeButton.paint();
        lightThemeTextField.paint();
        
        // Create a Dark Theme GUI
        GUIFactory darkThemeFactory = new DarkThemeFactory();
        Button darkThemeButton = darkThemeFactory.createButton();
        TextField darkThemeTextField = darkThemeFactory.createTextField();

        // Render UI components
        darkThemeButton.paint();
        darkThemeTextField.paint();
    }
}
```

#### Difference between Factory Method Pattern and Abstract Factory Pattern

| Feature            | Factory Method Pattern                                                           | Abstract Factory Pattern                                                                     |
| ------------------ | -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Focus              | Single type or related types                                                     | Families of related objects                                                                  |
| Structure          | Factory interface + Concrete Factories                                           | Abstract Factory + Concrete Factories                                                        |
| Client Interaction | Calls factory to get a product                                                   | Calls factory to get products from a family                                                  |
| Benefits           | Decoupling, Flexibility                                                          | Consistency, Flexibility, Multiple Families                                                  |
| Number of Methods  | Typically includes a single factory method for creating a single type of object. | Typically includes multiple factory methods for creating different types of related objects. |
| Drawbacks          | Extra abstraction, Simple cases                                                  | More complex, Overkill for simple cases                                                      |

### **Builder Pattern**

#### **Description**

The Builder Pattern is a creational design pattern that separates the construction of a complex object from its representation, allowing the same construction process to create different representations. It is useful when you need to create an object with many optional parameters or a complex construction process, and you want to keep the construction logic separate from the actual object construction. The Builder Pattern promotes fluent and readable object creation code by providing a step-by-step approach to constructing objects.

Imagine if we have a complex object with many optional parameters. Creating such objects directly with a large constructor can be cumbersome and error-prone. The Builder Pattern provides a solution by:

1. **Defining a Builder Class:** This class has methods for setting optional and mandatory properties of the object being constructed. Each method typically returns the builder object itself, allowing for method chaining (calling multiple builder methods consecutively).
2. **Building the Object:** The builder class also provides a `build()` method that takes the partially constructed object and returns the final, immutable object.

#### Example

A computer can have various optional components, such as a CPU, RAM, storage, graphics card, etc. We can use the Builder Pattern to create a ComputerBuilder class with methods for configuring each component, and a Computer class to represent the final constructed computer. The `build()` method constructs and returns the final `Computer` object using the specified components.

```java
class Computer {
    private String cpu;
    private String ram;
    private String storage;
    private String graphicsCard;

    public Computer(String cpu, String ram, String storage, String graphicsCard) {
        this.cpu = cpu;
        this.ram = ram;
        this.storage = storage;
        this.graphicsCard = graphicsCard;
    }

    // Getters for computer components
    // ...
}

// Builder: ComputerBuilder
class ComputerBuilder {
    private String cpu;
    private String ram;
    private String storage;
    private String graphicsCard;

    public ComputerBuilder withCPU(String cpu) {
        this.cpu = cpu;
        return this;
    }

    public ComputerBuilder withRAM(String ram) {
        this.ram = ram;
        return this;
    }

    public ComputerBuilder withStorage(String storage) {
        this.storage = storage;
        return this;
    }

    public ComputerBuilder withGraphicsCard(String graphicsCard) {
        this.graphicsCard = graphicsCard;
        return this;
    }

    public Computer build() {
        return new Computer(cpu, ram, storage, graphicsCard);
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        Computer computer = new ComputerBuilder()
                .withCPU("Intel Core i7")
                .withRAM("16GB DDR4")
                .withStorage("512GB SSD")
                .withGraphicsCard("NVIDIA GeForce RTX 3080")
                .build();
    }
}
```

{% hint style="info" %}
Lombok provides an `@Builder` annotation that can be used to generate a builder class for a given class, eliminating the need to manually write the builder class.

```java
// Computer class
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
class Computer {
    private String cpu;
    private String ram;
    private String storage;
    private String graphicsCard;
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        Computer computer = Computer.builder()
                .cpu("Intel Core i7")
                .ram("16GB DDR4")
                .storage("512GB SSD")
                .graphicsCard("NVIDIA GeForce RTX 3080")
                .build();
    }
}
```
{% endhint %}

By using Lombok's `@Builder` annotation, we can achieve the same functionality as the manually written builder class with less code. Lombok takes care of generating the builder class and its methods, reducing the need for boilerplate code. This makes the code cleaner, more concise, and easier to maintain.

### **Prototype Pattern**

#### Description

The Prototype Pattern is a creational design pattern that allows to create new objects by copying an existing object, known as the prototype, instead of creating new instances from scratch. It is useful when the construction of new objects is more expensive or complex, and you want to avoid the overhead of repeated object creation by reusing existing instances. The Prototype Pattern promotes object creation by cloning existing objects, providing a convenient and efficient way to create new objects with similar properties.

Imagine if we have an object with a lot of internal data or complex initialization logic. Creating new instances of this object can be expensive or time-consuming. The Prototype Pattern addresses this by:

1. **Defining an Interface (Optional):** An interface (often named `Cloneable`) can be used to mark classes that support cloning. However, Java doesn't enforce interfaces for implementing the pattern.
2. **Implementing the `clone()` Method:** The class representing the prototype object implements the `clone()` method. This method typically performs a shallow copy of the object's state, creating a new object with the same values but independent references to mutable member variables.

#### **Benefits of Prototype Pattern**

* **Improved performance:** Reduces the cost of creating new objects, especially for complex objects.
* **Reduces memory usage:** By reusing existing objects, the prototype pattern can help optimize memory usage.
* **Customization:** You can modify the cloned object after creation to achieve variations.

#### **Drawbacks of Prototype Pattern**

* **Shallow copy issues:** Be mindful of shallow copying and handle references to mutable objects within the prototype appropriately (e.g., by deep copying them).
* **Complexity for mutable objects:** Managing the state of mutable objects within the prototype requires careful consideration.
* **Limited use cases:** Not all objects are suitable for cloning. The pattern might be unnecessary for simple objects.

#### **When to Use Prototype Pattern**

The Prototype Pattern is suitable when:

* We need to create multiple copies of an object that is expensive or complex to create.
* We want to customize newly created objects based on an existing one.

#### Example 1

Let's consider a example of a document editor application. Users can create documents with various formatting styles, such as font size, font style, and alignment. We can use the Prototype Pattern to create a prototype document object and then clone it to create new documents with similar properties.

We have a prototype class `Document` representing a document with content and formatting styles. The `Document` class implements the `Cloneable` interface to indicate that it supports cloning. We override the `clone()` method to create a **deep copy** of the `Document` object, including its content and styles. We then modify the content and styles of the new documents independently without affecting the prototype or other clones.

```java
// Document class
import java.util.ArrayList;
import java.util.List;

class Document implements Cloneable {
    private String content;
    private List<String> styles;

    public Document(String content, List<String> styles) {
        this.content = content;
        this.styles = styles;
    }

    // Getter methods for content and styles

    @Override
    public Document clone() throws CloneNotSupportedException {
        List<String> clonedStyles = new ArrayList<>(this.styles);
        return new Document(this.content, clonedStyles);
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) throws CloneNotSupportedException {
        // Create a prototype document
        Document prototypeDocument = new Document("Prototype Document", List.of("Bold", "Italic"));

        // Clone the prototype to create new documents
        Document document1 = prototypeDocument.clone();
        Document document2 = prototypeDocument.clone();

        // Modify the content and styles of new documents if needed
        document1.setContent("Document 1 Content");
        document1.getStyles().add("Underline");

        document2.setContent("Document 2 Content");
        document2.getStyles().remove("Bold");

        // Print the details of new documents
        System.out.println("Document 1: " + document1.getContent() + ", Styles: " + document1.getStyles());
        System.out.println("Document 2: " + document2.getContent() + ", Styles: " + document2.getStyles());
    }
}
```

#### Example 2

Consider a game where we need to create multiple enemies of the same type (e.g., Orcs). Instead of creating each Orc from scratch, you can use a prototype.

The `Orc` class implements `Cloneable` (optional). The `clone()` method creates a new `Orc` object with the same values as the prototype. The `clone()` method typically performs a **shallow copy**, meaning references to objects within the prototype (like the `Weapon` here) are also copied by reference, not by value.

```javascript
// Orc class
public class Orc implements Cloneable { // Implements Cloneable (optional)
  private String name;
  private int health;
  private Weapon weapon; // Reference to a Weapon object

  public Orc(String name, int health, Weapon weapon) {
    this.name = name;
    this.health = health;
    this.weapon = weapon;
  }

  @Override
  public Object clone() throws CloneNotSupportedException {
    Orc clone = new Orc(name, health, weapon); // Shallow copy
    return clone;
  }
}

// Game class which create multiple cloned objects
public class Game {
  public void spawnEnemies() throws CloneNotSupportedException {
    Orc prototype = new Orc("Default Orc", 100, new Weapon("Axe"));
    Orc enemy1 = (Orc) prototype.clone();
    Orc enemy2 = (Orc) prototype.clone();
    // ... (use enemy1 and enemy2 in the game)
  }
}
```
