# Throwable

## **About**

The `Throwable` class in Java is the superclass for all errors and exceptions in the Java language. It provides the foundation for defining and handling conditions that disrupt the normal flow of execution in a program. Both checked and unchecked exceptions, as well as errors, derive from this class.

## **Features**

1. **Superclass for Exceptions and Errors**: `Throwable` is the parent class for `Exception` and `Error`.
2. **Supports Stack Traces**: Captures the stack trace at the time of creation, aiding debugging.
3. **Checked vs Unchecked**: Exceptions derived from `Exception` (excluding `RuntimeException`) are checked, while those derived from `RuntimeException` or `Error` are unchecked.
4. **Serializable**: Implements `Serializable` interface to allow instances to be serialized.
5. **Custom Exceptions**: Developers can define custom exceptions by extending `Throwable` or its subclasses.

## **Internal Working**

1. **Stack Trace Capture**: When a `Throwable` is instantiated, the JVM captures the current execution stack trace, which can later be accessed via `getStackTrace()` or printed using `printStackTrace()`.
2. **Message Handling**: The optional detail message passed to the constructor is stored and can be retrieved using `getMessage()`.
3. **Cause and Chaining**:
   * Supports exception chaining, where one `Throwable` can be the cause of another. This is implemented using:
     * `Throwable(Throwable cause)`
     * `Throwable(String message, Throwable cause)`
   * The cause can be retrieved using `getCause()`.
4. **Propagation**: `Throwable` objects are propagated up the call stack until caught by a `catch` block or terminate the program if uncaught.
5. **Native Code Interaction**: The `Throwable` class interacts with the JVM's native code to handle stack traces and error reporting.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="346"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><code>getMessage()</code></td><td>Returns the detail message string of this <code>Throwable</code>.</td></tr><tr><td><code>getLocalizedMessage()</code></td><td>Returns a localized version of the detail message.</td></tr><tr><td><code>getCause()</code></td><td>Returns the cause of this <code>Throwable</code> or <code>null</code> if no cause was set.</td></tr><tr><td><code>initCause(Throwable cause)</code></td><td>Initializes the cause of this <code>Throwable</code>. Throws an <code>IllegalStateException</code> if the cause is already set.</td></tr><tr><td><code>printStackTrace()</code></td><td>Prints the stack trace to the standard error stream.</td></tr><tr><td><code>getStackTrace()</code></td><td>Returns an array of <code>StackTraceElement</code> objects representing the current stack trace.</td></tr><tr><td><code>setStackTrace(StackTraceElement[])</code></td><td>Modifies the stack trace associated with this <code>Throwable</code>.</td></tr><tr><td><code>addSuppressed(Throwable exception)</code></td><td>Adds a suppressed exception for this <code>Throwable</code>.</td></tr><tr><td><code>getSuppressed()</code></td><td>Returns an array of exceptions that were suppressed.</td></tr></tbody></table>

## **Big(O) for Operations**

* **Creation**: Capturing the stack trace is dependent on the depth of the stack, typically **O(n)**, where _n_ is the stack depth.
* **Retrieving Stack Trace**: Accessing the stack trace is **O(n)**.
* **Chaining Causes**: Constant time **O(1)** for adding or getting causes.
* **Printing Stack Trace**: Dependent on the stack size, usually **O(n)**.

## **Limitations**

1. **Performance Overhead**: Capturing and printing stack traces can be computationally expensive.
2. **Error Handling Complexity**: Overuse of checked exceptions can lead to verbose and difficult-to-maintain code.
3. **Suppression Limitations**: Suppressed exceptions are often overlooked unless explicitly retrieved.
4. **Not Suitable for Control Flow**: Using exceptions for control flow is discouraged due to performance and readability concerns.

## **Real-World Usage**

1. **Custom Exceptions**: Define application-specific exceptions for better error reporting.
2. **Logging and Debugging**: Capturing stack traces for logging or debugging in production environments.
3. **Exception Chaining**: Linking exceptions to trace back to the root cause in layered architectures.

## **Examples**

### **1. Basic Usage**

```java
public class ThrowableExample {
    public static void main(String[] args) {
        try {
            throw new Throwable("Something went wrong!");
        } catch (Throwable t) {
            System.out.println("Caught Throwable: " + t.getMessage()); // Output: Caught Throwable: Something went wrong!
        }
    }
}
```

### **2. Exception Chaining**

```java
public class ThrowableExample {
    public static void main(String[] args) {
        try {
            try {
                throw new NullPointerException("Null pointer encountered!");
            } catch (NullPointerException e) {
                throw new Exception("Higher-level exception", e);
            }
        } catch (Exception e) {
            System.out.println("Caught Exception: " + e.getMessage()); // Output: Caught Exception: Higher-level exception
            System.out.println("Cause: " + e.getCause()); // Output: Cause: java.lang.NullPointerException: Null pointer encountered!
        }
    }
}
```

### **3. Suppressed Exceptions**

```java
public class ThrowableExample {
    public static void main(String[] args) {
        try (AutoCloseable resource1 = () -> {
                throw new Exception("Resource1 failed to close!");
            };
             AutoCloseable resource2 = () -> {
                throw new Exception("Resource2 failed to close!");
            }) {
            throw new Exception("Main block exception!");
        } catch (Exception e) {
            System.out.println("Main exception: " + e.getMessage()); // Output: Main exception: Main block exception!
            for (Throwable suppressed : e.getSuppressed()) {
                System.out.println("Suppressed: " + suppressed.getMessage());
                // Output: Suppressed: Resource1 failed to close!
                // Output: Suppressed: Resource2 failed to close!
            }
        }
    }
}
```

### **4. Custom Exception**

```java
class MyCustomException extends Throwable {
    public MyCustomException(String message) {
        super(message);
    }
}

public class ThrowableExample {
    public static void main(String[] args) {
        try {
            throw new MyCustomException("Custom exception occurred!");
        } catch (MyCustomException e) {
            System.out.println("Caught: " + e.getMessage()); // Output: Caught: Custom exception occurred!
        }
    }
}
```

