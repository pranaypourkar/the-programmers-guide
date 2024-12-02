# Variables

## About

A **variable** in Java is a named memory location that holds a value. It acts as a container for data that can be used and manipulated during program execution. Variables have the following attributes:

* **Type**: Determines the kind of data the variable can hold (e.g., `int`, `String`).
* **Name**: The identifier used to reference the variable.
* **Value**: The actual data stored in the variable.

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

1. **Local Variables**: Declared within a method or block and accessible only within it.

```java
void method() {
    int localVar = 10;  // Local variable
}
```

2. **Instance Variables**: Declared within a class but outside any method, and belong to an object.

```java
class Example {
    int instanceVar = 5;  // Instance variable
}
```

3. **Static Variables**: Declared with the `static` keyword and shared across all instances of the class.

```java
static int staticVar = 100;  // Static variable
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

```
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

* When you access a variable, the JVM uses the memory address (stored in metadata) to fetch its value.
* For local variables, the JVM looks up the stack frame of the current method.
* For instance variables, the JVM fetches the value from the heap memory associated with the object.

### **5. Garbage Collection**:

* Unused variables (e.g., objects) in the heap are eventually cleaned up by the JVM's **garbage collector** to free memory.

