# Set 2

## **What are the features of JAVA?**

**Features of Java are as follows:**

* **OOP concepts**
  * Object-oriented
  * Inheritance
  * Encapsulation
  * Polymorphism
  * Abstraction
* **Platform independent:** A single program works on different platforms without any modification.
* **High Performance:** JIT (Just In Time compiler) enables high performance in Java. JIT converts the bytecode into machine language and then JVM starts the execution.
* **Multi-threaded:** A flow of execution is known as a Thread. JVM creates a thread which is called the main thread. The user can create multiple threads by extending the thread class or by implementing the Runnable interface.

## **How does Java enable high performance?**

Java uses Just In Time compiler to enable high performance. It is used to convert the instructions into bytecodes.

## **What do you mean by Constructor?**

**Constructors can be explained in detail with enlisted points:**

* When a new object is created in a program a constructor gets invoked corresponding to the class.
* The constructor is a method which has the same name as the class name.
* If a user doesn’t create a constructor implicitly a default constructor will be created.
* The constructor can be overloaded.
* If the user created a constructor with a parameter then he should create another constructor explicitly without a parameter.

## **What is meant by the Local variable and the Instance variable?**

**Local variables** are defined in the method and scope of the variables that exist inside the method itself.

**Instance variable** is defined inside the class and outside the method and the scope of the variables exists throughout the class.

## **What is a Class?**

All Java codes are defined in a Class. It has variables and methods.

**Variables** are attributes which define the state of a class.

**Methods** is a place where the exact business logic has to be done. It contains a set of statements (or) instructions to satisfy the particular requirement.

## **What is an Object?**

In Java, an object is an instance of a class that encapsulates data and behavior. It is a fundamental building block of object-oriented programming (OOP) in Java. An object has state (fields or attributes) and behavior (methods).

An object in Java is a runtime entity that represents an instance of a class. It contains:

* **State**: Represented by fields (also known as attributes or properties) that store data.
* **Behavior**: Represented by methods that operate on the object's state and perform actions.

## Different ways to create Object?

There are several ways to create objects in Java:

### **1. Using the `new` Keyword**:&#x20;

The most common way to create an object is by using the `new` keyword, which allocates memory for the object and invokes its constructor.

```java
// Using the new keyword
MyClass obj = new MyClass();
```

### **2. Using Reflection:**

Java provides the reflection API to create objects dynamically at runtime.

```java
try {
    Class<?> clazz = Class.forName("MyClass");
    MyClass obj = (MyClass) clazz.getDeclaredConstructor().newInstance();
} catch (ClassNotFoundException | InstantiationException | IllegalAccessException | NoSuchMethodException | InvocationTargetException e) {
    e.printStackTrace();
}
```

### **3. Using the `clone()` Method**:&#x20;

The `clone()` method is used to create a copy of an existing object. The class must implement the `Cloneable` interface and override the `clone()` method.

```java
class MyClass implements Cloneable {
    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }
}

MyClass obj1 = new MyClass();
try {
    MyClass obj2 = (MyClass) obj1.clone();
} catch (CloneNotSupportedException e) {
    e.printStackTrace();
}
```

### **4. Using Deserialization**

Objects can be created by deserializing a previously serialized object. This requires implementing the `Serializable` interface.

```java
// Serializing an object
try (ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream("object.dat"))) {
    MyClass obj = new MyClass();
    out.writeObject(obj);
} catch (IOException e) {
    e.printStackTrace();
}

// Deserializing an object
try (ObjectInputStream in = new ObjectInputStream(new FileInputStream("object.dat"))) {
    MyClass obj = (MyClass) in.readObject();
} catch (IOException | ClassNotFoundException e) {
    e.printStackTrace();
}
```

### **5. Using Factory Methods**:&#x20;

Factory methods are static methods that return instances of a class. These methods can encapsulate the creation logic.

```java
class MyClass {
    // Factory method
    public static MyClass createInstance() {
        return new MyClass();
    }
}

MyClass obj = MyClass.createInstance();
```

### **6. Using Singleton Pattern:**

The singleton pattern ensures that only one instance of a class is created and provides a global point of access to it.

```java
class Singleton {
    private static Singleton instance;

    private Singleton() {
        // private constructor
    }

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}

Singleton obj = Singleton.getInstance();
```

### **7. Using Builder Pattern**

The builder pattern is a creational pattern that provides a flexible way to construct complex objects.

```java
class MyClass {
    private final String field1;
    private final int field2;

    private MyClass(Builder builder) {
        this.field1 = builder.field1;
        this.field2 = builder.field2;
    }

    public static class Builder {
        private String field1;
        private int field2;

        public Builder setField1(String field1) {
            this.field1 = field1;
            return this;
        }

        public Builder setField2(int field2) {
            this.field2 = field2;
            return this;
        }

        public MyClass build() {
            return new MyClass(this);
        }
    }
}

MyClass obj = new MyClass.Builder().setField1("value").setField2(10).build();
```

## **What is Inheritance?**

Inheritance means one class can extend to another class. So that the codes can be reused from one class to another class. The existing class is known as the Super class whereas the derived class is known as a sub class.

```java
// Super class
public class Manupulation {
}

// Sub class
public class Addition extends Manipulation {
}
```

## **What is Encapsulation?**

**Purpose of Encapsulation:**

* Protects the code from others.
* Code maintainability.

We are declaring ‘a’ as an integer variable and it should not be negative.

```java
public class Addition {
    int a=5;
}
```

If someone changes the exact variable as “_**a = -5”**_ then it is bad.

**In order to overcome the problem we need to follow the steps below:**

* We can make the variable private or protected.
* Use public accessor methods such as set\<property> and get\<property>.

**So that the above code can be modified as:**

```java
public class Addition {
    private int a = 5; //Here the variable is marked as private
    // getter
    // setter
}
```

For encapsulation, we need to make all the instance variables private and create setter and getter for those variables. Which in turn will force others to call the setters rather than access the data directly.

## **What is Polymorphism?**

Polymorphism means many forms.  Polymorphism is applicable for **overriding** and not for **overloading**.

## **What is meant by Method Overriding?**

**Method overriding happens if the sub-class method satisfies the below conditions with the Super-class method:**\


* Method name should be the same
* The argument should be the same
* Return type should also be the same

The key benefit of overriding is that the Sub-class can provide some specific information about that sub-class type than the super-class.

## **What is meant by Overloading?**

Method overloading happens for different classes or within the same class.

**For method overloading, sub-class method should satisfy the below conditions with the Super-class method (or) methods in the same class itself:**

* Same method name
* Different argument types
* There may be different return types

## **What is meant by Interface?**

Multiple inheritances cannot be achieved in java. To overcome this problem the Interface concept is introduced. An interface in Java is a template or reference type, similar to a class, that can contain only constants, method signatures, default methods, static methods, and nested types. Interfaces cannot contain instance fields or constructors. Java does not support multiple inheritance (i.e., a class cannot inherit from more than one class) to avoid complexity and ambiguity (such as the Diamond Problem). However, multiple inheritance of type is achieved by using interfaces. A class can implement multiple interfaces, thus providing a way to achieve multiple inheritances.

* All the methods in the interface are internally **public abstract void**.
* All the variables in the interface are internally **public static final** that is constants.
* Classes can implement the interface and not extends.
* The class which implements the interface should provide an implementation for all the methods declared in the interface.

{% hint style="info" %}
In an interface, we do not need to explicitly mark methods as `abstract`; they are implicitly `public` and `abstract`.
{% endhint %}

```java
interface MyInterface {
    // Constant
    int CONSTANT = 10; // public static final by default

    // Abstract method
    void method1(); // public abstract by default

    // Default method (since Java 8)
    default void method2() {
        System.out.println("This is a default method");
    }

    // Static method (since Java 8)
    static void method3() {
        System.out.println("This is a static method");
    }
}

class MyClass implements MyInterface {
    @Override
    public void method1() {
        System.out.println("Implementation of method1");
    }
}

public class Main {
    public static void main(String[] args) {
        MyClass myClass = new MyClass();
        myClass.method1(); // Implementation of method1
        myClass.method2(); // This is a default method
        MyInterface.method3(); // This is a static method
    }
}
```

## What is meant by Abstract class?

An abstract class in Java is a class that cannot be instantiated on its own and is intended to be subclassed by other classes. It is used to define common characteristics and behaviors that multiple derived classes can share, but it can also include abstract methods that must be implemented by the subclasses.

1. **Cannot Be Instantiated**: You cannot create an instance of an abstract class.
2. **Can Contain Abstract Methods**: These are methods declared without an implementation. Subclasses must provide implementations for these methods.
3. **Can Contain Concrete Methods**: These are methods with an implementation. Subclasses can use or override these methods.
4. **Can Have Constructors**: Although you cannot instantiate an abstract class, you can define constructors in it, and these constructors are called when an instance of a subclass is created.
5. **Can Have Fields and Methods**: Just like regular classes, abstract classes can have member variables and methods.
6. **Can Implement Interfaces**: Abstract classes can implement interfaces, and the implementing subclasses must provide implementations for the interface methods.

```java
interface AnimalBehavior {
    void eat();
}

abstract class Animal implements AnimalBehavior {
    // Fields
    private String name;

    // Constructor
    public Animal(String name) {
        this.name = name;
    }

    // Concrete method
    public void sleep() {
        System.out.println(name + " is sleeping.");
    }

    // Abstract method
    public abstract void makeSound();

    // Concrete method that uses the abstract method
    public void performSound() {
        makeSound();
    }

    // Getter for name
    public String getName() {
        return name;
    }
}

class Dog extends Animal {
    // Constructor
    public Dog(String name) {
        super(name); // Call to the constructor of the abstract class
    }

    // Implementation of the abstract method
    @Override
    public void makeSound() {
        System.out.println(getName() + " says: Bark Bark");
    }

    // Implementation of the interface method
    @Override
    public void eat() {
        System.out.println(getName() + " is eating dog food.");
    }
}

class Cat extends Animal {
    // Constructor
    public Cat(String name) {
        super(name); // Call to the constructor of the abstract class
    }

    // Implementation of the abstract method
    @Override
    public void makeSound() {
        System.out.println(getName() + " says: Meow Meow");
    }

    // Implementation of the interface method
    @Override
    public void eat() {
        System.out.println(getName() + " is eating cat food.");
    }
}

class Cat extends Animal {
    // Constructor
    public Cat(String name) {
        super(name); // Call to the constructor of the abstract class
    }

    // Implementation of the abstract method
    @Override
    public void makeSound() {
        System.out.println(getName() + " says: Meow Meow");
    }

    // Implementation of the interface method
    @Override
    public void eat() {
        System.out.println(getName() + " is eating cat food.");
    }
}

public class Main {
    public static void main(String[] args) {
        // Animal animal = new Animal("Generic Animal"); // This would be an error: Cannot instantiate the abstract class

        // Create instances of subclasses
        Dog dog = new Dog("Buddy");
        Cat cat = new Cat("Whiskers");

        // Call concrete methods
        dog.sleep(); // Buddy is sleeping.
        cat.sleep(); // Whiskers is sleeping.

        // Call abstract method implementations
        dog.makeSound(); // Buddy says: Bark Bark
        cat.makeSound(); // Whiskers says: Meow Meow

        // Call interface method implementations
        dog.eat(); // Buddy is eating dog food.
        cat.eat(); // Whiskers is eating cat food.

        // Call concrete method in abstract class that uses an abstract method
        dog.performSound(); // Buddy says: Bark Bark
        cat.performSound(); // Whiskers says: Meow Meow
    }
}
```

## **Difference between Array and Array List**

<table data-full-width="true"><thead><tr><th width="183">Feature</th><th>Array</th><th>ArrayList</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>A fixed-size data structure that holds elements of the same type.</td><td>A resizable array implementation of the List interface.</td></tr><tr><td><strong>Size</strong></td><td>Fixed size, determined at the time of creation.</td><td>Dynamic size, can grow or shrink as needed.</td></tr><tr><td><strong>Performance</strong></td><td>Faster for indexed access and manipulation due to fixed size.</td><td>Slower for indexed access compared to arrays due to resizing and potential overhead.</td></tr><tr><td><strong>Flexibility</strong></td><td>Less flexible; size cannot be changed after creation.</td><td>More flexible; can change size dynamically.</td></tr><tr><td><strong>Initialization</strong></td><td><code>int[] arr = new int[10];</code></td><td><code>ArrayList&#x3C;Integer> list = new ArrayList&#x3C;>();</code></td></tr><tr><td><strong>Element Type</strong></td><td>Can hold primitive types or objects.</td><td>Can only hold objects (wrapper classes for primitives).</td></tr><tr><td><strong>Memory Management</strong></td><td>Continuous memory allocation.</td><td>Non-continuous memory allocation; uses an internal array that grows as needed.</td></tr><tr><td><strong>Methods Available</strong></td><td>Limited to basic operations (e.g., length, clone).</td><td>Extensive methods from the List interface (e.g., add, remove, get, size, contains).</td></tr><tr><td><strong>Iteration</strong></td><td>Requires loop constructs like for, while.</td><td>Supports enhanced for-loop and iterator.</td></tr><tr><td><strong>Type Safety</strong></td><td>Type-safe with primitive types and objects.</td><td>Type-safe with generics; can enforce type constraints.</td></tr><tr><td><strong>Null Values</strong></td><td>Can hold null values.</td><td>Can hold null values.</td></tr><tr><td><strong>Use Case</strong></td><td>Best for fixed-size collections where performance is critical.</td><td>Best for dynamic collections where the size may change frequently.</td></tr><tr><td><strong>Example</strong></td><td><code>int[] numbers = {1, 2, 3, 4, 5};</code></td><td><code>ArrayList&#x3C;Integer> numbers = new ArrayList&#x3C;>(Arrays.asList(1, 2, 3, 4, 5));</code></td></tr><tr><td><strong>Multidimensional</strong></td><td>Supports multidimensional arrays (e.g., <code>int[][] matrix</code>).</td><td>Supports only single-dimensional ArrayLists; multidimensional behavior achieved with nested ArrayLists.</td></tr><tr><td><strong>Capacity Management</strong></td><td>No concept of capacity; fixed size.</td><td>Initial capacity can be specified; grows automatically when capacity is exceeded.</td></tr><tr><td><strong>Primitive Handling</strong></td><td>Directly stores primitive types.</td><td>Requires boxing/unboxing for primitive types (e.g., <code>int</code> to <code>Integer</code>).</td></tr></tbody></table>

## **Difference between String, String Builder, and String Buffer**

<table data-full-width="true"><thead><tr><th width="178">Feature</th><th>String</th><th>StringBuilder</th><th>StringBuffer</th></tr></thead><tbody><tr><td><strong>Mutability</strong></td><td>Immutable</td><td>Mutable</td><td>Mutable</td></tr><tr><td><strong>Thread Safety</strong></td><td>Thread-safe (because it's immutable)</td><td>Not thread-safe</td><td>Thread-safe</td></tr><tr><td><strong>Storage</strong></td><td>String variables are stored in a “constant string pool”</td><td>String values are stored in a stack. If the values are changed then the new value replaces the older value.</td><td>Same as StringBuilder</td></tr><tr><td><strong>Performance</strong></td><td>Slower in operations involving multiple string modifications</td><td>Faster for single-threaded operations involving multiple string modifications</td><td>Slower than <code>StringBuilder</code> due to synchronization overhead</td></tr><tr><td><strong>Usage</strong></td><td>Used when the string value will not change or change infrequently</td><td>Used when the string value will change frequently and thread safety is not a concern</td><td>Used when the string value will change frequently and thread safety is a concern</td></tr><tr><td><strong>Methods Available</strong></td><td>Limited to standard string operations (e.g., length, charAt, substring)</td><td>Extensive methods for modifying strings (e.g., append, insert, delete, reverse)</td><td>Similar to <code>StringBuilder</code> with synchronized methods for thread safety</td></tr><tr><td><strong>Thread Synchronization</strong></td><td>Not applicable</td><td>Not synchronized</td><td>Synchronized methods</td></tr><tr><td><strong>Memory Allocation</strong></td><td>Fixed and cannot be changed after creation</td><td>Can grow dynamically</td><td>Can grow dynamically</td></tr><tr><td><strong>String Pool</strong></td><td>Supports string pool</td><td>Does not support string pool</td><td>Does not support string pool</td></tr><tr><td><strong>Performance in Concatenation</strong></td><td>Poor performance in concatenation (each concatenation creates a new object)</td><td>Better performance for concatenation (modifies the existing object)</td><td>Better performance for concatenation (modifies the existing object, but slower than <code>StringBuilder</code>)</td></tr><tr><td><strong>Example Initialization</strong></td><td><code>String str = "Hello";</code></td><td><code>StringBuilder sb = new StringBuilder("Hello");</code></td><td><code>StringBuffer sb = new StringBuffer("Hello");</code></td></tr><tr><td><strong>Usage Scenario</strong></td><td>Best for read-only or rarely modified strings</td><td>Best for frequently modified strings in single-threaded contexts</td><td>Best for frequently modified strings in multi-threaded contexts</td></tr><tr><td><strong>Example Operations</strong></td><td><code>str.concat(" World");</code></td><td><code>sb.append(" World");</code></td><td><code>sb.append(" World");</code></td></tr></tbody></table>

```java
// String
String str = "Hello";
str = str.concat(" World"); // Creates a new string "Hello World"
System.out.println(str);    // Output: Hello World

// StringBuilder
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World"); // Modifies the existing StringBuilder object
System.out.println(sb.toString()); // Output: Hello World

// StringBuffer
StringBuffer sb = new StringBuffer("Hello");
sb.append(" World"); // Modifies the existing StringBuffer object
System.out.println(sb.toString()); // Output: Hello World 
```

## **Explain about Public and Private access specifiers**

Public members are visible in the same package as well as the outside package that is for other packages. Private members are visible in the same class only and not for the other classes in the same package as well as classes in the outside packages.

## **Difference between Default and Protected access specifiers.**

Methods and variables declared in a class without any access specifiers are called default. Default members in a Class are visible to the other classes which are inside the package and invisible to the classes which are outside the package. Protected member is not visible to all classes in the package of the subclass, only to the subclass itself.

## **Difference between HashMap and HashTable**

<table data-full-width="true"><thead><tr><th width="211">Feature</th><th>HashMap</th><th>Hashtable</th></tr></thead><tbody><tr><td><strong>Thread Safety</strong></td><td>Not thread-safe</td><td>Thread-safe</td></tr><tr><td><strong>Synchronization</strong></td><td>No methods are synchronized</td><td>All methods are synchronized</td></tr><tr><td><strong>Performance</strong></td><td>Faster due to lack of synchronization</td><td>Slower due to synchronization overhead</td></tr><tr><td><strong>Null Keys and Values</strong></td><td>Allows one null key and multiple null values</td><td>Does not allow null keys or null values</td></tr><tr><td><strong>Legacy</strong></td><td>Part of the Java Collections Framework</td><td>Legacy class (exists since JDK 1.0)</td></tr><tr><td><strong>Iteration Order</strong></td><td>Does not guarantee any specific order</td><td>Does not guarantee any specific order</td></tr><tr><td><strong>Initial Capacity and Load Factor</strong></td><td>Default initial capacity of 16 and load factor of 0.75</td><td>Initial capacity is 11 and load factor is 0.75</td></tr><tr><td><strong>Fail-Fast Iterator</strong></td><td>Yes, throws <code>ConcurrentModificationException</code> if the map is modified while iterating</td><td>Yes, but the behavior is undefined</td></tr><tr><td><strong>Use Case</strong></td><td>Best for non-threaded applications</td><td>Best for legacy applications requiring thread safety</td></tr><tr><td><strong>Example Initialization</strong></td><td><code>HashMap&#x3C;String, Integer> map = new HashMap&#x3C;>();</code></td><td><code>Hashtable&#x3C;String, Integer> table = new Hashtable&#x3C;>();</code></td></tr><tr><td><mark style="background-color:yellow;"><strong>Synchronization Control</strong></mark></td><td>Can be synchronized externally using <code>Collections.synchronizedMap(new HashMap&#x3C;>());</code></td><td>Internally synchronized, cannot be made non-synchronized</td></tr></tbody></table>

## **Difference between HashSet and TreeSet**

<table data-full-width="true"><thead><tr><th>Feature</th><th>HashSet</th><th>TreeSet</th></tr></thead><tbody><tr><td><strong>Underlying Data Structure</strong></td><td>Hash table</td><td>Red-Black tree (a type of self-balancing binary search tree)</td></tr><tr><td><strong>Order of Elements</strong></td><td>No guaranteed order</td><td>Elements are sorted in natural order or by a provided comparator</td></tr><tr><td><strong>Performance (Basic Operations)</strong></td><td>O(1) average time complexity for add, remove, and contains operations</td><td>O(log n) time complexity for add, remove, and contains operations</td></tr><tr><td><strong>Null Elements</strong></td><td>Allows a single null element</td><td>Does not allow null elements (throws <code>NullPointerException</code>)</td></tr><tr><td><strong>Duplicates</strong></td><td>Does not allow duplicate elements</td><td>Does not allow duplicate elements</td></tr><tr><td><strong>Iteration Order</strong></td><td>No guaranteed iteration order</td><td>Iterates in ascending order</td></tr><tr><td><strong>Comparator Support</strong></td><td>No</td><td>Yes, can use a custom comparator for sorting</td></tr><tr><td><strong>Methods for Range Operations</strong></td><td>No</td><td>Yes, provides methods like <code>subSet()</code>, <code>headSet()</code>, <code>tailSet()</code></td></tr><tr><td><strong>Example Initialization</strong></td><td><code>Set&#x3C;String> set = new HashSet&#x3C;>();</code></td><td><code>Set&#x3C;String> set = new TreeSet&#x3C;>();</code></td></tr><tr><td><strong>Use Case</strong></td><td>Best for collections with unique elements and no ordering requirement</td><td>Best for collections with unique elements that need to be sorted</td></tr></tbody></table>

## **Difference between Abstract class and Interface**

<table data-full-width="true"><thead><tr><th width="180">Feature</th><th>Abstract Class</th><th>Interface</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>Can contain abstract and concrete methods.</td><td>Can only contain abstract methods (until Java 8). From Java 8 onwards, can contain default and static methods.</td></tr><tr><td><strong>Purpose</strong></td><td>To provide a common base class with shared code.</td><td>To define a contract that implementing classes must follow.</td></tr><tr><td><strong>Inheritance</strong></td><td>A class can inherit only one abstract class (single inheritance).</td><td>A class can implement multiple interfaces (multiple inheritance).</td></tr><tr><td><strong>Implementation</strong></td><td>Can provide method implementations.</td><td>Cannot provide method implementations (except default and static methods from Java 8 onwards).</td></tr><tr><td><strong>Fields</strong></td><td>Can have instance variables (fields) and static fields.</td><td>Can only have static final fields (constants).</td></tr><tr><td><strong>Constructors</strong></td><td>Can have constructors.</td><td>Cannot have constructors.</td></tr><tr><td><strong>Access Modifiers</strong></td><td>Can have any access modifier (public, protected, private).</td><td>Methods are implicitly public (until Java 9). Can have private methods from Java 9 onwards.</td></tr><tr><td><strong>When to Use</strong></td><td>When you want to share code among several closely related classes.</td><td>When you want to define a role that can be shared among classes not necessarily related.</td></tr><tr><td><strong>Multiple Inheritance</strong></td><td>Does not support multiple inheritance.</td><td>Supports multiple inheritance.</td></tr><tr><td><strong>Example Usage</strong></td><td><code>abstract class Animal { ... }</code></td><td><code>interface AnimalBehavior { ... }</code></td></tr><tr><td><strong>Method Implementation</strong></td><td>Can contain both abstract and concrete methods.</td><td>Can contain abstract methods, and from Java 8 onwards, default and static methods.</td></tr><tr><td><strong>State Management</strong></td><td>Can manage state via instance variables.</td><td>Cannot manage state, only constants.</td></tr><tr><td><strong>Instantiation</strong></td><td>Cannot be instantiated directly.</td><td>Cannot be instantiated directly.</td></tr></tbody></table>

## What is Java Collections Framework?

The Java Collections Framework is a unified architecture for representing and manipulating collections of objects. It includes interfaces, implementations, and algorithms to help developers work with groups of objects in a standard way. The key components of the Java Collections Framework are:

**Interfaces**

These are abstract data types that represent collections. Some of the primary interfaces include:

* **Collection**: The root interface in the collection hierarchy. A collection represents a group of objects known as its elements.
  * **List**: An ordered collection (also known as a sequence). Allows duplicate elements. Examples: `ArrayList`, `LinkedList`.
  * **Set**: A collection that does not allow duplicate elements. Examples: `HashSet`, `TreeSet`.
  * **Queue**: A collection designed for holding elements prior to processing. Examples: `PriorityQueue`, `LinkedList`.
  * **Deque**: A double-ended queue that allows elements to be added or removed from both ends. Examples: `ArrayDeque`, `LinkedList`.
* **Map**: An object that maps keys to values. A map cannot contain duplicate keys; each key can map to at most one value. Examples: `HashMap`, `TreeMap`, `Hashtable`.

**Implementations**

These are the concrete classes that implement the collection interfaces. Some examples include:

* **ArrayList**: Implements the `List` interface. Uses a dynamic array to store elements.
* **LinkedList**: Implements both `List` and `Deque` interfaces. Uses a doubly linked list to store elements.
* **HashSet**: Implements the `Set` interface. Uses a hash table for storage.
* **TreeSet**: Implements the `Set` interface. Uses a Red-Black tree for storage, which orders the elements.
* **HashMap**: Implements the `Map` interface. Uses a hash table for storage.
* **TreeMap**: Implements the `Map` interface. Uses a Red-Black tree for storage, which orders the keys.

**Algorithms**

These are methods that perform useful computations, such as searching and sorting, on objects that implement collection interfaces. These algorithms are defined as static methods within the `java.util.Collections` class.

#### `java.util.Collections` Class

The `java.util.Collections` class consists of static methods that operate on or return collections. It contains polymorphic algorithms that operate on collections, "wrappers" which return a new collection backed by a specified collection, and a few other odds and ends.

**Key Methods in `java.util.Collections`**

* **Sorting**:
  * `sort(List<T> list)`: Sorts the specified list into ascending order.
  * `sort(List<T> list, Comparator<? super T> c)`: Sorts the specified list according to the order induced by the specified comparator.
* **Searching**:
  * `binarySearch(List<? extends T> list, T key)`: Searches the specified list for the specified object using the binary search algorithm.
  * `binarySearch(List<? extends T> list, T key, Comparator<? super T> c)`: Searches the specified list for the specified object using the binary search algorithm and a comparator.
* **Shuffling**:
  * `shuffle(List<?> list)`: Randomly permutes the specified list.
  * `shuffle(List<?> list, Random rnd)`: Randomly permutes the specified list using the specified source of randomness.
* **Synchronization**:
  * `synchronizedCollection(Collection<T> c)`: Returns a synchronized (thread-safe) collection backed by the specified collection.
  * `synchronizedList(List<T> list)`: Returns a synchronized (thread-safe) list backed by the specified list.
  * `synchronizedMap(Map<K,V> m)`: Returns a synchronized (thread-safe) map backed by the specified map.
* **Unmodifiable Collections**:
  * `unmodifiableCollection(Collection<? extends T> c)`: Returns an unmodifiable view of the specified collection.
  * `unmodifiableList(List<? extends T> list)`: Returns an unmodifiable view of the specified list.
  * `unmodifiableMap(Map<? extends K,? extends V> m)`: Returns an unmodifiable view of the specified map.



## **Explain the different lists available in the collection?**

In the Java Collections Framework, the `List` interface is a part of the `java.util` package and represents an ordered collection (also known as a sequence). The `List` interface extends the `Collection` interface and includes operations for positional access, searching, iteration, and range-view. Various implementations of the `List` interface provide different ways of storing and managing the elements. Here are the main `List` implementations available:

#### 1. `ArrayList`

* **Description**:
  * Implements the `List` interface using a dynamically resizable array.
  * Provides fast random access to elements.
* **Key Characteristics**:
  * **Resizing**: Automatically grows when elements are added beyond its capacity.
  * **Performance**: O(1) time complexity for positional access. O(n) for add/remove operations when resizing is necessary.
  * **Nulls**: Allows null elements.
* **Use Case**: Suitable for frequent read operations and occasional insertions and deletions.

```java
import java.util.ArrayList;
import java.util.List;

public class ArrayListExample {
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        list.add("Apple");
        list.add("Banana");
        list.add("Cherry");

        System.out.println(list);
    }
}
```

#### 2. `LinkedList`

* **Description**:
  * Implements the `List` interface using a doubly linked list.
  * Provides efficient insertion and removal of elements.
* **Key Characteristics**:
  * **Structure**: Each element (node) contains a reference to the previous and next elements.
  * **Performance**: O(1) time complexity for insertions and deletions at the beginning or end. O(n) for positional access.
  * **Nulls**: Allows null elements.
* **Use Case**: Suitable for applications that require frequent insertions and deletions, particularly at the beginning or end of the list.

```java
import java.util.LinkedList;
import java.util.List;

public class LinkedListExample {
    public static void main(String[] args) {
        List<String> list = new LinkedList<>();
        list.add("Apple");
        list.add("Banana");
        list.add("Cherry");

        System.out.println(list);
    }
}
```

#### 3. `Vector`

* **Description**:
  * Implements the `List` interface using a dynamically resizable array, similar to `ArrayList`.
  * Synchronized, making it thread-safe.
* **Key Characteristics**:
  * **Thread-Safety**: All methods are synchronized.
  * **Performance**: O(1) time complexity for positional access. Slower than `ArrayList` due to synchronization overhead.
  * **Nulls**: Allows null elements.
* **Use Case**: Suitable for legacy codebases and applications requiring thread-safe list operations.

```java
import java.util.List;
import java.util.Vector;

public class VectorExample {
    public static void main(String[] args) {
        List<String> list = new Vector<>();
        list.add("Apple");
        list.add("Banana");
        list.add("Cherry");

        System.out.println(list);
    }
}
```

#### 4. `Stack`

* **Description**:
  * A subclass of `Vector` that implements a last-in-first-out (LIFO) stack.
* **Key Characteristics**:
  * **LIFO**: Provides typical stack operations like `push`, `pop`, and `peek`.
  * **Performance**: Similar to `Vector`.
  * **Nulls**: Allows null elements.
* **Use Case**: Suitable for stack operations and legacy applications requiring stack functionalities.

```java
import java.util.Stack;

public class StackExample {
    public static void main(String[] args) {
        Stack<String> stack = new Stack<>();
        stack.push("Apple");
        stack.push("Banana");
        stack.push("Cherry");

        System.out.println(stack);
    }
}
```

#### 5. `CopyOnWriteArrayList`

* **Description**:
  * A thread-safe variant of `ArrayList` in which all mutative operations (e.g., add, set, remove) are implemented by making a fresh copy of the underlying array.
* **Key Characteristics**:
  * **Thread-Safety**: Thread-safe without using synchronization.
  * **Performance**: Efficient for read operations, but slower for write operations due to array copying.
  * **Nulls**: Allows null elements.
* **Use Case**: Suitable for applications with many concurrent read operations and relatively few write operations.

```java
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class CopyOnWriteArrayListExample {
    public static void main(String[] args) {
        List<String> list = new CopyOnWriteArrayList<>();
        list.add("Apple");
        list.add("Banana");
        list.add("Cherry");

        System.out.println(list);
    }
}
```

## **Explain about Set and their types in a collection**

In the Java Collections Framework, the `Set` interface is a part of the `java.util` package and represents a collection that does not allow duplicate elements. The `Set` interface extends the `Collection` interface. There are several implementations of the `Set` interface, each providing different ways to store and manage elements. Here's a detailed look at the internals of `Set` and its types:

#### `Set` Interface

The `Set` interface defines a collection that does not allow duplicate elements. It models the mathematical set abstraction and provides methods for basic operations like adding, removing, and checking for elements. The primary implementations of the `Set` interface include `HashSet`, `LinkedHashSet`, and `TreeSet`.

#### 1. `HashSet`

* **Description**:
  * Implements the `Set` interface using a hash table.
  * Provides constant-time performance for basic operations (add, remove, contains).
* **Internals**:
  * Uses a `HashMap` internally to store elements.
  * Elements are stored as keys in the `HashMap`, with a dummy value.
  * The hash code of the element is used to determine its position in the hash table.
* **Key Characteristics**:
  * **Order**: No guaranteed order of elements.
  * **Performance**: O(1) average time complexity for basic operations.
  * **Nulls**: Allows a single null element.
* **Use Case**: Suitable for collections where fast access is required, and the order of elements is not important.

```java
import java.util.HashSet;
import java.util.Set;

public class HashSetExample {
    public static void main(String[] args) {
        Set<String> set = new HashSet<>();
        set.add("Apple");
        set.add("Banana");
        set.add("Cherry");

        System.out.println(set); // Order is not guaranteed
    }
}
```

#### 2. `LinkedHashSet`

* **Description**:
  * Extends `HashSet` and maintains a linked list of the entries in the set.
  * Provides insertion-order iteration.
* **Internals**:
  * Uses a `LinkedHashMap` internally.
  * Maintains a doubly linked list running through all of its entries to maintain insertion order.
* **Key Characteristics**:
  * **Order**: Maintains insertion order of elements.
  * **Performance**: Slightly slower than `HashSet` due to the additional linked list.
  * **Nulls**: Allows a single null element.
* **Use Case**: Suitable for collections where fast access is required, but the order of elements needs to be preserved.

```java
import java.util.LinkedHashSet;
import java.util.Set;

public class LinkedHashSetExample {
    public static void main(String[] args) {
        Set<String> set = new LinkedHashSet<>();
        set.add("Apple");
        set.add("Banana");
        set.add("Cherry");

        System.out.println(set); // Order is preserved
    }
}
```

#### 3. `TreeSet`

* **Description**:
  * Implements the `Set` interface using a Red-Black tree (a self-balancing binary search tree).
  * Provides sorted order of elements.
* **Internals**:
  * Uses a `TreeMap` internally.
  * Elements are stored as keys in the `TreeMap`.
  * The tree is sorted according to the natural ordering of its elements or by a comparator provided at set creation time.
* **Key Characteristics**:
  * **Order**: Elements are sorted in ascending order or by a provided comparator.
  * **Performance**: O(log n) time complexity for basic operations.
  * **Nulls**: Does not allow null elements (throws `NullPointerException`).
* **Use Case**: Suitable for collections where sorted order of elements is required.

```java
import java.util.Set;
import java.util.TreeSet;

public class TreeSetExample {
    public static void main(String[] args) {
        Set<String> set = new TreeSet<>();
        set.add("Apple");
        set.add("Banana");
        set.add("Cherry");

        System.out.println(set); // Elements are sorted in ascending order
    }
}
```

## **Explain about Map and its types?**

In the Java Collections Framework, the `Map` interface is a part of the `java.util` package and represents a collection of key-value pairs. A `Map` cannot contain duplicate keys, and each key can map to at most one value. There are several implementations of the `Map` interface, each providing different ways to store and manage key-value pairs. Here's a detailed look at the `Map` interface and its types:

#### `Map` Interface

The `Map` interface defines a collection that maps keys to values. It includes methods for basic operations like putting, getting, removing, and checking for elements. The primary implementations of the `Map` interface include `HashMap`, `LinkedHashMap`, `TreeMap`, and `Hashtable`.

#### 1. `HashMap`

* **Description**:
  * Implements the `Map` interface using a hash table.
  * Provides constant-time performance for basic operations (put, get, remove).
* **Internals**:
  * Uses an array of buckets, where each bucket is a linked list (or tree in case of many collisions).
  * The hash code of the key is used to determine its position in the hash table.
* **Key Characteristics**:
  * **Order**: No guaranteed order of keys.
  * **Performance**: O(1) average time complexity for basic operations.
  * **Nulls**: Allows one null key and multiple null values.
* **Use Case**: Suitable for collections where fast access is required, and the order of keys is not important.

```java
import java.util.HashMap;
import java.util.Map;

public class HashMapExample {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();
        map.put("Apple", 1);
        map.put("Banana", 2);
        map.put("Cherry", 3);

        System.out.println(map);
    }
}
```

#### 2. `LinkedHashMap`

* **Description**:
  * Extends `HashMap` and maintains a doubly linked list of the entries.
  * Provides insertion-order iteration.
* **Internals**:
  * Uses a hash table with a linked list running through all of its entries to maintain insertion order.
* **Key Characteristics**:
  * **Order**: Maintains insertion order of keys.
  * **Performance**: Slightly slower than `HashMap` due to the additional linked list.
  * **Nulls**: Allows one null key and multiple null values.
* **Use Case**: Suitable for collections where fast access is required, but the order of keys needs to be preserved.

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class LinkedHashMapExample {
    public static void main(String[] args) {
        Map<String, Integer> map = new LinkedHashMap<>();
        map.put("Apple", 1);
        map.put("Banana", 2);
        map.put("Cherry", 3);

        System.out.println(map);
    }
}
```

#### 3. `TreeMap`

* **Description**:
  * Implements the `Map` interface using a Red-Black tree (a self-balancing binary search tree).
  * Provides sorted order of keys.
* **Internals**:
  * Uses a tree structure where elements are sorted according to the natural ordering of its keys or by a comparator provided at map creation time.
* **Key Characteristics**:
  * **Order**: Keys are sorted in ascending order or by a provided comparator.
  * **Performance**: O(log n) time complexity for basic operations.
  * **Nulls**: Does not allow null keys (throws `NullPointerException`).
* **Use Case**: Suitable for collections where sorted order of keys is required.

```java
import java.util.Map;
import java.util.TreeMap;

public class TreeMapExample {
    public static void main(String[] args) {
        Map<String, Integer> map = new TreeMap<>();
        map.put("Apple", 1);
        map.put("Banana", 2);
        map.put("Cherry", 3);

        System.out.println(map); // Keys are sorted in ascending order
    }
}
```

#### 4. `Hashtable`

* **Description**:
  * Implements the `Map` interface using a hash table.
  * Synchronized, making it thread-safe.
* **Internals**:
  * Uses an array of buckets, where each bucket is a linked list.
  * The hash code of the key is used to determine its position in the hash table.
* **Key Characteristics**:
  * **Order**: No guaranteed order of keys.
  * **Performance**: Slower than `HashMap` due to synchronization overhead.
  * **Nulls**: Does not allow null keys or values (throws `NullPointerException`).
* **Use Case**: Suitable for legacy applications requiring thread-safe map operations.

```java
import java.util.Hashtable;
import java.util.Map;

public class HashtableExample {
    public static void main(String[] args) {
        Map<String, Integer> map = new Hashtable<>();
        map.put("Apple", 1);
        map.put("Banana", 2);
        map.put("Cherry", 3);

        System.out.println(map);
    }
}
```

## **Explain the Priority Queue?**

In the Java Collections Framework, `PriorityQueue` is an implementation of the `Queue` interface that provides a priority-based ordering of elements. Elements in a `PriorityQueue` are ordered either by their natural ordering (if they implement the `Comparable` interface) or by a comparator provided at queue construction time. This makes `PriorityQueue` useful in scenarios where elements need to be processed based on their priority.

#### Key Features of `PriorityQueue`:

1. **Priority Ordering**:
   * Elements are ordered based on their priority, defined by either natural order or a custom comparator.
   * The head of the queue is always the least element with respect to the specified ordering.
2. **Dynamic Size**:
   * Unlike arrays or linked lists, `PriorityQueue` sizes can change dynamically as elements are added or removed.
3. **Efficient Operations**:
   * Basic operations like `add`, `offer`, `peek`, and `poll` have logarithmic time complexities (`O(log n)`), where `n` is the number of elements in the queue.
   * Removing the head (highest priority element) is efficient due to the underlying heap structure.

#### Internal Structure:

Internally, a `PriorityQueue` uses a heap data structure, specifically a binary heap, to maintain the priority order of elements. In a binary heap:

* **Min-Heap**: The smallest element is always at the root, making it suitable for `PriorityQueue` where the smallest element (by natural order or comparator) is dequeued first.
* **Max-Heap**: The largest element is at the root, which can be simulated by using a comparator that reverses the natural order.

#### Example Usage:

```java
import java.util.PriorityQueue;

public class PriorityQueueExample {
    public static void main(String[] args) {
        // Creating a priority queue of integers
        PriorityQueue<Integer> pq = new PriorityQueue<>();

        // Adding elements to the priority queue
        pq.add(10);
        pq.add(20);
        pq.add(15);
        pq.add(5);

        // Printing elements of the priority queue
        System.out.println("PriorityQueue elements: " + pq);

        // Removing elements from the priority queue
        System.out.println("Removing elements from the priority queue:");
        while (!pq.isEmpty()) {
            System.out.println("Removed: " + pq.poll());
        }
    }
}
```

#### Use Cases:

* **Task Scheduling**: Process tasks based on their priority (e.g., shortest job first in scheduling algorithms).
* **Event Handling**: Handle events or notifications based on urgency or importance.
* **Graph Algorithms**: Implement algorithms like Dijkstra's shortest path algorithm, where nodes are processed in order of their priority.

## **What is the final keyword in Java?**

**Final variable:** Once a variable is declared as final, then the value of the variable could not be changed. It is like a constant.

**Final method:** A final keyword in a method, couldn’t be overridden. If a method is marked as a final, then it can’t be overridden by the subclass.

**Final class:** If a class is declared as final, then the class couldn’t be subclassed. No class can extend the final class.

## What is a Thread? Different ways to create a thread?

In Java, a **thread** refers to the smallest unit of execution within a process. It allows concurrent execution of tasks, enabling programs to perform multiple operations simultaneously. Threads share memory space and resources within the same process, making them lightweight compared to processes.

Every java program has at least one thread called the main thread, the main thread is created by JVM. The user can define their own threads.

### Ways to Create a Thread in Java

There are two main ways to create a thread in Java:

**1. Extending the `Thread` Class**

You can create a thread by extending the `Thread` class and overriding its `run()` method, which contains the code that executes when the thread starts.

**Example:**

```java
// Step 1: Define a class that extends Thread
class MyThread extends Thread {
    // Step 2: Override the run() method
    @Override
    public void run() {
        System.out.println("Thread is running...");
    }
}

// Step 3: Create an instance of the thread and start it
public class ThreadExample {
    public static void main(String[] args) {
        // Step 4: Create and start the thread
        MyThread thread = new MyThread();
        thread.start(); // starts the execution of the thread
    }
}
```

**2. Implementing the `Runnable` Interface**

You can create a thread by implementing the `Runnable` interface and providing an implementation for the `run()` method. This approach separates the thread's behavior from the thread itself, allowing better code organization and reuse.

**Example:**

```java
// Step 1: Define a class that implements Runnable
class MyRunnable implements Runnable {
    // Step 2: Implement the run() method
    @Override
    public void run() {
        System.out.println("Runnable thread is running...");
    }
}

// Step 3: Create an instance of the Runnable and pass it to a Thread
public class RunnableThreadExample {
    public static void main(String[] args) {
        // Step 4: Create a Runnable instance
        MyRunnable myRunnable = new MyRunnable();

        // Step 5: Pass the Runnable instance to a Thread
        Thread thread = new Thread(myRunnable);

        // Step 6: Start the thread
        thread.start(); // starts the execution of the thread
    }
}
```

#### Key Points to Remember:

* Both approaches (`Thread` subclass and `Runnable` interface) achieve the same goal of creating a new thread.
* Implementing `Runnable` is generally preferred over extending `Thread` because it allows better separation of concerns and allows the class to extend another class if needed.
* When a thread's `run()` method completes, the thread terminates unless specified otherwise.

#### Additional Considerations:

*   **Lambda Expression (Java 8 and later)**: You can use lambda expressions to create and start a thread, especially when the thread logic is simple and can be expressed inline.

    Example using lambda expression:

    ```java
    Thread thread = new Thread(() -> {
        System.out.println("Thread using lambda is running...");
    });
    thread.start();
    ```
* **Executor Framework**: Java provides higher-level concurrency utilities such as `ExecutorService` and `ThreadPoolExecutor` from the `java.util.concurrent` package, which manage thread execution more efficiently than creating threads manually.

Threads are fundamental to Java's support for concurrent programming, allowing developers to create applications that can perform tasks concurrently and efficiently utilize available resources.

### Different Thread Methods

In Java, several methods are crucial for thread management and synchronization. Here's an overview of each method you mentioned:

#### 1. `join()`

The `join()` method allows one thread to wait for the completion of another thread. When a thread calls `join()` on another thread, it suspends its execution until the thread it joined completes its execution or a specified timeout occurs.

**Example:**

```java
Thread thread1 = new Thread(() -> {
    System.out.println("Thread 1 is running...");
});

Thread thread2 = new Thread(() -> {
    try {
        thread1.join(); // Wait for thread1 to complete
        System.out.println("Thread 2 is running after thread1 completes...");
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
});

thread1.start();
thread2.start();
```

#### 2. `yield()`

The `yield()` method is a hint to the scheduler that the current thread is willing to yield its current use of the processor. It allows the scheduler to select another thread to run instead of the current thread. However, yielding is not guaranteed to have any effect on thread execution order.

**Example:**

```java
Thread thread1 = new Thread(() -> {
    for (int i = 0; i < 5; i++) {
        System.out.println("Thread 1 is running...");
        Thread.yield(); // Yield to allow other threads to run
    }
});

Thread thread2 = new Thread(() -> {
    for (int i = 0; i < 5; i++) {
        System.out.println("Thread 2 is running...");
        Thread.yield(); // Yield to allow other threads to run
    }
});

thread1.start();
thread2.start();
```

#### 3. `wait()`, `notify()`, `notifyAll()`

These methods are used for inter-thread communication and synchronization using object monitors:

* **`wait()`**: Causes the current thread to wait until another thread invokes the `notify()` or `notifyAll()` method for this object or a specified timeout expires.
* **`notify()`**: Wakes up a single thread that is waiting on this object's monitor. If multiple threads are waiting, one of them is chosen to be awakened.
* **`notifyAll()`**: Wakes up all threads that are waiting on this object's monitor. This method should be used to notify waiting threads if multiple threads may be waiting for the same condition.

**Example:**

```java
class SharedObject {
    synchronized void method1() {
        System.out.println("method1 is executing...");
        try {
            wait(); // Thread waits until notified
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("method1 resumed...");
    }

    synchronized void method2() {
        System.out.println("method2 started...");
        notify(); // Notify one waiting thread
        // notifyAll(); // Notify all waiting threads
    }
}

public class WaitNotifyExample {
    public static void main(String[] args) {
        SharedObject sharedObject = new SharedObject();

        Thread thread1 = new Thread(() -> sharedObject.method1());
        Thread thread2 = new Thread(() -> sharedObject.method2());

        thread1.start();
        thread2.start();
    }
}
```

#### Other Methods

* **`sleep(long milliseconds)`**: Causes the current thread to sleep for the specified number of milliseconds. This method is used for pausing execution.
* **`interrupt()`**: Interrupts the thread, causing it to exit from its waiting or sleeping state, throwing an `InterruptedException` if it's waiting.
* **`isAlive()`**: Checks if the thread is alive (i.e., started and not yet terminated).
* **`setDaemon(boolean on)`**: Marks the thread as either a daemon thread (background thread) or a user thread. Daemon threads are terminated when all user threads have finished executing.

### Different ways to stop or pause a thread

In Java, there are several ways to stop or pause a thread, each suited to different scenarios and requirements. Here are some common methods:

#### 1. `Thread.sleep(long milliseconds)`

The `Thread.sleep()` method pauses the execution of the current thread for the specified number of milliseconds. It can be used to introduce delays or pause execution temporarily.

**Example:**

```java
Thread thread = new Thread(() -> {
    try {
        System.out.println("Thread started...");
        Thread.sleep(2000); // Pause for 2 seconds
        System.out.println("Thread resumed after sleep...");
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
});

thread.start();
```

#### 2. `Thread.yield()`

The `Thread.yield()` method is a hint to the scheduler that the current thread is willing to yield its current use of the processor. It allows the scheduler to select another thread to run instead of the current thread. However, its effectiveness can vary across different JVM implementations.

**Example:**

```java
Thread thread1 = new Thread(() -> {
    for (int i = 0; i < 5; i++) {
        System.out.println("Thread 1 is running...");
        Thread.yield(); // Yield to allow other threads to run
    }
});

Thread thread2 = new Thread(() -> {
    for (int i = 0; i < 5; i++) {
        System.out.println("Thread 2 is running...");
        Thread.yield(); // Yield to allow other threads to run
    }
});

thread1.start();
thread2.start();
```

#### 3. `Thread.interrupt()`

The `Thread.interrupt()` method interrupts a thread that is currently in a waiting, sleeping, or blocking state. It causes the thread to throw an `InterruptedException` or wake up from sleep.

**Example:**

```java
Thread thread = new Thread(() -> {
    try {
        while (!Thread.currentThread().isInterrupted()) {
            System.out.println("Thread is running...");
            Thread.sleep(1000); // Thread continues to run until interrupted
        }
    } catch (InterruptedException e) {
        System.out.println("Thread interrupted...");
    }
});

thread.start();

// Interrupt the thread after 3 seconds
try {
    Thread.sleep(3000);
    thread.interrupt();
} catch (InterruptedException e) {
    e.printStackTrace();
}
```

#### 4. Using a volatile flag or boolean variable

You can use a `volatile` boolean flag or variable to control the execution of a thread. The thread periodically checks the flag and exits or pauses based on its value.

**Example:**

```java
class MyRunnable implements Runnable {
    private volatile boolean flag = true;

    public void stop() {
        flag = false;
    }

    @Override
    public void run() {
        while (flag) {
            System.out.println("Thread is running...");
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        System.out.println("Thread stopped.");
    }
}

public class VolatileFlagExample {
    public static void main(String[] args) {
        MyRunnable myRunnable = new MyRunnable();
        Thread thread = new Thread(myRunnable);
        thread.start();

        // Stop the thread after 5 seconds
        try {
            Thread.sleep(5000);
            myRunnable.stop();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

#### 5. Using `wait()` and `notify()`

For more complex coordination between threads, you can use `wait()` and `notify()` methods for inter-thread communication and synchronization. This allows threads to pause and resume based on specific conditions.

**Example:**

```java
class SharedObject {
    synchronized void method1() {
        System.out.println("method1 is executing...");
        try {
            wait(); // Thread waits until notified
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("method1 resumed...");
    }

    synchronized void method2() {
        System.out.println("method2 started...");
        notify(); // Notify one waiting thread
        // notifyAll(); // Notify all waiting threads
    }
}

public class WaitNotifyExample {
    public static void main(String[] args) {
        SharedObject sharedObject = new SharedObject();

        Thread thread1 = new Thread(() -> sharedObject.method1());
        Thread thread2 = new Thread(() -> sharedObject.method2());

        thread1.start();
        thread2.start();
    }
}
```

### When to use the Runnable interface Vs Thread class?

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><mark style="background-color:red;">Aspect</mark></td><td><mark style="background-color:yellow;"><code>Runnable</code> Interface</mark></td><td><mark style="background-color:green;">Extending <code>Thread</code> Class</mark></td></tr><tr><td><strong>Inheritance</strong></td><td>Does not require extending a specific class</td><td>Requires extending the <code>Thread</code> class</td></tr><tr><td><strong>Flexibility</strong></td><td>Allows the class to extend another class if needed</td><td>Limits the class to only extending <code>Thread</code></td></tr><tr><td><strong>Code Reuse</strong></td><td>Promotes better code organization and reusability</td><td>Limited reuse because the class extends <code>Thread</code>directly</td></tr><tr><td><strong>Separation of Concerns</strong></td><td>Separates thread logic from the thread object itself</td><td>Combines thread logic with the thread object</td></tr><tr><td><strong>Multiple Inheritance</strong></td><td>Allows implementing multiple interfaces</td><td>Does not support multiple inheritance</td></tr><tr><td><strong>Thread Pooling</strong></td><td>Better suited for use with thread pools and executors</td><td>Less flexible with thread pools and executors</td></tr><tr><td><strong>Concurrency</strong></td><td>Encourages better synchronization practices</td><td>Requires careful handling of thread synchronization</td></tr><tr><td><strong>Common Practice</strong></td><td>Preferred approach in modern Java programming</td><td>Older style, still used in certain scenarios</td></tr></tbody></table>



### **Difference between start() and run() method of thread class**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><mark style="background-color:red;">Aspect</mark></td><td><mark style="background-color:yellow;"><code>start()</code> Method</mark></td><td><mark style="background-color:green;"><code>run()</code> Method</mark></td></tr><tr><td><strong>Invocation</strong></td><td>Invoked to start the execution of a new thread</td><td>Contains the actual code to be executed by the thread</td></tr><tr><td><strong>Execution Context</strong></td><td>Executes in a new thread context</td><td>Executes in the current thread context</td></tr><tr><td><strong>Method Signature</strong></td><td><code>public void start()</code></td><td><code>public void run()</code></td></tr><tr><td><strong>Concurrency</strong></td><td>Initiates thread creation and scheduling</td><td>Does not create a new thread; runs in current thread</td></tr><tr><td><strong>Thread Lifecycle</strong></td><td>Starts the thread lifecycle (NEW -> RUNNABLE)</td><td>No effect on thread lifecycle</td></tr><tr><td><strong>Overriding</strong></td><td>Should not be overridden</td><td>Should be overridden to define thread's task</td></tr><tr><td><strong>Calling Sequence</strong></td><td>Called once per thread instance</td><td>Called when <code>start()</code> method is invoked</td></tr><tr><td><strong>Execution Control</strong></td><td>Returns immediately after starting the thread</td><td>Blocks until <code>run()</code> method completes</td></tr><tr><td><strong>Use Case</strong></td><td>Use to initiate concurrent execution</td><td>Contains the task to be executed by the thread</td></tr><tr><td><strong>Example</strong></td><td><code>thread.start();</code></td><td><code>public void run() { /* task implementation */ }</code></td></tr></tbody></table>

### Difference between Multi-threading and Parallel processing?

The terms "multi-threading" and "parallel processing" are related to concurrent execution in computing but refer to distinct concepts:

#### Multi-threading:

* **Definition**: Multi-threading refers to the concurrent execution of multiple threads within the same process.
* **Concurrency**: Threads share the same memory space and resources of the process.
* **Execution**: Threads are managed by the operating system's thread scheduler, which allocates CPU time to each thread.
* **Communication**: Threads within the same process can communicate directly via shared memory.
* **Use Cases**:
  * Enhancing responsiveness in GUI applications by offloading long-running tasks to background threads.
  * Improving performance by overlapping I/O operations with computation.

#### Parallel Processing:

* **Definition**: Parallel processing involves executing multiple tasks simultaneously across multiple processors or cores to achieve faster computations.
* **Concurrency**: Tasks are executed independently and concurrently on different processors.
* **Execution**: Typically involves distributing tasks across multiple CPUs or cores to achieve performance gains.
* **Communication**: Processes in parallel processing may communicate via inter-process communication mechanisms or shared data structures.
* **Use Cases**:
  * Scientific computing and simulations where large datasets are processed concurrently.
  * Big data analytics, where tasks can be divided and processed across multiple nodes in a cluster.

#### Key Differences:

* **Concurrency vs. Parallelism**:
  * **Concurrency** (multi-threading) focuses on managing multiple tasks (threads) that may be executed in overlapping time periods within the same process.
  * **Parallelism** involves simultaneous execution of multiple tasks across different processors or cores, aiming for faster computation.
* **Resource Utilization**:
  * Multi-threading primarily optimizes CPU and I/O resource utilization within a single computing unit (e.g., a single machine or node).
  * Parallel processing utilizes multiple computing units (CPUs/cores) to divide and conquer tasks for higher throughput.
* **Communication Overhead**:
  * Multi-threading benefits from low communication overhead as threads share memory space.
  * Parallel processing across multiple processors or nodes may involve higher communication overhead due to inter-process communication.

#### Example Scenario:

* **Multi-threading**:
  * A web server handling multiple client requests concurrently using threads to manage each request's I/O and computation tasks.
* **Parallel Processing**:
  * A data analytics platform processing vast amounts of data by distributing computation across multiple nodes in a cluster, leveraging parallelism to achieve faster data processing.

### **Explain the thread life cycle in Java.**

The thread life cycle in Java describes the various states a thread transitions through during its execution. Here’s a concise explanation of the thread life cycle stages:

1. **New**:
   * A thread begins its life cycle in the `New` state when an instance of the `Thread` class is created but `start()`method is not yet invoked.
2. **Runnable**:
   * After invoking the `start()` method, the thread moves to the `Runnable` state.
   * In this state, the thread is ready to run, but it may not be currently executing due to CPU scheduling.
3. **Running**:
   * The thread enters the `Running` state when the CPU scheduler selects it to execute.
   * It executes its task within this state until it voluntarily relinquishes CPU control or is preempted by a higher-priority thread.
4. **Blocked/Waiting**:
   * A thread can transition to the `Blocked` or `Waiting` state under certain conditions:
     * **Blocked**: When waiting for a monitor lock to enter a synchronized block or method.
     * **Waiting**: When waiting indefinitely for another thread to perform a specific action, such as calling `wait()` or `join()` methods.
5. **Timed Waiting**:
   * Threads enter the `Timed Waiting` state when they call methods like `sleep()` or `join()` with a timeout parameter.
   * They wait for the specified time period or until another thread notifies them.
6. **Terminated**:
   * A thread completes its task and enters the `Terminated` state.
   * This happens when the `run()` method finishes execution or an unhandled exception terminates the thread.

## What is Synchronization?

**Synchronization** in Java refers to the mechanism that controls access to shared resources or critical sections by multiple threads. It ensures that only one thread can access the shared resource at a time, preventing concurrent access that could lead to data inconsistency or corruption.

#### Advantages of Synchronization:

1. **Thread Safety**: Synchronization ensures that shared resources are accessed in a mutually exclusive manner, preventing data races and maintaining data integrity.
2. **Consistency**: It helps in maintaining consistency among shared data by enforcing a strict order of access, ensuring that changes made by one thread are visible to others.
3. **Prevents Deadlocks**: Properly implemented synchronization techniques can prevent deadlock situations where two or more threads are blocked forever, waiting for each other to release resources.
4. **Coordination**: It facilitates coordination between threads, allowing them to communicate effectively and synchronize their activities based on specific conditions.

#### Disadvantages of Synchronization:

1. **Overhead**: Synchronization introduces overhead due to context switching and acquiring/releasing locks, which can impact performance, especially in highly concurrent applications.
2. **Potential Deadlocks**: Improper use of synchronization primitives can lead to deadlocks, where threads are stuck indefinitely waiting for resources that are held by other threads.
3. **Complexity**: Managing synchronization correctly requires careful attention to detail, as incorrect synchronization can lead to subtle bugs that are hard to detect and debug.
4. **Reduced Parallelism**: Synchronization may limit parallelism in multi-core systems, as threads may need to wait for access to shared resources even when they could otherwise execute independently.

#### Example:

```java
class Counter {
    private int count;

    // Synchronized method ensures atomicity and thread safety
    public synchronized void increment() {
        count++;
    }

    // Non-synchronized method for demonstration
    public void decrement() {
        count--;
    }
}
```

In the example above:

* The `increment()` method is synchronized to ensure that only one thread can execute it at a time, preventing race conditions when modifying `count`.
* The `decrement()` method is not synchronized, which could lead to data corruption if accessed concurrently by multiple threads without proper synchronization.

## What is **Serialization** and **Deserialization?**

**Serialization** and **Deserialization** are processes in Java (and in other programming languages) that involve converting an object into a stream of bytes to store its state persistently or to transmit it over a network, and then reconstructing the object from that stream.

{% hint style="info" %}
Whenever an object is Serialized, the object is stamped with a version ID number for the object class. This ID is called the SerialVersionUID. This is used during deserialization to verify that the sender and receiver that are compatible with the Serialization.
{% endhint %}

#### Serialization:

* **Definition**: Serialization is the process of converting an object into a byte stream so that it can be stored in a file, sent over a network, or persisted in a database.
* **Purpose**:
  * **Persistence**: Save the state of an object for later retrieval.
  * **Communication**: Transmit objects between applications or across a network.
* **Mechanism**:
  * In Java, the `Serializable` interface marks a class as serializable. It is a marker interface without any methods.
  * Objects of a serializable class can be converted into a stream of bytes using `ObjectOutputStream`.
  * Variables that are marked as transient will not be a part of the serialization. So we can skip the serialization for the variables in the file by using a transient keyword.
*   **Example**:

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

#### Deserialization:

* **Definition**: Deserialization is the process of reconstructing an object from a serialized byte stream.
* **Purpose**:
  * Restore the state of an object previously serialized.
  * Receive and reconstruct objects transmitted over a network or read from storage.
* **Mechanism**:
  * In Java, use `ObjectInputStream` to read the serialized byte stream and reconstruct the object.
  * The class of the deserialized object must have the same serialVersionUID as when it was serialized to ensure compatibility.
*   **Example**:

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

## What is Volatile Variable and its purpose?

In Java, a **volatile variable** is a type of variable that ensures visibility and atomicity guarantees when accessed or modified by multiple threads. Its primary purpose is to provide a consistent view of the variable's value across all threads, without the need for synchronization mechanisms like locks or `synchronized` blocks.

#### Purpose of Volatile Variable:

1. **Visibility Guarantee**:
   * When a variable is declared as `volatile`, any write to that variable is immediately visible to other threads. This ensures that changes made by one thread are immediately reflected in other threads.
2. **Atomicity on Writes**:
   * Writing to a `volatile` variable is atomic. This means that operations on the variable are indivisible, and no other thread can observe an intermediate state during a write operation.
3. **Preventing Compiler Optimizations**:
   * Accessing a `volatile` variable prevents the compiler and the JVM from applying certain optimizations that could reorder or cache the variable's access, ensuring the variable's updated value is always read from main memory.

#### When to Use Volatile Variables:

* **Flag Variables**: Use `volatile` for boolean flags or state variables that control the execution of threads across multiple cores or threads.
* **Read-Modify-Write Operations**: When performing read-modify-write operations (e.g., incrementing a counter), using `volatile` ensures atomicity without explicit synchronization.
* **Status Flags**: For variables used to signal state changes across threads, such as status updates or termination signals.

#### Example:

```java
public class SharedResource {
    private volatile boolean flag = false;

    public void setFlag(boolean value) {
        this.flag = value;
    }

    public void doWork() {
        while (!flag) {
            // Perform work while flag is false
        }
        // Exit loop when flag becomes true
    }
}
```

In this example:

* The `flag` variable is declared as `volatile` to ensure that changes made to `flag` in one thread are immediately visible to other threads.
* The `doWork()` method continuously checks the `flag` variable's value without the need for explicit synchronization, relying on the visibility guarantee provided by `volatile`

