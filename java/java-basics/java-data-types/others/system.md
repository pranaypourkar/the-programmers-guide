# System

## **About**

The `System` class in Java, part of the `java.lang` package, provides access to various system-level resources and functionalities. It is a utility class that offers methods for input, output, and other system-related tasks like working with properties, environment variables, and performing garbage collection. The class cannot be instantiated because it has a private constructor.

The `System` class is commonly used for tasks such as getting the current time, accessing environment variables, reading from standard input, writing to standard output, and controlling the system's exit process.

## **Features**

1. **Utility Methods**: Provides utility methods for handling standard input/output and other system properties.
2. **System Properties**: Accesses system properties like file paths, user details, and Java environment variables.
3. **Environment Variables**: Allows access to environment variables set in the operating system.
4. **Time Measurement**: Provides methods like `currentTimeMillis()` and `nanoTime()` for measuring time intervals.
5. **Garbage Collection**: Offers methods to suggest the JVM to perform garbage collection.
6. **I/O Streams**: Provides access to standard input, output, and error streams (`System.in`, `System.out`, `System.err`).
7. **Security Management**: Allows interaction with the security manager in Java to control permissions and access to system resources.

## **Internal Working**

The `System` class is designed to interact with the Java runtime environment and the underlying operating system. Here's an overview of its internal workings:

1. **Private Constructor**:
   * The `System` class has a private constructor, preventing instantiation. This enforces that its utility methods are used statically.
2. **System Properties**:
   * System properties are key-value pairs that describe the environment in which the Java application is running. The `System` class provides methods like `getProperty()` and `setProperty()` to manage these properties.
   * These properties can represent various details such as file paths (`user.dir`), OS name (`os.name`), Java version (`java.version`), etc.
3. **I/O Streams**:
   * The class provides access to standard input (`System.in`), output (`System.out`), and error (`System.err`) streams, which are used to read from and write to the console.
4. **Environment Variables**:
   * Environment variables are values provided by the operating system. The `System` class exposes methods like `getenv()` to access environment variables, allowing Java programs to interact with the system environment.
5. **Time Methods**:
   * `System.currentTimeMillis()` provides the current time in milliseconds since the Unix epoch (January 1, 1970).
   * `System.nanoTime()` returns the current value of the most precise available system timer in nanoseconds. This is useful for measuring elapsed time.
6. **Exit and Security**:
   * The `System.exit()` method allows you to terminate the JVM with a specified exit status. A non-zero exit code typically indicates an error.
   * `System.setSecurityManager()` allows setting a custom security manager to manage security policies for the running application.
7. **GC Control**:
   * The `System.gc()` method suggests that the JVM should perform garbage collection. However, it is not guaranteed that the garbage collection will occur immediately.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="374"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong><code>currentTimeMillis()</code></strong></td><td>Returns the current time in milliseconds since January 1, 1970 (the Unix epoch).</td></tr><tr><td><strong><code>nanoTime()</code></strong></td><td>Returns the current value of the most precise available system timer in nanoseconds. Useful for measuring elapsed time.</td></tr><tr><td><strong><code>exit(int status)</code></strong></td><td>Exits the Java application. A non-zero status code generally indicates an abnormal termination.</td></tr><tr><td><strong><code>getProperty(String key)</code></strong></td><td>Retrieves the value of a system property specified by the key.</td></tr><tr><td><strong><code>setProperty(String key, String value)</code></strong></td><td>Sets the system property with the specified key and value.</td></tr><tr><td><strong><code>getenv()</code></strong></td><td>Retrieves environment variables as a map of key-value pairs.</td></tr><tr><td><strong><code>getenv(String name)</code></strong></td><td>Retrieves a specific environment variable by name.</td></tr><tr><td><strong><code>lineSeparator()</code></strong></td><td>Returns the system's line separator ( for UNIX, <code>\r</code> for Windows).</td></tr><tr><td><strong><code>arraycopy(Object src, int srcPos, Object dest, int destPos, int length)</code></strong></td><td>Copies an array from the source to the destination array.</td></tr><tr><td><strong><code>setSecurityManager(SecurityManager sm)</code></strong></td><td>Sets the security manager for the Java runtime environment.</td></tr><tr><td><strong><code>gc()</code></strong></td><td>Suggests that the JVM performs garbage collection (not guaranteed).</td></tr><tr><td><strong><code>in</code></strong></td><td>The standard input stream (System.in) for reading data from the console.</td></tr><tr><td><strong><code>out</code></strong></td><td>The standard output stream (System.out) for printing data to the console.</td></tr><tr><td><strong><code>err</code></strong></td><td>The standard error stream (System.err) for printing error messages to the console.</td></tr></tbody></table>

## **Limitations**

1. **No Instantiation**: The `System` class cannot be instantiated due to its private constructor.
2. **Platform Dependent**: Some of the functionality provided by the `System` class is dependent on the underlying operating system, like environment variables and file path structures.
3. **No Direct Access to Hardware**: While the `System` class can interact with the OS, it does not provide direct access to hardware components like CPU or memory in a detailed manner. For such functionality, you would need to use Java libraries or native code.
4. **Unreliable `System.gc()`**: The `System.gc()` method is merely a suggestion to the JVM to run garbage collection, and it does not guarantee that GC will occur.
5. **Security**: The `System` class has access to the environment, which could lead to security concerns if misused, especially with methods like `setSecurityManager()`.

## **Real-World Usage**

1. **Measuring Execution Time**: The `System.nanoTime()` and `System.currentTimeMillis()` methods are commonly used in performance benchmarking to measure elapsed time between operations.
2. **Accessing Environment Variables**: The `System.getenv()` and `System.getProperty()` methods are used to fetch environment variables and system properties, which are helpful for configuration management, such as reading Java version or system-specific settings.
3. **Program Termination**: The `System.exit()` method is used in cases where a program needs to be terminated with a specific exit status, often in command-line tools or when handling fatal errors.
4. **Standard I/O Operations**: The `System.out` and `System.err` streams are widely used for printing messages to the console. `System.in` is used for reading user input in command-line applications.
5. **Managing Line Separator**: The `System.lineSeparator()` is useful for generating platform-independent line breaks in text files, making Java programs more portable across different operating systems.

## **Examples**

### **1. Measuring Elapsed Time Using `nanoTime()`**

```java
public class SystemExample {
    public static void main(String[] args) {
        long startTime = System.nanoTime(); // Start time
        
        // Some code whose execution time we want to measure
        for (int i = 0; i < 1000000; i++) {
            // Some operation
        }

        long endTime = System.nanoTime(); // End time
        long duration = endTime - startTime; // Elapsed time in nanoseconds
        System.out.println("Execution time: " + duration + " nanoseconds");
    }
}
```

### **2. Accessing System Properties**

```java
public class SystemExample {
    public static void main(String[] args) {
        String javaVersion = System.getProperty("java.version");
        String osName = System.getProperty("os.name");
        
        System.out.println("Java Version: " + javaVersion); // Output: Java Version: 17.0.2 (depends on the installed version)
        System.out.println("Operating System: " + osName); // Output: Operating System: Windows 10 (depends on the OS)
    }
}
```

### **3. Using `System.exit()`**

```java
public class SystemExample {
    public static void main(String[] args) {
        System.out.println("Program started");
        
        // Simulating a fatal error
        System.exit(1); // Exits with status code 1
        
        System.out.println("This will not be printed"); // This line will never be reached
    }
}
```

### **4. Reading Environment Variables**

```java
public class SystemExample {
    public static void main(String[] args) {
        String javaHome = System.getenv("JAVA_HOME");
        System.out.println("JAVA_HOME: " + javaHome); // Output: JAVA_HOME: C:\Program Files\Java\jdk-17 (depends on your system setup)
    }
}
```

### **5. Accessing Standard Input, Output, and Error**

```java
import java.util.Scanner;

public class SystemExample {
    public static void main(String[] args) {
        // Read user input
        System.out.print("Enter your name: ");
        Scanner scanner = new Scanner(System.in);
        String name = scanner.nextLine();
        
        // Print output to console
        System.out.println("Hello, " + name); // Output: Hello, [user input]
        
        // Print an error message to the console
        System.err.println("This is an error message!"); // Output: This is an error message! (printed to the error stream)
    }
}
```

