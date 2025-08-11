---
hidden: true
---

# KDF

## About

Security is very important, especially when dealing with sensitive data and information like passwords, secrets, etc. One of the aspects of a cryptographic system is the generation of strong cryptographic keys which act as a foundation for securing data, ensuring confidentiality, integrity, and authenticity. In this blog, let's explore KDF.

KDF, or Key Derivation Functions, is a cryptographic algorithm that takes an input, usually a password or a passphrase, and transforms it into a cryptographic key suitable for use in various security protocols and applications.

It is commonly used in scenarios where a secret key needs to be derived from a human-readable password, which typically has limited entropy and may be vulnerable to brute-force or dictionary attacks. By applying a KDF, the resulting key will have higher entropy and be more resistant to these types of attacks.The purpose of a KDF is to make the resulting key more secure and resistant to attacks.

{% hint style="success" %}
* Entropy measures the unpredictability or randomness of a given set of data. It quantifies the amount of randomness present in a system or source of data.
* Key Derivation Functions (KDFs) are one-way functions. A one-way function is a mathematical operation or algorithm that is relatively easy to compute in one direction (forward computation), but it is computationally infeasible to reverse the process and obtain the original input from the output (backward computation)
{% endhint %}

## KDF Algorithms

Some of the commonly used Key Derivation Function (KDF) algorithms are given below.

* **PBKDF2 (Password-Based Key Derivation Function 2)**&#x20;

PBKDF2 is a widely used KDF that applies a cryptographic hash function (such as SHA-1, SHA-256) multiple times to derive a key from a password. It allows for the customization of the iteration count and salt.

* **bcrypt**

bcrypt is a password hashing function that incorporates a KDF. It uses the Blowfish encryption algorithm and applies multiple rounds of hashing to protect against brute-force attacks.

* **scrypt**

scrypt is a KDF designed to be memory-hard, making it resistant to parallelized attacks. It uses a large amount of memory, making it computationally expensive to perform parallel computations.

* **Argon2**

Argon2 is a modern and memory-hard KDF that offers resistance against various attacks, including brute-force, time-memory trade-off, and side-channel attacks.

* **HKDF (HMAC-based Key Derivation Function)**

HKDF is a key derivation function based on HMAC which allows for the derivation of keys of varying lengths and is commonly used for generating cryptographic keys from shared secrets.

* **KDF1 and KDF2**

KDF1 and KDF2 are Key Derivation Functions based on a cryptographic hash function and are commonly used for deriving encryption keys from passwords.

* **Catena**

Catena is a KDF designed to be memory-hard and resistant to parallel attacks. It incorporates a chaining mechanism and introduces a time cost factor to increase the computational difficulty.

* **Balloon Hashing**

Balloon Hashing is a memory-hard KDF that aims to provide resistance against both parallel and time-memory trade-off attacks. It is designed to consume a significant amount of memory during the key derivation process.

{% hint style="info" %}
Memory-hard refers to an algorithm or function that requires a significant amount of memory (RAM) to compute, making it computationally expensive for attackers attempting to parallelize or optimize the computation.
{% endhint %}

## KDF Algorithm Properties

Some of the properties which make KDF algorithms effective and reliable in securely deriving cryptographic keys are listed below.

* **Key Strengthening**

KDFs must employ techniques like key stretching or iterative hashing to increase the computational effort required to derive the key. This property helps slow down potential attackers attempting to guess the input by brute force or dictionary attacks.

* **Salt or Nonce Usage**

KDFs often uses a salt or a nonce to derive the key. A salt is a random value that is combined with the input to prevent precomputed attacks like rainbow table attacks. A nonce, a number used once, is a unique value used to ensure that each key derivation operation produces a different output, even if the input is the same.

* **Domain Separation**

KDFs should ensure that the keys derived from different inputs or for different purposes are distinct and do not collide. This prevents issues where keys derived from unrelated inputs accidentally match, compromising the security of the system.

* **Randomness Preservation**

KDFs must try to keep as much unpredictability and randomness as possible from the original secret value (like a password) when generating a new cryptographic key. This is important because the security of the resulting key depends on the quality and randomness of the original secret. By preserving the randomness, KDFs ensure that the derived key is strong and less susceptible to attacks, making it safer for encrypting and protecting sensitive data.

* **Resistance to Attacks**

KDFs should resist various cryptographic attacks, such as brute force attacks, dictionary attacks, and precomputed attacks. The algorithms should provide a high level of security and make it computationally infeasible for an attacker to derive the input or recover the original key from the derived key.

* **Efficiency**

While security is critical, efficient computation is also important for practical implementation and performance. KDF algorithms should maintain a balance between security and performance, ensuring that key derivation operations can be carried out in a reasonable amount of time without excessive computational resources.

* **Standardization**

KDF algorithm should be well-defined and standardized to ensure interoperability and ease of implementation across different systems and applications.

## Weak or Strong KDFs&#x20;

### Weak KDF

A weak KDF is a Key Derivation Function that lacks sufficient security properties or fails to provide adequate protection against attacks. Weak KDFs may have vulnerabilities that can be exploited by attackers, potentially compromising the security of the derived keys. Some of the characteristics of weak KDFs include -

* Lack of randomness preservation
* Insufficient key stretching
* Susceptibility to attacks
* Non-standardized or obsolete designs

For example, MD5-based KDF is an example of a weak KDF. MD5 (Message Digest Algorithm 5) is a widely known cryptographic hash function that has been found to have vulnerabilities. It is considered insecure for most cryptographic applications due to its susceptibility to collision attacks and advances in computational power. Using MD5 as a basis for key derivation would make the resulting keys weak and vulnerable to various attacks.

### Strong KDF

A strong KDF is a Key Derivation Function that possesses strong security properties and is designed to resist various cryptographic attacks. Strong KDFs employ well-established cryptographic techniques and have undergone extensive analysis and scrutiny by the cryptographic community. Some of the characteristics of weak KDFs include -

* Key stretching and computational effort
* Randomness preservation
* Resistance to attacks
* Standardization and scrutiny

For example, PBKDF2, bcrypt, and Argon2 are considered to be strong KDF. PBKDF2 (Password-Based Key Derivation Function 2) is widely adopted and recommended for password storage and key derivation purposes. PBKDF2 applies a pseudorandom function (such as HMAC-SHA1, HMAC-SHA256, or HMAC-SHA512) iteratively to derive a cryptographic key from a password or passphrase. It incorporates salting as well to prevent precomputed attacks like rainbow table attacks.

### Comparison

| BCrypt | Medium    | Slow      |
| ------ | --------- | --------- |
| SCrypt | High      | Very Slow |
| PBKDF2 | Low       | Medium    |
| Argon2 | Very High | Very Slow |

## How KDF differs from Hash function ?

KDF and Hash functions are both cryptographic algorithms, but they serve different purposes and have distinct characteristics -

* **Purpose**
  * **KDF**: The primary purpose of a KDF is to derive cryptographic keys or key material from an input, such as a password or shared secret. KDFs are specifically designed to transform low-entropy inputs into high-entropy keys suitable for use in cryptographic operations.&#x20;
  * **Hash Function**: Hash functions are designed to take an arbitrary input and produce a fixed-size output, called a hash or message digest. Their primary purpose is to verify data integrity, detect changes or tampering in the input, and generate a unique identifier (digest) for a given input.
* **Input and Output**
  * **KDF**: KDFs usually take a secret input, such as a password or shared secret, and produce a cryptographic key or key material as the output. The output can have variable length and is generally used for encryption, authentication, or other cryptographic purposes.&#x20;
  * **Hash Function**: Hash functions take any input, such as a message or data, and produce a fixed-size output (hash). The output is a unique representation of the input and is commonly used for data integrity verification and digital signatures.
* **Key Stretching**
  * **KDF**: KDFs often include techniques like key stretching, where the input is subjected to multiple iterations or computations to increase the computational effort required to derive the key. Key stretching helps make the derived key more resistant to brute-force attacks.&#x20;
  * **Hash Function**: While some hash functions can be used in password-based key derivation, they are not inherently designed for key stretching. Hash functions aim to provide collision resistance and data integrity without the need for key stretching.

## Use cases for applying KDF

* **Key Generation** -> KDFs are commonly used to generate cryptographic keys from a master key or password. This process ensures that the generated keys have sufficient entropy and are resistant to various attacks.
* **Password Hashing** -> KDFs play a crucial role in password-based key derivation. They derive a secure and unique cryptographic hash from a user's password, adding salt and applying multiple iterations to protect against brute force and dictionary attacks.
* **Key Expansion** -> KDFs can expand a single key into multiple keys or produce additional parameters needed for cryptographic algorithms. This allows for efficient and secure key management within cryptographic systems.
* **Deriving Initialization Vectors (IVs)** -> KDFs can derive initialization vectors used in symmetric encryption algorithms. IVs are crucial for ensuring the uniqueness and randomness of ciphertexts, contributing to the security of encrypted data.
* **Key Agreement** -> In some cases, KDFs are used in key agreement protocols to derive a shared secret between two or more parties. This shared secret can be used as a symmetric encryption key or as input to other cryptographic algorithms.

\




