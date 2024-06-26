# OpenSSL

## About

OpenSSL is a widely-used toolkit for implementing SSL/TLS and other cryptographic protocols. It includes various commands to generate symmetric keys, encrypt and decrypt data, and manage cryptographic keys.

[https://github.com/openssl/openssl/blob/master/INSTALL.md](https://github.com/openssl/openssl/blob/master/INSTALL.md)

## Version

<figure><img src="../../../../../../.gitbook/assets/image (214).png" alt="" width="563"><figcaption></figcaption></figure>

## Help Section

### Openssl options available

<figure><img src="../../../../../../.gitbook/assets/image (213).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl Message Digest options available

<figure><img src="../../../../../../.gitbook/assets/image (215).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl Cipher options available

<figure><img src="../../../../../../.gitbook/assets/image (216).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl genpkey options available

<figure><img src="../../../../../../.gitbook/assets/image (218).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl ecparam options available

<figure><img src="../../../../../../.gitbook/assets/image (217).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl pkey options available

<figure><img src="../../../../../../.gitbook/assets/image (219).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl pkeyutl options available

<figure><img src="../../../../../../.gitbook/assets/image (220).png" alt="" width="563"><figcaption></figcaption></figure>

### Openssl req options

<figure><img src="../../../../../../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>





## Symmetric Key

Symmetric key generation involves creating a secret key that will be used for both encryption and decryption processes in symmetric cryptography. The strength and security of the encryption depend on the quality of the generated key.

### Generating a Symmetric Key

To generate a symmetric key using OpenSSL:

```
openssl rand <key_length> > <output_file>
```

* `<key_length>`: Specify the desired key length in bytes (e.g., 16 for 128-bit key).
* `<output_file>`: Name of the file to store the generated key (written in raw binary format).

```
openssl rand -base64 <key_length> > <output_file>
```

* `-base64` : encodes the key in Base64 format for readability

```
openssl rand -hex <key_length> > <output_file>
```

* `-hex` : outputs the key in hexadecimal format, which might be required by some tools.

```asciidoc
// Examples

// Generate a 256-bit (32 bytes) random key and saves it to symmetric.key
openssl rand -out symmetric.key 32
```

### **Encrypting Data**

To encrypt data using a symmetric key

```
openssl enc <encryption algorithm> -salt -in <input_file> -out <output_file> -k <symmetric_key>
```

* `<encryption algorithm>`: Specifies the encryption algorithm (AES-128 in CBC mode for example). We can use other algorithms and modes like `des-cbc` or `aes-256-cfb`. Choose based on the security requirements.
* `-salt`: (Optional) Adds a salt to the encryption.
* `-in <input_file>`: Path to the file containing the plain text data you want to encrypt.
* `-out <output_file>`: Path to the file where the encrypted data (ciphertext) will be written.
* `-k <symmetric_key>`: This is where we provide the symmetric key used for encryption. There are two ways to specify the key:
  * **Raw Key:** If key is a raw binary string (generated with `openssl rand` without `-base64`), use this option directly followed by the key in hexadecimal format. (e.g., `-k F40F9211C8AF2009...`).
  * **Base64 Encoded Key:** If key is Base64 encoded (more common for readability), use `-k` followed by the `-base64` option and then the Base64 encoded key string. (e.g., `-k -base64 your_base64_encoded_key`).
* **Password-Based Encryption:** We can use the `-pass` option to provide a password at runtime. OpenSSL will derive a key from the password using PBKDF2 for added security. (e.g., `openssl enc -aes-128-cbc -in data.txt -out data.txt.enc -pass pass:your_password`).

{% hint style="info" %}
**Key Management with Passwords:**

* There's no separate key file to manage in password-based encryption.
* The password acts as the "key" to the derived key.
* It's crucial to choose a strong password and keep it confidential for successful decryption.

**Key Derivation with Password:**

1. When we provide a password during encryption with `-pass pass:your_password`, OpenSSL doesn't store the password itself.
2. Instead, it uses a Key Derivation Function (KDF) to derive a secret key from your password. This KDF process involves one-way hashing and salting (adding random data) to make it computationally infeasible to recover the password from the derived key.
3. This derived key is then used for encryption or decryption.
{% endhint %}

```asciidoc
// Examples

// Encrypting a file with a Base64 encoded key
// Assuming we have a file named data.txt to encrypt and a Base64 encoded key stored in secret_key.txt.
openssl enc -aes-128-cbc -in data.txt -out data.txt.enc -k -base64 $(cat secret_key.txt)

// To encrypt a data using AES algorithm with a 256-bit key in CBC mode
openssl enc -aes-256-cbc -salt -in plaintext.txt -out encrypted.txt -pass pass:your_password

```

### **Decrypting Data**

To decrypt data using a symmetric key

```
openssl enc -d <encryption algorithm> -in <encrypted_file> -out <decrypted_file> -k <symmetric_key>
```

* `-d`: Decryption mode flag (essential for decryption).
* `<encryption algorithm>`: Specifies the decryption algorithm and mode used during encryption (should match the encryption process).
* `-in <encrypted_file>`: Path to the file containing the encrypted data (ciphertext).
* `-out <decrypted_file>`: Path to the file where the decrypted plain text data will be written.
* `-k <symmetric_key>`: This is where you provide the symmetric key used for decryption. Similar to encryption, there are two ways to specify the key:
  * **Raw Key:** If the key is a raw binary string, use `-k` followed by the key in hexadecimal format.
  * **Base64 Encoded Key:** If the key is Base64 encoded (more common), use `-k` followed by the `-base64` option and then the Base64 encoded key string

{% hint style="info" %}
**Matching Parameters:** Ensure the decryption command uses the same algorithm and mode (`-aes-256-cbc` for example) as used during encryption for successful decryption.

**Correct Key:** Use the exact key (raw, Base64 encoded, or password) that was used for encryption.

**Decryption Failure:** Incorrect password, key, or algorithm can lead to decryption failure.
{% endhint %}

```asciidoc
// Examples

// Decrypting with Raw Key
// Assuming we have an encrypted file data.txt.enc and the raw binary key stored in secret_key.bin
// xxd -p secret_key.bin reads the raw binary key from secret_key.bin and outputs it in a format suitable for OpenSSL
openssl enc -d -aes-256-cbc -in data.txt.enc -out data.txt -k $(xxd -p secret_key.bin)

// Decrypting with Base64 Encoded Key
// Assuming we have the encrypted file data.txt.enc and the Base64 encoded key stored in secret_key.txt
openssl enc -d -aes-256-cbc -in data.txt.enc -out data.txt -k -base64 $(cat secret_key.txt)

// Password-Based Decryption
// Replace your_password with the exact password you used during encryption
openssl enc -d -aes-256-cbc -in data.txt.enc -out data.txt -pass pass:your_password
```

## **Asymmetric Key**

Asymmetric key cryptography, also known as public-key cryptography, utilizes a pair of mathematically linked keys: a public key and a private key.

{% hint style="info" %}
**Key Pair:**

* **Public Key:** This key is freely distributed and can be shared with anyone. It's used for encryption. Anyone with the public key can encrypt data, but only the holder of the corresponding private key can decrypt it.
* **Private Key:** This key is kept secret and never shared. It's used for decryption. Only the entity possessing the private key can decrypt data encrypted with the corresponding public key.

The public key cannot be reversed and used for decryption like a private key. This is a fundamental design principle that ensures the security of the system.
{% endhint %}

### Generating a Private Key

```
openssl genpkey -algorithm <alogorithm type> -out private_key.pem [options]
```

* `algorithm`:   Type of algorithm to use. For example RSA, DSA, EC etc.

```asciidoc
// Examples

// RSA algorithm is widely used for key generation
// -pkeyopt rsa_keygen_bits:2048: Specifies the key size (2048 bits)
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048

// The Digital Signature Algorithm
// -pkeyopt dsa_paramgen_bits:2048: Specifies the key size (2048 bits)
openssl genpkey -algorithm DSA -out private_key.pem -pkeyopt dsa_paramgen_bits:2048

// Elliptic Curve (EC) cryptography
// -name prime256v1: Specifies the curve name
openssl ecparam -name prime256v1 -genkey -noout -out private_key.pem
```

### **Generating a Public Key**

OpenSSL can create the corresponding public key from the private key

```
openssl pkey -in <private_key_file> -pubout -out <public_key_file>
```

* `<private_key_file>`: Path to the existing private key file (generated in step 1).
* `<public_key_file>`: Path to the file where the public key will be stored (in PEM format).

```
// Examples

// Generate a public key from a private key
openssl pkey -in private_key.pem -pubout -out public_key.pem

// Command is specifically designed for RSA key operations
openssl rsa -in my_private_key.pem -pubout -out my_public_key.pem

```

### **Encrypting Data**

In asymmetric encryption, we use the public key of the recipient to encrypt data and the corresponding private key of the recipient to decrypt it.

```
openssl pkeyutl -encrypt -in <input_file> -out <output_file> -pubin -inkey recipient_public_key.pem
```

* `-encrypt`: Encrypt the input data.
* `-pubin`: Indicates the input key is a public key.
* `-inkey public_key.pem`: Path to the recipient's public key used for encryption (PEM format).
* `-in plaintext.txt`: Input file to encrypt.
* `-out encrypted.bin`: Output the encrypted data to `encrypted.bin`

```asciidoc
// Examples

// Encrypting data using recipient's public key (RSA)
openssl pkeyutl -encrypt -in message.txt -out message.enc -pubin -inkey recipient_public_key.pem

// Encrypting data using recipient's public key (DSA)
openssl pkeyutl -encrypt -in message.txt -out message.enc -pubin -inkey recipient_public_key.pem

// Encrypting data using recipient's public key (ECC)
openssl pkeyutl -encrypt -in message.txt -out message.enc -pubin -inkey recipient_public_key.pe
```

### **Decrypting Data**

While asymmetric encryption uses public keys, decryption relies on the corresponding private key.

```
openssl pkeyutl -decrypt -in message.enc -out message.txt -inkey your_private_key.pem
```

* `-`decrypt: Decrypt the input data.
* `-pubin`: Indicates the input key is a public key.
* `-inkey your_private_key.pem`: Path to the recipient's private key used for decryption (PEM format).
* `-in encryptedtext.enc`: Input file with encrypted data.
* `-out plaintext.txt`: Output the decrypted data to `plaintext.txt`

```
// Examples

// Decrypting data using your private key (RSA)
openssl pkeyutl -decrypt -in message.enc -out message.txt -inkey your_private_key.pem

// Decrypting data using your private key (DSA)
openssl pkeyutl -decrypt -in message.enc -out message.txt -inkey your_private_key.pem

// Decrypting data using your private key (ECC)
openssl pkeyutl -decrypt -in message.enc -out message.txt -inkey your_private_key.pem
```

### **Creating a Certificate Signing Request (CSR)**

A Certificate Signing Request (CSR) is a data structure containing information used to obtain a digital certificate from a Certificate Authority (CA)

```bash
openssl req -new -key private_key.pem -out csr.pem [options]
```

* `-new`: Indicates a new CSR creation.
* `-key my_private_key.pem`: Specifies the path to your private key file.
* `-out my_csr.csr`: Specifies the output file for the CSR.
* `[-subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"]`: This is an optional subject field. It defines information about the entity requesting the certificate. You can replace the values with your own details:
  * `/C=US`: Country (2-letter code)
  * `/ST=California`: State/Province
  * `/L=San Francisco`: Locality (City)
  * `/O=My Company`: Organization Name
  * `/CN=www.example.com`: Common Name (Domain name or server identifier)

{% hint style="info" %}
Once we have the CSR file (e.g., `my_csr.csr`), we can submit it to a Certificate Authority (CA) of our choice to obtain the digital certificate. The CA will validate the information and issue a certificate signed by their trusted root certificate.
{% endhint %}

```
// Examples

// Generate a CSR with default settings
openssl req -new -key private_key.pem -out csr.pem

// Generating the CSR with Subject Information
openssl req -new -key my_private_key.pem -out my_csr.csr \
  -subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"

```

### **Self-Signing a Certificate**

While obtaining a certificate from a trusted Certificate Authority (CA) is generally recommended, OpenSSL allows us to create a self-signed certificate for testing or internal purposes.

```
openssl req -x509 -sha256 -days 365 -newkey rsa:2048 -keyout my_server_key.pem \
  -out my_server_cert.crt [-subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"]
```

* `-x509`: This flag indicates creating a self-signed certificate.
* `-sha256`: Specifies the signature hashing algorithm (SHA-256 is recommended).
* `-days 365`: Sets the validity period of the certificate to 365 days .
* `-newkey rsa:2048`: Generates a new RSA key (2048 bits) and stores it in `my_server_key.pem`.
* `-keyout my_server_key.pem`: Specifies the output file for the private key (same as before).
* `-out my_server_cert.crt`: Specifies the output file for the self-signed certificate.
* `[-subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"]`: This optional subject information is similar to CSR creation.

{% hint style="info" %}
**Trusting the Self-Signed Certificate:**

Since it's self-signed, most browsers and applications will show a security warning when using this certificate.

Here are two approaches, depending on our needs:

**For testing on a local machine:** We  can import the self-signed certificate into our browser's trust store. However, this is not recommended for production environments due to security risks.

**For internal use on a closed network:** We can configure our applications and servers to trust the self-signed certificate's fingerprint or subject information. However, exercise caution as this bypasses the validation provided by trusted CAs.
{% endhint %}

```
// Examples

// Create a self signed certificate
openssl req -x509 -key private_key.pem -in csr.pem -out certificate.pem -days 365

// Create a self signed certificate with subject
openssl req -x509 -sha256 -days 365 -key my_server_key.pem \
  -out my_server_cert.crt [-subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"]
  
// Create a private key along with self signed certificate
openssl req -x509 -sha256 -days 365 -newkey rsa:2048 -keyout my_server_key.pem \
  -out my_server_cert.crt -subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=www.example.com"
  
```

### **Signing Data**

Digital signatures are a crucial aspect of secure communication, allowing verification of data integrity and origin. OpenSSL provides functionalities for signing data using your private key.

```
openssl dgst -sha256 -sign my_private_key.pem -out signature.txt data.txt
```

* `-sha256`: Specifies the hashing algorithm used to create a digest of the data (SHA-256 is recommended).
* `-sign my_private_key.pem`: Indicates signing with our private key stored in `my_private_key.pem`.
* `-out signature.txt`: Specifies the output file for the signature .
* `data.txt`: The path to the file containing the data we want to sign.

{% hint style="info" %}
Anyone with access to our public key (derived from our private key) can verify the signature to confirm the data's authenticity and integrity.
{% endhint %}

```
// Examples

// Sign data using a private key with SHA-256 hash algorithm.
openssl dgst -sha256 -sign private_key.pem -out signature.bin plaintext.txt
```

### **Verifying a Signature**

Verify a signature using a public key

```
openssl dgst -sha256 -verify signer_public_key.pem -signature signature.txt data.txt
```

* `-sha256`: Specifies the hashing algorithm used during signing (ensure it matches the signing process).
* `-verify signer_public_key.pem`: Indicates verification using the public key of the signer. This file (e.g., `signer_public_key.pem`) should be obtained from a trusted source.
* `-signature signature.txt`: Specifies the path to the signature file created during signing.
* `data.txt`: The path to the original data file (or the data itself if not in a file).

**Output:**

* If the verification is successful, OpenSSL will print "Verified OK". This indicates the data has not been tampered with and the signature is valid.
* If the verification fails, it will display an error message. This might suggest the data has been modified, the signature is invalid, or the wrong public key was used.

{% hint style="info" %}
1. **Signing Process:** During signing, a cryptographic hash function is used to create a "digest" of the data. This digest is a unique fingerprint of the data's content. The signer then uses their private key to encrypt this digest, creating a digital signature.
2. **Verification Process:** During verification, the same hashing algorithm is used to create a new digest of the received data. Then, the verifier uses the signer's public key (which can be mathematically derived from their private key) to decrypt the attached signature.
3. **Verification Outcome:** If the decrypted signature (digest) matches the newly created digest of the received data,verification is successful. This indicates that:
   * The data has not been altered since it was signed, as any changes would result in a different digest.
   * The signature is authentic, as only the private key corresponding to the public key used for verification could have created the valid signature.
{% endhint %}

