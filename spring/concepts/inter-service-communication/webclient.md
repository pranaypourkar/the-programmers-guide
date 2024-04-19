# WebClient

`WebClient` is a non-blocking, reactive HTTP client introduced in Spring 5 and is part of the Spring WebFlux module. It provides a functional and fluent API for making HTTP requests in Spring applications, especially in reactive, non-blocking scenarios. It's designed for modern, scalable applications that can handle high volumes of concurrent requests efficiently.



### **Some of the key points**

1. **Non-blocking and Reactive**: `WebClient` operates in a non-blocking manner, allowing application to handle multiple concurrent requests efficiently without blocking threads.
2. **Fluent API**: It offers a fluent and functional API for building and executing HTTP requests, making it easy to compose complex requests and handle responses.
3. **Supports Reactive Streams**: `WebClient` integrates well with reactive programming concepts and supports reactive streams, allowing to work with `Mono` and `Flux` types for handling asynchronous data streams.
4. **Customizable and Extensible**: `WebClient` provides various configuration options and allows customization of request and response handling through filters, interceptors, and other mechanisms.
5. **Supports WebClient.Builder**: We can create a `WebClient` instance using `WebClient.Builder`, which allows for centralized configuration and reuse across multiple requests.
6. **Codec Integration:** WebClient integrates with Spring's HTTP codecs for automatic marshalling and unmarshalling of request and response data formats (e.g., JSON, XML).



### Commonly used WebClient configuration



**1. Base URL:**

* This specifies the default root URL for your requests.

Java

```
WebClient webClient = WebClient.builder()
    .baseUrl("https://api.example.com")
    .build();
```

**Default Headers:**

* You can pre-set headers that will be included in every request made with this WebClient instance.

Java

```
WebClient webClient = WebClient.builder()
    .defaultHeader("Authorization", "Bearer your_access_token")
    .defaultHeader("Accept", "application/json")
    .build();
```

**3. Timeouts:**

* Configure timeouts to prevent your application from hanging indefinitely if a response takes too long. You can set timeouts for connection establishment, read operations, and write operations.

Java

```
HttpClient httpClient = HttpClient.create()
    .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 10000) // 10 seconds connect timeout
    .responseTimeout(Duration.ofMillis(5000)); // 5 seconds response timeout

WebClient webClient = WebClient.builder()
    .clientConnector(new ReactorClientHttpConnector(httpClient))
    .build();
```



**4. Interceptors:**

* Interceptors are powerful tools that allow you to intercept requests and responses before and after their execution. You can use them for tasks like logging, adding authentication headers dynamically, or error handling.

Java

```
WebClient webClient = WebClient.builder()
    .filter((req, next) -> {
        // Add logging or custom logic before the request
        return next.exchange(req);
    })
    .build();
```

**5. Codecs:**

* Spring provides built-in codecs for common data formats like JSON, XML, and others. You can also configure custom codecs for handling specific data formats.

Java

```
WebClient webClient = WebClient.builder()
    .codecs(configurer -> {
        configurer.defaultCodecs().の上に書き換える(defaults -> defaults.withMarshaller(String.class, StringEncoder.textPlain())); // Custom String encoder
    })
    .build();
```







