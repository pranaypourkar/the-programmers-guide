---
description: Info about custom exception handling in Java.
---

# Custom Exception Handling

Custom exception handling in Java allows us to define our own exception types to handle specific error conditions in your applications.&#x20;

**Best Practices**:

* **Follow the general naming convention:** That is end the name of custom exception with “Exception”&#x20;
* **Provide Javadoc comments for the custom exception class:** It’s a general best practice to document all classes, fields, constructors, and methods of your API.
* **Provide a constructor that sets the cause**: With this the original cause or important information is not lost.

To create a custom exception, define a new class that extends either `Exception` (for checked exceptions) or `RuntimeException` (for unchecked exceptions).

{% hint style="info" %}
The decision to make a custom exception checked or unchecked depends on the nature of the exception and the context in which it will be used. If the exception represents a recoverable situation, better to make it a checked exception (i.e., extending Exception). If the exception indicates an unrecoverable error, better to take it as unchecked exception (i.e., extending RuntimeException).
{% endhint %}



**How to decide whether a custom exception in Java should extend** `RuntimeException` **or** `Exception`**?**

Extending `Exception`**:**

* Use `Exception` when the custom exception represents a checked exception (Recoverable), meaning the compiler forces to either handle the exception in a `try-catch` block or declare it in the method signature using `throws`.
* Choose `Exception` if exception indicates an error condition that could potentially occur during normal program execution and needs to be explicitly handled.
* Examples of situations where we might extend `Exception`:
  * File opening failure (`FileNotFoundException`)
  * Network connection issues (`IOException`)
  * Parsing errors (`ParseException`)
  * EntityNotFoundException**:** This exception likely indicates an error condition where an entity (data object) couldn't be found during normal program execution. It's essential to handle this exception to prevent the program from continuing with invalid data.
  * TransactionNotFoundException**:** Similar to `EntityNotFoundException`, this exception suggests a situation where a transaction couldn't be located. Depending on the context, it might be crucial to handle this checked exception gracefully.
  * IncorrectFileNameException: Exception, if filename not found as well as incorrect.

Extending `RuntimeException`**:**

* Use `RuntimeException` when your custom exception represents an unchecked exception (Potentially Unrecoverable), meaning the compiler doesn't require explicit handling.
* Choose `RuntimeException` if your exception indicates a programming error or unexpected condition that should not occur during normal program execution. It's usually recommended to fix the code rather than relying on catching these exceptions.
* Examples of situations where we might extend `RuntimeException`:
  * Null pointer exceptions (`NullPointerException`)
  * Array index out of bounds (`IndexOutOfBoundsException`)
  * Class cast exceptions (`ClassCastException`)
  * InvalidTransactionDetails: This exception likely points to a programming error or unexpected condition where the transaction details are invalid or inconsistent. It's generally recommended to fix the code that led to this issue rather than relying on catching this exception.
  * MissingDetailsException: Similar to `InvalidTransactionDetails`, this exception suggests missing or incomplete information, indicating a potential issue in the code or data. It's preferable to address the root cause of missing details through proper validation or handling.
  * CardDetailsNotFoundException: This exception might indicate a situation where card details are missing or invalid. If it's essential to process card details and their absence halts normal program flow, consider extending `Exception`. However, if it's an optional field and its absence doesn't cause major issues, extending `RuntimeException` might be suitable.
  * IncorrectFileExtensionException: Exception, if the file name doesn’t contain any extension.
  * JsonSerializationException: Exception raised during serialization.



**Sample Examples**

```java
package org.example.exception;

public class UnknownOperationException extends UnsupportedOperationException {
    public UnknownOperationException(String operation) {
        super(String.format("Unsupported operation found - %s", operation));
    }
}
```

```java
package org.example.exception;

public class TransactionException extends Exception {

    public static final String TRANSACTION_NOT_FOUND = "Transaction with id %s not found for user %s";

    public TransactionException(String msg) {
        super(msg);
    }

    public TransactionException(String msg, Object...args) {
        super(msg.formatted(args));
    }
}
```

```java
package org.example.exception;

public class JsonSerializationException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public JsonSerializationException(String message) {
        super(message);
    }
}
```
