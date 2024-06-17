# Base32

## About

Base32 is a method of encoding binary data into a text format using a set of 32 ASCII characters. This encoding is particularly useful for cases where data integrity and compatibility with text-based systems are important. Base32 is often used in applications like QR codes, DNS records, and secret keys in two-factor authentication systems.

## Characteristics of Base32

* **Character Set**: Base32 uses a set of 32 characters, typically the uppercase letters A-Z and the digits 2-7. This avoids confusion between similar-looking characters such as 'I' and '1' or 'O' and '0'.
* **Padding**: Base32 encoded output is often padded with '=' characters to make the final output length a multiple of 8.
* **Efficiency**: Base32 is less space-efficient than Base64 but is more human-readable and suitable for use in systems where case-insensitivity or URL safety is required.

## Base32 Mapping

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="563"><figcaption></figcaption></figure>

## Base32 Encoding Process

1. **Grouping**: The binary data is divided into groups of 5 bits.
2. **Mapping**: Each 5-bit group is mapped to a corresponding Base32 character.
3. **Padding**: If the final group has fewer than 5 bits, it is padded with zero bits, and the resulting Base32 string is padded with '=' to make its length a multiple of 8.

## Base32 Decoding Process

1. **Remove Padding**: Remove any '=' padding characters.
2. **Grouping**: Convert each Base32 character back to its corresponding 5-bit binary representation.
3. **Reconstruct**: Combine the 5-bit groups into the original binary data.



