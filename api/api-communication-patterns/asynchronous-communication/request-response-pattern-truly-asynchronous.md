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

#### **1. Client Sends the Initial Request**

* The client initiates a request to the server (e.g., POST `/processReport` with input data).
* Instead of processing immediately, the server **acknowledges receipt** and assigns a **Correlation ID**.
*   Example Response:

    ```json
    {
      "requestId": "abc-123",
      "status": "ACCEPTED",
      "message": "Report generation started"
    }
    ```

#### **2. Server Processes in the Background**

* The server places the request in a **background job queue** (e.g., RabbitMQ, Kafka, AWS SQS).
* A worker service picks up the job and processes it **asynchronously**.
* This could take seconds, minutes, or longer depending on workload.

#### **3. Client Polls or Waits for Notification**

There are **two common approaches** for receiving the final response:

**A. Client Polling**

* The client periodically queries the server for the status:\
  `GET /status/abc-123`
* Server replies with progress info or final result.

**B. Server Push / Callback**

* Once processing is done, the server **sends a callback** to the client (e.g., Webhook, event message).
* This avoids polling and delivers results immediately.

#### **4. Final Response Delivered**

*   The client finally gets the **completed data**:

    ```json
    {
      "requestId": "abc-123",
      "status": "COMPLETED",
      "reportUrl": "https://example.com/reports/abc-123.pdf"
    }
    ```

## Advantages

#### **1. Improved User Experience**

* The client gets an **instant acknowledgment** instead of waiting for the entire operation to finish.
* Allows UI to remain **responsive**, avoiding browser timeouts or mobile app freezes.
* Example: A “Your request is being processed” message with a progress bar.

#### **2. Handles Long-Running Tasks**

* Ideal for operations like:
  * Generating large reports
  * Video rendering
  * Machine learning model training
  * Large batch data imports
* Prevents **HTTP connection timeouts** and reduces server-side resource locking.

#### **3. Better Scalability**

* Heavy tasks are **offloaded to background workers** and **queued**, allowing API servers to focus on handling incoming requests.
* Can easily scale worker services independently based on workload.
* Fits well in **microservices + message broker** architectures.

#### **4. Resilience & Fault Tolerance**

* If a worker crashes, the queued request remains safe in a message broker until another worker picks it up.
* Enables **retry mechanisms** and **dead-letter queues** for failed jobs without affecting the client-facing API.

#### **5. Decoupling Between Client and Processing Logic**

* The client does not need to know **how** or **where** the task is processed.
* Allows backend teams to **replace algorithms, change infrastructure, or distribute workloads** without breaking the API contract.

#### **6. Better Resource Utilization**

* Frees up HTTP threads quickly, allowing more concurrent requests.
* Reduces CPU/memory spikes since processing is distributed over time and across workers.

#### **7. Flexibility in Response Delivery**

* Multiple delivery options:
  * **Polling** (simpler for clients without push capabilities)
  * **Webhooks** (server pushes result to client)
  * **Push Notifications / SSE / WebSockets**
* Can be tailored to client capabilities.

#### **8. Natural Fit for Distributed & Cloud-Native Systems**

* Works perfectly with **event-driven architectures** and **serverless functions**.
* Cloud-native platforms like AWS Lambda, Google Cloud Pub/Sub, and Azure Functions are optimized for this approach.

## Limitations

#### **1. Increased Implementation Complexity**

* Requires **message queues**, **job schedulers**, or **background workers**.
* Needs additional infrastructure like RabbitMQ, Kafka, or cloud-native queue services (SQS, Pub/Sub).
* More moving parts → more failure points to monitor.

#### **2. Client-Side Complexity**

* The client must handle **job status tracking** and **result retrieval** (polling or listening to webhooks).
* Requires extra logic for **timeouts**, **retries**, and **handling partial results**.

#### **3. Higher Latency for Final Results**

* Since processing is deferred, clients may **wait longer** to receive the actual outcome.
* Not suitable for tasks where immediate results are critical (e.g., credit card validation at checkout).

#### **4. Error Propagation Challenges**

* In synchronous APIs, errors are returned instantly.
* In asynchronous workflows:
  * Errors may occur much later.
  * They must be stored and delivered via polling, push, or callback mechanisms.
  * Requires a **robust error payload structure**.

#### **5. Debugging and Monitoring Complexity**

* Tracing a single request across **multiple services, queues, and workers** can be harder.
* Requires distributed tracing tools (e.g., **OpenTelemetry**, **Jaeger**, **Zipkin**) to track workflow.

#### **6. Potential for Orphaned Requests**

* If the client disappears (e.g., user closes the browser) before fetching results, work might be processed unnecessarily.
* Requires cleanup strategies or **job expiration policies**.

#### **7. Security & Authentication Overhead**

* For polling or push updates, secure **authentication tokens** must be passed repeatedly.
* Webhooks need to be verified to avoid **spoofed callbacks**.

#### **8. More Infrastructure Cost**

* Requires **extra compute** for workers and **persistent storage** for job states.
* Cloud-based queues and workers can incur additional costs if not optimized.

## Common Technologies & Protocols Used

This pattern depends heavily on **message brokers**, **queue systems**, and **async-friendly protocols** to decouple request handling from processing.

#### **1. Messaging & Queue Systems**

These act as buffers to store requests until a worker processes them.

* **RabbitMQ** – Reliable queue-based system with routing patterns.
* **Apache Kafka** – Distributed streaming platform; great for high-throughput async jobs.
* **Amazon SQS / Google Pub/Sub / Azure Service Bus** – Cloud-managed queues with built-in scaling.
* **ActiveMQ / Artemis** – JMS-compliant brokers for enterprise systems.

#### **2. Worker & Job Processing Frameworks**

These tools manage background job execution.

* **Celery** (Python) – Distributed task queue for async processing.
* **Resque / Sidekiq** (Ruby) – Queue-backed job processors.
* **Spring Boot with @Async + Executor** – Java native async execution.
* **BullMQ / Agenda** (Node.js) – Job scheduling for JavaScript backends.

#### **3. API Protocols & Communication Methods**

While the _submission_ of requests may be HTTP, result delivery can be through different mechanisms:

* **HTTP Polling** – Client repeatedly queries the server for job status.
* **Webhooks (HTTP Callbacks)** – Server pushes results back when ready.
* **Server-Sent Events (SSE)** – One-way stream from server to client for updates.
* **WebSockets** – Full-duplex communication for continuous status updates.

#### **4. Data Serialization Formats**

For result exchange between services:

* **JSON** – Most common for REST-style APIs.
* **Protocol Buffers (Protobuf)** – Compact, fast serialization (especially for gRPC).
* **Avro** – Schema-based binary format (popular with Kafka).

#### **5. Tracking & Orchestration Tools**

To manage and monitor async workflows:

* **Camunda / Zeebe** – BPMN-based workflow engines.
* **Temporal.io** – Fault-tolerant workflow orchestration.
* **AWS Step Functions** – Serverless workflow orchestration in the cloud.
