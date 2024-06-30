# Asymmetric Encryption

## **About**

Asymmetric encryption, also known as public-key cryptography, uses a pair of keys for encryption and decryption. One key, known as the public key, is used to encrypt data, while the other key, known as the private key, is used to decrypt data. This method allows secure communication even over insecure channels, as the public key can be distributed openly without compromising security.

## **Key Characteristics**

**1. Key Pair:**

* **Public Key**: Can be shared openly. Used to encrypt data or verify a digital signature.
* **Private Key**: Kept secret. Used to decrypt data or create a digital signature.

**2. Security Based on Mathematical Problems:**

* **Complexity**: The security of asymmetric algorithms relies on the difficulty of certain mathematical problems, such as integer factorization (RSA) or elliptic curve discrete logarithms (ECC).

**3. Asymmetry:**

* **Key Functions**: Different keys for encryption and decryption, which allows for secure key exchange and digital signature verification.

{% hint style="info" %}
**Why it is not possible to encrypt using private key and decrypt using public key?**

Encrypting with a private key and decrypting with a public key is not the typical use case for asymmetric encryption algorithms like RSA. Here are the main reasons why this approach is not commonly used:

#### Purpose of Asymmetric Encryption

1. **Confidentiality**:
   * The primary use of asymmetric encryption is to ensure confidentiality. Data is encrypted with the recipient's public key and can only be decrypted with the recipient's private key. This ensures that only the intended recipient can read the encrypted data.
2. **Authentication and Integrity**:
   * The opposite process, where data is "encrypted" (more accurately, signed) with a private key and "decrypted" (verified) with a public key, is used for digital signatures. This process ensures that the data was created by the holder of the private key and has not been tampered with, providing authentication and integrity.

#### Technical Constraints

1. **Security Assumptions**: The security of RSA relies on the difficulty of factoring large prime numbers. The encryption operation (using the public key) is computationally easy, while decryption (using the private key) is hard without the private key. Reversing these roles would not align with the cryptographic assumptions and could weaken security.
2. **Key Pair Usage**: The private key is kept secret and should not be used for operations that could expose it to unauthorized parties. Encrypting data with the private key would mean the encrypted data could be decrypted by anyone with the public key, which defeats the purpose of keeping the private key secure.

#### Practical Considerations

1. **Performance**: RSA encryption and decryption operations are computationally expensive. Using the private key for encryption would require the private key holder to perform a large number of costly operations, which is impractical for most use cases.
2. **Data Exposure**: Encrypting with the private key means the data can be decrypted by anyone with the public key. This is contrary to the purpose of keeping data confidential and secure. In the context of digital signatures, using the private key to sign data is appropriate because it provides authentication, not confidentiality.

#### Digital Signatures vs. Encryption

1. **Digital Signatures**:
   * When we "encrypt" with the private key (more precisely, sign), we create a digital signature. This signature can be verified by anyone with the corresponding public key to ensure the authenticity and integrity of the data.
   * Example: Alice signs a message with her private key. Bob uses Alice's public key to verify the signature, ensuring the message came from Alice and hasn't been altered.
2. **Encryption**:
   * When we encrypt with the public key, we ensure that only the intended recipient, who holds the private key, can decrypt the data.
   * Example: Bob encrypts a message with Alice's public key. Only Alice can decrypt it with her private key, ensuring the message remains confidential.
{% endhint %}

## **Advantages**

**Secure Key Distribution:** No need to securely share a single key. The public key can be distributed freely, and only the private key needs to be kept secure.

**Digital Signatures:** Provides authentication and integrity. The private key can sign data, and the public key can verify the signature.

**Scalability:** Suitable for scenarios where many users need to securely communicate without the need for a shared secret key for each pair of users.

**Non-Repudiation:** Digital signatures provide non-repudiation, meaning that a sender cannot deny having sent the message.

## **Disadvantages**

**Performance:** Generally slower than symmetric encryption due to more complex mathematical operations. Not suitable for encrypting large amounts of data.

**Key Management Complexity:** Managing and storing key pairs securely can be complex, especially in large systems.

**Larger Key Sizes:** Requires larger key sizes compared to symmetric keys to achieve equivalent security levels, which can impact performance and storage.

## **Applications**

**1. Secure Communication:**

* **TLS/SSL**: Used to secure internet communications. Asymmetric encryption is used for key exchange, while symmetric encryption is used for the data transfer.
* **Email Encryption**: Protocols like PGP (Pretty Good Privacy) and S/MIME (Secure/Multipurpose Internet Mail Extensions) use asymmetric encryption to secure email communications.

**2. Digital Signatures:**

* **Document Signing**: Legal documents, software distributions, and emails can be signed digitally to ensure authenticity and integrity.
* **Code Signing**: Software developers sign their code to verify the source and integrity, ensuring that it has not been tampered with.

**3. Authentication:**

* **SSH (Secure Shell)**: Uses asymmetric encryption for authenticating users and establishing secure connections to remote servers.
* **Certificate Authorities (CAs)**: Issue digital certificates that authenticate the identity of individuals and organizations.

**4. Key Exchange:**

* **Diffie-Hellman**: Allows two parties to securely share a symmetric key over an insecure channel. Often used as part of other protocols like TLS.

**5. Blockchain and Cryptocurrencies:**

* **Bitcoin and Ethereum**: Use asymmetric cryptography to manage ownership and transfer of digital assets.
