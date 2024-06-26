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



## Keytool Operations

### Key

Generating a Symmetric Key&#x20;

Generating an Asymmetric Key Pair

#### **Setting a Key Entry's Alias**

#### Changing a Key Password

#### Exporting a Key Pair&#x20;

#### Importing a Key Pair&#x20;

#### Deleting a Key Entry



### Certificate

#### Exporting a Certificate

#### Displaying Certificate Information

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

