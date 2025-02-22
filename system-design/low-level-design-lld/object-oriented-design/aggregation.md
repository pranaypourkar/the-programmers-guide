# Aggregation

## About

Aggregation is an **object-oriented design principle** where **one object contains another object** in a **weakly coupled manner**. It represents a **"has-a" relationship**, but unlike **composition**, the contained object **can exist independently of the containing object**.

**Key Idea**: An object (container) holds references to other objects, but those objects can exist independently.

{% hint style="danger" %}
Aggregation is not considered as one of the four fundamental OOP principles (Encapsulation, Abstraction, Inheritance, and Polymorphism). However, it is an important design concept within OOP.
{% endhint %}

{% hint style="success" %}
**Composition = Strong Ownership**\
**Aggregation = Weak Ownership**
{% endhint %}

## **Types of Aggregation**

### **1. Simple Aggregation (Loose Coupling)**

* Contained objects can exist **independently**.
* Objects are referenced via pointers.
* Represented by an **empty diamond in UML.**

**Example: A `Team` has `Players`, but players exist without the team.**

```java
class Player {
    String name;
    Player(String name) { this.name = name; }
}

class Team {
    List<Player> players = new ArrayList<>();

    void addPlayer(Player p) { players.add(p); }
}
```

### **2. Shared Aggregation (Shared Ownership)**

* A single object **belongs to multiple containers**.
* If one container is deleted, the object still exists.
* Example: A `Book` is in multiple `Libraries`.

**Example: A `Library` contains `Books`, but books exist in multiple libraries.**

```java
class Book {
    String title;
    Book(String title) { this.title = title; }
}

class Library {
    List<Book> books = new ArrayList<>();

    void addBook(Book b) { books.add(b); }
}
```

## **Aggregation vs. Composition vs. Inheritance**

### **Comparison**

<table data-header-hidden data-full-width="true"><thead><tr><th width="207"></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Aggregation</strong></td><td><strong>Composition</strong></td><td><strong>Inheritance</strong></td></tr><tr><td><strong>Relationship</strong></td><td>"Has-a" (University has Students)</td><td>"Has-a" (Car has an Engine)</td><td>"Is-a" (Car is a Vehicle)</td></tr><tr><td><strong>Coupling</strong></td><td>Loose </td><td>Strong </td><td>Tight </td></tr><tr><td><strong>Lifespan Dependency</strong></td><td>Independent  (Student exists without University)</td><td>Dependent  (Engine dies with Car)</td><td>Dependent</td></tr><tr><td><strong>Code Reusability</strong></td><td>High </td><td>Moderate </td><td>Limited </td></tr><tr><td><strong>Encapsulation</strong></td><td>Strong </td><td>Strong </td><td>Weaker </td></tr><tr><td><strong>Flexibility</strong></td><td>More Flexible </td><td>Less Flexible </td><td>Fixed </td></tr><tr><td><strong>Example</strong></td><td>A <code>Team</code> has <code>Players</code> but they exist independently.</td><td>A <code>Car</code> has an <code>Engine</code>, which doesn't make sense alone.</td><td>A <code>Car</code> extends <code>Vehicle</code> (fixed behavior).</td></tr></tbody></table>

### **Code Example**

#### **Bad Example (Using Inheritance Incorrectly)**

```java
class Student {
    String name;
    Student(String name) { this.name = name; }
}

// Incorrect: University is not a Student!
class University extends Student { }

public class Main {
    public static void main(String[] args) {
        University uni = new University("John Doe");
    }
}
```

**Problem**: A `University` is **not** a `Student` but contains students.

#### **Good Example (Using Aggregation Correctly)**

```java
import java.util.ArrayList;
import java.util.List;

// Independent class
class Student {
    String name;
    
    Student(String name) { this.name = name; }
}

// Aggregation: University contains a list of students, but students can exist independently.
class University {
    private List<Student> students;

    University() { students = new ArrayList<>(); }

    void addStudent(Student student) { students.add(student); }

    void showStudents() {
        for (Student s : students) {
            System.out.println(s.name);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Student s1 = new Student("Alice");
        Student s2 = new Student("Bob");

        University uni = new University();
        uni.addStudent(s1);
        uni.addStudent(s2);

        uni.showStudents(); // Outputs: Alice, Bob
    }
}
```

**Correct Design**: Students exist **independently** from the `University`.



