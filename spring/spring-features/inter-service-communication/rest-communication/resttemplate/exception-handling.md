# Exception Handling

## About

Exception handling in `RestTemplate` is crucial to ensure robust communication between services, especially in distributed systems where network failures, downstream service issues, or unexpected responses are common.

Spring’s `RestTemplate` throws runtime exceptions (unchecked) to notify the developer when an error occurs during HTTP interaction. By default, Spring uses the `DefaultResponseErrorHandler` which throws exceptions for non-2xx status codes.

Without proper handling, errors like timeouts, 404s, or 500s can crash our service or cause undefined behavior. That’s why it's essential to implement systematic exception handling that can recover gracefully, log appropriately, and surface actionable information.

## **Types of Exceptions Thrown by RestTemplate**

<table data-header-hidden data-full-width="true"><thead><tr><th width="302.7569580078125"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Exception Type</strong></td><td><strong>Description</strong></td><td><strong>Typical Scenario</strong></td></tr><tr><td><code>HttpClientErrorException</code></td><td>Thrown for HTTP status codes in the 4xx range.</td><td>404 Not Found, 400 Bad Request, 401 Unauthorized</td></tr><tr><td><code>HttpServerErrorException</code></td><td>Thrown for 5xx errors from the server.</td><td>500 Internal Server Error, 503 Service Unavailable</td></tr><tr><td><code>ResourceAccessException</code></td><td>Thrown when connection errors occur — DNS issue, timeout, no network.</td><td>Network unreachable, service down</td></tr><tr><td><code>UnknownHttpStatusCodeException</code></td><td>Thrown for unrecognized or custom status codes not part of standard HTTP.</td><td>Non-standard HTTP response codes</td></tr><tr><td><code>RestClientException</code> (base class)</td><td>Base class for all RestTemplate client exceptions.</td><td>Catch-all for unknown/unexpected errors</td></tr></tbody></table>

## **Default Behavior (DefaultResponseErrorHandler)**

By default, Spring's `RestTemplate` uses `DefaultResponseErrorHandler`, which:

* **Throws** exceptions on all 4xx and 5xx HTTP responses.
* **Does not** throw exceptions on 2xx or 3xx responses.
* **Does not** handle the error body unless parsed manually.

## Handling Exception

#### Wrap `RestTemplate` calls in try-catch blocks

This is the most basic but explicit form of exception handling. We surround our `RestTemplate` calls with try-catch blocks where each catch clause targets a specific category of exceptions such as client errors (4xx), server errors (5xx), or connection timeouts.

```java
public User fetchUser(String userId) {
    try {
        ResponseEntity<User> response = restTemplate.getForEntity(
            "https://user-service/api/users/" + userId, User.class);
        return response.getBody();
    } catch (HttpClientErrorException.NotFound ex) {
        // Handle 404 gracefully
        throw new UserNotFoundException(userId);
    } catch (HttpServerErrorException ex) {
        // Retry logic or circuit-breaker fallback can go here
        log.error("Downstream service error: {}", ex.getStatusCode());
        throw new ExternalServiceException("User service unavailable");
    } catch (ResourceAccessException ex) {
        // Timeout or DNS failure
        log.warn("Network issue while calling user service: {}", ex.getMessage());
        throw new NetworkFailureException("Connection to user service failed");
    } catch (RestClientException ex) {
        // Catch-all
        log.error("Unexpected RestTemplate exception: {}", ex.getMessage(), ex);
        throw new InternalIntegrationException("Unexpected error communicating with user service");
    }
}
```

#### Centralize Handling Using a Utility/Adapter Layer

Instead of littering try-catch blocks across the codebase, enterprises abstract RestTemplate logic into a shared `HttpClientHelper`, `RestTemplateAdapter`, or `HttpIntegrationService`. This class wraps all RestTemplate interactions and handles common concerns like retries, error transformation, timeouts, logging, and telemetry.

```java
@Component
public class RestClientAdapter {

    private final RestTemplate restTemplate;

    public RestClientAdapter(RestTemplateBuilder builder) {
        this.restTemplate = builder.build();
    }

    public <T> T get(String url, Class<T> responseType) {
        try {
            return restTemplate.getForObject(url, responseType);
        } catch (HttpStatusCodeException ex) {
            String body = ex.getResponseBodyAsString();
            log.error("HTTP error from [{}]: {}", url, body);
            throw new DownstreamHttpException(ex.getStatusCode(), body);
        } catch (ResourceAccessException ex) {
            log.error("Timeout or connection error while accessing [{}]: {}", url, ex.getMessage());
            throw new NetworkIntegrationException(url, ex);
        } catch (RestClientException ex) {
            log.error("Unexpected error during HTTP call to [{}]: {}", url, ex.getMessage());
            throw new InternalIntegrationException("Unknown RestTemplate error", ex);
        }
    }
}
```

```java
User user = restClientAdapter.get("http://user-service/api/users/" + userId, User.class);
```

#### Use `ResponseErrorHandler` for Global Error Handling

Spring's `RestTemplate` allows us to plug in a custom `ResponseErrorHandler` that can intercept and process HTTP errors **globally** before they reach our business logic. This means we don’t need to handle `HttpStatusCodeException` manually every time.

```java
public class CustomRestTemplateErrorHandler implements ResponseErrorHandler {

    @Override
    public boolean hasError(ClientHttpResponse response) throws IOException {
        return response.getStatusCode().is4xxClientError() ||
               response.getStatusCode().is5xxServerError();
    }

    @Override
    public void handleError(ClientHttpResponse response) throws IOException {
        HttpStatus statusCode = response.getStatusCode();
        String body = new String(response.getBody().readAllBytes(), StandardCharsets.UTF_8);

        if (statusCode.is4xxClientError()) {
            if (statusCode == HttpStatus.NOT_FOUND) {
                throw new NotFoundException("Resource not found");
            }
            throw new ClientErrorException(statusCode, body);
        } else if (statusCode.is5xxServerError()) {
            throw new ServerErrorException(statusCode, body);
        }
    }
}
```

**Registering the Handler**

```java
@Bean
public RestTemplate restTemplate(RestTemplateBuilder builder) {
    return builder
        .errorHandler(new CustomRestTemplateErrorHandler())
        .build();
}
```



## **Handling Deserialization Errors**

When using `RestTemplate`, after a successful HTTP response (e.g., 200 OK), the response body is typically converted (deserialized) into a Java object using **Jackson** (or another configured message converter). If the response payload doesn't match the expected Java structure, deserialization fails, usually throwing a `HttpMessageConversionException` (like `JsonMappingException`, `MismatchedInputException`, etc.).

These errors are **runtime failures** and not caught by the usual `ResponseErrorHandler`, since they occur **after the response is successfully received**, but **before the result is returned to the caller**.

#### **Strategies to Handle Deserialization Errors**

#### **1. Wrap RestTemplate Calls and Catch Jackson Exceptions**

This is the first line of defense. Deserialization errors can be caught and handled using `try-catch`.

```java
try {
    ResponseEntity<UserDto> response = restTemplate.exchange(
        url, HttpMethod.GET, null, UserDto.class);
    return response.getBody();
} catch (HttpMessageConversionException ex) {
    log.error("Deserialization error from URL [{}]: {}", url, ex.getMessage());
    throw new InvalidDownstreamPayloadException("Malformed JSON received", ex);
}
```

**Key Exceptions to Catch**

<table data-full-width="true"><thead><tr><th width="301.84283447265625">Exception</th><th>Description</th></tr></thead><tbody><tr><td><code>HttpMessageNotReadableException</code></td><td>Thrown when the response body can’t be parsed (e.g., bad JSON)</td></tr><tr><td><code>JsonMappingException</code></td><td>Thrown by Jackson when structure mismatches (e.g., missing fields, type errors)</td></tr><tr><td><code>MismatchedInputException</code></td><td>Specific Jackson subtype when input doesn’t match target type</td></tr></tbody></table>

#### **2. Define Resilient DTOs**

To make DTOs less sensitive to upstream changes:

* **Mark all fields as optional** using `@JsonInclude(JsonInclude.Include.NON_NULL)`
* Use `@JsonIgnoreProperties(ignoreUnknown = true)` on class level
* Avoid using primitives (`int`, `boolean`) if the fields are optional
* Consider using `@JsonProperty(required = false)` if necessary

```java
@JsonIgnoreProperties(ignoreUnknown = true)
public class UserDto {
    private String id;
    private String name;
    private Integer age; // Avoid primitive int
}
```

#### **3. Log the Raw Response on Failure**

Logging the raw JSON response helps debugging deserialization issues.

```java
catch (HttpMessageConversionException ex) {
    log.error("Deserialization failed. Response body: {}", rawJson, ex);
}
```

We can read raw response manually if needed:

```java
ResponseEntity<String> rawResponse = restTemplate.getForEntity(url, String.class);
String json = rawResponse.getBody();

try {
    UserDto user = objectMapper.readValue(json, UserDto.class);
} catch (JsonProcessingException ex) {
    log.error("JSON parse error: {}", json, ex);
    throw new InvalidDownstreamPayloadException("Deserialization failed", ex);
}
```

This technique is also useful when the response is partially malformed but salvageable.

#### **4. Implement Custom Error-Resilient Deserializer**

For advanced cases, we can write custom Jackson deserializers:

```java
public class LenientUserDeserializer extends JsonDeserializer<UserDto> {
    @Override
    public UserDto deserialize(JsonParser jp, DeserializationContext ctxt)
        throws IOException {
        JsonNode node = jp.getCodec().readTree(jp);
        UserDto user = new UserDto();
        user.setId(node.path("id").asText(null));
        user.setName(node.path("name").asText(null));
        // Add default or fallback if missing
        user.setAge(node.path("age").isMissingNode() ? 0 : node.path("age").asInt());
        return user;
    }
}
```

Then register it:

```java
@JsonDeserialize(using = LenientUserDeserializer.class)
public class UserDto { ... }
```

#### **5. Fallback Strategy: Fallback DTO or Raw Map**

If payloads are highly dynamic or not fully trusted:

```java
ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
    url, HttpMethod.GET, null,
    new ParameterizedTypeReference<Map<String, Object>>() {});
```

This allows inspection of the payload without schema enforcement. We can then map it to DTO manually or partially.
