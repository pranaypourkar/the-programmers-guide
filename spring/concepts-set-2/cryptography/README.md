# Cryptography

## About&#x20;

**Cryptography** is the science of securing information by transforming it into an unreadable format. It involves various techniques and algorithms designed to protect data confidentiality, integrity, authenticity, and non-repudiation. Cryptography ensures that sensitive information can be stored and transmitted securely, preventing unauthorized access and tampering. Cryptography includes a wide range of practices, algorithms, and protocols beyond just encryption and decryption.

## **Types of Cryptographic Algorithms**

### **Symmetric Key Cryptography**:

* Uses a single key for both encryption and decryption.
* Faster and more efficient but poses challenges in key distribution and management.
* Common algorithms: AES (Advanced Encryption Standard), DES (Data Encryption Standard), 3DES (Triple DES).

### **Asymmetric Key Cryptography**:

* Uses a pair of keys: a public key for encryption and a private key for decryption.
* Enhances security and simplifies key management.
* Common algorithms: RSA (Rivest-Shamir-Adleman), ECC (Elliptic Curve Cryptography).

### **Hash Functions**:

* Converts input data into a fixed-size string of characters, which is typically a digest that is unique to each unique input.
* Used for data integrity verification.
* Common algorithms: SHA (Secure Hash Algorithm), MD5 (Message Digest Algorithm 5).

### **Digital Signatures**:

* A method to verify the authenticity and integrity of a message, software, or digital document.
* Uses asymmetric cryptography.
* Common algorithms: RSA, DSA (Digital Signature Algorithm).

## **Goals of Cryptography**

### **Confidentiality**:

* Ensures that information is accessible only to those authorized to access it.
* Achieved through encryption.

### **Integrity**:

* Ensures that the information has not been altered in an unauthorized manner.
* Achieved through hashing and digital signatures.

### **Authentication**:

* Confirms the identity of the parties involved in communication.
* Achieved through digital certificates and public key infrastructure (PKI).

### **Non-repudiation**:

* Ensures that a party cannot deny the authenticity of their signature on a document or a message they sent.
* Achieved through digital signatures.

## **Real-World Applications of Cryptography**

1. **Secure Communication**:
   * Encrypting email, instant messages, and video calls to ensure that only intended recipients can read the content.
   * Protocols like TLS (Transport Layer Security) and SSL (Secure Sockets Layer) secure web communications.
2. **Data Protection**:
   * Encrypting data at rest, such as files stored on a hard drive or in cloud storage, to prevent unauthorized access.
   * Tools like BitLocker and FileVault provide full-disk encryption.
3. **Authentication and Access Control**:
   * Using cryptographic methods for user authentication in systems and applications.
   * Password hashing, multi-factor authentication, and digital certificates are commonly used.
4. **Digital Signatures and Certificates**:
   * Ensuring the authenticity and integrity of digital documents and software.
   * Widely used in software distribution, legal documents, and secure transactions.
5. **Financial Transactions**:
   * Securing online banking and payment systems to protect financial data.
   * Standards like PCI DSS mandate the use of encryption to protect cardholder data.
6. **Blockchain and Cryptocurrencies**:
   * Cryptographic techniques underpin blockchain technology and cryptocurrencies like Bitcoin and Ethereum.
   * Ensures secure transactions and decentralized consensus.
