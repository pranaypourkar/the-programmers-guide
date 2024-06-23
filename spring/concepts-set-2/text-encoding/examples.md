# Examples

## Reading a File with Specified Encoding

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

```java
package encoding_decoding;

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
```

<figure><img src="../../../.gitbook/assets/image (199).png" alt=""><figcaption></figcaption></figure>

## **Writing a File with Specified Encoding**







