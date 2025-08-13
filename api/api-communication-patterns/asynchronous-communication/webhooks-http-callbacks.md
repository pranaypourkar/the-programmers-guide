# Webhooks (HTTP Callbacks)

## About

A **webhook** is a lightweight, event-driven communication mechanism where a server proactively **pushes** information to another system via an **HTTP(S) request** whenever a specific event occurs.\
Instead of polling an API at regular intervals to check for updates, the receiving system simply waits for the sending system to notify it with a **callback request**.

At its core, a webhook works like this:

1. **Consumer registers a callback URL** (endpoint) with the provider system.
2. **Provider triggers HTTP POST requests** to that URL when events happen.
3. The **payload** of the POST request carries the event details, usually in JSON, XML, or form data.

## **Nature of Webhooks**

* **One-way push** – initiated by the provider, no request from consumer needed at event time.
* **Event-driven** – tied to specific business or system events (e.g., “payment succeeded”, “user signed up”).
* **Stateless** – each webhook call is independent; no session is maintained between calls.
* **Near real-time** – latency depends on provider’s processing and network speed.
* **Uses standard HTTP(S)** – easy to integrate across different tech stacks.

{% hint style="success" %}
**Example Flow**

* **GitHub → Jenkins**: GitHub sends a webhook to Jenkins when code is pushed, triggering a CI pipeline.
* **Stripe → E-commerce App**: Stripe sends a webhook when a payment is confirmed so the store can update order status.
{% endhint %}

## Why Webhooks Matter in System Design ?

Webhooks solve a fundamental efficiency and scalability challenge in distributed systems: **keeping components in sync without constant polling**.

#### **1. Efficiency over Polling**

Without webhooks, a consumer system might need to send periodic **poll requests** (e.g., every 5 seconds) to check if a new event has happened.

* This wastes **network bandwidth** and **processing power** when no changes occur.
* Webhooks replace this with a **push-based model**, delivering updates **only when necessary**.

**Example:**\
Instead of an e-commerce app asking a payment gateway every few seconds if a payment is complete, the gateway sends a webhook immediately after the transaction is confirmed.

#### **2. Near Real-Time User Experience**

Webhooks enable **instant reactions** to events, improving responsiveness in applications.

* Notifications, chat systems, CI/CD triggers, and order tracking all benefit from **millisecond-to-second latency** delivery.

**Example:**\
When a customer updates their shipping address, a webhook instantly notifies the delivery partner to adjust the route.

#### **3. Decoupled System Integration**

Webhooks allow systems to **communicate without being tightly coupled**.

* The provider does not need to know how the consumer works internally.
* The consumer just needs to expose a publicly accessible HTTP endpoint.

This reduces **dependency management** and allows each system to evolve independently.

#### **4. Cost Savings**

* **Fewer API calls** mean lower **operational costs**, especially for services with API request charges.
* Reduced load on servers, freeing resources for other operations.

#### **5. Broad Applicability**

Webhooks are useful in many scenarios:

* **E-commerce** – Order status updates, payment confirmations.
* **DevOps** – CI/CD pipelines triggered by code changes.
* **Social Media** – Real-time activity feeds and notifications.
* **IoT** – Device alerts sent to cloud services.

## Characteristics

Webhooks are **event-driven HTTP requests** sent from one application (the **provider**) to another (the **consumer**) when a predefined event occurs. They have a set of defining characteristics that influence how they are implemented and maintained.

#### **1. Event-Driven**

* Webhooks are **triggered by specific events** in the provider system.
* Events are predefined (e.g., _payment\_success_, _user\_signup_, _file\_uploaded_).
* The consumer only receives updates **when relevant activity occurs**.

**Example:**\
A Git repository sends a webhook whenever a new commit is pushed to the main branch.

#### **2. Push-Based Communication**

* Unlike polling, the provider **pushes** data to the consumer over HTTP without waiting for a request.
* The provider calls the consumer’s endpoint directly, often with an HTTP POST request containing the event payload.

#### **3. HTTP as the Transport Layer**

* Webhooks use **HTTP/HTTPS** for delivery.
* Commonly **POST** is used (with JSON/XML payloads).
* Consumers expose an **HTTP endpoint (URL)** to receive the callback.

#### **4. Asynchronous by Nature**

* Webhooks operate **asynchronously**, meaning the consumer is notified **after the event** occurs without blocking the provider’s primary process.
* Delivery attempts may happen in **parallel** with other provider tasks.

#### **5. Lightweight Payloads**

* Payloads typically contain **only relevant event data** (often as JSON).
* Some providers send **minimal payloads** with a reference ID, requiring the consumer to make a follow-up API call for full details.

#### **6. Security Considerations**

* **Authentication & Verification**: To prevent spoofing, providers often use:
  * **Secret tokens** in headers
  * **HMAC signatures** for payload validation
* **HTTPS** is recommended to encrypt transmission.

#### **7. Delivery Guarantees**

* Most webhook systems follow **at-least-once delivery**:
  * If the consumer does not respond with `2xx`, the provider retries delivery (sometimes with exponential backoff).
* **Ordering is not guaranteed** unless the provider specifically supports it.

#### **8. Statelessness**

* Each webhook request should be **self-contained**, not relying on previous requests.
* This ensures resilience if a consumer misses earlier events.

#### **9. Error Handling and Retries**

* Providers typically retry failed deliveries several times before marking them as failed.
* Consumers should respond quickly with a **2xx status code** to acknowledge receipt.

## Execution Flow

Webhooks work like a **phone call between two systems** - when something happens in the provider’s system, it “calls” the consumer’s system to tell it right away.\
Here’s the step-by-step flow in a clear, practical way:

#### **1. Event Occurrence in the Provider System**

* **Definition:** This is the **triggering condition** inside the provider application that kicks off the webhook process.
* Events can be:
  * **System events** (server logs an error, scheduled job completes)
  * **User actions** (customer places an order, form is submitted)
  * **Third-party interactions** (payment gateway confirms a transaction)
* **Importance:** Webhooks are **event-driven** - without a meaningful event, there’s no reason to send a webhook.
* **Design Tip:** Providers should clearly define a **list of webhook-supported events** in their documentation so consumers can subscribe only to relevant ones.

**Example:** In GitHub, the event `push` is triggered whenever code is pushed to a repository.

#### **2. Event Captured & Translated into Payload**

* Once the event occurs, the provider’s internal event-handling mechanism:
  1. **Captures event details** from the system’s core business logic.
  2. **Formats the data** into a **standardized structure** (usually JSON, sometimes XML or form-encoded).
  3. **Adds metadata** for debugging and security, such as:
     * Event **timestamp**
     * Event **unique ID** (useful for detecting duplicates)
     * Webhook **API version** (ensures consumer parses data correctly)
     * **Digital signature** (HMAC or similar) for verification
* **Why This Matters:** Without structured and predictable data, the consumer system risks incorrect parsing or misinterpretation.

**Example payload snippet:**

```json
{
  "id": "evt_56f7a",
  "type": "payment_succeeded",
  "created": 1691405092,
  "data": {
    "orderId": "ORD-10045",
    "amount": 125.50,
    "currency": "USD"
  }
}
```

#### **3. HTTP Request Sent to Consumer Endpoint**

* **Method:** Webhooks are almost always sent as **HTTP POST** requests because:
  * POST allows sending structured bodies (JSON/XML)
  * It matches the semantics of “creating a new resource” (in this case, creating a new event in the consumer’s system)
* **Headers:** Critical for:
  * **Authentication** (e.g., `Authorization: Bearer <token>`)
  * **Security** (HMAC signature to detect tampering)
  * **Content Negotiation** (`Content-Type: application/json`)
* **Why POST Instead of GET:** GET is meant for retrieval and often cached; POST is more appropriate for sending new data.
* **Reliability Considerations:**
  * The provider must handle **network failures** gracefully.
  * Delivery should be **idempotent** - resending the same webhook shouldn’t create duplicate effects.

#### **4. Consumer Endpoint Processes the Event**

* **Validation:**
  * First, check **authenticity** by verifying the signature/token to ensure the request really came from the provider.
  * Also check **timestamp freshness** to prevent replay attacks.
* **Parsing:**
  * Convert JSON/XML into application objects.
  * Validate schema (using tools like JSON Schema).
* **Business Logic Execution:**
  * Based on the event type, execute the corresponding workflow.
  * Example: `payment_succeeded` → Mark order as paid, send invoice.
* **Security Considerations:**
  * Never trust incoming data blindly.
  * Apply rate limiting to avoid denial-of-service from malformed webhook floods.

#### **5. Consumer Sends HTTP Response**

* **Purpose:** This lets the provider know the webhook was **received and processed successfully**.
* **Best Practice:**
  * Always respond **quickly** (often <5 seconds).
  * If processing is long-running, **acknowledge immediately** and process asynchronously in the background.
* **Typical Responses:**
  * `200 OK` → Accepted and processed
  * `202 Accepted` → Accepted but will process later
  * `4xx` → Consumer error (e.g., bad request)
  * `5xx` → Temporary server failure
* **Why Quick Responses Matter:** If the provider times out waiting, it will assume the webhook failed and may retry unnecessarily.

#### **6. Provider Handles Acknowledgment**

* **If Success (2xx):**
  * The event is marked as “delivered” in the provider’s system.
  * Some providers log delivery metrics (latency, retries).
* **If Failure (Non-2xx or Timeout):**
  * Provider schedules a **retry**.
  * Retry policies often include:
    * **Exponential backoff** (1s, 2s, 4s, 8s…)
    * **Retry limit** (e.g., max 10 attempts)
    * **Dead-letter queue** if retries fail consistently.
* **Importance of Idempotency:** Retried webhooks should not cause duplicate actions. Consumers should check the event ID before processing.

#### **7. Optional: Consumer Makes Follow-up API Call**

* **Why:**
  * To reduce payload size, providers sometimes send only the **event ID** in the webhook.
  * Consumer then **calls the provider’s API** to fetch complete details.
* **Trade-off:**
  * Smaller payloads = faster delivery, but adds one more HTTP call.
*   **Example:**

    ```json
    { "id": "evt_56f7a", "type": "payment_succeeded" }
    ```

    → Consumer calls `/events/evt_56f7a` to retrieve full data.

## Advantages

Webhooks bring several architectural and operational benefits that make them a preferred choice for **event-driven integrations**. Below are the key advantages, along with **why they matter** in real-world system design.

#### **1. Real-Time Event Delivery**

* **What:** Webhooks notify consumers **immediately** when an event occurs, without polling.
* **Why It Matters:**
  * Reduces latency - consumers react instantly.
  * Improves user experience in time-sensitive workflows (e.g., chat apps, order updates, payment confirmations).
* **Example:** Payment gateway instantly informs an e-commerce site that a payment was successful, allowing immediate order processing.
* **Contrast with Polling:** Instead of hitting the API every minute to “check” for updates, the provider tells us exactly when something changes.

#### **2. Reduced Server Load & Bandwidth Usage**

* **What:** Since consumers don’t have to poll repeatedly, **fewer API calls** are made.
* **Why It Matters:**
  * Saves infrastructure costs on both sides.
  * Makes integration more scalable.
* **Example:**
  * Polling: 10,000 clients × 60 requests/hour = 600,000 requests/hour.
  * Webhooks: 10,000 clients receive **only relevant** events - possibly 10,000 requests/day.
* **Impact:** Less noise in system logs, reduced congestion, and smaller attack surface.

#### **3. Decoupled System Architecture**

* **What:** Provider and consumer are loosely coupled - the provider only needs to send an HTTP request, without knowing how the consumer processes it.
* **Why It Matters:**
  * Systems can evolve independently.
  * Easier to integrate with multiple third-party systems without redesign.
* **Example:** A CRM system can send the same customer update webhook to multiple downstream analytics, billing, and email systems without changing internal business logic.

#### **4. Better User Experience**

* **What:** Users see changes reflected **immediately** in the UI.
* **Why It Matters:**
  * Reduces perceived system lag.
  * Increases trust, especially in financial or operational systems where delays feel risky.
* **Example:** GitHub shows a pull request status change in seconds because the CI service sends a webhook as soon as the build finishes.

#### **5. Event-Driven Scalability**

* **What:** Webhooks integrate naturally into **event-driven architectures** where services react to discrete events instead of continuously polling for changes.
* **Why It Matters:**
  * Efficient scaling - resources are used only when needed.
  * Works well with message queues, serverless triggers, and streaming systems.
* **Example:** A warehouse system can automatically trigger a restocking workflow when a “low inventory” webhook is received.

#### **6. Flexible Consumer Implementation**

* **What:** Consumers can process events however they like - synchronously, asynchronously, or store them for later.
* **Why It Matters:**
  * Gives integration partners control over processing logic.
  * Supports lightweight triggers or heavy-duty background workflows.
* **Example:**
  * Fast action: Send SMS immediately on webhook receive.
  * Slow action: Save to database and process in nightly batch.

#### **7. Cost Efficiency for SaaS Providers**

* **What:** Providers send updates **only when necessary**, minimizing compute cycles and API infrastructure costs.
* **Why It Matters:**
  * Especially important in high-scale SaaS, where millions of customers may need updates.
  * Aligns with **pay-per-request** billing models in cloud platforms (AWS Lambda, API Gateway).
* **Example:** Slack sends webhooks for message events instead of letting apps hammer its API for new messages.

#### **8. Easier Debugging & Auditing**

* **What:** Since each webhook delivery is an HTTP transaction, it can be logged, traced, and replayed.
* **Why It Matters:**
  * Providers can offer a **delivery history** for developers to troubleshoot.
  * Consumers can replay failed events from logs or dead-letter queues.
* **Example:** Stripe’s developer dashboard shows every webhook sent, its payload, HTTP status, and retry attempts.

#### **9. Works Across Firewalls**

* **What:** As long as the consumer exposes a public HTTPS endpoint, webhooks can work without complex network setups.
* **Why It Matters:**
  * Avoids the need for VPNs or persistent socket connections.
  * Widely compatible with microservices, legacy systems, and SaaS platforms.
* **Example:** A corporate ERP system behind a firewall can still receive webhooks via a reverse proxy or API gateway.

## Limitations

While webhooks are powerful for **real-time, event-driven communication**, they are not a silver bullet. They introduce **reliability, security, and operational challenges** that architects and developers must carefully consider.

#### **1. Delivery Reliability Challenges**

* **What:** Webhooks rely on **outbound HTTP requests** from the provider to the consumer’s endpoint. If the consumer is temporarily unavailable, events can be lost unless retry logic exists.
* **Why It Matters:**
  * Network blips, server downtime, or DNS issues can cause missed events.
  * Not all providers implement durable retry queues.
* **Example:** If a payment provider sends a “payment completed” webhook but our server is down, we may never receive it unless they retry.
* **Mitigation:**
  * Use **idempotent** event handling.
  * Implement retry with exponential backoff on provider side.
  * Use message queues (e.g., RabbitMQ, Kafka) as buffers.

#### **2. No Guaranteed Ordering**

* **What:** Events might arrive **out of order** due to retries, network delays, or multiple processing nodes.
* **Why It Matters:**
  * Can cause incorrect state if consumer assumes sequential delivery.
* **Example:** “Order shipped” might arrive before “Order packed” if the latter was delayed in transmission.
* **Mitigation:**
  * Include **timestamps** and sequence numbers in webhook payloads.
  * Consumer should **reorder** or validate state before applying.

#### **3. One-Way Communication**

* **What:** Standard webhooks are **push-only**; the provider does not expect a payload from the consumer beyond a success/failure status.
* **Why It Matters:**
  * If we need additional data, we must call the provider’s API separately.
* **Example:** A “user created” webhook may not include full profile details - we need to make a GET API call to fetch them.
* **Mitigation:**
  * Use webhook as a **trigger**, then fetch complete data via API.

#### **4. Security Concerns**

* **What:** Webhooks expose an **HTTP endpoint** to the internet, making it a potential attack vector.
* **Why It Matters:**
  * Attackers can flood endpoints with fake requests.
  * Without proper authentication, our system might accept spoofed events.
* **Example:** A malicious actor sends a fake “payment success” event to trick our system.
* **Mitigation:**
  * Use **HMAC signatures**, mutual TLS, or OAuth 2.0 for validation.
  * Enforce IP whitelisting where possible.
  * Implement **rate limiting** and payload validation.

#### **5. Limited Error Feedback**

* **What:** Providers typically treat webhooks as “fire-and-forget”  they don’t give detailed feedback on processing results.
* **Why It Matters:**
  * Provider only knows if the HTTP response was `2xx` or not.
  * If the consumer logic fails after returning `200 OK`, the provider won’t retry.
* **Example:** We acknowledge receipt but later fail to store data due to DB error - event is lost.
* **Mitigation:**
  * Process **asynchronously** after acknowledgment.
  * Log failures internally for recovery.

#### **6. Scalability & Burst Traffic Issues**

* **What:** High-volume providers can send **bursts of events** that overwhelm consumers.
* **Why It Matters:**
  * Consumer might experience latency spikes or crashes.
* **Example:** A ticketing system sending thousands of “ticket sold” events during peak sale time.
* **Mitigation:**
  * Use a **load balancer** or **queue buffer** in front of webhook processors.
  * Implement backpressure handling.

#### **7. Difficult Local Development & Testing**

* **What:** Webhooks require a **publicly accessible URL**, which complicates local testing.
* **Why It Matters:**
  * Developers must tunnel traffic from provider to local machine.
* **Example:** We can’t easily test Stripe webhook locally without using tools like `ngrok`.
* **Mitigation:**
  * Use **request tunneling tools** (ngrok, localtunnel).
  * Simulate webhook payloads using provider’s testing features.

#### **8. Dependency on External Availability**

* **What:** Consumers rely on the provider’s **uptime and correctness** of event sending.
* **Why It Matters:**
  * If provider experiences a bug or outage, our downstream systems may go stale.
* **Example:** Provider silently stops sending “user updated” events due to a release bug.
* **Mitigation:**
  * Implement **watchdog processes** that detect event silence and switch to polling temporarily.

#### **9. No Built-In Replay or History (Unless Provided)**

* **What:** Once a webhook is missed, it’s gone unless provider supports replay.
* **Why It Matters:**
  * Event loss can cause incomplete state.
* **Example:** Payment provider only sends each event once; if missed, we must manually reconcile from transaction logs.
* **Mitigation:**
  * Choose providers that support event replay APIs.
  * Maintain reconciliation jobs to ensure consistency.

#### **10. Increased Operational Complexity**

* **What:** Managing multiple webhooks across different providers adds monitoring, retries, authentication, and versioning overhead.
* **Why It Matters:**
  * More moving parts = more failure points.
* **Example:** A SaaS app integrating with 5 different webhooks needs a centralized handler, security checks, and alerting for each.
* **Mitigation:**
  * Use a **central webhook gateway** for all integrations.
  * Standardize payload validation and error handling.

## Common Technologies & Protocols Used

Webhooks are built on top of **standard web technologies**, but effective implementation often requires additional tools, protocols, and patterns for **security, reliability, and development convenience**.

#### **1. HTTP & HTTPS**

* **Core Protocol:**
  * Webhooks are delivered over **HTTP/1.1** or **HTTPS**.
  * HTTPS is strongly recommended (often mandatory) to protect against data interception and tampering.
* **Common HTTP Methods:**
  * **`POST`** – Most common, with JSON/XML payload in the body.
  * **`GET`** – Rare; usually for basic “ping” type webhooks.
  * **`PUT`/`PATCH`** – Used by some APIs for idempotent updates.
* **HTTP Status Codes:**
  * `2xx` – Success (usually `200 OK` or `202 Accepted`).
  * `4xx` – Consumer-side issue (invalid request, unauthorized).
  * `5xx` – Consumer server error (triggers retries in many systems).

#### **2. Data Formats**

* **JSON** – Most common due to simplicity and universal parsing support.
* **XML** – Older or enterprise APIs (e.g., some SOAP-compatible systems).
* **Form-Encoded** – Sometimes used in legacy integrations.
* **Protobuf / Avro** – Rare for public webhooks, but used in high-performance internal systems.

#### **3. Security Mechanisms**

Webhooks require **strong authentication** since they’re open endpoints.

<table><thead><tr><th width="222.4296875">Method</th><th width="312.75">Description</th><th>Example Use Case</th></tr></thead><tbody><tr><td><strong>HMAC Signatures</strong></td><td>Provider sends a cryptographic hash of payload + secret, consumer verifies it.</td><td>Stripe, GitHub</td></tr><tr><td><strong>Basic Auth</strong></td><td>Username/password in request headers.</td><td>Internal services</td></tr><tr><td><strong>Bearer Tokens (OAuth 2.0)</strong></td><td>Token in <code>Authorization</code> header.</td><td>Modern APIs</td></tr><tr><td><strong>Mutual TLS (mTLS)</strong></td><td>Both sides exchange certificates.</td><td>High-security enterprise</td></tr><tr><td><strong>IP Whitelisting</strong></td><td>Only allow known provider IPs.</td><td>Internal or static-IP providers</td></tr></tbody></table>

#### **4. Retry & Delivery Guarantees**

* **Retry Policies:**
  * **Exponential Backoff:** Delay between retries grows after each failure.
  * **Fixed Interval:** Retry every `n` seconds.
* **Maximum Retry Attempts:** To avoid infinite loops, providers limit attempts (e.g., 24 hours with exponential backoff).
* **Dead Letter Queues:** Failed deliveries are sent to a holding queue for later review.

#### **5. Development & Testing Tools**

Since webhooks require public endpoints, developers use tunneling or simulation tools:

* **`ngrok`** – Creates a public HTTPS tunnel to local machine.
* **Localtunnel** – Similar to ngrok, free and open source.
* **Webhook.site** – Public endpoint to inspect incoming webhook payloads.
* **PostBin / RequestBin** – Store and display incoming requests for debugging.
* **Provider Simulators** – Stripe CLI, GitHub webhook tester, Twilio’s webhook replay tool.

#### **6. Message Queues & Buffers**

To make webhook handling more reliable:

* **RabbitMQ** – Queue incoming events for async processing.
* **Kafka** – For high-throughput event streaming.
* **AWS SQS** – Managed queue to decouple provider from consumer processing.
* **Redis Streams** – In-memory event buffering.

#### **7. Event Standards**

While many providers have custom payloads, some follow common eventing standards:

* **CloudEvents** (CNCF) – Vendor-neutral event specification.
* **Activity Streams** – JSON format for social and activity-related data.
* **JSON:API** – API format that can be adapted for webhook events.

#### **8. Logging & Monitoring Tools**

For operational visibility:

* **ELK Stack (Elasticsearch, Logstash, Kibana)** – Centralized logging.
* **Prometheus + Grafana** – Metrics & alerting.
* **Sentry / New Relic** – Error monitoring.

#### **9. Common Provider Implementations**

Some popular services and how they deliver webhooks:

* **GitHub** – JSON payload + HMAC signature.
* **Stripe** – JSON payload, versioned events, signature verification.
* **Slack** – JSON payload, signed secret.
* **Twilio** – Form-encoded or JSON, with request validation.
* **Shopify** – JSON payload with HMAC verification.

#### **10. Example Webhook Request**

```http
POST /webhook/payment HTTP/1.1
Host: api.example.com
Content-Type: application/json
X-Signature: sha256=2c5f0f0e88a9d...

{
  "event": "payment.success",
  "id": "evt_123456",
  "timestamp": "2025-08-13T08:15:30Z",
  "data": {
    "amount": 1500,
    "currency": "USD",
    "transaction_id": "txn_98765"
  }
}
```

* **Security:** HMAC in `X-Signature` header.
* **Versioning:** Often included in `event` name or headers.
* **Timestamp:** Used for ordering and replay protection.
