# Hybrid or Adaptive Patterns

## About

**Hybrid or Adaptive Communication Patterns** combine elements of **synchronous** and **asynchronous** approaches to leverage the strengths of both while minimizing their weaknesses.

In traditional designs, systems often commit to _either_ synchronous request-response (_immediate feedback, but tightly coupled_) or asynchronous event-based messaging (_loose coupling, but no instant confirmation_). However, in many real-world use cases, a **blend** of both patterns is required to balance **user experience**, **system performance**, and **reliability**.

{% hint style="success" %}
**Synchronous part:** Gives the client **immediate acknowledgment** or partial results to improve responsiveness.

**Asynchronous part:** Handles heavy processing, delayed updates, or background tasks without blocking the client.
{% endhint %}

## When Hybrid Patterns Are Useful ?

* **User Interfaces that need instant feedback** but still trigger long-running tasks in the background.
* **Mission-critical operations** where acknowledgment must be sent immediately, but final results may take time.
* **Systems requiring fallback strategies** - if asynchronous fails, fall back to synchronous; if synchronous is too slow, switch to async.
* **API designs where clients want both initial confirmation and final updates** (e.g., _payment processing with instant “order received” page but later “payment succeeded” notification_).

## Why it Matter in System Design ?

In modern distributed systems, it’s rare for all communication to be purely synchronous or purely asynchronous. The complexity of real-world business processes, coupled with user expectations for speed and reliability, demands **adaptability** in how services communicate.

Hybrid or adaptive patterns emerge as a **practical compromise** in the following scenarios:

#### **1. Balancing Speed and Completeness**

* **Problem:** Pure synchronous patterns provide instant results but can make users wait during long-running operations.
* **Solution:** Hybrid patterns give immediate, partial responses synchronously (e.g., _“Your request has been received”_), then complete the heavy work asynchronously in the background.

#### **2. Handling Unpredictable Processing Times**

* **Problem:** Some operations, like data aggregation from multiple slow services, may exceed acceptable request timeouts.
* **Solution:** The system sends a quick acknowledgment synchronously and pushes the final result via an asynchronous channel (e.g., Webhook, push notification, or WebSocket update).

#### **3. Improving Fault Tolerance**

* **Problem:** Synchronous workflows can fail entirely if one component is down.
* **Solution:** Hybrid designs allow the initial acknowledgment to be sent even if downstream systems are unavailable, with background retries and eventual consistency.

#### **4. Supporting Diverse Client Needs**

* **Problem:** Some clients (e.g., web browsers) expect immediate feedback, while others (e.g., batch processing systems) can wait.
* **Solution:** Hybrid patterns let the same API serve both - instant feedback for interactive clients and full async results for automated systems.

#### **5. Optimizing Resource Usage**

* **Problem:** Keeping synchronous threads blocked for long tasks consumes server resources.
* **Solution:** By offloading heavy work to asynchronous flows, systems reduce thread contention and scale more efficiently.

## **Characteristics**

Hybrid or adaptive communication patterns blend synchronous and asynchronous paradigms, inheriting traits from both while adding flexibility for real-world conditions. Their defining characteristics include:

#### **1. Dual-Phase Interaction**

* The communication typically happens in **two distinct stages**:
  1. **Initial Synchronous Phase** – Immediate response to acknowledge request receipt or provide preliminary results.
  2. **Follow-up Asynchronous Phase** – Completion notification or final result delivery after processing.
* **Example:** A payment API returns a _“Payment pending”_ response instantly, then sends a Webhook notification when the transaction clears.

#### **2. Context-Aware Communication**

* The pattern can **adapt its behavior** based on:
  * Client capabilities (e.g., can receive Webhooks or not)
  * Network conditions (e.g., fallback to polling if push fails)
  * Processing complexity (switch to async for heavier jobs)

#### **3. Decoupling of Long-Running Tasks**

* Complex or slow processes are **offloaded to background workers**, freeing the request-handling thread.
* This reduces API timeout issues and improves overall responsiveness.

#### **4. Multi-Channel Result Delivery**

* The final output can be sent through different channels:
  * Webhooks
  * WebSocket messages
  * Email/SMS notifications
  * Async polling endpoints

#### **5. Enhanced Resilience**

* Hybrid patterns **gracefully degrade** when async delivery mechanisms fail - the synchronous phase ensures that the client still knows the request was accepted.
* Retries and error-handling strategies are often built into the async phase.

#### **6. Flexibility in Client Experience**

* Interactive clients can display instant confirmation messages while the heavy lifting continues in the background.
* Automated systems can be configured to wait for or fetch the final results later.

## **Execution Flow**

A hybrid pattern combines synchronous acknowledgment with asynchronous completion, ensuring both quick responsiveness and eventual result delivery.

#### **1. Client Sends Initial Request**

* The client sends a request to the API endpoint.
* This request might include:
  * Request payload (data to process)
  * Callback URL (for Webhook notifications)
  * Client ID or tracking reference
*   **Example:**

    ```http
    POST /orders
    {
      "product_id": 12345,
      "quantity": 2,
      "callback_url": "https://client.example.com/order-status"
    }
    ```

#### **2. Immediate Processing (Synchronous Phase)**

* The API performs **lightweight validation**:
  * Checks request format and authentication.
  * Validates key business rules.
* If validation fails → returns error immediately.
* If validation succeeds → generates a **tracking ID** and schedules processing.
*   **Example Response:**

    ```http
    202 Accepted
    {
      "status": "processing",
      "tracking_id": "ORD-98765"
    }
    ```
* This ensures the client knows the request was received without waiting for full processing.

#### **3. Background or Deferred Processing (Asynchronous Phase)**

* The actual heavy work is done in background jobs or workers:
  * Data aggregation
  * External API calls
  * Complex computations
* Processing continues independently of the client’s request lifecycle.

#### **4. Completion Trigger**

* Once processing finishes:
  * **Push Model:** API sends a Webhook to the client’s `callback_url` with final status/results.
  * **Pull Model:** Client polls the `GET /orders/{tracking_id}` endpoint to fetch status.
*   **Example Webhook:**

    ```http
    POST https://client.example.com/order-status
    {
      "tracking_id": "ORD-98765",
      "status": "completed",
      "delivery_eta": "2025-08-15"
    }
    ```

#### **5. Client Handles Final Response**

* Client updates UI or triggers business logic upon receiving final completion notice.
* If Webhook fails, retries or fallback polling is used.

## **Advantages**

Hybrid patterns combine the **low-latency responsiveness of synchronous communication** with the **scalability and resilience of asynchronous processing**. This makes them highly suitable for modern distributed systems.

#### **1. Improved User Experience**

* **Why:** The client receives **immediate acknowledgment** rather than waiting for full processing to finish.
* **Impact:** Reduces perceived latency, keeping users engaged.
* **Example:** An e-commerce checkout returns “Order received” instantly, even if payment confirmation is processed later.

#### **2. Scalability for Long-Running Processes**

* **Why:** Heavy processing is offloaded to background jobs, preventing server bottlenecks.
* **Impact:** Servers can handle many incoming requests without being blocked by slow tasks.

#### **3. Fault Tolerance and Resilience**

* **Why:** If downstream services are temporarily unavailable, the job can be retried without blocking the client.
* **Impact:** Increased system robustness against transient failures.

#### **4. Flexible Notification Mechanisms**

* **Why:** Final results can be delivered via:
  * **Push:** Webhooks, message queues, event streaming.
  * **Pull:** Polling status endpoints.
* **Impact:** Supports different client capabilities and network environments.

#### **5. Reduced Client-Side Complexity for Long Tasks**

* **Why:** The client doesn't need to maintain a live connection for long-running work.
* **Impact:** Works well even for mobile devices or unreliable networks.

#### **6. Enhanced System Throughput**

* **Why:** Server resources are freed up quickly after acknowledgment.
* **Impact:** Higher throughput compared to purely synchronous blocking patterns.

#### **7. Easier Failure Recovery**

* **Why:** The processing system can reattempt failed jobs without re-sending the original request from the client.
* **Impact:** Lower risk of duplicate requests or lost data.

## **Limitations**

While hybrid approaches can deliver the best of both synchronous and asynchronous worlds, they also introduce **architectural complexity** and operational challenges that must be managed carefully.

#### **1. Increased Architectural Complexity**

* **Why:** We must design **two distinct flows** - immediate acknowledgment and deferred processing.
* **Impact:** Requires more components, such as message brokers, background workers, and notification services.
* **Example:** Instead of a single REST endpoint, we might have:
  * Initial synchronous API call.
  * Message queue for async processing.
  * Status-check API or Webhook for final result.

#### **2. Higher Operational Overhead**

* **Why:** Additional infrastructure (queues, event streaming, status tracking systems) must be deployed and monitored.
* **Impact:** Increases DevOps burden, especially in high-scale environments.

#### **3. Harder Debugging and Monitoring**

* **Why:** A request's journey is split across synchronous and asynchronous flows.
* **Impact:** Debugging failures may require correlating logs, metrics, and traces across multiple services and systems.
* **Mitigation:** Use **distributed tracing** with correlation IDs.

#### **4. Potential for Out-of-Sync States**

* **Why:** The client may receive immediate acknowledgment, but the final processing might fail.
* **Impact:** Client’s perceived state may differ from the actual server state.
* **Example:** User sees “Order Confirmed” but payment fails in the background.

#### **5. Complexity in Error Handling**

* **Why:** Must handle errors in both phases (acknowledgment phase and processing phase).
* **Impact:** Requires well-defined retry policies, idempotency keys, and compensation logic.

#### **6. Notification Delivery Challenges**

* **Why:** If using callbacks or push notifications, the client may be unavailable when the final result is ready.
* **Impact:** Results might be delayed or lost unless we have persistence and retry mechanisms.

#### **7. Testing Becomes More Complicated**

* **Why:** End-to-end tests must cover both immediate and delayed behaviors.
* **Impact:** Requires simulating various scenarios such as network failures, long delays, and partial processing.
