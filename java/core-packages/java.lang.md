# java.lang

## About

The `java.lang` package is one of the core packages in Java and is automatically imported into every Java program. It contains classes that are fundamental to the Java programming language, including basic types, system utilities, and fundamental classes that are essential for Java programming.

## Key Classes and Interfaces in `java.lang`

Here are some of the most important classes and interfaces provided by the `java.lang` package:

### **Object**:

* The root class of the Java class hierarchy. Every class has `Object` as a superclass. Provides basic methods such as `equals()`, `hashCode()`, `toString()`, `clone()`, `wait()`, `notify()`, and `notifyAll()`.

### **Class**:

* Instances of the `Class` class represent classes and interfaces in a running Java application. Provides methods to get metadata about a class, such as its name, fields, methods, constructors, and more.

### **System**:

* Provides several useful class fields and methods. It cannot be instantiated. Key functionalities include system properties, standard input/output streams, array copying, garbage collection, and current time retrieval.

### **String**:

* Represents a sequence of characters. Strings are immutable, meaning their values cannot be changed once created. Provides various methods for manipulating strings, such as concatenation, substring, and pattern matching.

### **StringBuilder** and **StringBuffer**:

* Mutable sequences of characters. `StringBuilder` is not synchronized, making it faster, but not thread-safe. `StringBuffer` is synchronized, making it thread-safe.

### **Math**:

* Provides methods for performing basic numeric operations such as exponentiation, logarithms, square roots, and trigonometric functions.

### **Integer, Long, Float, Double, Byte, Short, Character, Boolean**:

* Wrapper classes for primitive types. These classes provide methods for converting between types, parsing strings, and performing various utility functions.

### **Thread**:

* Represents a thread of execution in a program. Provides methods to manage and control thread behavior.

### **Runnable**:

* The `Runnable` interface should be implemented by any class whose instances are intended to be executed by a thread. The class must define a method of no arguments called `run`.

### **Exception** and **RuntimeException**:

* The `Exception` class and its subclasses are a form of `Throwable` that indicates conditions that a reasonable application might want to catch.
* `RuntimeException` is the superclass of those exceptions that can be thrown during the normal operation of the Java Virtual Machine.

### **Error**:

* A subclass of `Throwable` that indicates serious problems that a reasonable application should not try to catch. Most such errors are abnormal conditions.

## Key Interfaces in `java.lang`

### **CharSequence**:

* A readable sequence of `char` values. This interface is implemented by `String`, `StringBuilder`, `StringBuffer`, etc.

### **Comparable**:

* This interface imposes a total ordering on the objects of each class that implements it. This ordering is referred to as the class's natural ordering, and the class's `compareTo` method is referred to as its natural comparison method.

### **Cloneable**:

* A marker interface indicating that a class allows its instances to be cloned. The `Object` class provides a `clone` method if a class implements this interface.

### **Iterable**:

* Implementing this interface allows an object to be the target of the "foreach" statement. The only method in this interface is the `iterator()` method, which returns an `Iterator`.
