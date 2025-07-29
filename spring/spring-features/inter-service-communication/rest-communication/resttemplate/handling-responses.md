# Handling Responses

## About

When consuming RESTful APIs using `RestTemplate`, handling responses effectively is crucial to building reliable, observable, and maintainable applications. This includes reading the response body, capturing headers, dealing with different status codes, and handling typed or dynamic responses.

## ResponseEntity: The Preferred Wrapper

`ResponseEntity<T>` is the powerful and flexible way to capture the full HTTP response when making REST calls using `RestTemplate`.

In a production-grade system, relying solely on response body (`getForObject`) is often insufficient. We typically need access to **status codes**, **response headers**, or even empty bodies (204 No Content). `ResponseEntity` wraps all of this in one convenient structure.

ResponseEntity represents the entire HTTP response:

```java
ResponseEntity<T> {
   HttpStatus statusCode;
   HttpHeaders headers;
   T body;
}
```

Unlike `getForObject()` which returns only the body, `ResponseEntity` is useful in real-world applications where the **complete response context** matters — not just the payload.

**Example**

```java
ResponseEntity<UserDto> response = restTemplate.getForEntity(
    "https://api.example.com/users/{id}",
    UserDto.class,
    userId
);
```

**We can now extract**

```java
HttpStatus status = response.getStatusCode();        // e.g., 200 OK
HttpHeaders headers = response.getHeaders();         // Custom or standard headers
UserDto user = response.getBody();                   // Actual payload
```

**Handling 204 No Content**

```java
ResponseEntity<Void> response = restTemplate.getForEntity(url, Void.class);
if (response.getStatusCode() == HttpStatus.NO_CONTENT) {
    // No body, but operation was successful
}
```

**Extracting Pagination or Tracking Headers**

```java
String correlationId = response.getHeaders().getFirst("X-Correlation-ID");
String nextPageUrl = response.getHeaders().getFirst("Link");
```

**Building Defensive Services**

```java
if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
    process(response.getBody());
} else {
    throw new ExternalServiceException("Unexpected status: " + response.getStatusCode());
}
```



## Mapping Response to Domain Object

When building enterprise-grade applications, it's critical to **cleanly separate transport-layer data (e.g., JSON over HTTP)** from **internal domain models**. While `RestTemplate` allows direct mapping of HTTP response bodies to Java objects, blindly mapping external data structures into internal models can lead to tight coupling, maintenance issues, and data leakage between layers.

This is why response mapping should be treated as a formal step in our architecture — ensuring robustness, decoupling, and clarity.

Instead of directly consuming the HTTP response into our domain model, map the response to a dedicated DTO (Data Transfer Object) and **then transform it into a domain entity or business object**.

This two-step process:

1. **Maps raw JSON to DTOs** using RestTemplate.
2. **Converts DTO to Domain Object** using mappers (manual or libraries like MapStruct).

<table data-header-hidden data-full-width="true"><thead><tr><th width="312.29510498046875"></th><th></th></tr></thead><tbody><tr><td><strong>Reason</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Decoupling from External API Schema</strong></td><td>If external APIs change, we only need to update the DTO, not the domain logic.</td></tr><tr><td><strong>Avoid Overexposure</strong></td><td>External fields we don’t care about stay out of our core logic.</td></tr><tr><td><strong>Validation &#x26; Transformation</strong></td><td>Apply domain rules or enrich data before creating core objects.</td></tr><tr><td><strong>Reusability</strong></td><td>Same DTO can be used by other layers or adapters (caching, logging, etc.).</td></tr><tr><td><strong>Clean Layering</strong></td><td>Keeps domain layer free of protocol-specific artifacts.</td></tr></tbody></table>

#### **Example**

**1. Response JSON (from external API)**

```json
{
  "user_id": 1001,
  "full_name": "Alice Johnson",
  "email": "alice@example.com",
  "status": "active"
}
```

**2. DTO for External Response**

```java
public class UserResponseDto {
    private Long userId;
    private String fullName;
    private String email;
    private String status;
    // Getters and setters
}
```

**3. Domain Model**

```java
public class User {
    private Long id;
    private String name;
    private String contactEmail;
    private boolean active;

    public User(Long id, String name, String contactEmail, boolean active) {
        this.id = id;
        this.name = name;
        this.contactEmail = contactEmail;
        this.active = active;
    }
}
```

**4. Mapping Logic**

```java
public class UserMapper {
    public static User map(UserResponseDto dto) {
        return new User(
            dto.getUserId(),
            dto.getFullName(),
            dto.getEmail(),
            "active".equalsIgnoreCase(dto.getStatus())
        );
    }
}
```

**5. Usage with RestTemplate**

```java
ResponseEntity<UserResponseDto> response =
    restTemplate.getForEntity("https://api.example.com/users/1001", UserResponseDto.class);

UserResponseDto dto = response.getBody();
User user = UserMapper.map(dto);
```



## Handling JSON Arrays / Lists

When an API responds with a **JSON array**, it represents a collection of similar entities — like a list of users, orders, or products. In enterprise applications, it’s common to consume such arrays and **map them to a list of Java objects** for further processing.

Unlike single-object deserialization, handling arrays requires additional care with `RestTemplate`, especially with **Java generics** and **type erasure**.

**Example: External API Response**

```json
[
  {
    "id": 1,
    "name": "Product A",
    "price": 25.0
  },
  {
    "id": 2,
    "name": "Product B",
    "price": 30.0
  }
]
```

#### **Approach 1: Using `ResponseEntity<T[]>`**

The simplest way to handle a JSON array is to map it into an array of objects:

```java
ResponseEntity<ProductDto[]> response = restTemplate.getForEntity(
    "https://api.example.com/products",
    ProductDto[].class
);

ProductDto[] productArray = response.getBody();
List<ProductDto> productList = Arrays.asList(productArray);
```

* **Pros:** Simple and readable.
* **Cons:** Returns a fixed-size `List` (from `Arrays.asList`) unless we wrap it with `new ArrayList<>(...)`.

#### **Approach 2: Using `ParameterizedTypeReference<List<T>>`**

This is the **preferred approach** in most production systems where generic typing or further abstraction is required.

```java
ResponseEntity<List<ProductDto>> response = restTemplate.exchange(
    "https://api.example.com/products",
    HttpMethod.GET,
    null,
    new ParameterizedTypeReference<List<ProductDto>>() {}
);

List<ProductDto> productList = response.getBody();
```

* **Pros:**
  * Supports generics cleanly.
  * Produces a mutable list.
* **Cons:** Slightly more verbose.



## Dynamic Responses (Map or Raw JSON)

In many real-world APIs, the structure of a response might not be strictly defined or may vary across use cases for instance:

* **Optional fields**
* **Nested dynamic objects**
* **Polymorphic types**
* **Unknown keys or additional metadata**

In such cases, mapping directly to a fixed DTO may not work. We need a more flexible way to process **semi-structured** or **dynamic JSON**, often using `Map`, `JsonNode`, or other raw representations.

<table data-header-hidden><thead><tr><th width="312.40283203125"></th><th></th></tr></thead><tbody><tr><td><strong>Use Case</strong></td><td><strong>Why Dynamic</strong></td></tr><tr><td>Webhook payloads</td><td>Fields can vary between events</td></tr><tr><td>External third-party APIs</td><td>Schema may not be fixed or may include nested data</td></tr><tr><td>Feature-flag responses or config APIs</td><td>Keys are often dynamic or environment-based</td></tr><tr><td>Error or metadata responses</td><td>Varying shape of error payloads</td></tr><tr><td>Analytics or audit streams</td><td>Fields evolve over time</td></tr></tbody></table>

#### **Approach 1: Using `Map<String, Object>`**

This is the most direct approach to capturing the entire JSON response as a `Map`.

```java
ResponseEntity<Map> response = restTemplate.getForEntity(
    "https://api.example.com/metadata",
    Map.class
);

Map<String, Object> result = response.getBody();
```

* **Pros:** Straightforward; handles flat or nested dynamic keys.
* **Cons:** Type-safety is lost; casting required for deeper levels.

#### **Nested Access Example**

```java
String version = (String) ((Map<String, Object>) result.get("app")).get("version");
```

#### **Approach 2: Using `JsonNode` (Jackson Tree Model)**

Jackson's `JsonNode` allows for powerful navigation and inspection of arbitrary JSON.

```java
ResponseEntity<JsonNode> response = restTemplate.exchange(
    "https://api.example.com/data",
    HttpMethod.GET,
    null,
    JsonNode.class
);

JsonNode root = response.getBody();
String status = root.path("status").asText();
JsonNode details = root.path("details");
```

* **Pros:**
  * Non-breaking even when keys are missing.
  * Cleaner navigation and transformation.
* **Cons:** Requires familiarity with `JsonNode` API.



## Status Code Checks

When integrating with external systems or microservices, handling HTTP **status codes** correctly is a critical part of response handling. RestTemplate provides multiple ways to inspect and react to HTTP status codes — whether to retry, log, fail-fast, or switch business logic paths.

#### **Approach 1: Using `ResponseEntity`**

We can access the status code from the `ResponseEntity` object.

```java
ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

if (response.getStatusCode().is2xxSuccessful()) {
    // Process response
} else if (response.getStatusCode().is4xxClientError()) {
    // Log and handle client-side error
} else if (response.getStatusCode().is5xxServerError()) {
    // Retry or fallback
}
```

#### **Example with switch-style logic**

```java
HttpStatus status = response.getStatusCode();

switch (status) {
    case OK:
        // Proceed
        break;
    case NOT_FOUND:
        throw new ResourceNotFoundException();
    case BAD_REQUEST:
        log.warn("Validation error occurred");
        break;
    default:
        throw new ServiceIntegrationException("Unexpected status: " + status);
}
```

#### **Approach 2: Custom `ResponseErrorHandler`**

For centralizing status code handling logic, we can create and register a custom error handler.

```java
public class CustomResponseErrorHandler implements ResponseErrorHandler {
    @Override
    public boolean hasError(ClientHttpResponse response) throws IOException {
        return (
            response.getStatusCode().series() == HttpStatus.Series.CLIENT_ERROR ||
            response.getStatusCode().series() == HttpStatus.Series.SERVER_ERROR
        );
    }

    @Override
    public void handleError(ClientHttpResponse response) throws IOException {
        // Custom logic based on status code
        HttpStatus statusCode = response.getStatusCode();
        if (statusCode == HttpStatus.NOT_FOUND) {
            throw new NotFoundException("Resource not found");
        } else if (statusCode == HttpStatus.UNAUTHORIZED) {
            throw new AuthenticationException("Unauthorized");
        } else {
            throw new GeneralServiceException("Unexpected error: " + statusCode);
        }
    }
}
```

#### **Register it with RestTemplate**

```java
restTemplate.setErrorHandler(new CustomResponseErrorHandler());
```



## Extracting & Logging Response Headers

HTTP headers play a vital role in metadata exchange between services — including correlation IDs, content types, rate-limiting info, cache controls, and authentication details. When using `RestTemplate`, it is common in production systems to **extract headers** for logging, diagnostics, tracing, or making conditional decisions.

#### **Accessing Headers with `ResponseEntity`**

The most straightforward way is via `ResponseEntity.getHeaders()`:

```java
ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
HttpHeaders headers = response.getHeaders();
```

```java
String requestId = headers.getFirst("X-Request-ID");
String contentType = headers.getContentType() != null ? headers.getContentType().toString() : "unknown";

logger.info("Received response: X-Request-ID={}, Content-Type={}", requestId, contentType);
```

#### **Iterating Over All Headers**

In enterprise applications, it’s often useful to log or analyze all response headers.

```java
headers.forEach((key, values) -> {
    values.forEach(value -> logger.debug("Header {}: {}", key, value));
});
```

#### **Example: Handling Rate Limit Headers**

Some APIs send rate-limiting metadata in headers:

```java
String remaining = headers.getFirst("X-RateLimit-Remaining");
String resetTime = headers.getFirst("X-RateLimit-Reset");

if (remaining != null && Integer.parseInt(remaining) < 10) {
    logger.warn("Approaching rate limit. Remaining calls: {}", remaining);
}
```

#### **Accessing Headers in POST, PUT, DELETE Requests**

Even when using methods like `postForEntity` or `exchange`, we can still access headers:

```java
ResponseEntity<MyResponse> response = restTemplate.exchange(
    url,
    HttpMethod.POST,
    new HttpEntity<>(payload),
    MyResponse.class
);

HttpHeaders headers = response.getHeaders();
String apiVersion = headers.getFirst("X-API-Version");
```

#### **Structured Header Logging**

Enterprise services often use **structured logs** for better filtering and correlation. Here's how we would build a structured logging message:

```java
Map<String, String> logHeaders = new HashMap<>();
headers.forEach((key, values) -> logHeaders.put(key, String.join(",", values)));

logger.info("External API response headers: {}", logHeaders);
```



## Handling Empty Responses

In real-world service integrations, it is common for REST APIs to return responses with **no body** — either because:

* The operation was successful but doesn’t return data (e.g., `DELETE`, `PUT`, `204 No Content`)
* The response is dynamically constructed and might sometimes be empty (e.g., optional search results)
* The downstream service failed silently or intentionally suppressed the payload

If not handled carefully, these **empty responses can lead to `NullPointerException`, `HttpMessageNotReadableException`, or deserialization failures**, especially when using generic or POJO-based deserialization.

#### **Typical HTTP Scenarios**

<table data-header-hidden><thead><tr><th width="162.1380615234375"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>HTTP Status</strong></td><td><strong>Description</strong></td><td><strong>Behavior</strong></td></tr><tr><td><code>200 OK</code></td><td>May contain an empty body</td><td>Safe to check for null or empty</td></tr><tr><td><code>204 No Content</code></td><td>No content expected</td><td>Response body will be null</td></tr><tr><td><code>404 Not Found</code></td><td>Often no body returned</td><td>Should handle gracefully if optional</td></tr><tr><td><code>500</code>/<code>503</code></td><td>Error response, possibly empty</td><td>Fallback or error handling needed</td></tr></tbody></table>

#### **Handling with `ResponseEntity`**

```java
ResponseEntity<MyResponse> response = restTemplate.exchange(
    url,
    HttpMethod.GET,
    null,
    MyResponse.class
);

if (response.getStatusCode() == HttpStatus.NO_CONTENT || response.getBody() == null) {
    logger.info("No content returned from API");
    return Optional.empty();
}

return Optional.of(response.getBody());
```

#### **Handling with `String.class` to Safely Inspect Body**

```java
ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

if (response.getBody() == null || response.getBody().isBlank()) {
    logger.warn("Empty response body from downstream");
    return;
}

logger.info("Raw response: {}", response.getBody());
```

This approach is useful when:

* The response format is dynamic or loosely typed
* We want to inspect or log the raw body before parsing

#### **Using `ParameterizedTypeReference` with Exchange**

When using generics (e.g., `List<MyType>`), ensure safe parsing by checking body before access:

```java
ResponseEntity<List<MyType>> response = restTemplate.exchange(
    url,
    HttpMethod.GET,
    null,
    new ParameterizedTypeReference<List<MyType>>() {}
);

List<MyType> result = response.getBody() != null ? response.getBody() : Collections.emptyList();
```

#### **Avoiding `HttpMessageNotReadableException`**

Sometimes, `RestTemplate` may try to parse an empty body into a class and fail.

To prevent this:

#### Option 1: Use `String.class` and parse only if not empty

```java
ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
if (StringUtils.hasText(response.getBody())) {
    MyResponse obj = objectMapper.readValue(response.getBody(), MyResponse.class);
}
```

#### Option 2: Catch parsing exceptions

```java
try {
    ResponseEntity<MyResponse> response = restTemplate.getForEntity(url, MyResponse.class);
    return Optional.ofNullable(response.getBody());
} catch (HttpMessageNotReadableException ex) {
    logger.warn("Empty or unreadable response received", ex);
    return Optional.empty();
}
```



## Centralized Response Handling Using Utility

In large-scale Spring applications, interactions with external APIs are widespread across various services. Managing response deserialization, error handling, status code verification, and empty responses individually can lead to duplicated logic and inconsistent behavior.

A **centralized response handling utility** abstracts this logic in a reusable, maintainable, and testable manner.

#### **Basic Utility Design**

Step 1: Generic Response Mapper

```java
public class RestTemplateResponseHandler {

    private final ObjectMapper objectMapper;

    public RestTemplateResponseHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }

    public <T> Optional<T> handleResponse(ResponseEntity<String> response, Class<T> targetType) {
        if (response.getStatusCode().is2xxSuccessful() && StringUtils.hasText(response.getBody())) {
            try {
                return Optional.of(objectMapper.readValue(response.getBody(), targetType));
            } catch (JsonProcessingException e) {
                throw new RuntimeException("Failed to parse response", e);
            }
        }

        return Optional.empty();
    }
}
```

Step 2: Generic Utility with Status Code Checks

```java
public class RestResponseUtil {

    public static <T> T extract(ResponseEntity<T> response) {
        HttpStatus status = response.getStatusCode();

        if (status.is2xxSuccessful()) {
            T body = response.getBody();
            if (body != null) {
                return body;
            }
            throw new ResponseParsingException("Expected non-null response body");
        }

        throw new DownstreamException("Non-2xx status: " + status);
    }
}
```

Step 3: Example Usage in Service Layer

```java
public UserProfile getProfile(String userId) {
    ResponseEntity<UserProfile> response = restTemplate.getForEntity(PROFILE_API + "/" + userId, UserProfile.class);
    return RestResponseUtil.extract(response);
}
```

#### **Variation for Optional Use Cases**

```java
public static <T> Optional<T> extractOptional(ResponseEntity<T> response) {
    if (response.getStatusCode() == HttpStatus.NO_CONTENT || response.getBody() == null) {
        return Optional.empty();
    }

    if (response.getStatusCode().is2xxSuccessful()) {
        return Optional.of(response.getBody());
    }

    throw new DownstreamException("Unexpected HTTP Status: " + response.getStatusCode());
}
```

#### **Example Use: Optional Behavior**

```java
public Optional<UserProfile> fetchProfile(String userId) {
    ResponseEntity<UserProfile> response = restTemplate.getForEntity(PROFILE_API + "/" + userId, UserProfile.class);
    return RestResponseUtil.extractOptional(response);
}
```

## Deserializing Nested Responses

In real-world APIs, responses are often **wrapped** or **nested**, meaning the actual business data is embedded within a larger structure containing metadata, status codes, pagination info, or wrapper fields.

Instead of directly mapping to domain objects, we must **first extract** the inner content — and this requires custom deserialization logic or wrapper types.

#### **Common Real-World API Pattern**

Many APIs return data in the following shape:

```json
{
  "status": "SUCCESS",
  "code": 200,
  "data": {
    "id": "123",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

Here, our domain object is just the `"data"` part.

#### **Approach 1: Wrapper POJO Mapping**

Step 1: Define a Generic Wrapper

```java
public class ApiResponse<T> {
    private String status;
    private int code;
    private T data;

    // getters and setters
}
```

Step 2: Define Domain Object

```java
public class User {
    private String id;
    private String name;
    private String email;

    // getters and setters
}
```

Step 3: Parameterized Type Reference

```java
ResponseEntity<ApiResponse<User>> response = restTemplate.exchange(
    apiUrl,
    HttpMethod.GET,
    null,
    new ParameterizedTypeReference<ApiResponse<User>>() {}
);
User user = response.getBody().getData();
```

#### **Approach 2: Deserialize Using `ObjectMapper` and Extract Inner Field**

When type inference is complex, use `JsonNode` or manual extraction:

```java
ResponseEntity<String> response = restTemplate.getForEntity(apiUrl, String.class);
JsonNode root = objectMapper.readTree(response.getBody());
JsonNode dataNode = root.path("data");
User user = objectMapper.treeToValue(dataNode, User.class);
```

#### **Handling Lists in Nested Structure**

```json
{
  "status": "SUCCESS",
  "code": 200,
  "data": [
    { "id": "1", "name": "Alice" },
    { "id": "2", "name": "Bob" }
  ]
}
```

#### With Generic Wrapper

```java
public class ApiResponseList<T> {
    private String status;
    private int code;
    private List<T> data;

    // getters and setters
}

ResponseEntity<ApiResponseList<User>> response = restTemplate.exchange(
    apiUrl,
    HttpMethod.GET,
    null,
    new ParameterizedTypeReference<ApiResponseList<User>>() {}
);
List<User> users = response.getBody().getData();
```

#### **Advanced Use Case: Pagination with Metadata**

```json
{
  "status": "SUCCESS",
  "data": {
    "items": [ {...}, {...} ],
    "pagination": {
      "page": 1,
      "total": 5
    }
  }
}
```

POJO Structure

```java
public class Pagination {
    private int page;
    private int total;
}

public class PagedData<T> {
    private List<T> items;
    private Pagination pagination;
}

public class ApiResponse<T> {
    private String status;
    private T data;
}
```

Then:

```java
ResponseEntity<ApiResponse<PagedData<User>>> response = restTemplate.exchange(
    apiUrl,
    HttpMethod.GET,
    null,
    new ParameterizedTypeReference<ApiResponse<PagedData<User>>>() {}
);

List<User> users = response.getBody().getData().getItems();
```
