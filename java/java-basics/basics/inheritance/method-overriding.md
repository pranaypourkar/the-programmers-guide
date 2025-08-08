# Method Overriding

## About

In object-oriented programming, **method overriding** is a fundamental concept that allows a **subclass** to provide a specific implementation of a method that is already defined in its **superclass**. This feature supports **runtime polymorphism** and enables a program to decide at runtime which version of a method to execute depending on the **object's actual type**, not the reference type.

In Java, method overriding is a mechanism by which the behavior of an inherited method can be **customized** or **replaced** to suit the needs of the subclass.

## Why Overriding is Important ?

Method overriding plays a crucial role in:

* **Code reusability**: We inherit general behavior and refine it in specialized classes.
* **Extensibility**: We can adapt superclass behavior without modifying its code.
* **Framework integration**: Most Java frameworks rely heavily on method overriding to inject user-defined logic into pre-defined workflows.
* **Runtime polymorphism**: It allows method calls to be resolved dynamically, enabling more flexible and loosely coupled systems.

## What Happens When We Override ?

When a subclass **overrides** a method:

* It uses the **same method name**, **same parameter list**, and a **compatible return type**.
* The overridden method **replaces** the behavior inherited from the parent class.
* At **runtime**, the JVM will call the **subclass version** if the object is of subclass type - even when accessed via a superclass reference.

```java
class Animal {
    void makeSound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Dog barks");
    }
}

public class Test {
    public static void main(String[] args) {
        Animal a = new Dog();
        a.makeSound();  // Output: Dog barks
    }
}
```

Although `a` is declared as type `Animal`, the actual object is of type `Dog`, so the overridden method in `Dog` is executed.

## Rules for Method Overriding

When a subclass wants to modify the behavior of a method inherited from its superclass, it must follow a set of strict rules defined by the Java language. These rules are enforced by the compiler to maintain correctness and avoid ambiguity during runtime polymorphism.

### **1. The Method Must Be Inherited**

* Only methods that are **inherited** can be overridden.
* We **cannot override:**
  * **Private methods** (they are not visible to subclasses)
  * **Constructors** (they are not inherited)
  * **Static methods** (they are class-level, not instance-level)
  * **Final methods** (they are meant to remain unchanged)

### **2. Method Signature Must Be Exactly the Same**

* The **method name**, **parameter types**, and **order of parameters** must match.
* Overriding changes only the **method body**, not the method's signature.

```java
class A {
    void show(int a) { }
}

class B extends A {
    // Valid override
    @Override
    void show(int a) { }
}
```

### **3. Return Type Must Be the Same or a Subtype (Covariant Return)**

* From Java 5 onward, a subclass is allowed to return a **more specific type** (covariant type).
* The return type must still be **compatible** with the superclass version.

```java
class Animal { }
class Dog extends Animal { }

class A {
    Animal getAnimal() { return new Animal(); }
}

class B extends A {
    @Override
    Dog getAnimal() { return new Dog(); }  // Valid
}
```

### **4. Access Modifier Cannot Be More Restrictive**

* The visibility of the overridden method **cannot be more restrictive** than the method in the superclass.
* We **can** make it more accessible, but not less.

| Superclass Modifier | Allowed in Subclass              | Not Allowed in Subclass           |
| ------------------- | -------------------------------- | --------------------------------- |
| `public`            | `public`                         | `protected`, `default`, `private` |
| `protected`         | `protected`, `public`            | `default`, `private`              |
| `default` (package) | `default`, `protected`, `public` | `private`                         |

### **5. Cannot Override Static Methods**

* **Static methods are not overridden**, they are **hidden**.
* Method resolution for static methods is done at **compile time**, not runtime.

```java
class A {
    static void display() { System.out.println("A"); }
}

class B extends A {
    static void display() { System.out.println("B"); }
}

public class Test {
    public static void main(String[] args) {
        A obj = new B();
        obj.display();  // Output: A (not B)
    }
}
```

### **6. Cannot Override Final Methods**

* A method declared with the `final` keyword cannot be overridden.

```java
class A {
    final void show() { }
}

class B extends A {
    // Error: Cannot override the final method
    void show() { }
}
```

### **7. Exception Rules (Checked Exceptions)**

* The overriding method **cannot throw broader checked exceptions** than the method it overrides.
* It may:
  * Throw the **same exception**
  * Throw **subtypes** of the original exception
  * Throw **no exception**

```java
class A {
    void read() throws IOException { }
}

class B extends A {
    @Override
    void read() throws FileNotFoundException { }  // Valid
}
```

> Note: This rule **only applies to checked exceptions**, not unchecked ones (like `NullPointerException` or `RuntimeException`).

### **8. Use of `@Override` Annotation (Optional but Recommended)**

* Not required by the compiler, but **highly recommended**.
* Ensures that we are actually overriding a method, not overloading or misnaming it.
* Causes a **compile-time error** if we make a mistake.

```java
@Override
void display() {
    // ...
}
```

### **9. Abstract Methods Must Be Overridden**

* If a class inherits an abstract method from an abstract class or interface, it must **provide an implementation** unless the subclass is also abstract.

```java
abstract class Animal {
    abstract void makeSound();
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Bark");
    }
}
```
