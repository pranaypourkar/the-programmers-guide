---
hidden: true
---

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

These occur when your application is unable to successfully **send** the HTTP request.

<table data-header-hidden data-full-width="true"><thead><tr><th width="286.77166748046875"></th><th width="392.4852294921875"></th><th></th></tr></thead><tbody><tr><td><strong>Exception</strong></td><td><strong>What It Means</strong></td><td><strong>When It Happens</strong></td></tr><tr><td><code>WebClientRequestException</code></td><td>A low-level issue occurred while sending the request (network issue, DNS resolution failure, timeout, connection refused)</td><td>The server is down, the host is unreachable, or the request couldn’t be sent</td></tr><tr><td><code>ConnectTimeoutException</code> (wrapped inside <code>WebClientRequestException</code>)</td><td>The client could not establish a connection within the configured time</td><td>Target service took too long to respond to the connection attempt</td></tr><tr><td><code>ReadTimeoutException</code> (wrapped inside <code>WebClientRequestException</code>)</td><td>Connection was established, but the server didn’t send a response in time</td><td>Slow backend services or misconfigured timeouts</td></tr><tr><td><code>UnknownHostException</code></td><td>Hostname could not be resolved</td><td>DNS failure or incorrect domain name</td></tr></tbody></table>

These are typically retriable (e.g., with retry policies or circuit breakers).

### **Host Not Found / DNS Failure**

This simulates a situation where the hostname doesn't exist or cannot be resolved.

#### **Code Example**

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

***

### **2. Connection Refused (Server Down or Port Closed)**

Simulate when a service is not listening on the target port.

#### **Code Example**

```java
javaCopyEditimport org.springframework.web.reactive.function.client.WebClient;
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

***

### **3. Connect Timeout**

You can simulate this by setting a very short timeout and targeting a delayed service.

#### **Code Example**

```java
javaCopyEditimport org.springframework.http.client.reactive.ReactorClientHttpConnector;
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

***

### **4. Read Timeout**

You simulate this by calling a server that deliberately delays the response.

#### **Code Example**

```java
javaCopyEditimport org.springframework.http.client.reactive.ReactorClientHttpConnector;
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





## **3. Deserialization and Response Mapping Errors**

These are issues that occur when the **response body is being processed**.

<table data-header-hidden data-full-width="true"><thead><tr><th width="267.70916748046875"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Exception</strong></td><td><strong>What It Means</strong></td><td><strong>When It Happens</strong></td></tr><tr><td><code>DecodingException</code> or <code>DecoderException</code> (wrapped)</td><td>The response body could not be parsed into the expected object</td><td>Mismatched fields, corrupted JSON, wrong content-type</td></tr><tr><td><code>JsonProcessingException</code> / <code>MismatchedInputException</code></td><td>Jackson failed to bind JSON to a Java class</td><td>API response has missing/extra fields or type mismatch</td></tr><tr><td><code>IllegalStateException</code></td><td>Attempted to read body multiple times, or from an empty stream</td><td>Usually a mistake in chaining reactive operators</td></tr></tbody></table>

These errors highlight the importance of proper type matching and using DTOs that reflect the real response structure.

