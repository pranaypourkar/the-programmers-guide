# HTTP Clients with SSL

## About

By default, WebClient uses the JVM’s built-in trust store (`cacerts`) to validate SSL certificates. This works for public APIs and standard HTTPS websites. But modern enterprise systems deal with:

* Private APIs across data centers
* Zero-trust networks
* Internal services signed by private CAs
* Mutual TLS between services

In such scenarios, **SSL customization is not optional—it’s mandatory** for secure and reliable communication.

## **Scenarios**

<table data-header-hidden data-full-width="true"><thead><tr><th width="184.9053955078125"></th><th width="252.8602294921875"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>What’s Required</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Calling internal service signed with a self-signed certificate</strong></td><td>Configure a <code>TrustManager</code> with a custom trust store that includes the internal certificate.</td><td>Internal services in closed networks often use self-signed certificates. These are not recognized by default JVM trust stores, so we must explicitly trust them by loading them into a custom trust store and wiring that into our WebClient's SSL context.</td></tr><tr><td><strong>Mutual TLS (mTLS) between microservices</strong></td><td>Provide a client certificate and private key via a <code>KeyManager</code>.</td><td>Mutual TLS is used when both client and server need to authenticate each other. Our WebClient must be configured with a client-side certificate and private key (from a key store) to establish the SSL handshake. This is common in secure service meshes, zero-trust networks, or regulated industries.</td></tr><tr><td><strong>Certificate pinning</strong></td><td>Implement a custom <code>X509TrustManager</code> that validates specific certificate fingerprints.</td><td>Instead of trusting a certificate chain or CA, our application pins one or more known public keys or cert fingerprints. This adds extra protection against CA compromises or man-in-the-middle attacks. We override the default trust logic with custom fingerprint checks.</td></tr><tr><td><strong>Disabling SSL verification in CI or mock environments</strong></td><td>Provide a permissive <code>HostnameVerifier</code> and trust-all <code>TrustManager</code> (only for non-production use).</td><td>For local development or CI pipelines where strict SSL validation is not feasible (e.g., expired certs, mock servers), we can disable checks. However, this approach <strong>must never</strong> be promoted to production due to extreme security risk. This setup is usually isolated in test-specific configs or profiles.</td></tr><tr><td><strong>Different trust rules per target host or environment</strong></td><td>Build and apply dynamic trust configurations based on the hostname or target service.</td><td>When interacting with multiple services—some public, some internal we might need different trust stores or key pairs for each. We can create per-host SSL contexts and inject the right one dynamically at runtime, either via configuration-based routing or by customizing the <code>HttpClient</code> logic used in WebClient.</td></tr></tbody></table>

## **Trust Store vs Key Store**

<table data-header-hidden data-full-width="true"><thead><tr><th width="131.03387451171875"></th><th width="377.5521240234375"></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Trust Store</strong></td><td><strong>Key Store</strong></td></tr><tr><td><strong>Purpose</strong></td><td>Holds certificates of external <strong>trusted parties</strong> (usually servers or Certificate Authorities)</td><td>Holds our application's <strong>own certificates</strong> and <strong>private keys</strong> used for identification</td></tr><tr><td><strong>Used For</strong></td><td><strong>Verifying</strong> the identity of the remote server (e.g., during HTTPS handshake)</td><td><strong>Proving</strong> our identity to the remote party (e.g., in mutual TLS scenarios)</td></tr><tr><td><strong>Contents</strong></td><td>Trusted certificates (e.g., <code>.cer</code>, <code>.crt</code>, or public certs from CAs)</td><td>Private key and corresponding public certificate chain (e.g., in a <code>.p12</code> or <code>.jks</code> file)</td></tr><tr><td><strong>Example Usage</strong></td><td>Trusting a backend service’s certificate or an internal self-signed cert</td><td>Exposing our app to secure client connections or enabling mutual authentication</td></tr><tr><td><strong>Format</strong></td><td><code>.jks</code>, <code>.p12</code>, or PEM files</td><td><code>.jks</code>, <code>.p12</code>, or PEM + Key</td></tr><tr><td><strong>Spring Configuration Example</strong></td><td>Loaded into <code>TrustManagerFactory</code> and applied to <code>SslContext</code></td><td>Loaded into <code>KeyManagerFactory</code> and used in mTLS configurations</td></tr><tr><td><strong>Tools for Management</strong></td><td><code>keytool</code>, <code>openssl</code></td><td><code>keytool</code>, <code>openssl</code></td></tr><tr><td><strong>Where It's Referenced</strong></td><td>Typically required for <strong>outgoing</strong> connections where the client must validate the server</td><td>Required for <strong>incoming</strong> connections or mTLS where the server must validate the client</td></tr></tbody></table>

#### **How They Work Together in HTTPS / mTLS ?**

* In **regular HTTPS**, only the **trust store** is used to verify the remote (server) certificate.
* In **mutual TLS**, both **trust store** and **key store** are used:
  * The client uses the **trust store** to validate the server.
  * The client also uses the **key store** to send its own certificate and prove its identity.

{% hint style="info" %}
Think of the **trust store** like our personal contact list: it contains people we trust to talk to.\
The **key store** is like our own government-issued ID. We use it to prove who we are when someone asks for identification.
{% endhint %}

#### **When Configuring in WebClient**

* If our WebClient needs to talk to a **self-signed internal service**, configure a **trust store** with the server cert.
* If our WebClient participates in **mutual TLS**, we also need a **key store** to provide our client certificate.

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

In production, services typically use certificates issued by trusted Certificate Authorities (CAs) like DigiCert or Let's Encrypt. But in many real-world enterprise scenarios—especially in internal or non-production environments we may:

* Use **self-signed certificates**
* Use an **internal certificate authority (CA)**
* Need to test secure HTTPS endpoints without buying certificates from a public CA

By default, the Java Virtual Machine (JVM) uses a **default trust store** (`cacerts`) that doesn't trust self-signed or internal CA certificates unless explicitly added.

This leads to common errors like:

* `javax.net.ssl.SSLHandshakeException: PKIX path building failed`
* `unable to find valid certification path to requested target`

To resolve this, we configure our application to **load a custom trust store** (e.g., a `.jks` or `.p12` file) that contains the required self-signed certificate or the root/intermediate certificate of our internal CA.

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
* Contains: Certificates of the services we call.
* Secured with a password (e.g., `"changeit"`).

We can place the file in `src/main/resources` and load it with classpath if preferred:

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

* A **trust store**: Contains certificates of the services we are talking to.
* A **key store**: Contains our own certificate + private key to present to the server.

Use `keytool` or `openssl` to:

* Generate keys and certificates
* Sign and import them into `.jks` or `.p12` files

#### Code

_MutualTLSWebClientConfig.java_

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

<table><thead><tr><th width="209.71612548828125">Component</th><th>Purpose</th></tr></thead><tbody><tr><td><code>trustStore.jks</code></td><td>Trusts the server's certificate (or the CA that signed it)</td></tr><tr><td><code>keystore.p12</code></td><td>Stores client cert and private key to authenticate itself</td></tr><tr><td><code>KeyManagerFactory</code></td><td>Used to present client credentials</td></tr><tr><td><code>TrustManagerFactory</code></td><td>Used to validate the server’s certificate</td></tr></tbody></table>

#### **Use Example**

```java
@Autowired
private WebClient mutualTlsWebClient;

public Mono<String> fetchSecureData() {
    return mutualTlsWebClient.get()
            .uri("https://secure.internal.service/api/data")
            .retrieve()
            .bodyToMono(String.class);
}
```

### 3. Disabling SSL Validation (For CI or Local Mocks ONLY)

Disabling SSL validation allows an HTTP client to:

* **Trust all SSL certificates**, even self-signed or expired ones
* **Bypass hostname verification**, accepting mismatched hostnames

This is **extremely dangerous in production** and should **only be used in controlled test environments** like:

* Local development
* CI pipelines using mock/stub services
* Testing internal services before certs are provisioned

#### **Why Would We Do This ?**

<table data-full-width="true"><thead><tr><th width="419.32208251953125">Scenario</th><th>Reason</th></tr></thead><tbody><tr><td>CI pipelines with stubbed services over HTTPS</td><td>Mock servers use self-signed or untrusted certificates</td></tr><tr><td>Developer is testing internal microservices locally</td><td>No production-like certs available</td></tr><tr><td>Legacy systems using expired certs for testing</td><td>Bypassing SSL issues temporarily</td></tr></tbody></table>

#### **Risks**

* Leaves us vulnerable to **Man-in-the-Middle (MitM)** attacks
* Completely bypasses **SSL/TLS verification**, making the communication untrustworthy
* Can **mask certificate misconfiguration issues**

Never commit or ship code with SSL disabled to production environments.

**Code to** **Trust All Certificates + Disable Hostname Verification**

```java
import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import io.netty.handler.ssl.util.InsecureTrustManagerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.tcp.SslProvider;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;

import javax.net.ssl.SSLException;

@Configuration
public class InsecureWebClientConfig {

    @Bean
    public WebClient insecureWebClient() throws SSLException {
        // Trust all certificates
        SslContext sslContext = SslContextBuilder.forClient()
                .trustManager(InsecureTrustManagerFactory.INSTANCE)
                .build();

        // Disable hostname verification
        HttpClient httpClient = HttpClient.create()
                .secure(sslContextSpec -> sslContextSpec
                        .sslContext(sslContext)
                        .handlerConfigurator(sslHandler -> 
                            sslHandler.setHostnameVerifier((hostname, session) -> true)
                        )
                );

        return WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }
}
```

<table data-full-width="true"><thead><tr><th width="388.69189453125">Component</th><th>Role</th></tr></thead><tbody><tr><td><code>InsecureTrustManagerFactory.INSTANCE</code></td><td>Accepts all certificates</td></tr><tr><td><code>setHostnameVerifier(... -> true)</code></td><td>Disables hostname checks</td></tr><tr><td><code>SslContextBuilder.forClient()</code></td><td>Builds the client SSL context</td></tr><tr><td><code>HttpClient.create().secure(...)</code></td><td>Applies custom SSL context to Reactor Netty HTTP client</td></tr></tbody></table>

#### **Best Practices for Safer Testing**

* Use a **local CA and trusted certs** for mocks (e.g., mkcert)
*   Always wrap this logic in a **conditional bean or Spring profile**

    ```java
    @Profile("dev")
    @Bean
    public WebClient insecureWebClient() { ... }
    ```

We can also make the insecure client conditional on an environment property like:

```java
@Value("${webclient.insecure:false}")
private boolean insecure;

@Bean
public WebClient webClient() {
    return insecure ? insecureWebClient() : secureWebClient();
}
```

This ensures we don't accidentally deploy insecure code into production.

### 4. Certificate Pinning

Certificate pinning is a security technique where our application **trusts only a specific certificate or public key** even if it is otherwise valid and trusted by the system’s trust store.

Instead of trusting any certificate issued by a recognized Certificate Authority (CA), we “pin” the application to a known, fixed certificate or public key fingerprint.

#### **Why Use Certificate Pinning ?**

<table data-full-width="true"><thead><tr><th width="253.431396484375">Reason</th><th>Description</th></tr></thead><tbody><tr><td>Prevent MitM attacks</td><td>Ensures attackers cannot impersonate the server even with a valid certificate</td></tr><tr><td>Extra layer of trust</td><td>Protects against CA compromises</td></tr><tr><td>Ideal for sensitive systems</td><td>Financial services, authentication providers, and internal microservices benefit the most</td></tr></tbody></table>

#### **How It Works**

When the WebClient makes an HTTPS call, a custom `X509TrustManager` intercepts the certificate and compares it against **pre-approved fingerprints or public keys**.

If the certificate matches, the request proceeds. Otherwise, it's rejected—even if the cert is valid.

#### **Risks and Trade-Offs**

<table><thead><tr><th width="234.94183349609375">Risk</th><th>Explanation</th></tr></thead><tbody><tr><td>Certificate rotation issues</td><td>If certs change and app isn’t updated, connections will fail</td></tr><tr><td>Maintenance burden</td><td>We must manually maintain valid pins</td></tr><tr><td>Breaks flexibility</td><td>Can’t rely on usual CA trust hierarchy</td></tr></tbody></table>

#### **How to Implement Certificate Pinning in WebClient**

This implementation assumes pinning via **SHA-256 fingerprint of the certificate**.

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import reactor.netty.http.client.HttpClient;

import javax.net.ssl.*;
import java.security.cert.CertificateEncodingException;
import java.security.cert.X509Certificate;
import java.util.Base64;
import java.security.MessageDigest;

@Configuration
public class PinnedCertWebClientConfig {

    // Expected SHA-256 certificate fingerprint (Base64 encoded)
    private static final String PINNED_FINGERPRINT = "QWxhZGRpbjpPcGVuU2VzYW1l"; // example

    @Bean
    public WebClient pinnedCertWebClient() throws Exception {
        TrustManager[] trustManagers = new TrustManager[]{
            new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain, String authType) { }

                public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
                    if (chain == null || chain.length == 0) {
                        throw new CertificateException("Certificate chain is invalid");
                    }

                    X509Certificate serverCert = chain[0];
                    String actualFingerprint = getFingerprint(serverCert);

                    if (!PINNED_FINGERPRINT.equals(actualFingerprint)) {
                        throw new CertificateException("Certificate pinning failed. Fingerprint mismatch.");
                    }
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return new X509Certificate[0];
                }

                private String getFingerprint(X509Certificate cert) throws CertificateException {
                    try {
                        MessageDigest digest = MessageDigest.getInstance("SHA-256");
                        byte[] encoded = cert.getEncoded();
                        byte[] hash = digest.digest(encoded);
                        return Base64.getEncoder().encodeToString(hash);
                    } catch (Exception e) {
                        throw new CertificateException("Could not calculate certificate fingerprint", e);
                    }
                }
            }
        };

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustManagers, new java.security.SecureRandom());

        HttpClient httpClient = HttpClient.create()
            .secure(sslContextSpec -> sslContextSpec.sslContext(sslContext));

        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }
}
```

#### **How to Get the Fingerprint**

Run the following to extract fingerprint from a certificate file:

```bash
openssl x509 -in server.crt -noout -fingerprint -sha256
```

Then Base64-encode the hex value or directly compare raw hex (change code accordingly).

#### **When to Use Certificate Pinning**

| Environment                              | Reason                                    |
| ---------------------------------------- | ----------------------------------------- |
| Production with strict zero-trust policy | Extra layer of identity assurance         |
| High-security applications               | Financial APIs, healthcare, internal auth |
| Direct device-to-service communication   | IoT, mobile apps calling backend          |

#### **When Not to Use It**

| Situation                             | Reason                                       |
| ------------------------------------- | -------------------------------------------- |
| Certificate rotation is automated     | Pins will break without manual updates       |
| Using public APIs with rotating certs | We will likely break connectivity            |
| Maintaining multiple environments     | Pinning adds complexity in staging, QA, etc. |

#### **Best Practices**

* Use a **fallback trust manager** if pinning fails (optional)
* Keep the pinned value in a **centralized config** for easier rotation
* Pin **public key or subject public key info (SPKI)** instead of full cert if we expect cert changes but key stability

### 5. Multiple WebClients With Different SSL Contexts

In real-world enterprise applications, we might need to interact with multiple external systems—each with **different SSL requirements**. One might use a self-signed certificate, another might require **mutual TLS**, and yet another might use standard CA-signed certificates.

Using **a single WebClient bean** doesn’t work well in this scenario because SSL configuration (Trust Store, Key Store) is tightly coupled with the HTTP client.

Hence, we need **multiple WebClient instances**, each with its **own SSL context**.

#### **How to Set Up Multiple WebClients with Custom SSL Contexts**

Each WebClient is configured with its **own `ReactorClientHttpConnector`**, which is backed by a different `HttpClient` using a separate `SSLContext`.

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import reactor.netty.http.client.HttpClient;

import javax.net.ssl.SSLContext;
import java.security.KeyStore;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.KeyManagerFactory;

@Configuration
public class MultiSSLWebClientConfig {

    @Bean
    public WebClient selfSignedClient() throws Exception {
        SSLContext sslContext = createSSLContext("classpath:selfsigned-truststore.jks", "password", null, null);
        HttpClient httpClient = HttpClient.create()
            .secure(t -> t.sslContext(sslContext));
        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }

    @Bean
    public WebClient mutualTlsClient() throws Exception {
        SSLContext sslContext = createSSLContext(
            "classpath:mutual-tls-truststore.jks", "trustpass",
            "classpath:mutual-tls-keystore.jks", "keypass"
        );
        HttpClient httpClient = HttpClient.create()
            .secure(t -> t.sslContext(sslContext));
        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }

    private SSLContext createSSLContext(
        String trustStorePath, String trustStorePassword,
        String keyStorePath, String keyStorePassword
    ) throws Exception {

        // Load trust store
        KeyStore trustStore = KeyStore.getInstance("JKS");
        trustStore.load(
            getClass().getResourceAsStream(trustStorePath),
            trustStorePassword.toCharArray()
        );
        TrustManagerFactory tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
        tmf.init(trustStore);

        // Load key store (optional)
        KeyManagerFactory kmf = null;
        if (keyStorePath != null) {
            KeyStore keyStore = KeyStore.getInstance("JKS");
            keyStore.load(
                getClass().getResourceAsStream(keyStorePath),
                keyStorePassword.toCharArray()
            );
            kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
            kmf.init(keyStore, keyStorePassword.toCharArray());
        }

        // Build SSLContext
        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(
            kmf != null ? kmf.getKeyManagers() : null,
            tmf.getTrustManagers(),
            null
        );
        return sslContext;
    }
}
```

#### **Usage Example in Service Layer**

```java
@Service
public class PaymentService {

    private final WebClient selfSignedClient;
    private final WebClient mutualTlsClient;

    public PaymentService(
        @Qualifier("selfSignedClient") WebClient selfSignedClient,
        @Qualifier("mutualTlsClient") WebClient mutualTlsClient
    ) {
        this.selfSignedClient = selfSignedClient;
        this.mutualTlsClient = mutualTlsClient;
    }

    public Mono<String> callServiceA() {
        return selfSignedClient.get()
            .uri("https://self-signed-service/api/data")
            .retrieve()
            .bodyToMono(String.class);
    }

    public Mono<String> callServiceB() {
        return mutualTlsClient.post()
            .uri("https://secure-service/api/submit")
            .retrieve()
            .bodyToMono(String.class);
    }
}
```

## **Testing Custom SSL Setup**

Custom SSL configurations (like self-signed certs, mutual TLS, certificate pinning) are **notoriously error-prone**. If misconfigured, they don’t fail gracefully the client simply fails to connect, often with obscure error messages. That’s why robust testing is essential.

We should validate:

* The trust and key stores are correctly loaded.
* The SSL handshake completes successfully.
* Our WebClient communicates securely as intended.
* Errors are surfaced clearly (e.g., untrusted cert, wrong alias, expired cert, hostname mismatch).

### **Testing Scenarios**

| Scenario                                | Goal                                              |
| --------------------------------------- | ------------------------------------------------- |
| Integration test with mock HTTPS server | Verify end-to-end behavior of SSL context         |
| CI pipeline SSL validation              | Fail builds early if certs are expired or invalid |
| Negative test with wrong trust store    | Ensure application fails securely                 |
| Mutual TLS setup test                   | Confirm handshake using client cert/key           |
| Certificate pinning check               | Block unknown certs intentionally                 |

#### **1. Integration Testing with a Local HTTPS Server**

We can use tools like **WireMock**, **MockServer**, or **Testcontainers with NGINX** configured with HTTPS to simulate remote services.

**Example: WireMock with HTTPS**

```java
import com.github.tomakehurst.wiremock.WireMockServer;
import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
import org.junit.jupiter.api.*;
import org.springframework.web.reactive.function.client.WebClient;

class SslWebClientTest {

    static WireMockServer wireMockServer;

    WebClient client;

    @BeforeAll
    static void startServer() {
        wireMockServer = new WireMockServer(WireMockConfiguration.options()
            .httpsPort(8443)
            .keystorePath("src/test/resources/test-keystore.jks")
            .keystorePassword("testpass"));
        wireMockServer.start();
    }

    @AfterAll
    static void stopServer() {
        wireMockServer.stop();
    }

    @BeforeEach
    void setupClient() throws Exception {
        // Create WebClient using truststore that trusts test-keystore cert
        SSLContext sslContext = SslUtils.createSSLContext(
            "src/test/resources/test-truststore.jks", "testpass",
            null, null
        );

        HttpClient httpClient = HttpClient.create().secure(spec -> spec.sslContext(sslContext));
        client = WebClient.builder()
            .baseUrl("https://localhost:8443")
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }

    @Test
    void shouldConnectWithValidTrustStore() {
        wireMockServer.stubFor(get(urlEqualTo("/hello"))
            .willReturn(aResponse().withBody("Secure Hello")));

        String body = client.get().uri("/hello")
            .retrieve()
            .bodyToMono(String.class)
            .block();

        Assertions.assertEquals("Secure Hello", body);
    }
}
```

#### **2. Negative Testing With Wrong Trust Store**

Try running a test where our WebClient uses a trust store **that does not include** the server’s certificate.

Expectation: An `SSLHandshakeException` should be thrown.

This helps validate that our certificate validation logic is strict and correctly enforced.

#### **3. Testing Mutual TLS Setup**

Simulate an endpoint requiring client authentication using:

* NGINX configured with `ssl_verify_client on;`
* A custom Spring Boot server with `server.ssl.client-auth=need`

Then test our WebClient with correct and incorrect keystore configuration to ensure:

* Handshake succeeds with proper keystore
* Handshake fails with missing/invalid client cert

#### **4. Testcontainers for Isolated SSL Testing**

We can use Testcontainers with Dockerized services that have:

* Different cert setups (self-signed, CA-signed)
* TLS-only ports
* Simulated network failures

This helps test realistic environments in our integration pipeline.
