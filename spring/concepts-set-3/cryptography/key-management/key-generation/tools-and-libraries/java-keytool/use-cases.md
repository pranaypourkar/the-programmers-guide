# Use Cases

## **Securing Web Servers with SSL/TLS**

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

## **Authenticating Clients in a Secure Environment**

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
