# Methods & Fields

## **About Method**

A **method** in Java is a block of code that performs a specific task. Methods define the **behavior** of a class and are used to operate on data (fields).

## **Characteristics of a Method**

1. **Encapsulates Behaviour**
   * A method contains reusable logic that can be called multiple times.
2. **Has a Signature**&#x20;
   * A method's signature includes **return type, name, parameters, and access modifiers**.
   *   Example:

       ```java
       public int add(int a, int b) { return a + b; }
       ```
3. **Can Take Parameters**&#x20;
   * Methods can accept input values (parameters).
   *   Example:

       ```java
       void greet(String name) { System.out.println("Hello, " + name); }
       ```
4. **Can Return a Value**&#x20;
   * A method may return a value using `return`.
   *   Example:

       ```java
       int square(int num) { return num * num; }
       ```
   *   If no value is returned, the return type is `void`.

       ```java
       void display() { System.out.println("No return value"); }
       ```
5. **Access Modifiers**&#x20;
   * Determines method visibility (`public`, `private`, `protected`, or package-private).

### **Example of Methods in Java**

```java
class Calculator {
    // Method without parameters
    void greet() {
        System.out.println("Welcome to Calculator!");
    }

    // Method with parameters and return type
    int add(int a, int b) {
        return a + b;
    }

    // Method with no return (void)
    void printResult(int result) {
        System.out.println("Result: " + result);
    }
}

public class Main {
    public static void main(String[] args) {
        // Creating an object
        Calculator calc = new Calculator();

        // Calling methods
        calc.greet();
        int sum = calc.add(5, 10);
        calc.printResult(sum);
    }
}

/* Output:
Welcome to Calculator!
Result: 15
*/
```

## **Types of Methods in Java**

### **1. Instance Methods**

Operate on instance variables

```java
class Person {
    String name;
    void setName(String name) { this.name = name; }
}
```

### **2. Static Methods**

Belong to the class, not objects

```java
class MathUtil {
    static int square(int x) { return x * x; }
}

// Usage:
// int result = MathUtil.square(4);
```

### **3. Abstract Methods**

Declared without implementation in an abstract class

```java
abstract class Animal {
    abstract void makeSound();  // No implementation
}
```

### **4. Final Methods**

Cannot be overridden

```java
class Parent {
    final void show() { System.out.println("Cannot be overridden"); }
}
```

### **5. Synchronized Methods**

Used in multithreading

```java
class SharedResource {
    synchronized void access() { System.out.println("Thread-safe"); }
}
```



## **About Field**

A **field** in Java (also called an instance variable or attribute) is a variable **declared inside a class**. It represents the **state** or **properties** of an object.

{% hint style="success" %}
## Local variable and Instance variable

**Local variables** are defined in the method and scope of the variables that exist inside the method itself.

**Instance variable** is defined inside the class and outside the method and the scope of the variables exists throughout the class.
{% endhint %}

## **Characteristics of a Field**

1. **Stores Object Data**
   * Fields hold **values** that define the object's state.
2. **Can Have Different Access Levels**
   * Controlled by access modifiers (`private`, `public`, `protected`, package-private).
3. **Can Have Default Values**
   * **Primitive types** (e.g., `int` defaults to `0`, `boolean` to `false`).
   * **Reference types** (e.g., `String` defaults to `null`).
4. **Can Be Static or Final**
   * `static` fields belong to the **class**, not individual objects.
   * `final` fields cannot be **changed after initialization**.

### **Example of Fields in Java**

```java
class Car {
    // Instance fields
    String brand;
    int speed;

    // Static field
    static int wheels = 4;

    // Constructor
    Car(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
    }

    // Method to display details
    void showDetails() {
        System.out.println(brand + " is moving at " + speed + " km/h.");
    }
}

public class Main {
    public static void main(String[] args) {
        Car car1 = new Car("Toyota", 60);
        Car car2 = new Car("Honda", 50);

        car1.showDetails(); // Toyota is moving at 60 km/h.
        car2.showDetails(); // Honda is moving at 50 km/h.

        // Accessing a static field
        System.out.println("Cars have " + Car.wheels + " wheels.");
    }
}

/* Output:
Toyota is moving at 60 km/h.
Honda is moving at 50 km/h.
Cars have 4 wheels.
*/
```

## **Types of Fields in Java**

### **1. Instance Fields**&#x20;

Unique to each object

```java
class Dog {
    String name;  // Each dog has its own name
}
```

### **2. Static Fields**

Shared among all objects

```java
class School {
    static String schoolName = "Greenwood High";
}

// Usage:
System.out.println(School.schoolName);
```

### **3. Final Fields**

Cannot be reassigned

```java
class Person {
    final String country = "USA";  // Cannot be changed
}
```

### **4. Transient Fields**&#x20;

Ignored during serialization

```java
class User {
    transient String password;  // Not stored when saving an object
}
```

### **5. Volatile Fields**

Used in multithreading to ensure consistency

```java
class SharedData {
    volatile boolean flag = true;
}
```
