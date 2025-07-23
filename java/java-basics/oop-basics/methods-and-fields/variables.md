# Variables

## About

A **variable** in Java is a named memory location that holds a value. It acts as a container for data that can be used and manipulated during program execution. Variables have the following attributes:

```
-> Type: Determines the kind of data the variable can hold (e.g., int, String).
-> Name: The identifier used to reference the variable.
-> Value: The actual data stored in the variable.
```

* **High-Level Abstraction**: Java abstracts direct memory manipulation for safety and simplicity. Variables in Java do not allow access to their underlying memory addresses.
* **No Pointers (Directly Accessible)**: Unlike C, Java does not support pointers explicitly. Memory references are handled internally by the Java Virtual Machine (JVM).

{% hint style="info" %}
#### **Example: Memory Address Access**

*   **C Example**:

    ```c
    int a = 10;
    int *ptr = &a;  // 'ptr' stores the address of 'a'
    printf("Address of a: %p\n", ptr); // Prints the memory address
    printf("Value of a: %d\n", *ptr);  // Dereferences 'ptr' to get the value
    ```
*   **Java Example**:

    ```java
    int a = 10;
    System.out.println("Value of a: " + a);  // Directly prints value
    // Java does not allow access to the memory address of 'a'
    ```
{% endhint %}

* **References for Objects**: Java uses references to interact with objects. A reference points to an object stored in the heap, but we cannot perform pointer arithmetic or access raw memory addresses.

```java
class Example {
    int value;
}

public class Test {
    public static void main(String[] args) {
        Example obj1 = new Example();
        obj1.value = 100;
        
        Example obj2 = obj1; // obj2 references the same object as obj1
        obj2.value = 200;

        System.out.println(obj1.value); // Outputs 200 (shared reference)
    }
}
```

## Variable Declaration and Initialization

```java
// Declaration: Specifies the variable's type and name.
int age;  // Declares a variable 'age' of type int

// Initialization: Assigns a value to the variable.
age = 25;  // Initializes 'age' with the value 25

// Combined Declaration and Initialization
int age = 25;  // Declares and initializes in one step
```

## **Types of Variables**

Java provides three categories of variables:

### **1. Local Variables**

* **Definition**: Variables declared inside a method, constructor, or block and used only within that scope.
* **Scope**: Limited to the method or block where they are declared.
* **Lifetime**: Exists only during the execution of the block or method.
* **Initialization**: Must be explicitly initialized before use (Java does not provide a default value).
* **Storage**: Stored in the **stack**.

{% hint style="info" %}
Local variables cannot have access modifiers (e.g., `public`, `private`).

Allocated memory is freed as soon as the block exits.
{% endhint %}

```java
void method() {
    int localVar = 10;  // Local variable
}
```

### **2. Instance Variables**

* **Definition**: Variables declared outside methods but inside a class, and are not marked as `static`. Each instance (object) of the class gets its own copy of these variables.
* **Scope**: Accessible within the entire class through the instance of the class.
* **Lifetime**: Exists as long as the object exists.
* **Initialization**: Automatically initialized to default values (`0`, `null`, `false`, etc.).
* **Storage**: Stored in the **heap**, as part of the object's memory.

{% hint style="info" %}
Used to store object states (e.g., `name`, `age` for a `Person` class).

Can have access modifiers (`public`, `private`, `protected`).
{% endhint %}

```java
class Example {
    int instanceVar = 5;  // Instance variable
}
```

### **3. Static (or Class) Variables**

* **Definition**: Variables declared with the `static` keyword, shared across all instances of the class.
* **Scope**: Can be accessed directly using the class name or through objects, but they belong to the class, not individual objects.
* **Lifetime**: Exists for the lifetime of the class in memory.
* **Initialization**: Automatically initialized to default values.
* **Storage**: Stored in the **method area (a part of heap memory)**.

{% hint style="info" %}
Shared among all instances of the class.

Changes made to a static variable reflect across all instances.

Useful for constants (`static final`) or global counters.
{% endhint %}

```java
static int staticVar = 100;  // Static variable
```

### **4. Parameters**

* **Definition**: Variables passed to methods, constructors, or functions as arguments.
* **Scope**: Limited to the method or constructor in which they are declared.
* **Lifetime**: Exists during the method execution.
* **Initialization**: Must be initialized when the method is called.

{% hint style="info" %}
Parameters behave like local variables within the method.

Passed by value in Java (both for primitives and references).
{% endhint %}

**Example**:

```java
public class Example {
    public void display(int param) { // Parameter variable
        System.out.println("Parameter: " + param);
    }
}
```

### **5. Final Variables**

* **Definition**: Variables declared with the `final` keyword, meaning their value cannot be changed after initialization.
* **Scope**: Depends on where it is declared (local, instance, or static).
* **Lifetime**: Same as the respective variable type (local, instance, or static).
* **Initialization**: Must be initialized either during declaration or in the constructor (for instance variables).

{% hint style="info" %}
Ensures immutability.

For objects, the reference cannot be reassigned, but the object's internal state can still change.
{% endhint %}

**Example**:

```java
public class Example {
    final int finalVar = 10; // Final variable

    public void display() {
        System.out.println("Final Variable: " + finalVar);
    }
}
```

### **6. Transient Variables**

* **Definition**: Instance variables marked with `transient` are excluded during serialization (not stored in serialized output).
* **Scope**: Same as instance variables.
* **Lifetime**: Exists as long as the object exists but not serialized.
* **Initialization**: Reverts to default value during deserialization.

{% hint style="info" %}
Useful for sensitive data (e.g., passwords) that should not be serialized.
{% endhint %}

**Example**:

```java
import java.io.*;

public class Example implements Serializable {
    transient int transientVar = 10; // Transient variable
    int normalVar = 20;

    public static void main(String[] args) throws Exception {
        Example example = new Example();

        // Serialization
        FileOutputStream fileOut = new FileOutputStream("example.ser");
        ObjectOutputStream out = new ObjectOutputStream(fileOut);
        out.writeObject(example);
        out.close();

        // Deserialization
        FileInputStream fileIn = new FileInputStream("example.ser");
        ObjectInputStream in = new ObjectInputStream(fileIn);
        Example deserializedExample = (Example) in.readObject();
        in.close();

        System.out.println("Transient Variable: " + deserializedExample.transientVar); // Output: 0
        System.out.println("Normal Variable: " + deserializedExample.normalVar);     // Output: 20
    }
}
```

### **7. Volatile Variables**

* **Definition**: A **volatile variable** in Java is a special type of variable used in **multithreading** to ensure that updates to the variable are immediately visible to all threads.
* **Scope**: Same as instance variables.
* **Lifetime**: Exists as long as the object exists.
* **Behavior**: Forces all threads to read the variable directly from main memory, ensuring updated values.

{% hint style="info" %}
In a multithreaded environment:

* Threads often **cache variables** for better performance.
* Changes made to a variable by one thread might not be visible to other threads immediately.
* This can lead to issues like threads working with stale data.

**Volatile** solves this problem by ensuring:

* Every read or write operation on a `volatile` variable is done directly from **main memory**.
* It prevents threads from caching the variable's value.
{% endhint %}

**Example**:

```java
public class Example extends Thread {
    private volatile boolean running = true; // Volatile variable

    public void run() {
        while (running) {
            System.out.println("Thread is running...");
        }
    }

    public void stopThread() {
        running = false; // Updates are visible to all threads
    }

    public static void main(String[] args) throws InterruptedException {
        Example thread = new Example();
        thread.start();

        Thread.sleep(1000);
        thread.stopThread();
    }
}
```

## **How Variables Work Behind the Scenes**

### **1. Memory Allocation**:

* When we declare a variable, Java determines its **type** and allocates memory accordingly in the appropriate memory area:
  * **Stack Memory**: Local variables are stored here.
  * **Heap Memory**: Instance variables (part of objects) are stored here.
  * **Method Area**: Static variables are stored here.
* The size of memory depends on the variable's type. For example:
  * `int` → 4 bytes
  * `double` → 8 bytes

### **2. Compilation**:

* During compilation, the compiler checks the types and assigns memory offsets to variables.
* For example:

```java
int x = 10;
```

The compiler reserves 4 bytes for `x` and initializes it with `10` (in binary).

### **3. Initialization**:

* The Java Virtual Machine (JVM) assigns a **default value** if a variable is not explicitly initialized (only for instance and static variables):
  * `int` → 0
  * `float` → 0.0f
  * `boolean` → `false`
  * Reference types → `null`
* Local variables **must** be explicitly initialized before use.

### **4. Access**:

* When we access a variable, the JVM uses the memory address (stored in metadata) to fetch its value.
* For local variables, the JVM looks up the stack frame of the current method.
* For instance variables, the JVM fetches the value from the heap memory associated with the object.

### **5. Garbage Collection**:

* Unused variables (e.g., objects) in the heap are eventually cleaned up by the JVM's **garbage collector** to free memory.

## **Example of Variable Life Cycle**

* **Static Variable**: Allocated memory in the method area when the class is loaded.
* **Instance Variable**: Allocated in the heap when `demo` is instantiated.
* **Local Variable**: Allocated in the stack when `display()` is invoked.

```java
public class VariableDemo {
    static int staticVar = 100;  // Stored in the method area (shared)
    int instanceVar = 10;        // Stored in the heap (object-specific)

    public void display() {
        int localVar = 5;        // Stored in the stack (method-specific)
        System.out.println("Local Variable: " + localVar);
        System.out.println("Instance Variable: " + instanceVar);
        System.out.println("Static Variable: " + staticVar);
    }

    public static void main(String[] args) {
        VariableDemo demo = new VariableDemo();
        demo.display();
    }
}
```

## **Why Java Doesn't Use Pointers like C?**

1. **Safety**: Pointers in C can be misused, leading to vulnerabilities such as buffer overflows, segmentation faults, or unauthorized memory access.
2. **Garbage Collection**: With automatic memory management, explicit pointers are unnecessary.
3. **Simplified Development**: Java focuses on productivity and ease of use, removing low-level concerns like pointer arithmetic.

## Is Java Pass-by-Reference or Pass-by-Value?

Java is **always pass-by-value**, but the way it behaves depends on whether we are dealing with **primitives** or **reference types**.

* When a method is called, Java **copies the value** of the argument and passes that copy to the method.
* What the method works on is a **copy of the variable**, not the original variable itself.
* This applies uniformly to both primitives and objects.

{% hint style="success" %}
- When passing objects, their **reference is copied** (pass-by-value), but the copy still points to the **same object**.
- This creates the illusion of pass-by-reference because we can modify the object itself but not its reference.
{% endhint %}

### **Primitives in Java**

For **primitives**, the value itself is copied and passed to the method.

Example:

```java
public class Test {
    public static void modify(int num) {
        num = 50; // Changes only the local copy
    }

    public static void main(String[] args) {
        int value = 10;
        modify(value);
        System.out.println(value); // Output: 10
    }
}
```

Here, the `value` in `main` remains unchanged because only its value (10) was copied to the `modify` method.

### **Objects in Java**

For **reference types (objects)**, the **reference (memory address)** is passed by value.

This means:

1. The reference to the object is copied and passed to the method.
2. The method operates on the **same object** in memory, but it cannot change the reference itself.

Example:

```java
class Example {
    int num;
}

public class Test {
    public static void modify(Example obj) {
        obj.num = 50; // Modifies the object
        obj = new Example(); // Changes the local copy of the reference
        obj.num = 100; // Changes the new object, not the original
    }

    public static void main(String[] args) {
        Example example = new Example();
        example.num = 10;
        modify(example);
        System.out.println(example.num); // Output: 50
    }
}
```

* `modify` changes the object (`example.num = 50`) because both the original and local reference point to the same object.
* When `obj` is reassigned to a new `Example()`, the original reference in `main` remains unaffected because only the local reference in `modify` is updated.



