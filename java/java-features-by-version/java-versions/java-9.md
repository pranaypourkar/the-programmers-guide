# Java 9

## About

Java 9 introduced several significant features, primarily focusing on modularity, performance improvements, and API enhancements.

## **1. Java Platform Module System (JPMS) (Project Jigsaw)**

Java 9 introduced the **Module System**, which allows developers to create modular applications by grouping related classes and packages.

**Example:**

**Step 1: Create a module descriptor file (`module-info.java`)**

```java
module com.example.app {
    exports com.example.utils;
}
```

**Step 2: Define a package inside the module**

```java
package com.example.utils;

public class Greeting {
    public static void hello() {
        System.out.println("Hello from a module!");
    }
}
```

**Step 3: Use the module in another module**

```java
module com.example.main {
    requires com.example.app;
}
```

This helps **avoid classpath issues** and enables **strong encapsulation**.

## **2. JShell (REPL)**

JShell is an interactive command-line tool that allows developers to execute Java code **without writing an entire class or method**.

**Example (Inside JShell Terminal)**

```sh
$ jshell
jshell> int x = 10
x ==> 10

jshell> System.out.println("Hello, Java 9!")
Hello, Java 9!
```

JShell improves learning and testing capabilities without requiring a full Java program.

## **3. Private Methods in Interfaces**

Java 9 allows private methods inside interfaces, reducing code duplication in default and static methods.

**Example:**

```java
interface Logger {
    default void logInfo(String message) {
        log("INFO: " + message);
    }

    default void logError(String message) {
        log("ERROR: " + message);
    }

    // Private method
    private void log(String message) {
        System.out.println(message);
    }
}

public class LoggerExample implements Logger {
    public static void main(String[] args) {
        LoggerExample logger = new LoggerExample();
        logger.logInfo("Application started");
        logger.logError("Something went wrong!");
    }
}
```

## **4. HTTP/2 Client (Improved HTTP API)**

Java 9 introduced a new HTTP Client API to handle HTTP requests efficiently.

**Example:**

```java
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

public class HttpClientExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://jsonplaceholder.typicode.com/posts/1"))
                .GET()
                .build();
        
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println(response.body());
    }
}
```

## **5. Improved Stream API**

Java 9 added new methods in the **Stream API** to improve functional programming.

**New Methods:**

* `takeWhile()` - Takes elements while a condition holds true.
* `dropWhile()` - Drops elements while a condition holds true.
* `ofNullable()` - Creates a stream of a single element or an empty stream.

**Example:**

```java
import java.util.List;
import java.util.stream.Stream;

public class StreamEnhancements {
    public static void main(String[] args) {
        List<Integer> numbers = List.of(1, 2, 3, 4, 5, 6, 7);

        // takeWhile example
        numbers.stream().takeWhile(n -> n < 5).forEach(System.out::println);

        // dropWhile example
        numbers.stream().dropWhile(n -> n < 5).forEach(System.out::println);

        // ofNullable example
        Stream.ofNullable(null).forEach(System.out::println); // No output (empty stream)
    }
}
```

## **6. Factory Methods for Collections**

Java 9 introduced immutable factory methods for creating collections. The methods `List.of()`, `Set.of()`, and `Map.of()` in Java 9 return immutable collections, meaning their contents cannot be modified after creation.

#### **Example:**

```java
import java.util.List;
import java.util.Map;
import java.util.Set;

public class FactoryMethodsExample {
    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob", "Charlie");
        Set<Integer> numbers = Set.of(1, 2, 3);
        Map<Integer, String> map = Map.of(1, "One", 2, "Two", 3, "Three");
        
        // Trying to add a new element
        names.add("David"); // Throws UnsupportedOperationException

        // Trying to remove an element
        numbers.remove(1); // Throws UnsupportedOperationException

        // Trying to update a key-value pair
        map.put(4, "Four"); // Throws UnsupportedOperationException

        System.out.println(names);
        System.out.println(numbers);
        System.out.println(map);
    }
}
```

These methods return **immutable collections**, meaning elements cannot be modified.

## **7. Try-With-Resources Enhancement**

Java 9 improved try-with-resources by allowing resources to be declared outside the `try` block.

**Example:**

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class TryWithResourcesExample {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader("test.txt"));
        
        try (reader) { // No need to redeclare reader
            System.out.println(reader.readLine());
        }
    }
}
```

## **8. Process API Enhancements**

Java 9 introduced new methods in the `Process` API to **manage and monitor system processes**.

**Example:**

```java
import java.io.IOException;
import java.util.Optional;

public class ProcessAPIExample {
    public static void main(String[] args) throws IOException {
        Process process = new ProcessBuilder("notepad.exe").start();

        System.out.println("PID: " + process.pid());
        System.out.println("Alive: " + process.isAlive());
        
        Optional<ProcessHandle> parent = process.toHandle().parent();
        parent.ifPresent(handle -> System.out.println("Parent PID: " + handle.pid()));
    }
}
```

## **9. Multi-Release JAR Files**

Java 9 allows a JAR to include **different versions of classes for different Java versions**.

#### **Example Directory Structure:**

```
/META-INF/versions/9/com/example/MyClass.class  (Java 9 version)
/com/example/MyClass.class  (Java 8 version)
```

At runtime, Java 9 will **automatically pick the correct version**.

## **10. Improved `Optional` API**

Java 9 enhanced `Optional` with new methods like `ifPresentOrElse()`.

**Example:**

```java
import java.util.Optional;

public class OptionalEnhancements {
    public static void main(String[] args) {
        Optional<String> optional = Optional.ofNullable(null);

        optional.ifPresentOrElse(
            value -> System.out.println("Value: " + value),
            () -> System.out.println("No value present")
        );
    }
}
```

## **11. Unified JVM Logging**

Java 9 introduced **a new logging framework** for the JVM with a unified format.

**Example Command:**

```sh
java -Xlog:gc test.jar
```

This improves **JVM performance monitoring and debugging**.

## **12. Compact Strings**

Java 9 introduced **Compact Strings** to optimize memory by using **byte arrays instead of char arrays** for String storage, reducing memory usage for **Latin-1 encoded characters**.
