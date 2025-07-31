# Request Customization

## About

When interacting with external services, it is often necessary to customize HTTP requests adding headers, cookies, setting timeouts, modifying the request body, or even intercepting requests conditionally. WebClient offers a rich and fluent API for such customizations.

## **HTTP Methods**

WebClient supports all standard HTTP methods

<table data-full-width="true"><thead><tr><th width="145.98785400390625">HTTP Method</th><th width="351.890625">WebClient Usage Example</th><th>Description</th></tr></thead><tbody><tr><td>GET</td><td><code>webClient.get()</code></td><td>Retrieve data without modifying server state</td></tr><tr><td>POST</td><td><code>webClient.post()</code></td><td>Send data to create resources</td></tr><tr><td>PUT</td><td><code>webClient.put()</code></td><td>Send full updates to existing resources</td></tr><tr><td>PATCH</td><td><code>webClient.patch()</code></td><td>Send partial updates</td></tr><tr><td>DELETE</td><td><code>webClient.delete()</code></td><td>Remove a resource</td></tr><tr><td>HEAD</td><td><code>webClient.method(HttpMethod.HEAD)</code></td><td>Retrieve only headers</td></tr><tr><td>OPTIONS</td><td><code>webClient.method(HttpMethod.OPTIONS)</code></td><td>Discover supported HTTP methods</td></tr><tr><td>TRACE</td><td><code>webClient.method(HttpMethod.TRACE)</code></td><td>Debugging or tracing path of a request</td></tr></tbody></table>

All methods internally use below when more flexibility is needed.

```java
webClient.method(HttpMethod.X)
```

## Setting Multiple Query Parameters

Use `uriBuilder.queryParam(...)` repeatedly to add multiple query parameters.

```java
Mono<Response> response = webClient.get()
    .uri(uriBuilder -> uriBuilder
        .path("/orders")
        .queryParam("status", "PENDING")
        .queryParam("sortBy", "date")
        .queryParam("page", 1)
        .queryParam("limit", 20)
        .build())
    .retrieve()
    .bodyToMono(Response.class);
```

If we are using dynamic values, use a map:

```java
Map<String, Object> queryParams = Map.of(
    "status", "PENDING",
    "sortBy", "date",
    "page", 1,
    "limit", 20
);

Mono<Response> response = webClient.get()
    .uri(uriBuilder -> {
        UriBuilder builder = uriBuilder.path("/orders");
        queryParams.forEach(builder::queryParam);
        return builder.build();
    })
    .retrieve()
    .bodyToMono(Response.class);
```

## **Setting Multiple Path Variables**

Use `.uri(String template, Object... uriVariables)` with multiple values:

```java
Mono<ProductDetail> response = webClient.get()
    .uri("/stores/{storeId}/categories/{categoryId}/products/{productId}", 
         storeId, categoryId, productId)
    .retrieve()
    .bodyToMono(ProductDetail.class);
```

Using a `Map<String, ?>`:

```java
Map<String, String> pathVars = Map.of(
    "storeId", "101",
    "categoryId", "electronics",
    "productId", "555"
);

Mono<ProductDetail> response = webClient.get()
    .uri(uriBuilder -> uriBuilder
        .path("/stores/{storeId}/categories/{categoryId}/products/{productId}")
        .build(pathVars))
    .retrieve()
    .bodyToMono(ProductDetail.class);
```

## **Setting Request Body**

Request body is usually needed for POST, PUT, PATCH.

#### a. **Single Java Object**

```java
UserRequest request = new UserRequest("john@example.com", "John", "Doe");

Mono<UserResponse> response = webClient.post()
    .uri("/users")
    .bodyValue(request)
    .retrieve()
    .bodyToMono(UserResponse.class);
```

#### b. **List or Collection**

```java
List<OrderRequest> orders = List.of(
    new OrderRequest("item-1", 2),
    new OrderRequest("item-2", 1)
);

Flux<OrderRequest> requestFlux = Flux.fromIterable(orders);

Flux<OrderResponse> response = webClient.post()
    .uri("/bulk-orders")
    .body(BodyInserters.fromPublisher(requestFlux, OrderRequest.class))
    .retrieve()
    .bodyToFlux(OrderResponse.class);
```

## Setting Headers

Headers can be set using the `headers` method inside the request spec.

```java
Mono<CustomerResponse> response = webClient.get()
    .uri("/customers/{id}", customerId)
    .headers(httpHeaders -> {
        httpHeaders.set("X-Correlation-ID", UUID.randomUUID().toString());
        httpHeaders.setBearerAuth(jwtToken);
        httpHeaders.setContentType(MediaType.APPLICATION_JSON);
        httpHeaders.setAccept(List.of(MediaType.APPLICATION_JSON));
    })
    .retrieve()
    .bodyToMono(CustomerResponse.class);
```

We can also use `header(String, String...)` directly for quick one-liners:

```java
webClient.get()
    .uri("/orders")
    .header("X-Client-ID", "my-app")
    .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwtToken)
    .retrieve()
    .bodyToMono(OrderSummary.class);
```

## Adding Cookies

Use `.cookies()` to add one or more cookies to the request.

```java
Mono<LoginStatus> response = webClient.get()
    .uri("/session/check")
    .cookies(cookies -> {
        cookies.add("SESSIONID", sessionId);
        cookies.add("clientType", "web");
    })
    .retrieve()
    .bodyToMono(LoginStatus.class);
```

## Change content type / accept type

These are **crucial** for telling the server what format we are sending and what we expect in return.

#### a. **Set Content-Type (what we are sending)**

```java
webClient.post()
    .uri("/users")
    .contentType(MediaType.APPLICATION_JSON)
    .bodyValue(new UserRequest("john@example.com", "John"))
    .retrieve()
    .bodyToMono(UserResponse.class);
```

Other content types:

* `MediaType.APPLICATION_XML`
* `MediaType.MULTIPART_FORM_DATA`
* `MediaType.APPLICATION_FORM_URLENCODED`

#### b. **Set Accept Header (what we want back)**

```java
webClient.get()
    .uri("/catalog")
    .accept(MediaType.APPLICATION_JSON)
    .retrieve()
    .bodyToMono(CatalogResponse.class);
```

We can specify multiple types if needed:

```java
webClient.get()
    .uri("/report")
    .accept(MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML)
    .retrieve()
    .bodyToMono(Report.class);
```
