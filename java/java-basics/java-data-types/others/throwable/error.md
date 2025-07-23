# Error

## **About**

The `Error` class in Java represents critical issues or severe problems that an application typically cannot handle. These issues indicate serious conditions, usually related to the JVM environment, such as memory exhaustion or hardware failures. Since `Error` is a subclass of `Throwable`, it inherits methods for debugging and handling exceptions but is not intended for application-level exception handling.

## **Features**

1. **Critical JVM Issues**: Represents conditions like `OutOfMemoryError`, `StackOverflowError`, and `LinkageError` that arise due to the JVM's inability to continue normal execution.
2. **Unchecked**: Errors are unchecked, meaning they do not need to be declared in a method's `throws` clause.
3. **Not Recoverable**: Errors indicate problems that the program cannot recover from, so catching them is generally discouraged.
4. **Part of Throwable Hierarchy**: Extends `Throwable` and shares methods like `getMessage()`, `printStackTrace()`, and `getCause()`.

## **Internal Working**

1. **Stack Trace Capture**: Like exceptions, errors capture the stack trace at the time of instantiation, enabling debugging.
2. **JVM Triggering**: Errors are often thrown by the JVM itself when it encounters a condition it cannot resolve.
3. **Propagation**: Errors propagate up the call stack until they are caught (if at all) or the application terminates.
4. **Custom Errors**: Although possible, defining custom errors is rare and generally discouraged.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="389"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>getMessage()</code></td><td>Returns the detail message string of this <code>Error</code>.</td></tr><tr><td><code>getCause()</code></td><td>Returns the cause of this <code>Error</code> or <code>null</code> if no cause is set.</td></tr><tr><td><code>printStackTrace()</code></td><td>Prints the stack trace to the standard error stream.</td></tr><tr><td><code>getStackTrace()</code></td><td>Returns an array of <code>StackTraceElement</code> objects representing the current stack trace.</td></tr><tr><td><code>initCause(Throwable cause)</code></td><td>Sets the cause of this <code>Error</code>.</td></tr><tr><td><code>addSuppressed(Throwable exception)</code></td><td>Adds a suppressed exception for this <code>Error</code>.</td></tr><tr><td><code>getSuppressed()</code></td><td>Returns an array of suppressed exceptions associated with this <code>Error</code>.</td></tr></tbody></table>

## **Big(O) for Operations**

* **Creation**: Capturing the stack trace is **O(n)**, where _n_ is the depth of the stack.
* **Retrieving Stack Trace**: Accessing the stack trace is **O(n)**.
* **Propagation**: Linear with the stack depth, **O(n)**.

## **Common Subclasses**

<table data-header-hidden data-full-width="true"><thead><tr><th width="279"></th><th></th></tr></thead><tbody><tr><td><strong>Subclass</strong></td><td><strong>Description</strong></td></tr><tr><td><code>OutOfMemoryError</code></td><td>Thrown when the JVM cannot allocate memory.</td></tr><tr><td><code>StackOverflowError</code></td><td>Thrown when the stack exceeds its limit, often due to deep or infinite recursion.</td></tr><tr><td><code>NoClassDefFoundError</code></td><td>Thrown when a class definition cannot be found at runtime.</td></tr><tr><td><code>LinkageError</code></td><td>Thrown when a class has issues during linkage, such as incompatible changes in the class definition.</td></tr><tr><td><code>VirtualMachineError</code></td><td>Represents errors specific to the JVM, like <code>InternalError</code> and <code>UnknownError</code>.</td></tr></tbody></table>

## **Limitations**

1. **Not for Application Logic**: Errors are not intended to be caught or handled in the application logic.
2. **Program Termination**: Once an error occurs, the program is often in an unstable state, making recovery difficult or unsafe.
3. **Custom Errors Are Discouraged**: Creating custom subclasses of `Error` is rare and not recommended.

## **Real-World Usage**

1. **JVM-Level Issues**: Errors are generally used internally by the JVM to indicate severe, unrecoverable conditions.
2. **Logging and Monitoring**: Used in frameworks and monitoring tools to log critical issues for post-mortem debugging.
3. **Testing Edge Cases**: Simulating errors like `OutOfMemoryError` for stress testing applications.

## **Examples**

### **1. Basic Error Handling**

```java
public class ErrorExample {
    public static void main(String[] args) {
        try {
            throw new Error("Critical Error!");
        } catch (Error e) {
            System.out.println("Caught Error: " + e.getMessage()); // Output: Caught Error: Critical Error!
        }
    }
}
```

### **2. StackOverflowError**

```java
public class ErrorExample {
    public static void recursiveMethod() {
        recursiveMethod(); // Infinite recursion
    }

    public static void main(String[] args) {
        try {
            recursiveMethod();
        } catch (StackOverflowError e) {
            System.out.println("Caught StackOverflowError: " + e); // Output: Caught StackOverflowError: java.lang.StackOverflowError
        }
    }
}
```

### **3. OutOfMemoryError**

```java
import java.util.ArrayList;
import java.util.List;

public class ErrorExample {
    public static void main(String[] args) {
        try {
            List<Object> list = new ArrayList<>();
            while (true) {
                list.add(new int[1000000]); // Allocating large arrays
            }
        } catch (OutOfMemoryError e) {
            System.out.println("Caught OutOfMemoryError: " + e); // Output: Caught OutOfMemoryError: java.lang.OutOfMemoryError: Java heap space
        }
    }
}
```

### **4. NoClassDefFoundError**

```java
public class ErrorExample {
    public static void main(String[] args) {
        try {
            Class.forName("NonExistentClass");
        } catch (ClassNotFoundException e) {
            System.out.println("Caught ClassNotFoundException: " + e);
        } catch (NoClassDefFoundError e) {
            System.out.println("Caught NoClassDefFoundError: " + e);
        }
    }
}
```



