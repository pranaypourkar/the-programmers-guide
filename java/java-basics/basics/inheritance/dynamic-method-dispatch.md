# Dynamic Method Dispatch

## About

Dynamic Method Dispatch (also called **runtime polymorphism**) is a mechanism by which a call to an **overridden method** is resolved **at runtime** rather than compile-time. It is a core concept in Java's object-oriented system that enables **method overriding** and **late binding**.

It allows Java to determine which version of a method (from a superclass or subclass) to execute based on the **actual object type**, not the reference type, during program execution.

* It involves **method overriding**, not overloading.
* The **reference variable** is of the **parent class**, but the **object** is of the **child class**.
* The method that gets called is determined by the actual object type, not the reference type.

#### **Example**

```java
class Animal {
    void sound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    void sound() {
        System.out.println("Dog barks");
    }
}

class Cat extends Animal {
    void sound() {
        System.out.println("Cat meows");
    }
}

public class Test {
    public static void main(String[] args) {
        Animal a;

        a = new Dog();
        a.sound();  // Outputs: Dog barks

        a = new Cat();
        a.sound();  // Outputs: Cat meows
    }
}
```

Although the reference is of type `Animal`, the method executed is based on the actual object (`Dog` or `Cat`). This is dynamic dispatch in action.

## **Rules for Dynamic Method Dispatch**

1. It only applies to **overridden methods**, not overloaded ones.
2. The method must be **non-static** (instance methods only).
3. We must have a **superclass reference** pointing to a **subclass object**.
4. Method selection happens **at runtime**.
5. **Final, static, and private methods** cannot be overridden and hence are not dynamically dispatched.

## **How It Works Internally ?**

Dynamic Method Dispatch in Java relies on a runtime mechanism known as **dynamic binding** (also called _late binding_). This is managed internally by the **Java Virtual Machine (JVM)** through a structure called the **Virtual Method Table** (commonly referred to as the **vtable**).

#### **1. Virtual Method Table (vtable) Mechanism**

When a class contains instance methods (non-static), the JVM creates a **vtable** for that class. This table holds references (or pointers) to the actual method implementations. Each class has its own vtable.

If a subclass overrides a method, the vtable entry for that method in the subclass replaces the one from the superclass. This means the subclass version will be called, even if accessed through a superclass reference.

#### **2. Object Instantiation and vtable Binding**

When an object is created:

* The JVM assigns it a reference to the appropriate **vtable** corresponding to its **actual class**.
* If we call a method using a reference variable, the JVM uses the object's vtable to resolve which version of the method to execute - **at runtime**, not during compilation.

This mechanism ensures that the **most specific overridden method** for the actual object type is always called, regardless of the reference type.

#### **3. Why Not Compile-Time ?**

At **compile time**, Java only knows the **reference type**, not the object it will point to. Therefore, the compiler cannot determine the correct version of an overridden method. Instead, it defers this decision until runtime, when the actual object is known this is what makes it **dynamic**.

#### **Example**

```java
Animal a = new Dog();
a.sound();
```

At compile time:

* The compiler checks if `sound()` exists in the `Animal` class which it does.
* It does **not** bind to a specific method version.

At runtime:

* The JVM sees that `a` points to a `Dog` object.
* It looks up the vtable of `Dog`, finds the overridden `sound()` method, and executes it.
