# Comparison - String, StringBuilder & StringBuffer

## **Difference between String, String Builder, and String Buffer**

<table data-full-width="true"><thead><tr><th width="178">Feature</th><th>String</th><th>StringBuilder</th><th>StringBuffer</th></tr></thead><tbody><tr><td><strong>Mutability</strong></td><td>Immutable</td><td>Mutable</td><td>Mutable</td></tr><tr><td><strong>Thread Safety</strong></td><td>Thread-safe (because it's immutable)</td><td>Not thread-safe</td><td>Thread-safe</td></tr><tr><td><strong>Storage</strong></td><td>String variables are stored in a “constant string pool”</td><td>String values are stored in a stack. If the values are changed then the new value replaces the older value.</td><td>Same as StringBuilder</td></tr><tr><td><strong>Performance</strong></td><td>Slower in operations involving multiple string modifications</td><td>Faster for single-threaded operations involving multiple string modifications</td><td>Slower than <code>StringBuilder</code> due to synchronization overhead</td></tr><tr><td><strong>Usage</strong></td><td>Used when the string value will not change or change infrequently</td><td>Used when the string value will change frequently and thread safety is not a concern</td><td>Used when the string value will change frequently and thread safety is a concern</td></tr><tr><td><strong>Methods Available</strong></td><td>Limited to standard string operations (e.g., length, charAt, substring)</td><td>Extensive methods for modifying strings (e.g., append, insert, delete, reverse)</td><td>Similar to <code>StringBuilder</code> with synchronized methods for thread safety</td></tr><tr><td><strong>Thread Synchronization</strong></td><td>Not applicable</td><td>Not synchronized</td><td>Synchronized methods</td></tr><tr><td><strong>Memory Allocation</strong></td><td>Fixed and cannot be changed after creation</td><td>Can grow dynamically</td><td>Can grow dynamically</td></tr><tr><td><strong>String Pool</strong></td><td>Supports string pool</td><td>Does not support string pool</td><td>Does not support string pool</td></tr><tr><td><strong>Performance in Concatenation</strong></td><td>Poor performance in concatenation (each concatenation creates a new object)</td><td>Better performance for concatenation (modifies the existing object)</td><td>Better performance for concatenation (modifies the existing object, but slower than <code>StringBuilder</code>)</td></tr><tr><td><strong>Example Initialization</strong></td><td><code>String str = "Hello";</code></td><td><code>StringBuilder sb = new StringBuilder("Hello");</code></td><td><code>StringBuffer sb = new StringBuffer("Hello");</code></td></tr><tr><td><strong>Usage Scenario</strong></td><td>Best for read-only or rarely modified strings</td><td>Best for frequently modified strings in single-threaded contexts</td><td>Best for frequently modified strings in multi-threaded contexts</td></tr><tr><td><strong>Example Operations</strong></td><td><code>str.concat(" World");</code></td><td><code>sb.append(" World");</code></td><td><code>sb.append(" World");</code></td></tr></tbody></table>

```java
// String
String str = "Hello";
str = str.concat(" World"); // Creates a new string "Hello World"
System.out.println(str);    // Output: Hello World

// StringBuilder
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World"); // Modifies the existing StringBuilder object
System.out.println(sb.toString()); // Output: Hello World

// StringBuffer
StringBuffer sb = new StringBuffer("Hello");
sb.append(" World"); // Modifies the existing StringBuffer object
System.out.println(sb.toString()); // Output: Hello World 
```

