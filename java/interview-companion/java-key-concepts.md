# Set 1

### Why main method is always declared with **public static void?**

In Java, `public static void main(String[] args)` is the entry point of any Java program. L

* `public`: It means that the `main` method can be accessed from anywhere. It's necessary because the Java Virtual Machine (JVM) needs to access this method to start the execution of the program.
* `static`: It means that the `main` method belongs to the class itself, rather than to any instance of the class. This is because Java starts the program before any objects are created.
* `void`: It indicates that the `main` method doesn't return any value.
* `main`: This is the name of the method. `main` is a special method name recognized by the JVM.
* `(String[] args)`: This is the parameter that `main` accepts. `args` is an array of strings that can be passed to the program from the command line. These are typically arguments that you want to pass to your program when you run it.

So, when we run a Java program from the command line, we can pass arguments to it like this. `args` will contain `["arg1", "arg2", "arg3"]`, and we can access these values inside the `main` method.

```
java SomeClassName arg1 arg2 arg3
```



### Rules for variable names in Java:

* Variable names must begin with a letter (a-z or A-Z), an underscore (\_), or a currency character ($ or €).
* First character of a variable name cannot be a digit. It can start with currency or underscore also.
* Variable names are case-sensitive, meaning `myVariable` and `MyVariable` are considered different variables.
* Variable names cannot be a Java keyword or reserved word, such as `int`, `class`, `public`, etc



### Shallow Copy vs Deep Copy

**Shallow Copy**

* Shallow copy creates a new object and then copies the reference of the original object into it. In other words, it duplicates the reference, not the underlying data.
* So, any changes made to the copied object will reflect in the original object and vice versa because they both refer to the same underlying data.
* Shallow copy is relatively simple and fast, but it can lead to unexpected behavior if you're not careful about how changes propagate across objects.

**Deep Copy**

* Deep copy, on the other hand, creates a new object and then, recursively, copies each field of the original object into the new object.
* This means that changes made to the copied object won't affect the original object, and vice versa, because they refer to different sets of data.
* Deep copying can be more complex and computationally expensive, especially for complex objects with nested structures or references to other objects.

**Example 1**

```java
class Person {
    String name;
    int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

public class Main {
    public static void main(String[] args) {
        Person original = new Person("Alice", 30);

        // Shallow copy
        Person shallowCopy = original;
        shallowCopy.age = 25; // Changes reflected in both objects
        System.out.println(original.age); // Output: 25

        // Deep copy
        Person deepCopy = new Person(original.name, original.age);
        deepCopy.age = 35; // Changes not reflected in original
        System.out.println(original.age); // Output: 25
        System.out.println(deepCopy.age); // Output: 35
    }
}
```

Changes made to the shallow copy (`shallowCopy`) affect the original object (`original`) because they both refer to the same object in memory. However, changes made to the deep copy (`deepCopy`) do not affect the original object because they are separate instances with their own memory space.

**Example 2**

```java
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
```

In this method, a new `ArrayList` (`clonedStyles`) is created, and the elements from the original `styles` list are copied into it. This process of creating a new list and copying elements ensures that the `styles` list of the cloned `Document` object refers to a different memory location than the `styles` list of the original `Document` object. Therefore, changes made to the `styles` list of one `Document` object will not affect the `styles` list of the other `Document` object.

**Example 3**

```java
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
```

Here, the `clone()` method creates a new `Orc` object (`clone`) using the constructor with parameters `name`, `health`, and `weapon`. However, since no special handling is done for the `weapon` field, it's simply copied by reference. This means the `weapon` field of the cloned `Orc` object will reference the same `Weapon` object as the original `Orc` object. Therefore, any changes made to the `Weapon` object through the cloned `Orc` object will affect the original `Orc` object, and vice versa. This behavior indicates that it's a shallow copy



### Java Interfaces and abstract classes

Interfaces and abstract classes are both tools for achieving abstraction in Java, but they serve different purposes.

#### Use Interfaces When

1. **Defining a Contract**: Interfaces are used to define a contract or a set of methods that a class must implement. They specify what a class can do, without providing any implementation details.
2. **Multiple Inheritance of Type**: Java doesn't support multiple inheritance of classes, but it does support implementing multiple interfaces. This makes interfaces useful when a class needs to inherit behavior from multiple sources.
3. **Loose Coupling**: Interfaces promote loose coupling between components by providing a common abstraction. Classes can interact through interfaces without being tightly bound to each other's implementations.
4. **API Design**: Interfaces are often used in API design to define a set of methods that other classes must implement. This allows for flexibility and extensibility in the implementation details.

#### Use Abstract Classes When

1. **Partial Implementation**: Abstract classes can provide partial implementations of methods, along with abstract methods that must be implemented by subclasses. This is useful when you have a base class that contains common behavior shared by multiple subclasses.
2. **Code Reusability**: Abstract classes allow you to define common behavior once and reuse it across multiple subclasses. They can contain fields, constructors, and methods that are shared among subclasses.
3. **Stronger Encapsulation**: Abstract classes can have member variables with different access modifiers (e.g., private, protected), providing stronger encapsulation compared to interfaces, which can only have public members.
4. **Evolution Over Time**: Abstract classes provide more flexibility for evolving the API over time. You can add new methods (abstract or concrete) to an abstract class without breaking existing implementations, whereas adding new methods to an interface requires modifying all implementing classes.

#### Example of Interface

The `Comparable` interface in Java is a good example. It's used to define a contract for classes that can be compared to each other. Classes that implement `Comparable` must provide an implementation for the `compareTo` method, which compares the object with another object of the same type and returns an integer indicating the comparison result. For example, the `String` class implements `Comparable`

```java
// Comparable interface
public interface Comparable<T> {
    int compareTo(T other);
}

// Compare with String
public class String implements Comparable<String> {
    // Other methods...

    @Override
    public int compareTo(String other) {
        return // Comparison logic here;
    }
}
```

#### Example of Abstract Class

Creating an abstract class `Shape` to represent common behavior and characteristics of all different  shapes. It provides common functionality like `printDetails()`

<pre class="language-java"><code class="lang-java"><strong>// Shape abstract class
</strong><strong>public abstract class Shape {
</strong>    protected double area;
    protected double perimeter;

    // Abstract methods
    public abstract double calculateArea();
    public abstract double calculatePerimeter();

    // Other common methods
    public void printDetails() {
        System.out.println("Area: " + area);
        System.out.println("Perimeter: " + perimeter);
    }
}

// Circle class
public class Circle extends Shape {
    private double radius;

    public Circle(double radius) {
        this.radius = radius;
    }

    @Override
    public double calculateArea() {
        return Math.PI * radius * radius;
    }

    @Override
    public double calculatePerimeter() {
        return 2 * Math.PI * radius;
    }
}
</code></pre>

#### Example using both interface and abstract class

Consider an example of payment processing system. `PaymentProcessor` interface defines a contract. Any class implementing `PaymentProcessor` must have a `processPayment` method that takes an amount and returns true if the payment is successful. `AbstractPaymentGateway` abstract class extends the `PaymentProcessor` interface and provides some common functionalities:

<pre class="language-java"><code class="lang-java"><strong>// PaymentProcessor  interface
</strong><strong>public interface PaymentProcessor {
</strong>  boolean processPayment(double amount);
}

// AbstractPaymentGateway abstract class
public abstract class AbstractPaymentGateway implements PaymentProcessor {
  protected String credentials; // Shared credential field for subclasses

  public AbstractPaymentGateway(String credentials) {
    this.credentials = credentials;
  }

  // Default implementation for security checks (can be overridden)
  protected boolean performSecurityChecks() {
    // Implement some generic security checks
    return true;
  }

  @Override
  public abstract boolean processPayment(double amount);
}
</code></pre>



### When is the object created with new keyword

In Java, the object is created with the `new` keyword during **runtime**.

The `new` keyword plays a crucial role in the object creation process:

1. **Memory Allocation:** It triggers the allocation of memory for the new object on the heap. The heap is a special area of memory dedicated to storing objects in Java.
2. **Constructor Call:** It invokes the constructor of the class specified after `new`. The constructor is responsible for initializing the object's state by assigning values to its fields.

Therefore, the `new` keyword initiates object creation and memory allocation at runtime, not during compilation. This allows for dynamic object creation based on your program's needs.



### Statically Typed (like Java) and Dynamically Typed Languages

**Statically Typed Languages (like Java):**

* **Type declaration at compile time:** We explicitly declare the data type (e.g., `int`, `String`) of a variable when we define it.
* **Compile-time type checking:** The compiler verifies if the assigned values match the declared data type during compilation. This helps catch errors early on.
* **Strong type safety:** Variables can only hold values of their declared type, preventing unexpected behavior at runtime.

**Dynamically Typed Languages:**

* **Type inferred at runtime:** The data type of a variable is determined by the value assigned to it at runtime, not by explicit declaration.
* **Runtime type checking:** Type checking happens during program execution, not before. This offers more flexibility but can lead to runtime errors if incorrect types are used.
* **Weaker type safety:** Variables can hold different data types throughout the program, potentially causing issues if not handled carefully.



### `final` keyword on field, method and class

The `final` keyword in Java is used to restrict modifications or inheritance. Here's a breakdown of its meaning when applied to fields (variables), methods, and classes:

#### **Final Field (Variable):**

* When a field (variable) is declared as `final`, its value cannot be changed after it's initialized. This ensures the value remains constant throughout the program.
* **Example:**

```java
final int MAX_VALUE = 100;
MAX_VALUE = 200; // This will cause a compile-time error because the value is final
```

#### **Final Method:**

* When a method is declared as `final`, it cannot be overridden by subclasses. This prevents subclasses from modifying the behavior of that specific method.
* **Example:**

```java
class Parent {
  final void someMethod() {
    System.out.println("Parent's method implementation");
  }
}

class Child extends Parent {
  // This will cause a compile-time error because someMethod() is final
  void someMethod() {
    System.out.println("Child's method implementation (not allowed)");
  }
}
```

#### **Final Class:**

* When a class is declared as `final`, it cannot be extended or subclassed. This means you cannot create new classes that inherit from the final class.
* **Example:**

```java
final class MathUtils {
  static int add(int a, int b) {
    return a + b;
  }
}

// This will cause a compile-time error because MathUtils is final
class MyMath extends MathUtils {
  // ... (not allowed)
}
```

#### **When to Use `final`:**

Consider using `final` when:

* We want to ensure a variable's value remains constant.
* We want to prevent method overrides in subclasses (for specific well-defined behaviors).
* We have a class that serves a utility purpose and doesn't need subclasses.

By understanding the meaning of `final` with fields, methods, and classes, we can effectively control mutability, inheritance, and code structure in Java programs.



### `transient` keyword in java

The `transient` keyword in Java is used specifically in the context of **serialization**. Serialization is the process of converting an object's state into a stream of bytes that can be stored or transmitted. Deserialization is the opposite process of recreating an object from a byte stream. Transient fields are initialized to their default values during deserialization.

Here's how the `transient` keyword affects serialization:

**Purpose:**

* When we declare a field (variable) of a class as `transient`, its value **will not be serialized** when the object is serialized.
* This is useful for data members that don't represent the essential state of the object or that can be easily recalculated during deserialization. Or when we have fields that do not need to be saved or transferred along with the object's state.

**Example**:

```java
// User class
package src.main.java;

import java.io.Serializable;

public class User implements Serializable {

    private String name;
    private transient String password; // Password should not be serialized
    private int age;

    public User(String name, String password, int age) {
        this.name = name;
        this.password = password;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    // No getter for password (avoids accidental exposure)

    @Override
    public String toString() {
        return "User [name=" + name + ", password (hidden), age=" + age + "]";
    }
}

// Main Application class
package src.main.java;

import java.io.*;

public class Application {

    public static void main(String[] args) {
        User user = new User("Alice", "secret123", 25);

        // Serialize
        try (FileOutputStream fileOut = new FileOutputStream("user.txt");
             ObjectOutputStream out = new ObjectOutputStream(fileOut)) {
            out.writeObject(user);
        } catch (IOException e) {
            e.printStackTrace();
        }

        // De-Serialize
        try (FileInputStream fileIn = new FileInputStream("user.txt");
             ObjectInputStream in = new ObjectInputStream(fileIn)) {
            User deserializedUser = (User) in.readObject();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```



