# Asynchronous Execution

## About

Unlike `RestTemplate`, which blocks the calling thread until the response is received, `WebClient` is **non-blocking and reactive by design**. That means it can initiate multiple calls in parallel, freeing up threads and allowing better scalability especially important in high-concurrency environments like microservices or gateways.

## **Why Use Asynchronous Execution?**

In modern distributed systems and microservice-based architectures, **asynchronous execution** is a crucial strategy for building **responsive, resilient, and scalable applications**. Traditional synchronous HTTP calls (as seen with `RestTemplate`) block the calling thread until the remote service responds. This model works for simple use cases, but falls short under high concurrency or when integrating with slow/unreliable dependencies.

Using **asynchronous execution with WebClient** helps solve this by leveraging **non-blocking I/O** and **reactive programming**, which allows our application to remain responsive while waiting for external service responses.

#### 1. **Improved Scalability with Fewer Resources**

In a blocking system, each HTTP call ties up a thread until a response is received. This limits scalability because threads are a limited and expensive resource.\
With async execution, **threads are released** immediately after making the call, allowing them to serve other requests.

> For example: In a thread-per-request model, handling 1000 concurrent calls might need 1000 threads. With non-blocking async, we can achieve the same with just a fraction.

#### 2. **Faster Aggregate Latency**

When calling multiple downstream services, synchronous calls are executed sequentially—each one adds to total latency. Asynchronous calls allow **parallel execution**, significantly reducing the overall response time.

> For instance: Two services each take 500ms to respond. Sync execution takes \~1s, while async in parallel takes \~500ms.

#### 3. **Higher Throughput**

Applications using asynchronous execution can handle **more concurrent requests** under the same hardware constraints, resulting in better throughput, especially under heavy load or spikes in traffic.

#### 4. **Responsive UI and APIs**

Async calls help **maintain responsiveness** in front-end APIs or UI components. Backend calls don't block the thread serving the user, so our system feels more reactive and snappy, even during slow downstream responses.

#### 5. **Essential for Event-Driven and Reactive Systems**

In reactive architectures (e.g., using Spring WebFlux), **non-blocking async** is not optional—it's foundational. It enables seamless data streaming, event chaining, and composition of async pipelines.

#### 6. **Better Error Isolation**

Async flows allow graceful degradation. If one service call fails, the system can recover using fallback data or skip the failed step without crashing the entire flow.

#### 7. **Optimal for Cloud and Microservices**

Async communication aligns well with microservices and cloud-native design, where:

* Network latency is variable
* Services might be temporarily unavailable
* Horizontal scalability is expected
* Observability and resilience are required (timeouts, retries, backpressure)

#### 8. **Resource Efficiency in Blocking Scenarios**

Even when working with blocking databases or legacy systems, combining async I/O with bounded blocking thread pools helps us avoid resource starvation and maintain control over thread usage.

## Core Mechanism

Asynchronous execution with **Spring WebClient** is powered by **Reactor**, the reactive programming library at the core of **Spring WebFlux**. The key idea is to **not block threads** while waiting for HTTP responses, but instead use **event-driven, non-blocking I/O**.

### What Actually Happens Internally?

When we make a WebClient call asynchronously:

```java
Mono<ResponseEntity<User>> mono = webClient.get()
    .uri("/users/42")
    .retrieve()
    .toEntity(User.class);
```

* The request is initiated, but the **current thread is not blocked**.
* A **Mono** (a publisher representing a single future result) is returned.
* The actual HTTP call happens in the background using **non-blocking Netty I/O**.
* When the response arrives, a **callback** is triggered to process the result.

We can then:

```java
mono.subscribe(response -> System.out.println(response.getBody()));
```

Or transform it:

```java
User user = mono.block(); // This forces blocking — avoid this in reactive systems
```

### **Components in the Mechanism**

<table><thead><tr><th width="246.45660400390625">Component</th><th>Role in Async Execution</th></tr></thead><tbody><tr><td><strong>WebClient</strong></td><td>Provides the fluent API to define HTTP requests. Non-blocking by default.</td></tr><tr><td><strong>Reactor Core</strong></td><td>Enables reactive streams using <code>Mono</code> (0..1) and <code>Flux</code> (0..N).</td></tr><tr><td><strong>Netty HTTP Client</strong></td><td>Underlying engine for non-blocking HTTP. Uses event-loop based I/O instead of thread-per-request.</td></tr><tr><td><strong>Event Loop (Reactor Netty)</strong></td><td>Manages I/O readiness events efficiently using few threads.</td></tr><tr><td><strong>Schedulers</strong></td><td>Allows shifting execution to different thread pools (e.g., bounded elastic for blocking DB calls).</td></tr><tr><td><strong>Backpressure Handling</strong></td><td>Controls how fast data is produced/consumed — critical in streaming data.</td></tr></tbody></table>

### **Mono vs Flux: The Core of WebClient Responses**

<table><thead><tr><th width="114.96356201171875">Type</th><th width="220.61810302734375">Description</th><th>Common Use</th></tr></thead><tbody><tr><td><code>Mono&#x3C;T></code></td><td>Emits <strong>0 or 1</strong> item.</td><td>REST calls, single responses (e.g., <code>GET /user/1</code>)</td></tr><tr><td><code>Flux&#x3C;T></code></td><td>Emits <strong>0 to N</strong> items.</td><td>Streaming APIs, Server-Sent Events (SSE)</td></tr></tbody></table>

These types enable **declarative async programming** without using low-level `Future` or callbacks manually.

## Typical Async Use Case in Enterprise App

Imagine an **order-service** in an e-commerce platform responsible for handling user orders. While processing a new order, it must:

* Fetch **user profile** from `user-service`
* Get **product availability** from `inventory-service`
* Calculate **discount** via `promotion-service`

These calls can be made **in parallel**, improving overall latency.

#### **Async Workflow Using WebClient**

```java
Mono<User> userMono = webClient.get()
    .uri("http://user-service/api/users/{id}", userId)
    .retrieve()
    .bodyToMono(User.class);

Mono<Product> productMono = webClient.get()
    .uri("http://inventory-service/api/products/{id}", productId)
    .retrieve()
    .bodyToMono(Product.class);

Mono<Discount> discountMono = webClient.get()
    .uri("http://promotion-service/api/discounts/{id}", promoCode)
    .retrieve()
    .bodyToMono(Discount.class);

// Combine responses asynchronously
Mono<OrderResponse> responseMono = Mono.zip(userMono, productMono, discountMono)
    .map(tuple -> {
        User user = tuple.getT1();
        Product product = tuple.getT2();
        Discount discount = tuple.getT3();
        return buildOrderResponse(user, product, discount);
    });
```

#### **Explanation**

* `Mono.zip(...)` combines multiple async responses.
* All service calls start immediately and run **concurrently**, not sequentially.
* Once all results are available, the transformation logic builds the final response.
* No thread is blocked while waiting for service calls.

## **Using CompletableFuture for Async Integration**

While `WebClient` is inherently asynchronous and reactive (based on Project Reactor), in many real-world enterprise applications, we might not use the full reactive stack (e.g., `Flux`, `Mono`) across layers. Instead, we may prefer using `CompletableFuture` for async composition, especially in layered or legacy architectures.

Spring WebClient can integrate smoothly with `CompletableFuture` by bridging the reactive and future-based async worlds.

### **Why Use `CompletableFuture` Instead of Mono/Flux Directly ?**

<table data-full-width="true"><thead><tr><th width="261.19012451171875">Criteria</th><th width="282.0633544921875">Using WebClient with Mono/Flux</th><th>Using WebClient with CompletableFuture</th></tr></thead><tbody><tr><td>Reactive chain across layers</td><td>Natural and efficient</td><td>Not ideal – requires adaptation</td></tr><tr><td>Integration with legacy codebases</td><td>Might be intrusive</td><td>Seamless, since <code>CompletableFuture</code> is JDK</td></tr><tr><td>Familiarity in team</td><td>Reactive APIs can have steep learning curve</td><td>CompletableFuture is widely known</td></tr><tr><td>Minimal dependencies</td><td>Requires Reactor</td><td>CompletableFuture is part of Java</td></tr><tr><td>Blocking downstream logic</td><td>Requires careful scheduling (boundedElastic etc.)</td><td>More straightforward to use imperatively</td></tr></tbody></table>

### **Behavior Comparison: WebClient vs CompletableFuture**

<table data-full-width="true"><thead><tr><th width="273.74652099609375">Aspect</th><th width="299.435791015625">WebClient (Mono/Flux)</th><th>WebClient + CompletableFuture</th></tr></thead><tbody><tr><td>Execution model</td><td>Fully non-blocking, reactive</td><td>Non-blocking WebClient, wrapped in future</td></tr><tr><td>Thread management</td><td>Event loop + schedulers</td><td>ForkJoinPool or custom thread pool</td></tr><tr><td>Integration fit</td><td>Best in reactive end-to-end pipelines</td><td>Easier in non-reactive or mixed codebases</td></tr><tr><td>Flow control</td><td>Reactive operators (<code>zip</code>, <code>flatMap</code>)</td><td>Java 8+ chaining (<code>thenCombine</code>, <code>thenApply</code>)</td></tr><tr><td>Backpressure</td><td>Supported</td><td>Not supported</td></tr><tr><td>Debuggability (for many devs)</td><td>Can be harder due to async chains</td><td>More familiar for developers</td></tr></tbody></table>

{% hint style="warning" %}
**When Not Ideal**

* When we are already using WebFlux or Project Reactor end-to-end
* When we need backpressure handling and advanced stream operations
* When our system must optimize for extreme throughput and responsiveness
{% endhint %}

### **Example: Parallel Service Calls using CompletableFuture and WebClient**

#### **Use Case**

In an order processing system:

* Fetch user info from `user-service`
* Get product details from `catalog-service`
* Call both concurrently, combine result

```java
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import java.util.concurrent.CompletableFuture;

@Service
public class OrderAggregationService {

    private final WebClient webClient;

    public OrderAggregationService(WebClient.Builder builder) {
        this.webClient = builder.baseUrl("http://localhost").build();
    }

    public CompletableFuture<User> getUser(String userId) {
        return webClient.get()
                .uri("http://user-service/api/users/{id}", userId)
                .retrieve()
                .bodyToMono(User.class)
                .toFuture();
    }

    public CompletableFuture<Product> getProduct(String productId) {
        return webClient.get()
                .uri("http://catalog-service/api/products/{id}", productId)
                .retrieve()
                .bodyToMono(Product.class)
                .toFuture();
    }

    public CompletableFuture<OrderResponse> getOrderDetails(String userId, String productId) {
        CompletableFuture<User> userFuture = getUser(userId);
        CompletableFuture<Product> productFuture = getProduct(productId);

        return userFuture.thenCombine(productFuture, (user, product) -> {
            return new OrderResponse(user, product);
        });
    }
}
```

#### **Explanation**

* `bodyToMono().toFuture()` bridges `Mono` to `CompletableFuture`
* `thenCombine()` merges both async results when both complete
* We can further chain additional async logic
* Thread pool usage is typically `ForkJoinPool`, but can be customized

## **Threading Consideration**

Spring’s `WebClient` is inherently **non-blocking** and **asynchronous**. However, the actual threading behavior depends on:

* Whether we are using it with `Mono`/`Flux` (reactive pipelines)
* Or wrapping it with `CompletableFuture`
* The broader application architecture (WebFlux vs MVC)

Understanding the threading model helps prevent common pitfalls like blocking on non-blocking threads, thread leaks, and unnecessary CPU starvation.

### **WebClient Execution Model: Reactor Context**

By default, WebClient uses **Reactor Netty** and follows the reactive programming model:

* **I/O threads** (aka _event loop threads_) are used for sending and receiving HTTP requests
* All operations like serialization, deserialization, transformation (`map`, `flatMap`, etc.) run on **reactor-managed threads**
* Heavy or blocking tasks should **never** run on these threads they must be offloaded using a scheduler

```java
Mono.just("data")
    .map(this::process) // stays on event loop thread
    .subscribe();
```

This works for light, fast operations. For blocking ones:

```java
Mono.fromCallable(this::blockingTask)
    .subscribeOn(Schedulers.boundedElastic()) // switches thread pool
```

### **CompletableFuture + WebClient: Thread Behavior**

When we convert from `Mono` to `CompletableFuture`:

```java
webClient.get()
    .uri("/api/data")
    .retrieve()
    .bodyToMono(MyResponse.class)
    .toFuture();
```

This operation:

* Executes the request on a Netty I/O thread
* Returns immediately (non-blocking)
* `CompletableFuture` completes when the data is available

**Downstream processing** (e.g., `.thenApply(...)`) executes on the **ForkJoinPool.commonPool** by default unless customized.

### **What Can Go Wrong ?**

<table data-full-width="true"><thead><tr><th>Scenario</th><th>Problem</th></tr></thead><tbody><tr><td>Calling <code>block()</code> on a reactive chain</td><td>Blocks Netty I/O thread → kills scalability</td></tr><tr><td>Performing blocking DB or file I/O in <code>.map()</code></td><td>Runs on event loop → causes performance bottleneck</td></tr><tr><td>Misconfigured <code>CompletableFuture</code> blocking on get()</td><td>Converts async to sync and ties up threads</td></tr><tr><td>Overloading common pool with CPU-heavy tasks</td><td>Starves thread pool for other async work</td></tr></tbody></table>

### **Thread Pool Guidelines**

| Use Case                                      | Recommended Thread Pool                   |
| --------------------------------------------- | ----------------------------------------- |
| Reactive non-blocking pipelines               | Reactor’s default (event loop + internal) |
| Blocking code in reactive chain               | `Schedulers.boundedElastic()`             |
| `CompletableFuture` heavy work                | Custom thread pool via `ExecutorService`  |
| Lightweight transformations (mapping, filter) | OK on common pool or event loop           |
