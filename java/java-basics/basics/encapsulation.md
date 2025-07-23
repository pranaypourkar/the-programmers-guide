# Encapsulation

## Description

Encapsulation is one of the four fundamental principles of object-oriented programming (OOP), along with inheritance, polymorphism, and abstraction. It refers to the bundling of data (variables) and methods (functions) that operate on the data into a single unit, known as a class. Encapsulation allows you to hide the internal state of an object and restrict access to its data, while exposing a controlled interface for interacting with the object.

## Key Concepts of Encapsulation

1. **Data Hiding**: Encapsulation hides the internal state of an object from the outside world by making the data members (variables) of a class private. This prevents direct access to the object's data and ensures that it is accessed and modified only through controlled interfaces, such as methods.

```java
public class EncapsulationExample {
    private int id; // Private data member
    private String name; // Private data member

    // Constructor and methods omitted for brevity
}
```

2. **Access Modifiers**: In encapsulation, access modifiers (e.g., `private`, `public`, `protected`) are used to control the visibility and accessibility of class members (variables and methods). By specifying appropriate access modifiers, you can enforce access control rules and protect the integrity of the object's data.

```java
public class EncapsulationExample {
    private int id; // Private data member
    private String name; // Private data member

    // Constructor and methods omitted for brevity
}
```

3. **Getter and Setter Methods**: Encapsulation typically involves providing getter methods (accessors) and setter methods (mutators) to access and modify the private data members of a class, respectively. Getter methods allow external code to retrieve the values of private variables, while setter methods enable external code to modify the values of private variables, often with validation or additional logic.

```java
public class EncapsulationExample {
    private int id; // Private data member
    private String name; // Private data member

    // Getter method for id
    public int getId() {
        return id;
    }

    // Setter method for id
    public void setId(int id) {
        this.id = id;
    }

    // Getter method for name
    public String getName() {
        return name;
    }

    // Setter method for name
    public void setName(String name) {
        this.name = name;
    }

    // Constructor omitted for brevity
}
```

4. **Abstraction**: Encapsulation supports abstraction by hiding the implementation details of a class and exposing only the essential features through its public interface. This abstraction simplifies the interaction with objects, allowing users to focus on what an object does rather than how it works internally.

```java
public class EncapsulationExample {
    private int id; // Private data member
    private String name; // Private data member

    // Constructor, getter and setter methods omitted for brevity

    // Method to display object details (abstraction)
    public void displayDetails() {
        System.out.println("ID: " + id);
        System.out.println("Name: " + name);
    }
}
```

## Benefits of Encapsulation

* **Modularity**: Encapsulation promotes modularity by encapsulating related data and behavior within a single class. This modular design facilitates code reuse, maintenance, and scalability.
* **Information Hiding**: Encapsulation hides the internal details and complexities of a class implementation from its users. This helps in managing complexity and reducing dependencies between different parts of a program.
* **Security**: Encapsulation enhances security by providing a protective barrier around the internal state of objects. By controlling access to data through well-defined interfaces, encapsulation helps in preventing unauthorized access, manipulation, and corruption of data.

## Encapsulation helps in creating immutable classes

Encapsulation plays a crucial role in creating immutable classes in Java. Immutable classes are classes whose instances cannot be modified after they are created. Once an immutable object is created, its state remains constant throughout its lifetime. Encapsulation helps achieve immutability by enforcing the following principles:

1. **Private Fields**: In an immutable class, all fields are typically declared as `private` to encapsulate their state and prevent direct access from external classes.
2. **No Setter Methods**: Immutable classes typically do not provide setter methods to modify the values of their fields. This prevents external code from altering the state of immutable objects after they are created.
3. **Final Fields**: In addition to making fields private, immutable classes often declare their fields as `final` to ensure that their values cannot be changed once initialized.
4. **Constructor Initialization**: The values of fields in an immutable class are usually set only once, during object construction. The constructor initializes the fields with the provided values, and once constructed, the object's state cannot be modified.

```java
public final class ImmutableClass {
    private final int value; // Private and final field

    // Constructor initializes the value
    public ImmutableClass(int value) {
        this.value = value;
    }

    // Getter method to access the value
    public int getValue() {
        return value;
    }
}

// Main Application class
package src.main.java;

public class Application {
    public static void main(String[] args) {
        ImmutableClass i = new ImmutableClass(1);
        ImmutableClass j = new ImmutableClass(2);
    }
}
```



