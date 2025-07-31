# 2. WebClient

## About

**WebClient** is a non-blocking, reactive HTTP client introduced in Spring 5 as part of the WebFlux module. It is designed to work in both **reactive** and **imperative** programming models, offering greater flexibility and efficiency when handling asynchronous communication with external services.

Unlike its predecessor, `RestTemplate`, which is based on blocking I/O, `WebClient` is built on **Reactor**—a reactive library that allows it to handle many concurrent requests with fewer resources by using an event-loop model instead of one thread per request.

### **Imperative Programming Model**

In imperative programming, we **write code that tells the computer step-by-step what to do**. Each step runs one after the other, and the program waits for each operation to finish before moving to the next. This is how most traditional Java code works.

_Example_: If we make a REST API call using `RestTemplate`, our thread **waits (blocks)** until the response comes back, and only then does it move on.

### **Reactive Programming Model**

In reactive programming, we **don’t wait for each step to finish**. Instead, we **react to events or data as they arrive**. It uses non-blocking I/O and an event-driven model where we can handle many things at once without tying up threads.

_Example_: When we use `WebClient`, the thread doesn’t wait for the response. It registers a callback, and when the response is ready, the system triggers the next step. This is more efficient, especially when dealing with many concurrent calls or streaming data.

## When & Why it was Introduced ? <a href="#when-and-why-it-was-introduced" id="when-and-why-it-was-introduced"></a>

Spring introduced `WebClient` in **Spring 5**, alongside **Spring WebFlux**, to support the growing need for scalable, non-blocking, and reactive applications. The traditional `RestTemplate` was limited to a synchronous, thread-per-request model, which often led to resource contention and inefficiency under heavy loads or in microservices architectures.

**Motivations behind introducing WebClient**

<table data-full-width="true"><thead><tr><th width="221.80816650390625">Concern</th><th>Limitation with RestTemplate</th><th>How WebClient Solves It</th></tr></thead><tbody><tr><td>Blocking I/O</td><td>Uses synchronous I/O model (Servlet-based)</td><td>Fully non-blocking I/O using Reactor</td></tr><tr><td>Scalability</td><td>More threads needed for concurrent calls</td><td>Scales with fewer threads (event loop)</td></tr><tr><td>Reactive programming support</td><td>Not compatible with Project Reactor</td><td>Designed for use with reactive pipelines</td></tr><tr><td>Streaming large responses</td><td>Inefficient with large payloads</td><td>Stream data efficiently as it arrives</td></tr><tr><td>Unified use</td><td>Only works for blocking scenarios</td><td>Works in both blocking and reactive apps</td></tr></tbody></table>

{% hint style="success" %}
**What is an Event Loop ?**

An event loop is a programming construct that waits for and dispatches events or messages in a program. It's the core of the non-blocking/reactive model. Instead of using many threads to handle tasks, it uses a single or small number of threads that loop continuously, checking if anything needs to be processed (like an incoming HTTP response or database result).

**How It Works ?**

1. We initiate a task (like a web request).
2. That task is registered with the event loop.
3. The thread is freed up immediately to do other work.
4. When the task completes (e.g., data is returned), the event loop notifies our code (via callbacks or reactive pipelines) so we can handle the result.
{% endhint %}

**When introduced**\
Spring 5 (around 2017), coinciding with the broader industry move toward non-blocking and reactive systems, especially useful in microservice-heavy, I/O-bound environments.

**Why it matters today**\
Modern distributed systems often require high throughput, reactive backpressure, and non-blocking I/O to scale efficiently. `WebClient` is the Spring team's official recommendation going forward and is designed to meet the challenges of today's application architectures.

## Characteristics

The `WebClient` is engineered to provide a modern, flexible, and scalable HTTP client for Spring-based applications. It supports both reactive and traditional models, making it suitable for a wide variety of use cases, especially in distributed, microservice-driven systems.

Here’s a breakdown of its key characteristics:

<table data-full-width="true"><thead><tr><th width="277.217041015625">Characteristic</th><th>Description</th></tr></thead><tbody><tr><td><strong>Non-blocking I/O</strong></td><td>Executes requests without blocking threads. This allows high concurrency with fewer threads.</td></tr><tr><td><strong>Reactive Streams Support</strong></td><td>Fully integrated with Reactor (<code>Mono</code>, <code>Flux</code>), enabling backpressure and composable chains.</td></tr><tr><td><strong>Asynchronous Execution</strong></td><td>Out-of-the-box support for async operations, allowing us to fire-and-forget or chain flows.</td></tr><tr><td><strong>Low Resource Usage</strong></td><td>Efficient for handling thousands of concurrent requests with a small thread pool.</td></tr><tr><td><strong>Unified API</strong></td><td>Same client can be used in both traditional (MVC) and reactive (WebFlux) applications.</td></tr><tr><td><strong>Fluent API Design</strong></td><td>Provides a fluent, builder-style API for constructing complex requests and handling responses.</td></tr><tr><td><strong>Customizability</strong></td><td>Supports filters, codecs, error handlers, headers, cookies, and other custom configurations.</td></tr><tr><td><strong>Streaming &#x26; Large Data Support</strong></td><td>Efficiently handles large responses or streaming data over HTTP.</td></tr><tr><td><strong>Support for SSE and WebSockets</strong></td><td>Can consume Server-Sent Events and connect to WebSockets easily.</td></tr><tr><td><strong>Better Debugging Capabilities</strong></td><td>Logging and debugging hooks can be attached through filters or Reactor hooks.</td></tr><tr><td><strong>Pluggable Codec Support</strong></td><td>Customize how data is serialized/deserialized via custom codecs (e.g., JSON, XML).</td></tr><tr><td><strong>Integrated Timeout Handling</strong></td><td>Easily set connection/read/write timeouts at the client level.</td></tr><tr><td><strong>Security Integration</strong></td><td>Works well with OAuth2, JWT, and custom authentication mechanisms using Spring Security.</td></tr></tbody></table>

## Typical Usage Scenario <a href="#typical-usage-scenario" id="typical-usage-scenario"></a>

In a typical enterprise system, imagine a service that needs to fetch user details from a remote `user-service` microservice.

Using traditional HTTP clients like `RestTemplate`, the thread will block until the remote call completes. But with `WebClient`, the call is **non-blocking** our application doesn’t sit idle while waiting for the response.

### Example

```java
WebClient webClient = WebClient.create();

Mono<UserDetails> userMono = webClient.get()
    .uri("http://user-service/api/users/42")
    .retrieve()
    .bodyToMono(UserDetails.class);

System.out.println("Request sent... waiting for user data");
userMono.subscribe(user -> {
    System.out.println("User data received: " + user.getName());
});
System.out.println("This line runs immediately after sending the request");
```

### What this illustrates ?

* `"Request sent..."` is printed immediately.
* `"This line runs immediately..."` is also printed right away.
* The actual user data is printed only when the remote service responds, handled by the callback in `subscribe()`.
* No thread is blocked, making this approach scalable for high-load systems.

### Why It Matters in Large Systems ?

In high-throughput systems, if we block a thread waiting for a remote response, we are reducing our capacity to serve other users. With `WebClient`, we **send the request and move on** freeing up resources while waiting for the reply.

Imagine it like this

```
Thread: "Hey, go fetch that user data."
WebClient: "Sure, I'll let you know when it's back."
Thread: "Great. Meanwhile, I’ll serve the next request."
```

This is fundamentally different from

```
Thread: "Go fetch user data."
RestTemplate: "Okay, but you'll need to wait here until I return."
Thread: "Sigh..."
```

### Use Cases

<table data-header-hidden data-full-width="true"><thead><tr><th width="222.13885498046875"></th><th></th></tr></thead><tbody><tr><td><strong>Use Case</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Internal Microservice Calls</strong></td><td>Services like <code>payment-service</code> or <code>order-service</code> calling other internal APIs (e.g., to fetch account, pricing, or inventory info).</td></tr><tr><td><strong>External API Integration</strong></td><td>Integrating with payment gateways (e.g., Stripe), shipment tracking APIs, or social login providers—especially where performance and non-blocking behavior are crucial.</td></tr><tr><td><strong>Concurrent Calls</strong></td><td>Calling multiple services at once (e.g., inventory + pricing) using <code>Mono.zip()</code> or <code>Flux.merge()</code> and combining results efficiently.</td></tr><tr><td><strong>Streaming or Server-Sent Events (SSE)</strong></td><td>Listening to continuous data streams such as IoT sensor data, stock prices, or live sports scores.</td></tr><tr><td><strong>Background Workflows</strong></td><td>Triggering async jobs or workflows (e.g., sending notifications) without holding up a thread.</td></tr><tr><td><strong>Reactive Chains</strong></td><td>Composing multiple dependent calls with <code>flatMap</code>/<code>map</code>, perfect for building workflows in a functional, reactive style.</td></tr></tbody></table>

## When to Use WebClient ?

#### 1. **High-Concurrency, I/O-Bound Applications**

If our application needs to make **many outbound HTTP calls** (e.g., to other microservices, APIs, or gateways), `WebClient` allows us to do so **without blocking threads**, making it ideal for:

* Public-facing APIs under heavy load
* Backend services that call multiple other systems
* Event-driven or reactive platforms

> For example, an order processing service that needs to query inventory, pricing, and user account info **concurrently** can benefit greatly from `WebClient`'s non-blocking model.

#### 2. **Integration with Reactive Systems**

If we are using **Project Reactor**, **Spring WebFlux**, or building **reactive streams**, `WebClient` is the natural choice. It fits directly into the reactive programming model with return types like `Mono` and `Flux`.

> This is especially useful when consuming **reactive data sources** (e.g., R2DBC, reactive MongoDB), ensuring that the entire flow is non-blocking and backpressure-aware.

#### 3. **Streaming or Long-Lived Connections**

When our app needs to handle:

* **Server-Sent Events (SSE)**
* **WebSockets**
* **HTTP/2 streaming**

`WebClient` supports **streaming response bodies** and is well-suited for continuous data exchange without timeouts or holding threads open.

> Example: A monitoring dashboard consuming a live data feed from a telemetry or health-check service.

#### 4. **Need for Greater Customization or Control**

If we need fine-grained control over:

* Headers
* Cookies
* Body serialization
* Request logging
* Retry logic
* Timeout configuration

Then `WebClient` is highly customizable and can handle these with filters and builder configuration fluently.

#### 5. **Migrating to or Starting with Reactive Architecture**

If our app is undergoing **modernization** (e.g., monolith to microservices) and we are gradually introducing **reactive components**, `WebClient` becomes a stepping stone that aligns with our long-term architectural goals.

#### 6. **Parallel Requests / Aggregation Use Cases**

When our use case involves calling multiple external services and **combining their responses**, `WebClient` helps us do this **in parallel** using `Mono.zip()` or `Flux.merge()`.

> For instance, building a product detail page by fetching catalog info, reviews, stock availability, and promotions all at once.

## When Not to Use WebClient ?

Despite its flexibility and power, `WebClient` isn't always the best choice. There are scenarios where its reactive, non-blocking nature may actually introduce **unnecessary complexity**, **resource overhead**, or **mismatch** with our application's architecture.

\
1\. **In Traditional, Blocking Applications (Spring MVC)**

If our application is built on **Spring MVC** or uses a **thread-per-request model**, `WebClient` won’t provide meaningful benefits—and may even complicate the flow.

* It returns `Mono` or `Flux`, which require reactive composition and handling.
* Using `.block()` to convert it into a synchronous call defeats its purpose and leads to **thread blocking**, **increased latency**, and **poorer performance** than using `RestTemplate`.

> Example: A simple internal tool or dashboard where everything else is synchronous doesn't need the overhead of `WebClient`.

#### 2. **When Team is Not Comfortable with Reactive Programming**

If our team is not experienced with:

* Reactive concepts (e.g., `Mono`, `Flux`, `subscribe()`)
* Backpressure
* Chaining and composing async operations\
  then using `WebClient` can lead to:
* Confusing, unreadable code
* Improper error handling
* Memory leaks or resource starvation

> Training and ramp-up time may not justify the switch if async benefits aren't essential.

#### 3. **For Simple or Low-Traffic Use Cases**

If we are calling only one or two endpoints occasionally, in a low-concurrency context (like batch jobs, cron jobs, admin tools), then `RestTemplate` is easier to use, debug, and test.

> Example: A backend job that hits a reporting API once every hour to pull a CSV report.

#### 4. **When We Need Mature, Stable Ecosystem with Widespread Support**

While `WebClient` is feature-rich, it's **newer than RestTemplate**, and some mature integrations, examples, or client SDKs might still rely on the latter.

> We might run into third-party libraries or examples still tied to `RestTemplate`, and adapting them to `WebClient` may introduce friction.

#### 5. **When Code Simplicity and Debuggability Are Priority**

Reactive code requires:

* A different debugging approach
* Extra care in error propagation and exception mapping
* Advanced understanding of thread contexts (especially with `Schedulers`)

In scenarios where debugging clarity or developer onboarding is a priority, sticking with blocking HTTP clients can lead to **faster troubleshooting** and **simpler maintenance**.

#### 6. **If We Don’t Control the Entire Call Chain**

WebClient works best **end-to-end** in reactive flows. If our upstream and downstream systems are all blocking (e.g., blocking DB, synchronous services), then the non-blocking advantage is negated.

> We are essentially adding async complexity with no real gain.
