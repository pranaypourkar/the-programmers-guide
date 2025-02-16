# Shallow Copy and Deep Copy

## About Shallow Copy

Shallow copy creates a new object and then copies the reference of the original object into it. In other words, it duplicates the reference, not the underlying data. So, any changes made to the copied object will reflect in the original object and vice versa because they both refer to the same underlying data.

Shallow copy is relatively simple and fast, but it can lead to unexpected behavior if you're not careful about how changes propagate across objects.

## About Deep Copy

Deep copy, on the other hand, creates a new object and then, recursively, copies each field of the original object into the new object. This means that changes made to the copied object won't affect the original object, and vice versa, because they refer to different sets of data.

Deep copying can be more complex and computationally expensive, especially for complex objects with nested structures or references to other objects.

## Sample Example

### **Example 1**

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

### **Example 2**

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

### **Example 3**

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

