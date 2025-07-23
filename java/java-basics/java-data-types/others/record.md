# Record

## **About**

A **record** in Java is a special type of class introduced in **Java 14 (Preview)** and finalized in **Java 16**. It is a concise way to model immutable data structures. Records are designed to hold immutable data and automatically generate boilerplate code such as constructors, `equals`, `hashCode`, and `toString`.

Records are particularly useful when working with data transfer objects (DTOs) or value objects where immutability, simplicity, and predictable behavior are required.

## **Features**

1. **Immutability**: Fields of a record are implicitly `final` and cannot be modified after initialization.
2. **Concise Syntax**: Automatically generates constructors, `equals`, `hashCode`, and `toString` methods, reducing boilerplate code.
3. **Data-Centric**: Records focus solely on storing data and provide built-in methods for common tasks.
4. **Compact Constructor**: Provides a canonical constructor matching the declared components.
5. **Readability**: Enhances code clarity by reducing unnecessary verbosity.
6. **Integration with Pattern Matching**: Easily integrates with `switch` expressions and pattern matching for destructuring.
7. **Serialization**: Fully supports serialization and deserialization.
8. **Custom Methods**: You can still define your own methods, static fields, and static methods in a record.

## **Key Methods**

The following methods are automatically generated for every record:

1. **`equals(Object obj)`**: Checks for equality based on the field values.
2. **`hashCode()`**: Generates a hash code based on the field values.
3. **`toString()`**: Provides a string representation of the record, including field names and values.
4. **Canonical Constructor**: A constructor that initializes all the fields in the record.
5. **Field Accessors**: Methods to access the values of the fields (e.g., `fieldName()` for each field).

## **Internal Working**

1.  **Syntax**:

    ```java
    public record RecordName(Type1 field1, Type2 field2) { }
    ```

    Behind the scenes, the compiler generates:

    * A private `final` field for each component.
    * Public accessor methods for each field.
    * `equals`, `hashCode`, and `toString` methods.
    * A canonical constructor for initializing the fields.
2. **Compilation**: During compilation, the record is transformed into a class with all the above features implemented.
3. **Immutability**:
   * Fields are `final`, ensuring immutability.
   * You cannot add setter methods.
4. **Customization**:
   * Developers can add methods or customize the canonical constructor while preserving immutability.

## **Limitations**

1. **Immutability**: Fields cannot be modified once set, which may not suit mutable data requirements.
2. **No Extensibility**: Records cannot extend other classes because they implicitly extend `java.lang.Record`. However, they can implement interfaces.
3. **Not a Replacement for Classes**: Records are designed for simple data containers and are not a fit for complex business logic.
4. **Inheritance Restrictions**: Records cannot define instance fields other than their components.
5. **Limited Field Types**: Fields in a record cannot be non-static inner classes or directly reference themselves.

## **Real-World Usage**

1. **Data Transfer Objects (DTOs)**: Simplify the creation of objects for transferring data between layers or systems.
2. **Immutable Models**: Represent immutable objects such as configurations or constants.
3. **Mapping API Responses**: Representing structured data received from external APIs.
4. **Reducing Boilerplate**: Enhance code readability by reducing verbose class definitions.

## **Examples**

### **1. Simple Record**

```java
public record Person(String name, int age) { }

public class RecordExample {
    public static void main(String[] args) {
        Person person = new Person("Alice", 30);

        System.out.println(person.name()); // Output: Alice
        System.out.println(person.age()); // Output: 30
        System.out.println(person); // Output: Person[name=Alice, age=30]
    }
}
```

### **2. Customizing the Constructor**

```java
public record Person(String name, int age) {
    public Person {
        if (age < 0) {
            throw new IllegalArgumentException("Age must be non-negative");
        }
    }
}

public class RecordExample {
    public static void main(String[] args) {
        Person person = new Person("Alice", 30);
        System.out.println(person); // Output: Person[name=Alice, age=30]
        
        // Uncommenting the below line will throw IllegalArgumentException
        // Person invalidPerson = new Person("Bob", -5);
    }
}
```

### **3. Adding Custom Methods**

```java
public record Rectangle(int width, int height) {
    public int area() {
        return width * height;
    }
}

public class RecordExample {
    public static void main(String[] args) {
        Rectangle rectangle = new Rectangle(4, 5);

        System.out.println(rectangle.area()); // Output: 20
    }
}
```

### **4. Using Records with Pattern Matching**

```java
public record Point(int x, int y) { }

public class PatternMatchingExample {
    public static void main(String[] args) {
        Object obj = new Point(3, 4);

        if (obj instanceof Point(int x, int y)) {
            System.out.println("Point coordinates: " + x + ", " + y); // Output: Point coordinates: 3, 4
        }
    }
}
```
