# Base Encoding

## About

Base encoding is a method of converting binary data (like images, audio, or any data stream) into an ASCII string format using a specific alphabet. This technique is primarily used to encode binary data into a text format that can be easily transmitted over media that are designed to handle text.

## Types of Base Encodings

### **Base16 (Hexadecimal) (2^4)**

A more human-readable format that uses a 16-character alphabet (0-9, A-F) to represent each byte of binary data as two hexadecimal digits. While not as compact as BASE64, it's useful for debugging and visualization. It encodes binary data using 16 different ASCII characters (0-9, A-F) and Each byte (8 bits) is represented by two hexadecimal characters.&#x20;

It is commonly used in programming and computer science for representing binary data in a human-readable form.

#### **Example:**

* Binary: <mark style="background-color:purple;">`0101`</mark><mark style="background-color:orange;">`0100`</mark> (8 bits)
* Hexadecimal: `54`

### **Base32 (2^5)**

Utilizes a 32-character alphabet (A-Z, a-z, 2-7) and is more compact than BASE64, often used for URL-safe encoding (avoids characters like '+' and '/' that have special meanings in URLs). It encodes binary data using 32 ASCII characters (A-Z, 2-7) and each group of 5 bits is represented as a single Base32 character.

Often used in applications like QR codes, DNS, and secret keys in two-factor authentication.

**Example:**

* Binary: `0`<mark style="background-color:red;">`10101`</mark><mark style="background-color:orange;">`00010`</mark><mark style="background-color:purple;">`10101`</mark> (16 bits)
* Base32: `KRUG`

### **Base64 (2^6)**

The most widely used BASE encoding, it employs a 64-character alphabet (A-Z, a-z, 0-9, +, /) to represent the binary data. Since BASE64 encoding expands the data by about 33%, it's not ideal for size-constrained applications. It encodes binary data using 64 ASCII characters (A-Z, a-z, 0-9, +, /) and each group of 6 bits is represented as a single Base64 character.

Widely used in email via MIME, XML data, and embedding image data in HTML or CSS.

**Example:**

* Binary: <mark style="background-color:red;">`0101`</mark><mark style="background-color:purple;">`010001`</mark><mark style="background-color:blue;">`101000`</mark> (16 bits)
* Base64: `VGh`

{% hint style="info" %}
**Base64 Padding**

Ensures the encoded output length is a multiple of 4. And uses `=` as a padding character.
{% endhint %}

### **Base85**

It encodes binary data using 85 ASCII characters. More efficient than Base64, reducing the overhead of encoded data.

Used in applications like Adobe’s PostScript and PDF file formats.

**Example:**

* Binary: `0101010001101000` (16 bits)
* Base85: `n<$`

## Use Cases for Base Encoding

1. **Email Transmission**: Base64 is used to encode binary attachments in MIME format.
2. **Data URLs**: Embedding small data files directly in HTML or CSS.
3. **QR Codes**: Base32 or Base64 encodings to compactly represent data.
4. **Cryptographic Keys**: Base32 or Base64 for sharing keys and secrets in a text-based format.







