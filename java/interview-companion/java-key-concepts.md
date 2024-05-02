# Java Key Concepts

1. Why main method is always declared with **public static void**

In Java, `public static void main(String[] args)` is the entry point of any Java program. L

* `public`: It means that the `main` method can be accessed from anywhere. It's necessary because the Java Virtual Machine (JVM) needs to access this method to start the execution of the program.
* `static`: It means that the `main` method belongs to the class itself, rather than to any instance of the class. This is because Java starts the program before any objects are created.
* `void`: It indicates that the `main` method doesn't return any value.
* `main`: This is the name of the method. `main` is a special method name recognized by the JVM.
* `(String[] args)`: This is the parameter that `main` accepts. `args` is an array of strings that can be passed to the program from the command line. These are typically arguments that you want to pass to your program when you run it.

So, when we run a Java program from the command line, we can pass arguments to it like this. `args` will contain `["arg1", "arg2", "arg3"]`, and we can access these values inside the `main` method.

```
java SomeClassName arg1 arg2 arg3
```

2. Rules for variable names in Java:
   * Variable names must begin with a letter (a-z or A-Z), an underscore (\_), or a currency character ($ or €).
   * First character of a variable name cannot be a digit. It can start with currency or underscore also.
   * Variable names are case-sensitive, meaning `myVariable` and `MyVariable` are considered different variables.
   * Variable names cannot be a Java keyword or reserved word, such as `int`, `class`, `public`, etc
3. Shallow Copy vs Deep Copy

**Shallow Copy**

* Shallow copy creates a new object and then copies the reference of the original object into it. In other words, it duplicates the reference, not the underlying data.
* So, any changes made to the copied object will reflect in the original object and vice versa because they both refer to the same underlying data.
* Shallow copy is relatively simple and fast, but it can lead to unexpected behavior if you're not careful about how changes propagate across objects.

**Deep Copy**

* Deep copy, on the other hand, creates a new object and then, recursively, copies each field of the original object into the new object.
* This means that changes made to the copied object won't affect the original object, and vice versa, because they refer to different sets of data.
* Deep copying can be more complex and computationally expensive, especially for complex objects with nested structures or references to other objects.

**Example 1**

```java
class Person {
    String name;
    int age;
    
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

public class Main {
    public static void main(String[] args) {
        Person original = new Person("Alice", 30);

        // Shallow copy
        Person shallowCopy = original;
        shallowCopy.age = 25; // Changes reflected in both objects
        System.out.println(original.age); // Output: 25

        // Deep copy
        Person deepCopy = new Person(original.name, original.age);
        deepCopy.age = 35; // Changes not reflected in original
        System.out.println(original.age); // Output: 25
        System.out.println(deepCopy.age); // Output: 35
    }
}
```

Changes made to the shallow copy (`shallowCopy`) affect the original object (`original`) because they both refer to the same object in memory. However, changes made to the deep copy (`deepCopy`) do not affect the original object because they are separate instances with their own memory space.

**Example 2**

```java
class Document implements Cloneable {
    private String content;
    private List<String> styles;

    public Document(String content, List<String> styles) {
        this.content = content;
        this.styles = styles;
    }

    // Getter methods for content and styles

    @Override
    public Document clone() throws CloneNotSupportedException {
        List<String> clonedStyles = new ArrayList<>(this.styles);
        return new Document(this.content, clonedStyles);
    }
}
```

In this method, a new `ArrayList` (`clonedStyles`) is created, and the elements from the original `styles` list are copied into it. This process of creating a new list and copying elements ensures that the `styles` list of the cloned `Document` object refers to a different memory location than the `styles` list of the original `Document` object. Therefore, changes made to the `styles` list of one `Document` object will not affect the `styles` list of the other `Document` object.

**Example 3**

```java
public class Orc implements Cloneable { // Implements Cloneable (optional)
  private String name;
  private int health;
  private Weapon weapon; // Reference to a Weapon object

  public Orc(String name, int health, Weapon weapon) {
    this.name = name;
    this.health = health;
    this.weapon = weapon;
  }

  @Override
  public Object clone() throws CloneNotSupportedException {
    Orc clone = new Orc(name, health, weapon); // Shallow copy
    return clone;
  }
}
```

Here, the `clone()` method creates a new `Orc` object (`clone`) using the constructor with parameters `name`, `health`, and `weapon`. However, since no special handling is done for the `weapon` field, it's simply copied by reference. This means the `weapon` field of the cloned `Orc` object will reference the same `Weapon` object as the original `Orc` object. Therefore, any changes made to the `Weapon` object through the cloned `Orc` object will affect the original `Orc` object, and vice versa. This behavior indicates that it's a shallow copy



