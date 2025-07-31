# Usage

## About

Unlike `RestTemplate`, which relies on thread-per-request execution, `WebClient` uses reactive streams (`Mono` and `Flux`) to handle requests and responses—enabling higher throughput with fewer threads. This makes it particularly suitable for **microservices**, **API gateways**, and **cloud-native applications** where scalability and performance matter.

## Dependency

To use **WebClient** in a Spring Boot application, we need to include the appropriate Spring WebFlux dependency. This dependency provides the `WebClient` class along with reactive features like `Mono`, `Flux`, and support for non-blocking HTTP communication.

Spring WebClient is **part of the `spring-webflux` module**, not `spring-web`.

#### **For Maven Projects**

Add the following dependency in our `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

#### **For Gradle Projects**

In `build.gradle`:

```groovy
implementation 'org.springframework.boot:spring-boot-starter-webflux'
```

This brings in:

* `WebClient` class
* Reactor Core (`Mono`, `Flux`)
* Netty as the default HTTP client
* Jackson support for JSON (if already using it in Spring Boot)

### **Compatibility**

* WebClient is available in **Spring 5+**
* It works in **both reactive** (WebFlux) and **non-reactive** (Spring MVC) applications
* Even if we are using Spring MVC (with `spring-boot-starter-web`), we can still add `spring-boot-starter-webflux` to use WebClient
* However, **we don’t need to move our entire app to WebFlux** to use WebClient it can be used as a standalone client in any Spring Boot app

## Declarative and Fluent API

One of WebClient's most powerful traits is its **fluent API design**, which allows for **declarative-style HTTP request building**. This leads to highly **readable**, **concise**, and **maintainable** code—especially for composing dynamic or chained HTTP interactions.

{% hint style="success" %}
#### **What Does “Fluent” Mean ?**

The fluent style means that each method call returns an intermediate builder object, allowing multiple configuration steps to be **chained in a single, continuous statement**.

Instead of imperatively setting headers, bodies, and HTTP methods through separate steps, WebClient allows we to declare everything in a single flow.
{% endhint %}

#### **Example (Declarative Style)**

```java
WebClient client = WebClient.create();

Mono<User> result = client.get()
    .uri("http://user-service/api/users/{id}", 42)
    .header("Authorization", "Bearer some-token")
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(User.class);
```

Here’s what is happening in a flow:

1. GET request is made
2. URI is constructed with path variable
3. Authorization header is added
4. Expected content type is declared
5. Response is retrieved and body mapped to a Java class (`User`)

```java
WebClient.create()
    .post()
    .uri(uriBuilder -> uriBuilder
        .scheme("https")
        .host("payment.service")
        .path("/api/payments")
        .queryParam("region", "IN")
        .build()
    )
    .header("Authorization", "Bearer token")
    .contentType(MediaType.APPLICATION_JSON)
    .bodyValue(new PaymentRequest(...))
    .retrieve()
    .onStatus(HttpStatus::is4xxClientError, response -> {
        return Mono.error(new ClientErrorException("Client error"));
    })
    .bodyToMono(PaymentResponse.class);
```

This demonstrates the fluent API even for:

* Dynamic URI building
* Error handling
* Sending request bodies
* Mapping to POJO responses

## Creating a WebClient Instance

WebClient is the non-blocking, reactive HTTP client introduced in Spring WebFlux. To use it effectively, the first step is **creating an instance**—which can be done in multiple ways, depending on how we want to configure and reuse the client.

### **1. Default WebClient Instance (Minimal Setup)**

If no special configuration is needed, we can directly use `WebClient.create()`.

```java
import org.springframework.web.reactive.function.client.WebClient;

public class SimpleClient {

    private final WebClient webClient = WebClient.create();

    public void callApi() {
        webClient.get()
            .uri("https://api.example.com/data")
            .retrieve()
            .bodyToMono(String.class)
            .subscribe(System.out::println);
    }
}
```

* No base URL is set
* Used for quick, lightweight HTTP requests

### **2. With a Base URL**

When we are interacting with a fixed host (e.g., internal microservice), it's common to initialize WebClient with a **base URL**.

```java
import org.springframework.web.reactive.function.client.WebClient;

public class BaseUrlClient {

    private final WebClient webClient = WebClient.create("http://user-service");

    public void getUser(int id) {
        webClient.get()
            .uri("/api/users/{id}", id)
            .retrieve()
            .bodyToMono(String.class)
            .subscribe(System.out::println);
    }
}
```

* Helps avoid repeating the base URI
* Ideal for service-to-service calls

### **3. Using WebClient.Builder (Custom Configuration)**

For headers, timeouts, filters, or other settings, use `WebClient.Builder`.

```java
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class WebClientConfig {

    @Bean
    public WebClient customWebClient() {
        return WebClient.builder()
            .baseUrl("http://inventory-service")
            .defaultHeader("Authorization", "Bearer my-token")
            .build();
    }
}
```

We can then inject this bean wherever needed:

```java
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;

@Service
public class InventoryClient {

    private final WebClient webClient;

    public InventoryClient(WebClient webClient) {
        this.webClient = webClient;
    }

    public void getInventory() {
        webClient.get()
            .uri("/api/items")
            .retrieve()
            .bodyToMono(String.class)
            .subscribe(System.out::println);
    }
}
```

* Fully configurable
* Reusable across classes via Spring dependency injection
* Recommended for real-world applications

### **4. Per-Request WebClient Builder (When We Need Dynamic Behavior)**

Sometimes, we may need to build the client differently for each request (e.g., dynamic headers or SSL certificates).

```java
import org.springframework.web.reactive.function.client.WebClient;

public class DynamicClient {

    public void callWithDynamicToken(String token) {
        WebClient webClient = WebClient.builder()
            .baseUrl("http://auth-service")
            .defaultHeader("Authorization", "Bearer " + token)
            .build();

        webClient.get()
            .uri("/api/token/check")
            .retrieve()
            .bodyToMono(String.class)
            .subscribe(System.out::println);
    }
}
```

* Not reused across requests
* Useful for token rotation or multi-tenant scenarios

### **5. Using ExchangeStrategies (e.g., custom message converters)**

We may also need custom serialization or message readers/writers.

```java
import org.springframework.http.codec.json.Jackson2JsonDecoder;
import org.springframework.http.codec.json.Jackson2JsonEncoder;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import com.fasterxml.jackson.databind.ObjectMapper;

public class CustomStrategyClient {

    public WebClient createClientWithCustomJson(ObjectMapper mapper) {
        ExchangeStrategies strategies = ExchangeStrategies.builder()
            .codecs(config -> {
                config.defaultCodecs().jackson2JsonDecoder(new Jackson2JsonDecoder(mapper));
                config.defaultCodecs().jackson2JsonEncoder(new Jackson2JsonEncoder(mapper));
            })
            .build();

        return WebClient.builder()
            .baseUrl("http://analytics-service")
            .exchangeStrategies(strategies)
            .build();
    }
}
```

* Ideal for controlling JSON serialization/deserialization
* Works well in systems using customized Jackson configurations

## Making a HTTP GET Request&#x20;

The most common use of `WebClient` is to perform **HTTP GET** requests to fetch data from a remote service. WebClient provides a clean, fluent API that allows developers to define the request, handle the response, and optionally map it into Java objects all in a non-blocking, reactive style.

Let’s say we want to call a user service to retrieve details of a user by ID.

**Class: UserClient**

```java
package com.example.client;

import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Service
public class UserClient {

    private final WebClient webClient;

    public UserClient(WebClient.Builder builder) {
        this.webClient = builder
            .baseUrl("http://user-service")
            .build();
    }

    public Mono<User> getUserById(Long userId) {
        return webClient
            .get()
            .uri("/api/users/{id}", userId)
            .retrieve()
            .bodyToMono(User.class);
    }
}
```

**Class: User**

```java
package com.example.client;

public class User {
    private Long id;
    private String name;
    private String email;

    // Getters and Setters
}
```

* `.get()` – Specifies that the HTTP method is GET
* `.uri("/api/users/{id}", userId)` – Templated URI with path variable replacement
* `.retrieve()` – Triggers the request and prepares for response handling
* `.bodyToMono(User.class)` – Converts the response body into a `Mono<User>` (i.e., an asynchronous result)

This approach is **non-blocking** and **reactive**. The method will return immediately and complete once the response is received and processed.

#### **Consuming the Response**

We can subscribe to the response like this:

```java
userClient.getUserById(101L)
    .subscribe(user -> System.out.println("User name: " + user.getName()));
```

Or in a controller method, we can return the Mono directly:

```java
@GetMapping("/user/{id}")
public Mono<User> getUser(@PathVariable Long id) {
    return userClient.getUserById(id);
}
```

## Handling Path and Query Parameters

When making API calls, it is common to pass values via **path variables** or **query parameters**. WebClient offers flexible and readable ways to handle both types, allowing us to construct URIs dynamically and cleanly.

#### **1. Handling Path Parameters**

Path parameters are part of the URI itself (e.g., `/api/users/{id}`). WebClient supports templated URIs where placeholders are replaced with actual values at runtime.

**Example: Path Parameter**

```java
Mono<User> response = webClient
    .get()
    .uri("/api/users/{id}", 42)
    .retrieve()
    .bodyToMono(User.class);
```

We can also use a map for named parameters:

```java
Map<String, Object> uriVars = Map.of("id", 42);

Mono<User> response = webClient
    .get()
    .uri("/api/users/{id}", uriVars)
    .retrieve()
    .bodyToMono(User.class);
```

#### **2. Handling Query Parameters**

Query parameters are appended to the URI as key-value pairs (e.g., `?status=active&page=2`). WebClient provides a way to add these via `UriBuilder`.

```java
Mono<UserList> response = webClient
    .get()
    .uri(uriBuilder -> uriBuilder
        .path("/api/users")
        .queryParam("status", "active")
        .queryParam("page", 2)
        .build()
    )
    .retrieve()
    .bodyToMono(UserList.class);
```

This approach is clean, avoids string concatenation, and supports conditional or optional parameters easily.

#### **3. Combining Path and Query Parameters**

We can combine both approaches to form complex URIs.

```java
Mono<OrderList> response = webClient
    .get()
    .uri(uriBuilder -> uriBuilder
        .path("/api/users/{id}/orders")
        .queryParam("status", "delivered")
        .build(42)
    )
    .retrieve()
    .bodyToMono(OrderList.class);
```

In this example:

* `{id}` is replaced with `42`
* Query parameter `status=delivered` is appended
