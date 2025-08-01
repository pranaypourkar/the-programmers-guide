# Exception Handling

## About

When making an HTTP call using WebClient, many things can go wrong:

* The target server is down
* It returns a non-2xx status code (e.g. 404, 500)
* The response body is malformed or deserialization fails
* Network timeouts or DNS failures

We need to handle these failures **gracefully and centrally**, either by throwing meaningful exceptions or by performing fallback logic.

## Types of Exceptions We Might Encounter

When making HTTP calls with `WebClient`, our application can run into a wide range of issues, both client-side and server-side. Understanding these exception types is essential for building robust and fault-tolerant systems. They generally fall into three broad categories:

## **1. Client-Side I/O Exceptions (Request-Time Errors)**

These occur when our application is unable to successfully **send** the HTTP request.

<table data-header-hidden data-full-width="true"><thead><tr><th width="286.77166748046875"></th><th width="392.4852294921875"></th><th></th></tr></thead><tbody><tr><td><strong>Exception</strong></td><td><strong>What It Means</strong></td><td><strong>When It Happens</strong></td></tr><tr><td><code>WebClientRequestException</code></td><td>A low-level issue occurred while sending the request (network issue, DNS resolution failure, timeout, connection refused)</td><td>The server is down, the host is unreachable, or the request couldn’t be sent</td></tr><tr><td><code>ConnectTimeoutException</code> (wrapped inside <code>WebClientRequestException</code>)</td><td>The client could not establish a connection within the configured time</td><td>Target service took too long to respond to the connection attempt</td></tr><tr><td><code>ReadTimeoutException</code> (wrapped inside <code>WebClientRequestException</code>)</td><td>Connection was established, but the server didn’t send a response in time</td><td>Slow backend services or misconfigured timeouts</td></tr><tr><td><code>UnknownHostException</code></td><td>Hostname could not be resolved</td><td>DNS failure or incorrect domain name</td></tr></tbody></table>

These are typically retriable (e.g., with retry policies or circuit breakers).

### **Host Not Found / DNS Failure**

This occurs when the domain or hostname used in the URI cannot be resolved by the DNS resolver. It typically means the domain doesn't exist, there's a typo in the hostname, or DNS is misconfigured.

{% hint style="success" %}
An internal service might refer to another microservice via a DNS-based name like `http://user-service.internal`. If that service hasn’t been registered in the internal DNS or if there’s a service discovery failure (like in Consul, Eureka, or Kubernetes), the client cannot resolve the address.

Spring throws a `WebClientRequestException`, which wraps `UnknownHostException`.

This is a network-level failure that occurs **before** any HTTP request is actually sent.

Fallbacks here typically return cached results or empty responses.
{% endhint %}

This simulates a situation where the hostname doesn't exist or cannot be resolved.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientRequestException;
import reactor.core.publisher.Mono;

public class DnsFailureExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        webClient.get()
                .uri("http://nonexistent-host-xyz123.internal/api/test")
                .retrieve()
                .bodyToMono(String.class)
                .doOnError(WebClientRequestException.class, ex -> {
                    System.out.println("DNS resolution failed: " + ex.getMessage());
                })
                .onErrorResume(WebClientRequestException.class, ex -> Mono.empty())
                .block();
    }
}
```

### **Connection Refused (Server Down or Port Closed)**

The client resolves the host and attempts a connection, but no service is listening on the given port. This is common when:

* The server crashed or hasn’t started.
* The port is misconfigured.
* The service has not bound properly on the expected interface.

{% hint style="success" %}
An example is a client calling `http://payment-service:8080`, but the `payment-service` is down due to a crash, deployment error, or rolling update.

We still get `WebClientRequestException`, typically wrapping a `ConnectException`.

This error confirms the host is reachable, but connection-level establishment failed.

Monitoring tools and circuit breakers should track such events to avoid repeated connection attempts.
{% endhint %}

Simulate when a service is not listening on the target port.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientRequestException;
import reactor.core.publisher.Mono;

public class ConnectionRefusedExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        webClient.get()
                .uri("http://localhost:9999/api/users") // Assuming port 9999 is closed
                .retrieve()
                .bodyToMono(String.class)
                .doOnError(WebClientRequestException.class, ex -> {
                    System.out.println("Connection refused: " + ex.getMessage());
                })
                .onErrorResume(WebClientRequestException.class, ex -> Mono.just("Fallback response"))
                .block();
    }
}
```

{% hint style="warning" %}
Both `UnknownHostException` and `ConnectException` are wrapped in a `WebClientRequestException`, and at first glance, the handling looks identical in above both examples.

However, while the **structure of the code is similar**, we can **distinguish between "Host Not Found" and "Connection Refused"** by **checking the cause** inside the `WebClientRequestException`.

```java
.doOnError(WebClientRequestException.class, ex -> {
    Throwable rootCause = ex.getCause();
    if (rootCause instanceof java.net.UnknownHostException) {
        System.out.println("DNS resolution failed: " + rootCause.getMessage());
    } else if (rootCause instanceof java.net.ConnectException) {
        System.out.println("Connection refused or port unavailable: " + rootCause.getMessage());
    } else {
        System.out.println("Other I/O error: " + rootCause);
    }
})
```
{% endhint %}

### **Connect Timeout**

This occurs when the TCP handshake cannot be completed within a defined period. It is not the same as server slowness—it happens **before the request is even sent**.

{% hint style="success" %}
Sometimes a pod or server is alive but under heavy network pressure, and our service can't establish a socket connection in time. Or the service is hosted on a network with long routing paths (e.g., cross-region communication without edge optimization).

This triggers a `WebClientRequestException`, often wrapping a `ConnectTimeoutException`.

Increasing connection timeout should be done cautiously, only when justified.

Consider fallback logic or retrying with backoff using libraries like Resilience4j.
{% endhint %}

We can simulate this by setting a very short timeout and targeting a delayed service.

```java
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import reactor.netty.http.client.HttpClient;
import reactor.netty.tcp.TcpClient;
import io.netty.channel.ChannelOption;

import java.time.Duration;

public class ConnectTimeoutExample {
    public static void main(String[] args) {
        TcpClient tcpClient = TcpClient.create()
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 500); // Very short timeout

        WebClient webClient = WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(HttpClient.from(tcpClient)))
                .build();

        webClient.get()
                .uri("http://10.255.255.1:8080") // unroutable IP to force timeout
                .retrieve()
                .bodyToMono(String.class)
                .timeout(Duration.ofSeconds(2))
                .doOnError(Exception.class, ex -> System.out.println("Connection timeout: " + ex.getMessage()))
                .onErrorResume(ex -> Mono.just("Timeout fallback"))
                .block();
    }
}
```

### **Read Timeout**

This happens **after** the connection is established and the request is sent, but the server takes too long to respond with even a single byte.

{% hint style="success" %}
This often occurs in:

* Slow downstream services (e.g., making DB calls or hitting third-party APIs).
* Backend overloads or GC pauses that delay response.
* Calling APIs like `/reports/export` or `/invoice/bulk-process` which might be heavy.

Also wrapped in `WebClientRequestException`, typically with a `ReadTimeoutException`.



Set reasonable read timeouts to prevent our service from hanging.

For long-running processes, prefer async callbacks or pagination.

Use timeouts combined with retry logic and fallback responses where feasible.
{% endhint %}

We simulate this by calling a server that deliberately delays the response.

```java
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;
import reactor.netty.http.client.HttpClient;
import reactor.netty.resources.ConnectionProvider;

import java.time.Duration;

public class ReadTimeoutExample {
    public static void main(String[] args) {
        HttpClient httpClient = HttpClient.create(ConnectionProvider.newConnection())
                .responseTimeout(Duration.ofSeconds(1)); // Read timeout

        WebClient webClient = WebClient.builder()
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();

        webClient.get()
                .uri("http://httpstat.us/200?sleep=5000") // 5-second sleep
                .retrieve()
                .bodyToMono(String.class)
                .doOnError(Exception.class, ex -> System.out.println("Read timeout: " + ex.getMessage()))
                .onErrorResume(ex -> Mono.just("Read timeout fallback"))
                .block();
    }
}
```

## **2. Server Response Exceptions (Non-2xx Responses)**

These occur when the request was **successfully sent**, but the **server responded with an error status code** (e.g. 4xx, 5xx).

<table data-header-hidden data-full-width="true"><thead><tr><th width="417.84814453125"></th><th width="285.974853515625"></th><th></th></tr></thead><tbody><tr><td><strong>Exception</strong></td><td><strong>What It Means</strong></td><td><strong>When It Happens</strong></td></tr><tr><td><code>WebClientResponseException</code></td><td>The server returned a non-2xx HTTP status code</td><td>API returned 400, 404, 500, etc.</td></tr><tr><td><p>Subtypes:</p><p> <code>WebClientResponseException.BadRequest</code> </p><p> <code>WebClientResponseException.NotFound</code></p><p><code>WebClientResponseException.InternalServerError</code></p></td><td>These are specific subclasses for common HTTP errors</td><td>Allows targeted handling (e.g., only for 404 or 500 errors)</td></tr><tr><td><code>UnknownHttpStatusCodeException</code></td><td>Server returned a status code not defined in the <code>HttpStatus</code> enum</td><td>Happens rarely with non-standard HTTP status codes (e.g. 600)</td></tr></tbody></table>

These exceptions carry full HTTP response data (status, headers, body) and are useful for **error decoding or fallback logic**.

### Common Status Codes that Trigger Exceptions

<table data-header-hidden><thead><tr><th width="166.1961669921875"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>HTTP Status</strong></td><td><strong>Scenario</strong></td><td><strong>Typical Meaning</strong></td></tr><tr><td>400</td><td>Bad Request</td><td>Client sent malformed request</td></tr><tr><td>401 / 403</td><td>Unauthorized / Forbidden</td><td>Authentication/Authorization failure</td></tr><tr><td>404</td><td>Not Found</td><td>Resource missing</td></tr><tr><td>409</td><td>Conflict</td><td>Duplicate or state conflict</td></tr><tr><td>422</td><td>Unprocessable Entity</td><td>Validation failure</td></tr><tr><td>500</td><td>Internal Server Error</td><td>Server-side exception</td></tr><tr><td>503</td><td>Service Unavailable</td><td>Server overloaded or under maintenance</td></tr></tbody></table>

### Handling 4xx and 5xx

#### Handling 404 Not Found

A `404 Not Found` status indicates the client made a valid request, but the server could not locate the resource. In a microservices context, this might mean:

* The client is querying with a non-existent ID.
* The downstream service has deleted or never created the requested entity.
* The endpoint path is incorrect or deprecated.

This type of error is common in read-heavy APIs like catalog, account, or order lookup services.

{% hint style="success" %}
**Enterprise Handling**

* **Do not retry -** it’s a functional failure.
* **Return user-friendly messages** - “Account not found” instead of internal trace.
* **Log for audit** if the ID was user-supplied.
{% endhint %}

```java
WebClient webClient = WebClient.create();

webClient.get()
        .uri("http://product-service/api/products/9999") // Non-existent ID
        .retrieve()
        .onStatus(status -> status.value() == 404,
                  clientResponse -> Mono.error(new RuntimeException("Product not found")))
        .bodyToMono(String.class)
        .doOnError(ex -> System.out.println("Error occurred: " + ex.getMessage()))
        .onErrorResume(ex -> Mono.just("Fallback response"))
        .block();
```

#### Handling 400 Bad Request

A `400 Bad Request` typically happens when the client sends malformed data. This could involve

* Missing required fields.
* Invalid JSON format.
* Violations of schema-level validation (like invalid enum, incorrect types).

It's common in **POST/PUT** APIs like form submissions, resource creation, or updates.

{% hint style="success" %}
**Enterprise Handling:**

* Use detailed client-side validation to **prevent 400s proactively**.
* Map such exceptions to **`IllegalArgumentException`** or a domain-specific error.
* Avoid logging the entire payload in production, but store trace ID for debugging.
{% endhint %}

```java
webClient.post()
        .uri("http://order-service/api/orders")
        .bodyValue(new OrderRequest()) // Assume missing required fields
        .retrieve()
        .onStatus(status -> status.value() == 400,
                  response -> response.bodyToMono(String.class)
                                      .map(body -> new IllegalArgumentException("Bad request: " + body)))
        .bodyToMono(String.class)
        .onErrorResume(ex -> Mono.just("Client-side input error"))
        .block();
```

#### Catch All for 5xx Errors

5xx errors represent **server-side faults** — failures that are not the client’s responsibility. This could be due to:

* Null pointer exception in the downstream service.
* Database outages or timeouts.
* Resource exhaustion (e.g., memory, thread pool).
* Unhandled exceptions.

These are **transient errors** that are often recoverable.

{% hint style="success" %}
**Enterprise Handling**

* Do not surface raw server errors to end users.
* Retry with backoff (especially for 502/503).
* Alerting mechanisms should be in place for repeated 5xxs.
{% endhint %}

```java
webClient.get()
        .uri("http://inventory-service/api/status")
        .retrieve()
        .onStatus(status -> status.is5xxServerError(),
                  clientResponse -> Mono.error(new RuntimeException("Server error: Try later")))
        .bodyToMono(String.class)
        .onErrorResume(ex -> Mono.just("System temporarily unavailable"))
        .block();
```

#### Handling Specific Error Code with Custom Logging

```java
webClient.get()
        .uri("http://payment-service/api/payments/123")
        .retrieve()
        .onStatus(status -> status.value() == 409,
                  response -> {
                      System.out.println("Conflict detected: Possibly a duplicate payment.");
                      return Mono.error(new IllegalStateException("Duplicate operation"));
                  })
        .bodyToMono(String.class)
        .onErrorResume(ex -> Mono.just("Conflict fallback"))
        .block();
```

### Catch all server response exceptions

Sometimes we want to handle **any server error** generically (4xx or 5xx) to avoid writing multiple `.onStatus()` handlers for each code. We can capture and inspect the exception using `WebClientResponseException`.

{% hint style="success" %}
**Enterprise Handling**

* Generic fallback for user experience continuity.
* Central logging of status code, headers, response body for postmortem.
{% endhint %}

#### Using `WebClientResponseException` in `doOnError()`

If we want to globally catch all server response exceptions:

```java
webClient.get()
        .uri("http://user-service/api/users/abc")
        .retrieve()
        .bodyToMono(String.class)
        .doOnError(WebClientResponseException.class, ex -> {
            System.out.println("Received " + ex.getStatusCode() + ": " + ex.getResponseBodyAsString());
        })
        .onErrorResume(WebClientResponseException.class, ex -> Mono.just("Graceful fallback"))
        .block();
```

## **3. Deserialization and Response Mapping Errors**

Deserialization and response mapping errors occur when the HTTP response body cannot be properly converted into the desired Java object. These issues often arise in real-world enterprise systems where:

* The remote service returns unexpected JSON structure
* The target DTO has mismatched fields or missing annotations
* A non-JSON body is returned (e.g., HTML error page)
* Empty or null response is mapped to a non-nullable field

{% hint style="warning" %}
When using methods like `.bodyToMono(MyResponse.class)`, WebClient internally uses Jackson (or another codec) to parse the response body. If the format doesn't match the expected structure, a runtime exception is thrown, typically:

* `DecodingException`
* `JsonMappingException`
* `InvalidDefinitionException`
* `WebClientResponseException` (if response code was 4xx or 5xx)
{% endhint %}

<table data-header-hidden data-full-width="true"><thead><tr><th width="267.70916748046875"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Exception</strong></td><td><strong>What It Means</strong></td><td><strong>When It Happens</strong></td></tr><tr><td><code>DecodingException</code> or <code>DecoderException</code> (wrapped)</td><td>The response body could not be parsed into the expected object</td><td>Mismatched fields, corrupted JSON, wrong content-type</td></tr><tr><td><code>JsonProcessingException</code> / <code>MismatchedInputException</code></td><td>Jackson failed to bind JSON to a Java class</td><td>API response has missing/extra fields or type mismatch</td></tr><tr><td><code>IllegalStateException</code></td><td>Attempted to read body multiple times, or from an empty stream</td><td>Usually a mistake in chaining reactive operators</td></tr></tbody></table>

These errors highlight the importance of proper type matching and using DTOs that reflect the real response structure.

### Issues

#### **Mismatched Fields in Response Body**

Assume the server returns:

```json
{
  "id": 1,
  "name": "Alice",
  "status": "ACTIVE"
}
```

But our Java class is:

```java
public class UserDTO {
    private Long id;
    private String fullName; // mismatch: "name" ≠ "fullName"
}
```

```java
webClient.get()
    .uri("http://user-service/api/users/1")
    .retrieve()
    .bodyToMono(UserDTO.class)
    .doOnError(Exception.class, ex -> System.out.println("Mapping failed: " + ex.getMessage()))
    .onErrorResume(ex -> Mono.empty())
    .block();
```

> The error will likely be a `JsonMappingException` due to field mismatch.

#### **Response Is Not JSON**

Suppose the server responds with an HTML error page instead of JSON, and we try to deserialize it.

```java
webClient.get()
    .uri("http://example.com/api/data")
    .retrieve()
    .bodyToMono(MyData.class)
    .doOnError(Exception.class, ex -> System.out.println("Deserialization failed: " + ex.getMessage()))
    .onErrorResume(ex -> Mono.just(new MyData("default")))
    .block();
```

> Common in misconfigured reverse proxies or generic 404 pages returned from load balancers.

#### **Empty Response for a Non-Void Mapping**

```java
webClient.get()
    .uri("http://remote/api/config")
    .retrieve()
    .bodyToMono(Config.class) // But response is completely empty
    .block();
```

> We may get `DecodingException: JSON decoding error` or a `No content to map to object due to end of input`.

### How to Handle It Gracefully ?

#### **Use `.onStatus()` for HTTP Errors**

This separates HTTP error status from deserialization logic.

```java
.retrieve()
.onStatus(status -> status.is4xxClientError() || status.is5xxServerError(),
    response -> response.bodyToMono(String.class)
        .flatMap(body -> Mono.error(new RuntimeException("API error: " + body))))
```

#### **Catch Deserialization Exceptions Specifically**

```java
webClient.get()
    .uri("/api/user/1")
    .retrieve()
    .bodyToMono(UserDTO.class)
    .doOnError(JsonMappingException.class, ex -> {
        System.out.println("Field mismatch or bad format: " + ex.getMessage());
    })
    .onErrorResume(JsonMappingException.class, ex -> Mono.just(new UserDTO()))
    .block();
```

#### **Use `.bodyToMono(String.class)` and Deserialize Manually**

If the structure is inconsistent, fetch raw JSON and map it manually.

```java
webClient.get()
    .uri("/api/flexible")
    .retrieve()
    .bodyToMono(String.class)
    .map(json -> {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(json, MyFlexibleDto.class);
        } catch (Exception e) {
            throw new RuntimeException("Manual parse failed", e);
        }
    })
    .block();
```
