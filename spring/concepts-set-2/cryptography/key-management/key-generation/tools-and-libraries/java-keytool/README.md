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



## Keytool Command Options

### keytool -genseckey

<figure><img src="../../../../../../../.gitbook/assets/image (1) (1) (1) (1) (1).png" alt="" width="375"><figcaption></figcaption></figure>

### keytool -genkeypair and -changealias

<div>

<figure><img src="../../../../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1).png" alt="" width="375"><figcaption></figcaption></figure>

 

<figure><img src="../../../../../../../.gitbook/assets/image (2) (1) (1).png" alt="" width="375"><figcaption></figcaption></figure>

</div>

### keytool -keypasswd and -importkeystore

<div>

<figure><img src="../../../../../../../.gitbook/assets/image (3).png" alt="" width="375"><figcaption></figcaption></figure>

 

<figure><img src="../../../../../../../.gitbook/assets/image (4).png" alt="" width="375"><figcaption></figcaption></figure>

</div>

## Key

### Generating a Symmetric Key

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

### Generating an Asymmetric Key Pair

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

### **Setting a Key Entry's Alias**

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

### Changing a Key Password

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

### Exporting a Key Pair&#x20;

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

### Importing a Key Pair&#x20;

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

### Deleting a Key Entry

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

## Certificate

### Creating a Certificate

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

### Importing a Certificate

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

### Exporting a Certificate

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

### Displaying Certificate Information

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

### **Checking Certificate Expiration Date**

Checking the expiration date of a certificate stored in a keystore.

```bash
keytool -list -v -alias <alias_name> -keystore <keystore_name> -storepass <password> | grep -i "valid from"
```

* `-list -v`: Lists the contents of the keystore in verbose mode, showing detailed information.
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.
* `| grep -i "valid from"`: Filters the output to show the validity period of the certificate.

```
// Examples

// Check the expiration date of a certificate
keytool -list -v -alias mycert -keystore keystore.jks -storepass changeit | grep -i "valid from"
```

### **Renewing an Expired Certificate**

Renewing a certificate that is about to expire by generating a new Certificate Signing Request (CSR) and importing the renewed certificate.

{% hint style="info" %}
**Steps**:

1. **Generate a new CSR** using the existing key pair.
2. **Submit the CSR** to a Certificate Authority (CA) to get a renewed certificate.
3. **Import the renewed certificate** into the keystore.
{% endhint %}

### **CSR Generation**

```bash
keytool -certreq -alias <alias_name> -file <csr_file> -keystore <keystore_name> -storepass <password>
```

* `-certreq`: Generates a Certificate Signing Request (CSR).
* `-alias mycert`: Specifies the alias for the certificate entry.
* `-file mycert.csr`: Path to the CSR file.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

### **Importing Renewed Certificate**

```bash
keytool -importcert -alias <alias_name> -file <renewed_certificate_file> -keystore <keystore_name> -storepass <password>
```

* `-importcert`: Imports a certificate into the keystore.
* `-file renewed_mycert.crt`: Path to the renewed certificate file.

```
// Examples

// Generate a new CSR for the existing key pair
keytool -certreq -alias mycert -file mycert.csr -keystore keystore.jks -storepass changeit

// Import the renewed certificate into the keystore
keytool -importcert -alias mycert -file renewed_mycert.crt -keystore keystore.jks -storepass changeit
```

## Certificate Signing Request (CSR)

### Generating a CSR&#x20;

Generating a Certificate Signing Request (CSR) involves creating a request for a digital certificate from a Certificate Authority (CA). This request includes your public key and information about your organization.

```bash
keytool -certreq -alias <alias_name> -file <csr_file> -keystore <keystore_name> -storepass <password>
```

* `-certreq`: Command to generate a CSR.
* `-alias mykey`: Alias of the key pair for which the CSR is generated.
* `-file mycert.csr`: Path to the output CSR file.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Generate a CSR for the key pair with alias 'mykey'
keytool -certreq -alias mykey -file mycert.csr -keystore keystore.jks -storepass changeit
```

### Submitting a CSR to a CA

&#x20;Submitting a CSR to a Certificate Authority (CA) involves sending the CSR file to the CA for signing. The CA will verify the information and return a signed certificate.

{% hint style="info" %}
**Steps**:

1. **Generate a CSR** (see above).
2. **Submit the CSR to the CA**: This step is typically done through the CA's web interface or via email.
3. **Receive the signed certificate** from the CA.

Note that each CA has a different process for submitting a CSR. Follow the specific instructions provided by the CA.
{% endhint %}

```
// Examples

1. Visit the CA's website or contact them to find out how to submit the CSR.
2. Upload or email the CSR file (mycert.csr).
3. Wait for the CA to process the request and return a signed certificate (e.g., mycert_signed.crt).
```

### Importing a Signed Certificate from a CSR

Importing a signed certificate into a keystore involves adding the signed certificate returned by the CA into the keystore. You may also need to import the CA's root and intermediate certificates.

```
keytool -importcert -alias <alias_name> -file <signed_certificate_file> -keystore <keystore_name> -storepass <password>
```

* `-importcert`: Command to import a certificate into the keystore.
* `-alias caroot`: Alias for the CA root certificate.
* `-file caroot.crt`: Path to the CA root certificate file.
* `-alias mykey`: Alias for the signed certificate.
* `-file mycert_signed.crt`: Path to the signed certificate file.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Import the CA's root certificate
keytool -importcert -alias caroot -file caroot.crt -keystore keystore.jks -storepass changeit

// Import the signed certificate from the CA
keytool -importcert -alias mykey -file mycert_signed.crt -keystore keystore.jks -storepass changeit
```

## Certificate Chain

### Importing a Certificate Chain

A certificate chain (or certificate path) includes the end-entity certificate, any intermediate certificates, and the root certificate. Importing a certificate chain involves adding all these certificates to the keystore in the correct order.

```bash
keytool -importcert -trustcacerts -alias <alias_name> -file <certificate_chain_file> -keystore <keystore_name> -storepass <password>
```

* `-importcert`: Command to import certificates into the keystore.
* `-trustcacerts`: Trust the CA certificates in the chain.
* `-alias mykey`: Alias for the certificate chain.
* `-file mycert_chain.pem`: Path to the file containing the certificate chain.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

**Note**: The `mycert_chain.pem` file should contain the end-entity certificate followed by intermediate certificates and finally the root certificate.

```
// Examples

// Import a certificate chain into the keystore
keytool -importcert -trustcacerts -alias mykey -file mycert_chain.pem -keystore keystore.jks -storepass changeit
```

### **Verifying a Certificate Chain**

Verifying a certificate chain ensures that the certificate chain is valid and trusted. This involves checking the signatures of each certificate in the chain up to the root certificate.

```bash
keytool -list -v -keystore <keystore_name> -storepass <password>
```

* `-list -v`: Lists the contents of the keystore in verbose mode, showing detailed information.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Verify the certificate chain by listing details of the keystore
keytool -list -v -keystore keystore.jks -storepass changeit
```

### **Importing and Exporting Certificates with CA Certs**

Importing and exporting certificates with CA certificates involve transferring certificates and their associated CA certificates between keystores or between keystores and files.

### **Importing a CA Certificate**

```bash
keytool -importcert -alias <ca_alias> -file <ca_certificate_file> -keystore <keystore_name> -storepass <password>
```

* `-importcert`: Command to import a certificate into the keystore.
* `-alias caroot`: Alias for the CA certificate.
* `-file caroot.crt`: Path to the CA certificate file.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Import a CA certificate into the keystore
keytool -importcert -alias caroot -file caroot.crt -keystore keystore.jks -storepass changeit
```

### **Exporting a Certificate**

```bash
keytool -exportcert -alias <alias_name> -file <output_file> -keystore <keystore_name> -storepass <password>
```

* `-exportcert`: Exports a certificate from the keystore.
* `-alias mykey`: Alias for the certificate entry.
* `-file mycert_export.crt`: Path to the output file where the certificate will be saved.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Export a certificate from the keystore
keytool -exportcert -alias mykey -file mycert_export.crt -keystore keystore.jks -storepass changeit
```



## Keystore

### Creating a Keystore

Creating a new keystore involves generating a keystore file and optionally adding an initial key pair or certificate.

```bash
keytool -genkeypair -alias <alias_name> -keyalg <algorithm> -keysize <size> -keystore <keystore_name> -dname "<distinguished_name>" -storepass <password> -keypass <key_password> -validity <days>
```

* `-genkeypair`: Generates a key pair and creates a keystore if it doesn't exist.
* `-alias mykey`: Specifies the alias for the key pair.
* `-keyalg RSA`: Specifies the algorithm for the key pair.
* `-keysize 2048`: Specifies the key size in bits.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-dname`: Distinguished Name for the certificate.
* `-storepass changeit`: Password for the keystore.
* `-keypass keypassword`: Password for the private key.
* `-validity 365`: Validity period of the certificate in days.

```bash
keytool -keystore <keystore_name> -storepass <password> -storetype <storetype> -noprompt
```

```
// Examples

// Create a new keystore and generate an initial key pair
keytool -genkeypair -alias mykey -keyalg RSA -keysize 2048 -keystore keystore.jks -dname "CN=John Doe, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass keypassword -validity 365

// Create an empty keystore named empty_keystore.jks
keytool -keystore empty_keystore.jks -storepass changeit -storetype JKS -noprompt
```

### Importing a Certificate into a Keystore

Importing a certificate into an existing keystore.

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

### Changing a Keystore Password

Changing the password used to protect the keystore.

```bash
keytool -storepasswd -keystore <keystore_name> -storepass <current_password> -new <new_password>
```

* `-storepasswd`: Changes the keystore password.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Current password for the keystore.
* `-new newpassword`: New password for the keystore.

```
// Examples

// Change the keystore password
keytool -storepasswd -keystore keystore.jks -storepass changeit -new newpassword
```

### **Viewing Keystore Details**

Viewing details of the keystore and its contents.

```bash
keytool -list -v -keystore <keystore_name> -storepass <password>
```

* `-list -v`: Lists the contents of the keystore in verbose mode, showing detailed information.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// View detailed information about the keystore
keytool -list -v -keystore keystore.jks -storepass changeit
```

### **Backing Up a Keystore**

Backing up a keystore by copying the keystore file to a safe location. Use standard file copy commands (e.g., `cp` for Unix/Linux, `copy` for Windows) to create a backup of the keystore file.

```
// Examples

// Copy the keystore file to a backup location
cp keystore.jks keystore_backup.jks
```

### Listing Entries in a Keystore

Listing the aliases of all entries in the keystore.

```bash
keytool -list -keystore <keystore_name> -storepass <password>
```

* `-list`: Lists the contents of the keystore.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// List all entries in the keystore
keytool -list -keystore keystore.jks -storepass changeit
```

### Deleting an Entry from a Keystore

Deleting a specific entry (identified by its alias) from the keystore.

```bash
keytool -delete -alias <alias_name> -keystore <keystore_name> -storepass <password>
```

* `-delete`: Deletes an entry from the keystore.
* `-alias mycert`: Specifies the alias of the entry to be deleted.
* `-keystore keystore.jks`: Specifies the keystore file.
* `-storepass changeit`: Password for the keystore.

```
// Examples

// Delete an entry from the keystore
keytool -delete -alias mycert -keystore keystore.jks -storepass changeit
```

### Importing a Keystore

Importing an existing keystore involves copying or merging its contents into another keystore.

There is no direct command to import one keystore into another; instead, export entries from the source keystore and import them into the target keystore.

```
// Examples

// Export entries from the source keystore
keytool -exportcert -alias mycert -file mycert.crt -keystore source_keystore.jks -storepass sourcepass

// Import entries into the target keystore:
keytool -importcert -alias mycert -file mycert.crt -keystore target_keystore.jks -storepass targetpass
```

### Exporting a Keystore

Exporting a keystore involves creating a copy of the keystore file.

Use standard file copy commands (e.g., `cp` for Unix/Linux, `copy` for Windows) to create a copy of the keystore file.

```
// Examples

// Copy the keystore file to a new location
cp keystore.jks keystore_export.jks
```

## Truststore

### **Creating a TrustStore**

Creating a new truststore involves generating a truststore file and optionally adding trusted certificates. An empty truststore is a keystore with no certificates or key entries. This can be useful as a starting point to which you can later add trusted certificates.

**Non-Empty Truststore**

```bash
keytool -genkeypair -alias <alias_name> -keyalg <algorithm> -keystore <truststore_name> -dname "<distinguished_name>" -storepass <password>
```

* `-genkeypair`: Generates a key pair.
* `-alias temp`: Temporary alias for the key pair.
* `-keyalg RSA`: Algorithm for the key pair.
* `-keystore truststore.jks`: Specifies the truststore file.
* `-dname`: Distinguished name for the certificate.
* `-storepass changeit`: Password for the truststore.
* `-keypass tempkeypass`: Password for the private key.
* `-validity 1`: Validity period of the certificate in days (set to a very short period since it's temporary).

{% hint style="info" %}
Although the above command generates a key pair, a truststore typically contains trusted certificates. You can import trusted certificates into this truststore as shown in the next section.
{% endhint %}

**Empty Truststore**

```
keytool -genkeypair -alias <temporary_alias> -keyalg <algorithm> -keystore <truststore_name> -dname "<distinguished_name>" -storepass <password> -keypass <key_password> -validity <days>
keytool -delete -alias <temporary_alias> -keystore <truststore_name> -storepass <password>
```

{% hint style="info" %}
The above steps are necessary because Java Keytool does not provide a direct command to create an empty keystore. The temporary entry is used to create the keystore file, which is then deleted to make the keystore empty.
{% endhint %}

```
// Examples

// Create a new truststore with initial pair
keytool -genkeypair -alias truststorealias -keyalg RSA -keysize 2048 -keystore truststore.jks -dname "CN=TrustStore, OU=Security, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass keypassword -validity 365

// Create a new empty truststore
// Step 1: Create a temporary entry to initialize the truststore
keytool -genkeypair -alias temp -keyalg RSA -keysize 2048 -keystore truststore.jks -dname "CN=Temporary, OU=IT, O=Example Corp, L=City, ST=State, C=Country" -storepass changeit -keypass tempkeypass -validity 1

// Step 2: Delete the temporary entry to leave the truststore empty
keytool -delete -alias temp -keystore truststore.jks -storepass changeit
```

### **Adding a trusted Certificate**

Adding a trusted certificate to a truststore involves importing the certificate into the truststore.

```bash
keytool -importcert -alias <alias_name> -file <certificate_file> -keystore <truststore_name> -storepass <password>
```

* `-importcert`: Imports a certificate into the keystore (or truststore).
* `-alias caroot`: Specifies the alias for the trusted certificate.
* `-file caroot.crt`: Path to the certificate file to be imported.
* `-keystore truststore.jks`: Specifies the truststore file.
* `-storepass changeit`: Password for the truststore

```
// Examples

// Import a trusted certificate into the truststore
keytool -importcert -alias caroot -file caroot.crt -keystore truststore.jks -storepass changeit
```

### **Removing an Untrusted Certificate**

Removing a certificate from the truststore involves deleting the entry identified by its alias.

```bash
keytool -delete -alias <alias_name> -keystore <truststore_name> -storepass <password>
```

* `-delete`: Deletes an entry from the keystore (or truststore).
* `-alias caroot`: Specifies the alias of the entry to be deleted.
* `-keystore truststore.jks`: Specifies the truststore file.
* `-storepass changeit`: Password for the truststore.

```
// Examples

// Delete an untrusted certificate from the truststore
keytool -delete -alias caroot -keystore truststore.jks -storepass changeit
```

### Listing Entries in a Truststore

Listing the aliases of all entries in the truststore.

```bash
keytool -list -keystore <truststore_name> -storepass <password>
```

* `-list`: Lists the contents of the keystore (or truststore).
* `-keystore truststore.jks`: Specifies the truststore file.
* `-storepass changeit`: Password for the truststore.

```
// Examples

// List all entries in the truststore
keytool -list -keystore truststore.jks -storepass changeit
```

### Verifying TrustStore Contents

Verifying the contents of the truststore involves listing detailed information about each entry to ensure the certificates are correct and trusted.&#x20;

```bash
keytool -list -v -keystore <truststore_name> -storepass <password>
```

* `-list -v`: Lists the contents of the keystore (or truststore) in verbose mode, showing detailed information.
* `-keystore truststore.jks`: Specifies the truststore file.
* `-storepass changeit`: Password for the truststore.

```
// Examples

// View detailed information about the truststore
keytool -list -v -keystore truststore.jks -storepass changeit
```

### Updating a TrustStore&#x20;

Updating a truststore involves adding, removing, or replacing trusted certificates. Use the `-importcert` and `-delete` commands as described below to add, remove, or replace certificates in the truststore.

```
// Examples

// Add a trusted certificate
keytool -importcert -alias newroot -file newroot.crt -keystore truststore.jks -storepass changeit

// Remove an old certificate
keytool -delete -alias oldroot -keystore truststore.jks -storepass changeit

// Replace a certificate
// Remove the old certificate
keytool -delete -alias root -keystore truststore.jks -storepass changeit
// Add the new certificate
keytool -importcert -alias root -file newroot.crt -keystore truststore.jks -storepass changeit
```

### Backing Up a TrustStore

Backing up a truststore involves copying the truststore file to a safe location.

{% hint style="info" %}
Use standard file copy commands (e.g., `cp` for Unix/Linux, `copy` for Windows) to create a backup of the truststore file.
{% endhint %}

```
// Examples

// Copy the truststore file to a backup location
cp truststore.jks truststore_backup.jks
```
