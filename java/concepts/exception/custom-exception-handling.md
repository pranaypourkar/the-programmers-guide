---
description: Info about custom exception handling in Java.
---

# Custom Exception Handling

Custom exception handling in Java allows us to define our own exception types to handle specific error conditions in your applications.&#x20;

Best Practices:

* **Follow the general naming convention:** That is end the name of custom exception with “Exception”&#x20;
* **Provide Javadoc comments for the custom exception class:** It’s a general best practice to document all classes, fields, constructors, and methods of your API.
* **Provide a constructor that sets the cause**: With this the original cause or important information is not lost.

To create a custom exception, define a new class that extends either `Exception` (for checked exceptions) or `RuntimeException` (for unchecked exceptions).



**Checked Custom Exception:** Let's say you're building an inventory management system, and you have a custom exception `ProductNotFoundException` that extends `Exception`. This exception could be thrown when a requested product is not found in the inventory. Since the calling code might reasonably handle this situation (for example, by informing the user or logging the error), it's a checked exception.

**Unchecked Custom Exception:** On the other hand, suppose you have a custom exception `InvalidInputException` that extends `RuntimeException`. This exception might be thrown when the user provides invalid input to a method. Since it's likely a programming error and the calling code might not be able to handle it gracefully, it's an unchecked exception.
