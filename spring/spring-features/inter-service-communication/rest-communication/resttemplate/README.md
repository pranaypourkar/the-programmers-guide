# 1. RestTemplate

`RestTemplate` is a synchronous client included in the Spring Framework that allows to interact with RESTful web services. It provides a simplified way to send HTTP requests and receive responses. It also supports authentication, making it versatile for various API interactions.

### **Key points about RestTemplate**

* **Synchronous communication:** RestTemplate makes synchronous HTTP requests, meaning program waits (blocking) for the response before continuing execution. It can have performance impact in high-concurrency applications.
* **Template methods:** It offers template methods for common HTTP methods like GET, POST, PUT, and DELETE. These methods handle the underlying details of sending requests and receiving responses.
* **Flexibility:** While there are convenient methods for common scenarios, RestTemplate also provides more generic `exchange()` and `execute()` methods for less frequent cases.
* **Configuration:** RestTemplate can be customized by providing a custom `ClientHttpRequestFactory` or a list of `HttpMessageConverter` instances. We must define @Bean of RestTemplate in Spring Boot Configuration.
* **Non-Reactive:** Not suited for reactive programming or handling large data streams efficiently. Consider WebClient for these scenarios.
* **Deprecation:** RestTemplate is marked for deprecation in future Spring versions. Consider WebClient for new development as it offers both synchronous and asynchronous capabilities with a reactive programming model.
* RestTemplate doesn't use Apache classes be default. By default the RestTemplate relies on `SimpleClientHttpRequestFactory` which is a standard Java `HttpURLConnection` class for making HTTP requests. It doesn't offer features like connection pooling or advanced configuration options. We can switch to use a different HTTP library such as Apache HttpComponents and then we can enable complete request response logging via `logging.level.org.apache.http.wire=DEBUG`

{% hint style="info" %}
To use Apache HttpComponents, add below dependency and configure RestTemplate with -

<pre class="language-java"><code class="lang-java"><strong>RestTemplate restTemplate = new RestTemplate();
</strong>restTemplate.setRequestFactory(new HttpComponentsAsyncClientHttpRequestFactory());
</code></pre>

```markup
<dependency>
    <groupId>org.apache.httpcomponents</groupId>
    <artifactId>httpasyncclient</artifactId>
</dependency>
```
{% endhint %}

{% hint style="info" %}
To achieve asynchronous behavior when using RestTemplate, we can use it with `CompletableFuture`.

For example -

```java
// URL for the REST API endpoint
String url = "http://example.com/api/resource";

// Making an asynchronous GET request using CompletableFuture
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    // Perform the HTTP request
    String response = restTemplate.getForObject(url, String.class);
    return response;
});

// Other tasks can continue while the request is being made asynchronously

// Wait for the asynchronous operation to complete
future.join();
```
{% endhint %}

### Commonly used RestTemplate configuration

1. **Setting Timeout**: We can configure connection and read timeouts to prevent application from hanging indefinitely if a remote server is slow to respond.

```java
RestTemplate restTemplate = new RestTemplateBuilder()
    .setConnectTimeout(Duration.ofSeconds(10))
    .setReadTimeout(Duration.ofSeconds(10))
    .build();
```

2. **Customizing Message Converters**: We might need to customize the message converters used by `RestTemplate` to handle specific data formats or serialization/deserialization requirements.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setMessageConverters(Arrays.asList(new MappingJackson2HttpMessageConverter()));
```

3. **Error Handling**: We can configure error handling to handle different types of errors gracefully, such as by defining custom error handlers.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setErrorHandler(new MyResponseErrorHandler());
```

4. **Interceptors**: Interceptors allows to intercept and modify outgoing requests or incoming responses. They can be used for logging, adding headers, or other pre/post-processing tasks.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.setInterceptors(Collections.singletonList(new MyClientHttpRequestInterceptor()));
```

5. **HTTP Basic Authentication**: If we need to authenticate with a server using HTTP Basic authentication, we can configure it with `RestTemplate`.

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.getInterceptors().add(new BasicAuthenticationInterceptor("username", "password"));
```

6. **Connection Pooling**: To improve performance and efficiency, we can configure connection pooling.

```java
RestTemplate restTemplate = new RestTemplate();
HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();
requestFactory.setHttpClient(HttpClients.createDefault());
restTemplate.setRequestFactory(requestFactory);
```

### **RestTemplate methods**

Some of the RestTemplate methods are given below. For more details visit [https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html)

* `restTemplate.getForEntity(...)`:

Sends an HTTP GET request to the specified URL. Retrieves the entire HTTP response, including headers and body, and returns it encapsulated in a `ResponseEntity` object. It allows to access response headers, status code, and body separately.

* `restTemplate.exchange(...)`:

Provides more flexibility than `getForEntity()` by allowing to specify the HTTP method (GET, POST, PUT, DELETE, etc.), headers, request entity, and response type. Returns a `ResponseEntity` like `getForEntity()`, but with the ability to specify additional request parameters.

* `restTemplate.delete(...)`:

Sends an HTTP DELETE request to the specified URL. It's a convenience method specifically for DELETE requests, equivalent to `exchange(url, HttpMethod.DELETE, ...)`. Does not expect a response body.

* `restTemplate.execute(...)`:

This method provides the lowest-level access to HTTP requests. It takes an instance of `RequestCallback` and `ResponseExtractor` as parameters . This allows for full control over the request and response handling.

* `restTemplate.getForObject(...)`:

Similar to `getForEntity()`, but it directly returns the response body instead of encapsulating the entire response in a `ResponseEntity` object. Useful when you're only interested in the response body and don't need access to headers or status code separately.

* `postForObject(...)`:

Sends an HTTP POST request to the specified URL. Accepts a URL, request entity (typically an object representing the request body), and a response type. Returns the response body as an object of the specified type. Convenient when you expect a response body and want it directly mapped to a Java object.

* `postForEntity(...)`:

Similar to `postForObject()` but returns the entire HTTP response encapsulated in a `ResponseEntity` object. This allows you to access the response headers, status code, and body separately.

* `postForLocation(...)`:

Used when we expect the server to respond with a '201 Created' status and a 'Location' header indicating the URL of the newly created resource. Sends an HTTP POST request and returns the URL of the newly created resource.

* `patchForObject(...)`:

Sends an HTTP PATCH request to the specified URL. Similar to `postForObject()` but specifically designed for HTTP PATCH requests. Accepts a URL, request entity (typically an object representing the request body), and a response type.

* `put(...)`:

Sends an HTTP PUT request to the specified URL. Typically used to update an existing resource with the provided request entity. Unlike `postForObject()` and `postForEntity()`, there isn't a `putForObject()` or `putForEntity()` method because `RestTemplate`'s `exchange()` method can be used for PUT requests, providing more flexibility.

