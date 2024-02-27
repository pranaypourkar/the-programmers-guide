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
