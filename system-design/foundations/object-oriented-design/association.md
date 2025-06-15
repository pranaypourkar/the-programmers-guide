# Association

## About

Association is a **fundamental relationship** between two or more objects where they interact with each other but **do not depend on each other for existence**. It represents a **"uses-a"** or **"knows-a"** relationship in OOP.

**Key Idea**: Objects can interact with each other **without being tightly coupled**.

{% hint style="danger" %}
Association is not considered as one of the four fundamental OOP principles (Encapsulation, Abstraction, Inheritance, and Polymorphism). However, it is an important design concept within OOP.
{% endhint %}

## **Types of Association**

<table data-full-width="true"><thead><tr><th width="201">Type</th><th width="364">Description</th><th>Example</th></tr></thead><tbody><tr><td><strong>One-to-One</strong></td><td>One object is associated with only one other object.</td><td>A <code>Person</code> has <strong>one</strong> <code>Passport</code>.</td></tr><tr><td><strong>One-to-Many</strong></td><td>One object is associated with multiple objects.</td><td>A <code>Teacher</code> teaches <strong>many</strong> <code>Students</code>.</td></tr><tr><td><strong>Many-to-One</strong></td><td>Multiple objects are associated with one object.</td><td>Many <code>Students</code> study in <strong>one</strong> <code>School</code>.</td></tr><tr><td><strong>Many-to-Many</strong></td><td>Multiple objects are associated with multiple objects.</td><td>A <code>Student</code> enrolls in <strong>multiple</strong> <code>Courses</code>, and a <code>Course</code> has <strong>many</strong> <code>Students</code>.</td></tr></tbody></table>

## **Code Example: Association in Java**

### **Example 1: One-to-One Association (A Person Has One Passport)**

```java
class Passport {
    String passportNumber;
    
    Passport(String passportNumber) {
        this.passportNumber = passportNumber;
    }
}

class Person {
    String name;
    Passport passport;  // Association with Passport

    Person(String name, Passport passport) {
        this.name = name;
        this.passport = passport;
    }

    void display() {
        System.out.println(name + " has passport: " + passport.passportNumber);
    }
}

public class Main {
    public static void main(String[] args) {
        Passport p1 = new Passport("A123456");
        Person person1 = new Person("John", p1);
        person1.display();  // Output: John has passport: A123456
    }
}
```

**Correct Design**: The `Person` and `Passport` exist **independently** but are **associated**.

### **Example 2: One-to-Many Association (A Teacher Teaches Many Students)**

```java
import java.util.ArrayList;
import java.util.List;

class Student {
    String name;
    
    Student(String name) { this.name = name; }
}

class Teacher {
    String name;
    List<Student> students;

    Teacher(String name) {
        this.name = name;
        this.students = new ArrayList<>();
    }

    void addStudent(Student student) {
        students.add(student);
    }

    void showStudents() {
        System.out.println(name + " teaches:");
        for (Student s : students) {
            System.out.println("- " + s.name);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Teacher teacher = new Teacher("Mr. Smith");
        Student s1 = new Student("Alice");
        Student s2 = new Student("Bob");

        teacher.addStudent(s1);
        teacher.addStudent(s2);

        teacher.showStudents();
        // Output:
        // Mr. Smith teaches:
        // - Alice
        // - Bob
    }
}
```

**Correct Design**: The `Teacher` **knows** the `Students`, but they exist **independently**.

### **Example 3: Many-to-Many Association (Students Enroll in Courses)**

```java
import java.util.ArrayList;
import java.util.List;

class Student {
    String name;
    List<Course> courses = new ArrayList<>();

    Student(String name) { this.name = name; }

    void enroll(Course course) {
        courses.add(course);
        course.students.add(this);
    }

    void showCourses() {
        System.out.print(name + " is enrolled in: ");
        for (Course c : courses) {
            System.out.print(c.courseName + " ");
        }
        System.out.println();
    }
}

class Course {
    String courseName;
    List<Student> students = new ArrayList<>();

    Course(String courseName) { this.courseName = courseName; }
}

public class Main {
    public static void main(String[] args) {
        Student s1 = new Student("Alice");
        Student s2 = new Student("Bob");

        Course c1 = new Course("Math");
        Course c2 = new Course("Science");

        s1.enroll(c1);
        s1.enroll(c2);
        s2.enroll(c1);

        s1.showCourses();  // Alice is enrolled in: Math Science
        s2.showCourses();  // Bob is enrolled in: Math
    }
}
```

**Correct Design**: Students **know** Courses, and Courses **know** Students.

### Example 4: Many-to-One Association (Multiple Students Study in One School)

```java
class School {
    String name;

    School(String name) {
        this.name = name;
    }

    void showSchool() {
        System.out.println("School: " + name);
    }
}

class Student {
    String name;
    School school;  // Association with School

    Student(String name, School school) {
        this.name = name;
        this.school = school;
    }

    void showDetails() {
        System.out.println(name + " studies at " + school.name);
    }
}

public class Main {
    public static void main(String[] args) {
        School school = new School("Greenwood High");

        Student s1 = new Student("Alice", school);
        Student s2 = new Student("Bob", school);
        Student s3 = new Student("Charlie", school);

        s1.showDetails();
        s2.showDetails();
        s3.showDetails();

        // Output:
        // Alice studies at Greenwood High
        // Bob studies at Greenwood High
        // Charlie studies at Greenwood High
    }
}
```

## **Association vs. Aggregation vs. Composition**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td>Feature</td><td><strong>Association</strong></td><td><strong>Aggregation</strong></td><td><strong>Composition</strong></td></tr><tr><td><strong>Relationship</strong></td><td>"Uses-a"</td><td>"Has-a" (Weak ownership)</td><td>"Has-a" (Strong ownership)</td></tr><tr><td><strong>Lifespan Dependency</strong></td><td>Independent </td><td>Independent </td><td>Dependent </td></tr><tr><td><strong>Coupling</strong></td><td>Loose </td><td>Loose </td><td>Strong </td></tr><tr><td><strong>Example</strong></td><td>A <code>Teacher</code> <strong>teaches</strong> a <code>Student</code></td><td>A <code>Library</code> <strong>has</strong> <code>Books</code>, but books exist independently</td><td>A <code>Car</code> <strong>has</strong> an <code>Engine</code>, and the engine dies with the car</td></tr></tbody></table>

**Association is more general than Aggregation and Composition.**





