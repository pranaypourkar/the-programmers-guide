# Configuring Request Factories

## About

In Spring's `RestTemplate`, the **ClientHttpRequestFactory** is a crucial component responsible for creating low-level HTTP connections. It defines how HTTP requests are created, sent, and managed, including timeout settings, redirect policies, and connection reuse. Choosing the right request factory can significantly impact the performance, reliability, and behavior of your REST clients.

Spring provides multiple implementations of this interface, each suited for different scenarios—from lightweight one-off calls to highly concurrent enterprise-grade HTTP communication. Configuring the correct request factory is essential when fine-tuning `RestTemplate` for production-grade requirements like timeouts, proxy settings, SSL, or connection pooling.

## Why it Matters ?

By default, `RestTemplate` uses a very basic request factory with minimal configuration. While this is sufficient for simple use cases or quick prototyping, production systems often require more control and robustness.

Configuring the right request factory matters because it directly affects:

**1. Timeout Management**

Improper timeouts can cause threads to hang indefinitely or fail too aggressively. A well-configured factory ensures that connection and read timeouts are properly enforced, helping your system remain responsive even when downstream services misbehave.

**2. Connection Pooling & Resource Efficiency**

Some factories support connection pooling, which reduces latency and improves throughput by reusing connections. This is especially critical in high-concurrency applications that make frequent REST calls.

**3. Advanced HTTP Features**

You may need features like:

* Redirect handling
* Proxy support
* Cookie management
* Custom SSL configuration\
  These are only available with more advanced factories (e.g., `HttpComponentsClientHttpRequestFactory`).

**4. Resilience in Distributed Systems**

When your service communicates with multiple external APIs or microservices, network failures are inevitable. Fine-tuning the request factory ensures better resilience strategies like retries, fallback, or circuit-breaking can be integrated cleanly.

**5. Security and Compliance**

In security-sensitive applications, configuring SSL, hostname verification, and trusted certificates may require advanced HTTP client behavior—something only configurable through custom factories.

**6. Flexibility and Future Compatibility**

Explicitly configuring the request factory prepares your application for future enhancements, such as migrating to a different HTTP client library or adapting to cloud-specific HTTP settings.

## Types of Implementations

### **1. SimpleClientHttpRequestFactory**

This is the default factory provided by Spring when no custom configuration is defined. It relies on Java’s built-in `HttpURLConnection` for executing requests.

**Key Features**

* Lightweight and easy to use.
* No external library dependencies.
* Supports basic configuration like connect and read timeouts.
* Synchronous request execution.
* No support for connection pooling or advanced HTTP features.

**Usage Example**

```java
SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
factory.setConnectTimeout(5000);
factory.setReadTimeout(5000);
RestTemplate restTemplate = new RestTemplate(factory);
```

**Dependencies**

* **None** (uses JDK-provided classes)

**When to Use**

* In simple or small applications with limited HTTP interactions.
* When minimizing dependencies is a priority.
* During early development or internal tools.

**Limitations**

* No support for connection pooling.
* Difficult to customize beyond basic timeouts.
* Cannot handle advanced HTTP features like redirects or cookies.

### **2. HttpComponentsClientHttpRequestFactory**

This implementation delegates HTTP communication to **Apache HttpClient**, a mature and flexible HTTP client widely used in enterprise-grade systems.

**Key Features**

* Supports connection pooling.
* Advanced configuration (cookies, proxy, redirects, interceptors).
* SSL and TLS customization support.
* Thread-safe and highly extensible.
* Rich integration with enterprise networking requirements.

**Usage Example**

```java
PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
connectionManager.setMaxTotal(50);
connectionManager.setDefaultMaxPerRoute(20);

CloseableHttpClient httpClient = HttpClients.custom()
    .setConnectionManager(connectionManager)
    .build();

HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);
RestTemplate restTemplate = new RestTemplate(factory);
```

**Dependencies**

```xml
<dependency>
  <groupId>org.apache.httpcomponents</groupId>
  <artifactId>httpclient</artifactId>
  <version>4.5.13</version>
</dependency>
```

**When to Use**

* In high-throughput production applications.
* When connection pooling is essential for performance.
* When advanced HTTP behavior (custom headers, cookies, proxy config) is needed.
* For SSL certificate pinning or custom trust managers.

**Limitations**

* Additional setup and configuration complexity.
* Adds external library dependency.

### **3. OkHttp3ClientHttpRequestFactory**

This factory wraps the **OkHttp** client, known for performance and modern HTTP support. It is commonly used in microservices and Android applications.

**Key Features**

* HTTP/2 support.
* Efficient connection reuse and pooling.
* Built-in support for interceptors, redirects, and caching.
* Lightweight and efficient under high concurrency.

**Usage Example**

```java
OkHttpClient client = new OkHttpClient.Builder()
    .connectTimeout(Duration.ofSeconds(10))
    .readTimeout(Duration.ofSeconds(10))
    .build();

ClientHttpRequestFactory factory = new OkHttp3ClientHttpRequestFactory(client);
RestTemplate restTemplate = new RestTemplate(factory);
```

**Dependencies**

```xml
<dependency>
  <groupId>com.squareup.okhttp3</groupId>
  <artifactId>okhttp</artifactId>
  <version>4.9.3</version>
</dependency>
```

**When to Use**

* In systems that already rely on OkHttp.
* When performance and HTTP/2 support are critical.
* For reactive-like client behavior in synchronous systems.

**Limitations**

* Slightly less integrated into the Spring ecosystem than Apache HttpClient.
* Requires manual connection management for full control.

### **4. Netty4ClientHttpRequestFactory** _(Advanced)_

Part of the reactive stack (WebFlux), this factory uses **Netty**, a non-blocking networking framework. It’s not typically used with `RestTemplate` but can appear in hybrid setups.

**Key Features**

* Non-blocking, event-driven I/O.
* Built for reactive and high-throughput systems.
* Native support in `WebClient`.

**Dependencies**

Usually bundled with:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

**When to Use**

* Only in reactive applications (with `WebClient`, not `RestTemplate`).
* Rarely needed for standard `RestTemplate` usage.

## Comparison

<table data-full-width="true"><thead><tr><th>Feature / Aspect</th><th>SimpleClientHttpRequestFactory</th><th>HttpComponentsClientHttpRequestFactory</th><th>OkHttp3ClientHttpRequestFactory</th><th>Netty4ClientHttpRequestFactory*</th></tr></thead><tbody><tr><td><strong>Underlying Library</strong></td><td>JDK <code>HttpURLConnection</code></td><td>Apache HttpClient</td><td>OkHttp</td><td>Netty (Reactive Stack)</td></tr><tr><td><strong>Blocking or Non-Blocking</strong></td><td>Blocking</td><td>Blocking</td><td>Blocking</td><td>Non-blocking</td></tr><tr><td><strong>Connection Pooling</strong></td><td>No</td><td>Yes (with pooling manager)</td><td>Yes (built-in)</td><td>Yes (reactive connection handling)</td></tr><tr><td><strong>Custom Timeout Support</strong></td><td>Yes (basic: connect/read)</td><td>Yes (connect/read/request)</td><td>Yes (flexible builder-based setup)</td><td>Yes (but reactive, not with RestTemplate)</td></tr><tr><td><strong>SSL/TLS Configuration</strong></td><td>Limited</td><td>Full support (via <code>SSLContext</code>)</td><td>Full support</td><td>Full support</td></tr><tr><td><strong>Proxy Support</strong></td><td>Basic (JVM-level settings)</td><td>Full (programmatic + system-level)</td><td>Full</td><td>Full</td></tr><tr><td><strong>Redirect Handling</strong></td><td>Limited (JDK-driven)</td><td>Full, configurable</td><td>Full</td><td>Full</td></tr><tr><td><strong>Cookie Management</strong></td><td>Limited / manual</td><td>Full (via CookieStore)</td><td>Full (via Interceptors)</td><td>Full (via Netty handlers)</td></tr><tr><td><strong>Streaming Support</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>Yes</td></tr><tr><td><strong>HTTP/2 Support</strong></td><td>No</td><td>No</td><td>Yes</td><td>Yes</td></tr><tr><td><strong>Thread Safety</strong></td><td>No (create new per thread recommended)</td><td>Yes (with pooled client)</td><td>Yes (thread-safe design)</td><td>Yes (event loop-based)</td></tr><tr><td><strong>Interceptors / Filters</strong></td><td>Manual</td><td>Rich support via <code>HttpRequestInterceptor</code></td><td>Rich support via interceptors</td><td>Reactive-style filters</td></tr><tr><td><strong>Multipart Support</strong></td><td>Basic</td><td>Full</td><td>Full</td><td>Full</td></tr><tr><td><strong>Async Support</strong> (with CompletableFuture)</td><td>Limited (must wrap manually)</td><td>Supported</td><td>Supported</td><td>Native to WebClient, not RestTemplate</td></tr><tr><td><strong>Ease of Use / Simplicity</strong></td><td>Very Simple</td><td>Medium complexity</td><td>Medium</td><td>Complex (not for RestTemplate)</td></tr><tr><td><strong>Performance (Production Ready)</strong></td><td>Low</td><td>High</td><td>Very High</td><td>Very High (but not usable with RestTemplate)</td></tr><tr><td><strong>Dependencies Required</strong></td><td>None (JDK only)</td><td><code>org.apache.httpcomponents:httpclient</code></td><td><code>com.squareup.okhttp3:okhttp</code></td><td><code>org.springframework.boot:spring-boot-starter-webflux</code></td></tr><tr><td><strong>Integration in Spring Boot</strong></td><td>Built-in default</td><td>Widely used and supported</td><td>Slightly less integrated</td><td>Not recommended with RestTemplate</td></tr><tr><td><strong>Best Use Case</strong></td><td>Prototypes, Internal Tools</td><td>Enterprise apps, secure APIs</td><td>High-perf. services, microservices</td><td>Reactive applications with WebClient</td></tr><tr><td><strong>Suitability for RestTemplate</strong></td><td>Yes</td><td>Yes</td><td>Yes</td><td>No (used with WebClient, not RestTemplate)</td></tr></tbody></table>

{% hint style="warning" %}
`Netty4ClientHttpRequestFactory` is **not intended for use with `RestTemplate`**, but is shown here for comparison completeness.
{% endhint %}
