---
hidden: true
---

# Request Customization

## **About**

`RestTemplate` provides several hooks and constructs to allow **request customization**—a critical aspect when interacting with external APIs or internal microservices that require authentication, custom headers, request transformations, logging, tracing, or advanced configuration like timeouts and interceptors.

Customizing a request ensures that your API calls are:

* Secure (e.g., with bearer tokens or API keys),
* Compliant (e.g., with required content-type or correlation IDs),
* Reliable (e.g., with retries, timeouts, and fallbacks),
* Traceable (e.g., with custom headers for distributed tracing).

## **Common Use Cases**

<table data-header-hidden data-full-width="true"><thead><tr><th width="368.779541015625"></th><th></th></tr></thead><tbody><tr><td><strong>Use Case</strong></td><td><strong>Customization Example</strong></td></tr><tr><td>Add Path and Query Param</td><td>Set Query, Path parameters</td></tr><tr><td>Add Request Body</td><td>Set API Request body</td></tr><tr><td>Add authentication headers</td><td>Bearer token, API key, Basic Auth</td></tr><tr><td>Include trace/correlation IDs</td><td>Pass unique request ID for observability</td></tr><tr><td>Change content type / accept type</td><td><code>application/json</code>, <code>application/xml</code>, custom media types</td></tr><tr><td>Modify request payload</td><td>Pre-serialize object, or add additional request fields</td></tr><tr><td>Set timeouts or connection pool</td><td>Customize via underlying <code>HttpClient</code> or <code>RestTemplateBuilder</code></td></tr><tr><td>Pre-process request before sending</td><td>Interceptors, <code>ClientHttpRequestInterceptor</code></td></tr><tr><td>Add dynamic headers from context</td><td>Extract values from MDC, ThreadLocal, or SecurityContext</td></tr></tbody></table>

## Add Path and Query Param

When interacting with external or internal REST APIs, it is common to dynamically construct the request URL by appending:

* **Path Parameters** — values embedded directly within the URL path (e.g., `/user/{id}`),
* **Query Parameters** — key-value pairs appended after the `?` in the URL (e.g., `?status=active&limit=10`).

Spring’s `RestTemplate` provides multiple ways to inject these parameters cleanly and maintainably.

#### **1. Path Parameters with `exchange()`**

```java
String url = "https://api.example.com/users/{id}/accounts/{accountId}";

Map<String, String> pathParams = new HashMap<>();
pathParams.put("id", "42");
pathParams.put("accountId", "98765");

ResponseEntity<AccountDetails> response = restTemplate.exchange(
    url,
    HttpMethod.GET,
    null,
    AccountDetails.class,
    pathParams
);
```

* The placeholders (`{id}`, `{accountId}`) are replaced using the map.
* Clean and declarative.
* Avoids manual concatenation.

#### **2. Query Parameters with `UriComponentsBuilder`**

```java
URI uri = UriComponentsBuilder
    .fromHttpUrl("https://api.example.com/search")
    .queryParam("status", "active")
    .queryParam("limit", 10)
    .queryParam("sort", "date")
    .build()
    .encode()
    .toUri();

ResponseEntity<SearchResult> response = restTemplate.getForEntity(uri, SearchResult.class);
```

* Useful when query parameters are optional or dynamic.
* Automatically handles URL encoding (e.g., spaces, special characters).
* Keeps base URL clean.

#### **3. Combined Path and Query Parameters**

```java
URI uri = UriComponentsBuilder
    .fromUriString("https://api.example.com/users/{id}/transactions")
    .queryParam("from", "2024-01-01")
    .queryParam("to", "2024-12-31")
    .buildAndExpand("42")
    .encode()
    .toUri();

ResponseEntity<TransactionList> response = restTemplate.getForEntity(uri, TransactionList.class);
```

* `buildAndExpand("42")` injects the path parameter.
* `queryParam()` handles additional filters or pagination.



## Add Request Body

When making HTTP methods like `POST`, `PUT`, or `PATCH`, the client often needs to send a structured **request body**—typically in JSON or XML format. This body carries the actual business payload (e.g., user details, payment data, file metadata).

Spring’s `RestTemplate` allows for seamless serialization of Java objects into the body of a request using its built-in message converters (usually `MappingJackson2HttpMessageConverter` for JSON).





## Add authentication headers



## Include trace/correlation IDs



## Change content type / accept type



## Modify request payload



## Set timeouts or connection pool



## Pre-process request before sending



## Add dynamic headers from context





