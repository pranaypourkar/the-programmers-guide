# Request-Response Pattern (Truly Asynchronous)

## About

The **Request-Response Pattern (Truly Asynchronous)** is a communication style where the client sends a request to a server or service **without waiting for an immediate, synchronous reply**.\
Instead, the server processes the request in the background and sends the response **later via a separate channel or callback mechanism**.

This approach is **different** from non-blocking I/O in synchronous communication:

* In **non-blocking synchronous** calls, the same connection eventually returns the result - but still within the same request lifecycle.
* In **truly asynchronous** communication, the response might arrive minutes, hours, or even days later, **and not necessarily over the same connection**.

{% hint style="info" %}
**Common Use Cases**

* Long-running workflows (e.g., large data processing, video transcoding).
* Business processes requiring human approval steps.
* Backend services that must integrate with **event-driven architectures**.
{% endhint %}

## Characteristics

* **Temporal Decoupling**
  * The request and response do **not** need to happen at the same time.
  * The client can move on to other tasks while the server processes the request.
* **Different Communication Channels**
  * The request is sent through one channel, and the response may arrive through another (e.g., request via REST, response via Webhook).
  * This allows the server to choose the most suitable channel for delivering results.
* **Correlation Mechanism**
  * Every request usually has a **Correlation ID** or **Request ID**.
  * The consumer uses this ID to match a response with its original request.
* **Long-Running Operation Friendly**
  * Perfect for workloads where processing may take seconds, minutes, or hours.
  * Avoids keeping network resources open for extended periods.
* **Failure Resilience**
  * Because communication is decoupled, temporary failures in one system do not immediately break the interaction.
  * Messages or responses can be retried or queued until delivery succeeds.
* **Event-Driven Integration**
  * Often combined with **message queues**, **publish-subscribe**, or **event streams** to deliver responses asynchronously.
* **Stateless Request Phase, Stateful Correlation Phase**
  * The request phase can be stateless, but the server or orchestration layer must keep track of request status until it is fulfilled.

## Execution Flow



