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





