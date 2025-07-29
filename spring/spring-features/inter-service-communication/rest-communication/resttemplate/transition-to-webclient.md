# Transition to WebClient

## About

Spring introduced `WebClient` as a **non-blocking, reactive alternative** to `RestTemplate`. With increasing demand for **scalable**, **resilient**, and **high-performance** services, especially in microservices architecture, `WebClient` became the preferred choice in reactive and even traditional applications.

{% hint style="warning" %}
Spring has **not deprecated `RestTemplate` yet**, but it is considered **feature-frozen**.
{% endhint %}

## Why Transition ?

As systems scale and enterprise architectures shift toward **reactive**, **event-driven**, or **cloud-native** patterns, `RestTemplate` starts to become a bottleneck. It’s built on the traditional **blocking I/O** model, which limits concurrency and consumes more threads under load.

On the other hand, `WebClient` is part of **Spring WebFlux** and is designed for **non-blocking, reactive communication**, which aligns better with modern microservices and service mesh environments.

#### **1. Resource Efficiency**

* `RestTemplate` uses a **per-request thread model**, which is fine for small workloads but scales poorly under heavy load.
* `WebClient` runs on a **reactive, event-loop model**, allowing thousands of concurrent requests with a small number of threads.
* Enterprises aiming to run efficiently on Kubernetes, with limited memory and CPU, will benefit from this shift.

#### **2. Designed for Modern Architectures**

* Newer systems are often **microservice-based**, relying on high-volume inter-service calls.
* `WebClient` supports **backpressure**, **streaming**, and **non-blocking retries**, which are critical in distributed systems.
* It's suitable for **service meshes**, **API gateways**, and **reactive databases**, where latency and throughput matter.

#### **3. Native Support for Reactive and Asynchronous Programming**

* `WebClient` works natively with **Project Reactor**, returning `Mono` or `Flux`, and integrates seamlessly with **WebFlux**, **RSocket**, and **reactive data stores**.
* This enables **end-to-end non-blocking flows** from database to API response, which is not possible with `RestTemplate`.

#### **4. Full Support for Streaming Use Cases**

* Use cases like **server-sent events**, **chunked uploads/downloads**, or **real-time dashboards** require streaming support.
* `RestTemplate` doesn’t support this well, while `WebClient` provides direct support for **streaming responses**, **backpressure**, and **partial consumption of results**.

#### **5. Better Extensibility and Customization**

* `WebClient` uses a **fluent builder** and **filter-based API**, which is more modular and adaptable.
* Customizations such as:
  * Logging
  * Interceptors
  * Headers or auth injection
  * Retry strategies
  * Global error handling\
    are easier to implement in `WebClient`.

#### **6. Future-Proofing our Codebase**

* `RestTemplate` is in **maintenance mode**, meaning no new features, only bug/security fixes.
* `WebClient` is actively developed and will receive enhancements, integration with newer protocols (e.g., HTTP/2), and tooling support.
* Modern observability platforms and tracing libraries (like Sleuth, OpenTelemetry) offer first-class support for `WebClient`.

#### **7. Better Suitability for Resilience Patterns**

* Patterns like:
  * **Retry with backoff**
  * **Timeout handling**
  * **Circuit breakers**
  * **Fallback strategies**\
    are more naturally implemented with `WebClient` and tools like **Resilience4j**.

#### **8. Unified Client for All Scenarios**

* While `RestTemplate` is limited to HTTP and REST, `WebClient` works with:
  * REST
  * Streaming APIs
  * WebSocket
  * Server-Sent Events
  * Multipart uploads
* This makes it a **single client abstraction** for all communication needs, reducing fragmentation across teams.

## When to Transition ?

Transitioning to `WebClient` is not always about replacing everything at once. It’s about identifying **scenarios where the benefits of non-blocking, reactive HTTP communication outweigh the migration costs**. Below are real-world triggers that indicate it's time to shift.

#### **1. Performance Bottlenecks Under Load**

If our application starts experiencing:

* Thread pool exhaustion
* Increased latency during spikes
* High memory and CPU consumption under concurrent API traffic\
  ...it’s a strong signal that blocking I/O (`RestTemplate`) is hitting its limit. Transitioning to `WebClient` enables **efficient scaling with fewer resources**.

#### **2. High Concurrency Requirements**

If our service needs to:

* Call **many downstream services concurrently**
* Make **parallel API calls** (e.g., aggregators, facades)
* Perform **fire-and-forget notifications** or **long-polling**\
  …`WebClient` handles this with far fewer threads by leveraging **non-blocking async execution**.

#### **3. Moving Toward Reactive Stack**

If our application is:

* Using or planning to use **Spring WebFlux**
* Incorporating **reactive data sources** (e.g., R2DBC, reactive Mongo)
* Adopting reactive **message queues**, **Kafka**, or **WebSockets**\
  ...we should switch to `WebClient` to maintain a **fully reactive data flow**, avoiding thread-blocking points like `RestTemplate`.

#### **4. Need for Streaming and Advanced Protocol Support**

If we require

* **Server-sent events (SSE)**
* **Chunked transfer** or streaming large files
* Integration with **GraphQL over HTTP**, **gRPC-Web**, or **HTTP/2**\
  ...`WebClient` is the only viable client in the Spring ecosystem that supports these natively.

#### **5. Centralized Error Handling and Observability**

If our organization is maturing toward:

* **Standardized observability** using Sleuth, OpenTelemetry, Zipkin
* Implementing **retry logic**, **timeouts**, and **circuit breakers**
* Using **log enrichment** or **request tracing**\
  …`WebClient` allows for better integration with **Resilience4j**, **Micrometer**, and custom filters to build a robust HTTP client layer.

#### **6. Application is Gateway, Proxy, or Aggregator**

When our Spring Boot app is acting as a:

* **API Gateway**
* **Backend for frontend (BFF)**
* **Service aggregator**\
  … we are essentially performing **high-throughput, multi-destination communication**. `WebClient` is designed to maximize concurrency, minimize thread usage, and deliver **low latency** in such scenarios.

#### **7. Migrating to Cloud-Native or Serverless Architecture**

If We are deploying to:

* **Kubernetes**, where CPU and memory are constrained
* **Serverless functions**, which need minimal cold start time and fast I/O
* **Autoscaled containerized environments** where lightweight thread usage is critical\
  Then `WebClient` helps our services remain **scalable and responsive** without bloating resource usage.

#### **8. Starting a New Module or Greenfield Service**

When building:

* A **new microservice**
* An **internal tool**
* A **client SDK** or adapter\
  It’s better to start with `WebClient` from day one, since `RestTemplate` is in maintenance mode and lacks forward-looking capabilities.

#### **9. Integration with External Reactive Systems**

If external services (e.g., third-party APIs, streaming platforms) expose:

* **Streaming responses**
* **Reactive Web APIs**
* Expect **non-blocking backpressure support**\
  We will need `WebClient` to leverage full compatibility and throughput benefits.

#### **10. Incremental Migration of Legacy Codebase**

We don’t have to rip and replace everything. Introduce `WebClient`:

* For high-load or streaming endpoints
* Where retry/timeouts/circuit-breaking are must-haves
* In utility/service layers without touching the controller logic\
  This allows **gradual adoption** with measurable benefits.

## How to Transition ?

Transitioning from `RestTemplate` to `WebClient` should be **strategic and incremental**. It involves evaluating existing usage patterns, defining boundaries, preparing infrastructure, and gradually rolling out changes without disrupting the application.

This guide breaks down the process into **phases** with techniques and real-world practices.

#### **1. Assess Existing Usage**

Start with an inventory of current `RestTemplate` usages:

* Where are the HTTP calls happening?
* Which services are most frequently called?
* Are any calls parallel, streaming, or long-running?
* Are retry/timeouts or circuit breakers applied?

**Tip:** Use static code analysis tools or manual inspection to **categorize usage**.

#### **2. Identify Candidates for Migration**

Look for areas that:

* Face **performance or scaling limitations**
* Involve **parallel calls**, **batch processing**, or **high-frequency endpoints**
* Are already part of a **reactive pipeline**
* Need **fine-grained timeout, retry, or circuit-breaking logic**

**Don’t migrate everything at once** — start small and focus on **high-impact scenarios**.

#### **3. Introduce `WebClient` in Parallel**

There is **no need to delete `RestTemplate` immediately**. Spring allows both to coexist:

* Inject `WebClient.Builder` as a bean
* Use it selectively in service layers
* Build **utility wrappers** to standardize usage

This lets us experiment with `WebClient` without affecting stable paths.

#### **4. Build an Adapter Layer**

To abstract the usage:

* Create a reusable **HTTP client utility or adapter service**
* Internally use `WebClient`, but expose a **uniform API** to the rest of our app
* This makes **swapping the HTTP client** easier without ripple effects

**Example Adapter Interface:**

```java
public interface HttpClientAdapter {
    <T> Mono<T> get(String url, Class<T> responseType);
    <T, R> Mono<R> post(String url, T request, Class<R> responseType);
}
```

#### **5. Update Configuration**

Add a `WebClient` bean globally:

```java
@Configuration
public class WebClientConfig {
    @Bean
    public WebClient webClient(WebClient.Builder builder) {
        return builder
            .baseUrl("https://api.example.com")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }
}
```

Use `WebClient.Builder` for **customizations per service**, like timeouts, interceptors, authentication, or logging.

#### **6. Refactor Calls Gradually**

For each identified method or service:

* Replace `RestTemplate` call with `WebClient`
* Handle response using `Mono<T>` or `Flux<T>`
* Adapt result using `block()` if calling from imperative code temporarily
* Use `.onErrorResume()` or `.retry()` for resilience

**Before (RestTemplate):**

```java
ResponseEntity<User> response = restTemplate.getForEntity(url, User.class);
```

**After (WebClient):**

```java
User user = webClient.get()
    .uri(url)
    .retrieve()
    .bodyToMono(User.class)
    .block(); // Only if needed in imperative flow
```

#### **7. Handle Exception & Timeouts**

* Customize `ExchangeFilterFunction` to handle global errors
* Use `onStatus(...)` to manage HTTP status codes
* Set **timeouts** using `reactor.netty.http.client.HttpClient`
* Integrate with **Resilience4j** or **Spring Retry** for robust behavior

#### **8. Update Tests**

* Mock `WebClient` using `WebClient.Builder` with `ExchangeFunction`
* Use tools like **WireMock** or `MockWebServer` to simulate downstream APIs
* Avoid overusing `.block()` in tests; use `.subscribe()` or `StepVerifier` if we are already on reactive stack

#### **9. Train Our Team**

* Conduct internal knowledge-sharing or training sessions
* Share wrapper patterns and common pitfalls
* Document **when to use block() and when not to**

#### **10. Monitor and Iterate**

* Track error rates and latency after introducing `WebClient`
* Measure **thread usage**, **response time**, **GC impact**
* Use APM tools (e.g., New Relic, Grafana, Zipkin) to trace impact

