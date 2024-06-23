# Encoding and Decoding in Java

## About

Java provides support for Base32 encoding and decoding through third-party libraries like Apache Commons Codec. The standard Java library (`java.util.Base64`) does not include Base32, so an external library is typically used.

## Maven POM Dependency

### Apache Commons Codec

```xml
<dependency>
    <groupId>commons-codec</groupId>
    <artifactId>commons-codec</artifactId>
    <version>1.15</version>
</dependency>
```

## Encoding Example

```java
package com.org.example;

import org.apache.commons.codec.binary.Base32;

public class Application {

    public static void main(final String[] args) {

        Base32 base32 = new Base32();
        String originalString = "Hello, World!";
        byte[] encodedBytes = base32.encode(originalString.getBytes());
        
        String encodedString = new String(encodedBytes);
        
        System.out.println("Encoded String: " + encodedString);
    }
}
```

<figure><img src="../../../../../../.gitbook/assets/image (193).png" alt="" width="560"><figcaption></figcaption></figure>

## Decoding Example

```java
package com.backbase.snbdv;

import org.apache.commons.codec.binary.Base32;

@SpringBootApplication
public class Application {

    public static void main(final String[] args) {
        Base32 base32 = new Base32();
        String encodedString = "JBSWY3DPEB3W64TMMQ======";
        byte[] decodedBytes = base32.decode(encodedString);

        String decodedString = new String(decodedBytes);

        System.out.println("Decoded String: " + decodedString);
    }
}
```

<figure><img src="../../../../../../.gitbook/assets/image (194).png" alt="" width="560"><figcaption></figcaption></figure>

