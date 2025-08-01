---
hidden: true
---

# Handling Responses

## About

When using **WebClient**, handling responses is about more than just reading JSON into a Java object. It is a **crucial part of resilient and reliable communication** between distributed services. In production-grade systems, network calls can fail, data might be malformed, and downstream services can return unexpected status codes. Proper response handling ensures your application reacts **predictably and gracefully** in such scenarios.

## Goals of Response Handling

**1. Understanding HTTP Status Codes**

We need to differentiate between successful and unsuccessful responses:

* `2xx`: success
* `4xx`: client-side issue (e.g., not found, bad request)
* `5xx`: server-side issue (e.g., timeout, internal error)

Response handling enables you to **intelligently branch logic** depending on status, instead of blindly assuming all requests succeed.

**2. Transforming the Response Body**

Once the response is successful, we often want to

* Convert JSON/XML to a Java object
* Handle cases like empty responses
* Deal with large payloads or streaming data

Without proper transformation, data remains unusable in your application logic.

**3. Accessing Metadata**

We may need to

* Read headers like `ETag`, `X-Rate-Limit`, or authentication tokens
* Check content type or response length
* Log request correlation IDs for observability

These metadata values can influence retry logic, caching decisions, or diagnostics.

**4. Error Parsing and Custom Exceptions**

Many APIs return structured error payloads on failure. Instead of generic 400 or 500 errors, they provide:

```json
{
  "error": "USER_NOT_FOUND",
  "message": "No user exists with ID 42"
}
```

We should extract this payload and convert it into a **custom exception or response object**, so our application logic can handle it meaningfully.

**5. Controlling Side Effects**

When handling a response, we might:

* Trigger business logic based on results
* Retry under certain conditions
* Log important audit information
* Update local cache

All these require controlled and centralized response processing.

**6. Non-blocking Behavior**

In reactive programming, you often handle responses asynchronously using `Mono` or `Flux`. This makes response handling a **declarative operation** rather than a sequential one. You describe _what to do when the response arrives_, instead of blocking the thread and waiting.

## **Available Handling Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="214.046875"></th><th width="261.93316650390625"></th><th width="147.776123046875"></th><th></th></tr></thead><tbody><tr><td><strong>Method / Pattern</strong></td><td><strong>Purpose</strong></td><td><strong>Return Type</strong></td><td><strong>When to Use</strong></td></tr><tr><td><code>.retrieve()</code></td><td>Triggers the HTTP request and expects a 2xx status</td><td><code>ResponseSpec</code></td><td>When you're confident in getting a successful response and want to map body</td></tr><tr><td><code>.exchangeToMono(response -> …)</code></td><td>Full control over status, headers, and body; allows conditional handling</td><td><code>Mono&#x3C;T></code></td><td>When you need to react differently based on status or access full response</td></tr><tr><td><code>.exchange()</code> <strong>(Deprecated)</strong></td><td>Older method for getting full <code>ClientResponse</code></td><td><code>Mono&#x3C;ClientResponse></code></td><td>For legacy or transitional code</td></tr><tr><td><code>.bodyToMono(Class&#x3C;T>)</code></td><td>Deserializes a single-object response body into a POJO</td><td><code>Mono&#x3C;T></code></td><td>For standard JSON or XML single object responses</td></tr><tr><td><code>.bodyToFlux(Class&#x3C;T>)</code></td><td>Deserializes an array/stream response into a reactive list</td><td><code>Flux&#x3C;T></code></td><td>For streaming or multiple-item JSON arrays</td></tr><tr><td><code>.onStatus(predicate, handler)</code></td><td>Custom handling for specific status codes</td><td>—</td><td>To throw custom exceptions or transform error responses</td></tr><tr><td><code>.toEntity(Class&#x3C;T>)</code></td><td>Converts response to <code>ResponseEntity</code> with body, headers, status</td><td><code>Mono&#x3C;ResponseEntity&#x3C;T>></code></td><td>When you need access to full HTTP metadata along with body</td></tr><tr><td><code>.toEntityList(Class&#x3C;T>)</code></td><td>Converts list response to <code>ResponseEntity&#x3C;List&#x3C;T>></code></td><td><code>Mono&#x3C;ResponseEntity&#x3C;List&#x3C;T>>></code></td><td>For full access with multiple-item responses</td></tr><tr><td><code>.toBodilessEntity()</code></td><td>For responses without body (e.g., 204 No Content)</td><td><code>Mono&#x3C;ResponseEntity&#x3C;Void>></code></td><td>When only status and headers matter (e.g., DELETE ops)</td></tr><tr><td><code>.body((clientResponse, context) -> …)</code></td><td>Manual extraction and transformation of body</td><td><code>Mono&#x3C;T></code> or <code>Flux&#x3C;T></code></td><td>Advanced control over deserialization, custom codecs, etc.</td></tr><tr><td><code>.flatMap(...) / .map(...)</code></td><td>Transform or post-process the result in reactive style</td><td><code>Mono&#x3C;T></code> or <code>Flux&#x3C;T></code></td><td>To chain business logic or conversions after response</td></tr></tbody></table>

## Response Body Handling

#### **1. `bodyToMono(Class<T>)`** – For Single Object Responses

This is the most common way to retrieve a single resource (e.g., one user, one product) as a Java object. It's ideal for standard `GET` calls that return a single JSON object.

```java
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

public class SingleObjectExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Mono<User> userMono = webClient.get()
            .uri("http://user-service/api/users/42")
            .retrieve()
            .bodyToMono(User.class);

        userMono.subscribe(user -> System.out.println(user.getName()));
    }

    public static class User {
        private String id;
        private String name;

        // Getters and setters
    }
}
```

#### **2. `.bodyToFlux(Class<T>)` – For List/Streaming Responses**

Use `bodyToFlux` when you expect multiple objects (a JSON array) or a stream of data (e.g., multiple orders, notifications, etc.).

```java
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Flux;

public class ArrayResponseExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Flux<Order> orderFlux = webClient.get()
            .uri("http://order-service/api/orders")
            .retrieve()
            .bodyToFlux(Order.class);

        orderFlux.subscribe(order -> System.out.println(order.getId()));
    }

    public static class Order {
        private String id;
        private Double amount;

        // Getters and setters
    }
}
```

#### **3. `.toEntity(Class<T>)` – For Object + Metadata**

Use this when we need more than the body for example, to access status code, response headers, etc.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

public class EntityResponseExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Mono<ResponseEntity<User>> responseMono = webClient.get()
            .uri("http://user-service/api/users/42")
            .retrieve()
            .toEntity(User.class);

        responseMono.subscribe(entity -> {
            System.out.println("Status: " + entity.getStatusCode());
            System.out.println("Header: " + entity.getHeaders().getFirst("Content-Type"));
            System.out.println("Body: " + entity.getBody().getName());
        });
    }

    public static class User {
        private String id;
        private String name;

        // Getters and setters
    }
}
```

#### **4. `.toEntityList(Class<T>)` – For List + Metadata**

This variant of `toEntity` is useful when the body is a list and we still want access to headers and status code.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

import java.util.List;

public class EntityListResponseExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Mono<ResponseEntity<List<Order>>> responseMono = webClient.get()
            .uri("http://order-service/api/orders")
            .retrieve()
            .toEntityList(Order.class);

        responseMono.subscribe(entity -> {
            System.out.println("Status: " + entity.getStatusCode());
            for (Order order : entity.getBody()) {
                System.out.println("Order ID: " + order.getId());
            }
        });
    }

    public static class Order {
        private String id;
        private Double amount;

        // Getters and setters
    }
}
```

#### **5. `.toBodilessEntity()` – For Responses with No Body**

For responses like HTTP 204 (No Content), where the server doesn't return a body (e.g., DELETE operation), but we still want status and headers.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.http.ResponseEntity;
import reactor.core.publisher.Mono;

public class BodilessResponseExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Mono<ResponseEntity<Void>> responseMono = webClient.delete()
            .uri("http://user-service/api/users/42")
            .retrieve()
            .toBodilessEntity();

        responseMono.subscribe(entity -> {
            System.out.println("Status Code: " + entity.getStatusCode());
        });
    }
}
```

#### **6. `.exchangeToMono(response -> …)` – Full Manual Handling**

This gives full access to the `ClientResponse` and lets us write custom logic for different status codes, custom decoding, or error handling.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.ClientResponse;
import reactor.core.publisher.Mono;

public class ExchangeExample {
    public static void main(String[] args) {
        WebClient webClient = WebClient.create();

        Mono<String> responseMono = webClient.get()
            .uri("http://external-api.com/api/info")
            .exchangeToMono(response -> {
                if (response.statusCode().is2xxSuccessful()) {
                    return response.bodyToMono(String.class);
                } else if (response.statusCode().value() == 404) {
                    return Mono.error(new RuntimeException("Resource Not Found"));
                } else {
                    return response.createException().flatMap(Mono::error);
                }
            });

        responseMono.subscribe(
            body -> System.out.println("Response: " + body),
            error -> System.out.println("Error: " + error.getMessage())
        );
    }
}
```

#### 7. **`.bodyToMono(new ParameterizedTypeReference<T>())`**

This is used to deserialize **generic types** such as `List<User>`, `Map<String, Object>`, or custom wrapper types.\
Java’s type erasure makes it impossible to detect the actual generic type at runtime, so this is necessary when you're dealing with collections or nested generics.

Use this when we expect a generic or parameterized response (e.g., list of users) and want the response body only (no headers or status).

```java
Mono<List<User>> users = webClient.get()
    .uri("/api/users")
    .retrieve()
    .bodyToMono(new ParameterizedTypeReference<List<User>>() {});
```

#### 8. **`.exchangeToFlux(...)`**

This gives you full access to the **raw ClientResponse**, and lets you return a **Flux** stream instead of a Mono.\
Useful when you're working with **event streams**, **large datasets**, or need **manual branching** for different status codes with a stream.

Use this when you need to stream data with **fine-grained control** (e.g., server-sent events or streaming JSON arrays), and also want to inspect response status or headers.

```java
Flux<User> userFlux = webClient.get()
    .uri("/api/users/stream")
    .exchangeToFlux(response -> {
        if (response.statusCode().is2xxSuccessful()) {
            return response.bodyToFlux(User.class);
        } else {
            return Flux.error(new RuntimeException("Failed to stream users"));
        }
    });
```

#### 9. **`.exchange(...)` (Deprecated)**

Returns the raw `ClientResponse` directly, without enforcing how to handle the response.\
**This method is now deprecated** because it encouraged improper handling (e.g., skipping error mapping or leaving response unconsumed).

We **should not use** this anymore. It’s kept for backward compatibility. Use `exchangeToMono` or `exchangeToFlux` instead.

**Example (for legacy understanding only)**

```java
Mono<ClientResponse> response = webClient.get()
    .uri("/api/users")
    .exchange(); // Deprecated
```

## Converting Response to ResponseEntity

In certain scenarios, especially in enterprise applications, it's not enough to just get the **body** of the response. You might also need to access the:

* **HTTP Status Code**
* **Headers**
* **Raw Metadata**

The `ResponseEntity<T>` class is designed to hold all of this information together.\
Spring’s WebClient supports converting the response into a `ResponseEntity<T>` so that you can capture both the **body** and the **HTTP metadata** in one object.

#### **Syntax**

```java
Mono<ResponseEntity<T>> toEntity(Class<T> responseType)
```

#### **Example 1**

```java
Mono<ResponseEntity<User>> userResponse = webClient.get()
    .uri("/api/users/42")
    .retrieve()
    .toEntity(User.class);

userResponse.subscribe(response -> {
    HttpStatus status = response.getStatusCode();
    HttpHeaders headers = response.getHeaders();
    User user = response.getBody();

    System.out.println("Status: " + status);
    System.out.println("X-Request-ID: " + headers.getFirst("X-Request-ID"));
    System.out.println("User name: " + user.getName());
});
```

#### **Example 2**

```java
public Mono<ResponseEntity<OrderDetails>> getOrder(String orderId) {
    return webClient.get()
        .uri(uriBuilder -> uriBuilder
            .path("/api/orders/{id}")
            .build(orderId))
        .retrieve()
        .toEntity(OrderDetails.class);
}
```

#### **Example 3 – Using with Exchange Filter Logging**

If we use interceptors or filters (for example, for logging headers/status), having access to `ResponseEntity` makes this more meaningful.

```java
Mono<ResponseEntity<Product>> productResponse = webClient.get()
    .uri("/api/products/123")
    .retrieve()
    .toEntity(Product.class)
    .doOnNext(response -> {
        System.out.println("Received status: " + response.getStatusCode());
        System.out.println("Response headers: " + response.getHeaders());
    });
```

## Extracting Headers from Response

In many enterprise scenarios, it's not just the body of the response that matters. You might also need to:

* Read a custom header (e.g., `X-Correlation-ID`, `X-RateLimit-Remaining`)
* Extract authentication or pagination metadata
* Trace requests with diagnostic headers

Spring’s WebClient allows you to extract headers easily when working with the **entire `ClientResponse`** or **`ResponseEntity`**.

#### **Approach 1: Extract Headers via `toEntity(...)`**

If we are using `.toEntity(...)`, headers are directly available in the `ResponseEntity`.

```java
Mono<ResponseEntity<User>> userResponse = webClient.get()
    .uri("/api/users/42")
    .retrieve()
    .toEntity(User.class);

userResponse.subscribe(response -> {
    HttpHeaders headers = response.getHeaders();
    String correlationId = headers.getFirst("X-Correlation-ID");

    System.out.println("Correlation ID: " + correlationId);
});
```

#### **Approach 2: Using `exchangeToMono(...)` for More Control**

When we need **fine-grained control**, use `.exchangeToMono(...)` to get the raw `ClientResponse`, from which you can extract headers before converting the body.

```java
Mono<String> correlationId = webClient.get()
    .uri("/api/info")
    .exchangeToMono(response -> {
        String headerValue = response.headers()
            .header("X-Correlation-ID")
            .stream()
            .findFirst()
            .orElse("N/A");

        return Mono.just("Header: " + headerValue);
    });
```

We can also extract both headers and body in this pattern:

```java
Mono<String> result = webClient.get()
    .uri("/api/response")
    .exchangeToMono(response -> {
        HttpHeaders headers = response.headers().asHttpHeaders();
        String requestId = headers.getFirst("X-Request-ID");

        return response.bodyToMono(String.class)
            .map(body -> "Request ID: " + requestId + ", Body: " + body);
    });
```

#### **Approach 3: Inside a `doOnNext()` for Post-processing**

Sometimes you already have the `ResponseEntity`, and just want to log headers or take action based on them.

```java
webClient.get()
    .uri("/api/inventory")
    .retrieve()
    .toEntity(Inventory.class)
    .doOnNext(response -> {
        String limit = response.getHeaders().getFirst("X-RateLimit-Remaining");
        System.out.println("Rate Limit Remaining: " + limit);
    })
    .subscribe();
```

#### **Handling Multiple Values of a Header**

Some headers like `Set-Cookie` may return multiple values:

```java
List<String> cookies = response.getHeaders().get("Set-Cookie");
```

## Mapping Error Responses (Graceful Fallback)



## Deserialize into Custom Error Object





