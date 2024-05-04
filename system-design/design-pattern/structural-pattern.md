# Structural Pattern

## Description

Structural patterns in software engineering deal with the composition of classes or objects to form larger structures while keeping the system flexible and efficient. These patterns focus on how classes and objects are connected or structured to provide new functionality or improve system architecture. Structural patterns often involve creating interfaces or abstract classes that define the structure of the system and providing implementations that realize this structure.



## Types of Structural Pattern

### **Adapter Pattern**

#### Description

The Adapter Pattern is a structural design pattern that allows objects with incompatible interfaces to work together. It acts as a bridge between two incompatible interfaces, converting the interface of a class into another interface that a client expects. The Adapter Pattern allows classes to work together that couldn't otherwise because of incompatible interfaces, promoting code reuse and interoperability.

Imagine if we have two existing classes with incompatible interfaces (methods, properties) that need to collaborate. The Adapter Pattern bridges this gap by:

1. **Defining an Adapter Class:** This class implements the target interface (the interface the client code expects) and also holds a reference to the incompatible object (the adaptee).
2. **Adapting the Interface:** The adapter class implements the target interface methods by delegating the work to the adaptee's methods or by converting data as needed.

#### **Benefits of Adapter Pattern**

* **Promotes reusability:** Allows you to reuse existing incompatible classes without modifying their code.
* **Improves maintainability:** Keeps the core functionality of the incompatible class separate from the adapter, making changes easier.
* **Increases flexibility:** Enables working with different implementations as long as they can be adapted to the target interface.

#### **Drawbacks of Adapter Pattern**

* **Increased complexity:** Introduces an extra layer of abstraction (the adapter class) which can add complexity.
* **Potential performance overhead:** Adapting method calls might introduce some overhead compared to direct calls.
* **Tight coupling to the adaptee:** Changes to the adaptee's interface might require modifications in the adapter.

#### **When to Use Adapter Pattern**

The Adapter Pattern is suitable when:

* You need to integrate with existing, incompatible classes or libraries.
* You want to isolate the core functionality of a class from the way it's used by clients.
* You anticipate needing to support different implementations that can be adapted to a common interface.

#### Example 1: Legacy printer interface and modern computer (client)

Consider a example where we have a legacy printer that only supports printing in plain text format, and we want to connect it to a modern computer that expects to print in PDF format. We can use the Adapter Pattern to create an adapter class that converts the modern computer's PDF printing interface into the legacy printer's plain text printing interface

We have target interface `Printer` that defines the interface expected by the client code for printing, an adaptee class `LegacyPrinter` that represents the legacy printer with a method to print in plain text format, an adapter class `PrinterAdapter` that implements the `Printer` interface and wraps the `LegacyPrinter` object.

```java
// Target interface: Printer
interface Printer {
    void print(String text);
}

// Adaptee: LegacyPrinter
class LegacyPrinter {
    void printPlainText(String text) {
        System.out.println("Printing plain text: " + text);
    }
}

// Adapter: PrinterAdapter
class PrinterAdapter implements Printer {
    private LegacyPrinter legacyPrinter;

    public PrinterAdapter(LegacyPrinter legacyPrinter) {
        this.legacyPrinter = legacyPrinter;
    }

    @Override
    public void print(String text) {
        // Convert PDF text to plain text format
        String plainText = convertPDFtoPlainText(text);
        // Call the legacy printer's method to print plain text
        legacyPrinter.printPlainText(plainText);
    }

    private String convertPDFtoPlainText(String pdfText) {
        // Convert PDF text to plain text format (simplified for demonstration)
        return "Converted from PDF: " + pdfText;
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a legacy printer
        LegacyPrinter legacyPrinter = new LegacyPrinter();

        // Create a printer adapter for the legacy printer
        Printer printerAdapter = new PrinterAdapter(legacyPrinter);

        // Modern computer expects to print in PDF format
        String pdfText = "PDF Document Content";

        // Call the print method on the adapter to print PDF text using the legacy printer
        printerAdapter.print(pdfText);
    }
}
```



#### Example 2: Legacy payment processor and e-commerce application (client)

Consider a scenario where you want to use a legacy payment processor library (adaptee) with your new e-commerce application (client code). The legacy library might have methods like `chargeCreditCard` while your application expects a `processPayment` method.

The `LegacyPaymentProcessor` interface represents the incompatible library. The `PaymentProcessor` interface defines the expected interface for your application. The `LegacyPaymentProcessorAdapter` implements the `PaymentProcessor` and adapts the `chargeCreditCard` method to the `processPayment` method.

```java
// Legacy Payment Processor Interface (incompatible with your application)
public interface LegacyPaymentProcessor {
  void chargeCreditCard(String cardNumber, double amount) throws PaymentException;
}

// Payment Processor you want to use in your application (target interface)
public interface PaymentProcessor {
  void processPayment(String paymentMethod, double amount) throws PaymentException;
}

// Adapter Class bridges the gap
public class LegacyPaymentProcessorAdapter implements PaymentProcessor {

  private LegacyPaymentProcessor legacyProcessor;

  public LegacyPaymentProcessorAdapter(LegacyPaymentProcessor legacyProcessor) {
    this.legacyProcessor = legacyProcessor;
  }

  @Override
  public void processPayment(String paymentMethod, double amount) throws PaymentException {
    if (paymentMethod.equals("credit_card")) {
      legacyProcessor.chargeCreditCard( /* extract card number from paymentMethod */, amount);
    } else {
      throw new UnsupportedOperationException("Only credit card payments supported");
    }
  }
}

// Client code (e-commerce application) uses the PaymentProcessor interface
public class ECommerce {
  private PaymentProcessor paymentProcessor;

  public ECommerce(PaymentProcessor paymentProcessor) {
    this.paymentProcessor = paymentProcessor;
  }

  public void makePurchase(double amount) throws PaymentException {
    paymentProcessor.processPayment("credit_card", amount);
  }
}

// Main Application class
public class Application {
  public static void main(String[] args) {
    LegacyPaymentProcessor legacyProcessor = new LegacyPaymentProcessorImpl(); // Legacy library
    PaymentProcessor adapter = new LegacyPaymentProcessorAdapter(legacyProcessor);
    ECommerce ecommerce = new ECommerce(adapter);
    ecommerce.makePurchase(100);
  }
}
```



### **Bridge Pattern**

#### Description

The Bridge Pattern is a structural design pattern that separates the abstraction from its implementation so that they can vary independently. It allows to create two separate hierarchies **one** for abstraction (interface or abstract class) and **one** for implementation (concrete class) and then **connect them together using composition**. This pattern promotes loose coupling between abstraction and implementation, enabling changes in one part of the system without affecting the other.

Imagine if we have a system with a complex hierarchy of classes representing different functionalities (e.g., shapes with different colors). The Bridge Pattern promotes flexibility and maintainability by separating these concerns:

1. **Defining an Abstraction Interface:** This interface defines the operations that can be performed on the object (e.g., draw a shape).
2. **Creating Concrete Implementations (Implementors):** These classes implement the functionalities behind the abstraction (e.g., specific shapes like circle, square).
3. **Creating a Bridge Class:** This class holds a reference to an implementor object and implements the abstraction interface. It delegates the actual work to the implementor object based on the chosen functionality.

#### **Benefits of Bridge Pattern**

* **Decoupling abstraction and implementation:** Allows independent changes to both aspects without affecting the other.
* **Improved maintainability:** Easier to modify or extend shapes and colors independently.
* **Increased flexibility:** Enables creating new combinations of shapes and colors easily.

#### **Drawbacks of Bridge Pattern**

* **Increased complexity:** Introduces additional classes (interfaces and bridge class) which can add complexity.
* **Potential performance overhead:** Delegation through the bridge class might introduce some overhead compared to direct calls.
* **Overkill for simple scenarios:** If the relationship between abstraction and implementation is straightforward, the pattern might be unnecessary.

#### **When to Use Bridge Pattern**

The Bridge Pattern is suitable when:

* We need to decouple an abstraction from its implementation for independent variation.
* We have a large hierarchy of classes with multiple variations (e.g., shapes with different behaviors and appearances).
* We anticipate the need to extend the system with new functionalities (shapes, colors) in the future.

#### Example

Let's consider example of a remote control for electronic devices, such as TVs and DVD players. Each device (TV or DVD player) can have different functionalities (turn on/off, adjust volume, change channels, etc.). We can use the Bridge Pattern to separate the abstraction (remote control) from its implementation (devices) and allow them to vary independently.

```java
// Abstraction: RemoteControl
abstract class RemoteControl {
    protected Device device;

    public RemoteControl(Device device) {
        this.device = device;
    }

    abstract void powerOn();
    abstract void powerOff();
    abstract void volumeUp();
    abstract void volumeDown();
    // Other abstract methods for controlling the device
}

// Implementor: Device
interface Device {
    void powerOn();
    void powerOff();
    void adjustVolume(int delta);
    // Other methods for device functionality
}

/ Concrete Implementor A: TV
class TV implements Device {
    @Override
    public void powerOn() {
        System.out.println("TV is powered on");
    }

    @Override
    public void powerOff() {
        System.out.println("TV is powered off");
    }

    @Override
    public void adjustVolume(int delta) {
        System.out.println("Adjusting TV volume by " + delta);
    }
    // Other methods specific to TV functionality
}

// Concrete Implementor B: DVDPlayer
class DVDPlayer implements Device {
    @Override
    public void powerOn() {
        System.out.println("DVD player is powered on");
    }

    @Override
    public void powerOff() {
        System.out.println("DVD player is powered off");
    }

    @Override
    public void adjustVolume(int delta) {
        // DVD player does not have volume control
    }
    // Other methods specific to DVD player functionality
}

// Refined Abstraction: BasicRemoteControl
class BasicRemoteControl extends RemoteControl {
    public BasicRemoteControl(Device device) {
        super(device);
    }

    @Override
    void powerOn() {
        device.powerOn();
    }

    @Override
    void powerOff() {
        device.powerOff();
    }

    @Override
    void volumeUp() {
        device.adjustVolume(1);
    }

    @Override
    void volumeDown() {
        device.adjustVolume(-1);
    }
    // Other methods for basic remote control functionality
}

// Using the bridge pattern in Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a TV
        TV tv = new TV();

        // Create a basic remote control for the TV
        RemoteControl basicRemote = new BasicRemoteControl(tv);

        // Use the basic remote control to power on the TV and adjust its volume
        basicRemote.powerOn();
        basicRemote.volumeUp();
        basicRemote.volumeDown();
        basicRemote.powerOff();
    }
}
```



### **Composite Pattern**

#### Description

The Composite Pattern is a structural design pattern that allows to compose objects into tree-like structures to represent part-whole hierarchies. It enables clients to treat individual objects and compositions of objects uniformly. In other words, clients can treat a single object and a group of objects in a uniform manner without distinguishing between them. This pattern is useful when you want to represent hierarchical structures of objects and apply operations uniformly across the entire hierarchy.

Imagine we have a complex system with objects that can be treated individually or as part of a larger group. The Composite Pattern allows you to handle them uniformly by:

1. **Defining a Component Interface:** This interface declares the operations (methods) that both individual objects (leaves) and composite objects (containers) can perform. These operations might include adding or removing child components and performing actions on the component itself.
2. **Creating Concrete Classes:** These classes implement the `Component` interface and represent individual objects (leaves) or composite objects (containers). Leaves typically implement the operations directly, while containers can delegate them to their child components.

#### **Benefits of Composite Pattern**

* **Uniform treatment of objects:** Allows treating individual objects and composite objects in the same way.
* **Hierarchical representation:** Models part-whole hierarchies effectively.
* **Flexible structure:** Enables building complex structures by composing objects.

#### **Drawbacks of Composite Pattern**

* **Increased complexity:** Introduces an extra layer of abstraction (the interface) which can add complexity.
* **Overkill for flat structures:** If you only have flat collections of objects, the pattern might be unnecessary.

#### **When to Use Composite Pattern**

The Composite Pattern is suitable when:

* We need to represent hierarchical structures where objects can be treated individually or as a whole.
* We want to perform operations on entire branches of the hierarchy.
* We anticipate needing to extend the structure with new types of objects

#### Example 1

Consider a file system where we have files and folders. Both files and folders can be treated as components in the hierarchy. The Composite Pattern allows to manage them uniformly.

The `FileSystemComponent` interface defines methods for managing and displaying files and folders. The `File` class implements the interface for individual files. The `Folder` class implements the interface for folders and can contain other components. Both files and folders can be treated uniformly using the `displayInfo()` method, which recursively traverses the tree structure for folders.

```java
// Component Interface (what can be done with a file or folder)
public interface FileSystemComponent {
  void displayInfo(); // Display name/size for files, structure for folders
  void addComponent(FileSystemComponent component); // Applicable to folders
  void removeComponent(FileSystemComponent component); // Applicable to folders
}

// Concrete Class (Leaf - File)
public class File implements FileSystemComponent {

  private String name;
  private int size;

  public File(String name, int size) {
    this.name = name;
    this.size = size;
  }

  @Override
  public void displayInfo() {
    System.out.println("File: " + name + " (" + size + " bytes)");
  }

  // Not applicable for files (empty implementations)
  @Override
  public void addComponent(FileSystemComponent component) {}
  @Override
  public void removeComponent(FileSystemComponent component) {}
}

// Concrete Class (Container - Folder)
public class Folder implements FileSystemComponent {

  private String name;
  private List<FileSystemComponent> components;

  public Folder(String name) {
    this.name = name;
    this.components = new ArrayList<>();
  }

  @Override
  public void displayInfo() {
    System.out.println("Folder: " + name);
    for (FileSystemComponent component : components) {
      component.displayInfo(); // Delegate to child components
    }
  }

  @Override
  public void addComponent(FileSystemComponent component) {
    components.add(component);
  }

  @Override
  public void removeComponent(FileSystemComponent component) {
    components.remove(component);
  }
}

public class Main {
  public static void main(String[] args) {
    Folder documents = new Folder("Documents");
    documents.addComponent(new File("report.txt", 1024));
    Folder work = new Folder("Work");
    work.addComponent(new File("presentation.pdf", 5120));
    documents.addComponent(work);
    documents.displayInfo(); // Output shows structure and file details
  }
}
```

#### Example 2

Let's consider another example of an organization structure, where employees are organized into departments, and departments can contain both individual employees and sub-departments. We can use the Composite Pattern to represent the organization structure as a tree-like hierarchy, with departments and individual employees as nodes.

In this example, we have an interface `Employee` representing individual employees and departments in the organization structure, a leaf class `IndividualEmployee` representing individual employees,  a composite class `Department` representing departments which can contain both individual employees and sub-departments and the `Department` class contains a list of employees (individual employees and sub-departments) and implements the `displayDetails()` method to display details of the department and its employees.

```java
// Component: Employee
interface Employee {
    void displayDetails();
}

// Leaf: IndividualEmployee
class IndividualEmployee implements Employee {
    private String name;

    public IndividualEmployee(String name) {
        this.name = name;
    }

    @Override
    public void displayDetails() {
        System.out.println("Employee: " + name);
    }
}

// Composite: Department
class Department implements Employee {
    private String name;
    private List<Employee> employees = new ArrayList<>();

    public Department(String name) {
        this.name = name;
    }

    public void addEmployee(Employee employee) {
        employees.add(employee);
    }

    @Override
    public void displayDetails() {
        System.out.println("Department: " + name);
        for (Employee employee : employees) {
            employee.displayDetails();
        }
    }
}

// Use the composite in the Main Application class
public class Application {
    public static void main(String[] args) {
        // Create individual employees
        Employee employee1 = new IndividualEmployee("John");
        Employee employee2 = new IndividualEmployee("Alice");

        // Create sub-departments
        Department marketingDepartment = new Department("Marketing");
        Department salesDepartment = new Department("Sales");

        // Add employees to departments
        marketingDepartment.addEmployee(employee1);
        salesDepartment.addEmployee(employee2);

        // Create the organization structure
        Department headOffice = new Department("Head Office");
        headOffice.addEmployee(marketingDepartment);
        headOffice.addEmployee(salesDepartment);

        // Display details of the organization structure
        headOffice.displayDetails();
    }
}
```



### **Decorator Pattern**

#### Description

The Decorator Pattern is a structural design pattern that allows behavior to be added to individual objects dynamically without affecting the behavior of other objects from the same class. It is useful when you want to add new functionalities to objects without altering their structure. The Decorator Pattern involves creating a set of decorator classes that are used to wrap concrete components. Each decorator class adds its own functionality to the component, which can be stacked on top of each other to create a combination of behaviors.

Imagine we have objects with functionalities that we want to modify or extend at runtime without changing their core implementation. The Decorator Pattern achieves this by:

1. **Defining a Component Interface:** This interface declares the core functionality of the objects you want to decorate.
2. **Creating Concrete Component Classes:** These classes implement the `Component` interface and represent the base objects with their core functionalities.
3. **Creating Decorator Classes:** These classes implement the `Component` interface and "wrap" a concrete component object. They add new functionalities or modify the behavior of the wrapped object dynamically. Decorators typically hold a reference to the wrapped component and delegate calls to it while potentially adding their own behavior before or after.

#### **Benefits of Decorator Pattern**

* **Dynamic extension of functionality:** Allows adding new functionalities to objects at runtime without modifying their original code.
* **Flexible composition:** You can combine different decorators to achieve complex behavior.
* **Loose coupling:** Decorators and components are loosely coupled, promoting maintainability.

#### **Drawbacks of Decorator Pattern**

* **Increased complexity:** Introduces additional classes (decorators) which can add complexity.
* **Potential performance overhead:** Decorator method calls can add some overhead compared to direct calls.
* **Can lead to long chains of decorators:** Managing a large number of decorators might become cumbersome.

#### **When to Use Decorator Pattern**

The Decorator Pattern is suitable when:

* We need to add functionalities to objects dynamically without subclassing.
* We want to support multiple layers of optional functionality.
* We anticipate the need to extend functionality in the future without modifying existing objects.

#### Example 1

Consider a example of a coffee ordering system, where customers can order various types of coffee with optional toppings such as milk, sugar, and whipped cream. We can use the Decorator Pattern to create decorators for each optional topping and then dynamically add them to the base coffee order.

In this example, we have an interface `Coffee` representing the base component for coffee orders, with methods to get the description and cost of the coffee. We have a concrete component `BasicCoffee` representing the basic coffee order without any toppings. We have an abstract decorator class `CoffeeDecorator` that implements the `Coffee` interface and wraps concrete components. We have concrete decorator classes `Milk` and `Sugar` that add milk and sugar toppings to the coffee order. We create a basic coffee order and then dynamically add milk and sugar toppings to it using decorators.

```java
// Component: Coffee
interface Coffee {
    String getDescription();
    double cost();
}

// Concrete Component: BasicCoffee
class BasicCoffee implements Coffee {
    @Override
    public String getDescription() {
        return "Basic Coffee";
    }

    @Override
    public double cost() {
        return 2.0;
    }
}

// Decorator: CoffeeDecorator
abstract class CoffeeDecorator implements Coffee {
    protected Coffee coffee;

    public CoffeeDecorator(Coffee coffee) {
        this.coffee = coffee;
    }

    @Override
    public String getDescription() {
        return coffee.getDescription();
    }

    @Override
    public double cost() {
        return coffee.cost();
    }
}

// Concrete Decorator: Milk
class Milk extends CoffeeDecorator {
    public Milk(Coffee coffee) {
        super(coffee);
    }

    @Override
    public String getDescription() {
        return coffee.getDescription() + ", Milk";
    }

    @Override
    public double cost() {
        return coffee.cost() + 0.5;
    }
}

// Concrete Decorator: Sugar
class Sugar extends CoffeeDecorator {
    public Sugar(Coffee coffee) {
        super(coffee);
    }

    @Override
    public String getDescription() {
        return coffee.getDescription() + ", Sugar";
    }

    @Override
    public double cost() {
        return coffee.cost() + 0.3;
    }
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a basic coffee order
        Coffee basicCoffee = new BasicCoffee();

        // Add milk and sugar toppings to the basic coffee order
        Coffee milkCoffee = new Milk(basicCoffee);
        Coffee milkSugarCoffee = new Sugar(milkCoffee);

        // Display description and cost of the decorated coffee order
        System.out.println("Description: " + milkSugarCoffee.getDescription());
        System.out.println("Cost: $" + milkSugarCoffee.cost());
    }
}
```

#### Example 2

Consider another example of a text editor where we can format text with functionalities like bold, italic, and underline. The Decorator Pattern allows to add these features dynamically:

In this example, the `Text` interface defines a method to get the text content. The `PlainText` class implements the interface for plain text. The `TextDecorator` is an abstract class that wraps a `Text` object and provides a base for concrete decorators. Concrete decorators like `BoldDecorator` and `ItalicDecorator` modify the text by adding HTML formatting tags

```java
// Component Interface (what can be done with text)
public interface Text {
  String getText();
}

// Concrete Component Class (Plain Text)
public class PlainText implements Text {

  private String text;

  public PlainText(String text) {
    this.text = text;
  }

  @Override
  public String getText() {
    return text;
  }
}

// Decorator Class (adds functionality)
public abstract class TextDecorator implements Text {

  private Text text;

  public TextDecorator(Text text) {
    this.text = text;
  }

  @Override
  public abstract String getText();

  // Delegate to the wrapped text and potentially add decoration logic
  protected String decorate(String text) {
    return text;
  }
}

// Concrete Decorators (specific formatting)
public class BoldDecorator extends TextDecorator {

  public BoldDecorator(Text text) {
    super(text);
  }

  @Override
  public String getText() {
    return "<b>" + decorate(super.getText()) + "</b>";
  }
}

public class ItalicDecorator extends TextDecorator {

  public ItalicDecorator(Text text) {
    super(text);
  }

  @Override
  public String getText() {
    return "<i>" + decorate(super.getText()) + "</i>";
  }
}

// Main Application class
public class Main {
  public static void main(String[] args) {
    Text text = new PlainText("Hello World");
    Text boldText = new BoldDecorator(text);
    Text italicBoldText = new ItalicDecorator(boldText);
    System.out.println(italicBoldText.getText()); // Output: <i><b>Hello World</b></i>
  }
}
```



### **Facade Pattern**

#### Description

The Facade Pattern is a structural design pattern that provides a simplified interface to a set of interfaces in a subsystem. It hides the complexities of the subsystem and provides a single interface that the client can use to interact with the subsystem. The Facade Pattern promotes loose coupling between the client and the subsystem by providing a high-level interface that shields the client from the details of the subsystem's implementation.

Imagine we have a complex system with many interacting objects and functionalities. The Facade Pattern provides a simplified interface (facade) to this complexity, hiding the underlying implementation details. Here's the approach:

1. **Defining a Facade Class:** This class acts as a single point of entry for interacting with the subsystem. It provides a simplified set of methods that expose essential functionalities of the complex system.
2. **Facade Implementation:** The facade class encapsulates the logic for interacting with the various objects within the subsystem. It might delegate calls to specific objects or orchestrate a sequence of operations to fulfill the requested functionality.

#### **Benefits of Facade Pattern**

* **Simplified interface:** Provides a simpler and more user-friendly way to interact with a complex system.
* **Decoupling client code:** Client code only interacts with the facade, hiding the internal implementation details.
* **Improved maintainability:** Changes within the subsystem can be contained within the facade without affecting client code.

#### **Drawbacks of Facade Pattern**

* **Reduced flexibility:** The facade might limit access to certain functionalities of the underlying objects.
* **Tight coupling between facade and subsystem:** Changes in the subsystem might require modifications to the facade.
* **Potential complexity for large systems:** For very large systems, managing a single facade class might become complex.

#### **When to Use Facade Pattern**

The Facade Pattern is suitable when:

* We have a complex system with many interacting objects.
* We want to provide a simplified interface for client code to interact with the system.
* We need to decouple client code from the implementation details of the subsystem.

#### Example

Consider a example of a home theater system, which consists of various subsystems such as the DVD player, amplifier, speakers, and screen. Each subsystem may have its own complex interface. We can use the Facade Pattern to create a home theater facade that provides a simple interface for common operations such as watching a movie.

In this example, we have a facade class `HomeTheaterFacade` that provides a simple interface for common operations such as watching a movie and ending the movie. We have subsystem classes `DVDPlayer`, `Amplifier`, `Speakers`, and `Screen` that represent the individual components of the home theater system. The `HomeTheaterFacade` class encapsulates the interactions with the subsystems and hides the complexities of the subsystems' interfaces.

```java
// Facade: HomeTheaterFacade
class HomeTheaterFacade {
    private DVDPlayer dvdPlayer;
    private Amplifier amplifier;
    private Speakers speakers;
    private Screen screen;

    public HomeTheaterFacade() {
        this.dvdPlayer = new DVDPlayer();
        this.amplifier = new Amplifier();
        this.speakers = new Speakers();
        this.screen = new Screen();
    }

    public void watchMovie(String movie) {
        System.out.println("Get ready to watch a movie...");
        dvdPlayer.turnOn();
        amplifier.turnOn();
        speakers.turnOn();
        screen.unroll();
        dvdPlayer.play(movie);
    }

    public void endMovie() {
        System.out.println("Shutting down the home theater system...");
        dvdPlayer.turnOff();
        amplifier.turnOff();
        speakers.turnOff();
        screen.rollUp();
    }
}

// Subsystem: DVDPlayer
class DVDPlayer {
    public void turnOn() {
        System.out.println("DVD player is powered on");
    }

    public void turnOff() {
        System.out.println("DVD player is powered off");
    }

    public void play(String movie) {
        System.out.println("Playing movie: " + movie);
    }
}

// Subsystem: Amplifier
class Amplifier {
    public void turnOn() {
        System.out.println("Amplifier is powered on");
    }

    public void turnOff() {
        System.out.println("Amplifier is powered off");
    }
    // Other amplifier methods
}

// Subsystem: Speakers
class Speakers {
    public void turnOn() {
        System.out.println("Speakers are powered on");
    }

    public void turnOff() {
        System.out.println("Speakers are powered off");
    }
    // Other speakers methods
}

// Subsystem: Screen
class Screen {
    public void unroll() {
        System.out.println("Screen is unrolled");
    }

    public void rollUp() {
        System.out.println("Screen is rolled up");
    }
    // Other screen methods
}

// Main Application class
public class Application {
    public static void main(String[] args) {
        // Create a home theater facade
        HomeTheaterFacade homeTheater = new HomeTheaterFacade();

        // Watch a movie using the home theater facade
        homeTheater.watchMovie("The Matrix");

        // End the movie using the home theater facade
        homeTheater.endMovie();
    }
}
```



### **Flyweight Pattern**

#### Description

The Flyweight Pattern is a structural design pattern that aims to minimize memory usage and improve performance by sharing as much data as possible with similar objects. It is particularly useful when dealing with a large number of objects that have similar or identical intrinsic state, and when the extrinsic state can be managed externally.



### **Proxy Pattern**

#### Description





