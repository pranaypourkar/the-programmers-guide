# Examples

## Scenario 1: Encrypt Decrypt 6 digit code using RSA Algorithm

### Given

{% hint style="info" %}
Inputs given to us:

* **Algorithm for the key**: RSA
* **Key size**: 2048 (typical for RSA)
* **Keystore type**: JKS (Java KeyStore)
* **Keystore Password**: changeit
* **Key Password**: changeit
* **Padding Scheme**: PKCS1Padding
* **Cryptographic Provider**: BC (BouncyCastle)
{% endhint %}

### Step 1: Generate the Key Pair Using Keytool

Generate an RSA key pair and store it in a keystore.

```sh
keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -validity 365 -keystore mykeystore.jks -storetype JKS -storepass changeit -keypass changeit -dname "CN=example.com, OU=IT, O=Example Corp, L=San Francisco, ST=CA, C=US"
```

* `-genkeypair`: Generates a key pair (public and private key).
* `-alias mykey`: The alias for the key pair.
* `-keyalg RSA`: The algorithm for the key.
* `-keysize 2048`: The size of the key.
* `-validity 365`: The validity of the key in days.
* `-keystore mykeystore.jks`: The keystore file to store the key pair.
* `-storetype JKS`: The type of the keystore.
* `-storepass changeit`: The password for the keystore.
* `-keypass changeit`: The password for the key.
* `-dname`: The Distinguished Name (DN) for the certificate.

<figure><img src="../../../../../.gitbook/assets/image (2) (1).png" alt=""><figcaption></figcaption></figure>

### **Step 2: Export the Public Key**

{% hint style="warning" %}
This step is optional. Instead of exporting the key, we can directly both private and public key from the keystore. See Step 4 for more details.
{% endhint %}

Export the public key to a file.

```sh
keytool -exportcert -alias mykey -keystore mykeystore.jks -file publickey.cer -storepass changeit
```

* `-exportcert`: Exports the certificate (public key).
* `-alias mykey`: The alias of the key pair.
* `-keystore mykeystore.jks`: The keystore file.
* `-file publickey.cer`: The output file for the public key.
* `-storepass changeit`: The password for the keystore.

<figure><img src="../../../../../.gitbook/assets/image (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

### Step 3: **Encrypt Decrypt the 6-Digit Code**

Encrypt the 6-digit code using the public key and Decrypt via private key.

```java
import java.io.FileInputStream;
import java.security.Security;
import java.security.cert.Certificate;
import java.security.cert.CertificateFactory;
import java.util.Base64;
import javax.crypto.Cipher;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.*;

public class EncryptionDecryptionRSA {

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    public static void main(String[] args) throws Exception {
        String storeBasePath = "/Users/pranayp/Documents/Project/Personal/sample-java-project/src/main/resources/store/";

        PublicKey publicKey = getPublicKey(storeBasePath + "publickey.cer");
        PrivateKey privateKey = getPrivateKey(storeBasePath + "mykeystore.jks", "mykey", "changeit", "changeit");

        String plaintext = "123456";
        System.out.println("Original: " + plaintext);

        String encrypted = encrypt(plaintext, publicKey);
        System.out.println("Encrypted: " + encrypted);

        String decrypted = decrypt(encrypted, privateKey);
        System.out.println("Decrypted: " + decrypted);
    }

    public static String encrypt(String plaintext, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding", "BC");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(plaintext.getBytes());
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    public static String decrypt(String encryptedText, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding", "BC");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedText));
        return new String(decryptedBytes);
    }

    public static PrivateKey getPrivateKey(String keystoreFile, String alias, String storePassword, String keyPassword)
        throws Exception {
        KeyStore keystore = KeyStore.getInstance("JKS");
        keystore.load(new FileInputStream(keystoreFile), storePassword.toCharArray());
        return (PrivateKey) keystore.getKey(alias, keyPassword.toCharArray());
    }

    public static PublicKey getPublicKey(String filename) throws Exception {
        CertificateFactory certFactory = CertificateFactory.getInstance("X.509");
        Certificate cert = certFactory.generateCertificate(new FileInputStream(filename));
        return cert.getPublicKey();
    }
}
```

### Step 4: **Encrypt Decrypt the 6-Digit Code without using separately generated certificate key**

```java
import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.Security;
import java.security.cert.Certificate;
import java.util.Base64;
import javax.crypto.Cipher;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class EncryptionDecryptionRSA2 {

    static {
        Security.addProvider(new BouncyCastleProvider());
    }

    private static final String KEYSTORE_TYPE = "JKS";
    private static final String STORE_BASE_PATH = "/Users/pranayp/Documents/Project/Personal/sample-java-project/src/main/resources/store/";
    private static final String KEYSTORE_FILE = STORE_BASE_PATH + "mykeystore.jks";
    private static final String KEYSTORE_PASSWORD = "changeit";
    private static final String KEY_ALIAS = "mykey";
    private static final String KEY_PASSWORD = "changeit";


    public static void main(String[] args) {
        try {
            KeyStore keystore = loadKeyStore();
            PublicKey publicKey = getPublicKey(keystore);
            PrivateKey privateKey = getPrivateKey(keystore);

            String plaintext = "123456";
            System.out.println("Original: " + plaintext);

            String encrypted = encrypt(plaintext, publicKey);
            System.out.println("Encrypted: " + encrypted);

            String decrypted = decrypt(encrypted, privateKey);
            System.out.println("Decrypted: " + decrypted);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static KeyStore loadKeyStore() throws Exception {
        KeyStore keystore = KeyStore.getInstance(KEYSTORE_TYPE);
        try (FileInputStream fis = new FileInputStream(KEYSTORE_FILE)) {
            keystore.load(fis, KEYSTORE_PASSWORD.toCharArray());
        }
        return keystore;
    }

    public static PublicKey getPublicKey(KeyStore keystore) throws Exception {
        Certificate cert = keystore.getCertificate(KEY_ALIAS);
        return cert.getPublicKey();
    }

    public static PrivateKey getPrivateKey(KeyStore keystore) throws Exception {
        return (PrivateKey) keystore.getKey(KEY_ALIAS, KEY_PASSWORD.toCharArray());
    }

    public static String encrypt(String plaintext, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(plaintext.getBytes());
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    public static String decrypt(String encryptedText, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/NONE/PKCS1Padding", "BC");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedText));
        return new String(decryptedBytes);
    }
}
```

