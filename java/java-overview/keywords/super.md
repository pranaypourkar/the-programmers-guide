# super

In Java, the `super` keyword is used to refer to the superclass (parent class) of the current object instance. The `super` keyword in Java is a reference to the superclass and is used to access superclass members, constructors, and methods from within a subclass. It plays an important role in inheritance and allows for better code organization and reuse

## Uses of the `super` keyword

1. **Accessing Superclass Members**: We can use `super` to access methods and instance variables of the superclass within a subclass. This is useful when a subclass overrides a method or hides an instance variable of the superclass and you still want to access the superclass version.

```java
class Parent {
    int value = 10;
    void display() {
        System.out.println("Parent's value: " + value);
    }
}

class Child extends Parent {
    int value = 20;
    void display() {
        System.out.println("Child's value: " + value);
        System.out.println("Parent's value: " + super.value); // Accessing superclass variable
        super.display(); // Invoking superclass method
    }
}
```

2. **Invoking Superclass Constructors**: We can use `super` to invoke constructors of the superclass from a subclass constructor. This is useful when we want to reuse initialization logic defined in the superclass constructor.

```java
class Parent {
    Parent() {
        System.out.println("Parent constructor");
    }
}

class Child extends Parent {
    Child() {
        super(); // Invoking superclass constructor
        System.out.println("Child constructor");
    }
}
```

**Accessing Superclass Methods**: We can use `super` to invoke methods of the superclass even if they are overridden in the subclass.

```java
class Parent {
    void display() {
        System.out.println("Parent's display method");
    }
}

class Child extends Parent {
    @Override
    void display() {
        super.display(); // Invoking superclass method
        System.out.println("Child's display method");
    }
}
```

{% hint style="info" %}
**If a class is not subclassed by any other class, then defining a default constructor (constructor with no arguments) is not mandatory in Java.**

Here's why:

* **Compiler-Generated Default Constructor:** The Java compiler automatically generates a default constructor for any class that doesn't explicitly define one. This default constructor simply calls the no-argument constructor of the superclass (if there is one) and doesn't perform any additional initialization.
* **No Subclasses, No Need for Explicit Call:** Since the class isn't subclassed, there's no need for subclasses to explicitly call a constructor using `super()`. The compiler-generated default constructor will suffice for creating objects of that class.
{% endhint %}
