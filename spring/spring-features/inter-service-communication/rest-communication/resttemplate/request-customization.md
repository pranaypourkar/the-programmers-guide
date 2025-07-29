# Request Customization

## **About**

`RestTemplate` provides several hooks and constructs to allow **request customization** a critical aspect when interacting with external APIs or internal microservices that require authentication, custom headers, request transformations, logging, tracing, or advanced configuration like timeouts and interceptors.

Customizing a request ensures that our API calls are:

* Secure (e.g., with bearer tokens or API keys),
* Compliant (e.g., with required content-type or correlation IDs),
* Reliable (e.g., with retries, timeouts, and fallbacks),
* Traceable (e.g., with custom headers for distributed tracing).

## **Common Use Cases**

<table data-header-hidden data-full-width="true"><thead><tr><th width="346.17108154296875"></th><th></th></tr></thead><tbody><tr><td><strong>Use Case</strong></td><td><strong>Customization Example</strong></td></tr><tr><td>Add Path and Query Param</td><td>Set Query, Path parameters</td></tr><tr><td>Add Request Body</td><td>Set API Request body</td></tr><tr><td>Add authentication headers</td><td>Bearer token, API key, Basic Auth</td></tr><tr><td>Include trace/correlation IDs</td><td>Pass unique request ID for observability</td></tr><tr><td>Change content type / accept type</td><td><code>application/json</code>, <code>application/xml</code>, custom media types</td></tr><tr><td>Modify request payload</td><td>Pre-serialize object, or add additional request fields</td></tr><tr><td>Set timeouts or connection pool</td><td>Customize via underlying <code>HttpClient</code> or <code>RestTemplateBuilder</code></td></tr><tr><td>Pre-process request before sending</td><td>Interceptors, <code>ClientHttpRequestInterceptor</code></td></tr><tr><td>Add dynamic headers from context</td><td>Extract values from MDC, ThreadLocal, or SecurityContext</td></tr></tbody></table>

## Add Path and Query Param

When interacting with external or internal REST APIs, it is common to dynamically construct the request URL by appending:

* **Path Parameters** — values embedded directly within the URL path (e.g., `/user/{id}`),
* **Query Parameters** — key-value pairs appended after the `?` in the URL (e.g., `?status=active&limit=10`).

Spring’s `RestTemplate` provides multiple ways to inject these parameters cleanly and maintainably.

### **1. Using Path Variables with URI Template Expansion**

This is the most common and safe way to replace path variables in endpoint templates using placeholders.

```java
String url = "https://api.example.com/users/{userId}/orders/{orderId}";
Map<String, String> uriVariables = Map.of(
    "userId", "12345",
    "orderId", "987"
);

ResponseEntity<OrderResponse> response = restTemplate.getForEntity(
    url,
    OrderResponse.class,
    uriVariables
);
```

* Path placeholders (`{userId}`, `{orderId}`) are automatically replaced by values from the `Map`.
* No need for string concatenation.
* Prevents URL injection or malformed paths.

### **2. Path Params via `UriComponentsBuilder` for Dynamic URIs**

Use `UriComponentsBuilder` when we want to construct complex URLs that include both path variables and query parameters dynamically.

```java
URI uri = UriComponentsBuilder
    .fromUriString("https://api.example.com/users/{userId}/orders")
    .queryParam("page", 1)
    .queryParam("limit", 50)
    .queryParam("sortBy", "date")
    .buildAndExpand("12345")
    .toUri();

ResponseEntity<OrderList> response = restTemplate.getForEntity(uri, OrderList.class);
```

* `buildAndExpand("12345")` replaces `{userId}`.
* `queryParam()` is used for clean and safe appending of query parameters.
* Works great for pagination, filtering, and sorting APIs.

### **3. Fully Programmatic Path + Query Construction**

This is helpful when query params are optional or dynamically built based on logic:

```java
MultiValueMap<String, String> queryParams = new LinkedMultiValueMap<>();
queryParams.add("category", "books");
queryParams.add("sort", "title");
queryParams.add("sort", "price"); // multiple values for same key

URI uri = UriComponentsBuilder
    .fromUriString("https://api.example.com/users/{userId}/cart")
    .queryParams(queryParams)
    .buildAndExpand("u7890")
    .encode()
    .toUri();

ResponseEntity<CartResponse> response = restTemplate.exchange(
    uri,
    HttpMethod.GET,
    null,
    CartResponse.class
);
```

* `MultiValueMap` handles multiple query parameters with the same key.
* `encode()` ensures proper URI encoding for special characters.

### **4. Mixing Path and Query Params in POST Request**

Even in POST calls (or PUT), query parameters are often used for metadata like versioning or flags.

```java
URI uri = UriComponentsBuilder
    .fromUriString("https://api.example.com/users/{id}/upload")
    .queryParam("async", "true")
    .queryParam("version", "v2")
    .buildAndExpand("user123")
    .toUri();

HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
HttpEntity<FileUploadRequest> request = new HttpEntity<>(fileRequest, headers);

ResponseEntity<FileUploadResponse> response = restTemplate.exchange(
    uri,
    HttpMethod.POST,
    request,
    FileUploadResponse.class
);
```

## Add Request Body

When making HTTP methods like `POST`, `PUT`, or `PATCH`, the client often needs to send a structured **request body** typically in JSON or XML format. This body carries the actual business payload (e.g., user details, payment data, file metadata).

Spring’s `RestTemplate` allows for seamless serialization of Java objects into the body of a request using its built-in message converters (usually `MappingJackson2HttpMessageConverter` for JSON).

{% hint style="success" %}
* `HttpEntity<T>` is used to encapsulate:
  * **Body** – the Java object (payload).
  * **Headers** – content type, authentication, etc.
* Always specify `Content-Type` (`application/json`) to avoid serialization issues.
{% endhint %}

### **1. POST Request with JSON Body**

```java
UserCreateRequest user = new UserCreateRequest("john.doe", "password123");

HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);

HttpEntity<UserCreateRequest> requestEntity = new HttpEntity<>(user, headers);

ResponseEntity<UserResponse> response = restTemplate.postForEntity(
    "https://api.example.com/users",
    requestEntity,
    UserResponse.class
);
```

* `user` is automatically serialized into JSON.
* The content-type is declared explicitly.
* Response is mapped to `UserResponse`.

### **2. PUT Request with Request Body**

```java
UserUpdateRequest updateRequest = new UserUpdateRequest("john.doe", "newemail@example.com");

HttpEntity<UserUpdateRequest> entity = new HttpEntity<>(updateRequest);

restTemplate.put("https://api.example.com/users/{id}", entity, "123");
```

* PUT operations use `restTemplate.put()`.
* Path variable (`{id}`) is passed separately.

### **3. Exchange Method for Full Control (POST, PUT, PATCH)**

For advanced use cases like:

* Passing **custom headers**
* Supporting non-JSON content
* Handling dynamic URLs

Use `exchange()` method:

```java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
headers.set("X-Correlation-Id", "txn-456789");

PaymentRequest payload = new PaymentRequest("user123", 100.0);

HttpEntity<PaymentRequest> request = new HttpEntity<>(payload, headers);

URI uri = UriComponentsBuilder
    .fromUriString("https://api.example.com/payments?async=true")
    .build()
    .toUri();

ResponseEntity<PaymentResponse> response = restTemplate.exchange(
    uri,
    HttpMethod.POST,
    request,
    PaymentResponse.class
);
```

### **4. Sending a List or Collection in Request Body**

For APIs that accept arrays or lists:

```java
List<String> userIds = List.of("u123", "u124", "u125");

HttpEntity<List<String>> request = new HttpEntity<>(userIds);

ResponseEntity<GroupResponse> response = restTemplate.postForEntity(
    "https://api.example.com/groups/{groupId}/users",
    request,
    GroupResponse.class,
    "teamA"
);
```

### **5. Sending a Form-Encoded Body (Non-JSON)**

If the backend expects a URL-encoded form body:

```java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
map.add("username", "john");
map.add("password", "secret");

HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(map, headers);

ResponseEntity<TokenResponse> response = restTemplate.postForEntity(
    "https://auth.example.com/oauth/token",
    request,
    TokenResponse.class
);
```

## Add authentication headers

In most enterprise applications, outbound HTTP requests need to include **authentication** details—whether via **Bearer tokens**, **API keys**, **Basic Auth**, or **custom headers**—to access protected APIs.

Spring’s `RestTemplate` allows injecting headers easily via `HttpHeaders`, which are then bundled with the request body using `HttpEntity`.

{% hint style="success" %}
* Headers are included using `HttpHeaders`, which supports all standard and custom header types.
* Auth headers are most often added as:
  * `Authorization: Bearer <token>` (OAuth/JWT)
  * `Authorization: Basic <base64>` (Basic Auth)
  * `X-API-Key: <key>` (Custom API key)
* `HttpEntity` is used to combine **headers** and optional **body** for request.
{% endhint %}

### **1. Bearer Token Authentication**

Used widely with OAuth 2.0, JWT, and internal token-based auth:

```java
HttpHeaders headers = new HttpHeaders();
headers.setBearerAuth("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...");

HttpEntity<Void> entity = new HttpEntity<>(headers);

ResponseEntity<AccountResponse> response = restTemplate.exchange(
    "https://api.example.com/accounts/{id}",
    HttpMethod.GET,
    entity,
    AccountResponse.class,
    "acc123"
);
```

* `setBearerAuth()` automatically adds the header:\
  `Authorization: Bearer <token>`

### **2. Basic Authentication**

For services still using basic HTTP authentication:

```java
String plainCreds = "username:password";
String base64Creds = Base64.getEncoder().encodeToString(plainCreds.getBytes());

HttpHeaders headers = new HttpHeaders();
headers.add("Authorization", "Basic " + base64Creds);

HttpEntity<Void> entity = new HttpEntity<>(headers);

ResponseEntity<EmployeeData> response = restTemplate.exchange(
    "https://internal.example.com/employees",
    HttpMethod.GET,
    entity,
    EmployeeData.class
);
```

* Encodes the string as `Authorization: Basic <encoded-credentials>`

### **3. API Key as Header**

Some services use API keys passed in custom headers like `X-API-Key` or `x-client-secret`:

```java
HttpHeaders headers = new HttpHeaders();
headers.add("X-API-Key", "api-key-987654321");

HttpEntity<Void> request = new HttpEntity<>(headers);

ResponseEntity<InvoiceResponse> response = restTemplate.exchange(
    "https://thirdparty.com/invoices",
    HttpMethod.GET,
    request,
    InvoiceResponse.class
);
```

### **4. With Request Body and Auth Headers (POST)**

When sending both payload and headers:

```java
PaymentRequest payment = new PaymentRequest("txn789", 150.00);

HttpHeaders headers = new HttpHeaders();
headers.setBearerAuth("secure-token-123");
headers.setContentType(MediaType.APPLICATION_JSON);

HttpEntity<PaymentRequest> requestEntity = new HttpEntity<>(payment, headers);

ResponseEntity<PaymentResponse> response = restTemplate.postForEntity(
    "https://api.example.com/payments",
    requestEntity,
    PaymentResponse.class
);
```

### **5. Dynamically Inject Headers via Interceptor (Reusable)**

If every request should carry a token:

```java
public class AuthInterceptor implements ClientHttpRequestInterceptor {
    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body, ClientHttpRequestExecution execution)
            throws IOException {
        request.getHeaders().setBearerAuth("dynamic-token-here");
        return execution.execute(request, body);
    }
}
```

Register it:

```java
RestTemplate restTemplate = new RestTemplate();
restTemplate.getInterceptors().add(new AuthInterceptor());
```

* Recommended when a common token applies to all requests.
* Encouraged over repeating header logic in every request.

## Include trace/correlation IDs

In distributed systems and microservices, **correlation IDs (also called trace IDs or request IDs)** are essential for **request tracking, observability, debugging, and log correlation** across service boundaries.

When making HTTP calls using `RestTemplate`, it's a common practice to **propagate the correlation ID** received in the incoming request to any downstream services.

### **1. Manually Add a Correlation ID to Headers**

If the correlation ID is generated earlier (e.g., in a filter or controller), inject it into outgoing request headers.

```java
String correlationId = MDC.get("X-Correlation-ID"); // From thread-local logging context

HttpHeaders headers = new HttpHeaders();
headers.add("X-Correlation-ID", correlationId);

HttpEntity<Void> entity = new HttpEntity<>(headers);

ResponseEntity<CustomerResponse> response = restTemplate.exchange(
    "https://api.partner.com/customers/{id}",
    HttpMethod.GET,
    entity,
    CustomerResponse.class,
    "cust-101"
);
```

* **Header Name**: Use a consistent name like `X-Correlation-ID` or `traceId`.

### **2. Automatically Inject Correlation ID via Interceptor**

To avoid repeating this logic everywhere, use a `ClientHttpRequestInterceptor`:

```java
public class CorrelationIdInterceptor implements ClientHttpRequestInterceptor {
    @Override
    public ClientHttpResponse intercept(
            HttpRequest request, byte[] body, ClientHttpRequestExecution execution) throws IOException {
        
        String correlationId = MDC.get("X-Correlation-ID");
        if (correlationId != null) {
            request.getHeaders().add("X-Correlation-ID", correlationId);
        }

        return execution.execute(request, body);
    }
}
```

Register the interceptor:

```java
@Bean
public RestTemplate restTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    restTemplate.getInterceptors().add(new CorrelationIdInterceptor());
    return restTemplate;
}
```

* Now **every outbound call** via `RestTemplate` will carry the correlation ID.

### **3. Integration with Spring Cloud Sleuth**

If we use **Spring Cloud Sleuth**, it automatically manages trace IDs and span IDs:

```plaintext
X-B3-TraceId: 7b63a1d95e0e33c7
X-B3-SpanId: d7a1fbea4e3fa0b7
X-B3-Sampled: 1
```

We can keep this in sync with our custom `X-Correlation-ID` by configuring MDC.

### **4. Handling Missing Correlation IDs**

In a gateway or edge service, it’s common to **generate a correlation ID** if not already present:

```java
String correlationId = Optional.ofNullable(MDC.get("X-Correlation-ID"))
                               .orElse(UUID.randomUUID().toString());

MDC.put("X-Correlation-ID", correlationId);
```

Then pass this into headers downstream.

## Change content type / accept type

When consuming external or internal REST APIs, it's crucial to **explicitly set `Content-Type` and `Accept` headers** to align with what the server expects and returns. These headers define:

* `Content-Type`: The format of the request body being sent.
* `Accept`: The format that the client can process in the response.

Failing to set these correctly can lead to:

* `415 Unsupported Media Type`
* `406 Not Acceptable`
* Unexpected deserialization failures

#### **Typical Scenarios**

<table data-full-width="true"><thead><tr><th width="287.06683349609375">Use Case</th><th>Required Content-Type</th><th>Required Accept-Type</th></tr></thead><tbody><tr><td>Sending JSON payload</td><td><code>application/json</code></td><td><code>application/json</code></td></tr><tr><td>Consuming XML-based third-party API</td><td><code>application/xml</code></td><td><code>application/xml</code></td></tr><tr><td>Posting form data</td><td><code>application/x-www-form-urlencoded</code></td><td>Depends on API, often JSON or text</td></tr><tr><td>Multipart file upload</td><td><code>multipart/form-data</code></td><td>Usually JSON or plain text</td></tr><tr><td>Consuming text or CSV file</td><td><code>text/plain</code>, <code>text/csv</code></td><td><code>text/plain</code>, <code>text/csv</code></td></tr></tbody></table>

### **1. Set Content-Type and Accept-Type Explicitly**

We can customize both headers using `HttpHeaders`:

```java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

MyRequest requestPayload = new MyRequest("sample", 42);
HttpEntity<MyRequest> requestEntity = new HttpEntity<>(requestPayload, headers);

ResponseEntity<MyResponse> response = restTemplate.exchange(
    "https://partner.api.com/process",
    HttpMethod.POST,
    requestEntity,
    MyResponse.class
);
```

### **2. Changing Content-Type for Form Submission**

```java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
form.add("username", "john.doe");
form.add("password", "securePass");

HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(form, headers);

ResponseEntity<String> response = restTemplate.postForEntity(
    "https://auth.example.com/login",
    entity,
    String.class
);
```

### **3. Accepting XML Response from External Service**

```java
HttpHeaders headers = new HttpHeaders();
headers.setAccept(Collections.singletonList(MediaType.APPLICATION_XML));

HttpEntity<Void> entity = new HttpEntity<>(headers);

ResponseEntity<MyXmlResponse> response = restTemplate.exchange(
    "https://legacy.service.com/data.xml",
    HttpMethod.GET,
    entity,
    MyXmlResponse.class
);
```

Note: Our `ObjectMapper` (or JAXB if XML) must be correctly configured to handle XML.

### **4. Combine with Interceptors for Reusability**

In large systems, we can create an interceptor that dynamically adjusts content negotiation based on context or configuration.

```java
public class MediaTypeInterceptor implements ClientHttpRequestInterceptor {
    @Override
    public ClientHttpResponse intercept(HttpRequest request, byte[] body,
                                        ClientHttpRequestExecution execution) throws IOException {
        request.getHeaders().setContentType(MediaType.APPLICATION_JSON);
        request.getHeaders().setAccept(List.of(MediaType.APPLICATION_JSON));
        return execution.execute(request, body);
    }
}
```

Register globally:

```java
@Bean
public RestTemplate restTemplate() {
    RestTemplate restTemplate = new RestTemplate();
    restTemplate.getInterceptors().add(new MediaTypeInterceptor());
    return restTemplate;
}
```

### **5. Accept Multiple Media Types**

Sometimes, services support multiple response formats:

```java
headers.setAccept(Arrays.asList(
    MediaType.APPLICATION_JSON,
    MediaType.APPLICATION_XML
));
```

This makes the request more flexible — the server can return what it prefers among those listed.

## Reference: Required Dependencies & Import Statements

#### Maven Dependency

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

#### Common Import Statements

Below are the commonly used import statements for the examples in this guide:

```java
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.client.RestClientException;

import java.util.Base64;
import java.util.Map;
import java.util.Collections;

// For interceptors
import org.springframework.http.client.ClientHttpRequestExecution;
import org.springframework.http.client.ClientHttpRequestInterceptor;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.client.ClientHttpResponse;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
```
