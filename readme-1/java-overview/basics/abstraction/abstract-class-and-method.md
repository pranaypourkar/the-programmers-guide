# Abstract Class & Method

## About

An abstract class in Java is a class that cannot be instantiated directly, meaning we cannot create objects of an abstract class using the `new` keyword. Instead, it serves as a blueprint for other classes and may contain both abstract and concrete methods.

{% hint style="info" %}
**Rules for Abstract Classes:**

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

### **Can Contain Fields**

Abstract classes can contain fields (variables), constructors, static methods, and instance methods, similar to regular classes.

{% hint style="success" %}
Although abstract classes cannot be instantiated, they can contain constructors, which subclasses call as part of their instantiation process. This is useful for initializing fields common to all subclasses or performing setup tasks.

Abstract classes can have fields (instance variables), unlike interfaces. This feature is valuable when we want to share common data across subclasses and need more complex state handling within an inheritance structure.
{% endhint %}

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

