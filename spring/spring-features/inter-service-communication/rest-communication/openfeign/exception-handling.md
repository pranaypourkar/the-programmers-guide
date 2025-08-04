# Exception Handling

## About

In microservices or any distributed systems, remote API calls are inherently unreliable due to:

* Network latency or timeouts
* API version mismatches
* Temporary service outages
* Unauthorized or invalid requests
* Resource not found (e.g., user doesn’t exist)

Instead of letting these issues break our application flow, proper exception handling helps us:

* Provide **informative responses to clients**
* Avoid **cascading failures**
* Enable **automated fallbacks**
* **Log and trace** failures for observability
* Enforce **clean separation of concerns** between service call logic and failure behavior

## **How OpenFeign Handles Exceptions ?**

OpenFeign does not throw `HttpClientErrorException` or `HttpServerErrorException` like `RestTemplate`. Instead:

* It throws **`FeignException`**, a base class for all client errors.
* Subtypes like `FeignException.NotFound`, `FeignException.BadRequest` represent specific HTTP statuses.
* The exception **encapsulates the raw response**, status code, and response body which we can inspect or log.

## **1. Client-Side I/O Exceptions (Request-Time Errors)** <a href="#id-1.-client-side-i-o-exceptions-request-time-errors" id="id-1.-client-side-i-o-exceptions-request-time-errors"></a>

These exceptions happen **before** the HTTP request even reaches the server. They usually indicate a problem in the **request pipeline** itself, such as:

* Network unreachable (e.g., DNS resolution fails, host unreachable)
* Timeout while establishing a connection
* TLS handshake failure
* Serialization error while preparing the request body
* Connection reset by peer

These are different from typical **HTTP response errors** (like 404 or 500), because **no HTTP response is returned**.

#### **How Does OpenFeign Represent These ?**

When such exceptions occur:

* OpenFeign throws **`FeignException`** or wraps lower-level exceptions (e.g., `IOException`, `SocketTimeoutException`) as **`RetryableException`** or raw `RuntimeException`.

In Spring Cloud OpenFeign, we can intercept these exceptions in:

* A **global `@ControllerAdvice`**
* A **custom Feign `ErrorDecoder`** if Feign tries to wrap it
* A **fallback method** if configured

#### **Example: Handling I/O Failures in a Safe Way**

Let’s say a downstream service is unavailable, and the client fails at request time.

Feign Client Definition

```java
@FeignClient(name = "account-client", url = "http://unreachable-service", fallback = AccountClientFallback.class)
public interface AccountClient {
    @GetMapping("/api/accounts/{id}")
    Account getAccountById(@PathVariable("id") Long id);
}
```

Fallback Implementation

```java
@Component
public class AccountClientFallback implements AccountClient {

    @Override
    public Account getAccountById(Long id) {
        // Return safe default or log fallback
        System.out.println("Fallback triggered due to client-side failure.");
        return null;
    }
}
```

This will catch I/O-level failures and prevent the caller from crashing.

Catching Low-Level Exceptions (Manually)

If we want full control and **don’t use a fallback**, catch `FeignException` or nested `IOException`:

```java
@Autowired
private AccountClient accountClient;

public Account fetchAccount(Long id) {
    try {
        return accountClient.getAccountById(id);
    } catch (FeignException e) {
        System.err.println("FeignException occurred: " + e.getMessage());
        throw new ServiceUnavailableException("Account service unreachable.");
    } catch (Exception e) {
        System.err.println("Unknown error: " + e.getMessage());
        throw new RuntimeException("Unexpected failure");
    }
}
```

#### **Better: Custom ErrorDecoder with Logging**

Even request-time failures can be caught in a custom decoder:

```java
@Configuration
public class FeignClientConfiguration {
    @Bean
    public ErrorDecoder errorDecoder() {
        return (methodKey, response) -> {
            // Can log or transform known issues
            return FeignException.errorStatus(methodKey, response);
        };
    }
}
```

#### **Detecting Request-Time vs Response-Time Failures**

To **detect request-time I/O errors**, we can configure Feign to use a `Retryer` or add a custom interceptor and logger.

```java
@Slf4j
public class CustomLogger extends feign.Logger {
    @Override
    protected void log(String configKey, String format, Object... args) {
        log.info(String.format(methodTag(configKey) + format, args));
    }

    @Override
    protected void logIOException(String configKey, IOException ioe, long elapsedTime) {
        log.error("Request failed: " + methodTag(configKey), ioe);
    }
}
```

## **2. Server Response Exceptions (Non-2xx Responses)** <a href="#id-2.-server-response-exceptions-non-2xx-responses" id="id-2.-server-response-exceptions-non-2xx-responses"></a>

These occur when the request **successfully reaches the server**, but the server returns a **non-2xx HTTP status code**, such as:

* `404 Not Found`
* `400 Bad Request`
* `401 Unauthorized`
* `500 Internal Server Error`

These aren't client-side I/O errors they represent a valid HTTP response indicating **server-side rejection or failure**.

#### **How OpenFeign Handles Them ?**

OpenFeign by default **throws a `FeignException`** (a subclass of `RuntimeException`) when the server returns a non-successful HTTP status.

We can handle these exceptions by:

* Catching `FeignException` in our business code
* Defining a **custom `ErrorDecoder`**
* Using **fallbacks with `@FeignClient(fallback = …)`**

#### **Exception Type Mapping in Feign**

| HTTP Status | Feign Exception Class        |
| ----------- | ---------------------------- |
| 4xx         | `FeignException.ClientError` |
| 5xx         | `FeignException.ServerError` |
| Other       | `FeignException`             |

#### **Example: Basic Feign Client**

**Feign Client Interface**

```java
@FeignClient(name = "payment-client", url = "http://payment-service", configuration = FeignConfig.class)
public interface PaymentClient {
    @GetMapping("/api/payments/{id}")
    Payment getPayment(@PathVariable("id") Long id);
}
```

#### **Calling the Client and Handling Server Errors**

```java
@Service
public class PaymentService {

    @Autowired
    private PaymentClient paymentClient;

    public Payment fetchPayment(Long id) {
        try {
            return paymentClient.getPayment(id);
        } catch (FeignException.NotFound e) {
            throw new PaymentNotFoundException("Payment not found for id: " + id);
        } catch (FeignException.BadRequest e) {
            throw new InvalidRequestException("Invalid payment request");
        } catch (FeignException e) {
            throw new RuntimeException("Payment service returned error: " + e.status());
        }
    }
}
```

#### **Custom ErrorDecoder to Handle Server Responses Gracefully**

Instead of handling exceptions everywhere, define a central place to decode them.

```java
@Configuration
public class FeignConfig {

    @Bean
    public ErrorDecoder errorDecoder() {
        return new CustomErrorDecoder();
    }
}
```

```java
public class CustomErrorDecoder implements ErrorDecoder {

    private final ErrorDecoder defaultDecoder = new Default();

    @Override
    public Exception decode(String methodKey, Response response) {
        switch (response.status()) {
            case 404:
                return new ResourceNotFoundException("Resource not found");
            case 400:
                return new BadRequestException("Invalid input");
            case 500:
                return new ServiceUnavailableException("Internal server error");
            default:
                return defaultDecoder.decode(methodKey, response);
        }
    }
}
```

#### **Fallback Option: Safe Fallback for Errors**

```java
@Component
public class PaymentClientFallback implements PaymentClient {
    @Override
    public Payment getPayment(Long id) {
        System.out.println("Fallback: could not fetch payment for id " + id);
        return null;
    }
}
```

## **3. Deserialization and Response Mapping Errors** <a href="#id-3.-deserialization-and-response-mapping-errors" id="id-3.-deserialization-and-response-mapping-errors"></a>

Deserialization errors occur **after a successful HTTP response** (i.e., a 2xx status), but when Feign tries to **convert the JSON/XML body into a Java object (POJO)** and fails.

These are **runtime exceptions** and common reasons include:

* Mismatched or missing fields in the POJO
* Incorrect data types (e.g., expecting `int` but receiving a string)
* Invalid or unexpected response structure
* Jackson misconfiguration

#### **How Feign Handles Deserialization ?**

Feign uses **Jackson (via Spring Cloud OpenFeign)** by default to deserialize the HTTP response into a Java object. If deserialization fails, it throws:

```java
com.fasterxml.jackson.databind.JsonMappingException
```

or

```java
com.fasterxml.jackson.core.JsonParseException
```

These typically bubble up as:

```java
feign.FeignException$InternalServerError: status 500 reading …
Caused by: com.fasterxml.jackson.databind.exc.MismatchedInputException
```

#### **Example Scenario**

Feign Client

```java
@FeignClient(name = "account-client", url = "http://account-service")
public interface AccountClient {
    @GetMapping("/api/accounts/{id}")
    Account getAccount(@PathVariable("id") Long id);
}
```

Account POJO (Incorrect)

```java
public class Account {
    private Long id;
    private String userName; // This might be "username" in JSON
    private String balance;
}
```

JSON Response

```json
{
  "id": 101,
  "username": "john_doe",
  "balance": 1200.50
}
```

Here, deserialization will fail because Jackson looks for `userName`, but the JSON has `username`.

#### **How to Fix / Prevent**

1\. Match Field Names Exactly

Use `@JsonProperty` if field names differ.

```java
import com.fasterxml.jackson.annotation.JsonProperty;

public class Account {
    private Long id;

    @JsonProperty("username")
    private String userName;

    private double balance;
}
```

2\. Enable Logging for Debugging

```yaml
logging:
  level:
    com.example.client: DEBUG
    feign: DEBUG
```

#### **Catching Deserialization Errors Globally**

Wrap our call in a try-catch and catch mapping exceptions:

```java
public Account fetchAccount(Long id) {
    try {
        return accountClient.getAccount(id);
    } catch (FeignException e) {
        throw new RuntimeException("Feign exception: " + e.status());
    } catch (JsonProcessingException | IllegalArgumentException e) {
        throw new DataFormatException("Deserialization failed: " + e.getMessage(), e);
    }
}
```

Note: Jackson exceptions might get wrapped inside Feign or not be thrown directly, so sometimes using a fallback or decoding error body helps.

#### **Using a Custom Decoder**

Override Jackson decoder for finer control:

```java
@Configuration
public class FeignConfig {
    @Bean
    public Decoder feignDecoder() {
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        return new JacksonDecoder(mapper);
    }
}
```



