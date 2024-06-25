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





