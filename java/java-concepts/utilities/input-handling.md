# Input from User

## About

In Java, there are several ways to take input from the user. Here are some common methods.

## **Using `Scanner` Class**

### About

The `Scanner` class is a standard class in Java used for taking input from the user. It's part of the `java.util` package.

* Supports reading input from various sources, including:
  * `System.in` (keyboard/console input)
  * Files (`File` object)
  * Strings (`String` object)
* Provides methods to parse primitive data types (`int`, `double`, etc.) and strings.
* `Scanner` class in Java is **not thread-safe**. It is not synchronized, which means that if multiple threads access a `Scanner` instance concurrently, and at least one thread modifies it (e.g., advances the scanner's position or modifies its delimiter), it can lead to undefined behavior.

{% hint style="info" %}
**How to Use Scanner Safely in Multithreaded Applications?**

**Synchronize External Access**: Wrap the `Scanner` usage in a synchronized block or method to prevent concurrent access:

```
synchronized(scanner) {
    String line = scanner.nextLine();
}
```

**Thread-Local Scanner Instances**: Use a separate `Scanner` instance for each thread to avoid shared state:

```
ThreadLocal<Scanner> threadLocalScanner = ThreadLocal.withInitial(() -> new Scanner(System.in));
```
{% endhint %}

### Example

```java
// Reading from Console
Scanner scanner = new Scanner(System.in);

// Reading from a File
import java.io.File;
import java.io.FileNotFoundException;

File file = new File("example.txt");
Scanner scanner = new Scanner(file);

// Reading from a String
String data = "123 apple 45.67";
Scanner scanner = new Scanner(data);
```

<pre class="language-java"><code class="lang-java">// Basic Input Reading
String input = scanner.nextLine(); // Reads entire line
String word = scanner.next();     // Reads a single word/token
int number = scanner.nextInt();   // Reads an integer
double value = scanner.nextDouble(); // Reads a double
long value = scanner.nextLong(); // Reads a long
boolean flag = scanner.nextBoolean(); // Reads a boolean

// Token Delimiters. The default delimiter is whitespace. To change the delimiter
scanner.useDelimiter(","); // Now tokens are separated by commas

// Checking for Input
// hasNext(): Checks if there's another token.
// hasNextInt(), hasNextDouble(), etc.: Checks for specific data types.
if (scanner.hasNextInt()) {
    int value = scanner.nextInt();
}

<strong>// Skipping Input
</strong>// skip(String pattern): Skips a specific pattern.
// nextLine(): Advances to the next line.

// Exception Handling
// Handling Input Mismatch
try {
    int number = scanner.nextInt();
} catch (InputMismatchException e) {
    System.out.println("Please enter a valid number.");
}

// FileNotFoundException
try {
    Scanner fileScanner = new Scanner(new File("file.txt"));
} catch (FileNotFoundException e) {
    System.out.println("File not found.");
}

<strong>// Closing the Scanner
</strong>// Always close the scanner to release system resources:
scanner.close();
</code></pre>

```java
package src.main.java;

import java.util.Scanner;

public class Application {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your name: ");
        String name = scanner.nextLine();
        System.out.println("Hello, " + name + "!");
        scanner.close();
    }
}
```

<figure><img src="../../../.gitbook/assets/image (273).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Among all the methods mentioned here, using the `Scanner` class is probably the most commonly used method for taking input from the user in Java, especially for beginner-level programming and simple console-based applications.
{% endhint %}

### **Limitations of Scanner**

* Not suitable for reading large files efficiently.
* Limited control over complex parsing; use libraries like **Apache Commons CSV** or **Jackson** for structured data.

## **Using `BufferedReader` Class**

### About

The `BufferedReader` class, along with `InputStreamReader`, can be used to read input from the user. This method is useful when dealing with input streams. It's part of the `java.io` package. It is especially useful when working with large input data as it buffers the data to improve reading performance.

* Reads data in chunks to minimize I/O operations.
* Works well for reading text files or console input.
* Can read data line by line or character by character.
* Supports marking and resetting, which allows re-reading portions of the input stream.

### Example

```java
// Importing BufferedReader
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

// Creating a BufferedReader Instance
// Reading from a File
BufferedReader reader = new BufferedReader(new FileReader("file.txt"));

// Reading from Console
// Using InputStreamReader to wrap System.in
BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

// Reading Data
// readLine(): Reads an entire line of text, returning null at the end of the file.
String line = reader.readLine();

// read(): Reads a single character and returns it as an integer (-1 indicates end of stream).
int charData = reader.read();

// Marking and Resetting
// mark(int readAheadLimit): Marks the current position in the stream.
// reset(): Resets the stream to the most recent mark.
// ready(): Checks if the stream is ready to be read.
reader.mark(100); // Marks the current position
String data = reader.readLine();
reader.reset();   // Resets to the marked position

// Skipping Characters
// skip(long n): Skips n characters in the stream.
reader.skip(5); 
```



```java
package src.main.java;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Application {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter your age: ");
        int age = Integer.parseInt(reader.readLine());
        System.out.println("Your age is: " + age);
        reader.close();
    }
}
```

<figure><img src="../../../.gitbook/assets/image (274).png" alt=""><figcaption></figcaption></figure>

```java
// Reading a File Line by Line
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ReadFileExample {
    public static void main(String[] args) {
        try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Counting Lines in a File
int lineCount = 0;
while (reader.readLine() != null) {
    lineCount++;
}

// Console Input
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class ConsoleInputExample {
    public static void main(String[] args) {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in))) {
            System.out.println("Enter your name:");
            String name = reader.readLine();
            System.out.println("Hello, " + name + "!");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

// Handling Exceptions
try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
// Read data
} catch (IOException e) {
    System.out.println("An error occurred: " + e.getMessage());
}

// Reading a config.txt file
BufferedReader configReader = new BufferedReader(new FileReader("config.txt"));
String config;
while ((config = configReader.readLine()) != null) {
    System.out.println(config);
}
```

### **Best Practices**

1.  **Always Close Resources**: Use a `try-with-resources` block to automatically close the `BufferedReader`:

    ```java
    try (BufferedReader reader = new BufferedReader(new FileReader("file.txt"))) {
        // Read data
    }
    ```
2. **Buffer Size**: Use the default buffer size unless specific performance tuning is required.
3. **Avoid Mixing with Scanner**: Avoid mixing `BufferedReader` and `Scanner` in the same program for reading input to prevent unexpected behavior.
4. **Check `readLine()` for Null**: Always check for `null` to handle the end of the stream gracefully.

## **Using Command Line Arguments**

We can also pass input arguments directly when running the program from the command line. These arguments can be accessed through the `args` parameter in the `main` method.

```java
package src.main.java;

public class Application {
    public static void main(String[] args) {
        if (args.length > 0) {
            System.out.println("First argument: " + args[0]);
        } else {
            System.out.println("No arguments provided.");
        }
    }
}
```

<figure><img src="../../../.gitbook/assets/image (275).png" alt=""><figcaption></figcaption></figure>

## **Using `Console` Class (Java 6 and later)**

The `Console` class provides methods for reading input and writing output to the console. It is useful for simple console-based applications. It is a `java.io` package. Note that we need to execute the code via console.

```java
package src.main.java;

import java.io.Console;

public class Application {
    public static void main(String[] args) {
        Console console = System.console();
        if (console != null) {
            String input = console.readLine("Enter your input: ");
            console.printf("You entered: %s\n", input);
        } else {
            System.out.println("Console is not available.");
        }
    }
}
```

<figure><img src="../../../.gitbook/assets/image (276).png" alt=""><figcaption></figcaption></figure>

## Which one to use?

### BufferedReader vs Scanner

<table data-header-hidden data-full-width="true"><thead><tr><th width="221"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Feature</strong></td><td><strong>BufferedReader</strong></td><td><strong>Scanner</strong></td></tr><tr><td><strong>Primary Purpose</strong></td><td>Efficiently reads text from a character-based input stream in chunks.</td><td>Reads and parses input into tokens or specific data types.</td></tr><tr><td><strong>Performance</strong></td><td>Faster for reading large files due to internal buffering.</td><td>Slower for large files due to token parsing overhead.</td></tr><tr><td><strong>Data Type Support</strong></td><td>Reads text as <code>String</code> or characters; manual parsing required for primitives.</td><td>Built-in support for parsing primitives (<code>int</code>, <code>double</code>, etc.).</td></tr><tr><td><strong>Input Sources</strong></td><td>Can read from files, strings, or streams.</td><td>Can read from files, strings, streams, and system input (<code>System.in</code>).</td></tr><tr><td><strong>Default Delimiter</strong></td><td>Not applicable; reads lines or characters directly.</td><td>Whitespace (<code>\s</code>) by default, customizable via <code>useDelimiter()</code>.</td></tr><tr><td><strong>Line-by-Line Reading</strong></td><td>Supports reading lines via <code>readLine()</code>.</td><td>Possible but not as intuitive; requires custom logic.</td></tr><tr><td><strong>Character-by-Character Reading</strong></td><td>Supports reading characters using <code>read()</code>.</td><td>Not supported directly.</td></tr><tr><td><strong>End of Input Handling</strong></td><td>Returns <code>null</code> for <code>readLine()</code> and <code>-1</code> for <code>read()</code>.</td><td>Uses <code>hasNext()</code> and related methods to check availability.</td></tr><tr><td><strong>Parsing Capabilities</strong></td><td>Requires manual parsing for primitives (e.g., using <code>Integer.parseInt()</code>).</td><td>Provides methods like <code>nextInt()</code>, <code>nextDouble()</code>, etc., for parsing.</td></tr><tr><td><strong>Error Handling</strong></td><td>Throws <code>IOException</code> for input/output errors.</td><td>Throws <code>InputMismatchException</code> for type mismatches.</td></tr><tr><td><strong>Mark and Reset</strong></td><td>Supports marking and resetting positions in the stream.</td><td>Does not support marking and resetting.</td></tr><tr><td><strong>Custom Delimiters</strong></td><td>Not applicable; processes lines/characters directly.</td><td>Supports custom delimiters via <code>useDelimiter()</code>.</td></tr><tr><td><strong>Thread Safety</strong></td><td>Not thread-safe; external synchronization required.</td><td>Not thread-safe; external synchronization required.</td></tr><tr><td><strong>Complex Input Handling</strong></td><td>Best suited for reading raw text or large files efficiently.</td><td>Better for simple interactive inputs or structured data with tokens.</td></tr><tr><td><strong>Binary File Support</strong></td><td>Cannot handle binary files; use <code>BufferedInputStream</code> instead.</td><td>Not suitable for binary files.</td></tr><tr><td><strong>Resource Management</strong></td><td>Requires manual closure or use of <code>try-with-resources</code>.</td><td>Requires manual closure or use of <code>try-with-resources</code>.</td></tr><tr><td><strong>Use Case</strong></td><td>Reading and processing large text files, logs, or configuration files.</td><td>Interactive console input or small structured file parsing.</td></tr></tbody></table>

* **Use `BufferedReader`:**
  * When working with large files where performance is critical.
  * When we need to read text line by line or character by character.
  * When parsing is not required, or we prefer manual control over parsing.
* **Use `Scanner`:**
  * For interactive input from the console.
  * When parsing numbers, tokens, or specific data types directly is required.
  * For quick, small-scale parsing of structured input like CSVs or space-separated values.





