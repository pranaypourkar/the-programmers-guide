# Configuration

## About

`RestTemplate` is a central class in Spring that allows applications to make HTTP calls to external services in a simple and declarative way. However, just using `new RestTemplate()` is rarely enough. In real-world applications, `RestTemplate` needs proper configuration to handle timeouts, error handling, authentication, message conversion, and performance tuning.

## **Creating and Registering a RestTemplate Bean**

The best practice is to **create a single `RestTemplate` bean** and inject it wherever needed.

```java
@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder.build();
    }
}
```

Using `RestTemplateBuilder` allows us to apply global settings such as timeouts, interceptors, and message converters.

## Setting Timeouts

Timeouts are a **critical part of robust system design**. They help prevent our application from hanging indefinitely when a remote service is **slow, overloaded, or unresponsive**.

In enterprise applications, we should never rely on the default timeout settings, as they are often unbounded or too generous.

#### **Types of Timeouts We Should Configure**

In the context of `RestTemplate`, we typically configure two timeouts

<table data-full-width="true"><thead><tr><th width="181.48699951171875">Timeout Type</th><th>Description</th></tr></thead><tbody><tr><td>Connection Timeout</td><td>Time allowed to establish the <strong>TCP connection</strong> to the target server.</td></tr><tr><td>Read Timeout</td><td>Time to wait for the <strong>response</strong> after sending the request. If the server is slow to respond or never responds, this will kick in.</td></tr></tbody></table>

Optional (depending on request factory)

<table data-full-width="true"><thead><tr><th width="184.00433349609375">Timeout Type</th><th>Description</th></tr></thead><tbody><tr><td>Connection Request Timeout</td><td>Time to wait for a connection from the connection pool (for pooled HTTP clients). Useful when we are reusing HTTP connections.</td></tr></tbody></table>

### **1. Using SimpleClientHttpRequestFactory**

This is the **default and simplest HTTP request factory** provided by Spring. It directly uses the `java.net.HttpURLConnection` under the hood.

**Characteristics**

* Lightweight and easy to set up.
* Good for **basic use cases** with low concurrency.
* No support for **connection pooling**.
* Limited to **blocking** I/O operations.
* Best suited for **small applications, internal tooling, or test utilities**.

```java
SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
factory.setConnectTimeout(3000);  // milliseconds
factory.setReadTimeout(8000);

RestTemplate restTemplate = new RestTemplate(factory);
```

**When to Use**

* When building **non-critical** or **internal apps** with low request volume.
* In situations where we **don't require** advanced HTTP features like pooling, connection reuse, or retry strategies.
* For rapid prototyping and quick integrations.

**Limitations**

* **No connection reuse**: a new connection is created for each request.
* Cannot tune many HTTP-layer concerns (e.g., keep-alive, socket buffering, etc.).
* Not suitable for production-level **microservices or distributed systems**.

### **2. Using HttpComponentsClientHttpRequestFactory**

Backed by **Apache HttpClient**, this factory allows advanced HTTP capabilities including:

* **Connection pooling**
* **Retry policies**
* **Custom headers, interceptors**
* SSL configuration
* Request-level tuning

**Characteristics**

* Supports **fine-grained timeout control**: connection timeout, read timeout, and connection request timeout.
* Integrates well with enterprise-grade HTTP configurations.
* Suitable for **high-performance** and **scalable** applications.
* Supports **connection reuse**, improving performance.

```java
HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
factory.setConnectTimeout(3000);
factory.setReadTimeout(10000);
factory.setConnectionRequestTimeout(2000);

RestTemplate restTemplate = new RestTemplate(factory);
```

**When to Use**

* For **enterprise-scale applications** or **microservices** communicating over HTTP.
* When we need connection pooling for **performance optimization**.
* If we are interacting with external APIs or services with potential for high latency.

**Additional Benefits**

* Can plug in a **custom HttpClient** with additional configurations (e.g., proxy, TLS versions, keep-alive).
* Better control for **timeouts per route** or host.

### **3. Using RestTemplateBuilder**

A **Spring Boot convenience builder** for creating `RestTemplate` instances in a more declarative and chainable manner.

**Characteristics**

* Encourages **cleaner, more readable code**.
* Automatically injects common configurations (e.g., message converters, interceptors).
* Easily integrates with **application properties**, profiles, and dependency injection.
* Under the hood, it can use any `ClientHttpRequestFactory`, most commonly the Apache one in Spring Boot setups.

```java
@Bean
public RestTemplate restTemplate(RestTemplateBuilder builder) {
    return builder
        .setConnectTimeout(Duration.ofSeconds(3))
        .setReadTimeout(Duration.ofSeconds(10))
        .build();
}
```

**When to Use**

* In **Spring Boot applications**, where idiomatic configuration and centralization are preferred.
* When we want to keep timeout and other settings **externalized** via config files (YAML/properties).
* If we want to create **preconfigured RestTemplate beans** shared across services with minimal boilerplate.

We can combine it with `.requestFactory(...)` to fully customize the underlying factory (e.g., inject Apache HttpClient).

**Advantages**

* Aligns well with **Spring Boot auto-configuration**.
* Works seamlessly with `@ConfigurationProperties` for dynamic timeout settings.
* Useful for **unit testing**, as the builder can be mocked or overridden easily.

## Adding Interceptors

Interceptors in `RestTemplate` allow we to **intercept HTTP requests and responses** before they are sent and after they are received. This provides a powerful mechanism to:

* Enrich or modify the request (e.g., add headers)
* Log outgoing and incoming traffic
* Propagate context (like trace IDs, auth tokens)
* Handle cross-cutting concerns like metrics, retries, or API versioning

They are analogous to servlet filters but applied to outbound HTTP calls.

### **Interface: `ClientHttpRequestInterceptor`**

Each interceptor implements the following interface:

```java
public interface ClientHttpRequestInterceptor {
    ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution)
        throws IOException;
}
```

* `request`: Contains metadata like headers and URL.
* `body`: Raw request body in bytes.
* `execution`: Used to proceed with the actual call.

### **How to Register Interceptors ?**

We can add interceptors to a `RestTemplate` either programmatically or through `RestTemplateBuilder`.

#### **Registering Manually**

```java
@Bean
public RestTemplate restTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    List<ClientHttpRequestInterceptor> interceptors = new ArrayList<>();
    interceptors.add(new HeaderAddingInterceptor());
    interceptors.add(new LoggingInterceptor());
    restTemplate.setInterceptors(interceptors);
    return restTemplate;
}
```

### Example

#### 1. **Add Standard Headers (e.g., Authentication, Correlation IDs)**

```java
public class HeaderAddingInterceptor implements ClientHttpRequestInterceptor {
    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body,
                                        ClientHttpRequestExecution execution) throws IOException {
        request.getHeaders().add("X-Correlation-ID", MDC.get("correlationId"));
        request.getHeaders().add("Authorization", "Bearer " + getJwtToken());
        return execution.execute(request, body);
    }

    private String getJwtToken() {
        // Retrieve from thread-local storage or context
        return SecurityContextHolder.getContext().getAuthentication().getCredentials().toString();
    }
}
```

This is useful when every service call needs security and traceability.

#### 2. **Centralized Logging of Requests/Responses**

```java
public class LoggingInterceptor implements ClientHttpRequestInterceptor {

    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body,
                                        ClientHttpRequestExecution execution) throws IOException {

        logRequest(request, body);

        ClientHttpResponse response = execution.execute(request, body);

        logResponse(response);

        return response;
    }

    private void logRequest(HttpRequest request, byte[] body) {
        System.out.println("Sending Request to URI: " + request.getURI());
        System.out.println("Headers: " + request.getHeaders());
        System.out.println("Body: " + new String(body, StandardCharsets.UTF_8));
    }

    private void logResponse(ClientHttpResponse response) throws IOException {
        System.out.println("Response Status: " + response.getStatusCode());
        // Avoid reading body here if the stream will be consumed downstream
    }
}
```

This is critical in environments where auditing, debugging, or API telemetry is required.

#### 3. **Dynamic API Key Injection Based on Service**

```java
public class ApiKeyRoutingInterceptor implements ClientHttpRequestInterceptor {

    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body,
                                        ClientHttpRequestExecution execution) throws IOException {

        URI uri = request.getURI();
        if (uri.getHost().contains("payment-service")) {
            request.getHeaders().add("x-api-key", "payment-service-key");
        } else if (uri.getHost().contains("inventory-service")) {
            request.getHeaders().add("x-api-key", "inventory-service-key");
        }

        return execution.execute(request, body);
    }
}
```

Used in multi-tenant or multi-provider integrations.

## Custom Message Converters

In Spring’s `RestTemplate`, **message converters** are responsible for serializing Java objects into HTTP request bodies and deserializing HTTP response bodies into Java objects. These converters implement the interface `HttpMessageConverter`.

Spring provides a set of default converters (like `MappingJackson2HttpMessageConverter` for JSON), but we can register our **own converters** when:

* Working with custom media types
* Using an alternative serialization library (e.g., Gson, Protobuf)
* Customizing how objects are serialized/deserialized (e.g., date formats, field naming, null handling)

### **Default Converters**

Spring Boot pre-configures the following (based on dependencies):

<table data-full-width="true"><thead><tr><th width="358.14410400390625">Converter Class</th><th width="162.35064697265625">Purpose</th><th>Media Type</th></tr></thead><tbody><tr><td><code>StringHttpMessageConverter</code></td><td>Text/plain</td><td><code>text/plain</code></td></tr><tr><td><code>MappingJackson2HttpMessageConverter</code></td><td>JSON using Jackson</td><td><code>application/json</code></td></tr><tr><td><code>Jaxb2RootElementHttpMessageConverter</code></td><td>XML via JAXB</td><td><code>application/xml</code></td></tr><tr><td><code>FormHttpMessageConverter</code></td><td>Form data</td><td><code>application/x-www-form-urlencoded</code></td></tr></tbody></table>

These are added to `RestTemplate` when it’s auto-configured via `RestTemplateBuilder`.

### **Why Customize Message Converters ?**

<table data-full-width="true"><thead><tr><th>Scenario</th><th>Example</th></tr></thead><tbody><tr><td>Need to support additional serialization formats</td><td>Protocol Buffers, Avro, Smile</td></tr><tr><td>Require fine-tuned Jackson behavior</td><td>Use snake_case, omit nulls, custom serializers</td></tr><tr><td>Work with encrypted or compressed payloads</td><td>Custom stream-based converter</td></tr><tr><td>Our API uses non-standard media types</td><td>e.g., <code>application/vnd.company.v1+json</code></td></tr><tr><td>Need to use libraries like Gson or Moshi</td><td>Replacing Jackson entirely</td></tr></tbody></table>

### **How to Add Custom Message Converters ?**

#### **Programmatic Registration**

```java
@Bean
public RestTemplate restTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    List<HttpMessageConverter<?>> converters = new ArrayList<>();

    converters.add(customJacksonConverter());
    converters.add(new ProtobufHttpMessageConverter()); // if using Protobuf
    converters.addAll(restTemplate.getMessageConverters()); // preserve defaults

    restTemplate.setMessageConverters(converters);
    return restTemplate;
}

private MappingJackson2HttpMessageConverter customJacksonConverter() {
    ObjectMapper objectMapper = new ObjectMapper();
    objectMapper.setPropertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE);
    objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);

    MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter(objectMapper);
    converter.setSupportedMediaTypes(List.of(MediaType.APPLICATION_JSON));
    return converter;
}
```

### **Use Case: Supporting a Custom Media Type**

```java
public class CustomMediaTypeConverter extends AbstractHttpMessageConverter<MyCustomType> {

    public CustomMediaTypeConverter() {
        super(new MediaType("application", "vnd.company.v1+json"));
    }

    @Override
    protected boolean supports(Class<?> clazz) {
        return MyCustomType.class.equals(clazz);
    }

    @Override
    protected MyCustomType readInternal(Class<? extends MyCustomType> clazz,
                                        HttpInputMessage inputMessage) throws IOException {
        // Custom deserialization logic
    }

    @Override
    protected void writeInternal(MyCustomType myCustomType,
                                 HttpOutputMessage outputMessage) throws IOException {
        // Custom serialization logic
    }
}
```

Register this converter along with our `RestTemplate`.

### **Use Case: Replace Jackson with Gson**

```java
@Bean
public RestTemplate gsonRestTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd'T'HH:mm:ssZ")
            .create();

    GsonHttpMessageConverter gsonConverter = new GsonHttpMessageConverter(gson);

    restTemplate.setMessageConverters(List.of(gsonConverter));
    return restTemplate;
}
```

### **How Converters Are Selected**

When a request or response is processed:

1. Spring inspects the `Content-Type` and `Accept` headers.
2. It looks for the **first compatible converter** that supports both the Java type and media type.
3. If none match, it throws an `HttpMediaTypeNotSupportedException`.

We can manipulate this behavior by adjusting:

* `Accept` and `Content-Type` headers
* Supported media types in our converter
* Converter order in the list

## Connection Pooling

Connection pooling is a technique used to **reuse existing HTTP connections** instead of opening a new connection for every request. When `RestTemplate` is used with its default setup (`SimpleClientHttpRequestFactory`), **each request opens a new HTTP connection**, which is expensive in high-throughput applications.

To optimize resource usage and improve performance, Spring allows `RestTemplate` to be configured with **connection pooling** using a more advanced `ClientHttpRequestFactory`, typically backed by **Apache HttpClient** or **OkHttp**.

### **Why Connection Pooling Matters ?**

<table data-full-width="true"><thead><tr><th width="411.6484375">Reason</th><th>Benefit</th></tr></thead><tbody><tr><td><strong>Avoid overhead of creating new TCP connections</strong></td><td>Reduces latency and CPU usage</td></tr><tr><td><strong>Reuses persistent connections</strong></td><td>Boosts throughput for HTTP/1.1 keep-alive</td></tr><tr><td><strong>Handles concurrent requests efficiently</strong></td><td>Suitable for microservices, APIs, batch jobs</td></tr><tr><td><strong>Enables timeout management</strong></td><td>Controls socket/connect/read timeouts</td></tr><tr><td><strong>Provides fine-grained tuning</strong></td><td>Max connections, eviction, retries</td></tr></tbody></table>

### **Default vs. Pooled**

<table><thead><tr><th width="98.1796875">Setup</th><th>Request Factory</th><th>Connection Handling</th></tr></thead><tbody><tr><td>Default</td><td><code>SimpleClientHttpRequestFactory</code></td><td>New connection per request</td></tr><tr><td>Pooled</td><td><code>HttpComponentsClientHttpRequestFactory</code> (Apache) or <code>OkHttp3ClientHttpRequestFactory</code></td><td>Reuses connections via pool</td></tr></tbody></table>

### **Apache HttpClient Setup for Pooling**

```java
@Bean
public RestTemplate pooledRestTemplate() {
    HttpClientConnectionManager poolingConnManager = new PoolingHttpClientConnectionManager();
    ((PoolingHttpClientConnectionManager) poolingConnManager).setMaxTotal(100);
    ((PoolingHttpClientConnectionManager) poolingConnManager).setDefaultMaxPerRoute(20);

    RequestConfig requestConfig = RequestConfig.custom()
        .setConnectTimeout(3000)
        .setSocketTimeout(5000)
        .setConnectionRequestTimeout(2000)
        .build();

    CloseableHttpClient httpClient = HttpClients.custom()
        .setConnectionManager(poolingConnManager)
        .setDefaultRequestConfig(requestConfig)
        .evictIdleConnections(30, TimeUnit.SECONDS)
        .build();

    ClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);
    return new RestTemplate(factory);
}
```

<table><thead><tr><th width="349.35589599609375">Setting</th><th>Description</th></tr></thead><tbody><tr><td><code>setMaxTotal(100)</code></td><td>Total max connections in the pool</td></tr><tr><td><code>setDefaultMaxPerRoute(20)</code></td><td>Max concurrent connections per route (host)</td></tr><tr><td><code>setConnectTimeout(3000)</code></td><td>Time to establish TCP connection</td></tr><tr><td><code>setSocketTimeout(5000)</code></td><td>Time waiting for data after connection</td></tr><tr><td><code>setConnectionRequestTimeout(2000)</code></td><td>Time waiting to obtain a connection from the pool</td></tr><tr><td><code>evictIdleConnections(...)</code></td><td>Closes idle connections after timeout</td></tr></tbody></table>

### **Using OkHttp Instead**

```java
@Bean
public RestTemplate okHttpRestTemplate(OkHttpClient okHttpClient) {
    return new RestTemplate(new OkHttp3ClientHttpRequestFactory(okHttpClient));
}
```

`OkHttpClient` supports connection pooling and HTTP/2 by default.

## Logging

### 1. **Enable Basic RestTemplate Logging**

```yaml
logging:
  level:
    org.springframework.web.client.RestTemplate: DEBUG
```

* Logs high-level info: HTTP method, URL, status, etc
*   Example log:

    ```
    DEBUG org.springframework.web.client.RestTemplate - POST request for "http://api.example.com/users"
    DEBUG org.springframework.web.client.RestTemplate - Response 200 OK
    ```

### 2. **Enable Underlying HTTP Client Logging**

#### a) **Default (SimpleClientHttpRequestFactory → java.net.HttpURLConnection)**

Enable JDK HTTP wire logging:

```yaml
logging:
  level:
    sun.net.www.protocol.http.HttpURLConnection: DEBUG
    sun.net.www.protocol.http: DEBUG
```

* Prints headers and some payload info.
* Useful if we are not overriding the HTTP client.

#### b) **Apache HttpClient (HttpComponentsClientHttpRequestFactory)**

If we use Apache HttpClient under RestTemplate, enable:

```yaml
logging:
  level:
    org.apache.http: DEBUG
    org.apache.http.wire: DEBUG
    org.apache.http.headers: DEBUG
```

* `org.apache.http` → general client internals.
* `org.apache.http.headers` → logs request & response headers.
* `org.apache.http.wire` → logs raw request & response bodies (wire format).

#### c) **OkHttp (OkHttp3ClientHttpRequestFactory)**

If we use OkHttp:

```yaml
logging:
  level:
    okhttp3: DEBUG
    okhttp3.OkHttpClient: DEBUG
```

* Use `HttpLoggingInterceptor` for detailed body logging (more flexible than logger-only).

### 3. **Enable Message Converter Logging**

Spring uses **HttpMessageConverters** to serialize/deserialize request/response bodies.\
Enable logging for Jackson (JSON):

```yaml
logging:
  level:
    org.springframework.http.converter.json: DEBUG
    com.fasterxml.jackson.databind: DEBUG
```

* Prints details when converting JSON request/response.

### 4. **Enable Client Factory Logging**

```yaml
logging:
  level:
    org.springframework.http.client: DEBUG
```

* Shows which HTTP client factory (`SimpleClientHttpRequestFactory`, `HttpComponentsClientHttpRequestFactory`, etc.) RestTemplate is using.
