---
description: Details about custom functional interfaces in Java.
---

# Custom Interfaces

Custom functional interfaces are interfaces in Java that extend the functionalities of the built-in functional interfaces (like `Function`, `Predicate`, etc.) to fit specific needs within the application. They adhere to the principle of having exactly one abstract method.

**Benefits:**

* **Improved code organization:** Encapsulates specific functionalities, making code more organized and easier to understand.
* **Enhanced reusability:** Allows to reuse the same interface for different implementations, promoting code reusability.
* **Flexibility:** Enables you to create interfaces that cater to specific needs not directly addressed by the built-in options.

**Example:**

Lets create a custom functional interface class.

```java
@FunctionalInterface
public interface StringModifier {
    String modify(String str);
}
```



Now, implement the Interface. There are two ways to implement this interface.

* **Using a separate class**

```java
public class UppercaseModifier implements StringModifier {

    @Override
    public String modify(String str) {
        return str.toUpperCase();
    }
}
```

* **Using a Lambda Expression**

```java
StringModifier lowercaseModifier = str -> str.toLowerCase();
```



Then use the interface

```javascript
String originalString = "Hello World!";

// Using separate class implementation
StringModifier uppercaseModifier = new UppercaseModifier();
String uppercaseString = uppercaseModifier.modify(originalString);
log.info(uppercaseString); 
// Output: HELLO WORLD!

// Using lambda expression
String lowercaseString = lowercaseModifier.modify(originalString);
log.info(lowercaseString); 
// Output: hello world!
```
