# Request-Response Pattern (Non-blocking)

## About

The **Request–Response Pattern (Non-blocking)** is a communication style where a client sends a request and expects a **single corresponding response**, but the underlying processing uses **asynchronous I/O** or **reactive programming** techniques to avoid blocking threads while waiting for that response.

It is often confused with _true asynchronous communication_, but the distinction lies in the **interaction contract**:

* The communication is still **synchronous at the protocol and application flow level** - every request has exactly one corresponding response, and the client considers the operation complete only after receiving it.
* The _non-blocking_ aspect applies to the **threading and I/O model**, not to the business workflow.

## **Why It’s Under Synchronous Communication ?**

In non-blocking request–response:

1. **Request–response coupling remains** - the client sends a request and waits (logically) for that same response.
2. **Flow completion is tied to the response** - the request is not considered done until the corresponding response is received.
3. **Order and mapping are preserved** - responses map directly to specific requests, unlike in event-driven or fire-and-forget models.

The main change from _blocking_ synchronous communication is in **how resources are managed**:

* **Blocking sync** → Thread is occupied until the response arrives.
* **Non-blocking sync** → Thread is freed to handle other work; callbacks, promises, or reactive streams handle the response when ready.

## Characteristics

* **One-to-One Request–Response Mapping**
  * Each request from the client produces exactly one response from the server.
  * The correlation between request and response is maintained, often using IDs or connection context.
  * Even though execution is non-blocking, the contract remains synchronous in terms of logical completion.
* **Non-Blocking I/O**
  * Server threads are **not blocked** while waiting for network or disk I/O operations to complete.
  * Utilizes **event loops**, **selectors**, or **reactive streams** to handle I/O events.
  * Greatly improves scalability by reducing the number of threads needed to handle many concurrent requests.
* **Callback or Reactive Handling**
  * Responses are handled via **callbacks**, **promises**, **futures**, or **reactive operators**.
  * The main execution thread can return to serve other requests, with the response being processed when data is ready.
* **Predictable Completion**
  * Despite the non-blocking execution, the interaction is **bounded** - the client expects and waits (logically) for the server’s response before proceeding to the next step in the workflow.
  * Timeouts and error handling are still crucial because the client is aware that a result _must_ arrive.
* **Efficient Resource Utilization**
  * Especially useful for high-latency I/O operations (e.g., calling external APIs, database queries).
  * Allows a small number of threads to serve a very large number of concurrent connections.
* **Protocol Independence**
  * Can be implemented over **HTTP/1.1**, **HTTP/2**, **gRPC unary calls**, or custom binary protocols.
  * The “non-blocking” nature is an implementation detail, not visible in the protocol itself.
* **Order Preservation (Per Connection)**
  * Responses are usually sent in the order requests are received on the same connection, unless pipelining or multiplexing is involved.
  * Multiplexed protocols like HTTP/2 allow out-of-order responses, but still maintain correlation via stream IDs.
* **Transparent to Consumers**
  * Consumers may not even know they’re talking to a non-blocking server - the API contract is identical to a blocking one.
  * The difference lies entirely in the server/client execution model and scalability profile.

## Execution Flow

Instead of holding a thread hostage until the I/O operation completes (blocking), the server registers interest in the I/O event and releases the thread to handle other tasks. When the I/O operation finishes, the server’s event loop or callback system picks up the result and sends the response.

#### **Step-by-Step Flow**

1. **Client Sends Request**
   * The client issues a request over the network (HTTP, gRPC, etc.).
   * A connection (persistent or short-lived) is established.
2. **Server Accepts Request**
   * A small pool of I/O worker threads or an **event loop** receives the request.
   * The request is parsed and validated without blocking.
3. **Task Dispatch without Blocking**
   * The server initiates the downstream work (e.g., DB query, external API call) asynchronously.
   * Instead of waiting for the result, it **registers a callback** or uses a **reactive pipeline** to process the response when ready.
   * The thread is freed immediately to handle other incoming requests.
4. **Event Loop or Scheduler Waits**
   * An event loop monitors multiple pending I/O operations (using **selectors** or **reactors**).
   * No busy-waiting - the loop only reacts when I/O is ready.
5. **I/O Completion Trigger**
   * When the downstream operation finishes, the registered callback/reactive subscriber is notified.
   * This happens on an event loop thread or a dedicated callback thread.
6. **Response Preparation**
   * The server serializes the result (JSON, Protobuf, etc.).
   * Any transformations, filtering, or mapping happen in this phase - often in a non-blocking way.
7. **Response Sent to Client**
   * The prepared response is written to the socket asynchronously.
   * HTTP/2 or gRPC may multiplex responses so they can be sent out of order without interference.
8. **Client Receives Response**
   * From the client’s point of view, this is still a standard request–response - it just happens faster and allows higher concurrency on the server side.

## **Differences from Blocking Flow**

<table><thead><tr><th width="180.77734375">Aspect</th><th width="245.39453125">Blocking Flow</th><th>Non-blocking Flow</th></tr></thead><tbody><tr><td>Thread per Request</td><td>Yes</td><td>No - few threads handle many requests</td></tr><tr><td>Waiting for I/O</td><td>Thread is idle while waiting</td><td>Thread is freed, event loop waits</td></tr><tr><td>Scalability</td><td>Limited by thread pool size</td><td>Much higher scalability</td></tr><tr><td>Latency</td><td>Higher under load</td><td>Lower under high concurrency</td></tr><tr><td>Complexity</td><td>Simple code</td><td>Requires async patterns (callbacks, reactive)</td></tr></tbody></table>

## Advantages

* **Higher Concurrency with Fewer Resources**
  * Non-blocking I/O enables a **small pool of threads** to handle thousands of concurrent requests.
  * This is critical in high-traffic systems (e.g., chat servers, streaming platforms, API gateways).
* **Better Scalability**
  * Because threads are freed when waiting for I/O, the server can scale **vertically** (more concurrent requests per machine) and **horizontally** (multiple servers with async handling).
* **Lower Latency Under Load**
  * Blocking systems often degrade significantly under heavy load due to thread starvation.
  * Non-blocking systems **maintain responsiveness** even when many operations are pending.
* **Efficient Resource Utilization**
  * Less CPU overhead from **context switching** between large numbers of threads.
  * Lower memory footprint because fewer thread stacks are allocated.
* **Improved Throughput**
  * Non-blocking execution can process more requests per second since idle waiting time is eliminated.
  * Especially beneficial for **I/O-heavy workloads** like database queries, remote API calls, or file reads/writes.
* **Better User Experience in Interactive Systems**
  * End-users receive **faster feedback** because small, quick operations are not delayed by slower requests.
  * For example, in a web server, static content can be served instantly while long-running operations happen in parallel.
* **Supports Reactive and Streaming Architectures**
  * Naturally aligns with **Reactive Streams**, **Project Reactor**, and **RxJava** for backpressure handling and event-driven data flows.
* **Suited for Modern Protocols**
  * Works exceptionally well with **HTTP/2 multiplexing** and **gRPC streaming**, where multiple requests share a single connection.

## Limitations

* **Higher Implementation Complexity**
  * Non-blocking code often requires **callbacks, promises, or reactive streams**, which can be harder to write, read, and maintain compared to simple blocking code.
  * Complex control flows can lead to **callback hell** or deeply nested asynchronous chains.
* **Steeper Learning Curve for Developers**
  * Developers familiar only with synchronous programming must adapt to **event-driven, state-machine-like thinking**.
  * Debugging asynchronous flows requires a deeper understanding of concurrency and scheduling.
* **Harder Debugging and Tracing**
  * Stack traces are often fragmented because execution is **spread across multiple callbacks or event loops**.
  * Requires specialized tools for tracing asynchronous execution (e.g., Reactor Debug Agent, async profilers).
* **Potential for Race Conditions and Concurrency Bugs**
  * Non-blocking doesn’t mean thread-safe; shared state can still cause **race conditions**.
  * Synchronization needs careful handling, especially when multiple async tasks touch shared data.
* **Latency Spikes from Event Loop Blocking**
  * If **any task in the event loop** performs a blocking operation (e.g., synchronous DB query), it delays all other tasks queued behind it.
  * This defeats the purpose of non-blocking I/O.
* **More Complex Error Handling**
  * Exceptions can’t simply be thrown and caught like in synchronous code - they must be propagated through **callbacks, futures, or reactive streams**.
* **Not Always Beneficial for CPU-Bound Tasks**
  * Non-blocking is primarily for I/O-bound workloads.
  * For CPU-intensive operations (e.g., data processing, encryption), non-blocking offers little advantage and might even introduce unnecessary complexity.
* **Possible Memory Pressure from Queued Requests**
  * Large numbers of pending async requests may accumulate in memory if upstream producers **overwhelm** the system, requiring **backpressure management**.

## Common Technologies & Protocols Used

Non-blocking request–response implementations rely on technologies that **asynchronously manage I/O** while still preserving the request–response interaction model. These span **application-level frameworks**, **protocol capabilities**, and **reactive libraries**.

#### **1. HTTP/1.1 with Asynchronous APIs**

* While HTTP/1.1 itself is synchronous in semantics, many frameworks provide **non-blocking request handling** by delegating I/O operations to event loops.
* **Examples:**
  * **Spring WebFlux** - Uses Project Reactor and runs on Netty for non-blocking HTTP handling.
  * **Vert.x** - Event-driven, non-blocking toolkit for building reactive applications.
  * **JAX-RS Async APIs** - `@Suspended AsyncResponse` for delayed responses.

#### **2. HTTP/2**

* Multiplexing allows multiple requests over the same TCP connection without blocking each other.
* Useful for **non-blocking REST APIs** or gRPC over HTTP/2.
* **Examples:**
  * gRPC with async stubs.
  * Jetty HTTP/2 Server with async servlets.

#### **3. Non-blocking I/O Libraries**

* **Java NIO** (`java.nio.channels`) - Underpins most modern non-blocking servers by enabling **selectors**, **channels**, and **buffers**.
* **Netty** - High-performance non-blocking networking framework used by Spring WebFlux, Play Framework, and gRPC Java.
* **Akka HTTP** - Actor-based non-blocking HTTP server and client.

#### **4. Reactive Programming Frameworks**

* Provide **stream-based, backpressure-aware** handling of asynchronous data flows.
* **Examples:**
  * **Project Reactor** (used in Spring WebFlux).
  * **RxJava** - Reactive extensions for Java with async operators.
  * **Mutiny** - Reactive programming for Quarkus.

#### **5. Servlet 3.0+ Async Processing**

* Introduced `AsyncContext` in the Java Servlet API to allow requests to be processed **asynchronously** without tying up container threads.
* Implementations:
  * Tomcat’s `AsyncServlet`.
  * Jetty async APIs.

#### **6. Protocols with Built-in Asynchronous Support**

* **WebSockets** (for bidirectional async but still request–response capable).
* **gRPC async** stubs for request–response over HTTP/2.
* **AMQP / Kafka RPC-style** - While typically used for messaging, they can be configured for request–response.

#### **7. Cloud-Native Non-blocking Platforms**

* **AWS API Gateway with Lambda (async mode)** - Handles requests asynchronously while still providing HTTP request–response semantics.
* **Azure Functions / Google Cloud Functions** - Event-loop based handling for non-blocking responses.
