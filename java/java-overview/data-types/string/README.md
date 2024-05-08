# String

## Description

In Java, a String represents a sequence of characters. Unlike some other languages where strings might be mutable (changeable), strings in Java are **immutable**. This means that once a String object is created, its content cannot be modified. It is part of the `java.lang` package, which means it's automatically imported into every Java program.



## Characteristic

### **Immutable:**

* One of the most unique characteristics of strings in Java is that they are immutable, meaning once a string object is created, its value cannot be changed. Whenever we try to change any string, a new instance is created.
* Any operation that appears to modify a string actually creates a new string object with the modified value.

{% hint style="info" %}
In Java, the String class and all wrapper classes which include Boolean, Character, Byte, Short, Integer, Long, Float, and Double are immutable.
{% endhint %}

#### Why String Objects are Immutable? <a href="#why-string-objects-are-immutable-in-java-and-its-benefits" id="why-string-objects-are-immutable-in-java-and-its-benefits"></a>

Strings with the same content share storage in a single pool to minimize creating a copy of the same value. A new String instance will be generated if in case it previously doesn't have any instance in the pool and returned to that same caller if any modifications are made to the String or if any operation is performed using String methods. When there are no more references to the original String object in the pool, it will be unallocated and the global garbage collector will remove it.

```java
String s1 = "Hello"; // String literal
String s2 = "Hello"; // String literal
String s3 = s1; // same reference
```

<figure><img src="../../../../.gitbook/assets/image (80).png" alt="" width="551"><figcaption></figcaption></figure>

Changing the value of String created above

```java
// Changing the value of s1
s1 = "Java";

// Updating with concat() operation
s2.concat(" World");

// The concatenated string will be created as a new instance and an object should refer to that instance to get the concatenated value.
String newS3 = s3.concat(" Test");

System.out.println("s1 refers to " + s1); // s1 refers to Java
System.out.println("s2 refers to " + s2); // s2 refers to Hello
System.out.println("s3 refers to " + s3); // s3 refers to Hello
System.out.println("newS3 refers to " + newS3); // newS3 refers to Hello Test
```

<figure><img src="../../../../.gitbook/assets/image (81).png" alt="" width="563"><figcaption></figcaption></figure>

String s1 is updated with a new value and that's why a new instance is created. Hence, s1 reference changes to that newly created instance "Java". String s2 and s3 remain unchanged as their references were not changed to a new instance created after performing concat() operation. "Hello World" remains unreferenced to any object and lost in the pool as s2.concat() operation is not assigned to any object. That's why there is a reference to its result. String newS3 refers to the instance of s3.concat() operation that is "Hello Test" as it is referenced to new object newS3.

### String Pool <a href="#string-pool" id="string-pool"></a>

In java, a String pool refers to a storage area in heap memory. Memory allocation to a String object is a costly process in terms of both time as well as memory. The JVM (Java Virtual Machine) performs a sequence of steps while initializing string literals to reduce memory overhead and increase performance efficiency.

To reduce the number of String objects produced and hence the overall memory consumption, the String class keeps a pool of strings. Every time a string literal is generated, the JVM checks for its existence in the string pool first. A reference to the instance of the String is returned if the string already exists in the string pool, otherwise a new String object is instantiated and added to the pool. Note that **new** operator prevents the pool searching mechanism.

```java
// "Hi" is added to the pool as it doesn't exist in it already.
String s = "Hi";

// s2 refers to the pre-existing "Hi" in the pool from s1
String s2 = "Hi";

// new operator prevents the pool searching mechanism and thus s3 doesn't share the reference with s1 or s2
String s3 = new String("Hi");
```

### Thread Safety <a href="#thread-safety" id="thread-safety"></a>

Thread safety refers to the ability of a program to function correctly and produce consistent results when accessed concurrently by multiple threads. In the case of `String`, because `String` objects are immutable, they are inherently thread-safe. This means that multiple threads can safely read the content of a `String` object simultaneously without any risk of data corruption or inconsistency.

However, it's important to note that while `String` objects themselves are thread-safe for reading, operations that involve multiple `String` objects may not be thread-safe if those objects are being modified concurrently by multiple threads. For example, operations that involve concatenating or modifying `String` objects may need external synchronization to ensure thread safety.

But in the case of the usage of references, thread safety is not maintained. Thus, **Immutable objects are always thread-safe, but their references are not.**

### **Equality Comparisons**

In Java, the `==` operator checks whether two object references point to the same memory location in the heap. When we use `==` to compare strings, we're checking whether the two string references refer to the same object in memory, not whether the strings themselves have the same content.

However, when we want to compare the actual content of two strings, we should use the `equals()` method. The `equals()` method compares the characters in the strings, character by character, to determine whether they have the same content. It doesn't rely on object references; instead, it compares the sequences of characters in the strings.

Even though two string objects might have the same content, they could still be different objects in memory if they were created independently.

```java
String str1 = "hello";
String str2 = "hello";

// Here, str1 and str2 both point to the same string literal in the string pool
System.out.println(str1 == str2);      // Output: true
System.out.println(str1.equals(str2)); // Output: true

String str3 = new String("hello");
String str4 = new String("hello");

// Here, str3 and str4 are separate objects created using the new keyword
System.out.println(str3 == str4);      // Output: false
System.out.println(str3.equals(str4)); // Output: true
```

### **Performance Considerations**

Because strings are immutable, operations such as concatenation (`+` operator) or appending (`+=` operator) can create many temporary string objects, leading to inefficient memory usage and performance degradation. To efficiently manipulate strings, we can use the `StringBuilder` or `StringBuffer` classes, which are **mutable and designed for string manipulation**.

### **String Literals vs. String Objects**

* String literals (e.g., `"Hello"`) are stored in the string pool and reused if the same literal is encountered again.
* String objects created using the `new` keyword (e.g., `new String("Hello")`) are not stored in the string pool and are separate objects, even if they contain the same sequence of characters.

### **Unicode Support:**

* Java strings are Unicode-based, which means they can represent characters from various writing systems and languages around the world.
* Each character in a Java string is represented using a 16-bit Unicode code point.



## Methods available in String Class

### **Length Related:**

* `int length()`: Returns the length of the string.

### **Accessing Characters:**

* `char charAt(int index)`: Returns the character at the specified index.
* `int codePointAt(int index)`: Returns the Unicode code point at the specified index.
* `int codePointBefore(int index)`: Returns the Unicode code point before the specified index.
* `int codePointCount(int beginIndex, int endIndex)`: Returns the number of Unicode code points in the specified range of text.

### **Searching:**

* `int indexOf(String str)`: Returns the index of the first occurrence of the specified substring.
* `int lastIndexOf(String str)`: Returns the index of the last occurrence of the specified substring.
* `boolean contains(CharSequence s)`: Returns `true` if the string contains the specified sequence of characters.
* `boolean startsWith(String prefix)`: Returns `true` if the string starts with the specified prefix.
* `boolean endsWith(String suffix)`: Returns `true` if the string ends with the specified suffix.

### **Substring:**

* `String substring(int beginIndex)`: Returns a new string that is a substring of this string.
* `String substring(int beginIndex, int endIndex)`: Returns a new string that is a substring of this string, starting from `beginIndex` up to `endIndex-1`.

### **Modifying Strings:**

* `String concat(String str)`: Concatenates the specified string to the end of this string.
* `String replace(char oldChar, char newChar)`: Returns a new string resulting from replacing all occurrences of `oldChar` with `newChar`.
* `String trim()`: Returns a copy of the string with leading and trailing whitespace removed.
* `String toLowerCase()`: Converts all characters in this string to lowercase.
* `String toUpperCase()`: Converts all characters in this string to uppercase.

### **Splitting and Joining:**

* `String[] split(String regex)`: Splits the string around matches of the given regular expression.
* `String join(CharSequence delimiter, CharSequence... elements)`: Joins the elements of the provided array into a single string, using the specified delimiter.

### **Comparing Strings:**

* `boolean equals(Object anObject)`: Compares this string to the specified object.
* `boolean equalsIgnoreCase(String anotherString)`: Compares this string to another string, ignoring case considerations.
* `int compareTo(String anotherString)`: Compares two strings lexicographically.
* `int compareToIgnoreCase(String str)`: Compares two strings lexicographically, ignoring case considerations.

### **Converting to and from Primitive Types:**

* `static String valueOf(primitive data type x)`: Returns the string representation of the passed argument.
* `static String valueOf(Object obj)`: Returns the string representation of the passed object.
