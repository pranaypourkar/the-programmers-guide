# Best Practices and Concepts

## How Java `String` and `char` works internally

In Java, `String` and `char` types are designed to work with Unicode characters, and they handle text internally using the UTF-16 encoding.&#x20;

### Internal Representation of Strings in Java

* **UTF-16 Encoding**: Internally, Java uses UTF-16 encoding for its `String` and `char` types.
  * Each `char` in Java is a 16-bit Unicode character.
  * This means that characters in the Basic Multilingual Plane (BMP) are represented by a single 16-bit `char`value.
  * Characters outside the BMP (such as many emoji and some ancient scripts) are represented using a pair of `char` values known as surrogate pairs.

### Default Character Set for I/O Operations

* **Default Charset**: The default character set is used when we perform I/O operations without specifying an explicit charset.
  * It affects methods like `String.getBytes()` and `new String(byte[])` when no charset is provided.
  * The default charset is typically determined by the system's locale and can vary. On most modern systems, it is often UTF-8.

{% hint style="info" %}
How to Find Default Character Set ?

```java
import java.nio.charset.Charset;

public class EncodingDecodingFiles {
    public static void main(String[] args) {
        Charset defaultCharset = Charset.defaultCharset();
        System.out.println("Default Charset: " + defaultCharset);
    }
}
```

\
![](<../../../../.gitbook/assets/image (1) (1) (1) (1) (1).png>)
{% endhint %}

### How They Work Together

1. **Internal String Representation (UTF-16)**:
   * When we create a `String` in Java, it is stored in memory using UTF-16 encoding.
   *   For example:

       ```java
       javaCopy codeString text = "Hello, 世界!";
       ```
   * In memory, each character in "Hello, 世界!" is represented using one or more 16-bit code units.
2. **Encoding and Decoding for I/O (Default Charset)**:
   * When we write this `String` to a file or send it over a network, it is converted from the internal UTF-16 representation to a byte sequence.
   * If you use `getBytes()` without specifying a charset, it uses the default charset (e.g., UTF-8 on your system).
3. **Displaying Strings**
   * **System.out.print**: When we print a `String` using `System.out.print` or `System.out.println`, the internal UTF-16 encoded string is converted to bytes using the default charset of the environment (often UTF-8) and sent to the console.
     * The console's encoding (often UTF-8) will then render these bytes as characters on the screen.

### Example with character "A"

Here we will understand about - Internal Representation, Conversion to Bytes, Display on Console

Here is a step-by-step diagram:

```plaintext
1. Internal Representation (UTF-16)
   --------------------------------
   Character: 'A'
   Unicode Code Point: U+0041
   UTF-16 Encoding: 0041

   [ char ]     [ char ]
     0x0041

2. Conversion to Bytes (UTF-8)
   ----------------------------
   Character: 'A'
   UTF-16 Code Unit: 0x0041
   UTF-8 Encoding: 41

   [ byte ]
     0x41

3. Display on Console (UTF-8 Decoding)
   -----------------------------------
   Console receives byte 0x41
   Decodes as 'A' using UTF-8

   [ Display ]
      'A'
```

#### Detailed Explanation with Example Character 'A'

1. **Internal Representation (UTF-16)**:
   * When we declare a `String` in Java with the character 'A', it is stored using UTF-16 encoding.
   * Example: `String example = "A";`
   * Internally, the character 'A' is represented by a single 16-bit code unit: `0x0041`.
2. **Conversion to Bytes (UTF-8)**:
   * When we print the `String`, Java converts the UTF-16 encoded `String` to bytes using the default charset (often UTF-8).
   * In UTF-8, the character 'A' (U+0041) is represented by a single byte: `0x41`.
3. **Display on Console (UTF-8 Decoding)**:
   * The console receives the byte `0x41`.
   * It decodes the byte using UTF-8 and displays the character 'A'.



## How Text Editors Handle Encoding

1. **Internal Representation**:
   * Text editors internally represent the text as a sequence of characters, often using an internal encoding like UTF-16 (as in Java's `String` class) or UTF-32 (common in some programming languages).
   * This internal representation allows the editor to handle and display the text correctly, regardless of the external file encoding.
2. **Conversion to Bytes**:
   * When we save the file, the editor converts this internal character representation to a byte sequence according to the specified encoding.
   * This process involves mapping each character to its corresponding byte (or bytes) in the target encoding. For example, in UTF-8, characters can be represented by one to four bytes.
3. **Writing to Disk**:
   * The resulting byte sequence is then written to the file on disk. The file's encoding determines how the text is stored.
   * If the file contains a BOM (Byte Order Mark), this marker is also written at the beginning of the file to indicate the encoding.

### Example Scenario

Imagine we have the following text in an editor:

```plaintext
plaintextCopy codeHello, World!
Accented characters: á, é, í, ó, ú, ü, ñ, ç
Cyrillic characters: А, Б, В, Г, Д, Е, Ж, З, И, Й
```

#### **Saving as UTF-8**

1. **Internal Representation**:
   * The text is represented internally, say, using UTF-16.
2. **Conversion to UTF-8**:
   * Each character is converted to UTF-8 bytes.
   * For example, "H" is `0x48`, "á" is `0xC3 0xA1`, and "А" is `0xD0 0x90`.
3. **Writing to Disk**:
   * The byte sequence `48 65 6C 6C 6F 2C 20 57 6F 72 6C 64 21 0A C3 A1 2C 20 65 2C 20 69 2C 20 6F 2C 20 75 2C 20 FC 2C 20 F1 2C 20 E7 0A D0 90 2C 20 D0 91 2C 20 D0 92 2C 20 D0 93 2C 20 D0 94 2C 20 D0 95 2C 20 D0 96 2C 20 D0 97 2C 20 D0 98 2C 20 D0 99` is written to the file.

#### **Opening the File with a Different Encoding (ISO-8859-1)**

1. **Reading Bytes**:
   * The editor reads the byte sequence from the file.
2. **Conversion to Characters**:
   * The editor interprets the bytes using ISO-8859-1 encoding rules.
   * Bytes that don’t map to valid ISO-8859-1 characters result in incorrect characters or replacement characters.

## Mismatched Encoding

When we save a file in a specific encoding and then try to open it in a different encoding, the interpretation of the byte sequences in the file can lead to various issues and unexpected results. Here’s what typically happens:

1. **Character Misinterpretation**:
   * Characters might be displayed incorrectly because the byte sequences are interpreted according to the rules of the wrong encoding.
   * For example, a file saved in UTF-8 might contain multibyte sequences for certain characters, but if opened as ISO-8859-1 (Latin-1), those byte sequences may be interpreted as different, often nonsensical, characters.
2. **Data Corruption**:
   * Special characters, symbols, and characters from non-Latin scripts are particularly prone to corruption. You might see replacement characters like `�` or completely incorrect characters.
   * For example, the Chinese characters in UTF-8 might turn into garbled text when opened in ISO-8859-1.
3. **Loss of Information**:
   * If the file is saved in a limited encoding like ISO-8859-1 and contains characters not supported by that encoding, those characters may be replaced or lost. When reopened in a different encoding, the original characters cannot be recovered.
4. **Readability Issues**:
   * Text might become unreadable, especially if it contains special symbols, accented characters, or non-Latin alphabets.
   * Plain ASCII characters (0-127) generally remain readable because they are commonly shared across many encodings.

## Preventing Encoding Issues

1. **Specify Encoding Explicitly**:
   * Always specify the encoding when saving and opening files, especially when dealing with non-ASCII characters.
   * Many text editors allow you to set the encoding when saving a file. For example, in VS Code or Sublime Text, you can choose the encoding from the save dialog.
2. **Use BOM for UTF Encodings**:
   * Use a Byte Order Mark (BOM) for UTF-16 and UTF-32 files to indicate the encoding explicitly.
   * UTF-8 BOM can also be used, although it’s less common and not recommended for compatibility reasons.
3. **Consistent Encoding**:
   * Ensure that both the producer and consumer of the file agree on the encoding.
   * Standardize on a widely supported encoding like UTF-8, which can handle a broad range of characters.
4. **File Metadata and Headers**:
   * Use metadata and headers in protocols (like HTTP headers or HTML meta tags) to specify the encoding.
   * Example: `<meta charset="UTF-8">` in HTML files.

## Defining encoding property in Springboot pom.xml file

In a Springboot application, the `pom.xml` file often contains a property to define the character encoding. This is usually set to `UTF-8` to ensure that the project uses UTF-8 encoding for source files and resources. The property being referred is `project.build.sourceEncoding` and `project.reporting.outputEncoding`

### Explanation of Properties

1. **`project.build.sourceEncoding`**:
   * This property defines the character encoding for the source code files.
   * Setting it to `UTF-8` ensures that the Java source files are read and compiled using UTF-8 encoding.
2. **`project.reporting.outputEncoding`**:
   * This property defines the character encoding for the output of reporting tasks (e.g., site generation).
   * Setting it to `UTF-8` ensures that the generated reports are encoded in UTF-8.

{% hint style="info" %}
The Maven Compiler Plugin does not automatically take the `project.build.sourceEncoding` property from the `<properties>` section. We need to explicitly configure the Maven Compiler Plugin to use this property.

However, setting the encoding in the `<properties>` section ensures that we can reuse this property value consistently across different plugins and configurations.&#x20;
{% endhint %}

### Why UTF-8?

* **Consistency**: Ensures that all parts of the project, including source code and reports, use the same character encoding.
* **Compatibility**: UTF-8 is a widely used encoding that supports all Unicode characters, making it a good choice for internationalization.
* **Best Practice**: Using UTF-8 helps avoid issues with character encoding mismatches, especially in projects that might involve multiple developers and different systems.

### Impact on a Spring Boot Application

Setting these properties in `pom.xml` file ensures that:

* The Maven compiler plugin uses UTF-8 to read and compile Java source files.
* Any generated reports (e.g., Javadoc, site reports) are encoded in UTF-8.
* Resources such as `application.properties` or `application.yml` are processed with the specified encoding, avoiding potential issues with special characters.

### Example with Maven Compiler Plugin

The `maven-compiler-plugin` is configured to use the source encoding property. It is configured to use UTF-8 to read and compile Java source files.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>example-project</artifactId>
    <version>1.0.0</version>

    <properties>
        <java.version>11</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <dependencies>
        <!-- Dependencies here -->
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                    <encoding>${project.build.sourceEncoding}</encoding>
                </configuration>
            </plugin>
            <!-- Other plugins -->
        </plugins>
    </build>

</project>

```



