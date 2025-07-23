# Scanner

## **About**

The **`Scanner`** class in Java is part of the `java.util` package and is widely used for parsing and reading input. It allows developers to read and parse text or primitive data types (like `int`, `double`, etc.) from various sources, including keyboard input, files, and strings.

* The `Scanner` class is designed to break input into tokens using a delimiter (default is whitespace).
* It provides methods to read and parse different data types, such as integers, floats, strings, etc.
* Commonly used in applications that require user input or processing text-based data.
* It is simple to use, making it a popular choice for basic input handling in beginner Java programs.

## **Features**

1. **Input Sources:** Can read input from a wide variety of sources such as the console, files, strings, and streams.
2. **Tokenization:** Automatically splits input into tokens based on delimiters.
3. **Parsing Data:** Provides methods to parse input into primitive types (`int`, `double`, `boolean`, etc.) and strings.
4. **Custom Delimiters:** Supports the use of custom delimiters for splitting input.
5. **Locale Support:** Can use different `Locale` settings for parsing numbers and text.
6. **Built-in Validation:** Offers methods to check the presence of a specific type of token (`hasNextInt`, `hasNextDouble`, etc.), ensuring safe input parsing.

## **Declaration**

To use the `Scanner` class, it needs to be imported from the `java.util` package:

```java
import java.util.Scanner;
```

## **Methods Available**

### **1. Reading Data**

* `next()`: Reads the next token as a string.
* `nextLine()`: Reads the entire line of input.
* `nextInt()`, `nextDouble()`, `nextFloat()`, `nextLong()`, `nextShort()`, `nextByte()`: Reads and parses a token as a specific primitive type.
* `nextBoolean()`: Reads a token and parses it as a boolean.

### **2. Checking for Input**

* `hasNext()`: Checks if there is another token available.
* `hasNextInt()`, `hasNextDouble()`, etc.: Checks if the next token can be parsed as the specified type.

### **3. Token Delimiters**

* `useDelimiter(String pattern)`: Sets a custom delimiter pattern.
* `reset()`: Resets the scanner to the default delimiter and locale.

### **4. Locale and Patterns**

* `useLocale(Locale locale)`: Sets the scanner's locale for parsing numbers.
* `findInLine(String pattern)`: Finds a pattern in the current line.

### **5. Closing the Scanner**

* `close()`: Closes the scanner and releases any underlying resources.

## **Usage**

### **Basic Input from Console**

```java
import java.util.Scanner;

public class ScannerExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter your name: ");
        String name = scanner.nextLine();

        System.out.print("Enter your age: ");
        int age = scanner.nextInt();

        System.out.println("Hello, " + name + ". You are " + age + " years old.");
        scanner.close(); // Always close the scanner
    }
}
```

### **Reading from a File**

```java
import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class FileScannerExample {
    public static void main(String[] args) throws FileNotFoundException {
        File file = new File("example.txt");
        Scanner scanner = new Scanner(file);

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            System.out.println(line);
        }

        scanner.close();
    }
}
```

### **Using a Custom Delimiter**

```java
import java.util.Scanner;

public class CustomDelimiterExample {
    public static void main(String[] args) {
        String input = "John,Doe,25,Engineer";
        Scanner scanner = new Scanner(input);
        scanner.useDelimiter(",");

        while (scanner.hasNext()) {
            System.out.println(scanner.next());
        }

        scanner.close();
    }
}
```

### **Validating Input**

```java
import java.util.Scanner;

public class InputValidationExample {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter an integer: ");
        while (!scanner.hasNextInt()) {
            System.out.println("That's not a valid integer. Try again:");
            scanner.next(); // Consume the invalid token
        }
        int number = scanner.nextInt();
        System.out.println("You entered: " + number);

        scanner.close();
    }
}
```

## **Applications and Real-World Usage**

1. **Command-Line Applications:** Used to handle user input for interactive console-based applications.
2. **File Parsing:** Reading and processing text files for data analysis or configuration.
3. **Data Validation:** Ensuring user input meets specific criteria before processing.
4. **Custom Data Formats:** Parsing delimited data (e.g., CSV, TSV) using custom delimiters.
5. **Educational Use:** Commonly used in programming exercises to teach input handling in Java.
