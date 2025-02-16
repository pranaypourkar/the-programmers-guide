# What is an Object?

## About

In Java, an **object** is an instance of a class that contains **state (fields/variables)** and **behavior (methods)**. Objects are created based on the blueprint defined by a class.

## **Characteristics of an Object**

1. **State (Attributes)**&#x20;
   * Represented by **instance variables** (fields).
   * Stores the data or properties of the object.
2. **Behavior (Methods)**&#x20;
   * Defined by **functions inside the class**.
   * Determines what actions an object can perform.
3. **Identity (Reference)**&#x20;
   * Each object has a unique memory address in the heap.

## **Example of an Object**

```java
// Class Definition
class Car {
    String brand;  // Attribute
    int speed;

    // Constructor
    Car(String brand, int speed) {
        this.brand = brand;
        this.speed = speed;
    }

    // Method (Behavior)
    void accelerate() {
        speed += 10;
        System.out.println(brand + " is now going at " + speed + " km/h.");
    }
}

// Main Class
public class Main {
    public static void main(String[] args) {
        // Creating Objects
        Car car1 = new Car("Toyota", 50);
        Car car2 = new Car("Honda", 40);

        // Accessing Object Methods
        car1.accelerate();  // Toyota is now going at 60 km/h.
        car2.accelerate();  // Honda is now going at 50 km/h.
    }
}
```

## **How Objects Work in Memory**

1. Objects are created in the **heap memory**.
2. The **reference variable** (like `car1` and `car2`) points to the object in memory.
3. Multiple reference variables can point to the same object.

```java
Car car3 = car1;  // Now both car1 and car3 point to the same object
```

## When is the object created with new keyword

In Java, the object is created with the `new` keyword during **runtime**.

The `new` keyword plays a crucial role in the object creation process:

1. **Memory Allocation:** It triggers the allocation of memory for the new object on the heap. The heap is a special area of memory dedicated to storing objects in Java.
2. **Constructor Call:** It invokes the constructor of the class specified after `new`. The constructor is responsible for initializing the object's state by assigning values to its fields.

Therefore, the `new` keyword initiates object creation and memory allocation at runtime, not during compilation. This allows for dynamic object creation based on your program's needs.

