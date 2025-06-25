# Set 3

## What are Public Static Methods ?

These are methods that belong to the class itself rather than to any particular instance of the class. They can be called without creating an instance of the class. Common uses for `public static` methods include utility methods, helper functions, or methods that operate on class-level data. For example:

```java
public class MathUtils {
    public static int add(int a, int b) {
        return a + b;
    }
}
```

Here, `add` is a `public static` method of the `MathUtils` class, allowing us to call it like `MathUtils.add(2, 3)` without needing to create an instance of `MathUtils`.

## What are Public Static Final Variables ?

These are constants that are associated with the class and cannot be changed once they are assigned a value. They are often used for values that are meant to be constant throughout the execution of the program. For example:

```java
public class Constants {
    public static final double PI = 3.14159;
}
```

Here, `PI` is a `public static final` variable of the `Constants` class, and its value cannot be modified once it's set. We can access it using `Constants.PI`.



