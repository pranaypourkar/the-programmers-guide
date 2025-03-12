# Serialization & Deserialization

## About

**Serialization** and **Deserialization** are processes in Java (and in other programming languages) that involve converting an object into a stream of bytes to store its state persistently or to transmit it over a network, and then reconstructing the object from that stream.

{% hint style="info" %}
Whenever an object is Serialized, the object is stamped with a version ID number for the object class. This ID is called the SerialVersionUID. This is used during deserialization to verify that the sender and receiver that are compatible with the Serialization.
{% endhint %}

## Serialization

Serialization is the process of converting an object into a byte stream so that it can be stored in a file, sent over a network, or persisted in a database.

### **Purpose**

* **Persistence**: Save the state of an object for later retrieval.
* **Communication**: Transmit objects between applications or across a network.

### **Mechanism**

* In Java, the `Serializable` interface marks a class as serializable. It is a marker interface without any methods.
* Objects of a serializable class can be converted into a stream of bytes using `ObjectOutputStream`.
* Variables that are marked as transient will not be a part of the serialization. So we can skip the serialization for the variables in the file by using a transient keyword.

### **Example**

```java
import java.io.*;

public class SerializationExample {
    public static void main(String[] args) {
        // Creating an object of class Student
        Student student = new Student("John Doe", 25, "Computer Science");

        // Serialization
        try {
            FileOutputStream fileOut = new FileOutputStream("student.ser");
            ObjectOutputStream out = new ObjectOutputStream(fileOut);
            out.writeObject(student);
            out.close();
            fileOut.close();
            System.out.println("Object serialized successfully.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

## Deserialization

Deserialization is the process of reconstructing an object from a serialized byte stream.

### **Purpose**

* Restore the state of an object previously serialized.
* Receive and reconstruct objects transmitted over a network or read from storage.

### **Mechanism**

* In Java, use `ObjectInputStream` to read the serialized byte stream and reconstruct the object.
* The class of the deserialized object must have the same serialVersionUID as when it was serialized to ensure compatibility.

### **Example**

```java
import java.io.*;

public class DeserializationExample {
    public static void main(String[] args) {
        // Deserialization
        try {
            FileInputStream fileIn = new FileInputStream("student.ser");
            ObjectInputStream in = new ObjectInputStream(fileIn);
            Student student = (Student) in.readObject();
            in.close();
            fileIn.close();
            System.out.println("Object deserialized successfully.");
            System.out.println("Name: " + student.getName());
            System.out.println("Age: " + student.getAge());
            System.out.println("Major: " + student.getMajor());
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

## About serialVersionUID

`serialVersionUID` is a unique identifier for a `Serializable` class in Java. It ensures version compatibility between serialized and deserialized objects.

### Why is `serialVersionUID` Needed?

During deserialization, Java checks whether the class used to serialize an object matches the class definition available at runtime. This is done by comparing the `serialVersionUID` of the serialized object and the current class. If they don’t match, `InvalidClassException` is thrown.

### Default Behavior

If `serialVersionUID` is not explicitly declared, Java generates it based on various class properties such as fields, methods, constructors, and other structural elements. This means even a minor change in the class (e.g., renaming a method) can alter the generated `serialVersionUID`, causing incompatibility.

### Declaring `serialVersionUID`

To avoid unexpected deserialization failures, we can manually define `serialVersionUID`

{% hint style="success" %}
#### Generating `serialVersionUID` Automatically

You can generate a unique `serialVersionUID` using `serialver` tool:

```sh
shCopyEditserialver -show
serialver Employee
```

This helps when we want to ensure consistency across different versions.
{% endhint %}

```java
import java.io.Serializable;

public class Employee implements Serializable {
    private static final long serialVersionUID = 1L; // Explicitly declared
    private String name;
    private int age;

    // Getters and setters
}
```

### How Does It Work?

1. When an object is serialized, its `serialVersionUID` is stored in the serialized data.
2. During deserialization, Java checks if the `serialVersionUID` of the saved object matches the current class.
3. If they match, deserialization proceeds. Otherwise, an `InvalidClassException` occurs.

### Best Practices

1. **Always define `serialVersionUID` explicitly** to prevent accidental changes from breaking deserialization.
2. **Use a meaningful value** (e.g., increment it when making incompatible changes).
3. **Keep it the same if changes are backward-compatible** (e.g., adding non-final, non-static fields).
4. **Use `serialVersionUID` for versioning** to control object evolution across different releases.

### Handling Class Changes with Default `serialVersionUID`

<table><thead><tr><th width="338">Change Type</th><th>Impact on Deserialization</th></tr></thead><tbody><tr><td>Adding new non-static, non-final fields</td><td>Compatible</td></tr><tr><td>Changing method implementation</td><td>Compatible</td></tr><tr><td>Removing a field</td><td>Compatible (field gets default value)</td></tr><tr><td>Changing field type</td><td>Incompatible (causes <code>InvalidClassException</code>)</td></tr><tr><td>Renaming a field</td><td>Incompatible (treated as removal and addition)</td></tr></tbody></table>

### Scenario 1: `serialVersionUID` Matches (Successful Deserialization)

#### **Step 1: Define and Serialize an Object**

We define a class `Employee` with an explicitly declared `serialVersionUID` and serialize an object of this class.

```java
import java.io.*;

class Employee implements Serializable {
    private static final long serialVersionUID = 1L; // Explicitly defined
    private String name;
    private int age;

    public Employee(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Employee{name='" + name + "', age=" + age + "}";
    }
}

public class SerializeExample {
    public static void main(String[] args) throws IOException {
        Employee emp = new Employee("Alice", 30);
        
        // Serialize the object
        FileOutputStream fileOut = new FileOutputStream("employee.ser");
        ObjectOutputStream out = new ObjectOutputStream(fileOut);
        out.writeObject(emp);
        out.close();
        fileOut.close();

        System.out.println("Serialization Done!");
    }
}
```

This will create a file `employee.ser` containing the serialized object.

#### **Step 2: Deserialize Without Any Change**

If we deserialize the object without modifying the class, it works fine.

```java
import java.io.*;

public class DeserializeExample {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        // Deserialize the object
        FileInputStream fileIn = new FileInputStream("employee.ser");
        ObjectInputStream in = new ObjectInputStream(fileIn);
        Employee emp = (Employee) in.readObject();
        in.close();
        fileIn.close();

        System.out.println("Deserialized Object: " + emp);
        /*
        Serialization Done!
        Deserialized Object: Employee{name='Alice', age=30}
        */
    }
}
```

Since the `serialVersionUID` in the serialized data matches the `serialVersionUID` of the class at runtime, deserialization is successful.

### **Scenario 2: `serialVersionUID` Does Not Match (Failure Case)**

#### **Step 1: Serialize an Object with `serialVersionUID = 1L`**

We start by defining a class **Employee** with `serialVersionUID = 1L` and serialize an object.

```java
import java.io.*;

class Employee implements Serializable {
    private static final long serialVersionUID = 1L; // Explicitly defined
    private String name;
    private int age;

    public Employee(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Employee{name='" + name + "', age=" + age + "}";
    }
}

public class SerializeExample {
    public static void main(String[] args) throws IOException {
        Employee emp = new Employee("Alice", 30);

        // Serialize the object
        FileOutputStream fileOut = new FileOutputStream("employee.ser");
        ObjectOutputStream out = new ObjectOutputStream(fileOut);
        out.writeObject(emp);
        out.close();
        fileOut.close();

        System.out.println("Serialization Done!");
    }
}
```

* The object is serialized and saved in **employee.ser**.
* The `serialVersionUID` is `1L` at this point.

#### **Step 2: Modify the Class and Change `serialVersionUID`**

Now, let's modify the Employee class by:

* Changing `serialVersionUID` to `2L`
* Adding a new field `department`

```java
import java.io.*;

class Employee implements Serializable {
    private static final long serialVersionUID = 2L; // Changed from 1L to 2L
    private String name;
    private int age;
    private String department; // New field added

    public Employee(String name, int age, String department) {
        this.name = name;
        this.age = age;
        this.department = department;
    }

    @Override
    public String toString() {
        return "Employee{name='" + name + "', age=" + age + "', department='" + department + "'}";
    }
}
```

#### **Step 3: Deserialize the Old Object**

Now, let's try to deserialize the old **employee.ser** file using the modified class.

```java
import java.io.*;

public class DeserializeExample {
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        // Deserialize the object
        FileInputStream fileIn = new FileInputStream("employee.ser");
        ObjectInputStream in = new ObjectInputStream(fileIn);
        Employee emp = (Employee) in.readObject();
        in.close();
        fileIn.close();

        System.out.println("Deserialized Object: " + emp);
    }
}
```

#### **Step 4: Runtime Error Due to Mismatch**

When we run this code, we get the following exception:

```
Exception in thread "main" java.io.InvalidClassException: Employee;
local class incompatible: stream classdesc serialVersionUID = 1, local class serialVersionUID = 2
```

#### **Why Did This Happen?**

* The old serialized object (stored in `employee.ser`) was created when `serialVersionUID = 1L`.
* The new class definition has `serialVersionUID = 2L`.
* Java compares the two `serialVersionUID` values during deserialization. Since they do not match, Java rejects the deserialization process and throws `InvalidClassException`.

#### **How to Fix This?**

#### **Solution 1: Keep `serialVersionUID` the Same**

If we **keep `serialVersionUID = 1L`** in the new version of the class, deserialization will succeed.\
Even though the new field (`department`) was not in the original object, it will **default to `null`**.

```java
private static final long serialVersionUID = 1L;
```

#### **Solution 2: Implement `readObject()` for Backward Compatibility**

If we want the new `department` field to have a **default value** instead of `null`, we can use **custom deserialization**.

```java
private void readObject(ObjectInputStream ois) throws IOException, ClassNotFoundException {
    ois.defaultReadObject(); // Deserialize existing fields
    if (department == null) {  // Handle old serialized objects
        department = "Unknown";
    }
}
```

Now, when an old object is deserialized, it will have `"Unknown"` as the `department` value.

### **How to Maintain Compatibility?**

#### **Solution 1: Keep the Same `serialVersionUID`**

If we keep `serialVersionUID = 1L` in the modified class, deserialization will work.\
Even though the new field `department` is missing in the old serialized object, Java will initialize it with its default value (`null` for `String`).

```java
private static final long serialVersionUID = 1L;
```

**Deserialization succeeds**, and the output will be:

```
Deserialized Object: Employee{name='Alice', age=30, department=null}
```

#### **Solution 2: Implement `readObject()` for Backward Compatibility**

If we want full control over deserialization (e.g., setting default values for new fields), we can use `readObject()`:

```java
private void readObject(ObjectInputStream ois) throws IOException, ClassNotFoundException {
    ois.defaultReadObject();
    if (department == null) {  // Handle old object without department field
        department = "Unknown";
    }
}
```

Now, even if we deserialize an older object, it will have `"Unknown"` as the default department.
