# Encoding | Decoding

## Encoding

### About

Encoding in Java refers to the process of converting characters (letters, numbers, symbols etc) from human readable form into a sequence of bytes that computers can understand and manipulate. Text encoding is crucial for handling different character sets and ensuring that text data is correctly interpreted and displayed across various systems and platforms. It establishes a mapping between characters and their corresponding codes. Different encoding schemes define different mappings.

For example, encoding a random string to binary ASCII code typically requires an ASCII table with the respective decimal values of each of the string's characters. After encoded, digital devices can process, store or transmit these codes. However, displaying ASCII to human operators of such devices involves decoding the codes from binary to a readable version.

### Use Cases of Encoding

1. **Data Storage**:
   * **Database Storage**: Ensuring text is stored in a consistent encoding format, such as UTF-8, to support a wide range of characters.
   * **File Storage**: Writing and reading files in a specific encoding to maintain text integrity.
2. **Data Transmission**:
   * **Network Communication**: Encoding text data before sending it over the network to ensure it is correctly received and interpreted.
   * **APIs and Web Services**: Ensuring that text data sent and received through RESTful APIs or SOAP services is correctly encoded and decoded.
3. **Internationalization (i18n)**:
   * Supporting multiple languages by encoding text in Unicode, which covers most of the world's writing systems.
4. **Data Interchange**:
   * **XML/JSON Processing**: Encoding and decoding text data in XML or JSON formats to ensure compatibility across different systems.

### Benefits of Encoding

**Consistency**: Provides a standardized way to represent text, ensuring that data remains consistent across different systems and platforms.

**Interoperability**: Facilitates the exchange of text data between different systems, applications, and languages.

**Data Integrity**: Ensures that text data is correctly interpreted and displayed, preventing issues like character corruption or loss of information.

**Support for Multiple Languages**: Allows applications to support and display text in various languages, enhancing global reach and usability.

{% hint style="info" %}
**What is Character Set ?**

It is a collection of symbols and their corresponding unique codes. Common examples include: US-ASCII (American Standard Code for Information Interchange), ISO-8859-1 (Latin-1), UTF-8 (Unicode Transformation Format-8), UTF-16 (Unicode Transformation Format-16).

`java.nio.charset.StandardCharsets` class is introduced in Java 7 (JDK 1.7) that provides a convenient way to access a set of standard charsets commonly used for text encoding and decoding. These charsets are guaranteed to be available on all Java platforms, ensuring consistent behavior regardless of the underlying operating system or environment.

It defines static final fields for each standard charset, providing human-readable names for easy access.

* `UTF_8`: The most widely used and recommended encoding for modern applications, supporting a vast range of characters.
* `ISO_8859_1` (Latin-1): Covers basic Western European characters but is limited for languages with additional symbols.
* `US_ASCII`: The most basic encoding, suited only for English and some Western European languages.
* `UTF_16`: Less common than UTF-8, often used internally by Java for string representation.
* `UTF_16BE`: A variant of UTF-16 with big-endian byte order.
* `UTF_16LE`: A variant of UTF-16 with little-endian byte order.
{% endhint %}

### Best Practices

1. **Use Standard Encodings**: Prefer UTF-8 for its compatibility and efficiency.
2. **Explicitly Specify Encodings**: Avoid relying on platform default encodings.
3. **Validate Input**: Ensure that text data conforms to the expected encoding.
4. **Handle Exceptions**: Gracefully handle `UnsupportedEncodingException` and other I/O exceptions.

### Troubleshooting Common Issues

1. **Character Corruption**: Ensure that the same encoding is used for both encoding and decoding.
2. **UnsupportedEncodingException**: Verify the availability of the specified encoding.
3. **Data Loss**: Check for proper handling of character sets that require more than one byte.
4. **File Opening Issues:** Some applications might have default encoding assumptions. If a file doesn't open correctly, try specifying the encoding during opening.

### Handling Text Encoding in Java

```java
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

public class EncodingExample {
    public static void main(String[] args) {
        String text = "This is some text with special characters: ñ, ö, €";

        byte[] utf8Bytes = text.getBytes(StandardCharsets.UTF_8);
        byte[] utf16Bytes = text.getBytes(StandardCharsets.UTF_16);
        byte[] asciiBytes = text.getBytes(StandardCharsets.US_ASCII);

        // From readable string to decimal format
        // Refer to the respective encoding scheme table for corresponding character code
        System.out.println("UTF-8 decimal form: " + Arrays.toString(utf8Bytes));
        System.out.println("UTF-16 decimal form: " + Arrays.toString(utf16Bytes));
        System.out.println("US-ASCII decimal form: " + Arrays.toString(asciiBytes));

        // From binary form to human-readable
        // Look up the respective scheme table to convert decimal codes to a readable string
        System.out.println("UTF-8 Encoded: " + new String(utf8Bytes, StandardCharsets.UTF_8));
        System.out.println("UTF-16 Encoded: " + new String(utf16Bytes, StandardCharsets.UTF_16));
        System.out.println("US-ASCII Encoded: " + new String(asciiBytes, StandardCharsets.US_ASCII));
    }
}
```

<figure><img src="../../../.gitbook/assets/image (210).png" alt=""><figcaption></figcaption></figure>

### Handling BASE Encoding in Java

```java
import java.util.Base64;

public class Base64Example {

    public static void main(String[] args) {
        String text = "This is some text data for Base64 encoding";

        // Encode to Base64 string
        byte[] data = text.getBytes();
        String encodedString = Base64.getEncoder().encodeToString(data);
        System.out.println("Base64 Encoded: " + encodedString);

        // Decode from Base64 String
        byte[] decodedData = Base64.getDecoder().decode(encodedString);
        String decodedText = new String(decodedData);
        System.out.println("Decoded Text: " + decodedText);
    }
}
```

<figure><img src="../../../.gitbook/assets/image (208).png" alt="" width="563"><figcaption></figcaption></figure>

## Decoding

### About

Decoding is the process of reversing the steps taken during encoding. It involves converting the encoded data back into its original form, ensuring it's interpreted and displayed correctly by the receiving system or application. Basically, it is a process of converting encoded byte data back into human-readable text.

### Use Cases of Decoding

**Data Retrieval**: Decoding data retrieved from databases, files, or network responses.

* **Data Display**: Ensuring correctly interpreted and displayed text in user interfaces.
* **Data Parsing**: Processing text data in various formats like JSON, XML, and HTML.

### **Benefits:**

* **Data Integrity**: Ensures the accurate interpretation of byte data.
* **Interoperability**: Allows for seamless data exchange across different systems.
* **Internationalization**: Supports multiple languages and character sets.

### Handling Text Decoding in Java

```java
import java.io.UnsupportedEncodingException;

public class DecodingExample {
    public static void main(String[] args) {
        byte[] utf8Bytes = {72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33};
        
        try {
            String decodedText = new String(utf8Bytes, "UTF-8");
            System.out.println("Decoded Text: " + decodedText);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }
}
```

<figure><img src="../../../.gitbook/assets/image (212).png" alt="" width="272"><figcaption></figcaption></figure>

## Common Text Encodings

1. **UTF-8**: A widely used encoding that supports all Unicode characters. It's efficient and backward-compatible with ASCII.
2. **UTF-16**: Encodes characters using one or two 16-bit units, often used in Java's internal string representation.
3. **ISO-8859-1 (Latin-1)**: An 8-bit encoding that covers Western European languages.
4. **US-ASCII**: A 7-bit encoding covering the English alphabet and basic symbols.
5. **UTF-32**: Fixed-length encoding using 4 bytes per character, simpler but less space-efficient.
6. **Windows-1252 (CP1252):** An 8-bit character encoding based on ISO-8859-1, with additional characters for commonly used symbols and Central/Eastern European languages. Text files and system encoding on older Windows systems (may not be fully compatible with other platforms).

## **Common BASE Encodings**

* **Base64:** Most widely used, encodes data into a format using A-Z, a-z, 0-9, +, /.
* **Base32:** More compact than Base64, uses A-Z, a-z, 2-7 (URL-safe for embedding in URLs).
* **Base16 (Hexadecimal):** Uses 0-9, A-F to represent each byte of data as two hexadecimal digits (mainly for debugging or visualization).

## **Text Encodings vs. BASE Encodings**

* **Text Encodings:** Define how characters (letters, numbers, symbols) are represented using a set of numerical codes (e.g., UTF-8 for various languages, ISO-8859-1 for Western European languages).
* **BASE Encodings:** Encode binary data (not just text) into a human-readable format using a limited set of characters (e.g., Base64 with A-Z, a-z, 0-9, +, /). BASE encodings primarily focus on representing arbitrary binary data (like images, audio, compressed files) in a text-based format suitable for transmission or storage. While they can be used for text data as well, it's not their primary purpose.

{% hint style="info" %}
**How BASE Encodings Relate to Text Encodings ?**

* After BASE decoding (converting back from the encoded format), the resulting data might be in a specific text encoding depending on the original data.
* For example, if we Base64-encoded a plain text file in UTF-8, decoding it would provide the original text data still encoded in UTF-8.
{% endhint %}

