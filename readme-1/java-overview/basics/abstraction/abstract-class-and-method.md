# Abstract Class & Method

## About

An abstract class in Java is a class that cannot be instantiated directly, meaning we cannot create objects of an abstract class using the `new` keyword. Instead, it serves as a blueprint for other classes and may contain both abstract and concrete methods.

{% hint style="info" %}
**Rules for Abstract Classes:**

1. If a class contains at least one abstract method, it must be declared as abstract.
2. Abstract methods cannot have a body (implementation) and end with a semicolon (;).
3. Abstract classes cannot be instantiated directly with the `new` keyword.
4. Subclasses of an abstract class must either provide implementations for all abstract methods or be declared abstract themselves.
5. Subclasses are not required to override non-abstract methods but can choose to if they need to alter the default behavior provided in the abstract class. This enables polymorphic behavior while maintaining flexibility for subclasses.
{% endhint %}

{% hint style="warning" %}
Thread is not a abstract class.

Opposite of Abstract class is concrete class.

Abstract class supports multilevel inheritance.

Interface is also used to achieve abstraction.
{% endhint %}

{% hint style="success" %}
Partial Implementation: Abstract classes allow partial implementation, where a class can have both abstract (unimplemented) and concrete (implemented) methods. This flexibility  provide default behaviors while enforcing that subclasses implement specific methods.
{% endhint %}

## **Abstract Keyword**

An abstract class or method is declared using the `abstract` keyword before the class name.

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

### **Abstract Methods**

Abstract methods are method declarations that **don't have a body** (implementation). They are declared using the `abstract` keyword before the method return type. Subclasses that inherit from the abstract class **must provide implementations** for all inherited abstract methods. Abstract methods define the functionality that subclasses must adhere to, promoting a common interface within the class hierarchy.

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

### **Non-Abstract Methods**

Abstract classes can also have concrete methods (methods with a body) that provide default implementations for common functionalities. Subclasses can inherit and potentially override these methods to customize behavior.

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

## **Instantiation**

We cannot create objects directly from an abstract class using the `new` keyword. Subclasses, which are not abstract, can be instantiated.

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

## Access Modifier

Access Modifiers control the visibility and accessibility of classes, methods, and fields. Abstract classes leverage access modifiers to encapsulate certain methods or fields, making them accessible only to specific parts of the program. This capability is useful in complex hierarchies where we want to limit access to certain parts of the abstract class.

### **`public` Modifier**

* **Applicability**: Abstract classes and methods can use the `public` modifier to allow maximum visibility. For example, if an abstract method needs to be implemented across packages, it should be declared `public` in the abstract class.
*   **Usage Example**:

    ```java
    public abstract class Shape {
        public abstract void draw();  // Accessible from any subclass in any package
    }

    class Circle extends Shape {
        @Override
        public void draw() {
            System.out.println("Drawing a Circle");
        }
    }
    ```

    The `draw` method is declared as `public` to make it accessible from any subclass of `Shape`.

### **`protected` Modifier**

* **Applicability**: `protected` methods in an abstract class can only be accessed within the same package or by subclasses in other packages. This is useful for methods that should only be available to subclasses but hidden from other classes.
*   **Usage Example**:

    ```java
    abstract class Animal {
        protected String name;

        protected abstract void sound();  // Accessible only to subclasses

        protected void sleep() {
            System.out.println(name + " is sleeping.");
        }
    }

    class Dog extends Animal {
        @Override
        protected void sound() {
            System.out.println("Woof! Woof!");
        }
    }
    ```

    Here, `sound` and `sleep` are `protected`, so they’re only accessible to `Animal`'s subclasses or other classes within the same package.

### **`default` (Package-Private) Modifier**

* **Applicability**: The package-private (default) modifier restricts visibility to within the same package. In an abstract class, a method declared with no access modifier can only be accessed by classes within the same package.
*   **Usage Example**:

    ```java
    abstract class PaymentProcessor {
        abstract void process();  // Only accessible within the same package

        void validate() {  // package-private method
            System.out.println("Validating payment...");
        }
    }

    class CreditCardProcessor extends PaymentProcessor {
        @Override
        void process() {
            System.out.println("Processing credit card payment.");
        }
    }
    ```

    Here, `process` and `validate` have package-private access. They’re only accessible to classes within the same package.

### **`private` Modifier**

* **Applicability**: In Java, `private` is not allowed for methods declared in an abstract class because it would make them inaccessible to subclasses. However, `private` fields can be used in abstract classes and are accessible only within the class itself.
*   **Usage Example**:

    ```java
    abstract class BankAccount {
        private double balance;

        public BankAccount(double balance) {
            this.balance = balance;
        }

        public double getBalance() {
            return balance;
        }

        public abstract void deposit(double amount);
    }

    class SavingsAccount extends BankAccount {
        public SavingsAccount(double balance) {
            super(balance);
        }

        @Override
        public void deposit(double amount) {
            System.out.println("Depositing " + amount);
        }
    }
    ```

    The `balance` field is declared `private`, so it’s encapsulated within `BankAccount`. However, subclasses like `SavingsAccount` can still interact with `balance` through the `getBalance` method, which is `public`.

Compilation error if private methods are declared

```java
import lombok.Getter;

@Getter
public abstract class BankAccount {
    private double balance;

    protected BankAccount(double balance) {
        this.balance = balance;
    }

    // Compilation error - Illegal combination of modifiers 'abstract' and 'private'
    private abstract void deposit(double amount);
}
```

## **Constructors in Abstract Classes**

While abstract classes cannot be instantiated directly, they can have constructors. These constructors are primarily used to initialize fields or perform setup tasks that are common across all subclasses. When a subclass of an abstract class is instantiated, the constructor of the abstract class is called as part of the instantiation chain.

This feature is essential because it allows abstract classes to set up necessary state or dependencies that subclasses rely on. Additionally, since subclasses must call the constructor of the abstract superclass, this approach provides consistency in initialization.

```java
abstract class Account {
    protected double balance;

    // Constructor to initialize balance
    public Account(double balance) {
        this.balance = balance;
        System.out.println("Account created with balance: " + balance);
    }

    // Abstract method to be implemented by subclasses
    public abstract void withdraw(double amount);
}

class SavingsAccount extends Account {
    public SavingsAccount(double balance) {
        super(balance);  // Calls the constructor in the abstract superclass
    }

    @Override
    public void withdraw(double amount) {
        if (balance >= amount) {
            balance -= amount;
            System.out.println("Withdrew: " + amount + ", New balance: " + balance);
        } else {
            System.out.println("Insufficient funds.");
        }
    }
}
```

Abstract classes can have protected constructors, a technique used to control instantiation and ensure subclasses inherit but cannot create instances directly outside their package.

Here, the protected constructor in `BaseComponent` prevents instantiation from outside the class hierarchy, emphasizing that this class is intended solely for inheritance.

```java
abstract class BaseComponent {
    protected BaseComponent() {
        System.out.println("BaseComponent constructor");
    }
    public abstract void render();
}

class Button extends BaseComponent {
    @Override
    public void render() {
        System.out.println("Rendering Button");
    }
}
```

Other Example

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

## **Static Methods in Abstract Classes**

Static methods belong to the class itself rather than to any specific instance. In abstract classes, static methods can provide utility functions or helper methods relevant to the class as a whole. Because static methods do not depend on an instance, they’re often used to perform operations that do not require access to non-static fields of the class.

Since abstract classes can contain both static methods and abstract methods, this structure is more versatile than interfaces (which traditionally only contained abstract methods prior to Java 8).

```java
abstract class MathOperation {
    // Static utility method
    public static int add(int a, int b) {
        return a + b;
    }

    // Abstract method for other operations
    public abstract int operate(int a, int b);
}

class MultiplyOperation extends MathOperation {
    @Override
    public int operate(int a, int b) {
        return a * b;
    }
}

public class Main {
    public static void main(String[] args) {
        // Using static method in the abstract class
        int sum = MathOperation.add(5, 10);
        System.out.println("Sum: " + sum);

        // Using subclass to perform specific operation
        MathOperation operation = new MultiplyOperation();
        int product = operation.operate(5, 10);
        System.out.println("Product: " + product);
    }
}
```

## Nested abstract classess

Abstract class in Java can contain inner abstract classes, inner concrete classes, and static methods within it.

An inner class is defined within the scope of an outer class. Java supports different types of inner classes, which can also be abstract or concrete:

* **Non-static Inner Class (Instance Inner Class)**: Tied to an instance of the outer class. It has access to the outer class’s instance members.
* **Static Inner Class**: Similar to a regular class but nested within an outer class. It doesn’t require an instance of the outer class to be instantiated and can only access static members of the outer class.

**Types of Inner Classes**

* **Abstract Inner Class**: Defines an abstract class within an outer class, requiring subclasses (either nested or external) to implement its methods.
* **Concrete Inner Class**: Provides a fully implemented inner class that can operate within the context of the outer class.

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

```java
class OuterClass {
    private String message = "Hello from OuterClass";

    // Abstract inner class
    abstract class InnerAbstract {
        public abstract void displayMessage();

        // Non-abstract method in the abstract inner class
        public void commonInnerMethod() {
            System.out.println("This is a common method in an abstract inner class.");
        }
    }

    // Concrete subclass of InnerAbstract within the same outer class
    class InnerConcrete extends InnerAbstract {
        @Override
        public void displayMessage() {
            System.out.println("Message from InnerConcrete: " + message);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        OuterClass outer = new OuterClass();
        OuterClass.InnerConcrete inner = outer.new InnerConcrete();
        inner.displayMessage(); // Output: Message from InnerConcrete: Hello from OuterClass
        inner.commonInnerMethod(); // Output: This is a common method in an abstract inner class.
    }
}
```

## **Abstract Classes and Dependency Injection**

Abstract classes can serve as base types in dependency injection (DI) configurations in frameworks such as Spring. They can provide foundational, unchanging methods while enforcing specific functionalities in subclasses.

```java
public abstract class AbstractService {
    public void logServiceCall() { System.out.println("Service Call Logged"); }
    public abstract void executeService();
}

@Service
public class UserService extends AbstractService {
    @Override
    public void executeService() { System.out.println("Executing user service"); }
}
```

## **Abstract Classes in Design Patterns**

Abstract classes are often foundational in design patterns, particularly in cases like the _Template Method_, _Factory Method_, and _Adapter Pattern_.

### **Template Method Pattern**

Defines the skeleton of an algorithm in an abstract class, allowing subclasses to override certain steps without altering the algorithm's structure.

```java
public abstract class DataParser {
    // Template method defining the algorithm structure
    public final void parseData() {
        readData();
        processData();
        saveData();
    }
    protected abstract void readData();   // Steps to be customized
    protected abstract void processData();
    protected void saveData() {
        System.out.println("Data saved.");
    }
}

public class CSVDataParser extends DataParser {
    @Override
    protected void readData() { System.out.println("Reading CSV data."); }
    @Override
    protected void processData() { System.out.println("Processing CSV data."); }
}

public class JSONDataParser extends DataParser {
    @Override
    protected void readData() { System.out.println("Reading JSON data."); }
    @Override
    protected void processData() { System.out.println("Processing JSON data."); }
}
```

### **Factory Method Pattern**

In the **Factory Method Pattern**, an abstract class defines a method for creating an object, but allows subclasses to alter the type of object that will be created. This pattern is particularly useful for scenarios where the creation process of an object requires customization by subclasses.

Let’s consider a scenario where we have different types of `Document` objects: `WordDocument` and `PDFDocument`. Each document type has its own way of preparing content.

```java
// Abstract Creator class with Factory Method
public abstract class DocumentCreator {
    // Factory method to be implemented by subclasses
    protected abstract Document createDocument();

    // Template method that uses the factory method
    public void openDocument() {
        Document doc = createDocument();
        doc.prepareContent();
        System.out.println("Document opened: " + doc.getType());
    }
}

// Abstract Document class that represents the product
public abstract class Document {
    protected abstract void prepareContent();   // Step to be customized
    protected abstract String getType();
}

// Concrete Creator for Word documents
public class WordDocumentCreator extends DocumentCreator {
    @Override
    protected Document createDocument() {
        return new WordDocument();
    }
}

// Concrete Creator for PDF documents
public class PDFDocumentCreator extends DocumentCreator {
    @Override
    protected Document createDocument() {
        return new PDFDocument();
    }
}

// Concrete Product: WordDocument
public class WordDocument extends Document {
    @Override
    protected void prepareContent() {
        System.out.println("Preparing Word document content.");
    }

    @Override
    protected String getType() {
        return "Word Document";
    }
}

// Concrete Product: PDFDocument
public class PDFDocument extends Document {
    @Override
    protected void prepareContent() {
        System.out.println("Preparing PDF document content.");
    }

    @Override
    protected String getType() {
        return "PDF Document";
    }
}

public class Main {
    public static void main(String[] args) {
        DocumentCreator wordCreator = new WordDocumentCreator();
        wordCreator.openDocument();
        // Output: Preparing Word document content.
        // Document opened: Word Document

        DocumentCreator pdfCreator = new PDFDocumentCreator();
        pdfCreator.openDocument();
        // Output: Preparing PDF document content.
        // Document opened: PDF Document
    }
}
```

### **Adapter Pattern**

In the **Adapter Pattern**, an abstract class or interface defines a target interface that different adapters can implement to wrap incompatible classes. This pattern is often used when integrating with third-party libraries or legacy systems that have incompatible interfaces.

Consider a scenario where we have an existing `Rectangle` class in a legacy system, but we want to use it in a new system that expects `Shape` objects.

```java
// Target Interface
public abstract class Shape {
    public abstract void draw();
}

// Legacy Rectangle class (incompatible with Shape interface)
class Rectangle {
    public void drawRectangle() {
        System.out.println("Drawing a rectangle.");
    }
}

// Adapter class for Rectangle, adapting it to the Shape interface
public class RectangleAdapter extends Shape {
    private final Rectangle rectangle;

    public RectangleAdapter(Rectangle rectangle) {
        this.rectangle = rectangle;
    }

    @Override
    public void draw() {
        rectangle.drawRectangle();  // Adapter delegates to Rectangle's method
    }
}

// Legacy Circle class (incompatible with Shape interface)
class Circle {
    public void drawCircle() {
        System.out.println("Drawing a circle.");
    }
}

// Adapter class for Circle, adapting it to the Shape interface
public class CircleAdapter extends Shape {
    private final Circle circle;

    public CircleAdapter(Circle circle) {
        this.circle = circle;
    }

    @Override
    public void draw() {
        circle.drawCircle();  // Adapter delegates to Circle's method
    }
}

public class Main {
    public static void main(String[] args) {
        // Adapting a Rectangle object to the Shape interface
        Shape rectangleShape = new RectangleAdapter(new Rectangle());
        rectangleShape.draw();  // Output: Drawing a rectangle.

        // Adapting a Circle object to the Shape interface
        Shape circleShape = new CircleAdapter(new Circle());
        circleShape.draw();     // Output: Drawing a circle.
    }
}
```
