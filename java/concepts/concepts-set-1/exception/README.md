---
description: Overview on the Exception Handling and best practices.
---

# Exception

An exception is an event that disrupts the normal flow of a program's instructions during execution. When an exceptional scenario occurs within a method, the method creates an exception object and hands it off to the runtime system. The runtime system then searches for an exception handler i.e., a block of code that can handle that particular type of exception.

**There are two main types of exceptions in Java:**

1. **Checked Exceptions (Recoverable)**: These are exceptions that are checked at compile time. This means that the compiler ensures that your code handles these exceptions either by catching them with a try-catch block or by declaring that the method throws the exception using the `throws` keyword. Examples of checked exceptions include `IOException`, `SQLException`, etc.
2. **Unchecked Exceptions (Potentially Unrecoverable)**: Also known as runtime exceptions, these exceptions are not checked at compile time. They occur during the execution of the program and typically indicate programming errors or exceptional conditions that a coder can reasonably expect might occur. Examples of unchecked exceptions include `NullPointerException`, `ArrayIndexOutOfBoundsException`, etc.

{% hint style="info" %}
Every exception in Java is a subclass of the `Throwable` class. The two main subclasses of `Throwable` are `Exception` and `Error`. Checked exceptions are subclasses of `Exception`, while unchecked exceptions are subclasses of `RuntimeException`, which itself is a subclass of `Exception`.
{% endhint %}

{% hint style="info" %}
**Recoverable Exception:**

* An exception that might be possible to handle and continue program execution in some way.
* This doesn't necessarily mean the program can fully recover from the issue that caused the exception, but it might be able to work around it or take alternative actions.
* Examples:
  * **Network timeouts:** The program might retry the operation after a delay.
  * **Temporary resource unavailability:** The program might wait for the resource to become available or use an alternative resource.

**Non-recoverable Exception:**

* An exception that usually indicates a more severe issue from which it's difficult or impossible to fully recover, often requiring the program to terminate abnormally**.**
* These exceptions often point to critical errors or unexpected conditions that fundamentally prevent the program from continuing its intended operation.
* Examples:
  * **Out of memory errors:** The program might not have enough memory to continue execution.
  * **Corrupted data:** The program might be unable to process data that is in an invalid or inconsistent state.
{% endhint %}



There are **different ways to handle exceptions**, depending on the requirements of the program and the nature of the exceptions being thrown. Here are some of the ways to handle.

**Using try-catch Block**: try-catch block can be used to catch exceptions and handle them gracefully. Inside the try block, place the code that might throw an exception, and inside the catch block, specify the type of exception that needs to be handled and provide the code to handle it.

```java
try {
    // Code that might throw an exception
} catch (ExceptionType e) {
    // Code to handle the exception
}
```

**Using Multiple catch Blocks**: Multiple catch blocks can be used to handle different types of exceptions separately.

```java
try {
    // Code that might throw different types of exceptions
} catch (IOException e) {
    // Code to handle IOException
} catch (SQLException e) {
    // Code to handle SQLException
} catch (Exception e) {
    // Code to handle other exceptions
}
```

**Using a Single catch Block for Multiple Exceptions**: Multiple exceptions can be catched using a single catch block separated by a pipe (|) symbol.

```java
try {
    // Code that might throw different types of exceptions
} catch (IOException | SQLException e) {
    // Code to handle IOException or SQLException
}
```

**Throwing Exceptions**: Exceptions can be thrown explicitly using the `throw` keyword.&#x20;

```java
if (someCondition) {
    throw new ExceptionType("Error message");
}
```

**Using finally Block**: Finally block can be used to execute code regardless of whether an exception is thrown or not. This block is useful for releasing resources or performing cleanup operations.

```java
try {
    // Code that might throw an exception
} catch (ExceptionType e) {
    // Code to handle the exception
} finally {
    // Code to execute regardless of whether an exception is thrown or not
}
```

**Using try-with-resources**: This is a special form of try statement that declares one or more resources to be used within the block. The resources are automatically closed at the end of the block, even if an exception occurs.

```java
try (ResourceType resource = new ResourceType()) {
    // Code that uses the resource
} catch (ExceptionType e) {
    // Code to handle the exception
}
```



**Best Practices in Exception Handling**

* **Catch Specific Exceptions**: Catch only those exceptions that can be handled. Avoid catching broader exceptions like `Exception` if specific exceptions can be used.
* **Handle Exceptions Appropriately**: Handle exceptions at an appropriate level of abstraction. This means catching exceptions where it can be handled effectively without cluttering the code with unnecessary try-catch blocks.
* **Use try-with-resources**: When working with resources like files, streams, or database connections, use the try-with-resources statement to ensure that resources are closed properly, even if an exception occurs.
* **Log Exceptions**: Always log exceptions along with relevant information such as stack traces, error messages, and context information. This helps in debugging and troubleshooting issues later.
* **Avoid Swallowing Exceptions**: Avoid catching exceptions and doing nothing (also known as swallowing exceptions). If an exception is catched, make sure to handle it appropriately, whether by logging it, retrying the operation, or propagating it up the call stack.
* **Fail Fast**: If an error condition occurs that the code cannot handle, it's better to fail fast and throw an exception rather than allowing the program to continue in an inconsistent state.
* **Encapsulate Exception Handling Logic**: Encapsulate exception handling logic into separate methods or classes to improve code readability and maintainability. This also helps in reusing exception handling logic across multiple parts of your application.
* **Do not remove the original cause of the exception with custom exception:** One common mistake in exception handling is removing the original cause of the exception when wrapping it in a different exception type. For example, let's say you have a method that reads data from a file and encounters an `IOException`. Instead of propagating this exception or wrapping it in a custom business exception, you create a new exception without setting the original `IOException` as its cause. This effectively removes valuable information such as the error message and stack trace related to the original exception.

<table data-full-width="true"><thead><tr><th align="center">Bad Practice</th><th align="center">Good Practice</th></tr></thead><tbody><tr><td align="center"><p></p><pre class="language-java"><code class="lang-java">public class BadPracticeExample {

    public void readFile() {
        try {
            // Code that might throw an IOException
            FileInputStream fileInputStream = new FileInputStream("example.txt");
            // Read file contents
        } catch (IOException e) {
            // Wrapping the original exception in a new exception without setting the cause
            throw new CustomBusinessException("Error reading file");
        }
    }
}
</code></pre></td><td align="center"><p></p><pre class="language-java"><code class="lang-java">public class GoodPracticeExample {

    public void readFile() throws CustomBusinessException {
        try {
            FileInputStream fileInputStream = new FileInputStream("example.txt");
            // Read file contents
        } catch (IOException e) {
            // Wrapping the original exception in a new exception and setting it as the cause
            throw new CustomBusinessException("Error reading file", e);
        }
    }
}
</code></pre></td></tr></tbody></table>
