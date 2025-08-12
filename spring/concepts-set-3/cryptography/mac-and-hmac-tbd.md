# MAC & HMAC

## About

When it comes to data security, ensuring data integrity and authenticity of information is the most important part. In terms of safeguarding sensitive data, MAC (Message Authentication Code) and HMAC (Hash-based Message Authentication Code) act as a crucial cryptographic constructs. They play a vital role in verifying that messages remain unaltered and originate from trusted sources.

{% hint style="success" %}
Cryptographic constructs refers to the building blocks or components used in the field of cryptography to achieve various security measures.
{% endhint %}

**MACs** and **HMACs** are cryptographic techniques used to verify the authenticity and integrity of messages. They work by creating a "tag" that is associated with a message. The tag is generated using a secret key and it can be used to verify that the message has not been tampered with. The MAC is appended to the message and transmitted along with it. The recipient of the message can then use the same key and algorithm to compute a new MAC for the received message. By comparing the computed MAC with the received MAC, the recipient can verify whether the message has been tampered with or modified during transmission. If the MACs match, the recipient can have confidence that the message is authentic and has not been altered.

They are used in various security protocols and applications.

_Here is the High Level Diagram showing the steps involved in message authentication using MACs_

<figure><img src="https://static.wixstatic.com/media/5fb94b_b8361ce5012043f08cfd572f7a4d86a1~mv2.png/v1/fill/w_1480,h_574,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_b8361ce5012043f08cfd572f7a4d86a1~mv2.png" alt="High level diagram showing the flow of MAC between sender and receiver"><figcaption></figcaption></figure>

{% hint style="warning" %}
Transmitting the MAC along with the original message does not provide secrecy. It only ensures data integrity and authenticity. For confidentiality, encryption can be used in conjunction with message authentication mechanisms like MACs.
{% endhint %}

HMAC is a specific type of MAC that uses a cryptographic hash function, such as SHA-256 or MD5, along with a secret key. The HMAC improves security of the MAC by providing resistance against certain cryptographic attacks. HMAC is computed by applying the hash function to the input message and key in a specific way that incorporates both. The resulting output is the HMAC. Like MAC, the HMAC is sent along with the message, allowing the recipient to verify the integrity and authenticity of the message.

The **main difference between MAC and HMAC** is that MAC can use various cryptographic algorithms, such as symmetric ciphers or cryptographic hash functions, while HMAC specifically uses a hash function in combination with a key. HMAC is considered to be a more secure and recommended approach for message authentication due to its resistance against certain attacks.

{% hint style="success" %}
Ciphers are algorithms used to encrypt and decrypt data, transforming it from its original form (plaintext) into an unintelligible form (ciphertext) and vice versa. Types of Ciphers based on the type of keys used - **Symmetric Ciphers:** Also known as secret-key or shared-key ciphers, symmetric ciphers use the same secret key for both encryption and decryption. The sender and recipient must possess and securely share the same key. Eg. Advanced Encryption Standard (AES), Data Encryption Standard (DES) Asymmetric Ciphers: Also referred to as public-key ciphers, asymmetric ciphers uses a pair of mathematically related keys: a public key and a private key. The public key is freely distributed and used for encryption, while the private key, kept secret by the owner, is used for decryption. Eg. RSA (Rivest-Shamir-Adleman) and Elliptic Curve Cryptography (ECC).
{% endhint %}

## Use cases of MAC and HMAC are

* **Message Authentication**: MAC and HMAC are used to authenticate the sender of a message. By sharing a secret key between the sender and receiver, the receiver can verify that the message was sent by the claimed sender.
* **Data Integrity**: MAC and HMAC are used to verify that data has not been tampered with during transmission. By comparing the computed authentication code with the received code, the receiver can ensure the integrity of the data.
* **Password Protection**: MAC and HMAC are frequently used in password hashing and storage. When a user sets or changes a password, the MAC or HMAC of the password is computed and stored. During login attempts, the computed MAC or HMAC of the entered password is compared with the stored value for verification.
* **Secure Communication**: MAC and HMAC are used in various secure communication protocols, such as SSL/TLS, SSH etc. They provide data integrity and authentication, ensuring that the transmitted data remains confidential and has not been tampered.
* **Digital Signatures**: HMAC can be used in digital signature as a part of the signature generation process. By applying an HMAC to the message using the signer's private key, a digital signature is created. The recipient can then verify the signature using the signer's public key and the original message. For Eg. JSON Web Token (JWT) uses digital signatures to ensure the integrity and authenticity of the token.
* **Network Security**: They play a crucial role in network security protocols such a secure email (S/MIME), secure file transfer (SFTP), and secure network protocols (e.g., HTTPS).

## Common MAC algorithms

* **HMAC (Hash-based Message Authentication Code)** - HMAC is a widely used MAC algorithm that is based on cryptographic hash functions.
  * HMAC-MD5
  * HMAC-SHA1
  * HMAC-SHA256
  * HMAC-SHA512
* **CBC-MAC (Cipher Block Chaining Message Authentication Code)** - CBC-MAC is a MAC algorithm that is based on the cipher block chaining (CBC) mode of operation. It works by encrypting the message with a block cipher in CBC mode. The encryption process generates a sequence of blocks, and the last block is the MAC.
  * CBC-MAC using DES
  * CBC-MAC using AES
* **CMAC (Cipher-based Message Authentication Code)** - CMAC is a MAC algorithm that is based on block ciphers. CMAC is similar to HMAC, but it uses a block cipher instead of a hash function
  * CMAC using AES
* **OMAC (One-Key CBC MAC)** - OMAC is a MAC algorithm that is designed to be used with one-time keys.
  * OMAC1 using AES
  * OMAC2 using AES

Best practices for Key Management\



* **Use Strong Secret Keys** -> Use a long and randomly generated secret key for the MAC computation. The strength of the key greatly impacts the security of the MAC.
* **Protect the Secret Key** -> Ensure that the secret key is properly protected and kept confidential. Avoid hardcoding or transmitting the key insecurely. We should not store the keys in plain text files or on unencrypted disks. It should be stored in secure location, such as a password manager.
* **Rotate the keys frequently** -> We should rotate the keys regularly. This means that we should generate new keys and update the systems to use the new keys. Rotating the keys helps to protect the data from attackers which might have compromised the old keys.
* **Back up the keys** -> We should store copies of keys in a secure location. If primary copy of the keys is lost or compromised, backup can be used to restore the keys.
* **Use of a hardware security module (HSM)** -> A hardware security module (HSM) is a physical device that can be used to store the keys.
* **Use of a key management system** -> A key management system (KMS) is a software application that helps manage keys. A KMS can help generate, store, rotate, and back up of the keys.

## Example

Hands-on with HMAC-SHA512 MAC algorithm that is based on the SHA-512 hash function.

### Using Java inbuilt library javax.crypto.Mac for MAC (HMAC-SHA512)

```java
package com.company.project;

import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@Slf4j
@SpringBootApplication
public class Application {

    public static void main(final String[] args) {
        SpringApplication.run(Application.class, args);

        //////////////SENDER////////////////
        // Message for which MAC is computed
        String message = "Some Sensitive Data";

        // Secret key used for generating the MAC. It should be kept secure probably in
        // a vault and known only to the parties involved in message authentication.
        String secretKeyString = "someSecretKeyString";

        // Select MAC algorithm (e.g., HmacSHA512)
        String algorithm = "HmacSHA512";

        // Create a secret key specification from the secret key string and chosen MAC algorithm
        SecretKeySpec keySpec = new SecretKeySpec(secretKeyString.getBytes(), algorithm);

        String macSenderString = "";
        try {
            // Compute MAC based on the message and the secret key as input
            byte[] macSender = computeMac(message, keySpec);

            // MAC is transmitted by the sender in Base64-encoded string along with the original message
            macSenderString = Base64.getEncoder().encodeToString(macSender);
            // Print the computed MAC as a Base64-encoded string
            log.info("Computed MAC by Sender in Base64 encoded: {}", macSenderString);
        } catch (InvalidKeyException | NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        ////////////// RECEIVER////////////////
        // Receiver is already aware of the secret key and MAC algorithm used for computing the MAC
        // Receiver will get original message as well as MAC in Base64-encoded string
        String receiverMessage = message;
        String macReceiverString = macSenderString;

        // Create a secret key from the provided key string
        SecretKeySpec receiverKeySpec = new SecretKeySpec(secretKeyString.getBytes(), algorithm);

        // Compute the MAC for the received message
        byte[] receivedMac = Base64.getDecoder().decode(macReceiverString);
        // Compute the MAC for the received message using the same algorithm and secret key
        byte[] computedMac;
        try {
            // Compute the MAC of received original message
            computedMac = computeMac(receiverMessage, receiverKeySpec);
            // Compare the received MAC with the computed MAC
            boolean isMacValid = MessageDigest.isEqual(receivedMac, computedMac);

            if (isMacValid) {
                log.info("MAC verification: The message is authentic and has not been tampered");
            } else {
                log.info("MAC verification: The message may have been tampered with or is not authentic");
            }
        } catch (InvalidKeyException | NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }

    private static byte[] computeMac(String message, SecretKeySpec keySpec)
            throws NoSuchAlgorithmException, InvalidKeyException {
        Mac mac = Mac.getInstance(keySpec.getAlgorithm());
        mac.init(keySpec);
        return mac.doFinal(message.getBytes());
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_c51eea0dff7a4efa8b289810f084b498~mv2.png/v1/fill/w_1480,h_96,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_c51eea0dff7a4efa8b289810f084b498~mv2.png" alt="Log output of the above code"><figcaption></figcaption></figure>

### Using Bouncy Castle library in Spring for HMAC (HMAC-SHA512)

```xml
<dependency>
    <groupId>org.bouncycastle</groupId>
    <artifactId>bcpkix-jdk15on</artifactId>
    <version>1.67</version>
</dependency>
```

```java
package com.company.project;

import java.security.MessageDigest;
import java.util.Base64;
import lombok.extern.slf4j.Slf4j;
import org.bouncycastle.crypto.digests.SHA512Digest;
import org.bouncycastle.crypto.macs.HMac;
import org.bouncycastle.crypto.params.KeyParameter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@Slf4j
@SpringBootApplication
public class Application {

    public static void main(final String[] args) {
        SpringApplication.run(Application.class, args);

        //////////////SENDER////////////////
        // Message for which HMAC is computed
        String message = "Some Sensitive Data";

        // Secret key used for generating the HMAC. It should be kept secure probably in
        // a vault and known only to the parties involved in message authentication.
        String secretKeyString = "someSecretKeyString";

        // Create an HMAC instance with SHA-512
        HMac hmacSender = new HMac(new SHA512Digest());

        // Set the key for the HMAC computation
        byte[] keyBytes = secretKeyString.getBytes();
        hmacSender.init(new KeyParameter(keyBytes));

        // Compute HMAC
        byte[] hmacSenderBytes = new byte[hmacSender.getMacSize()];
        byte[] messageBytes = message.getBytes();
        hmacSender.update(messageBytes, 0, messageBytes.length);
        hmacSender.doFinal(hmacSenderBytes, 0);

        // HMAC is transmitted by the sender in Base64-encoded string along with the
        // original message
        String hmacSenderString = Base64.getEncoder().encodeToString(hmacSenderBytes);
        // Print the computed MAC as a Base64-encoded string
        log.info("Computed MAC by Sender in Base64 encoded: {}", hmacSenderString);

        //////////////RECEIVER////////////////
        // Receiver is already aware of the secret key and HMAC algorithm used for computing the HMAC
        // Receiver will get original message as well as HMAC in Base64-encoded string
        String receiverMessage = message;
        String hmacReceiverString = hmacSenderString;

        // Create an HMAC instance for receiver with SHA-512
        HMac hmacReceiver = new HMac(new SHA512Digest());

        // Use the same shared key for the HMAC computation
        hmacReceiver.init(new KeyParameter(keyBytes));

        // Compute HMAC
        byte[] hmacReceiverBytes = new byte[hmacReceiver.getMacSize()];
        byte[] messageReceiverBytes = receiverMessage.getBytes();
        hmacSender.update(messageReceiverBytes, 0, messageReceiverBytes.length);
        hmacSender.doFinal(hmacReceiverBytes, 0);

        // Compute the HMAC in bytes for the received HMAC Base64 String
        byte[] hmacSenderBytesReceived = Base64.getDecoder().decode(hmacReceiverString);

        // Compare the HMAC
        boolean isHmacValid = MessageDigest.isEqual(hmacSenderBytesReceived, hmacReceiverBytes);

        if (isHmacValid) {
            log.info("HMAC verification: The message is authentic and has not been tampered");
        } else {
            log.info("HMAC verification: The message may have been tampered with or is not authentic");
        }
    }
}
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_9d22579a61934629afef56ea00a6279b~mv2.jpg/v1/fill/w_1480,h_128,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_9d22579a61934629afef56ea00a6279b~mv2.jpg" alt="Log output of the above sample bouncy castle code"><figcaption></figcaption></figure>

{% hint style="success" %}
Bouncy Castle and javax.crypto.Mac are both cryptographic libraries that can be used to implement message authentication codes (MAC).&#x20;

* Bouncy Castle is a third-party library that is not part of the Java standard library. We need to download and install Bouncy Castle separately. It offers a wider range of cryptographic algorithms than javax.crypto.Mac.
* javax.crypto.Mac is part of the Java standard library and is available on all Java platforms.
* Both are secure when used correctly and with best security measures like for example following best practices for key management.
{% endhint %}
