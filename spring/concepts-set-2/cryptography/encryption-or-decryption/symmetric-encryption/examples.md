# Examples

## Scenario 1: Encrypt Decrypt 6 digit code using AES Algorithm

### Given:&#x20;

{% hint style="info" %}
**Inputs given to us ->**

Algorithm for the key: **AES**

Key size: **256**

Keystore type: **JCEKS**

Keystore Password: **changeit**

Key Password: **changeit**

Mode of operation: **CBC** (Cipher Block Chaining)

Padding Scheme: **PKCS7Padding**

Cryptographic Provider: **BC** (BouncyCastle)
{% endhint %}

### **Step 1:** Generate the Key Using `keytool`

Generate the AES key and store it in a JCEKS keystore with the `.jceks` extension.

```
keytool -genseckey -alias myaeskey -keyalg AES -keysize 256 -keystore mykeystore.jceks -storetype JCEKS
```

<figure><img src="../../../../../.gitbook/assets/image (221).png" alt=""><figcaption></figcaption></figure>

### Step 2: Export the Key from the Keystore

Since `keytool` does not directly support exporting secret keys, we need to use a Java program to export the key from the keystore.

```java
package encryption_decryption;

import java.io.FileOutputStream;
import java.security.Key;
import java.security.KeyStore;

public class ExportSecretKey {
    public static void main(String[] args) throws Exception {
        String alias = "myaeskey";
        String keystorePassword = "changeit";
        String keyPassword = "changeit";
        String storeBasePath = "/Users/pranayp-2529/Documents/Project/Personal/sample-java-project/src/main/resources/store/";
        String keystorePath = storeBasePath + "mykeystore.jceks";

        KeyStore keystore = KeyStore.getInstance("JCEKS");
        keystore.load(new java.io.FileInputStream(keystorePath), keystorePassword.toCharArray());

        Key key = keystore.getKey(alias, keyPassword.toCharArray());
        byte[] keyBytes = key.getEncoded();

        try (FileOutputStream fos = new FileOutputStream(storeBasePath + "myaeskey.key")) {
            fos.write(keyBytes);
        }
    }
}
```

<figure><img src="../../../../../.gitbook/assets/image (222).png" alt=""><figcaption></figcaption></figure>

A `.key` file, when it contains a symmetric key like an AES key, is typically in binary format. This binary format is not human-readable and cannot be meaningfully viewed or edited with a text editor.

#### **Convert Binary Key to Hex and Base64 for Viewing**

<figure><img src="../../../../../.gitbook/assets/image (223).png" alt="" width="563"><figcaption></figcaption></figure>

```
// HEX Key
b5928408ed8d846e5a12f5642d94808dd52c1b74bdfb6365a84f606fc1574cd0

// Base64 key
tZKECO2NhG5aEvVkLZSAjdUsG3S9+2NlqE9gb8FXTNA=
```

### Step 3: Load the key and use it for encryption decryption

#### Method 1: Using static Initialization Vector (IV)

```java
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.Security;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class EncryptionDecryption {
    public static final String TRANSFORMATION = "AES/CBC/PKCS7Padding";
    public static final String AES_ALGORITHM = "AES";
    public static final String PROVIDER = "BC";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static void main(String[] args) throws Exception {
        String storeBasePath = "/Users/pranayp/Documents/Project/Personal/sample-java-project/src/main/resources/store/";
        byte[] keyBytes = Files.readAllBytes(Paths.get(storeBasePath + "myaeskey.key"));
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, AES_ALGORITHM);

        String originalText = "123456";
        System.out.println("Original Text: " + originalText);
        // A static IV is used here for simplicity.
        // In a real application, we should use a securely generated random IV for each encryption operation.
        byte[] iv = new byte[16];
        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);

        byte[] encryptedText = encrypt(originalText.getBytes(), secretKey, ivParameterSpec);
        System.out.println("Encrypted Text: " + new String(encryptedText));

        String encryptedTextBase64 = Base64.getEncoder().encodeToString(encryptedText);
        System.out.println("Encrypted Text (Base64): " + encryptedTextBase64);

        byte[] decryptedText = decrypt(encryptedText, secretKey, ivParameterSpec);
        System.out.println("Decrypted Text: " + new String(decryptedText));
    }

    public static byte[] encrypt(byte[] plaintext, SecretKeySpec key, IvParameterSpec iv) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION, PROVIDER);
        cipher.init(Cipher.ENCRYPT_MODE, key, iv);
        return cipher.doFinal(plaintext);
    }

    public static byte[] decrypt(byte[] ciphertext, SecretKeySpec key, IvParameterSpec iv) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION, PROVIDER);
        cipher.init(Cipher.DECRYPT_MODE, key, iv);
        return cipher.doFinal(ciphertext);
    }
}
```

<figure><img src="../../../../../.gitbook/assets/image (224).png" alt="" width="563"><figcaption></figcaption></figure>

{% hint style="success" %}
Usually, Base64 excrypted text is shared among applications (say Web/Mobile Application sending to Backend in an API or vice versa)&#x20;
{% endhint %}

#### Method 2: Using dynamic Initialization Vector (IV) with key in hex format

{% hint style="success" %}
Always ensure that the IV used for encryption is the same one used for decryption. Proper handling and storage of the IV are essential for secure cryptographic operations.

Note that default blocksize of AES is 16 byte (128 bits)
{% endhint %}

```java
import static org.bouncycastle.util.encoders.Base64.encode;

import java.io.ByteArrayOutputStream;
import java.security.SecureRandom;
import java.security.Security;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.bouncycastle.util.encoders.Base64;
import org.bouncycastle.util.encoders.Hex;

public class EncryptionDecryptionWithHexKey {
    public static final String TRANSFORMATION = "AES/CBC/PKCS7Padding";
    public static final String AES_ALGORITHM = "AES";
    public static final String PROVIDER = "BC";

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static void main(String[] args) throws Exception {
        String keyInHexFormat = "b5928408ed8d846e5a12f5642d94808dd52c1b74bdfb6365a84f606fc1574cd0";

        String originalText = "123456";
        System.out.println("Original Text: " + originalText);

        String encryptedText = encrypt(originalText, keyInHexFormat);
        System.out.println("Encrypted Text: " + encryptedText);

        String decryptedText = decrypt(encryptedText, keyInHexFormat);
        System.out.println("Decrypted Text: " + decryptedText);
    }

    public static String encrypt(String plainText, String secretKeyInHex) throws Exception {
        SecretKey secret = new SecretKeySpec(Hex.decode(secretKeyInHex), AES_ALGORITHM);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION, PROVIDER);

        // Generate IV
        byte[] iv = new byte[cipher.getBlockSize()];
        new SecureRandom().nextBytes(iv);

        // Initialize the cipher in encryption mode with the secret key and the IV.
        cipher.init(Cipher.ENCRYPT_MODE, secret, new IvParameterSpec(iv));

        // Prepend IV to the ciphertext so that it can be extracted during decryption
        ByteArrayOutputStream os = new ByteArrayOutputStream();
        os.write(iv);
        os.write(cipher.doFinal(plainText.getBytes()));

        byte[] encodedBytes = os.toByteArray();

        // Encode to Base64 and return
        byte[] encodedBase64Bytes = encode(encodedBytes);
        return new String(encodedBase64Bytes);
    }

    public static String decrypt(String ivAndCipherBase64Text, String secretKeyInHex) throws Exception {
        byte[] ivAndCipherText = Base64.decode(ivAndCipherBase64Text);
        byte[] secretKey = Hex.decode(secretKeyInHex);

        SecretKey secret = new SecretKeySpec(secretKey, AES_ALGORITHM);
        Cipher cipher = Cipher.getInstance(TRANSFORMATION, PROVIDER);

        // Extract IV from the beginning of the ciphertext
        byte[] iv = Arrays.copyOfRange(ivAndCipherText, 0, cipher.getBlockSize());

        // Extract the actual ciphertext
        byte[] cipherText = Arrays.copyOfRange(ivAndCipherText, cipher.getBlockSize(), ivAndCipherText.length);

        // Initialize the cipher in decryption mode with the secret key and the extracted IV.
        cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(iv));

        // Decrypt the actual ciphertext
        byte[] decryptedBytes = cipher.doFinal(cipherText);

        return new String(decryptedBytes);
    }

}
```

<figure><img src="../../../../../.gitbook/assets/image (225).png" alt="" width="563"><figcaption></figcaption></figure>



