# HTTP Client with SSL

## About

OpenFeign, when configured to work over HTTPS, must ensure secure, trusted communication with external or internal APIs. This involves verifying certificates, supporting encrypted channels (SSL/TLS), and optionally providing client certificates for mutual authentication.

SSL configuration is **not a feature of Feign itself**, but rather of the **underlying HTTP client** (like Apache HttpClient or OkHttp) used by Feign. Therefore, **Feign’s SSL behavior is inherited** from the HTTP client it delegates to. Without correct SSL configuration, secure communication fails, often with handshake exceptions or trust errors.

## Why SSL Configuration Matters

1. **Security Compliance**\
   SSL/TLS is critical in meeting regulatory standards (e.g., PCI-DSS, HIPAA, GDPR) by ensuring that sensitive data is encrypted during transit.
2. **Enterprise Microservices**\
   Internal APIs in large enterprises often rely on:
   * **Self-signed certificates**
   * **Internal Certificate Authorities**
   * **Mutual TLS (mTLS)** for two-way identity verification\
     These are not automatically trusted by the JVM, so SSL configuration becomes mandatory.
3. **Avoiding Failures**\
   If a client connects to an endpoint over `https://`, and SSL is not properly configured:
   * We will face `javax.net.ssl.SSLHandshakeException`
   * Our service may silently fail if fallback or retries are not configured
4. **Zero Trust and Secure Meshes**\
   In **service meshes** (e.g., Istio, Linkerd) or **zero-trust** networks, TLS is everywhere. Feign clients must adapt to support secure transport and verification in these ecosystems.

## **How SSL Works in Feign ?**

When we use OpenFeign to make HTTPS calls:

* The Feign client (via HTTP client underneath) **initiates an SSL handshake** with the server.
* The server provides a certificate.
* The client:
  * Verifies the certificate using its **truststore** (by default, JVM's `cacerts`)
  * Optionally sends its own **client certificate** (via a **keystore**) if mutual TLS is needed
* If either verification fails, the connection is rejected.

### SSL Components

<table><thead><tr><th width="158.1640625">Component</th><th>Description</th></tr></thead><tbody><tr><td><strong>Truststore</strong></td><td>Contains CA certs the client trusts (e.g., <code>cacerts</code>, or custom <code>.jks</code> file)</td></tr><tr><td><strong>Keystore</strong></td><td>Contains client’s own certificate (used in mutual TLS)</td></tr><tr><td><strong>HostnameVerifier</strong></td><td>Verifies the server’s certificate matches the expected hostname</td></tr><tr><td><strong>SSLContext</strong></td><td>Java's abstraction for secure SSL/TLS sockets</td></tr><tr><td><strong>Client Builder (Apache/OkHttp)</strong></td><td>Used to inject custom SSL configuration into Feign</td></tr></tbody></table>

### **Common Pitfalls in SSL with Feign**

<table><thead><tr><th width="257.56640625">Pitfall</th><th>Explanation</th></tr></thead><tbody><tr><td><code>PKIX path building failed</code></td><td>The certificate presented is not trusted (missing in truststore)</td></tr><tr><td>Self-signed certificate errors</td><td>JVM does not trust it by default</td></tr><tr><td>SSLHandshakeException</td><td>Indicates a failure during the SSL negotiation</td></tr><tr><td>Hostname mismatch</td><td>Certificate CN or SAN does not match the URL host</td></tr><tr><td>Using default SSL blindly</td><td>Works with public certs, but not with internal/mTLS</td></tr></tbody></table>

### **Typical Approaches to Custom SSL Setup** <a href="#typical-approaches-to-custom-ssl-setup" id="typical-approaches-to-custom-ssl-setup"></a>

When working in secure environments or communicating with services over HTTPS, it's often necessary to configure SSL behavior explicitly. While Feign itself doesn’t expose SSL configuration directly, the HTTP client (e.g., Apache HttpClient or OkHttp) used under the hood provides rich support.

### 1. Trusting Self-Signed Certificates (Custom Trust Store) <a href="#id-1.-trusting-self-signed-certificates-custom-trust-store" id="id-1.-trusting-self-signed-certificates-custom-trust-store"></a>

In many enterprise environments or test setups, the server may use a **self-signed certificate** that is **not trusted by the JVM** by default. To trust such certificates, we must:

* Export the certificate (`.cer`) from the server.
* Import it into a **custom truststore** (e.g., a `.jks` file).
* Load this truststore into the SSL context used by the HTTP client that Feign uses.

This ensures only that certificate (or issuer) is trusted, while keeping other validation mechanisms in place.

```java
package com.example.config;

import feign.Client;
import feign.httpclient.ApacheHttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import java.io.File;

@Configuration
public class FeignTrustStoreConfig {

    @Bean
    public Client feignClientWithTrustStore() throws Exception {
        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial(new File("src/main/resources/truststore.jks"), "trustpass".toCharArray())
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext))
                .build();

        return new ApacheHttpClient(httpClient);
    }
}
```

### 2. Mutual TLS (Using Key Store and Trust Store)

**Mutual TLS** (mTLS) is used when both server and client must authenticate each other using certificates. This is common in secure internal APIs and B2B communication.

To configure mTLS:

* The **truststore** contains the server CA certificate (as before).
* The **keystore** contains the client certificate and private key.

Both must be loaded into the SSL context.

```java
package com.example.config;

import feign.Client;
import feign.httpclient.ApacheHttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import java.io.File;

@Configuration
public class FeignMutualTLSConfig {

    @Bean
    public Client feignClientWithMutualTLS() throws Exception {
        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial(new File("src/main/resources/truststore.jks"), "trustpass".toCharArray())
                .loadKeyMaterial(new File("src/main/resources/keystore.jks"), "keypass".toCharArray(), "keypass".toCharArray())
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext))
                .build();

        return new ApacheHttpClient(httpClient);
    }
}
```

### 3. Disabling SSL Validation (For CI or Local Mocks ONLY)

In test or CI environments, we might interact with HTTPS endpoints using **self-signed or invalid certificates**. To avoid trust issues during testing, we can disable SSL validation entirely.

This should **never be used in production** as it makes the client accept any certificate without validation.

```java
package com.example.config;

import feign.Client;
import feign.httpclient.ApacheHttpClient;
import org.apache.http.conn.ssl.NoopHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;

@Configuration
public class FeignInsecureSSLConfig {

    @Bean
    public Client feignClientInsecure() throws Exception {
        TrustManager[] trustAllCerts = new TrustManager[]{
            new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain, String authType) {}
                public void checkServerTrusted(X509Certificate[] chain, String authType) {}
                public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
            }
        };

        SSLContext sslContext = SSLContext.getInstance("TLS");
        sslContext.init(null, trustAllCerts, new java.security.SecureRandom());

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext, NoopHostnameVerifier.INSTANCE))
                .build();

        return new ApacheHttpClient(httpClient);
    }
}
```

### 4. Certificate Pinning

**Certificate pinning** means that instead of trusting any certificate signed by a CA, we explicitly trust a known certificate or public key. This enhances security by preventing man-in-the-middle attacks, even if a CA is compromised.

This is commonly used in mobile apps and secure APIs where absolute trust is required.

In Java, this is usually implemented by overriding the `X509TrustManager` to **compare the certificate or its fingerprint** with the known pinned value.

**Example Strategy**

* Compute the SHA-256 fingerprint of the trusted certificate
* Match the fingerprint in a custom TrustManager

```java
package com.example.config;

import feign.Client;
import feign.httpclient.ApacheHttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import javax.net.ssl.X509TrustManager;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

@Configuration
public class FeignPinnedSSLConfig {

    private static final String EXPECTED_SHA256 = "AB:CD:12:34:..."; // our pinned fingerprint

    @Bean
    public Client feignClientWithPinning() throws Exception {
        X509TrustManager pinnedTrustManager = new X509TrustManager() {
            public void checkClientTrusted(X509Certificate[] chain, String authType) {}
            public void checkServerTrusted(X509Certificate[] chain, String authType) {
                String fingerprint = getSHA256(chain[0]);
                if (!EXPECTED_SHA256.equalsIgnoreCase(fingerprint)) {
                    throw new SecurityException("Certificate fingerprint mismatch");
                }
            }
            public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }

            private String getSHA256(X509Certificate cert) {
                try {
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] digest = md.digest(cert.getEncoded());
                    StringBuilder sb = new StringBuilder();
                    for (byte b : digest) {
                        sb.append(String.format("%02X:", b));
                    }
                    return sb.deleteCharAt(sb.length() - 1).toString();
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
            }
        };

        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial((chain, authType) -> {
                    pinnedTrustManager.checkServerTrusted(chain, authType);
                    return true;
                })
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext))
                .build();

        return new ApacheHttpClient(httpClient);
    }
}
```

### 5. Multiple Feign Clients With Different SSL Contexts

Sometimes different remote services require different SSL setups. For example:

* One service uses public SSL
* Another uses self-signed
* Another needs mutual TLS

We cannot use a **global HTTP client** with one SSL context in such cases. Instead, create multiple Feign clients, each with its **own configuration and SSL context**.

This is done by registering separate beans or using a `@Configuration` class with `@Qualifier`.

```java
package com.example.config;

import feign.Client;
import feign.httpclient.ApacheHttpClient;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContextBuilder;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.net.ssl.SSLContext;
import java.io.File;

@Configuration
public class FeignMultiSSLConfig {

    @Bean
    @Qualifier("clientA")
    public Client feignClientForServiceA() throws Exception {
        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial(new File("src/main/resources/truststoreA.jks"), "passA".toCharArray())
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext))
                .build();

        return new ApacheHttpClient(httpClient);
    }

    @Bean
    @Qualifier("clientB")
    public Client feignClientForServiceB() throws Exception {
        SSLContext sslContext = SSLContextBuilder.create()
                .loadTrustMaterial(new File("src/main/resources/truststoreB.jks"), "passB".toCharArray())
                .loadKeyMaterial(new File("src/main/resources/keystoreB.jks"), "passB".toCharArray(), "passB".toCharArray())
                .build();

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext))
                .build();

        return new ApacheHttpClient(httpClient);
    }
}
```
