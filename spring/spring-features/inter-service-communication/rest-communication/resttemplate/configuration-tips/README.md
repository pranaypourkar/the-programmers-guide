---
hidden: true
---

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

Using `RestTemplateBuilder` allows you to apply global settings such as timeouts, interceptors, and message converters.

## Setting Timeouts

Timeouts are a **critical part of robust system design**. They help prevent your application from hanging indefinitely when a remote service is **slow, overloaded, or unresponsive**.

In enterprise applications, you should never rely on the default timeout settings, as they are often unbounded or too generous.

#### **Types of Timeouts You Should Configure**

In the context of `RestTemplate`, you typically configure two timeouts

<table data-full-width="true"><thead><tr><th width="181.48699951171875">Timeout Type</th><th>Description</th></tr></thead><tbody><tr><td>Connection Timeout</td><td>Time allowed to establish the <strong>TCP connection</strong> to the target server.</td></tr><tr><td>Read Timeout</td><td>Time to wait for the <strong>response</strong> after sending the request. If the server is slow to respond or never responds, this will kick in.</td></tr></tbody></table>

Optional (depending on request factory)

<table data-full-width="true"><thead><tr><th width="184.00433349609375">Timeout Type</th><th>Description</th></tr></thead><tbody><tr><td>Connection Request Timeout</td><td>Time to wait for a connection from the connection pool (for pooled HTTP clients). Useful when you're reusing HTTP connections.</td></tr></tbody></table>

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
* In situations where you **don't require** advanced HTTP features like pooling, connection reuse, or retry strategies.
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
* When you need connection pooling for **performance optimization**.
* If you're interacting with external APIs or services with potential for high latency.

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
* When you want to keep timeout and other settings **externalized** via config files (YAML/properties).
* If you want to create **preconfigured RestTemplate beans** shared across services with minimal boilerplate.

We can combine it with `.requestFactory(...)` to fully customize the underlying factory (e.g., inject Apache HttpClient).

**Advantages**

* Aligns well with **Spring Boot auto-configuration**.
* Works seamlessly with `@ConfigurationProperties` for dynamic timeout settings.
* Useful for **unit testing**, as the builder can be mocked or overridden easily.

## Adding Interceptors

Interceptors in `RestTemplate` allow you to **intercept HTTP requests and responses** before they are sent and after they are received. This provides a powerful mechanism to:

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

### **How to Register Interceptors**

You can add interceptors to a `RestTemplate` either programmatically or through `RestTemplateBuilder`.

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



## Connection Pooling



## Injecting Properties



