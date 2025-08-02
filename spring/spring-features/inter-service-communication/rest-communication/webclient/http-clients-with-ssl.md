---
hidden: true
---

# HTTP Clients with SSL

## About

By default, WebClient uses the JVM’s built-in trust store (`cacerts`) to validate SSL certificates. This works for public APIs and standard HTTPS websites. But modern enterprise systems deal with:

* Private APIs across data centers
* Zero-trust networks
* Internal services signed by private CAs
* Mutual TLS between services

In such scenarios, **SSL customization is not optional—it’s mandatory** for secure and reliable communication.

## **Scenarios**

<table data-header-hidden data-full-width="true"><thead><tr><th width="184.9053955078125"></th><th width="252.8602294921875"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>What’s Required</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Calling internal service signed with a self-signed certificate</strong></td><td>Configure a <code>TrustManager</code> with a custom trust store that includes the internal certificate.</td><td>Internal services in closed networks often use self-signed certificates. These are not recognized by default JVM trust stores, so you must explicitly trust them by loading them into a custom trust store and wiring that into your WebClient's SSL context.</td></tr><tr><td><strong>Mutual TLS (mTLS) between microservices</strong></td><td>Provide a client certificate and private key via a <code>KeyManager</code>.</td><td>Mutual TLS is used when both client and server need to authenticate each other. Your WebClient must be configured with a client-side certificate and private key (from a key store) to establish the SSL handshake. This is common in secure service meshes, zero-trust networks, or regulated industries.</td></tr><tr><td><strong>Certificate pinning</strong></td><td>Implement a custom <code>X509TrustManager</code> that validates specific certificate fingerprints.</td><td>Instead of trusting a certificate chain or CA, your application pins one or more known public keys or cert fingerprints. This adds extra protection against CA compromises or man-in-the-middle attacks. You override the default trust logic with custom fingerprint checks.</td></tr><tr><td><strong>Disabling SSL verification in CI or mock environments</strong></td><td>Provide a permissive <code>HostnameVerifier</code> and trust-all <code>TrustManager</code> (only for non-production use).</td><td>For local development or CI pipelines where strict SSL validation is not feasible (e.g., expired certs, mock servers), you can disable checks. However, this approach <strong>must never</strong> be promoted to production due to extreme security risk. This setup is usually isolated in test-specific configs or profiles.</td></tr><tr><td><strong>Different trust rules per target host or environment</strong></td><td>Build and apply dynamic trust configurations based on the hostname or target service.</td><td>When interacting with multiple services—some public, some internal—you might need different trust stores or key pairs for each. You can create per-host SSL contexts and inject the right one dynamically at runtime, either via configuration-based routing or by customizing the <code>HttpClient</code> logic used in WebClient.</td></tr></tbody></table>

## **Trust Store vs Key Store**

<table data-header-hidden data-full-width="true"><thead><tr><th width="131.03387451171875"></th><th width="377.5521240234375"></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Trust Store</strong></td><td><strong>Key Store</strong></td></tr><tr><td><strong>Purpose</strong></td><td>Holds certificates of external <strong>trusted parties</strong> (usually servers or Certificate Authorities)</td><td>Holds your application's <strong>own certificates</strong> and <strong>private keys</strong> used for identification</td></tr><tr><td><strong>Used For</strong></td><td><strong>Verifying</strong> the identity of the remote server (e.g., during HTTPS handshake)</td><td><strong>Proving</strong> your identity to the remote party (e.g., in mutual TLS scenarios)</td></tr><tr><td><strong>Contents</strong></td><td>Trusted certificates (e.g., <code>.cer</code>, <code>.crt</code>, or public certs from CAs)</td><td>Private key and corresponding public certificate chain (e.g., in a <code>.p12</code> or <code>.jks</code> file)</td></tr><tr><td><strong>Example Usage</strong></td><td>Trusting a backend service’s certificate or an internal self-signed cert</td><td>Exposing your app to secure client connections or enabling mutual authentication</td></tr><tr><td><strong>Format</strong></td><td><code>.jks</code>, <code>.p12</code>, or PEM files</td><td><code>.jks</code>, <code>.p12</code>, or PEM + Key</td></tr><tr><td><strong>Spring Configuration Example</strong></td><td>Loaded into <code>TrustManagerFactory</code> and applied to <code>SslContext</code></td><td>Loaded into <code>KeyManagerFactory</code> and used in mTLS configurations</td></tr><tr><td><strong>Tools for Management</strong></td><td><code>keytool</code>, <code>openssl</code></td><td><code>keytool</code>, <code>openssl</code></td></tr><tr><td><strong>Where It's Referenced</strong></td><td>Typically required for <strong>outgoing</strong> connections where the client must validate the server</td><td>Required for <strong>incoming</strong> connections or mTLS where the server must validate the client</td></tr></tbody></table>

#### **How They Work Together in HTTPS / mTLS ?**

* In **regular HTTPS**, only the **trust store** is used to verify the remote (server) certificate.
* In **mutual TLS**, both **trust store** and **key store** are used:
  * The client uses the **trust store** to validate the server.
  * The client also uses the **key store** to send its own certificate and prove its identity.

{% hint style="info" %}
Think of the **trust store** like your personal contact list: it contains people you trust to talk to.\
The **key store** is like your own government-issued ID: you use it to prove who you are when someone asks for identification.
{% endhint %}

#### **When Configuring in WebClient**

* If your WebClient needs to talk to a **self-signed internal service**, configure a **trust store** with the server cert.
* If your WebClient participates in **mutual TLS**, you also need a **key store** to provide your client certificate.

## **How It Works Under the Hood ?**

When we configure WebClient with custom SSL, here's what happens during the request:

1. WebClient (via Netty) initiates an HTTPS connection.
2. SSL handshake begins:
   * The server sends its certificate.
   * The client verifies it using the **TrustManager**.
   * If mutual TLS is enabled, the client sends its own cert from the **KeyManager**.
3. The secure connection is established or rejected.
4. HTTP request is sent securely.

## **Typical Approaches to Custom SSL Setup**

### 1. Trusting Self-Signed Certificates (Custom Trust Store)

In production, services typically use certificates issued by trusted Certificate Authorities (CAs) like DigiCert or Let's Encrypt. But in many real-world enterprise scenarios—especially in internal or non-production environments—you may:

* Use **self-signed certificates**
* Use an **internal certificate authority (CA)**
* Need to test secure HTTPS endpoints without buying certificates from a public CA

By default, the Java Virtual Machine (JVM) uses a **default trust store** (`cacerts`) that doesn't trust self-signed or internal CA certificates unless explicitly added.

This leads to common errors like:

* `javax.net.ssl.SSLHandshakeException: PKIX path building failed`
* `unable to find valid certification path to requested target`

To resolve this, we configure your application to **load a custom trust store** (e.g., a `.jks` or `.p12` file) that contains the required self-signed certificate or the root/intermediate certificate of your internal CA.

#### **Steps to Create a Trust Store**

1. Export the certificate from the remote server (using browser or `openssl`).
2. Import it into a `.jks` trust store using `keytool`:

```bash
keytool -import -alias my-service-cert \
        -file my-service.crt \
        -keystore truststore.jks \
        -storepass changeit
```

**Code: WebClient with Custom Trust Store (Reactor Netty)**

```java
@Configuration
public class SecureWebClientConfig {

    @Bean
    public WebClient webClientWithCustomTrustStore() throws Exception {
        // Load truststore
        KeyStore trustStore = KeyStore.getInstance("JKS");
        try (FileInputStream trustStoreFile = new FileInputStream("truststore.jks")) {
            trustStore.load(trustStoreFile, "changeit".toCharArray()); // password for the .jks
        }

        // Initialize TrustManager with custom truststore
        TrustManagerFactory trustManagerFactory =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        trustManagerFactory.init(trustStore);

        // Create SSL context
        SslContext sslContext = SslContextBuilder.forClient()
                .trustManager(trustManagerFactory)
                .build();

        // Configure Netty client with custom SSL
        HttpClient httpClient = HttpClient.create()
                .secure(sslSpec -> sslSpec.sslContext(sslContext));

        // Create and return WebClient
        return WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }
}
```

#### **Structure of the Trust Store**

* Format: Typically `.jks`, but `.p12` is also supported (PKCS12).
* Contains: Certificates of the services you call.
* Secured with a password (e.g., `"changeit"`).

You can place the file in `src/main/resources` and load it with classpath if preferred:

```java
try (InputStream trustStream = getClass().getResourceAsStream("/truststore.jks")) {
    ...
}
```

#### **Using This WebClient**

```java
@Autowired
private WebClient webClientWithCustomTrustStore;

public Mono<String> callSecureService() {
    return webClientWithCustomTrustStore
        .get()
        .uri("https://internal-secure-service/api/secure-data")
        .retrieve()
        .bodyToMono(String.class);
}
```

### 2. Mutual TLS (Using Key Store and Trust Store)

Mutual TLS (mTLS) is a two-way SSL authentication mechanism where **both client and server authenticate each other** using certificates.

* The **server** presents its certificate to the client.
* The **client** presents its certificate to the server.

This is commonly used in **enterprise systems** or **zero-trust architectures**, particularly for **internal service-to-service communication** where strong authentication and encryption are required.

#### **When Do We Need It ?**

* Secure communication between microservices inside private networks
* API Gateways or BFFs validating backend services
* Ensuring only trusted applications talk to each other
* Regulatory compliance (e.g., PCI-DSS, HIPAA)

#### **Prerequisites**

We need:

* A **trust store**: Contains certificates of the services you're talking to.
* A **key store**: Contains your own certificate + private key to present to the server.

Use `keytool` or `openssl` to:

* Generate keys and certificates
* Sign and import them into `.jks` or `.p12` files

#### Code

#### `MutualTLSWebClientConfig.java`

```java
package com.example.config;

import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;

import javax.net.ssl.KeyManagerFactory;
import javax.net.ssl.TrustManagerFactory;
import java.io.FileInputStream;
import java.security.KeyStore;

@Configuration
public class MutualTLSWebClientConfig {

    @Bean
    public WebClient mutualTlsWebClient() throws Exception {
        // Load TrustStore
        KeyStore trustStore = KeyStore.getInstance("JKS");
        try (FileInputStream trustStoreFile = new FileInputStream("truststore.jks")) {
            trustStore.load(trustStoreFile, "trustpass".toCharArray());
        }
        TrustManagerFactory trustManagerFactory =
                TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        trustManagerFactory.init(trustStore);

        // Load KeyStore (client certificate + private key)
        KeyStore keyStore = KeyStore.getInstance("PKCS12");
        try (FileInputStream keyStoreFile = new FileInputStream("keystore.p12")) {
            keyStore.load(keyStoreFile, "keypass".toCharArray());
        }
        KeyManagerFactory keyManagerFactory =
                KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
        keyManagerFactory.init(keyStore, "keypass".toCharArray());

        // Create SSL Context with both KeyManager and TrustManager
        SslContext sslContext = SslContextBuilder.forClient()
                .keyManager(keyManagerFactory)
                .trustManager(trustManagerFactory)
                .build();

        // Configure WebClient with custom SSL
        HttpClient httpClient = HttpClient.create()
                .secure(sslSpec -> sslSpec.sslContext(sslContext));

        return WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }
}
```



### 3. Disabling SSL Validation (For CI or Local Mocks ONLY)



### 4. Certificate Pinning



### 5. Multiple WebClients With Different SSL Contexts



## **Testing Custom SSL Setup**





