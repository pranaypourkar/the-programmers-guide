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

**]**Method overloading happens for different classes or within the same class.

**For method overloading, sub-class method should satisfy the below conditions with the Super-class method (or) methods in the same class itself:**

* Same method name
* Different argument types
* There may be different return types

