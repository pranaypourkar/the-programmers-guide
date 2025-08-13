# Sync-Async Failover Patterns

## **About**

The **Sync-Async Failover Pattern** is a **resilience and flexibility strategy** where a system primarily operates using **synchronous communication** but can **gracefully fall back to asynchronous processing** if immediate responses are not possible.

This pattern is often used in scenarios where:

* **Low latency** is preferred when conditions are optimal.
* **High availability** and **guaranteed processing** are still required when services are slow or overloaded.

It blends **real-time responsiveness** with **fault tolerance**, ensuring the user’s request is never lost even if the synchronous path is unavailable.

## **How It Works ?**

1. **Normal Path (Synchronous)**
   * The system attempts to process the request immediately and return the result within the same connection.
   * If everything works fine, the client gets an instant response.
2. **Failover Path (Asynchronous)**
   * If the synchronous operation fails or times out:
     * The request is **queued** for background processing.
     * The client receives an acknowledgment with a tracking ID.
     * The result is sent later via polling, WebSocket, SSE, or webhook.

## **Where This Is Common ?**

* **Payment gateways** - Immediate confirmation if possible, but fall back to async confirmation for high-latency payment processors.
* **Search engines** - Provide partial results quickly, and send full results later.
* **E-commerce** - Instant stock check; async follow-up if inventory service is overloaded.
* **Customer support systems** - Try to fetch ticket status in real time, fallback to async update if CRM system is slow.

## Why This Pattern Matters in System Design ?

The **Sync-Async Failover Pattern** addresses one of the biggest challenges in distributed systems — **balancing responsiveness with reliability**.

In real-world applications, network latency, service outages, or processing bottlenecks can cause synchronous requests to fail or time out. Without a failover strategy, this results in:

* **User frustration** (due to waiting or repeated retries)
* **Lost transactions** (if requests are dropped)
* **Poor system availability** (as failures cascade)

By introducing an asynchronous fallback, systems can maintain **service continuity** even when the primary synchronous path is degraded.

Some of the Key Reasons include -

1. **Improved User Experience**
   * Users still get a confirmation that their request is accepted, even if processing is delayed.
   * Reduces the perception of downtime.
2. **Increased Reliability**
   * Prevents data loss by queuing requests when the synchronous path fails.
3. **Operational Flexibility**
   * Allows services to handle varying loads without rejecting requests outright.
4. **Resilience Against Downstream Failures**
   * If a dependent service is slow or unavailable, the system can switch to async and keep functioning.
5. **Scalable Load Management**
   * During traffic spikes, failover can be triggered to reduce strain on synchronous endpoints.

This pattern is particularly valuable in **mission-critical** systems where failure to process a request at all is worse than delayed processing - for example, payments, order placement, or healthcare data submissions.

## **Characteristics**

1. **Dual Communication Modes**
   * Supports **synchronous request-response** as the primary mode for fast acknowledgment.
   * Switches to **asynchronous queuing** when the sync path is unavailable or under heavy load.
2. **Automatic Failover Trigger**
   * Monitors the health and latency of synchronous services.
   * If a threshold is exceeded (e.g., response time > 3 seconds or error rate > 10%), the system automatically routes requests to the async queue.
3. **Guaranteed Request Capture**
   * Even in failover mode, requests are persisted (in message queues, logs, or databases) to prevent data loss.
4. **Deferred Processing**
   * Async requests are processed later, either when the synchronous service is restored or during off-peak hours.
5. **User Notification Mechanism**
   * In failover mode, users are informed that the request has been accepted but processing is delayed.
   * Optional tracking links or callback notifications can be provided.
6. **Health-Based Reversion**
   * Once the synchronous service recovers, the system reverts to sync mode without manual intervention.
7. **Load-Adaptive Behavior**
   * Can be configured to failover not only on hard failures but also during **load shedding** scenarios to preserve overall system stability.

## **Execution Flow**

1. **Client Initiates a Request (Synchronous Mode)**
   * The client sends a request expecting an immediate response.
   * Example: A user submits a payment on an e-commerce site.
2. **Primary Sync Path Attempt**
   * The API gateway or service router tries to process the request through the synchronous service.
   * Real-time validation and processing are attempted (e.g., calling the payment gateway API directly).
3. **Health & Performance Check**
   * Before processing completes, the system checks:
     * **Service health** (is it online?)
     * **Latency thresholds** (is it taking too long?)
     * **Error rate** (are many requests failing?)
   * If metrics are normal, the request proceeds synchronously.
4. **Failover Decision Trigger**
   * If the sync service fails or exceeds thresholds, the request is **rerouted** to an asynchronous processing mechanism.
   * Failover can be **hard** (service is down) or **soft** (system is overloaded).
5. **Async Capture and Acknowledgment**
   * The request payload is placed into a durable store such as:
     * Message queue (Kafka, RabbitMQ)
     * Persistent event log
     * Temporary database table
   * The client receives a quick acknowledgment:
     * “Your request has been received and will be processed shortly.”
6. **Background Processing**
   * Workers or consumers process the queued requests when resources are available.
   * Processing can be:
     * Triggered immediately when the sync service recovers.
     * Scheduled for off-peak hours to reduce load.
7. **Result Notification (Optional)**
   * Once processed, the system can notify the client via:
     * Email or SMS
     * Webhook callback
     * Client polling endpoint
8. **Auto-Reversion to Sync Mode**
   * The failover monitor detects when the primary sync service is healthy again.
   * The system automatically routes new requests back to synchronous processing.
   * The async queue continues draining any pending requests until empty.

## **Advantages**

1. **High Availability During Outages**
   * Even if the synchronous service fails, the system still accepts requests via the asynchronous fallback.
   * Prevents complete downtime and ensures business continuity.
   * Example: Flight booking system still records seat reservations during payment gateway outages.
2. **Improved User Experience Under Load**
   * Instead of a timeout or 500 error, users receive confirmation that their request was accepted for later processing.
   * Reduces frustration and support calls.
3. **Graceful Performance Degradation**
   * When traffic spikes, the system gracefully shifts to async mode without hard failures.
   * Allows services to recover without being overwhelmed.
4. **Better Resource Utilization**
   * During failover, the workload can be processed in batches, using off-peak resources more efficiently.
   * Reduces operational costs by avoiding over-provisioning for peak loads.
5. **Flexibility in Recovery Time**
   * Async mode allows teams to prioritize critical transactions or reorder processing based on business rules.
   * Example: Banking systems might process high-value transactions first after failover.
6. **Seamless Transition for Clients**
   * With proper API design, clients often don’t need to know whether they’re in sync or async mode.
   * Minimizes integration complexity.
7. **Enhanced Fault Isolation**
   * Failures in the synchronous path don’t cascade to bring down the whole system.
   * The async queue acts as a buffer to contain issues.

## **Limitations**

1. **Increased System Complexity**
   * Requires implementing **two distinct execution paths** (sync and async) and logic to decide when to switch.
   * More moving parts means more potential failure points.
2. **Data Consistency Challenges**
   * During async fallback, responses may be delayed, and clients might see **stale data**.
   * Potential risk of double-processing if sync retry logic is not carefully managed.
3. **Operational Overhead**
   * Requires **monitoring both paths** and ensuring the failover logic works correctly under real-world conditions.
   * Failover testing can be more complex compared to simpler patterns.
4. **Delayed Feedback to Users**
   * In async mode, users may not know the **final status** of their request immediately.
   * This can impact workflows that require instant confirmation.
5. **Queue Management Issues**
   * Async mode typically relies on a message queue; if queues fill up or fail, requests could be lost or severely delayed.
   * Requires careful sizing and monitoring.
6. **Switching Criteria Can Be Tricky**
   * Determining **exactly when** to failover and when to revert to sync mode without oscillating is a challenge.
   * Poorly tuned thresholds can lead to unnecessary failovers or delays in recovery.
7. **Testing and Maintenance Burden**
   * Must test **both normal mode and failover mode** regularly to avoid discovering issues only in emergencies.
   * Infrequently used paths (like async fallback) often have hidden bugs.
