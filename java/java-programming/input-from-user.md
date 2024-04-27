# Input from User

In Java, there are several ways to take input from the user. Here are some common methods.

1. **Using `Scanner` Class:** The `Scanner` class is a standard class in Java used for taking input from the user. It's part of the `java.util` package.

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

<figure><img src="../../.gitbook/assets/image (51).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Among all the methods mentioned here, using the `Scanner` class is probably the most commonly used method for taking input from the user in Java, especially for beginner-level programming and simple console-based applications.
{% endhint %}



2. **Using `BufferedReader` Class:** The `BufferedReader` class, along with `InputStreamReader`, can be used to read input from the user. This method is useful when dealing with input streams. It's part of the `java.io` package.

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

<figure><img src="../../.gitbook/assets/image (52).png" alt=""><figcaption></figcaption></figure>



3. **Using Command Line Arguments:** You can also pass input arguments directly when running the program from the command line. These arguments can be accessed through the `args` parameter in the `main` method.

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

<figure><img src="../../.gitbook/assets/image (53).png" alt=""><figcaption></figcaption></figure>



4. **Using `Console` Class (Java 6 and later):** The `Console` class provides methods for reading input and writing output to the console. It's useful for simple console-based applications. It is a `java.io` package. Note that we need to execute the code via console.

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

<figure><img src="../../.gitbook/assets/image (54).png" alt=""><figcaption></figcaption></figure>



