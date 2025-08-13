# Request-Response with Async Push Updates

## About

The **Request-Response with Async Push Updates** pattern is a **hybrid communication model** that combines the **predictability of synchronous requests** with the **real-time delivery** of asynchronous events.

In this approach:

1. A client sends a **standard HTTP request** to initiate a process.
2. The server responds **immediately** (or within a short time) with an acknowledgment that the request has been accepted and is being processed.
3. Once the background processing is complete, the server **actively pushes** the final result to the client via a **real-time channel** - such as **WebSockets**, **Server-Sent Events (SSE)**, **Webhooks**, or **push notifications**.

This eliminates the need for **polling** (periodically checking for results), reducing client overhead and improving user experience.

{% hint style="info" %}
* **Two phases**: Immediate acknowledgment + later push notification of results.
* **Client does not poll**; results are **pushed** by the server.
* Ideal when **processing time varies** and clients benefit from **instant updates upon completion**.
* Often used in **event-driven architectures** where the client can remain idle until notified.
{% endhint %}

{% hint style="success" %}
**Use Cases**

1. **E-commerce** — Order placement confirmation (sync) followed by shipment tracking updates (push).
2. **Document Processing** — Upload acknowledgment (sync) followed by push notification once processing completes.
3. **CI/CD Pipeline** — Build request acknowledgment (sync) followed by build result pushed to a Slack channel or webhook endpoint.
{% endhint %}

## Why It Matters in System Design ?

The **Request-Response with Async Push Updates** pattern addresses several real-world challenges in distributed systems and API design:

#### **1. Eliminates Inefficient Polling**

In traditional async flows without push, clients **poll** the server repeatedly to check if the result is ready.

* **Problem**: Wastes bandwidth, increases server load, and introduces unnecessary latency between result readiness and client awareness.
* **Solution**: Push updates allow the server to **notify instantly** when the work is done, ensuring the client learns about the result as soon as possible.

#### **2. Improves User Experience**

End-users value **immediacy and feedback**. This pattern provides:

* **Immediate acknowledgment** that their request has been accepted.
* **Later automatic updates** without requiring manual refresh or waiting on the same screen.\
  Example: Submitting a video for processing → Instant “Upload received” → Later notification “Your video is ready to watch.”

#### **3. Reduces Server Resource Strain**

Without push updates, multiple clients polling frequently can lead to **thundering herd** problems.

* With push notifications, the server only sends **targeted updates to relevant clients**, significantly lowering CPU and network usage.

#### **4. Supports Long-Running or Unpredictable Tasks**

Some tasks - such as **machine learning model training**, **data aggregation**, or **batch imports** — have unpredictable completion times.

* This pattern **decouples the request phase** from the **result delivery phase**, allowing processing to happen without blocking the client.

#### **5. Integrates Seamlessly with Event-Driven Architectures**

In microservices or event-driven systems, this pattern maps well to **publish-subscribe** or **event sourcing** models.

* The **initial sync acknowledgment** fits well in REST or gRPC request-response.
* The **push phase** can be implemented over Kafka consumers, WebSockets, SSE, or even message brokers like RabbitMQ.

## **Characteristics**

The **Request-Response with Async Push Updates** pattern blends the reliability of synchronous acknowledgment with the scalability of asynchronous event delivery. Its key traits include:

#### **1. Two-Phase Interaction**

* **Phase 1 (Synchronous Request-Response)**
  * Client sends a request.
  * Server validates it and returns an **immediate acknowledgment** with a tracking ID, correlation ID, or resource URL.
* **Phase 2 (Asynchronous Push Update)**
  * Server completes processing later.
  * Server pushes the result or a status change to the client via a push channel (WebSocket, SSE, Webhook, FCM, etc.).

**Example:**

```plaintext
Client → POST /process  
Server → 202 Accepted { trackingId: "abc123" }  
(Server processes task in background)  
Server → Push "task abc123 completed"
```

#### **2. Decoupled Processing and Notification**

* The server that accepts the request may **not** be the same component that sends the push update.
* Enables **horizontal scaling**, as processing can be offloaded to background workers or separate services.

#### **3. Correlation and State Tracking**

* A **unique identifier** is essential to match the push update with the original request.
* State transitions are often defined, e.g.:
  * `PENDING → PROCESSING → COMPLETED → FAILED`.
* Clients can also query status manually if needed (hybrid approach).

#### **4. Multiple Push Mechanisms Supported**

This pattern is **transport-agnostic** for the push phase. Common implementations include:

* **WebSockets** → Real-time bidirectional updates.
* **Server-Sent Events (SSE)** → Lightweight, one-way server-to-client stream.
* **Mobile Push Notifications** → Via Firebase Cloud Messaging (FCM) or Apple Push Notification service (APNs).
* **Webhooks** → Server-to-server callbacks.

#### **5. Resilience Against Network Fluctuations**

* Push updates can be retried if delivery fails (important for mobile or IoT devices).
* Some implementations buffer missed updates so the client can sync later.

#### **6. Flexible Client Behavior**

* Clients can **wait passively** for updates.
* Or, if no update is received after a threshold, they can **fallback to polling** using the tracking ID.

## **Execution Flow**

This pattern unfolds in **two distinct phases**, with clear hand-off between synchronous and asynchronous parts.

#### **Step 1 – Client Sends Request**

* The client initiates an operation (e.g., file processing, report generation, payment confirmation) by sending an HTTP or RPC request.
* The request contains **all required data** for the server to start processing.
* Example:

```http
POST /reports/generate
Content-Type: application/json
{
  "reportType": "sales",
  "dateRange": "2024-01-01 to 2024-12-31"
}
```

#### **Step 2 – Immediate Server Acknowledgment**

* The server **does not** block until the task is complete.
* Instead, it:
  1. Validates the request.
  2. Creates a job entry in a processing queue or database.
  3. Responds with:
     * **HTTP 202 Accepted** (most common).
     * A **tracking ID** or **resource URL**.
     * Optional initial status (e.g., `pending`).

```http
HTTP/1.1 202 Accepted
Content-Type: application/json
{
  "trackingId": "abc123",
  "status": "pending"
}
```

#### **Step 3 – Background Processing**

* The request is passed to an **asynchronous worker** (via message broker, job queue, or internal event bus).
* Workers process the job independently from the initial HTTP thread.
* The main request thread is already closed, freeing up server resources.

#### **Step 4 – Push Channel Subscription (Optional)**

* The client might:
  * **Open a WebSocket** connection to listen for the result.
  * **Register a webhook endpoint** where the server will send updates.
  * **Subscribe via SSE** for a live event stream.
* If the push channel was already established (e.g., WebSocket from login), no extra step is needed.

#### **Step 5 – Push Notification on Completion**

* When the job completes (or fails), the server sends a **push update**.
* The update includes:
  * **Tracking ID** (to match the original request).
  * Final status (`completed`, `failed`, `partial`).
  * Any result data or a URL to download it.

```json
{
  "trackingId": "abc123",
  "status": "completed",
  "downloadUrl": "/reports/download/abc123"
}
```

#### **Step 6 – Optional Client Polling Fallback**

* If the client did not receive a push update (network issues, missed connection), it can:
  * Query `/status/{trackingId}` for the latest job state.
  * Retry the push subscription if necessary.

#### **Step 7 – Post-Processing & Cleanup**

* The server may:
  * Store results temporarily for download.
  * Purge old jobs after a retention period.
  * Log completion events for auditing.

## **Advantages**

#### **1. Improved User Experience**

* Clients get **instant acknowledgment** without waiting for the entire process.
* Users can continue other actions while the system works in the background.
* Push updates feel **real-time**, avoiding constant page refreshes.

**Example:**\
A payment app confirms _"Transaction in Progress"_ immediately and later pushes _"Payment Successful"_ to the user’s device.

#### **2. Efficient Server Resource Usage**

* The request-handling thread is released **immediately after acknowledgment**.
* Long-running jobs move to **background workers** or queues, preventing HTTP timeouts.
* Better scalability under high load.

#### **3. Reduced Client Polling**

* Push mechanisms (WebSockets, SSE, webhooks) eliminate **excessive polling requests**.
* Less bandwidth and server load compared to constant polling.

#### **4. Flexible Delivery Options**

* Supports multiple push channels:
  * WebSockets for continuous connection.
  * SSE for lightweight one-way streaming.
  * Webhooks for server-to-server callbacks.
* Fallback to polling if push fails.

#### **5. Clear Job Tracking**

* Using **tracking IDs** allows:
  * Progress monitoring.
  * Retry or resume if necessary.
  * Auditing and debugging.

#### **6. Better for Unpredictable Processing Times**

* Works well for **long-running or variable-duration** tasks.
* No risk of client timeout before task completion.

#### **7. Decoupled Frontend and Backend**

* Backend doesn’t need to keep the HTTP session alive.
* Frontend receives results asynchronously through an independent channel.

## **Limitations**

#### **1. Increased Implementation Complexity**

* Requires **two communication channels**:
  * Initial synchronous acknowledgment.
  * Separate asynchronous push update.
* Must manage correlation between the request and the later update (usually via tracking IDs).

#### **2. Dependency on Push Mechanism Reliability**

* Push delivery may fail due to:
  * Network instability.
  * Client disconnection.
  * Webhook endpoint downtime.
* Requires **retry logic** and **dead-letter queues** for guaranteed delivery.

#### **3. Security Challenges**

* Push channels must be **authenticated** and **authorized**.
* Webhooks need:
  * Signature verification.
  * Replay attack prevention.
* WebSockets/SSE need secure token-based authentication.

#### **4. Handling Client State**

* Clients must be prepared for:
  * Receiving updates after a session is closed.
  * Receiving updates in the wrong order if multiple jobs are in flight.
* Requires **idempotent** and **order-aware** update handling.

#### **5. Harder Debugging & Monitoring**

* Since the processing and update happen **separately**, logs and traces must:
  * Correlate events across different services.
  * Include correlation IDs in all logs.
* Without proper observability, errors can be hard to track.

#### **6. Compatibility Limitations**

* Some environments (e.g., certain firewalls, older browsers) may:
  * Block WebSocket/SSE connections.
  * Limit persistent connections.
* May require fallback to polling, adding extra code paths.

#### **7. Delayed Feedback for Failures**

* If a job fails after acknowledgment, the client only learns during the push update.
* This may cause confusion if the initial acknowledgment message wasn’t clear about being _only provisional_.
