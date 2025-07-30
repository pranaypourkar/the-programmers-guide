# HTTP Clients with SSL

## About

SSL (Secure Sockets Layer) or its newer version TLS (Transport Layer Security) is used when your application talks to another service over **HTTPS**. It ensures that:

* The data sent is **encrypted**
* The communication is **private and secure**
* You're talking to a **trusted server** (by verifying its certificate)

This is essential when calling APIs or services that require HTTPS—especially in production environments or when dealing with sensitive data.

## **One-Way TLS** vs **Mutual TLS (mTLS)**

#### **One-Way TLS (Standard HTTPS)**

Only the **server** presents a certificate to the **client** (usually your browser or app) to prove its identity.

**How it works**

* Client sends a request.
* Server replies with its SSL certificate.
* Client checks if the server is trusted.
* Once verified, communication is encrypted.

**Use case**\
Most websites, REST APIs, and apps use this. It ensures the **client trusts the server** but not the other way around.

#### **Mutual TLS (mTLS)**

Both the **server** and the **client** authenticate each other using certificates.

**How it works**

* Client sends a request.
* Server presents its certificate (as in one-way).
* Client verifies server certificate.
* Then **client also sends its certificate** to the server.
* Server verifies the **client’s identity**.
* If both are trusted, secure communication begins.

**Use case**\
Used in **high-security systems**, **internal APIs**, **B2B systems**, **banking**, or **microservices** communication where the server needs to trust only specific clients.

#### **Comparison Table**

<table data-full-width="true"><thead><tr><th width="275.8836669921875">Feature</th><th width="259.8897705078125">One-Way TLS</th><th>Mutual TLS (mTLS)</th></tr></thead><tbody><tr><td>Server Authentication</td><td>Yes</td><td>Yes</td></tr><tr><td>Client Authentication</td><td>No</td><td>Yes</td></tr><tr><td>Security Level</td><td>Good</td><td>Stronger</td></tr><tr><td>Typical Use</td><td>Public web, REST APIs</td><td>Internal APIs, Financial Systems, B2B</td></tr><tr><td>Client Certificate Needed</td><td>No</td><td>Yes</td></tr></tbody></table>

## When You Need Custom SSL Setup ?

In most basic use cases, `RestTemplate` works seamlessly with HTTPS endpoints by relying on the **default JVM truststore**, which contains standard, globally trusted certificate authorities (CAs). However, in enterprise environments or secure system architectures, this default behavior is insufficient or insecure. You often need a **custom SSL configuration** when connecting to **internal services, non-public APIs, or systems with heightened security requirements**.

#### **Typical Scenarios That Require Custom SSL Configuration**

<table data-full-width="true"><thead><tr><th width="259.5390625">Scenario</th><th>Why Custom SSL is Required</th></tr></thead><tbody><tr><td><strong>Internal Microservices Use Self-Signed Certificates</strong></td><td>The JVM does not trust self-signed certs by default. A custom truststore must be configured to explicitly trust them.</td></tr><tr><td><strong>Your Organization Uses a Private Certificate Authority (CA)</strong></td><td>Enterprises may issue certificates using an internal CA. These certs are not recognized by public trust chains and need to be manually added to a truststore.</td></tr><tr><td><strong>Mutual TLS (mTLS) Is Required</strong></td><td>When both client and server authenticate each other using certificates, the client needs to present its own certificate via a configured keystore.</td></tr><tr><td><strong>You Need to Bypass Hostname Verification in Controlled Environments</strong></td><td>In some non-prod or dynamic environments (e.g., container orchestration systems), DNS may not resolve expected hostnames. A relaxed hostname verifier is needed temporarily.</td></tr><tr><td><strong>Strict Control Over TLS Versions and Cipher Suites</strong></td><td>Legacy systems or regulated environments may require only specific TLS protocols or exclude vulnerable cipher suites. You’ll need a customized <code>SSLContext</code> to enforce this.</td></tr><tr><td><strong>External API Uses a Custom Root Certificate</strong></td><td>Some fintech, banking, or regulated domains expose APIs with root certificates not included in the standard JVM truststore. These must be manually imported and trusted.</td></tr><tr><td><strong>Automated Certificate Rotation</strong></td><td>When using certs managed by tools like HashiCorp Vault or Let's Encrypt, your SSL config must dynamically reload trust/keystores or pull credentials at runtime.</td></tr><tr><td><strong>Integration With HSM or External Keystores</strong></td><td>When cryptographic material is managed by external providers (e.g., AWS KMS, Azure Key Vault), custom SSL code is needed to integrate with those sources.</td></tr><tr><td><strong>Different Trust Requirements Per Environment</strong></td><td>Dev and staging might use permissive or stubbed certs, while production requires strict validation using real certs—hence different truststore/keystore setup per profile.</td></tr></tbody></table>

#### 1. **Calling Internal APIs with Self-Signed Certs**

> Your team exposes a service internally (`https://internal-api.company.local`) using self-signed certs for development and staging. You must import these certs into a custom truststore and configure the `RestTemplate` to use it.

#### 2. **Fintech App Using mTLS for Transaction APIs**

> A payment gateway requires both client and server certificates to be exchanged. You must configure a client keystore with your app's certificate and a truststore with the gateway’s certificate chain.

#### 3. **Zero Trust Networking**

> In a microservice mesh architecture (e.g., with Istio or Linkerd), each service is issued a short-lived certificate for mutual authentication. These certificates are rotated frequently, and the truststore needs to be dynamically managed.

#### 4. **Strict Regulatory Compliance**

> Healthcare applications complying with HIPAA or financial apps under PCI DSS must enforce TLS 1.2+, avoid weak ciphers, and sometimes restrict certificate validity periods—none of which can be handled by default SSL configurations.

## SSL Configuration

<table data-header-hidden data-full-width="true"><thead><tr><th width="190.400146484375"></th><th width="293.25518798828125"></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>What It Is</strong></td><td><strong>Why It Matters / Meaning</strong></td></tr><tr><td><strong>Truststore</strong></td><td>A file (usually <code>.jks</code> or <code>.p12</code>) containing certificates the client <em>trusts</em></td><td>It holds the public keys or certificates of the servers you’re willing to trust. Used to validate server certs.</td></tr><tr><td><strong>Keystore</strong></td><td>A file that holds the client’s own private key and certificate</td><td>Required for <strong>mutual TLS</strong>. It authenticates the client to the server.</td></tr><tr><td><strong>Truststore Password</strong></td><td>Password to access the truststore</td><td>Protects unauthorized access to the truststore.</td></tr><tr><td><strong>Keystore Password</strong></td><td>Password to access the keystore</td><td>Secures the client certificate and private key.</td></tr><tr><td><strong>Key Alias</strong></td><td>Label used to select a specific key pair in the keystore</td><td>Important if keystore has multiple keys.</td></tr><tr><td><strong>SSLContext</strong></td><td>Java object that manages SSL parameters and sockets</td><td>Central component used to configure custom SSL behavior in code.</td></tr><tr><td><strong>X509TrustManager</strong></td><td>Validates the server’s certificate</td><td>Often customized to accept specific CAs or bypass certain validations in dev/test environments.</td></tr><tr><td><strong>HostnameVerifier</strong></td><td>Validates that the server’s certificate matches the hostname in URL</td><td>Used to prevent man-in-the-middle attacks. Can be relaxed in some controlled cases.</td></tr><tr><td><strong>Protocol (e.g., TLSv1.2)</strong></td><td>Defines which SSL/TLS version to use</td><td>Ensures strong encryption. TLS 1.2+ is preferred; older versions are vulnerable.</td></tr><tr><td><strong>Cipher Suites</strong></td><td>Algorithms used in SSL handshakes and encryption</td><td>Can be customized to exclude weak or deprecated algorithms.</td></tr><tr><td><strong>Custom SSLSocketFactory</strong></td><td>Creates sockets using your custom SSLContext</td><td>Allows injection into HTTP clients for full control over SSL behavior.</td></tr><tr><td><strong>PKCS12 / JKS Format</strong></td><td>File formats used for keystores/truststores</td><td><code>PKCS12</code> is the modern standard; <code>JKS</code> is Java’s legacy format. Both are supported by <code>RestTemplate</code>.</td></tr><tr><td><strong>Java System Properties</strong></td><td>Global flags like <code>javax.net.ssl.trustStore</code></td><td>Used to define SSL configuration at JVM level if not programmatically set.</td></tr><tr><td><strong>Reloadable Configuration</strong></td><td>Custom logic to reload certs/trust dynamically</td><td>Useful when certificates are rotated automatically (e.g., with Let's Encrypt or HashiCorp Vault).</td></tr></tbody></table>

{% hint style="success" %}


* We don’t always need both **truststore and keystore**. For one-way SSL (standard HTTPS), truststore is sufficient.
* For **two-way SSL (mTLS)**, both truststore and keystore are required.
* Use programmatic configuration (via `SSLContext` or `HttpComponentsClientHttpRequestFactory`) for fine-grained control.
* Avoid skipping validations unless it's strictly non-production and controlled.
{% endhint %}

## How to Configure RestTemplate for SSL ?

#### **Required Maven Dependencies**

Add the following to your `pom.xml`:

```xml
<dependencies>
  <!-- Spring Boot Web Starter (includes RestTemplate) -->
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

  <!-- Apache HttpClient (to support SSL and advanced features) -->
  <dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpclient</artifactId>
  </dependency>

  <!-- Apache HttpClient fluent builder utilities (optional) -->
  <dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpcore</artifactId>
  </dependency>
</dependencies>
```

{% hint style="success" %}
If we are using Spring Boot **2.x**, these will usually align properly. For Spring Boot **3.x**, Apache HttpClient is still compatible but we may consider switching to **Jakarta** equivalents if required.
{% endhint %}

### One-Way SSL Configuration for RestTemplate (Truststore Only)

This is when the client (your app) **verifies the server's certificate**, but the server doesn't validate the client's identity.

#### **application.yml**

```yaml
# src/main/resources/application.yml
rest-client:
  ssl:
    trust-store: classpath:certs/truststore.jks
    trust-store-password: changeit
```

#### **Java Configuration**

```java
package com.example.config;

import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContexts;
import org.apache.http.impl.client.CloseableHttpClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.InputStream;
import java.security.KeyStore;

@Configuration
public class RestTemplateSSLConfig {

    @Value("${rest-client.ssl.trust-store}")
    private Resource trustStore;

    @Value("${rest-client.ssl.trust-store-password}")
    private String trustStorePassword;

    @Bean
    public RestTemplate restTemplate() throws Exception {
        KeyStore truststore = KeyStore.getInstance("JKS");
        try (InputStream is = trustStore.getInputStream()) {
            truststore.load(is, trustStorePassword.toCharArray());
        }

        SSLContext sslContext = SSLContexts.custom()
                .loadTrustMaterial(truststore, null)
                .build();

        SSLConnectionSocketFactory socketFactory =
                new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(socketFactory)
                .build();

        HttpComponentsClientHttpRequestFactory factory =
                new HttpComponentsClientHttpRequestFactory(httpClient);

        return new RestTemplate(factory);
    }
}
```

### Mutual TLS (mTLS) Configuration for RestTemplate

This is when the **client also presents its certificate** to the server for authentication.

#### **application.yml**

```yaml
# src/main/resources/application.yml
rest-client:
  ssl:
    trust-store: classpath:certs/truststore.jks
    trust-store-password: changeit
    key-store: classpath:certs/keystore.jks
    key-store-password: changeit
```

#### **Java Configuration**

```java
package com.example.config;

import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContexts;
import org.apache.http.impl.client.CloseableHttpClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

import javax.net.ssl.SSLContext;
import java.io.InputStream;
import java.security.KeyStore;

@Configuration
public class RestTemplateMutualTLSConfig {

    @Value("${rest-client.ssl.trust-store}")
    private Resource trustStore;

    @Value("${rest-client.ssl.trust-store-password}")
    private String trustStorePassword;

    @Value("${rest-client.ssl.key-store}")
    private Resource keyStore;

    @Value("${rest-client.ssl.key-store-password}")
    private String keyStorePassword;

    @Bean
    public RestTemplate restTemplate() throws Exception {
        KeyStore truststore = KeyStore.getInstance("JKS");
        try (InputStream trustInput = trustStore.getInputStream()) {
            truststore.load(trustInput, trustStorePassword.toCharArray());
        }

        KeyStore keystore = KeyStore.getInstance("JKS");
        try (InputStream keyInput = keyStore.getInputStream()) {
            keystore.load(keyInput, keyStorePassword.toCharArray());
        }

        SSLContext sslContext = SSLContexts.custom()
                .loadTrustMaterial(truststore, null)
                .loadKeyMaterial(keystore, keyStorePassword.toCharArray())
                .build();

        SSLConnectionSocketFactory socketFactory =
                new SSLConnectionSocketFactory(sslContext);

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(socketFactory)
                .build();

        HttpComponentsClientHttpRequestFactory factory =
                new HttpComponentsClientHttpRequestFactory(httpClient);

        return new RestTemplate(factory);
    }
}
```

### **Directory Structure for Certs**

Place your cert files under:

```
src/main/resources/certs/
  └── keystore.jks
  └── truststore.jks
```





