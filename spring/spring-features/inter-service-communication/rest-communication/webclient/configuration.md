---
hidden: true
---

# Configuration

## About

`WebClient` is Spring's non-blocking, reactive HTTP client designed for both synchronous and asynchronous communication. While using WebClient out of the box is sufficient for many cases, real-world applications often require fine-tuned configuration — including timeouts, connection pools, SSL settings, base URLs, and default headers.

Proper configuration ensures consistent behavior across all requests, improves performance, and avoids repetition of setup logic.

## **Configuration Aspects**

<table><thead><tr><th width="221.3828125">Configuration Area</th><th>Purpose</th></tr></thead><tbody><tr><td>Base URL</td><td>Define a root URL so you don’t repeat it on every request</td></tr><tr><td>Default Headers / Cookies</td><td>Apply common headers or cookies globally (like Auth headers)</td></tr><tr><td>Timeouts</td><td>Prevent hanging requests due to slow downstream services</td></tr><tr><td>Connection Pooling</td><td>Efficient reuse of TCP connections</td></tr><tr><td>Custom Codecs</td><td>Customize serialization/deserialization behavior</td></tr><tr><td>Proxy Settings</td><td>Enable routing through a proxy (e.g., for logging or security)</td></tr><tr><td>SSL Configuration</td><td>Trust specific certificates or apply secure connection settings</td></tr><tr><td>ExchangeFilterFunction</td><td>Add interceptors for logging, metrics, tracing, authentication etc.</td></tr></tbody></table>

## Reuse and Centralization

In enterprise-grade applications, it’s important to avoid repeated and inconsistent configuration of `WebClient` across different services and modules. This is where the principle of **centralized configuration and client reuse** becomes critical.

Rather than instantiating `WebClient` ad hoc using `WebClient.create()` or re-writing builder logic in every service class, it’s considered best practice to define **named, reusable WebClient beans** in a dedicated configuration class. This promotes consistency, eases maintenance, and enables standardized behavior across services.

### **Typical Centralized Structure**

We define a Spring `@Configuration` class where multiple specialized clients are exposed:

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient accountClient() {
        return WebClient.builder()
            .baseUrl("https://account-service/api")
            .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }

    @Bean
    public WebClient paymentClient() {
        return WebClient.builder()
            .baseUrl("https://payment-service/api")
            .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }
}
```

Now, you can inject them cleanly:

```java
@Service
public class PaymentService {

    private final WebClient paymentClient;

    public PaymentService(@Qualifier("paymentClient") WebClient paymentClient) {
        this.paymentClient = paymentClient;
    }

    public Mono<PaymentDetails> getPayment(String id) {
        return paymentClient.get()
            .uri("/payments/{id}", id)
            .retrieve()
            .bodyToMono(PaymentDetails.class);
    }
}
```

### **Central Registry or Factory**

In some projects, a dynamic client registry or factory might be used if endpoints are determined at runtime, or for multitenant use:

```java
@Component
public class WebClientFactory {

    public WebClient create(String baseUrl, Map<String, String> headers) {
        WebClient.Builder builder = WebClient.builder().baseUrl(baseUrl);
        headers.forEach(builder::defaultHeader);
        return builder.build();
    }
}
```

This approach is useful when your application communicates with different third-party systems whose properties are stored in a DB or config server.

## **Base URL and Default Headers**

We can configure a `WebClient` bean with a base URL and default headers that apply to all requests.

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient() {
        return WebClient.builder()
            .baseUrl("https://api.example.com")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .defaultHeader("X-Custom-Header", "MyValue")
            .build();
    }
}
```

This reduces boilerplate and ensures consistent header usage across requests.

## Timeout Settings

By default, `WebClient` uses **Reactor Netty** under the hood, and it does **not apply any connection, read, or write timeout unless explicitly configured**. In real-world systems especially those integrated with external services **timeouts are critical** for preventing resource exhaustion, request pile-up, and degraded performance.

We can configure timeouts using the underlying `HttpClient` (from Reactor Netty) and wire that into your `WebClient`.

**Timeout Types**

<table><thead><tr><th width="190.7838134765625">Timeout Type</th><th>Description</th></tr></thead><tbody><tr><td><strong>Connection Timeout</strong></td><td>Maximum time to establish a TCP connection to the server.</td></tr><tr><td><strong>Read Timeout</strong></td><td>Maximum time to wait for data to be read from the server.</td></tr><tr><td><strong>Write Timeout</strong></td><td>Maximum time to wait while sending data to the server.</td></tr><tr><td><strong>Response Timeout</strong></td><td>Maximum time to wait for a complete response from the server.</td></tr></tbody></table>

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClientWithTimeout() {

        HttpClient httpClient = HttpClient.create()
            .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000) // Connection timeout
            .responseTimeout(Duration.ofSeconds(5))             // Overall response timeout
            .doOnConnected(conn -> conn
                .addHandlerLast(new ReadTimeoutHandler(5))      // Read timeout
                .addHandlerLast(new WriteTimeoutHandler(5))     // Write timeout
            );

        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .baseUrl("https://external-service")
            .build();
    }
}
```

#### **Explanation**

* **`CONNECT_TIMEOUT_MILLIS`** – How long to wait to establish the TCP connection.
* **`responseTimeout(Duration)`** – How long to wait for the entire response (headers + body).
* **`ReadTimeoutHandler` / `WriteTimeoutHandler`** – Netty-level handlers that apply read/write I/O timeouts after connection is established.

## Connection Pooling

**Connection pooling** allows the reuse of existing TCP connections rather than opening a new connection for every request. This significantly improves performance and resource utilization, especially in high-throughput or service-to-service communication scenarios.

By default, **WebClient uses Reactor Netty**, which provides a non-blocking connection pool. However, pooling is not enabled unless explicitly configured.

#### **Why Connection Pooling Matters**

<table data-full-width="true"><thead><tr><th width="297.3897705078125">Benefit</th><th>Explanation</th></tr></thead><tbody><tr><td>Reduces latency</td><td>Avoids TCP and TLS handshake overhead for every request.</td></tr><tr><td>Improves throughput</td><td>Multiple requests can be processed efficiently using persistent connections.</td></tr><tr><td>Conserves system resources</td><td>Limits number of open sockets and threads required.</td></tr><tr><td>Aligns with modern microservices</td><td>Essential for high-performance internal service calls.</td></tr></tbody></table>

#### **Enabling Connection Pooling with WebClient (Reactor Netty)**

Connection pooling is done via the `ConnectionProvider` API in Reactor Netty. Here's a standard setup:

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient pooledWebClient() {

        ConnectionProvider provider = ConnectionProvider.builder("custom-connection-pool")
            .maxConnections(100)                 // Max concurrent connections
            .pendingAcquireMaxCount(500)         // Max requests waiting for connection
            .pendingAcquireTimeout(Duration.ofSeconds(10))  // Wait timeout
            .maxIdleTime(Duration.ofSeconds(30)) // Close idle connections
            .maxLifeTime(Duration.ofMinutes(5))  // Maximum lifetime for a connection
            .build();

        HttpClient httpClient = HttpClient.create(provider);

        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }
}
```

#### **Key Configuration Options**

<table data-full-width="true"><thead><tr><th width="255.8099365234375">Setting</th><th>Description</th></tr></thead><tbody><tr><td><code>maxConnections</code></td><td>Maximum active connections in the pool</td></tr><tr><td><code>pendingAcquireMaxCount</code></td><td>How many queued requests can wait for a connection</td></tr><tr><td><code>pendingAcquireTimeout</code></td><td>Maximum time to wait for an available connection before failing</td></tr><tr><td><code>maxIdleTime</code></td><td>Closes idle connections after a certain duration</td></tr><tr><td><code>maxLifeTime</code></td><td>Closes connections after a set lifetime (to avoid stale TCP connections)</td></tr></tbody></table>

#### **How It Works Internally ?**

* Connections are created as needed (up to the max).
* Idle connections are reused for new requests.
* If no connection is available and the queue is full, requests fail immediately.

#### **Debugging and Monitoring**

Enable the following Reactor Netty logs to understand connection usage:

```properties
logging.level.reactor.netty.resources=DEBUG
logging.level.reactor.netty.http.client=DEBUG
```

We can also observe connection reuse patterns via APM tools or custom metrics.

## Custom SSL Configuration





## Adding Logging, Tracing, or Retry Using Filters









## Proxy Configuration





## Custom Message Converters

























