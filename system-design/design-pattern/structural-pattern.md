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

[stackoverflow.com/questions/33840290/trouble-with-jcolorchooser-colors-when-drawing-different-shapes-java](https://stackoverflow.com/questions/33840290/trouble-with-jcolorchooser-colors-when-drawing-different-shapes-java)

The Bridge Pattern, another member of the Structural design pattern category, focuses on decoupling an abstraction from its implementation. This allows for independent variation of both aspects without affecting the other. Here's a breakdown similar to the previous ones:

**Concept:**

Imagine you have a system with a complex hierarchy of classes representing different functionalities (e.g., shapes with different colors). The Bridge Pattern promotes flexibility and maintainability by separating these concerns:

1. **Defining an Abstraction Interface:** This interface defines the operations that can be performed on the object (e.g., draw a shape).
2. **Creating Concrete Implementations (Implementors):** These classes implement the functionalities behind the abstraction (e.g., specific shapes like circle, square).
3. **Creating a Bridge Class:** This class holds a reference to an implementor object and implements the abstraction interface. It delegates the actual work to the implementor object based on the chosen functionality.

**Real-World Example:**

Consider a drawing application where you can have different shapes (circle, square) with different colors (red, green). The Bridge Pattern allows you to separate the concept of a shape from its color:

Java

```
// Abstraction Interface (what can be done with a shape)
public interface Shape {
  void draw();
}

// Concrete Implementations (specific shapes)
public class Circle implements Shape {
  @Override
  public void draw() {
    System.out.println("Drawing a circle");
  }
}

public class Square implements Shape {
  @Override
  public void draw() {
    System.out.println("Drawing a square");
  }
}

// Implementor Interface (what colors can provide)
public interface Color {
  void applyColor();
}

// Concrete Implementations (specific colors)
public class Red implements Color {
  @Override
  public void applyColor() {
    System.out.println("Applying red color");
  }
}

public class Green implements Color {
  @Override
  public void applyColor() {
    System.out.println("Applying green color");
  }
}

// Bridge Class (holds the implementor and delegates drawing)
public class ColoredShape {

  private Shape shape;
  private Color color;

  public ColoredShape(Shape shape, Color color) {
    this.shape = shape;
    this.color = color;
  }

  public void drawShape() {
    color.applyColor();
    shape.draw();
  }
}

public class Main {
  public static void main(String[] args) {
    Shape circle = new Circle();
    Color red = new Red();
    ColoredShape redCircle = new ColoredShape(circle, red);
    redCircle.drawShape(); // Output: Applying red color; Drawing a circle
  }
}
```

Use code with caution.content\_copy

In this example:

* The `Shape` interface defines the `draw()` method for all shapes.
* Concrete shapes (`Circle`, `Square`) implement the `Shape` interface.
* The `Color` interface defines the `applyColor()` method.
* Concrete colors (`Red`, `Green`) implement the `Color` interface.
* The `ColoredShape` class holds a `Shape` and a `Color` object and delegates the `drawShape()` method to them.

**Benefits of Bridge Pattern:**

* **Decoupling abstraction and implementation:** Allows independent changes to both aspects without affecting the other.
* **Improved maintainability:** Easier to modify or extend shapes and colors independently.
* **Increased flexibility:** Enables creating new combinations of shapes and colors easily.

**Drawbacks of Bridge Pattern:**

* **Increased complexity:** Introduces additional classes (interfaces and bridge class) which can add complexity.
* **Potential performance overhead:** Delegation through the bridge class might introduce some overhead compared to direct calls.
* **Overkill for simple scenarios:** If the relationship between abstraction and implementation is straightforward, the pattern might be unnecessary.

#### **When to Use Bridge Pattern:**

The Bridge Pattern is suitable when:

* You need to decouple an abstraction from its implementation for independent variation.
* You have a large hierarchy of classes with multiple variations (e.g., shapes with different behaviors and appearances).
* You anticipate the need to extend the system with new functionalities (shapes, colors) in the future.



### **Composite Pattern**

#### Description





### **Decorator Pattern**

#### Description





### **Facade Pattern**

#### Description





### **Flyweight Pattern**

#### Description





### **Proxy Pattern**

#### Description





