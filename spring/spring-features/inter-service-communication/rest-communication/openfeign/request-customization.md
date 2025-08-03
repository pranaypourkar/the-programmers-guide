# Request Customization

## About

OpenFeign supports **extensive request customization** without cluttering our service code. It allows setting custom headers, request parameters, query/path variables, cookies, interceptors, encoders, and more all declaratively or through configuration.

This is essential in enterprise environments where calls may require authentication tokens, dynamic headers, correlation IDs, or different content types per endpoint.

## HTTP Methods <a href="#http-methods" id="http-methods"></a>

OpenFeign supports standard HTTP methods through annotated Java interfaces. Each method maps to a specific REST operation and can be configured with URI templates, query parameters, headers, and request bodies.

#### **Supported HTTP Methods**

<table data-full-width="true"><thead><tr><th width="144.046875">HTTP Method</th><th width="166.28515625">Feign Annotation</th><th width="160.12109375">Typical Use Case</th><th width="132.26953125">Supports Body</th><th>Example Signature</th></tr></thead><tbody><tr><td>GET</td><td><code>@GetMapping</code> / <code>@RequestMapping(method = GET)</code></td><td>Read-only operations (e.g., fetch user, list items)</td><td>No</td><td><code>@GetMapping("/users/{id}") UserDto getUser(@PathVariable("id") String id);</code></td></tr><tr><td>POST</td><td><code>@PostMapping</code></td><td>Create resources, form submissions</td><td>Yes</td><td><code>@PostMapping("/payments") PaymentResponse create(@RequestBody PaymentRequest r);</code></td></tr><tr><td>PUT</td><td><code>@PutMapping</code></td><td>Full update of existing resource</td><td>Yes</td><td><code>@PutMapping("/accounts/{id}") AccountDto update(@PathVariable String id, @RequestBody AccountDto dto);</code></td></tr><tr><td>PATCH</td><td><code>@PatchMapping</code></td><td>Partial updates</td><td>Yes</td><td><code>@PatchMapping("/orders/{id}") OrderDto patch(@PathVariable String id, @RequestBody OrderPatch patch);</code></td></tr><tr><td>DELETE</td><td><code>@DeleteMapping</code></td><td>Delete a resource</td><td>No (usually)</td><td><code>@DeleteMapping("/users/{id}") void deleteUser(@PathVariable("id") String id);</code></td></tr><tr><td>HEAD</td><td><code>@RequestMapping(method = HEAD)</code></td><td>Retrieve headers or metadata only</td><td>No</td><td><code>@RequestMapping(value = "/files/{id}", method = RequestMethod.HEAD) ResponseEntity&#x3C;?> checkFile(@PathVariable String id);</code></td></tr><tr><td>OPTIONS</td><td><code>@RequestMapping(method = OPTIONS)</code></td><td>Discover allowed methods on resource</td><td>No</td><td><code>@RequestMapping(value = "/files", method = RequestMethod.OPTIONS) ResponseEntity&#x3C;?> options();</code></td></tr></tbody></table>

#### **Example: Using All Methods in One Interface**

```java
@FeignClient(name = "user-service")
public interface UserClient {

    @GetMapping("/users/{id}")
    UserDto getUser(@PathVariable("id") String id);

    @PostMapping("/users")
    UserDto createUser(@RequestBody CreateUserRequest request);

    @PutMapping("/users/{id}")
    UserDto updateUser(@PathVariable("id") String id, @RequestBody UpdateUserRequest request);

    @PatchMapping("/users/{id}")
    UserDto patchUser(@PathVariable("id") String id, @RequestBody PatchUserRequest patch);

    @DeleteMapping("/users/{id}")
    void deleteUser(@PathVariable("id") String id);

    @RequestMapping(value = "/users/{id}", method = RequestMethod.HEAD)
    ResponseEntity<Void> checkUserExists(@PathVariable("id") String id);

    @RequestMapping(value = "/users", method = RequestMethod.OPTIONS)
    ResponseEntity<?> getUserOptions();
}
```

## Setting Multiple Query Parameters <a href="#http-methods" id="http-methods"></a>

OpenFeign makes it straightforward to define multiple query parameters in method signatures. These parameters are automatically appended to the URL at runtime when the request is constructed.

This is commonly needed in search/filter/list endpoints where multiple filtering criteria, sorting options, pagination details, etc., are passed in the request.

#### **Ways to Set Multiple Query Parameters**

#### **1. Using `@RequestParam` for Each Parameter**

Best for fixed number of parameters.

```java
@FeignClient(name = "product-service")
public interface ProductClient {

    @GetMapping("/products")
    List<Product> getProducts(
        @RequestParam("category") String category,
        @RequestParam("sort") String sort,
        @RequestParam("limit") int limit,
        @RequestParam("offset") int offset
    );
}
```

Resulting URL

```
GET /products?category=electronics&sort=price&limit=10&offset=0
```

#### **2. Using a Map for Dynamic Query Parameters**

Useful when the number or names of query parameters vary at runtime.

```java
@FeignClient(name = "product-service")
public interface ProductClient {

    @GetMapping("/products")
    List<Product> getProducts(@RequestParam Map<String, String> queryParams);
}
```

Usage in Service Layer

```java
Map<String, String> filters = new HashMap<>();
filters.put("category", "electronics");
filters.put("brand", "sony");
filters.put("sort", "name");

List<Product> products = productClient.getProducts(filters);
```

Resulting URL

```
GET /products?category=electronics&brand=sony&sort=name
```

#### **3. Combining Fixed and Dynamic Parameters**

We can use both fixed and dynamic parameters together in the same method.

```java
@FeignClient(name = "search-service")
public interface SearchClient {

    @GetMapping("/search")
    List<Result> search(
        @RequestParam("query") String query,
        @RequestParam Map<String, String> filters
    );
}
```

```java
Map<String, String> extraFilters = new HashMap<>();
extraFilters.put("lang", "en");
extraFilters.put("type", "image");

List<Result> results = searchClient.search("dogs", extraFilters);
```

URL Example

```
GET /search?query=dogs&lang=en&type=image
```

## Setting Multiple Path Variables

In REST APIs, path variables represent dynamic segments in the URI — typically used for identifying specific resources (e.g., `/users/{userId}/orders/{orderId}`). OpenFeign supports this through method-level `@GetMapping` or other HTTP method annotations with `@PathVariable` parameters.

This is especially useful when we need to build RESTful clients that interact with resources based on hierarchical identifiers.

#### **Defining Multiple Path Variables**

#### **1. Using Named Placeholders with `@PathVariable`**

We must ensure

* The path in `@GetMapping` matches exactly with the placeholders in the method arguments.
* Each `@PathVariable` has a matching name (explicitly or implicitly).

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @GetMapping("/users/{userId}/orders/{orderId}")
    Order getOrderByUserAndId(
        @PathVariable("userId") String userId,
        @PathVariable("orderId") String orderId
    );
}
```

Resulting URL

```
GET /users/123/orders/456
```

#### **2. Omitting Parameter Names (if method parameter names are preserved)**

If our build tool preserves parameter names (e.g., via `-parameters` flag in the compiler), we can omit explicit names:

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @GetMapping("/users/{userId}/orders/{orderId}")
    Order getOrderByUserAndId(
        @PathVariable String userId,
        @PathVariable String orderId
    );
}
```

This approach works **only** if our build config includes:

```xml
<compilerArgs>
    <arg>-parameters</arg>
</compilerArgs>
```

#### **3. Combining Path and Query Parameters**

We can also combine path variables and query parameters easily:

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @GetMapping("/users/{userId}/orders/{orderId}")
    Order getOrderDetails(
        @PathVariable("userId") String userId,
        @PathVariable("orderId") String orderId,
        @RequestParam("includeItems") boolean includeItems
    );
}
```

Resulting URL

```
GET /users/123/orders/456?includeItems=true
```

## Setting Request Body

In OpenFeign, we can send a request body for methods like **POST**, **PUT**, or **PATCH** by using the `@RequestBody` annotation. The body is usually a serialized object (e.g., JSON) representing complex data such as forms, DTOs, or domain objects.

This is typically used for:

* Creating new resources
* Updating existing resources
* Passing structured payloads

#### **Example: POST Request with JSON Body**

```java
@FeignClient(name = "user-service")
public interface UserClient {

    @PostMapping("/users")
    User createUser(@RequestBody UserRequest request);
}
```

```java
public class UserRequest {
    private String name;
    private String email;
    // Getters and Setters
}
```

Calling the Client

```java
UserRequest request = new UserRequest("John", "john@example.com");
User created = userClient.createUser(request);
```

This will serialize the `UserRequest` object into a JSON body:

```json
{
  "name": "John",
  "email": "john@example.com"
}
```

## Setting Headers

Headers are a critical part of HTTP requests, conveying metadata such as:

* Authentication tokens
* Content types
* Custom app-level flags (e.g., correlation IDs)

OpenFeign offers multiple ways to set headers for requests:

1. Statically via annotations
2. Dynamically via request interceptors
3. Using `@RequestHeader` parameters in method signatures

#### **1. Static Headers with `@Headers`**

We can define static headers directly on the method using `@Headers` from `feign.Headers`.

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @Headers("Authorization: Bearer some-static-token")
    @GetMapping("/orders")
    List<Order> getOrders();
}
```

**Note:** Static headers are hardcoded and not suitable for dynamic tokens (e.g., JWTs).

#### **2. Dynamic Headers with `@RequestHeader`**

We can pass headers at runtime using method parameters.

```java
@FeignClient(name = "order-service")
public interface OrderClient {

    @GetMapping("/orders")
    List<Order> getOrders(@RequestHeader("Authorization") String authHeader);
}
```

```java
String token = "Bearer " + jwtProvider.getToken();
orderClient.getOrders(token);
```

This is useful for:

* Passing authentication headers per request
* Setting correlation IDs, tenant IDs, etc.

#### **3. Custom Header Injection via Request Interceptor**

For consistent headers across all requests (like JWTs or trace IDs), define a custom `RequestInterceptor`.

```java
@Configuration
public class FeignClientConfig {

    @Bean
    public RequestInterceptor requestInterceptor() {
        return requestTemplate -> {
            requestTemplate.header("Authorization", getAuthToken());
            requestTemplate.header("X-Correlation-ID", UUID.randomUUID().toString());
        };
    }

    private String getAuthToken() {
        return "Bearer " + tokenProvider.getAccessToken();
    }
}
```

Then attach it to our client:

```java
@FeignClient(name = "order-service", configuration = FeignClientConfig.class)
public interface OrderClient {
    @GetMapping("/orders")
    List<Order> getOrders();
}
```

#### **4. Multiple Headers Example**

```java
@FeignClient(name = "billing-service")
public interface BillingClient {

    @GetMapping("/invoices")
    List<Invoice> getInvoices(
        @RequestHeader("Authorization") String token,
        @RequestHeader("X-Tenant-ID") String tenantId,
        @RequestHeader("Accept-Language") String locale
    );
}
```

**Invocation**

```java
billingClient.getInvoices(authToken, "tenant-abc", "en-US");
```

## Adding Cookies <a href="#adding-cookies" id="adding-cookies"></a>

Cookies are often used for session management, authentication, or passing stateful information between services. While headers are more commonly used for API tokens, some systems still rely on cookies especially legacy systems or when integrating with frontend-based session handling.

In OpenFeign, cookies can be sent as part of the **`Cookie`** HTTP header.

#### **1. Pass Cookie via `@RequestHeader("Cookie")`**

We can add cookies manually by passing them in the `Cookie` header like any other header.

```java
@FeignClient(name = "session-service")
public interface SessionClient {

    @GetMapping("/session/validate")
    SessionInfo validateSession(@RequestHeader("Cookie") String cookie);
}
```

**Calling Code**

```java
String cookie = "JSESSIONID=abc123; userToken=xyz456";
SessionInfo sessionInfo = sessionClient.validateSession(cookie);
```

#### **2. Use a `RequestInterceptor` to Set Cookie Globally**

This is ideal when all Feign clients or specific ones need to send cookies for every request (e.g., for session stickiness or CSRF protection).

#### **Custom Interceptor Example**

```java
@Configuration
public class FeignCookieInterceptorConfig {

    @Bean
    public RequestInterceptor cookieAddingInterceptor() {
        return requestTemplate -> {
            String jsessionId = fetchFromSessionStorage(); // Custom logic
            requestTemplate.header("Cookie", "JSESSIONID=" + jsessionId);
        };
    }
}
```

**Attach it to the client**

```java
@FeignClient(name = "user-service", configuration = FeignCookieInterceptorConfig.class)
public interface UserClient {

    @GetMapping("/users/profile")
    UserProfile getUserProfile();
}
```

#### **3. Supporting Multiple Cookies**

We can pass multiple cookies by separating them with semicolons (`;`) in a single `Cookie` header:

```java
String cookie = "JSESSIONID=abc123; authToken=def456; lang=en";
requestTemplate.header("Cookie", cookie);
```

#### **4. When we Might Need This ?**

<table data-full-width="true"><thead><tr><th width="349.9375">Use Case</th><th>Example</th></tr></thead><tbody><tr><td>Integrating with legacy systems</td><td>Older systems relying on session cookies instead of token headers</td></tr><tr><td>Load-balanced sticky sessions</td><td>Routing based on <code>JSESSIONID</code></td></tr><tr><td>Web apps requiring <code>XSRF-TOKEN</code> via cookie</td><td>CSRF protection using Spring Security frontend integration</td></tr><tr><td>Stateless APIs behind reverse proxies</td><td>Proxies managing cookies for routing/authentication</td></tr></tbody></table>

## Change content type / accept type

In OpenFeign, we can control the format of requests of send (via `Content-Type`) and the format of responses we expect (via `Accept`) using:

* `@RequestHeader` annotations
* Default Feign behavior (via `spring-cloud-starter-openfeign`)
* Custom configuration/interceptors for global overrides

These headers are essential for ensuring correct serialization and deserialization of payloads.

#### **1. `Content-Type`**

Specifies the media type of the request body. Common values:

* `application/json`
* `application/xml`
* `application/x-www-form-urlencoded`
* `multipart/form-data`

#### **Set `Content-Type` with `@RequestMapping`**

```java
@FeignClient(name = "user-service")
public interface UserClient {

    @PostMapping(value = "/users", consumes = "application/json")
    UserResponse createUser(@RequestBody UserRequest request);
}
```

**Explanation:**

* `consumes = "application/json"` tells Feign and Spring to serialize the request as JSON.

#### **2. `Accept`**

Specifies the expected format of the response. Common values:

* `application/json`
* `application/xml`
* `text/plain`

#### **Set `Accept` with `produces` Attribute**

```java
@FeignClient(name = "user-service")
public interface UserClient {

    @GetMapping(value = "/users/{id}", produces = "application/json")
    UserResponse getUser(@PathVariable("id") Long id);
}
```

**Explanation:**

* `produces = "application/json"` tells the server we expect a JSON response.

#### **3. Set Dynamically via `@RequestHeader`**

Sometimes header values need to be dynamic or client-controlled.

```java
@FeignClient(name = "report-service")
public interface ReportClient {

    @PostMapping("/generate")
    ReportResponse generateReport(
        @RequestBody ReportRequest request,
        @RequestHeader("Content-Type") String contentType,
        @RequestHeader("Accept") String acceptType
    );
}
```

```java
reportClient.generateReport(
    request,
    "application/json",
    "application/pdf"
);
```

#### **4. Set Globally via `RequestInterceptor`**

To apply consistent content negotiation across all clients:

```java
@Configuration
public class FeignHeaderConfig {

    @Bean
    public RequestInterceptor contentNegotiationInterceptor() {
        return requestTemplate -> {
            requestTemplate.header("Content-Type", "application/json");
            requestTemplate.header("Accept", "application/json");
        };
    }
}
```

Use this in a shared config and link it in each `@FeignClient(configuration = ...)`.
