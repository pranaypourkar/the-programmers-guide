# Extended ASCII

## About

Extended ASCII is a character encoding system that extends the original 7-bit ASCII (American Standard Code for Information Interchange) to include additional characters, utilizing the full 8-bit byte to provide a total of 256 possible characters. This extension was developed to accommodate characters from various languages and additional symbols not covered by the standard ASCII set.

## Characteristics of Extended ASCII

1. **8-bit Encoding**: While standard ASCII uses 7 bits, Extended ASCII uses 8 bits per character, allowing for 128 additional characters (codes 128-255).
2. **Backward Compatibility**: The first 128 characters (0-127) in Extended ASCII are identical to standard ASCII, ensuring compatibility with the original ASCII set.
3. **Varied Standards**: There is no single standard for Extended ASCII. Different systems and regions have developed their own variations, such as ISO-8859-1 (Latin-1), Windows-1252, and others.

## Common Extended ASCII Standards

### **ISO-8859-1 (Latin-1)**

* Widely used in Western European languages.
* Includes characters such as accented letters (é, ü), additional punctuation, and special symbols.
* ASCII characters (0-127) are identical to standard ASCII.
* Codes 128-255 include additional characters.

<table><thead><tr><th width="138">ASCII Code</th><th>Binary</th><th>Character</th><th>Description</th></tr></thead><tbody><tr><td>128</td><td>10000000</td><td>€</td><td>Euro Sign</td></tr><tr><td>129</td><td>10000001</td><td>ƒ</td><td>Florin Sign</td></tr><tr><td>130</td><td>10000010</td><td>„</td><td>Double Low-9 Quote</td></tr><tr><td>...</td><td>...</td><td>...</td><td>...</td></tr><tr><td>255</td><td>11111111</td><td>ÿ</td><td>Small Y with Diaeresis</td></tr></tbody></table>

<figure><img src="../../../../../../.gitbook/assets/image (429).png" alt=""><figcaption></figcaption></figure>

### **Windows-1252**

* An extension of ISO-8859-1 used in Microsoft Windows.
* Includes additional characters like the Euro sign (€), curly quotes, and other symbols.

<table><thead><tr><th width="132">ASCII Code</th><th>Binary</th><th>Character</th><th>Description</th></tr></thead><tbody><tr><td>128</td><td>10000000</td><td>€</td><td>Euro Sign</td></tr><tr><td>129</td><td>10000001</td><td></td><td>Undefined</td></tr><tr><td>130</td><td>10000010</td><td>‚</td><td>Single Low-9 Quote</td></tr><tr><td>...</td><td>...</td><td>...</td><td>...</td></tr><tr><td>255</td><td>11111111</td><td>Ÿ</td><td>Capital Y with Diaeresis</td></tr></tbody></table>

<figure><img src="../../../../../../.gitbook/assets/image (430).png" alt=""><figcaption></figcaption></figure>

### **IBM Code Pages**

* IBM developed several code pages for use in DOS, such as Code Page 437.
* Includes graphical symbols, box-drawing characters, and additional language-specific characters.

<table><thead><tr><th width="153">ASCII Code</th><th>Binary</th><th>Character</th><th>Description</th></tr></thead><tbody><tr><td>128</td><td>10000000</td><td>Ç</td><td>Capital C with Cedilla</td></tr><tr><td>129</td><td>10000001</td><td>ü</td><td>Small U with Diaeresis</td></tr><tr><td>130</td><td>10000010</td><td>é</td><td>Small E with Acute</td></tr><tr><td>...</td><td>...</td><td>...</td><td>...</td></tr><tr><td>255</td><td>11111111</td><td>ÿ</td><td>Small Y with Diaeresis</td></tr></tbody></table>

<figure><img src="../../../../../../.gitbook/assets/image (431).png" alt=""><figcaption></figcaption></figure>

## Advantages of Extended ASCII

1. **Broader Character Set**: Provides support for additional characters, symbols, and graphical elements not available in standard ASCII.
2. **Internationalization**: Enables representation of characters from various languages, facilitating better localization and internationalization of software and text.
3. **Backward Compatibility**: Maintains compatibility with standard ASCII, ensuring that existing ASCII text can still be interpreted correctly.

## Disadvantages of Extended ASCII

1. **Lack of Standardization**: Multiple versions of Extended ASCII exist, leading to inconsistencies and compatibility issues across different systems and platforms.
2. **Limited Scope**: Although Extended ASCII includes more characters than standard ASCII, it still does not support the full range of characters needed for all languages, particularly those with large character sets like Chinese, Japanese, and Korean.
3. **Superseded by Unicode**: Unicode, particularly UTF-8, has become the preferred encoding standard because it provides a comprehensive and consistent way to represent virtually all characters from all writing systems.

## Extended ASCII in Use

1. **Legacy Systems**: Many older systems and software still use Extended ASCII, especially those developed before the widespread adoption of Unicode.
2. **Specific Applications**: Some applications and protocols that require specific character sets continue to use Extended ASCII, such as certain email systems and file formats.
3. **Regional Standards**: Extended ASCII is often used in specific regions that developed their own standards to support local languages and symbols.
