# StringBuffer

## Description

`StringBuffer` has been available since the early versions of Java. It is similar to `StringBuilder`, but it is synchronized, making it thread-safe. This means that `StringBuffer` can be safely used in multithreaded environments where multiple threads might access or modify the same `StringBuffer` object concurrently.

`StringBuffer` classes in Java are mutable and designed for string manipulation. They provide methods to modify the contents of the string without creating new string objects, which can lead to better performance compared to using regular `String` objects for string manipulation.

```java
StringBuffer sb = new StringBuffer("Hello");
sb.append(" World");
String result = sb.toString(); // result is "Hello World"
```

## Working

Internally it uses a resizable array to store the characters of the string. When we append or modify the contents of the string using methods like `append()`, `insert()`, `delete()`, etc., they directly modify the internal character array of the object without creating new string objects. This allows for efficient string manipulation, especially when dealing with large strings or performing many concatenation operations.

## Not Using String Pool

Unlike regular `String` objects, `StringBuffer` do not use the string pool for storing string literals. When we create a `StringBuffer` object and append or modify its contents, new character arrays may be created dynamically to accommodate the changes, but these arrays are not stored in the string pool. This behavior is different from regular `String` objects, which may use the string pool for storing string literals to optimize memory usage.



