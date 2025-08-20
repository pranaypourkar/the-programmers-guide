# Configuration

## About

`WebClient` is Spring's non-blocking, reactive HTTP client designed for both synchronous and asynchronous communication. While using WebClient out of the box is sufficient for many cases, real-world applications often require fine-tuned configuration — including timeouts, connection pools, SSL settings, base URLs, and default headers.

Proper configuration ensures consistent behavior across all requests, improves performance, and avoids repetition of setup logic.

## **Configuration Aspects**

<table><thead><tr><th width="221.3828125">Configuration Area</th><th>Purpose</th></tr></thead><tbody><tr><td>Base URL</td><td>Define a root URL so we don’t repeat it on every request</td></tr><tr><td>Default Headers / Cookies</td><td>Apply common headers or cookies globally (like Auth headers)</td></tr><tr><td>Timeouts</td><td>Prevent hanging requests due to slow downstream services</td></tr><tr><td>Connection Pooling</td><td>Efficient reuse of TCP connections</td></tr><tr><td>Custom Codecs</td><td>Customize serialization/deserialization behavior</td></tr><tr><td>Proxy Settings</td><td>Enable routing through a proxy (e.g., for logging or security)</td></tr><tr><td>SSL Configuration</td><td>Trust specific certificates or apply secure connection settings</td></tr><tr><td>ExchangeFilterFunction</td><td>Add interceptors for logging, metrics, tracing, authentication etc.</td></tr></tbody></table>

## Reuse and Centralization

In enterprise-grade applications, it’s important to avoid repeated and inconsistent configuration of `WebClient` across different services and modules. This is where the principle of **centralized configuration and client reuse** becomes critical.

Rather than instantiating `WebClient` ad hoc using `WebClient.create()` or re-writing builder logic in every service class, it’s considered best practice to define **named, reusable WebClient beans** in a dedicated configuration class. This promotes consistency, eases maintenance, and enables standardized behavior across services.

#### **Typical Centralized Structure**

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

Now, we can inject them cleanly:

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

#### **Central Registry or Factory**

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

This approach is useful when our application communicates with different third-party systems whose properties are stored in a DB or config server.

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

We can configure timeouts using the underlying `HttpClient` (from Reactor Netty) and wire that into our `WebClient`.

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

## Adding Logging, Tracing, or Retry Using Filters

Spring WebClient supports a powerful feature called **filters**, which are analogous to servlet filters or interceptors. These allow us to intercept and modify requests and responses, making them ideal for **cross-cutting concerns** such as:

* Request and response logging
* Distributed tracing propagation (e.g., Sleuth, OpenTelemetry)
* Retry mechanisms
* Metrics collection
* Error handling

#### **What Is a WebClient Filter ?**

A **filter** is a function applied to every WebClient call that allows us to inspect, log, modify, or retry the request/response pipeline.

Signature:

```java
ExchangeFilterFunction : ClientRequest -> ClientResponse
```

We typically add filters at the **WebClient builder level**.

#### **1. Logging Requests and Responses**

```java
public class LoggingFilter {

    public static ExchangeFilterFunction logRequest() {
        return ExchangeFilterFunction.ofRequestProcessor(clientRequest -> {
            System.out.println("Request: " + clientRequest.method() + " " + clientRequest.url());
            clientRequest.headers().forEach((name, values) ->
                System.out.println(name + ": " + String.join(",", values))
            );
            return Mono.just(clientRequest);
        });
    }

    public static ExchangeFilterFunction logResponse() {
        return ExchangeFilterFunction.ofResponseProcessor(clientResponse -> {
            System.out.println("Response Status: " + clientResponse.statusCode());
            return Mono.just(clientResponse);
        });
    }
}
```

**Register the filters**

```java
WebClient client = WebClient.builder()
    .filter(LoggingFilter.logRequest())
    .filter(LoggingFilter.logResponse())
    .build();
```

#### **2. Distributed Tracing (Spring Cloud Sleuth / OpenTelemetry)**

WebClient integrates with **Spring Cloud Sleuth** or **OpenTelemetry** automatically, provided the tracing context is active.

For manual tracing propagation (custom headers):

```java
public static ExchangeFilterFunction tracePropagation() {
    return ExchangeFilterFunction.ofRequestProcessor(request -> {
        ClientRequest traced = ClientRequest.from(request)
            .header("X-Trace-Id", "some-trace-id") // typically auto-populated
            .build();
        return Mono.just(traced);
    });
}
```

In enterprise setups, **Sleuth auto-injects trace IDs** via `TraceExchangeFilterFunction`, so we often don’t need to customize this.

#### **3. Retry Logic via Resilience4j or Reactor Retry**

#### a. Basic Retry Example with `retryWhen`

```java
WebClient webClient = WebClient.builder()
    .baseUrl("http://api-service")
    .build();

Mono<String> response = webClient.get()
    .uri("/resource")
    .retrieve()
    .bodyToMono(String.class)
    .retryWhen(Retry.backoff(3, Duration.ofMillis(500)))
    .onErrorResume(e -> {
        // Fallback or log
        return Mono.just("fallback");
    });
```

#### b. Retry with Resilience4j Filter

```java
@Bean
public WebClient resilientClient(Resilience4JCircuitBreakerFactory factory) {
    CircuitBreaker circuitBreaker = factory.create("external-service");

    return WebClient.builder()
        .filter(Resilience4JCircuitBreakerOperator.of(circuitBreaker))
        .build();
}
```

This allows retries with circuit-breaking, fallback logic, and custom backoff.

#### **4. Combine Filters in Centralized Builder**

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient() {
        return WebClient.builder()
            .filter(LoggingFilter.logRequest())
            .filter(LoggingFilter.logResponse())
            .filter(tracePropagation())
            .build();
    }
}
```

This setup ensures all requests passing through this WebClient instance include standardized logging, tracing headers, and can be wrapped in retry/circuit-breaker logic.

## Proxy Configuration

In enterprise environments, it's common to operate behind an HTTP proxy for security, compliance, or traffic routing purposes. WebClient supports proxy configuration through its underlying `HttpClient` (from **Reactor Netty**).

Configuring a proxy allows our WebClient-based applications to:

* Route outbound HTTP calls through a proxy server
* Enforce outbound firewall rules
* Perform internal service routing in secured networks
* Support testing in proxy environments (e.g., Charles Proxy, Fiddler)

**Example**

```java
import io.netty.handler.proxy.ProxyHandler;
import io.netty.handler.proxy.HttpProxyHandler;
import reactor.netty.transport.ProxyProvider;
import reactor.netty.http.client.HttpClient;

import org.springframework.web.reactive.function.client.WebClient;

public class WebClientWithProxy {

    public WebClient create() {
        HttpClient httpClient = HttpClient.create()
            .proxy(proxy -> proxy
                .type(ProxyProvider.Proxy.HTTP)
                .host("proxy.mycorp.com")
                .port(8080)
            );

        return WebClient.builder()
            .clientConnector(new ReactorClientHttpConnector(httpClient))
            .build();
    }
}
```

This configures WebClient to route all requests through the specified HTTP proxy.

#### **Proxy with Authentication**

If the proxy requires basic authentication:

```java
HttpClient httpClient = HttpClient.create()
    .proxy(proxy -> proxy
        .type(ProxyProvider.Proxy.HTTP)
        .host("proxy.mycorp.com")
        .port(8080)
        .username("myuser")
        .password(s -> "mypassword")
    );
```

Note: Avoid hardcoding credentials; use secure storage like environment variables, Spring Vault, or secret managers.

#### **Proxy Types Supported**

| Proxy Type          | Description                          |
| ------------------- | ------------------------------------ |
| `HTTP`              | Standard HTTP proxy                  |
| `SOCKS4` / `SOCKS5` | SOCKS proxy for TCP-based protocols  |
| `DIRECT`            | No proxy (default if not configured) |

We can choose the type using:

```java
proxy.type(ProxyProvider.Proxy.SOCKS5)
```

Use Spring profiles to isolate proxy logic:

```yaml
# application-prod.yaml
proxy:
  host: proxy.mycorp.com
  port: 8080
  username: user
  password: pass
```

Then conditionally enable the proxy WebClient for production profile only.

#### **Debugging Proxy Issues**

* Use Wireshark or tcpdump to verify traffic redirection.
* Use WebClient logging or custom filters to log connection metadata.
* Test using curl or Postman with proxy settings for comparison.

## Custom Message Converters

By default, `WebClient` uses built-in message readers and writers to handle data formats like JSON or XML. These are based on **HTTP message converters**, most commonly using **Jackson** for JSON. However, in some enterprise scenarios, we may need to register or override default converters, such as:

* Custom serialization/deserialization logic
* Supporting non-standard or proprietary media types
* Modifying behavior for specific content types (e.g., parsing HAL, CSV, or binary formats)

#### **How Message Conversion Works in WebClient ?**

When a WebClient makes a request or receives a response:

* **Writers** are used to encode Java objects into the request body
* **Readers** are used to decode response bodies into Java objects

Spring uses **ReactiveHttpMessageReader** and **ReactiveHttpMessageWriter** interfaces for this under the hood.

#### **Use Cases for Custom Converters**

<table data-full-width="true"><thead><tr><th width="410.4244384765625">Use Case</th><th>Why Needed</th></tr></thead><tbody><tr><td>Custom JSON field naming or formatting</td><td>When default Jackson rules don’t suffice</td></tr><tr><td>CSV or custom-text format</td><td>For legacy APIs or non-JSON-based protocols</td></tr><tr><td>Encrypted payloads</td><td>To decrypt/encrypt request/response body</td></tr><tr><td>Enriching or modifying object before deserialization</td><td>To transform inputs to domain-specific classes</td></tr></tbody></table>

#### **Registering Custom Converters**

WebClient allows us to configure custom message converters through the underlying `ExchangeStrategies`.

#### **Example: Custom Jackson Module**

```java
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient() {
        ObjectMapper customMapper = new ObjectMapper();
        customMapper.registerModule(new CustomJacksonModule());

        Jackson2JsonDecoder decoder = new Jackson2JsonDecoder(customMapper);
        Jackson2JsonEncoder encoder = new Jackson2JsonEncoder(customMapper);

        ExchangeStrategies strategies = ExchangeStrategies.builder()
            .codecs(config -> {
                config.defaultCodecs().jackson2JsonDecoder(decoder);
                config.defaultCodecs().jackson2JsonEncoder(encoder);
            })
            .build();

        return WebClient.builder()
            .exchangeStrategies(strategies)
            .build();
    }
}
```

We can register additional modules like `JavaTimeModule`, `JodaModule`, or our own.

#### **Example: Add Support for Custom Media Type (e.g., CSV)**

```java
public class CsvHttpMessageReader implements HttpMessageReader<MyCsvModel> {
    // implement decode logic here using OpenCSV or our CSV parser
}

public class CsvHttpMessageWriter implements HttpMessageWriter<MyCsvModel> {
    // implement encoding logic here
}
```

Then:

```java
ExchangeStrategies strategies = ExchangeStrategies.builder()
    .codecs(config -> {
        config.customCodecs().register(new CsvHttpMessageReader());
        config.customCodecs().register(new CsvHttpMessageWriter());
    })
    .build();

WebClient webClient = WebClient.builder()
    .exchangeStrategies(strategies)
    .build();
```

#### **Override vs Extend Default Behavior**

<table data-full-width="true"><thead><tr><th width="409.9288330078125">Scenario</th><th>Approach</th></tr></thead><tbody><tr><td>Tweak Jackson’s behavior</td><td>Register a custom ObjectMapper</td></tr><tr><td>Replace JSON handling entirely</td><td>Remove default codecs and register our own</td></tr><tr><td>Add support for new format (e.g., Avro)</td><td>Add custom reader/writer to <code>customCodecs()</code></td></tr><tr><td>Intercept encoding/decoding</td><td>Create decorator around existing Jackson encoder/decoder</td></tr></tbody></table>

#### **Custom ExchangeStrategies**

```java
ExchangeStrategies strategies = ExchangeStrategies.builder()
    .codecs(clientCodecConfigurer -> {
        clientCodecConfigurer.defaultCodecs().enableLoggingRequestDetails(true);
        clientCodecConfigurer.defaultCodecs().jackson2JsonDecoder(new CustomJsonDecoder());
        clientCodecConfigurer.customCodecs().register(new BinaryPayloadWriter());
    })
    .build();
```

This gives us complete control over:

* Logging
* Media type resolution
* Reactive flow customization

## Logging

### **1. Enable Basic WebClient Logging**

```yaml
logging:
  level:
    org.springframework.web.reactive.function.client.WebClient: DEBUG
```

* Logs request method, URI, status code, and error signals.
*   Example:

    ```
    DEBUG WebClient: [5f20f] HTTP POST http://api.example.com/users
    DEBUG WebClient: [5f20f] Response 200 OK
    ```

### 2. **Enable Reactor Netty HTTP Logging**

#### a) Request & Response details

```yaml
logging:
  level:
    reactor.netty.http.client: DEBUG
```

* Logs connection events, request sent, response received.
*   Example:

    ```
    DEBUG reactor.netty.http.client.HttpClient - [id: 0x12345] REGISTERED
    DEBUG reactor.netty.http.client.HttpClient - [id: 0x12345] WRITE: POST /users
    DEBUG reactor.netty.http.client.HttpClient - [id: 0x12345] READ: 200 OK
    ```

#### b) Full wire-level logging (headers + body)

```yaml
logging:
  level:
    reactor.netty.channel: DEBUG
    reactor.netty.transport: DEBUG
```

* Shows raw bytes over TCP (like `org.apache.http.wire` in HttpClient).
*   Example:

    ```
    DEBUG reactor.netty.channel - [id:0x12345] OUTBOUND: {"name":"Alice"}
    DEBUG reactor.netty.channel - [id:0x12345] INBOUND: {"id":1,"name":"Alice"}
    ```

### 3. **Enable Codec & JSON Logging**

To see what’s happening inside message encoders/decoders:

```yaml
logging:
  level:
    org.springframework.http.codec: DEBUG
    org.springframework.core.codec: DEBUG
    org.springframework.web.reactive.function.BodyExtractors: TRACE
    com.fasterxml.jackson.databind: DEBUG
```

* Logs when Spring encodes request/response bodies.
* Shows serialization details if using Jackson.
