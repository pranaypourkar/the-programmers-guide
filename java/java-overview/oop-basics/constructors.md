# Constructors

## About

A **constructor** in Java is a special method used to **initialize objects**. It is automatically called when an object is created. The **main purpose** of a constructor is to assign initial values to the object's fields.

## **Characteristics of a Constructor**

### **Same Name as Class**

A constructor **must have the same name** as the class.

```java
class Person {
    Person() {  // Constructor name = Class name
        System.out.println("Person object created!");
    }
}
```

### **No Return Type**

Unlike methods, constructors **do not have a return type** (not even `void`).

```java
class Example {
    Example() {  // Constructor
        System.out.println("Object initialized!");
    }
}
```

### **Automatically Called**

It executes **when an object is created** using `new`.

```java
Example obj = new Example();  // Constructor runs automatically
```

### **Can Have Parameters**

Just like methods, constructors can accept parameters to initialize object values.

```java
class Car {
    String brand;
    
    Car(String brand) {  // Parameterized constructor
        this.brand = brand;
    }
}
```

### **Can Have Multiple Constructors (Constructor Overloading)**

Java allows multiple constructors with different **parameter lists** (overloading).

```java
class Person {
    Person() { System.out.println("Default Constructor!"); }
    Person(String name) { System.out.println("Hello, " + name); }
}
```

### Can have access modifiers

**Constructors in Java can have access modifiers** just like methods and fields. The access modifier of a constructor determines **where it can be accessed**.

**Access Modifiers for Constructors**

<table><thead><tr><th width="213">Access Modifier</th><th>Description</th></tr></thead><tbody><tr><td><strong>public</strong></td><td>The constructor is accessible from <strong>anywhere</strong> in the project.</td></tr><tr><td><strong>private</strong></td><td><p>The constructor is accessible <strong>only within the same class</strong> (used in Singleton pattern). </p><ul><li>Prevents <strong>direct object creation</strong> from outside the class.</li><li>Used in <strong>Singleton Pattern</strong> to ensure only <strong>one instance</strong> exists.</li></ul></td></tr><tr><td><strong>protected</strong></td><td><p>The constructor is accessible within the <strong>same package</strong> and in <strong>subclasses</strong>.</p><ul><li>Allows access <strong>within the same package</strong> and <strong>in subclasses</strong>.</li><li>Used when creating an <strong>abstract class with a protected constructor</strong>.</li></ul></td></tr><tr><td><strong>default (no modifier)</strong></td><td>The constructor is accessible only within the <strong>same package</strong>.</td></tr></tbody></table>

```java
// Public Constructor
// ---------------------------------------
class Person {
    public Person() {  // Public Constructor
        System.out.println("Person object created!");
    }
}

public class Main {
    public static void main(String[] args) {
        Person p = new Person();  // Allowed
    }
}
// ---------------------------------------

// Private Constructor (Singleton Pattern)
// ---------------------------------------
class Singleton {
    private static Singleton instance;

    private Singleton() {  // Private Constructor
        // The message appears only once, proving that only one instance is created.
        System.out.println("Singleton Instance Created!");
    }

    public static Singleton getInstance() {
        if (instance == null)
            instance = new Singleton();
        return instance;
    }
}

public class Main {
    public static void main(String[] args) {
        // Singleton s = new Singleton(); // Not Allowed (Compilation Error)
        Singleton s1 = Singleton.getInstance();  // Allowed
        Singleton s2 = Singleton.getInstance();  // Same instance returned
    }
}
// ---------------------------------------

// Protected Constructor (Inheritance)
// ---------------------------------------
class Animal {
    protected Animal() {  // Protected Constructor
        System.out.println("Animal object created!");
    }
}

class Dog extends Animal {
    Dog() {
        super();  // Allowed in subclass
        System.out.println("Dog object created!");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog d = new Dog();  // Allowed
    }
}
// ---------------------------------------

// Default (Package-Private) Constructor
// ---------------------------------------
class Car {
    Car() {  // Default Constructor (No Modifier)
        System.out.println("Car object created!");
    }
}

public class Main {
    public static void main(String[] args) {
        Car c = new Car();  // Allowed (same package)
    }
}

package anotherPackage;
import myPackage.Car;

public class Test {
    public static void main(String[] args) {
        Car c = new Car();  // Not Allowed (Compilation Error)
    }
}
// ---------------------------------------
```

## Example

```java
class Car {
    String brand;
    int speed;

    // Constructor
    Car(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
        System.out.println(brand + " car created with speed " + speed + " km/h.");
    }
}

public class Main {
    public static void main(String[] args) {
        Car car1 = new Car("Toyota", 120);
        Car car2 = new Car("Honda", 100);
        /* Output:
            Toyota car created with speed 120 km/h.
            Honda car created with speed 100 km/h.
        */
    }
}
```

## **Types of Constructors in Java**

### **1. Default Constructor (No-Argument Constructor)**

A constructor **without parameters** that initializes default values.

```java
class Dog {
    String breed;
    
    Dog() {  // Default constructor
        breed = "Unknown";
        System.out.println("A dog is created!");
    }
}
```

```java
Dog d = new Dog();  // Output: A dog is created!
```

### **2. Parameterized Constructor**

A constructor that **accepts arguments** to initialize object fields.

```java
class Laptop {
    String brand;
    
    Laptop(String brand) {  // Parameterized constructor
        this.brand = brand;
    }
}
```

#### **Usage:**

```java
Laptop l = new Laptop("Dell");
System.out.println(l.brand);  // Output: Dell
```

### **3. Copy Constructor**

A constructor that **copies values** from another object.

```java
class Book {
    String title;

    // Parameterized Constructor
    Book(String title) {
        this.title = title;
    }

    // Copy Constructor
    Book(Book b) {
        this.title = b.title;
    }
}
```

#### **Usage:**

```java
Book b1 = new Book("Java Programming");
Book b2 = new Book(b1);
System.out.println(b2.title);  // Output: Java Programming
```

### **4. Private Constructor**

A constructor that is **private** to prevent object creation. Used in **Singleton Design Pattern**.

```java
class Singleton {
    private static Singleton instance;
    
    private Singleton() { }  // Private Constructor
    
    public static Singleton getInstance() {
        if (instance == null)
            instance = new Singleton();
        return instance;
    }
}
```

#### **Usage:**

```java
Singleton obj = Singleton.getInstance();  // Only one instance allowed
```

### **5. Constructor Overloading**

A class can have **multiple constructors** with different parameters.

```java
class Student {
    String name;
    int age;

    // Constructor Overloading
    Student() { name = "Unknown"; age = 0; }
    Student(String name) { this.name = name; }
    Student(String name, int age) { this.name = name; this.age = age; }
}
```

#### **Usage:**

```java
Student s1 = new Student();  
Student s2 = new Student("Alice");  
Student s3 = new Student("Bob", 20);  
```

