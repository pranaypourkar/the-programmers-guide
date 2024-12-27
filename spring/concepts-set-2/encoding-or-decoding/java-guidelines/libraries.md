# Libraries

## java.nio.charset

### About

The `java.nio.charset` package provides classes and interfaces for character encoding and decoding. It is part of the Java NIO (New I/O) package introduced in Java 1.4 to provide non-blocking I/O operations, among other features. Understanding character sets is crucial for applications dealing with text processing, file I/O, network communication, and internationalization.

### **Charset** (java.nio.charset.Charset):

Represents a named mapping between sequences of sixteen-bit Unicode characters and sequences of bytes. It defines methods for encoding, decoding, and working with character sets.

**Static Methods:**

* `static Charset forName(String charsetName)`: Returns a charset object for the given charset name.
* `static Charset defaultCharset()`: Returns the default charset of this Java virtual machine.
* `static SortedMap<String, Charset> availableCharsets()`: Returns a map of available charsets.
* `static boolean isSupported(String charsetName)`: Tells whether the named charset is supported.

**Methods:**

* `boolean contains(Charset cs)`: Tells whether or not this charset contains the given charset.
* `boolean canEncode()`: Tells whether or not this charset supports encoding.
* `String name()`: Returns the canonical name of this charset.
* `Set<String> aliases()`: Returns a set containing this charset's aliases.
* `String displayName()`: Returns a string that is the canonical name of this charset.
* `String displayName(Locale locale)`: Returns a localized string that is the canonical name of this charset.
* `boolean isRegistered()`: Tells whether or not this charset is known by its canonical name.
* `CharsetEncoder newEncoder()`: Constructs a new encoder for this charset.
* `CharsetDecoder newDecoder()`: Constructs a new decoder for this charset.
* `ByteBuffer encode(CharBuffer cb)`: Convenience method that encodes Unicode characters into bytes.
* `ByteBuffer encode(String str)`: Convenience method that encodes a string into bytes.
* `CharBuffer decode(ByteBuffer bb)`: Convenience method that decodes bytes into Unicode characters.
* `int compareTo(Charset that)`: Compares this charset to another.

### **CharsetDecoder** (java.nio.charset.CharsetDecoder):

Converts a byte sequence into a sequence of sixteen-bit Unicode characters.

**Methods:**

* `Charset charset()`: Returns the charset that created this decoder.
* `CharsetDecoder onMalformedInput(CodingErrorAction newAction)`: Changes the action for malformed-input errors.
* `CharsetDecoder onUnmappableCharacter(CodingErrorAction newAction)`: Changes the action for unmappable-character errors.
* `CodingErrorAction malformedInputAction()`: Returns the current malformed-input action.
* `CodingErrorAction unmappableCharacterAction()`: Returns the current unmappable-character action.
* `CharsetDecoder replaceWith(String newReplacement)`: Changes this decoder's replacement value.
* `String replacement()`: Returns this decoder's replacement value.
* `boolean isAutoDetecting()`: Tells whether or not this decoder implements an auto-detecting charset.
* `boolean isCharsetDetected()`: Tells whether or not a charset has yet been detected by this decoder.
* `Charset detectedCharset()`: Returns the charset detected by this decoder, if any.
* `CoderResult decode(ByteBuffer in, CharBuffer out, boolean endOfInput)`: Decodes one or more bytes into one or more characters.
* `CoderResult flush(CharBuffer out)`: Flushes this decoder.
* `CharsetDecoder reset()`: Resets this decoder, clearing any internal state.

### **CharsetEncoder** (java.nio.charset.CharsetEncoder):

Converts a sequence of sixteen-bit Unicode characters into a byte sequence.

**Methods:**

* `Charset charset()`: Returns the charset that created this encoder.
* `CharsetEncoder onMalformedInput(CodingErrorAction newAction)`: Changes the action for malformed-input errors.
* `CharsetEncoder onUnmappableCharacter(CodingErrorAction newAction)`: Changes the action for unmappable-character errors.
* `CodingErrorAction malformedInputAction()`: Returns the current malformed-input action.
* `CodingErrorAction unmappableCharacterAction()`: Returns the current unmappable-character action.
* `CharsetEncoder replaceWith(byte[] newReplacement)`: Changes this encoder's replacement value.
* `byte[] replacement()`: Returns this encoder's replacement value.
* `float averageBytesPerChar()`: Returns this encoder's average bytes-per-character.
* `float maxBytesPerChar()`: Returns this encoder's maximum bytes-per-character.
* `CoderResult encode(CharBuffer in, ByteBuffer out, boolean endOfInput)`: Encodes one or more characters into one or more bytes.
* `CoderResult flush(ByteBuffer out)`: Flushes this encoder.
* `CharsetEncoder reset()`: Resets this encoder, clearing any internal state.
* `boolean canEncode(char c)`: Tells whether or not this encoder can encode the given character.
* `boolean canEncode(CharSequence cs)`: Tells whether or not this encoder can encode the given character sequence.

### **CodingErrorAction** (java.nio.charset.CodingErrorAction):

Describes actions to be taken when encoding/decoding errors occur. Actions include `IGNORE`, `REPLACE`, and `REPORT`.

**Static Variables:**

* `static CodingErrorAction IGNORE`: Action indicating that a coding error is to be ignored.
* `static CodingErrorAction REPLACE`: Action indicating that a coding error is to be handled by dropping the erroneous input and replacing it with the current replacement byte or character sequence.
* `static CodingErrorAction REPORT`: Action indicating that a coding error is to be reported, either by returning a `CoderResult` object or by throwing a `CharacterCodingException`, depending upon the method implementing the coding process.

### **StandardCharsets** (java.nio.charset.StandardCharsets):

Defines constants for standard character sets such as UTF-8, UTF-16, ISO-8859-1, etc.

**Static Variables:**

* `static Charset US_ASCII`: Seven-bit ASCII, a.k.a. ISO646-US, a.k.a. the Basic Latin block of the Unicode character set.
* `static Charset ISO_8859_1`: ISO Latin Alphabet No. 1, a.k.a. ISO-LATIN-1.
* `static Charset UTF_8`: Eight-bit UCS Transformation Format.
* `static Charset UTF_16BE`: Sixteen-bit UCS Transformation Format, big-endian byte order.
* `static Charset UTF_16LE`: Sixteen-bit UCS Transformation Format, little-endian byte order.
* `static Charset UTF_16`: Sixteen-bit UCS Transformation Format, byte order identified by an optional byte-order mark.

### UnsupportedCharsetException (java.nio.charset.UnsupportedCharsetException)

**Constructor:**

* `UnsupportedCharsetException(String charsetName)`: Constructs an instance of this class.

**Methods:**

* `String getCharsetName()`: Retrieves the name of the unsupported charset.

### Examples

#### Encoding and Decoding Strings

```java
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

public class CharsetExample {
    public static void main(String[] args) {
        String input = "Hello, World!";
        Charset charset = StandardCharsets.UTF_8;

        // Encoding
        ByteBuffer byteBuffer = charset.encode(input);
        System.out.println("Encoded ByteBuffer: " + byteBuffer);

        // Decoding
        CharBuffer charBuffer = charset.decode(byteBuffer);
        String output = charBuffer.toString();
        System.out.println("Decoded String: " + output);
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (436).png" alt="" width="563"><figcaption></figcaption></figure>

#### Handling Encoding or Decoding Errors

```java
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CharsetEncoder;
import java.nio.charset.CodingErrorAction;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;

public class ErrorHandlingExample {
    public static void main(String[] args) {
        Charset charset = Charset.forName("US-ASCII");
        CharsetEncoder encoder = charset.newEncoder();
        CharsetDecoder decoder = charset.newDecoder();

        encoder.onMalformedInput(CodingErrorAction.REPLACE);
        encoder.onUnmappableCharacter(CodingErrorAction.REPLACE);
        decoder.onMalformedInput(CodingErrorAction.REPLACE);
        decoder.onUnmappableCharacter(CodingErrorAction.REPLACE);

        String input = "Hello, World! \u00A9";
        ByteBuffer byteBuffer = encoder.encode(CharBuffer.wrap(input));
        CharBuffer charBuffer = decoder.decode(byteBuffer);
        String output = charBuffer.toString();

        System.out.println("Original String: " + input);
        System.out.println("Encoded and Decoded String: " + output);
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (437).png" alt="" width="563"><figcaption></figcaption></figure>

#### Listing Available Charsets

```java
import java.nio.charset.Charset;
import java.util.SortedMap;

public class ListCharsets {
    public static void main(String[] args) {
        SortedMap<String, Charset> charsets = Charset.availableCharsets();
        for (String charsetName : charsets.keySet()) {
            System.out.println(charsetName);
        }
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (438).png" alt=""><figcaption></figcaption></figure>
