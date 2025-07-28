---
hidden: true
---

# Asynchronous Execution

To achieve asynchronous behavior when using RestTemplate, we can use it with `CompletableFuture`.

For example -

```java
// URL for the REST API endpoint
String url = "http://example.com/api/resource";

// Making an asynchronous GET request using CompletableFuture
CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
    // Perform the HTTP request
    String response = restTemplate.getForObject(url, String.class);
    return response;
});

// Other tasks can continue while the request is being made asynchronously

// Wait for the asynchronous operation to complete
future.join();
```
