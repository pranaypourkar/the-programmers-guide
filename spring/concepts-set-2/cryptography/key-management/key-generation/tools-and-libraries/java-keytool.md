# Java Keytool

## About

Java Keytool is a key and certificate management utility that comes with the Java Development Kit (JDK). It allows users to administer their own public/private key pairs and associated certificates for use in self-authenticated applications or data integrity and authentication services. It provides functionalities for managing keystores, which are repositories for cryptographic keys and certificates used for secure communication in Java applications. Keytool allows tasks like creating, importing, exporting, and managing keys and certificates within a keystore.

{% hint style="info" %}
A keystore is a database file (usually in JKS - Java Key Store format) that stores cryptographic keys and certificates.

TrustStore is a specific type of KeyStore that holds the trusted certificates used to verify the identity of peers.

Keys come in pairs: public and private. Public keys are used for encryption and verification, while private keys are used for decryption and signing.

Certificates are digital documents that bind a public key to an entity (e.g., person, server) and are issued by a Certificate Authority (CA).

Alias is a unique identifier for an entry in a keystore.
{% endhint %}

## Concept

### Keystore vs Truststore

<table><thead><tr><th width="164">Feature</th><th>Keystore</th><th>TrustStore</th></tr></thead><tbody><tr><td>Purpose</td><td>Stores private keys and certificates</td><td>Stores trusted certificates</td></tr><tr><td>Content Type</td><td>Private keys and certificates</td><td>Certificates only</td></tr><tr><td>Usage</td><td>Decryption, signing</td><td>Identity verification (HTTPS, etc.)</td></tr><tr><td>Management</td><td>You manage the keys and certificates</td><td>You import certificates from trusted sources</td></tr><tr><td>Security</td><td>Private keys require strong protection</td><td>Less critical for security, but validation recommended</td></tr></tbody></table>

## Keytool Command Options

### keytool -genseckey

<figure><img src="../../../../../../.gitbook/assets/image.png" alt="" width="375"><figcaption></figcaption></figure>

### keytool -genkeypair and -changealias

<div>

<figure><img src="../../../../../../.gitbook/assets/image (1).png" alt="" width="375"><figcaption></figcaption></figure>

 

<figure><img src="../../../../../../.gitbook/assets/image (2).png" alt="" width="375"><figcaption></figcaption></figure>

</div>

### keytool -keypasswd and -importkeystore

<div>

<figure><img src="../../../../../../.gitbook/assets/image (3).png" alt="" width="375"><figcaption></figcaption></figure>

 

<figure><img src="../../../../../../.gitbook/assets/image (4).png" alt="" width="375"><figcaption></figcaption></figure>

</div>



## Keytool Operations

### Key

#### Generating a Symmetric Key

A symmetric key is a single key used for both encryption and decryption. This is commonly used in algorithms like AES.

```bash
keytool -genseckey -alias <alias> -keyalg <algorithm> -keysize <keysize> -keystore <keystore> -storepass <password>
```

* `-genseckey`: Generates a secret (symmetric) key.
* `-keyalg AES`: Specifies the algorithm (e.g., AES).
* `-keysize 256`: Specifies the key size.

```
// Examples

// Generate an AES symmetric key of size 256 bits
keytool -genseckey -alias symmetrickey -keyalg AES -keysize 256 -keystore keystore.jks -storepass changeit
```

#### Generating an Asymmetric Key Pair

An asymmetric key pair consists of a private key and a public key. These are used in algorithms like RSA for encryption, digital signatures, and key exchange.

```bash
keytool -genkeypair -alias <alias_name> -keyalg <algorithm> -keysize <size> -keystore <keystore_name> -dname "<distinguished_name>" -storepass <password> -keypass <key_password>
```

* `-genkeypair`: Generates an asymmetric key pair.
* `-alias myrsakey`: Specifies the alias for the key entry.
* `-keyalg RSA`: Specifies the algorithm for the key pair.
* `-keysize 2048`: Specifies the key size in bits.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-dname`: Distinguished Name for the certificate associated with the key pair.
* `-storepass changeit`: Password for the keystore.
* `-keypass keypassword`: Password for the private key.

```
// Examples

keytool -genkeypair -alias myrsakey -keyalg RSA -keysize 2048 -keystore keystore.jks -dname "CN=John Doe, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass keypassword
```

#### **Setting a Key Entry's Alias**

Changing the alias of an existing key entry in the keystore.

```
keytool -changealias -alias <current_alias> -destalias <new_alias> -keystore <keystore_name> -storepass <password>
```

* `-changealias`: Command to change the alias of a key entry.
* `-alias oldalias`: Current alias of the key entry.
* `-destalias newalias`: New alias for the key entry.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Change the alias from 'oldalias' to 'newalias'
keytool -changealias -alias oldalias -destalias newalias -keystore keystore.jks -storepass changeit
```

#### Changing a Key Password

Changing the password associated with a specific key in the keystore.

```bash
keytool -keypasswd -alias <alias_name> -keystore <keystore_name> -storepass <store_password> -keypass <old_key_password> -new <new_key_password>
```

* `-keypasswd`: Command to change the password of a key entry.
* `-alias mykey`: Specifies the alias of the key entry.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.
* `-keypass oldkeypassword`: Current password of the key.
* `-new newkeypassword`: New password for the key.

```
// Examples

// Change the password for the key with alias 'mykey'
keytool -keypasswd -alias mykey -keystore keystore.jks -storepass changeit -keypass oldkeypassword -new newkeypassword
```

#### Exporting a Key Pair&#x20;

Exporting a key pair involves converting the key pair from the keystore to a format that can be used by other tools, like PKCS#12

```bash
keytool -importkeystore -srckeystore <source_keystore> -destkeystore <destination_keystore> -deststoretype PKCS12 -srcalias <alias_name> -deststorepass <destination_password> -srcstorepass <source_password> -srckeypass <source_key_password>
```

* `-importkeystore`: Command to import/export a keystore.
* `-srckeystore keystore.jks`: Source keystore file.
* `-destkeystore keystore.p12`: Destination keystore file.
* `-deststoretype PKCS12`: Destination keystore type.
* `-srcalias mykey`: Alias of the key entry in the source keystore.
* `-deststorepass changeit`: Password for the destination keystore.
* `-srcstorepass changeit`: Password for the source keystore.
* `-srckeypass keypassword`: Password for the source key.

<pre><code><strong>// Examples
</strong><strong>
</strong>// Export the key pair with alias 'mykey' from JKS to PKCS12 format
keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -deststoretype PKCS12 -srcalias mykey -deststorepass changeit -srcstorepass changeit -srckeypass keypassword
</code></pre>

#### Importing a Key Pair&#x20;

Importing a key pair involves adding a key pair from an external file (like PKCS#12) into the keystore.

```bash
keytool -importkeystore -srckeystore <source_keystore> -destkeystore <destination_keystore> -srcstoretype PKCS12 -srcstorepass <source_password> -deststorepass <destination_password> -destkeypass <destination_key_password> -alias <alias_name>
```

* `-importkeystore`: Command to import/export a keystore.
* `-srckeystore keystore.p12`: Source keystore file.
* `-destkeystore keystore.jks`: Destination keystore file.
* `-srcstoretype PKCS12`: Source keystore type.
* `-srcstorepass changeit`: Password for the source keystore.
* `-deststorepass changeit`: Password for the destination keystore.
* `-destkeypass keypassword`: Password for the destination key.
* `-alias mykey`: Alias of the key entry in the source keystore.

```
// Examples

// Import a key pair from a PKCS12 file into a JKS keystore
keytool -importkeystore -srckeystore keystore.p12 -destkeystore keystore.jks -srcstoretype PKCS12 -srcstorepass changeit -deststorepass changeit -destkeypass keypassword -alias mykey
```

#### Deleting a Key Entry

Deleting a key entry removes the key and its associated certificate from the keystore.

```bash
keytool -delete -alias <alias_name> -keystore <keystore_name> -storepass <password>
```

* `-delete`: Command to delete a key entry from the keystore.
* `-alias mykey`: Alias of the key entry to delete.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Delete the key entry with alias 'mykey' from the keystore
keytool -delete -alias mykey -keystore keystore.jks -storepass changeit
```

### Certificate

#### Creating a Certificate

Creating a self-signed certificate or generating a Certificate Signing Request (CSR) for obtaining a signed certificate from a Certificate Authority (CA).

```bash
keytool -genkeypair -alias <alias_name> -keyalg <algorithm> -keysize <size> -keystore <keystore_name> -dname "<distinguished_name>" -storepass <password> -keypass <key_password> -validity <days>
```

* `-genkeypair`: Generates a key pair and a self-signed certificate.
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-keyalg RSA`: Specifies the algorithm for the key pair.
* `-keysize 2048`: Specifies the key size in bits.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-dname`: Distinguished Name for the certificate.
* `-storepass changeit`: Password for the keystore.
* `-keypass keypassword`: Password for the private key.
* `-validity 365`: Validity period of the certificate in days.

```
// Examples

// Generate a self-signed certificate with an RSA key pair
keytool -genkeypair -alias mycert -keyalg RSA -keysize 2048 -keystore keystore.jks -dname "CN=John Doe, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass keypassword -validity 365
```

#### Importing a Certificate

Importing a certificate into a keystore.

```bash
keytool -importcert -alias <alias_name> -file <certificate_file> -keystore <keystore_name> -storepass <password>
```

* `-importcert`: Imports a certificate into the keystore.
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-file mycert.crt`: Path to the certificate file to be imported.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Import a certificate into the keystore
keytool -importcert -alias mycert -file mycert.crt -keystore keystore.jks -storepass changeit
```

#### Exporting a Certificate

Exporting a certificate from a keystore.

```bash
keytool -exportcert -alias <alias_name> -file <output_file> -keystore <keystore_name> -storepass <password>
```

* `-exportcert`: Exports a certificate from the keystore.
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-file mycert_export.crt`: Path to the output file where the certificate will be saved.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Export a certificate from the keystore
keytool -exportcert -alias mycert -file mycert_export.crt -keystore keystore.jks -storepass changeit
```

#### Displaying Certificate Information

Displaying detailed information about a certificate stored in a keystore.

```bash
keytool -list -v -alias <alias_name> -keystore <keystore_name> -storepass <password>
```

* `-list -v`: Lists the contents of the keystore in verbose mode, showing detailed information.
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Display detailed information about a certificate
keytool -list -v -alias mycert -keystore keystore.jks -storepass changeit
```

#### **Checking Certificate Expiration Date**

#### **Renewing an Expired Certificate**



### Certificate Signing Request (CSR)

Generating a CSR&#x20;

Submitting a CSR to a CA&#x20;

Importing a Signed Certificate from a CSR



### Certificate Chain

#### Importing a Certificate Chain

#### **Verifying a Certificate Chain**

#### **Importing and Exporting Certificates with CA Certs**



### Keystore

#### Creating a Keystore

#### Importing a Certificate into a Keystore

#### Changing a Keystore Password

#### **Viewing Keystore Details**

#### **Backing Up a Keystore**

#### Listing Entries in a Keystore

#### Deleting an Entry from a Keystore

Importing a Keystore&#x20;

Exporting a Keystore



### Truststore

#### **Creating a TrustStore**

#### **Adding a trusted Certificate**

#### **Removing an Untrusted Certificate**

#### Listing Entries in a Truststore

Verifying TrustStore Contents&#x20;

Updating a TrustStore&#x20;

Backing Up a TrustStore























## Real-World Use Cases

### **Securing Web Servers with SSL/TLS**

**Scenario**: Setting up SSL/TLS on a Tomcat server.

1.  **Generate a Keystore**:

    ```bash
    keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 -keystore tomcat.keystore -dname "CN=www.example.com, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass changeit
    ```
2.  **Generate a CSR**:

    ```bash
    keytool -certreq -alias tomcat -file tomcat.csr -keystore tomcat.keystore -storepass changeit
    ```
3. **Submit CSR to CA**: Submit `tomcat.csr` to a Certificate Authority (CA) to get a signed certificate.
4.  **Import the CA Certificate**:

    ```bash
    keytool -importcert -alias root -file rootCA.crt -keystore tomcat.keystore -storepass changeit
    ```
5.  **Import the Signed Certificate**:

    ```bash
    keytool -importcert -alias tomcat -file tomcat.crt -keystore tomcat.keystore -storepass changeit
    ```
6.  **Configure Tomcat**: Update `server.xml` in Tomcat's `conf` directory:

    ```xml
    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               keystoreFile="conf/tomcat.keystore" keystorePass="changeit"
               clientAuth="false" sslProtocol="TLS"/>
    ```

### **Authenticating Clients in a Secure Environment**

**Scenario**: Using client certificates for authentication.

1.  **Generate Client Keystore**:

    ```bash
    keytool -genkeypair -alias client -keyalg RSA -keysize 2048 -keystore client.keystore -dname "CN=Client Name, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass changeit
    ```
2.  **Generate a CSR for Client**:

    ```bash
    keytool -certreq -alias client -file client.csr -keystore client.keystore -storepass changeit
    ```
3. **Sign the CSR with Root CA**: Use the CA's private key to sign the CSR and generate the client certificate.
4.  **Import CA Certificate into Client Keystore**:

    ```bash
    keytool -importcert -alias root -file rootCA.crt -keystore client.keystore -storepass changeit
    ```
5.  **Import Client Certificate into Client Keystore**:

    ```bash
    keytool -importcert -alias client -file client.crt -keystore client.keystore -storepass changeit
    ```
6. **Client Uses Keystore for SSL/TLS Authentication**: The client application can now use the `client.keystore` to authenticate to servers.

