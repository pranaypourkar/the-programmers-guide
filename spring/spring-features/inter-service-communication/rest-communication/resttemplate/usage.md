# Usage

## **About**

In enterprise-grade applications, usage of `RestTemplate` is often abstracted, standardized, and injected as a dependency to ensure reusability, testability, and maintainability.

## **HTTP Methods in RestTemplate**

<table data-header-hidden data-full-width="true"><thead><tr><th width="97.03729248046875"></th><th width="244.3359375"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>HTTP Method</strong></td><td><strong>RestTemplate Method</strong></td><td><strong>Purpose / Description</strong></td><td><strong>Typical Usage</strong></td></tr><tr><td><strong>GET</strong></td><td><code>getForObject(String url, Class&#x3C;T>)</code></td><td>Retrieves a resource and maps the response body to the given class.</td><td>Fetching a customer by ID, getting configuration values, etc.</td></tr><tr><td></td><td><code>getForEntity(String url, Class&#x3C;T>)</code></td><td>Same as above but gives access to full <code>ResponseEntity</code> (headers, status, body).</td><td>When response metadata like headers or status codes matter.</td></tr><tr><td><strong>POST</strong></td><td><code>postForObject(String url, Object, Class&#x3C;T>)</code></td><td>Sends an object as request body and receives a response mapped to the given class.</td><td>Creating a new resource like customer, transaction, etc.</td></tr><tr><td></td><td><code>postForEntity(String url, Object, Class&#x3C;T>)</code></td><td>Similar to above but returns <code>ResponseEntity</code>.</td><td>When we need to access response headers or status along with body.</td></tr><tr><td><strong>PUT</strong></td><td><code>put(String url, Object)</code></td><td>Updates a resource; does not return anything.</td><td>Updating customer details, modifying order info.</td></tr><tr><td><strong>DELETE</strong></td><td><code>delete(String url)</code></td><td>Deletes the resource at the specified URL.</td><td>Deleting a user, removing a product from cart, etc.</td></tr><tr><td><strong>PATCH</strong></td><td><em>Not directly supported (manual <code>exchange</code>)</em></td><td>PATCH is not directly supported; must use <code>exchange()</code> method with <code>HttpMethod.PATCH</code>.</td><td>Partial updates to resources, such as modifying specific fields (e.g., status).</td></tr><tr><td><strong>HEAD</strong></td><td><em>Not directly supported (use <code>exchange</code>)</em></td><td>Used to fetch headers without the body. Often used for metadata checks.</td><td>Checking if a resource exists without downloading it.</td></tr><tr><td><strong>OPTIONS</strong></td><td><em>Not directly supported (use <code>exchange</code>)</em></td><td>To determine allowed operations on a resource.</td><td>Checking CORS rules or supported methods.</td></tr><tr><td><strong>Any</strong></td><td><code>exchange(String url, HttpMethod, HttpEntity, Class&#x3C;T>)</code></td><td>General-purpose method to perform any HTTP request with full control.</td><td>Advanced use cases needing headers, custom methods, etc.</td></tr><tr><td><strong>Any (generic)</strong></td><td><code>execute(String url, HttpMethod, RequestCallback, ResponseExtractor&#x3C;T>)</code></td><td>Lowest-level API for full flexibility.</td><td>Rarely used; suited for streaming, low-level customization.</td></tr></tbody></table>

## **Centralized Configuration Using `@Bean`**

In most large-scale applications, `RestTemplate` is defined as a Spring-managed bean to ensure consistent configuration across the application. Timeouts, interceptors, and error handling are typically set once and reused.

```java
@Configuration
public class RestTemplateConfig {

    @Bean
    public RestTemplate restTemplate(RestTemplateBuilder builder) {
        return builder
                .setConnectTimeout(Duration.ofSeconds(5))
                .setReadTimeout(Duration.ofSeconds(10))
                .additionalInterceptors(new LoggingInterceptor())
                .build();
    }
}
```

This ensures:

* Centralized control over timeouts
* Reusable interceptors (e.g., logging, authentication headers)
* Consistent error behavior

## **Dependency Injection and Reuse in Services**

Avoid creating `RestTemplate` instances manually. In real-world services, it is autowired and reused.

```java
@Service
public class CustomerService {

    private final RestTemplate restTemplate;

    @Autowired
    public CustomerService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public CustomerDTO fetchCustomerById(String customerId) {
        String url = "https://customer-service/api/customers/{id}";
        return restTemplate.getForObject(url, CustomerDTO.class, customerId);
    }
}
```

This is how services talk to other services over HTTP. The URL is often externalized using `@Value` or a config server.

## **Using Exchange for Full Control**

When we need to control HTTP method, headers, request body, or inspect the full response (`status code`, `headers`, `body`), the `exchange()` method is used.

```java
public PaymentResponse initiatePayment(PaymentRequest paymentRequest) {
    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.APPLICATION_JSON);
    headers.setBearerAuth(tokenService.getAccessToken());

    HttpEntity<PaymentRequest> entity = new HttpEntity<>(paymentRequest, headers);

    ResponseEntity<PaymentResponse> response = restTemplate.exchange(
            "https://payment-service/api/payments",
            HttpMethod.POST,
            entity,
            PaymentResponse.class
    );

    return response.getBody();
}
```

This approach mirrors real-world APIs where headers, tokens, and status need to be fully managed.

## **Handling Path and Query Parameters**

For APIs with dynamic segments or filters:

```java
String url = "https://orders-service/api/orders/{orderId}";
OrderDTO order = restTemplate.getForObject(url, OrderDTO.class, "ORD123");
```

Or with query parameters:

```java
UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl("https://orders-service/api/orders")
        .queryParam("status", "PENDING")
        .queryParam("limit", 10);

OrderListResponse orders = restTemplate.getForObject(builder.toUriString(), OrderListResponse.class);
```
