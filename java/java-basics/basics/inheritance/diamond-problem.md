# Diamond Problem

## About

The **Diamond Problem** is a classic issue in object-oriented programming that arises with **multiple inheritance**, where a class inherits from two classes that both inherit from a common superclass. This can create **ambiguity in method resolution**, making it difficult for the compiler or runtime to decide which inherited behavior to use.

Java avoids this problem altogether by **not allowing multiple inheritance with classes**, and instead supports multiple inheritance via **interfaces**, which handle such conflicts more predictably.

## What is the Diamond Problem ?

The diamond problem gets its name from the shape of the class diagram it produces:

```
      A
     / \
    B   C
     \ /
      D
```

In this structure:

* Class `B` and class `C` inherit from class `A`.
* Class `D` inherits from both `B` and `C`.

Now, if class `A` has a method `display()`, and both `B` and `C` override it, what should class `D` inherit?

* `B`’s version?
* `C`’s version?
* Or should it override both?

This **ambiguity** in method resolution is what we call the **diamond problem**.

## Why Java Disallows Multiple Inheritance with Classes ?

To avoid the complications of the diamond problem and reduce complexity, Java **does not allow** a class to extend more than one class directly.

#### **Reasons**

1. **Ambiguity in Method Inheritance**\
   When two parent classes define a method with the same signature, the subclass wouldn’t know which one to inherit.
2. **Maintainability and Simplicity**\
   Multiple inheritance leads to tightly coupled and fragile code that is harder to understand, debug, and maintain.
3. **Design Clarity**\
   Single inheritance enforces a **clear and hierarchical class structure**, which aligns with Java's design philosophy.
4. **Avoiding Conflicts in State and Behavior**\
   In multiple inheritance, the same field might be inherited multiple times, leading to **conflicting copies of instance variables**.

## **How Java Solves It ?**

Java avoids the diamond problem by **supporting multiple inheritance through interfaces**, not classes. Interfaces allow multiple inheritance **without ambiguity** because:

* Before Java 8, interfaces had no method bodies (no implementation), so the problem did not arise.
* From Java 8 onward, interfaces can have **default methods**, but Java handles conflict resolution explicitly.

#### **Example: Multiple Inheritance Using Interfaces**

```java
interface A {
    default void show() {
        System.out.println("A's show");
    }
}

interface B extends A {
    default void show() {
        System.out.println("B's show");
    }
}

interface C extends A {
    default void show() {
        System.out.println("C's show");
    }
}

class D implements B, C {
    public void show() {
        // Must resolve ambiguity explicitly
        B.super.show(); // or C.super.show()
    }
}

public class Test {
    public static void main(String[] args) {
        D d = new D();
        d.show(); // Output depends on which super.show() is called
    }
}
```

In this example, class `D` inherits `show()` from both `B` and `C`. Java **forces the developer to resolve the conflict** by specifying which interface's method to invoke using `B.super.show()` or `C.super.show()`.
