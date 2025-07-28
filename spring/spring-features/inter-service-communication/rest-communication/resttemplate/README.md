# 1. RestTemplate

## About

`RestTemplate` is a high-level, synchronous HTTP client provided by the Spring Framework, used to simplify communication with RESTful web services. It abstracts away the boilerplate code involved in interacting with HTTP-based APIs, allowing developers to focus on business logic rather than HTTP plumbing.

By handling HTTP requests and responses, serialization and deserialization of Java objects, and error management, `RestTemplate` enables seamless integration between microservices or external systems within a Spring-based application.

## When & Why it was Introduced ?

In the early days of REST adoption, developers were left to implement low-level HTTP clients using libraries like `HttpURLConnection` or Apache HttpClient. These solutions were verbose and error-prone, requiring manual configuration for headers, content types, serialization, and error handling.

To streamline this process, Spring introduced `RestTemplate` as part of the Spring Web module. It offered a declarative, reusable, and idiomatic way to consume REST APIs within the familiar Spring programming model. The goal was to reduce repetitive code, enforce type safety, and provide out-of-the-box support for JSON and XML mapping using Spring's `HttpMessageConverters`.

## Deprecation notice

While `RestTemplate` remains supported and widely used in production applications, **it is considered legacy in newer Spring projects**.

Spring introduced **`WebClient`** as part of **Spring WebFlux**, which supports asynchronous, non-blocking, and reactive HTTP communication. WebClient offers better scalability and performance in modern microservice or reactive systems.

Spring officially states:

> _"The RestTemplate will be in maintenance mode, with no major enhancements going forward. For non-blocking HTTP calls, prefer WebClient."_

That said, `RestTemplate` is still a reliable choice for:

* Synchronous applications
* Traditional Spring MVC stacks
* Systems that don't use reactive programming

## Characteristics

<table data-full-width="true"><thead><tr><th width="232.290771484375">Characteristic</th><th>Description</th></tr></thead><tbody><tr><td><strong>Synchronous</strong></td><td>Calls are blocking. The thread is held until the response arrives.</td></tr><tr><td><strong>Template-Based</strong></td><td>Encourages reusable, declarative code for REST operations.</td></tr><tr><td><strong>Thread-safe</strong></td><td>Can be used as a singleton across multiple threads (with proper configuration).</td></tr><tr><td><strong>Rich API</strong></td><td>Provides methods like <code>getForObject</code>, <code>postForEntity</code>, <code>exchange</code>, and more.</td></tr><tr><td><strong>Serialization Support</strong></td><td>Uses Spring’s <code>HttpMessageConverters</code> (e.g., Jackson) for JSON/XML conversion.</td></tr><tr><td><strong>Exception Handling</strong></td><td>Can be customized via <code>ResponseErrorHandler</code>.</td></tr><tr><td><strong>Pluggable</strong></td><td>Custom interceptors, request factories, and converters can be injected.</td></tr><tr><td><strong>Mature and Stable</strong></td><td>Battle-tested and well-documented across the Spring ecosystem.</td></tr></tbody></table>

## **Typical Usage Scenario**

Imagine a system where your Spring Boot application needs to call another microservice to retrieve user details or perform a payment:

```java
ResponseEntity<UserDetails> response = restTemplate.getForEntity(
    "http://user-service/api/users/42", UserDetails.class
);
```

In this simple example:

* A GET request is made to an external service
* The response body is converted to a Java object (`UserDetails`)
* The HTTP response metadata (status code, headers) is accessible

It eliminates the need to manually open connections, handle streams, or parse JSON.

Some common real-world uses:

* Calling payment gateways (e.g., Stripe, Razorpay)
* Fetching catalog information from external APIs
* Internal service-to-service communication in monolithic-to-microservice migrations
* Performing health checks or diagnostics of dependent services

## **When to Use RestTemplate ?**

<table data-full-width="true"><thead><tr><th width="398.82720947265625">Use Case</th><th>Explanation</th></tr></thead><tbody><tr><td><strong>Synchronous communication is acceptable</strong></td><td>When the client can afford to wait for the response, <code>RestTemplate</code> provides a clear and simple abstraction for REST calls.</td></tr><tr><td><strong>Traditional Spring MVC applications</strong></td><td>It integrates well with Spring Boot apps that do not use reactive programming or WebFlux.</td></tr><tr><td><strong>Simple API interaction with predictable behavior</strong></td><td>Perfect for straightforward REST operations (GET, POST, PUT, DELETE) where advanced control over connection or flow isn’t needed.</td></tr><tr><td><strong>Stable legacy systems</strong></td><td>When working within a system that already uses <code>RestTemplate</code> extensively, introducing <code>WebClient</code> might not justify the cost unless there are performance concerns.</td></tr><tr><td><strong>Quick prototypes or PoCs</strong></td><td>Easier to set up and use for rapid development cycles or temporary internal tools.</td></tr><tr><td><strong>Blocking behavior is intentional</strong></td><td>In some applications (like financial workflows or audit trails), it’s desirable to wait until the operation completes successfully before moving forward.</td></tr></tbody></table>

## **When Not to Use RestTemplate ?**

<table data-full-width="true"><thead><tr><th width="366.0364990234375">Situation</th><th>Why Not</th></tr></thead><tbody><tr><td><strong>Need for non-blocking or reactive I/O</strong></td><td><code>RestTemplate</code> is blocking. If your app is reactive (using WebFlux or functional endpoints), use <code>WebClient</code> instead.</td></tr><tr><td><strong>High-concurrency or scalability requirements</strong></td><td>Blocking threads do not scale well. In systems that handle thousands of concurrent requests, <code>WebClient</code> is more efficient.</td></tr><tr><td><strong>Streaming APIs or long polling</strong></td><td><code>RestTemplate</code> is not optimized for data streams or server-sent events (SSE).</td></tr><tr><td><strong>Modern microservices architecture</strong></td><td>If your architecture favors reactive patterns, event-driven communication, or non-blocking behavior, <code>RestTemplate</code> becomes a bottleneck.</td></tr><tr><td><strong>Heavy customization of HTTP layer</strong></td><td>While you can customize <code>RestTemplate</code>, <code>WebClient</code> offers finer control over connection settings, filters, timeouts, etc.</td></tr></tbody></table>
