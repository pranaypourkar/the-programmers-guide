---
hidden: true
---

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

If you’re using dynamic values, use a map:

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



