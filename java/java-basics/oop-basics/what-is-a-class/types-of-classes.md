# Types of Classes

## About

Java provides different types of classes to support various programming needs.

{% hint style="success" %}
If we declare a **class as `public`**, it **must** be in a separate file with the **same name as the class**.

#### **Rules for `public` class declaration in Java**:

1. A Java **file name must match the `public` class name**.
2. We **cannot** have multiple `public` classes in the same file.
3. We **can** have multiple **non-public** (default, private, protected) classes in the same file.
{% endhint %}

## **1. Concrete Class**

A concrete class is a **regular class** that can be instantiated into objects. It contains both **implemented methods** and instance variables.

### **Characteristics**

* Can be **instantiated** (objects can be created from it).
* Can have **constructors, methods, and fields**.
* Can be **extended** by other classes (supports inheritance).
* Can **implement interfaces**.
* Cannot have **abstract methods**.

### **Example**

```java
// Concrete Class
class Car {
    String brand;
    int speed;

    // Constructor
    Car(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
    }

    // Method
    void accelerate() {
        speed += 10;
        System.out.println(brand + " is now going at " + speed + " km/h.");
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        Car myCar = new Car("Toyota", 50);
        myCar.accelerate(); // Toyota is now going at 60 km/h.
    }
}
```

## **2. Abstract Class**

An abstract class **cannot be instantiated** but serves as a **base class** for other classes. It can have both **abstract methods (without implementation)** and **concrete methods**.

### **Characteristics**

* Cannot be **instantiated** directly.
* Can contain **both abstract and concrete methods**.
* Must be **extended** by a subclass.
* Supports **constructors and fields**.
* Can implement interfaces.

### **Example**

```java
// Abstract Class
abstract class Animal {
    String name;

    Animal(String name) {
        this.name = name;
    }

    // Abstract Method (no body)
    abstract void makeSound();

    // Concrete Method
    void eat() {
        System.out.println(name + " is eating.");
    }
}

// Subclass (Concrete Class)
class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    // Implementing abstract method
    void makeSound() {
        System.out.println(name + " barks.");
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        Dog myDog = new Dog("Buddy");
        myDog.makeSound(); // Buddy barks.
        myDog.eat();       // Buddy is eating.
    }
}
```

## **3. Final Class**

A final class **cannot be extended** (no subclass can inherit from it). It is used to **prevent modification** of critical functionality.

### **Characteristics**

* Cannot be **extended (inherited)**.
* Can contain **fields, methods, and constructors**.
* Often used for **security** and **immutability**.
* Can be **instantiated normally**.

### **Example**

```java
// Final Class
final class MathUtils {
    int square(int x) {
        return x * x;
    }
}

// This would cause an error: "Cannot inherit from final 'MathUtils'"
// class AdvancedMath extends MathUtils { }

// Main Class
public class Main {
    public static void main(String[] args) {
        MathUtils math = new MathUtils();
        System.out.println(math.square(5)); // 25
    }
}
```

## **4. Static Class (Nested Static Class)**

Java does not allow **top-level static classes**, but it allows **static nested classes** inside another class.

### **Characteristics**

* A **static nested class** can be created inside another class.
* Cannot access **non-static members** of the outer class directly.
* Used when the nested class is **logically related to the outer class** but does not depend on its instance.

### **Example**

```java
class OuterClass {
    static class StaticNested {
        void showMessage() {
            System.out.println("Hello from Static Nested Class!");
        }
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        // No need to create an instance of OuterClass
        OuterClass.StaticNested nestedObj = new OuterClass.StaticNested();
        nestedObj.showMessage(); // Hello from Static Nested Class!
    }
}
```

## **5. Inner Class (Non-Static Nested Class)**

An inner class is a class defined **inside another class** and has access to its **outer class's members**.

### **Characteristics**

* Can **access private members** of the outer class.
* Requires an **instance of the outer class** to be created.
* Useful for **encapsulation** and **logical grouping**.

### **Example**

```java
class OuterClass {
    private String message = "Hello from Outer Class!";

    // Inner Class
    class Inner {
        void showMessage() {
            System.out.println(message); // Accessing private field of OuterClass
        }
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        OuterClass outer = new OuterClass();
        OuterClass.Inner inner = outer.new Inner();
        inner.showMessage(); // Hello from Outer Class!
    }
}
```

## **6. Anonymous Class**

An anonymous class is a **class without a name**, defined **on the fly** for **one-time use**, often used with interfaces or abstract classes.

### **Characteristics**

* Declared **inside a method** or **as part of an expression**.
* Cannot have **constructors**.
* Typically used to **implement interfaces or extend abstract classes**.

### **Example**

```java
interface Greeting {
    void sayHello();
}

// Main Class
public class Main {
    public static void main(String[] args) {
        // Anonymous Inner Class implementing interface
        Greeting greeting = new Greeting() {
            public void sayHello() {
                System.out.println("Hello from Anonymous Class!");
            }
        };

        greeting.sayHello(); // Hello from Anonymous Class!
    }
}
```

## **7. POJO (Plain Old Java Object) Class**

A POJO class is a simple Java class that **only contains fields, getters, and setters**. It does **not extend or implement** anything special.

### **Characteristics**

* Only contains **fields (variables)** and **getter/setter methods**.
* Used as **data holders**.
* No business logic.

### **Example**

```java
class Person {
    private String name;
    private int age;

    // Constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        Person p = new Person("Alice", 25);
        System.out.println(p.getName()); // Alice
    }
}
```

## Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th width="179"></th><th width="205"></th><th width="200"></th><th></th></tr></thead><tbody><tr><td><strong>Type of Class</strong></td><td><strong>Can be Instantiated?</strong></td><td><strong>Supports Inheritance?</strong></td><td><strong>Special Feature</strong></td></tr><tr><td>Concrete Class</td><td>✅ Yes</td><td>✅ Yes</td><td>Regular class used for objects</td></tr><tr><td>Abstract Class</td><td>❌ No</td><td>✅ Yes</td><td>Can have abstract &#x26; concrete methods</td></tr><tr><td>Final Class</td><td>✅ Yes</td><td>❌ No</td><td>Cannot be extended</td></tr><tr><td>Static Class</td><td>✅ Yes (nested)</td><td>❌ No</td><td>Can be a static nested class</td></tr><tr><td>Inner Class</td><td>✅ Yes (inside another class)</td><td>❌ No</td><td>Can access outer class members</td></tr><tr><td>Anonymous Class</td><td>✅ Yes (one-time use)</td><td>❌ No</td><td>No name, used inside methods</td></tr><tr><td>POJO Class</td><td>✅ Yes</td><td>✅ Yes</td><td>Plain Java Object with getters/setters</td></tr></tbody></table>





