# WebClient

`WebClient` is a non-blocking, reactive HTTP client introduced in Spring 5 and is part of the Spring WebFlux module. It provides a functional and fluent API for making HTTP requests in Spring applications, especially in reactive, non-blocking scenarios. It's designed for modern, scalable applications that can handle high volumes of concurrent requests efficiently.



### **Some of the key points**

1. **Non-blocking and Reactive**: `WebClient` operates in a non-blocking manner, allowing application to handle multiple concurrent requests efficiently without blocking threads.
2. **Fluent API**: It offers a fluent and functional API for building and executing HTTP requests, making it easy to compose complex requests and handle responses.
3. **Supports Reactive Streams**: `WebClient` integrates well with reactive programming concepts and supports reactive streams, allowing to work with `Mono` and `Flux` types for handling asynchronous data streams.
4. **Customizable and Extensible**: `WebClient` provides various configuration options and allows customization of request and response handling through filters, interceptors, and other mechanisms.
5. **Supports WebClient.Builder**: We can create a `WebClient` instance using `WebClient.Builder`, which allows for centralized configuration and reuse across multiple requests.
6. **Codec Integration:** WebClient integrates with Spring's HTTP codecs for automatic marshalling and unmarshalling of request and response data formats (e.g., JSON, XML).
7. The default _HttpClient_ used by _WebClient_ is the Netty implementation, so to see details like requests we need to change the _**reactor.netty.http.client**_** logging level to **_**DEBUG**._



### Commonly used WebClient configuration

1. **Base URL:**

This specifies the default root URL for the requests.

```java
WebClient webClient = WebClient.builder()
    .baseUrl("https://api.example.com")
    .build();
```

2. **Default Headers:**

We can pre-set headers that will be included in every request made with this WebClient instance.

```java
WebClient webClient = WebClient.builder()
    .defaultHeader("Authorization", "Bearer your_access_token")
    .defaultHeader("Accept", "application/json")
    .build();
```

3. **Timeouts:**

Configure timeouts to prevent application from hanging indefinitely if a response takes too long. We can set timeouts for connection establishment, read operations, and write operations.

```java
HttpClient httpClient = HttpClient.create()
    .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 10000) // 10 seconds connect timeout
    .responseTimeout(Duration.ofMillis(5000)); // 5 seconds response timeout

WebClient webClient = WebClient.builder()
    .clientConnector(new ReactorClientHttpConnector(httpClient))
    .build();
```

4. **Interceptors:**

Interceptors allows us to intercept requests and responses before and after their execution. We can use them for tasks like logging, adding authentication headers dynamically, or error handling.

```java
WebClient webClient = WebClient.builder()
    .filter((req, next) -> {
        // Add logging or custom logic before the request
        return next.exchange(req);
    })
    .build();
```

5. **Error Handling:**

WebClient allows to chain error handling logic using operators like `onErrorResume` or `onErrorReturn`. This helps to gracefully handle unexpected errors and provide appropriate responses.

```java
Mono<String> responseMono = webClient.get()
    .uri("/users")
    .retrieve()
    .bodyToMono(String.class)
    .onErrorResume(throwable -> Mono.just("An error occurred")); // Handle error gracefully
```

6. **Retry:**

WebClient provides the `onErrorRetry` operator for retrying a failed request a certain number of times. This is useful for handling transient errors like network issues or server overload.

```java
Mono<String> responseMono = webClient.get()
    .uri("/users")
    .retrieve()
    .bodyToMono(String.class)
    .onErrorRetry(3, // Retry up to 3 times
                 throwable -> throwable instanceof IOException); // Retry only for IOExceptions
```



### **Making HTTP Requests**

WebClient offers a fluent API for building different types of HTTP requests:

* `.retrieve()`: Use this for GET requests.
* `.post()`: Use this for POST requests.
* `.put()`: Use this for PUT requests.
* `.patch()`: Use this for PATCH requests.
* `.delete()`: Use this for DELETE requests



### Examples

#### Service 1 API calling Service 2 GET API via WebClient.

* **Service 2**

Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

    @GetMapping("/api/service-2/details")
    public ResponseEntity<String> getInterServiceDetails() {
        return ResponseEntity.ok("Service 2 processed successfully");
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
server:
  port: 8082
```

Build and run the application



* **Service 1**

Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.30</version>
    <scope>provided</scope>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-webflux</artifactId>
</dependency>
```

_<mark style="background-color:yellow;">**SampleController.java**</mark>_

```java
package org.example.api;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.example.service.SampleService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
@RestController
public class SampleController {

    private final SampleService sampleService;

    @GetMapping("/api/service-1/details")
    public Mono<String> getInterServiceDetails() {
        return sampleService.fetchService2Details();
    }
}
```

_<mark style="background-color:yellow;">**WebClientConfig.java**</mark>_

```java
package org.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
    @Bean
    public WebClient webClient() {
        return WebClient.builder()
                .baseUrl("http://localhost:8082") // Set the base URL for the requests
                .defaultCookie("cookie-name", "cookie-value") // Set a default cookie for the requests
                .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE) // Set a default header for the requests
                .build();
    }
}
```

_<mark style="background-color:yellow;">**SampleService.java**</mark>_

```java
package org.example.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

@Slf4j
@RequiredArgsConstructor
@Service
public class SampleService {

    private static final String SERVICE_2_ENDPOINT_PATH = "/api/service-2/details";

    private final WebClient webClient;

    // Method to retrieve service 2 details using a GET request
    public Mono<String> fetchService2Details() {
        log.info("Calling service 2 API via WebClient");

        return webClient.get()
                .uri(SERVICE_2_ENDPOINT_PATH)
                .retrieve()
                .bodyToMono(String.class)
                .doOnNext(data -> log.info("Received data from Service-2: {}", data)) // Do logging after receiving response
                .onErrorReturn("Failed to retrieve data from Service-2"); // Default error message
    }
}
```

_<mark style="background-color:yellow;">**application.yaml**</mark>_

```yaml
server:
  port: 8081

logging.level.reactor.netty.http.client: DEBUG
```

Build and run the application



**Execute the service 1 API via Postman**

<figure><img src="../../../.gitbook/assets/image.png" alt=""><figcaption></figcaption></figure>

Monitor the logs (have a look at the threads executing the code)

<figure><img src="../../../.gitbook/assets/image (2).png" alt=""><figcaption></figcaption></figure>









