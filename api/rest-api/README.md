# REST API

## About

REST stands for **Representational State Transfer**. It is a widely used architectural style for designing web services that allows systems to communicate over HTTP using standard methods. REST APIs are stateless, scalable, and simple to implement, which is why they are a popular choice for building modern web and mobile applications.

## What is a REST API ?

A REST API is an interface that allows clients (like web browsers, mobile apps, or other servers) to interact with resources on a server using a predefined set of HTTP methods. It works by exposing endpoints (URLs) that represent resources, and each operation (like retrieving or modifying data) is performed by sending an HTTP request to one of these endpoints.

For example:\
`GET /users/1` retrieves the user with ID 1.\
`POST /users` creates a new user.

## Key Components of a REST API

**1. Resources**

Everything in a REST API is considered a resource—users, products, orders, etc. Each resource has a unique URL (endpoint).

* Example: `/users/123` represents the user with ID 123.

**2. HTTP Methods (Verbs)**

Each operation on a resource is performed using standard HTTP methods:

* `GET` – Read data
* `POST` – Create a new resource
* `PUT` – Update a resource completely
* `PATCH` – Update a resource partially
* `DELETE` – Remove a resource

**3. URI (Uniform Resource Identifier)**

A URI identifies each resource.

* Example: `/books/10` refers to a book with ID 10

**4. Request and Response**

* **Request**: The client sends data using URL, headers, and sometimes a body.
* **Response**: The server sends back data (often in JSON) with a status code.

**5. Status Codes**

REST APIs use standard HTTP status codes to indicate the result:

* `200 OK` – Success
* `201 Created` – New resource created
* `400 Bad Request` – Invalid request
* `404 Not Found` – Resource not found
* `500 Internal Server Error` – Something failed on the server

**6. Headers**

Used to pass metadata like content type, authentication tokens, etc.

**7. Parameters**

* **Path parameters**: Included directly in the URL. Example: `/users/42`
* **Query parameters**: Provide filters or options. Example: `/products?sort=price&limit=5`

**8. Representation**

Resources are usually represented in JSON or XML. For example, the response to `GET /user/1` might be:

```json
{
  "id": 1,
  "name": "John",
  "email": "john@example.com"
}
```

## When to Use REST ?

REST is a powerful and flexible architectural style, but it's especially effective in certain scenarios. Below are situations where using REST makes the most sense -

**1. We Are Building a Resource-Oriented System**

REST works best when our application deals with entities or objects that can be identified and manipulated, such as users, orders, products, or devices. If our domain is naturally organized around nouns (things), REST is a natural fit.

* Example: An e-commerce platform managing products, categories, and orders.

**2. We Want Simplicity and Wide Adoption**

REST uses standard HTTP methods like GET, POST, PUT, and DELETE, which are familiar to most developers. It’s supported by every major programming language, framework, and toolset, so we don’t need special libraries or complex tooling to start using it.

* Example: Public-facing APIs for third-party developers or teams with mixed technical backgrounds.

**3. Stateless Communication Works for our Case**

If our application doesn't require the server to store session state between requests (i.e., each request is independent), REST’s stateless nature makes scaling easier. Stateless APIs are easier to load-balance and distribute across servers.

* Example: User profile APIs where each request includes authentication info and doesn’t rely on prior interaction.

**4. We Need Caching Support**

REST leverages HTTP caching mechanisms, such as ETags and Cache-Control headers, to reduce load and improve performance. This is beneficial when clients frequently request the same data.

* Example: Mobile apps fetching news or weather data where updates are periodic.

**5. We are Building Web or Mobile Frontends**

REST is ideal for APIs consumed by frontend applications (browser or mobile) that need to retrieve and modify data on the backend. REST’s simplicity and JSON support make it frontend-friendly.

* Example: A mobile app that displays user-generated content or communicates with a social media backend.

**6. We Want Clear and Predictable URL Structures**

REST encourages clean, readable, and predictable URIs, such as:

* `/users/12/orders/50`
* `/articles?category=technology`

This improves API readability, documentation, and developer onboarding.

**7. Interoperability Across Clients**

REST APIs work over HTTP, which is universally supported. This makes it possible for any device with internet access—phones, browsers, servers, IoT devices—to use the API, regardless of language or platform.

* Example: A payment service used by both a website and a mobile app.

**8. We Need Loose Coupling Between Client and Server**

In REST, the client and server are loosely coupled—clients don’t need to know how the server works internally, only the API contract. This allows each side to evolve independently as long as the contract is preserved.

* Example: Frontend developers can continue building against a mock REST API while backend development is ongoing.

**9. We Intend to Expose the API Publicly or to External Developers**

REST is well-known and expected in public APIs. Its simplicity and standard behavior help third-party developers integrate easily without needing detailed instructions.

* Example: Offering API access for partners or external developers to fetch user data or analytics.

**10. Our Infrastructure Supports HTTP-Based Tools**

Since REST uses HTTP, it plays nicely with firewalls, proxies, browsers, testing tools (like Postman), load balancers, and logging systems. This lowers operational complexity.

## When Not to Use REST ?

While REST is a popular and widely used architectural style, it is **not the best fit for every situation**. Below are scenarios where using REST may introduce limitations, complexity, or inefficiency.

**1. Real-Time Communication Is Needed**

REST is based on request-response over HTTP. It doesn't support **server-to-client push** or real-time data updates naturally. If our application needs instant updates (e.g., chat apps, live sports scores), REST falls short.

* **Better suited alternative**: WebSockets or streaming APIs using protocols like SSE (Server-Sent Events) or gRPC.

**2. We Need Bi-Directional or Long-Lived Connections**

In REST, the client sends a request and the server responds—it’s strictly one-way. For **long-lived, continuous, or bidirectional communication**, REST isn’t designed for that model.

* **Example**: Online multiplayer games, collaborative whiteboards, or remote device control.
* **Better alternative**: WebSockets or MQTT.

**3. We Have Complex Workflows Not Easily Mapped to Resources**

REST is ideal for resource-oriented APIs (think: things). But if our application is **action-oriented**, such as performing sequences of tasks or workflows (e.g., processing a multi-step loan application), REST becomes less natural and harder to design.

* **Issue**: Actions like `approve`, `reject`, or `calculate` don't map well to standard HTTP verbs.
* **Alternative**: GraphQL, RPC-style APIs, or task/event-based APIs.

**4. We Need Efficient Data Fetching for Complex or Flexible Queries**

In REST, we often need multiple requests to fetch related data. There’s no built-in support for specifying **exact fields or nested relationships**, which can lead to **over-fetching or under-fetching**.

* **Example**: A client needs user info along with their recent orders and shipping status.
* **Better alternative**: GraphQL allows clients to request exactly what they need in a single query.

**5. High-Performance Requirements Over Low-Bandwidth Networks**

REST uses plain text (typically JSON over HTTP), which may be **too verbose for low-bandwidth** environments like mobile networks, embedded systems, or IoT.

* **Issue**: REST headers and payload sizes can be bulky.
* **Alternative**: Protocol Buffers (used with gRPC), MessagePack, or binary formats.

**6. We Need Strictly Defined APIs and Contract-First Development**

REST lacks a universal standard for describing API contracts (though OpenAPI helps). If we require **strict schemas, validations, and auto-generated clients**, REST might feel too loose.

* **Better alternative**: gRPC (uses Protocol Buffers with strict type enforcement), or tools like OpenAPI/Swagger with REST.

**7. We Want to Avoid Versioning Complexity**

REST APIs often require URL versioning (`/v1/products`) or header-based versioning. Managing multiple versions of endpoints can become **complex and hard to maintain**.

* **Better alternative**: GraphQL (where schema evolution is built-in), or event-driven systems where versioning happens at the message level.

**8. We Have Large Payloads or File Transfers**

REST over HTTP may not be optimal for **streaming large files or continuous data**. File uploads/downloads can be clunky, and streaming is not native.

* **Better alternative**: gRPC with streaming, or direct file transfer protocols like FTP/SFTP.

**9. We Need Stronger Typing and Performance in Internal Microservices**

For internal services where **performance, schema enforcement, and efficient serialization** matter more than human readability, REST may be suboptimal.

* **Alternative**: gRPC or Apache Thrift for internal APIs between microservices.

**10. REST Constraints Are Too Rigid for our Use Case**

REST follows strict principles (statelessness, uniform interface, etc.). If these constraints are **limiting instead of helping**, such as needing stateful operations or complex custom behavior, then REST may not be worth enforcing.
