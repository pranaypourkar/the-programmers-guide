# Object

## **About**

The `Object` class is the root of the class hierarchy in Java. Every class in Java directly or indirectly inherits from the `Object` class. It provides basic methods that all Java objects share, such as equality, hashing, cloning, and string representation. It resides in the `java.lang` package, and no import is required to use it.

## **Features**

1. **Root Class**: The base class for all Java classes.
2. **Essential Methods**: Provides methods for object comparison, hashing, string conversion, thread synchronization, and more.
3. **Automatic Inheritance**: All classes inherit from `Object` either directly or through other classes.
4. **Used in Collections**: The `Object` class serves as a common data type in generic structures like `List<Object>`.

## **Internal Working**

### **1. Inheritance and Subtyping**

* Any class can be cast to `Object`.
* This allows collections and frameworks to handle objects generically.

### **2. Methods Overview**

The `Object` class defines several methods that are fundamental to Java programming:

* **`equals`**: Determines logical equality.
* **`hashCode`**: Returns a hash code for the object.
* **`toString`**: Provides a string representation of the object.
* **`clone`**: Creates a shallow copy of the object.
* **`finalize`**: Performs cleanup before garbage collection.
* **`wait`, `notify`, `notifyAll`**: Used for thread synchronization.

## Key Methods

<table data-header-hidden data-full-width="true"><thead><tr><th width="257"></th><th></th></tr></thead><tbody><tr><td><strong>Key Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong><code>equals(Object obj)</code></strong></td><td>Compares the current object with the specified object for equality. <br><strong>Default Implementation</strong>: Compares references (<code>==</code>).</td></tr><tr><td><strong><code>hashCode()</code></strong></td><td>Returns an integer hash code representing the object. <br><strong>Contract with <code>equals</code></strong>: If two objects are equal, they must have the same hash code.</td></tr><tr><td><strong><code>toString()</code></strong></td><td>Returns a string representation of the object. <br><strong>Default format</strong>: <code>ClassName@HashCode</code>.</td></tr><tr><td><strong><code>clone()</code></strong></td><td>Creates a shallow copy of the object. <br><strong>Requirement</strong>: Must implement <code>Cloneable</code> interface; otherwise, throws <code>CloneNotSupportedException</code>.</td></tr><tr><td><strong><code>wait(), notify(), notifyAll()</code></strong></td><td>Thread synchronization methods for inter-thread communication. <br><strong>Usage</strong>: Used within synchronized blocks or methods.</td></tr><tr><td><strong><code>finalize()</code></strong></td><td>Called by the garbage collector before reclaiming memory. <br><strong>Note</strong>: Deprecated due to unreliability and better alternatives like <code>try-with-resources</code>.</td></tr></tbody></table>

## **Limitations**

1. **Default Behavior**: The default implementations of methods like `equals` and `hashCode` may not be suitable for all use cases and often need overriding.
2. **Synchronization Overhead**: Methods like `wait` and `notify` require careful handling to avoid deadlocks.
3. **Deprecated Finalize**: `finalize` is unreliable and not recommended for resource cleanup.

## **Real-World Usage**

1. **Equality and Hashing**: Custom classes that use collections like `HashSet` or `HashMap` often override `equals` and `hashCode`.
2. **Debugging**: `toString` is commonly overridden to provide meaningful information about objects during debugging.
3. **Concurrency**: Thread-safe communication using `wait`, `notify`, and `notifyAll`.
4. **Generic Object Handling**: Used in APIs and frameworks that work with objects generically (e.g., `Object[]`, Reflection).

## **Examples**

### **1. Default Methods**

```java
public class ObjectExample {
    public static void main(String[] args) {
        Object obj1 = new Object();
        Object obj2 = new Object();

        // toString
        System.out.println(obj1.toString()); // Output: java.lang.Object@<hashcode>

        // equals
        System.out.println(obj1.equals(obj2)); // Output: false

        // hashCode
        System.out.println(obj1.hashCode()); // Output: <hashcode>
    }
}
```

### **2. Overriding `equals` and `hashCode`**

```java
class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Person person = (Person) obj;
        return age == person.age && name.equals(person.name);
    }

    @Override
    public int hashCode() {
        return 31 * name.hashCode() + age;
    }
}

public class EqualsHashCodeExample {
    public static void main(String[] args) {
        Person p1 = new Person("Alice", 30);
        Person p2 = new Person("Alice", 30);

        System.out.println(p1.equals(p2)); // Output: true
        System.out.println(p1.hashCode() == p2.hashCode()); // Output: true
    }
}
```

### **3. Using `clone`**

```java
class CloneableExample implements Cloneable {
    int value;

    public CloneableExample(int value) {
        this.value = value;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

public class CloneExample {
    public static void main(String[] args) throws CloneNotSupportedException {
        CloneableExample original = new CloneableExample(10);
        CloneableExample copy = (CloneableExample) original.clone();

        System.out.println(original.value); // Output: 10
        System.out.println(copy.value); // Output: 10
    }
}
```

### **4. Synchronization with `wait` and `notify`**

```java
class WaitNotifyExample {
    private static final Object lock = new Object();

    public static void main(String[] args) {
        Thread waitingThread = new Thread(() -> {
            synchronized (lock) {
                try {
                    System.out.println("Waiting..."); // Output: Waiting...
                    lock.wait();
                    System.out.println("Notified!"); // Output: Notified!
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });

        Thread notifyingThread = new Thread(() -> {
            synchronized (lock) {
                System.out.println("Notifying..."); // Output: Notifying...
                lock.notify();
            }
        });

        waitingThread.start();
        notifyingThread.start();
    }
}
```
