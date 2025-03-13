# Salt & Nonce

Salts and nonces are both important concepts in cryptography.

## Salt

A salt is a random value added to the input of a hash function to ensure that identical inputs produce different hash outputs. Salts are typically used in password hashing.

### **Purpose**

* The primary purpose of a salt is to prevent precomputed attacks, such as rainbow table attacks, on hashed data.
* Salts ensure that even if two users have the same password, their hashed passwords will be different because each password is hashed with a unique salt.

### **Usage**

* Salts are commonly used in password hashing. When a password is hashed, a unique salt is generated and combined with the password before hashing.
* The salt is stored along with the hash so that the password can be verified later.

### **Example**

<pre class="language-java"><code class="lang-java">Password: "mypassword"
Salt: "randomsalt"
Hashed Password: hash("mypasswordrandomsalt")

// Java Code
// -------------------------
// Generate a Random Salt
byte[] salt = new byte[16];
SecureRandom random = new SecureRandom();
random.nextBytes(salt);

// Hash the Password with the Salt
String password = "mypassword";
MessageDigest md = MessageDigest.getInstance("SHA-256");
md.update(salt);
byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
// -------------------------

<strong>// Store the Salt and Hashed Password
</strong>Salt: "randomsalt"
Hashed Password: "hashed_password_value"
</code></pre>

### **Characteristics**

* Unique for each input (e.g., each user's password).
* Stored alongside the hashed output.
* Does not need to be secret, but must be unpredictable and unique.

## Nonce

A nonce (number used once) is a random or pseudo-random value that is used only once in a cryptographic communication. Nonces are typically used in encryption (using AES GCM mode as an example).

### **Purpose**

* Nonces ensure that old communications cannot be reused in replay attacks.
* They provide uniqueness to each cryptographic operation, such as encryption or authentication, to prevent duplicate or predictable outputs.

### **Usage**

* Nonces are used in protocols that require uniqueness and freshness, such as session tokens, initialization vectors (IV) in encryption, and in authentication protocols.
* In encryption, a nonce may be used as an IV to ensure that the same plaintext encrypted multiple times will produce different ciphertexts.

### **Example**

```java
Message: "This is a secret message"
Nonce: "unique_nonce"
Encrypted Message: encrypt("This is a secret message", "unique_nonce")

// Java Code
// -------------------------
// Generate a Nonce
byte[] nonce = new byte[12]; // GCM recommended size
SecureRandom random = new SecureRandom();
random.nextBytes(nonce);

// Encrypt the Data with the Nonce
Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
GCMParameterSpec spec = new GCMParameterSpec(128, nonce);
cipher.init(Cipher.ENCRYPT_MODE, secretKey, spec);
byte[] ciphertext = cipher.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));
// -------------------------

// Transmit/Store the Nonce with the Ciphertext
Nonce: "unique_nonce"
Ciphertext: "encrypted_data"
```

### **Characteristics**

* Unique for each operation.
* Does not need to be secret, but must not be reused with the same key.
* Often combined with other values (e.g., counters or timestamps) to ensure uniqueness.

## Best Practices

**Salts**

* Generate a new, unique salt for each password.
* Use a sufficiently large random salt (e.g., 16 bytes or more) to ensure uniqueness.
* Store the salt alongside the hashed password in a secure manner.

**Nonces**

* Ensure that nonces are unique for each operation to prevent replay attacks.
* Use a secure random number generator to generate nonces.
* Avoid reusing nonces with the same key in encryption operations to maintain security.







