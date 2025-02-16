# What is a Class?

## About

A **class** in Java is a **blueprint** or **template** for creating objects. It defines the **state (fields/attributes)** and **behavior (methods)** that objects of that class will have.

## **Characteristics of a Class**

### **1. Defines State (Attributes)**&#x20;

* Represented by **fields/variables** inside the class.
* Example: `String name;`, `int age;`.

### **2. Defines Behavior (Methods)**&#x20;

* Defined by functions inside the class.
* Example: `void eat() {}`, `void sleep() {}`.

### **3. Can Contain a Constructor**&#x20;

* Special method used to **initialize** an object.
* Example: `Person(String name, int age) { this.name = name; this.age = age; }`.

### **4. Objects are Created from a Class**&#x20;

* A class itself is just a definition; actual **objects** are instantiated from it.

## **Example of a Class in Java**

```java
// Class Definition (Blueprint)
class Person {
    // Attributes (State)
    String name;
    int age;

    // Constructor (Used to initialize object)
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    // Methods (Behavior)
    void introduce() {
        System.out.println("Hi, I am " + name + " and I am " + age + " years old.");
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        // Creating Objects from Class
        Person person1 = new Person("Alice", 25);
        Person person2 = new Person("Bob", 30);

        // Calling Methods
        person1.introduce(); // Hi, I am Alice and I am 25 years old.
        person2.introduce(); // Hi, I am Bob and I am 30 years old.
    }
}
```

## **How Classes Work in Memory**

* The **class definition** itself is stored in **method area (Metaspace in Java 8+)**.
* When an **object** is created, memory is allocated in the **heap**, and the reference variable (like `person1`) is stored in the **stack**.

