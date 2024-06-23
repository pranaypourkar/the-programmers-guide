# Examples

## Reading a UTF8 saved file with different encoding&#x20;

Below is an example of a text file content that includes a variety of characters from different character sets. This file contains English text, accented characters, Cyrillic characters, Greek characters, Chinese characters, and special symbols. While saving the file via editor, UTF8 is used.

**example.txt file contents**

```
Hello, World!
Accented characters: á, é, í, ó, ú, ü, ñ, ç
Cyrillic characters: А, Б, В, Г, Д, Е, Ж, З, И, Й
Greek characters: Α, Β, Γ, Δ, Ε, Ζ, Η, Θ, Ι, Κ
Chinese characters: 你好，世界！
Special symbols: €, ©, ™, ∑, √, ≈, π, ÷, ≤, ≥
Emoji: 😀, 🚀, 🌍, ❤️, 👍
```

{% file src="../../../.gitbook/assets/example.txt" %}

<pre class="language-java"><code class="lang-java"><strong>package encoding_decoding;
</strong>
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class EncodingDecodingFiles {
    public static void main(String [] args) {
        try {
            Path path = Path.of("/Users/pranay/Documents/Project/Personal/sample-java-project/src/main/resources/txt/example.txt");
            byte[] encoded = Files.readAllBytes(path);

            // UTF_8
            String string_utf8 = new String(encoded, StandardCharsets.UTF_8);
            System.out.println("\n-----Printing UTF_8 content-----");
            System.out.println(string_utf8);

            // UTF_16
            String string_utf16 = new String(encoded, StandardCharsets.UTF_16);
            System.out.println("\n-----Printing UTF_16 content-----");
            System.out.println(string_utf16);

            // ISO_8859_1
            String string_iso_8859_1 = new String(encoded, StandardCharsets.ISO_8859_1);
            System.out.println("\n-----Printing ISO_8859_1 content-----");
            System.out.println(string_iso_8859_1);

            // US_ASCII
            String string_ascii = new String(encoded, StandardCharsets.US_ASCII);
            System.out.println("\n-----Printing US_ASCII content-----");
            System.out.println(string_ascii);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
</code></pre>

<figure><img src="../../../.gitbook/assets/image (8).png" alt=""><figcaption></figcaption></figure>

## **Writing a string content to a file with specified encoding**

```java
package encoding_decoding;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class EncodingDecodingFiles {
    public static void main(String [] args) {
        try {
            String content = """
                Hello, World!
                Accented characters: á, é, í, ó, ú, ü, ñ, ç
                Cyrillic characters: А, Б, В, Г, Д, Е, Ж, З, И, Й
                Greek characters: Α, Β, Γ, Δ, Ε, Ζ, Η, Θ, Ι, Κ
                Chinese characters: 你好，世界！
                Special symbols: €, ©, ™, ∑, √, ≈, π, ÷, ≤, ≥
                Emoji: 😀, 🚀, 🌍, ❤️, 👍
                """;

            String baseFilePath = "/Users/pranayp/Documents/Project/Personal/sample-java-project/src/main/resources/txt/";
            // Save as UTF-8
            Path pathToSaveUtf8File = Path.of(baseFilePath + "example-UTF8.txt");
            Files.write(pathToSaveUtf8File, content.getBytes(StandardCharsets.UTF_8));

            // Save as ISO-8859-1 (Latin-1)
            Path pathToSaveIso88591File = Path.of(baseFilePath + "example-ISO-8859-1.txt");
            Files.write(pathToSaveIso88591File, content.getBytes(StandardCharsets.ISO_8859_1));

            // Save as Windows-1252
            Path pathToSaveWindows1252File = Path.of(baseFilePath + "example-Windows-1252.txt");
            Files.write(pathToSaveWindows1252File, content.getBytes(Charset.forName("Windows-1252")));

            // Save as UTF-16
            Path pathToSaveUtf16File = Path.of(baseFilePath + "example-UTF16.txt");
            Files.write(pathToSaveUtf16File, content.getBytes(StandardCharsets.UTF_16));
            
            // Save as ASCII
            Path pathToSaveAsciiFile = Path.of(baseFilePath + "example-ASCII.txt");
            Files.write(pathToSaveAsciiFile, content.getBytes(StandardCharsets.US_ASCII));

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

{% hint style="info" %}
Make sure to select the proper encoding scheme of the file editor to view the txt file.

ISO-8859-1 does not support characters like Cyrillic, Greek, Chinese, or Emoji. Unsupported characters will be replaced with a placeholder (usually `?`)

Similar to ISO-8859-1, Windows-1252 has limited support for non-Western characters
{% endhint %}

<figure><img src="../../../.gitbook/assets/image (6).png" alt="" width="350"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/example-ISO-8859-1.txt" %}

<figure><img src="../../../.gitbook/assets/image (1).png" alt="" width="375"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/example-UTF8.txt" %}

<figure><img src="../../../.gitbook/assets/image (5).png" alt="" width="375"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/example-UTF16.txt" %}

<figure><img src="../../../.gitbook/assets/image (3).png" alt="" width="375"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/example-Windows-1252.txt" %}

<figure><img src="../../../.gitbook/assets/image (4).png" alt="" width="375"><figcaption></figcaption></figure>

{% file src="../../../.gitbook/assets/example-ASCII.txt" %}

<figure><img src="../../../.gitbook/assets/image (7).png" alt="" width="375"><figcaption></figcaption></figure>

## Reading the above saved file in respective character set

```java
package encoding_decoding;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class EncodingDecodingFiles {
    public static void main(String [] args) {
        try {
            String baseFilePath = "/Users/pranayp@backbase.com/Documents/Project/Personal/sample-java-project/src/main/resources/txt/";

            // UTF_8
            Path path1 = Path.of(baseFilePath + "example-UTF8.txt");
            byte[] encoded1 = Files.readAllBytes(path1);
            String string1 = new String(encoded1, StandardCharsets.UTF_8);
            System.out.println("\n-----Printing UTF_8 content-----");
            System.out.println(string1);

            // UTF_16
            Path path2 = Path.of(baseFilePath + "example-UTF16.txt");
            byte[] encoded2 = Files.readAllBytes(path2);
            String string2 = new String(encoded2, StandardCharsets.UTF_16);
            System.out.println("\n-----Printing UTF_16 content-----");
            System.out.println(string2);

            // ISO-8859-1
            Path path3 = Path.of(baseFilePath + "example-ISO-8859-1.txt");
            byte[] encoded3 = Files.readAllBytes(path3);
            String string3 = new String(encoded3, StandardCharsets.ISO_8859_1);
            System.out.println("\n-----Printing ISO_8859_1 content-----");
            System.out.println(string3);

            // US_ASCII
            Path path4 = Path.of(baseFilePath + "example-ASCII.txt");
            byte[] encoded4 = Files.readAllBytes(path4);
            String string4 = new String(encoded4, StandardCharsets.US_ASCII);
            System.out.println("\n-----Printing US_ASCII content-----");
            System.out.println(string4);

            // Windows-1252
            Path path5 = Path.of(baseFilePath + "example-Windows-1252.txt");
            byte[] encoded5 = Files.readAllBytes(path5);
            String string5 = new String(encoded5, Charset.forName("Windows-1252"));
            System.out.println("\n-----Printing Windows-1252 content-----");
            System.out.println(string5);

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

<div>

<figure><img src="../../../.gitbook/assets/image (200).png" alt="" width="375"><figcaption></figcaption></figure>

 

<figure><img src="../../../.gitbook/assets/image (202).png" alt="" width="375"><figcaption></figcaption></figure>

</div>







