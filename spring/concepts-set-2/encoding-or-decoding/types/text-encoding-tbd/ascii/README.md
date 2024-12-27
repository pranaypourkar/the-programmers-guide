# ASCII

## About ASCII

ASCII (American Standard Code for Information Interchange) is a character encoding standard used for representing text in computers and other devices that use text. It was developed in the early 1960s and has become one of the most widely used character encoding systems.

{% hint style="info" %}
ASCII was first published as a standard in 1963 by the American Standards Association (ASA), which later became the American National Standards Institute (ANSI). It was developed to create a common standard for text representation and communication between different computer systems.
{% endhint %}

## Characteristics of ASCII

* **7-bit Encoding**: ASCII uses 7 bits to represent each character, allowing for 128 unique symbols.
* **Character Set**: Includes control characters, punctuation, digits, uppercase and lowercase English letters, and some special characters.
* **Compatibility**: ASCII is the foundation for many other character encoding systems, such as UTF-8 and ISO/IEC 8859-1.

## ASCII Table

The ASCII table is divided into two main sections:

1. **Control Characters** (0–31 and 127)
2. **Printable Characters** (32–126)

### **Control Characters (0-31 and 127)**

These characters are non-printable and used for controlling devices (e.g., printers) or formatting text.

| ASCII Code | Binary  | Character | Description     |
| ---------- | ------- | --------- | --------------- |
| 0          | 0000000 | NUL       | Null character  |
| 1          | 0000001 | SOH       | Start of Header |
| 2          | 0000010 | STX       | Start of Text   |
| ...        | ...     | ...       | ...             |
| 10         | 0001010 | LF        | Line Feed       |
| ...        | ...     | ...       | ...             |
| 27         | 0011011 | ESC       | Escape          |
| ...        | ...     | ...       | ...             |
| 127        | 1111111 | DEL       | Delete          |

### **Printable Characters (32-126)**

These characters include punctuation, digits, uppercase and lowercase letters.

| ASCII Code | Binary   | Character | Description      |
| ---------- | -------- | --------- | ---------------- |
| 32         | 00100000 | SPACE     | Space            |
| 33         | 00100001 | !         | Exclamation mark |
| 34         | 00100010 | "         | Double quote     |
| ...        | ...      | ...       | ...              |
| 48         | 00110000 | 0         | Digit 0          |
| 49         | 00110001 | 1         | Digit 1          |
| ...        | ...      | ...       | ...              |
| 65         | 01000001 | A         | Uppercase A      |
| 66         | 01000010 | B         | Uppercase B      |
| ...        | ...      | ...       | ...              |
| 97         | 01100001 | a         | Lowercase a      |
| 98         | 01100010 | b         | Lowercase b      |
| ...        | ...      | ...       | ...              |
| 126        | 01111110 | \~        | Tilde            |

<figure><img src="../../../../../../.gitbook/assets/image (428).png" alt=""><figcaption></figcaption></figure>

## Usage of ASCII

1. **Text Files**: Plain text files often use ASCII encoding, ensuring compatibility across different text editors and operating systems.
2. **Programming**: Source code files are typically stored using ASCII or a compatible encoding.
3. **Communication Protocols**: Many communication protocols use ASCII for command and data representation, such as HTTP and SMTP.
4. **Data Storage**: ASCII is used in various data storage formats, especially older or simpler formats like CSV.

{% hint style="info" %}
Text files themselves do not typically store encoding information within their content. Instead, the encoding information is often inferred by the application reading the file, specified by external metadata, or based on conventions and standards. Here’s a detailed look at how text encoding is managed:

* **Incorrect Encoding:** If a file is encoded in UTF-8 and opened with an editor assuming ISO-8859-1 (Latin-1), special characters might appear incorrectly.
* **"Garbage Characters":** Unrecognizable characters might appear if the wrong encoding is used.

**How Text Encoding is Determined**

1. **External Metadata**
   * **File Metadata**: Some operating systems and file systems may support metadata that indicates the encoding of a file.
   * **Protocol Headers**: In contexts like HTTP or email, the encoding may be specified in headers (e.g., `Content-Type: text/plain; charset=UTF-8`).
2. **BOM (Byte Order Mark)**
   * **Unicode Text Files**: A Byte Order Mark (BOM) is a special marker at the beginning of a text file that indicates the encoding. For example:
     * UTF-8 BOM: `EF BB BF`
     * UTF-16 BOM: `FE FF` (Big Endian) or `FF FE` (Little Endian)
   * **Presence of BOM**: The presence of a BOM can help a text editor or application determine the file’s encoding.
3. **Conventions and Heuristics**
   * **File Extension**: Certain file extensions might suggest a particular encoding (e.g., `.txt` typically implies ASCII or UTF-8).
   * **Content Analysis**: Some applications use heuristics to guess the encoding based on the content of the file. This can involve analyzing byte patterns or using algorithms to detect common encoding signatures.
4. **Configuration**
   * **User Settings**: Text editors and development environments often allow users to specify the encoding to use when opening or saving a file.
   * **Application Defaults**: Some applications have default encodings they assume when no other information is provided (e.g., UTF-8 for many modern applications).

**Managing Text Encoding in Different Contexts**

1. **Text Editors**
   * Many text editors allow users to select or change the encoding when opening or saving a file. Popular editors like VS Code, Sublime Text, and Notepad++ provide options to specify or convert file encodings.
2. **Web Browsers**
   * HTML documents can specify their encoding using the `<meta charset="UTF-8">` tag within the document’s head section.
   * Web servers communicate the encoding through HTTP headers.
3. **Programming Languages**
   * Most programming languages provide libraries or functions to specify encoding when reading from or writing to text files. For example, in Python, you can specify the encoding with `open('file.txt', 'r', encoding='utf-8')`.
{% endhint %}

## Pros and Cons of ASCII

### **Example 1: Simplicity and Efficiency**

**Pro**: ASCII's simplicity makes it easy to debug and understand.

* Example: A text file containing the string "Hello" can be easily read and interpreted in ASCII as:
  * H: 72
  * e: 101
  * l: 108
  * l: 108
  * o: 111

**Con**: The same simplicity can be a limitation when more complex character representations are needed.

* Example: To represent the same text in Chinese or Arabic, ASCII is insufficient, and a more comprehensive encoding like UTF-8 is required.

### **Example 2: Standardization and Compatibility**

**Pro**: ASCII's standardization ensures that a plain text file created on one system can be read on another without issues.

* Example: A configuration file in ASCII can be shared between Unix and Windows systems without any encoding-related problems.

**Con**: ASCII's lack of support for characters beyond its basic set can cause problems in global applications.

* Example: An ASCII-encoded document cannot include characters like 'é' or 'ü', which are common in many European languages.

### **Example 3: Legacy System Support**

**Pro**: Many older systems and protocols are designed around ASCII.

* Example: Protocols like SMTP (for email) and HTTP use ASCII for command and data representation, ensuring broad compatibility with legacy systems.

**Con**: Modern systems that need to interact with these older protocols often have to include additional handling for ASCII, complicating their design.

* Example: Modern web servers need to support ASCII for HTTP headers but also need to handle UTF-8 for content, adding complexity to their implementation.
