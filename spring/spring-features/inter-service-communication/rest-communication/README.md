# REST Communication

## About

**REST Communication** refers to the exchange of information between services using HTTP and REST (Representational State Transfer) principles. REST is a stateless, client-server architecture that enables loosely coupled interactions over the web, commonly using JSON or XML as data formats.

In the Spring ecosystem, REST is a foundational style of service interaction. Whether we are building microservices, exposing APIs to external consumers, or orchestrating between internal modules, RESTful communication offers simplicity, scalability, and wide adoption.

## Why it Matters

REST communication is central to how modern distributed systems, APIs, and microservices talk to each other. Its importance stems from both **technical simplicity** and **architectural flexibility**.

<table data-full-width="true"><thead><tr><th width="243.6961669921875">Perspective</th><th>Why It Matters</th></tr></thead><tbody><tr><td><strong>Platform Agnostic</strong></td><td>REST uses HTTP, a universally supported protocol, allowing seamless communication between systems written in different languages or frameworks.</td></tr><tr><td><strong>Simplicity &#x26; Adoption</strong></td><td>The use of HTTP verbs (<code>GET</code>, <code>POST</code>, <code>PUT</code>, <code>DELETE</code>) and readable URIs makes REST intuitive, widely taught, and well-documented.</td></tr><tr><td><strong>Stateless Architecture</strong></td><td>Each request contains all necessary information. This simplifies server design and improves horizontal scalability.</td></tr><tr><td><strong>Foundation for Microservices</strong></td><td>In microservice ecosystems, REST is the default protocol for synchronous service-to-service communication.</td></tr><tr><td><strong>Tooling and Ecosystem</strong></td><td>Rich support from tools like Swagger/OpenAPI, Postman, and Spring Boot make REST easy to implement, test, and maintain.</td></tr><tr><td><strong>Human and Machine Friendly</strong></td><td>RESTful APIs often return JSON, which is both machine-readable and easy for developers to inspect during development and debugging.</td></tr><tr><td><strong>Caching and Performance</strong></td><td>HTTP-level caching support can improve performance and reduce server load when implemented correctly.</td></tr><tr><td><strong>Security Integration</strong></td><td>REST naturally integrates with transport-level (HTTPS), application-level (JWT, OAuth2), and network-level (API gateway) security mechanisms.</td></tr></tbody></table>

## Characteristics of REST Communication

REST is defined not just by _how_ systems communicate, but also by _how communication is structured_. These principles make REST highly scalable, adaptable, and fit for distributed systems.

{% hint style="info" %}
Refer to the page for more details [rest-api](../../../../api/rest-api/ "mention")
{% endhint %}

<table data-full-width="true"><thead><tr><th width="232.28997802734375">Characteristic</th><th>Description</th></tr></thead><tbody><tr><td><strong>Statelessness</strong></td><td>Each HTTP request is independent. The server does not retain any client context between calls.</td></tr><tr><td><strong>Resource-Based</strong></td><td>Systems expose data as <em>resources</em> identified by URIs (e.g., <code>/orders/123</code>), not actions or commands.</td></tr><tr><td><strong>Standard HTTP Methods</strong></td><td>Uses well-defined HTTP verbs like <code>GET</code>, <code>POST</code>, <code>PUT</code>, <code>DELETE</code>, aligned with CRUD semantics.</td></tr><tr><td><strong>Uniform Interface</strong></td><td>All interactions follow a common, predictable interface pattern using standard HTTP constructs.</td></tr><tr><td><strong>Cacheability</strong></td><td>Responses can be marked as cacheable, enabling intermediate systems (e.g., browsers, proxies) to optimize performance.</td></tr><tr><td><strong>Layered System</strong></td><td>Clients may not know whether they are communicating with the origin server or an intermediary like a load balancer or proxy. This promotes scalability.</td></tr><tr><td><strong>Representation-Based</strong></td><td>Resources are not directly exposed. Instead, they are represented as formats (like JSON, XML) passed between client and server.</td></tr><tr><td><strong>Discoverability via HATEOAS</strong> <em>(Optional)</em></td><td>Clients can navigate the API dynamically using hyperlinks in responses. While not commonly implemented, it's part of full REST maturity.</td></tr><tr><td><strong>Stateless Error Handling</strong></td><td>Error responses like 400, 401, 404, 500 help clients understand failure context without needing extra contracts.</td></tr></tbody></table>

## REST Communication in Spring

In Spring applications, REST-based communication is a core capability that enables services to exchange data over HTTP. Spring abstracts the complexity of constructing and processing HTTP requests using various tools, making REST interactions seamless and expressive.

Spring provides both imperative and reactive programming models to support different performance and scalability needs:

* **RestTemplate**: A synchronous and traditional client used for making HTTP requests. It is simple to use and well-integrated with the broader Spring ecosystem. While it is considered **deprecated** in favor of WebClient, many legacy applications still rely on it.
* **WebClient**: Part of the Spring WebFlux module, WebClient is designed for non-blocking, asynchronous communication. It allows better scalability under high load, especially in I/O-heavy or reactive applications.
* **Feign Client**: A declarative REST client integrated with Spring Cloud, used for inter-service calls in microservice architectures. It allows developers to define client-side interfaces annotated with mappings, eliminating boilerplate HTTP call code.

## Typical Flow in Spring

The typical flow of REST communication in a Spring Boot application (both client and server) involves multiple components working in a layered and loosely coupled way. Here's a breakdown of the sequence:

**On the Client Side**

1. The client constructs a request using `RestTemplate`, `WebClient`, or `FeignClient`. The request may contain headers, query parameters, path variables, or a request body (e.g., JSON).
2. The request is sent over HTTP to the REST endpoint.
3. Spring automatically serializes the request payload to JSON using Jackson or another configured converter.
4. The client waits for a synchronous response (unless using a reactive pipeline).
5. The response is deserialized back into a Java object for further use.

**On the Server Side**

1. A controller method, annotated with `@RestController` and appropriate `@RequestMapping`, receives the request.
2. Spring automatically maps the HTTP request to method arguments using annotations like `@RequestBody`, `@PathVariable`, and `@RequestParam`.
3. The controller delegates business logic to service classes, which may interact with repositories, external APIs, or other internal services.
4. A response object is returned, often wrapped in a `ResponseEntity` for control over HTTP headers and status.
5. Spring serializes the response back into JSON and sends it to the client.

The entire pipeline leverages Spring’s dependency injection, HTTP conversion layers, validation mechanisms, and interceptor support to ensure clean, testable, and reusable code.

## When to Use REST Communication

**REST communication** is best suited for scenarios where a client needs a timely and predictable response from a service. It's useful when interaction needs to happen in a well-defined, synchronous manner.

**Recommended Use Cases**

* **Synchronous Client-Server Interaction**\
  When the client sends a request and must wait for a response before proceeding, such as fetching user details, submitting forms, or triggering immediate actions.
* **Well-Defined APIs and Contracts**\
  When data contracts are established and unlikely to change frequently. REST works well where resources are stable, and endpoints map clearly to operations (CRUD).
* **Interfacing with External Systems**\
  Most third-party services expose HTTP REST APIs. REST is often the only option when integrating with payment gateways, OAuth providers, or data providers.
* **Service Orchestration**\
  When one service is responsible for coordinating the execution of several other services in a structured flow, and needs control over execution order and responses.
* **Low to Medium Load Systems**\
  REST works well in systems where concurrency is moderate and scalability requirements are straightforward.
* **Mobile and Web Frontend Communication**\
  Frontend applications often consume REST APIs due to wide HTTP support and browser compatibility.
* **Situations Needing Simplicity and Speed of Development**\
  REST is relatively simple to implement and understand. It is a good fit when we need fast prototyping or have small teams.

## When NOT to Use REST Communication

REST is not always the right choice. There are several scenarios where REST creates bottlenecks, complexity, or inefficiency.

**Avoid REST When:**

* **High Throughput, Event-Driven Requirements Exist**\
  If the system needs to publish, consume, or react to events in real time (e.g., financial transactions, audit logs), asynchronous messaging (like Kafka or RabbitMQ) is better suited.
* **Loose Coupling Is Essential**\
  REST enforces temporal coupling: both client and server must be online at the same time. For decoupled communication (fire-and-forget), use event-driven architectures or message brokers.
* **Long-Running or Batch Processes**\
  REST is synchronous. It's not ideal for operations that take a long time (e.g., generating large reports, video processing). These should be queued asynchronously and handled via background workers.
* **Complex Workflows or Choreography**\
  For systems with multiple services collaborating dynamically, managing state and failure recovery via REST is difficult. Messaging patterns or workflow engines offer better orchestration.
* **High Scalability or Fault Tolerance Requirements**\
  REST over HTTP can become a bottleneck under extreme load. Also, retrying or failing over REST calls often requires additional error handling logic. Event-driven communication can buffer spikes and handle retries natively.
* **Need for Real-Time Communication or Streaming**\
  REST is request-response only. For real-time needs (e.g., chat apps, live updates), use WebSockets or streaming protocols like Server-Sent Events or gRPC with streaming support.
* **Dynamic Payload Routing or Schema Evolution**\
  REST APIs tightly couple clients to resource structure. If our domain is evolving rapidly, schema-first or event-based strategies allow more flexibility and backward compatibility.
