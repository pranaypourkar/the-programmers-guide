# Streaming & Real-Time APIs

## About

**Streaming & Real-Time APIs** enable the **continuous exchange of data** between clients and servers, allowing updates to be delivered immediately as they happen instead of waiting for a traditional request-response cycle.

In contrast to **batch** or **polling-based** models, streaming focuses on **persistent connections** where the server can push data at any moment. This makes them ideal for scenarios where **low latency** and **instant updates** are critical.

{% hint style="success" %}
**Examples**

* **Stock Trading Platforms** – delivering live market price changes within milliseconds.
* **Sports Scoreboards** – streaming live scores to users without page refreshes.
* **Chat Applications** – sending messages instantly to all connected users.
* **IoT Monitoring Dashboards** – continuous sensor readings updating in real-time.
* **Multiplayer Gaming** – instant movement, action, and state sync.
{% endhint %}

## **Differences from Traditional APIs**

<table data-full-width="true"><thead><tr><th width="188.70703125">Feature</th><th width="268.66015625">Traditional REST APIs</th><th>Streaming &#x26; Real-Time APIs</th></tr></thead><tbody><tr><td><strong>Communication Style</strong></td><td>Request → Response</td><td>Continuous, bidirectional or unidirectional stream</td></tr><tr><td><strong>Connection Lifecycle</strong></td><td>New connection for each request</td><td>Persistent, long-lived connection</td></tr><tr><td><strong>Latency</strong></td><td>Higher, due to repeated requests</td><td>Very low, near real-time</td></tr><tr><td><strong>Data Flow</strong></td><td>Client pulls data</td><td>Server pushes updates as they occur</td></tr><tr><td><strong>Use Cases</strong></td><td>CRUD operations, occasional updates</td><td>Live feeds, IoT data, collaborative apps</td></tr></tbody></table>

## **Why It Matters in System Design ?**

When designing modern distributed systems, **data freshness and responsiveness** are often as important as accuracy. Streaming & Real-Time APIs directly impact **system responsiveness, scalability, and user satisfaction**.

#### **1. Enabling Instant Decision-Making**

* **Scenario:** In **financial trading**, delays of even a few milliseconds can cause losses.
* **Impact:** Streaming ensures that decision-making systems have **up-to-the-second** data.

#### **2. Reducing Network Overhead**

* With **polling**, the client repeatedly sends requests (often returning no new data).
* Streaming:
  * Maintains a **single persistent connection**
  * Pushes **only when there’s new data**
  * Minimizes **redundant network calls** and saves bandwidth.

#### **3. Supporting Massive Concurrent Clients**

* Large-scale real-time applications (e.g., live sports apps, online gaming) must **scale to millions of users**.
* Streaming protocols like **WebSockets** or **SSE** are designed for **high concurrency** with minimal latency.

#### **4. Better User Experience (UX)**

* No manual refreshes.
* No visible delays between actions and feedback.
* Perceived application speed is significantly improved.

#### **5. Fits Event-Driven Architectures**

* Integrates naturally with **event-driven microservices**.
* Works seamlessly with **pub-sub** messaging layers (e.g., Kafka, RabbitMQ) for **real-time propagation** of events to clients.

#### **6. Critical for Certain Domains**

<table><thead><tr><th width="300.51171875">Domain</th><th>Why Real-Time is Essential</th></tr></thead><tbody><tr><td><strong>Healthcare</strong></td><td>Live patient monitoring in ICUs</td></tr><tr><td><strong>Transportation</strong></td><td>Live vehicle tracking and ETA updates</td></tr><tr><td><strong>E-commerce</strong></td><td>Real-time inventory updates</td></tr><tr><td><strong>Security</strong></td><td>Live surveillance feeds</td></tr></tbody></table>

### **System Design Considerations**

When integrating streaming into system architecture:

* **Scalability:** Can the infrastructure handle thousands/millions of persistent connections?
* **Resilience:** How does the system handle dropped connections or network partitions?
* **Security:** Are data streams encrypted? Is authentication persistent or token-based?
* **Fallbacks:** What happens when streaming is unavailable? (e.g., fallback to polling)

## Characteristics

Streaming & Real-Time APIs have a distinct set of traits that set them apart from traditional request-response mechanisms.

#### **1. Persistent Connections**

* **Definition:** The client and server maintain a long-lived connection instead of opening/closing one for every request.
* **Examples:** WebSockets, SSE, gRPC streaming.
* **Benefit:** Reduces handshake overhead, enabling low-latency communication.

#### **2. Server-Initiated Data Push**

* Unlike polling (where the client asks), here **the server pushes data** when an event occurs.
* Enables **instant updates** without unnecessary requests.

#### **3. Low Latency**

* Round-trip delays are minimized.
* Ideal for applications that require **millisecond-level responsiveness**.

#### **4. Continuous or Event-Driven Flow**

* **Continuous Streaming:** Constant data feed (e.g., live video streaming).
* **Event-Driven Streaming:** Data sent only when triggered by events (e.g., stock price change).

#### **5. Bi-Directional Communication (in some protocols)**

* **WebSockets** and **gRPC streaming** support two-way communication.
* Allows both **client and server** to send messages without waiting for the other.

#### **6. Scalability Challenges**

* Maintaining thousands/millions of open connections requires careful resource management.
* Solutions often involve:
  * **Connection pooling**
  * **Horizontal scaling**
  * **Load balancing for stateful connections**

#### **7. Real-Time Data Consistency**

* Data delivered is **fresh** at the time of sending.
* Still requires mechanisms for **ordering** and **reconciliation** if messages arrive out of sequence.

#### **8. Protocol-Dependent Reliability**

* **SSE** guarantees ordering but is one-way.
* **WebSockets** allow full-duplex but require custom logic for reconnection and ordering.
* **gRPC streaming** provides strong contract enforcement and type safety.

## Execution Flow

Although the exact steps differ by protocol (SSE, WebSockets, gRPC streaming), the general flow remains similar.

#### **1. Connection Establishment**

* **Client initiates a persistent connection** to the server.
* **Protocol negotiation** happens:
  * **WebSockets:** HTTP handshake upgraded to WebSocket protocol.
  * **SSE:** HTTP connection kept open with `Content-Type: text/event-stream`.
  * **gRPC Streaming:** HTTP/2 connection with streaming metadata.

#### **2. Authentication & Authorization**

* Typically handled **at connection time** to avoid repeated checks.
* Techniques:
  * API Keys
  * JWT tokens
  * OAuth 2.0 access tokens
* Security policies applied before streaming begins.

#### **3. Subscription or Stream Registration**

* The client **subscribes to specific channels/topics** or requests a certain data stream.
*   Example:

    ```json
    {
      "type": "subscribe",
      "topics": ["stock:TSLA", "stock:AAPL"]
    }
    ```

#### **4. Continuous Data Flow**

* **Server pushes updates** when events occur or at regular intervals.
* Data can be:
  * **Continuous feed:** Video, audio, sensor data.
  * **Event-driven updates:** Notifications, IoT alerts, financial data.

#### **5. Error Handling & Reconnection**

* If the connection drops:
  * **SSE:** Automatically attempts reconnection with `Last-Event-ID`.
  * **WebSockets:** Requires custom reconnection logic.
  * **gRPC:** Supports automatic retries in some cases.
* **Backoff strategies** (e.g., exponential backoff) prevent overload.

#### **6. Client Processing & UI Updates**

* The client application **parses incoming messages** and updates the UI or internal state instantly.
* Messages may be:
  * JSON
  * Binary (e.g., Protocol Buffers for gRPC)
  * Plain text (SSE events)

#### **7. Connection Termination**

* Connection can be closed by:
  * The client (e.g., user logs out)
  * The server (e.g., idle timeout, maintenance)
* Graceful closure includes sending a **final message or status code**.

#### **Flow Diagram**

```
[Client] ---Connect & Authenticate---> [Server]
   |                                       |
   |---Subscribe to Topics---------------->|
   |<--Push Data (events/stream)-----------|
   |<--Push Data (events/stream)-----------|
   | ...                                   |
   |---Close Connection------------------->|
```

## Advantages

Streaming and real-time APIs are designed for **instantaneous data delivery**, making them indispensable for applications where delays directly impact user experience or business value.

#### **1. Low Latency Data Delivery**

* **Benefit:** Events are pushed immediately after they occur—no waiting for polling intervals.
* **Example:**
  * A stock trading app receives market price changes within milliseconds.
  * A live multiplayer game updates player positions instantly.

#### **2. Reduced Network Overhead**

* **Benefit:** No need for repeated HTTP polling requests.
* **Example:**
  * Instead of sending `GET /updates` every 2 seconds, the server sends updates only when something changes.
  * IoT sensors send data only when a threshold is crossed, saving bandwidth.

#### **3. Improved User Experience**

* **Benefit:** Users get fresh content **as it happens**, without manual refresh.
* **Example:**
  * Social media platforms like Twitter push new tweets instantly.
  * Messaging apps like WhatsApp deliver “seen” and “typing…” indicators in real time.

#### **4. Efficient Server Resource Utilization**

* **Benefit:** Server processes fewer redundant requests, focusing only on meaningful events.
* **Example:**
  * An online sports score provider sends updates only when the score changes, avoiding millions of unnecessary requests.

#### **5. Enables New Classes of Applications**

* **Benefit:** Certain business cases are **only possible** with real-time streams.
* **Example:**
  * **Live analytics dashboards** that visualize changing metrics.
  * **Collaborative editing tools** like Google Docs, where multiple users edit a file simultaneously.

#### **6. Better Scalability with Event-Driven Backends**

* **Benefit:** Real-time APIs integrate well with event-driven and microservices architectures.
* **Example:**
  * Kafka or RabbitMQ-based backend pushing updates to thousands of clients without polling.

#### **7. Supports Bi-Directional Communication (WebSockets / gRPC)**

* **Benefit:** Not just server → client; clients can send messages instantly to the server.
* **Example:**
  * In an online auction platform, bidders send bids instantly while receiving live updates.

#### **8. Lower Latency for Time-Sensitive Industries**

* **Benefit:** Critical in domains where **milliseconds matter**.
* **Example:**
  * Financial trading systems (high-frequency trading).
  * Real-time health monitoring in hospitals.

## **Limitations**

While streaming and real-time APIs offer impressive benefits, they also introduce **technical, architectural, and operational challenges** that teams must consider before adoption.

#### **1. Increased Complexity in Development**

* **Challenge:** Implementing streaming protocols like WebSockets, SSE, or gRPC streaming requires more intricate client-server logic compared to simple REST.
* **Example:**
  * REST API: Send a `GET` request and get a single response.
  * WebSockets: Maintain a persistent connection, handle reconnections, and manage multiple event types in one channel.
* **Impact:** Developers must handle **connection management**, **event parsing**, and **error handling** differently.

#### **2. Higher Infrastructure Costs**

* **Challenge:** Persistent connections consume **more memory and CPU resources** per client.
* **Example:**
  * A chat app with 500,000 concurrent WebSocket connections may require significant horizontal scaling or specialized infrastructure.
* **Impact:** Cloud providers may charge more for load balancers or servers that support large numbers of concurrent open connections.

#### **3. Scalability Challenges**

* **Challenge:** Scaling a system that handles **hundreds of thousands or millions of concurrent connections** is more complex than scaling stateless HTTP REST APIs.
* **Example:**
  * We may need to use **connection-aware load balancers** (like NGINX, HAProxy) and **distributed pub/sub systems** (like Kafka) to broadcast updates efficiently.
* **Impact:** This adds operational overhead and requires new scaling patterns.

#### **4. Network Reliability Issues**

* **Challenge:** Persistent connections are more susceptible to **network interruptions**, NAT timeouts, or firewall restrictions.
* **Example:**
  * Mobile networks often drop idle WebSocket connections after a few minutes, requiring clients to reconnect seamlessly.
* **Impact:** Requires robust **retry logic**, **session resumption**, and **offline queuing**.

#### **5. Browser & Client Limitations**

* **Challenge:**
  * Older browsers may not support SSE or WebSockets.
  * gRPC streaming is not fully supported in all browsers without additional proxies.
* **Impact:** May need **fallback mechanisms** like long polling for compatibility.

#### **6. Data Security & Privacy Concerns**

* **Challenge:** Continuous connections mean **attack surfaces stay open** longer.
* **Example:**
  * An attacker could flood the connection with malicious events.
* **Impact:** Requires **strict authentication**, **rate limiting**, and **message validation**.

#### **7. Debugging & Monitoring Complexity**

* **Challenge:**
  * Unlike HTTP requests (which can be logged individually), streaming sends multiple events over one connection.
* **Impact:** Requires specialized **real-time monitoring tools** (e.g., WebSocket inspectors, Kafka monitoring dashboards).

#### **8. Potential Over-Engineering**

* **Challenge:** Some use cases **don’t actually need real-time streaming**.
* **Example:**
  * A weather app that updates every 10 minutes doesn’t require WebSockets—REST polling is simpler and cheaper.
* **Impact:** Overuse of streaming can increase complexity without delivering tangible user benefits.

## Common Technologies & Protocols Used

Streaming and real-time APIs can be implemented using multiple technologies, each with its own strengths, trade-offs, and best-fit scenarios.

#### **1. Server-Sent Events (SSE)**

* **Description:**
  * A unidirectional protocol where the **server pushes events** to the client over an HTTP connection.
  * Uses **HTTP/1.1** and keeps a single connection open for continuous updates.
* **When to Use:**
  * Real-time notifications, dashboards, live score updates, stock tickers.
* **Advantages:**
  * Simple to implement in browsers (`EventSource` API).
  * Automatically handles reconnections.
* **Limitations:**
  * One-way only (server → client).
  * Limited browser buffering control.
*   **Example:**

    ```javascript
    const source = new EventSource('/events');
    source.onmessage = (event) => console.log(event.data);
    ```

#### **2. WebSockets**

* **Description:**
  * A **full-duplex** communication protocol over a single TCP connection.
  * Allows **bi-directional** real-time messaging between client and server.
* **When to Use:**
  * Chat applications, multiplayer games, collaborative editing tools.
* **Advantages:**
  * Very low latency.
  * Works for high-frequency updates in both directions.
* **Limitations:**
  * Requires more complex connection management.
  * May face issues with some corporate firewalls or proxies.
* **Example Flow:**
  * Client sends handshake via HTTP → Connection upgrades to WebSocket → Persistent two-way communication.

#### **3. gRPC Streaming**

* **Description:**
  * A modern, high-performance **RPC framework** using HTTP/2 and Protocol Buffers.
  * Supports:
    * **Server streaming:** Server sends multiple responses for a single request.
    * **Client streaming:** Client sends multiple requests for a single response.
    * **Bi-directional streaming:** Both send data streams at the same time.
* **When to Use:**
  * Internal microservice communication, IoT data pipelines, high-performance backend-to-backend connections.
* **Advantages:**
  * Strong typing and contract-based APIs (via `.proto` files).
  * Very efficient binary serialization.
* **Limitations:**
  * Browser support is limited without a proxy.
  * Requires Protocol Buffers knowledge.

#### **4. GraphQL Subscriptions**

* **Description:**
  * A **GraphQL-based real-time mechanism** for subscribing to specific data changes.
  * Typically implemented using WebSockets.
* **When to Use:**
  * Applications already using GraphQL that need live data updates (e.g., real-time UI refresh).
* **Advantages:**
  * Flexible queries — clients request only the fields they need.
  * Integrates naturally with existing GraphQL schema.
* **Limitations:**
  * More complex server setup.
  * Still maturing in terms of tooling compared to REST/WebSockets.

#### **5. MQTT (Message Queuing Telemetry Transport)**

* **Description:**
  * A lightweight **publish-subscribe** protocol designed for unreliable or constrained networks.
  * Uses TCP (or WebSockets for browsers).
* **When to Use:**
  * IoT devices, sensors, real-time telemetry.
* **Advantages:**
  * Extremely low overhead.
  * Supports persistent sessions and QoS levels.
* **Limitations:**
  * Requires a dedicated MQTT broker.
  * Not as widely supported natively in browsers.

#### **6. Kafka / Pulsar (Streaming Platforms)**

* **Description:**
  * Distributed event streaming platforms designed for massive scale.
  * Can integrate with WebSockets, SSE, or gRPC for client delivery.
* **When to Use:**
  * High-throughput data pipelines, event-driven architectures, large-scale analytics.
* **Advantages:**
  * Durable message storage.
  * Scales to millions of events per second.
* **Limitations:**
  * High operational complexity.
  * More suited for backend-to-backend streaming than direct browser use.
