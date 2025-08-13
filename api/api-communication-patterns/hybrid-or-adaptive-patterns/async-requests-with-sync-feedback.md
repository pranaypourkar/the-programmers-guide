# Async Requests with Sync Feedback

## About

**Async Requests with Sync Feedback** is a hybrid communication pattern where the **client sends a request**, the server **immediately responds with partial or preliminary feedback**, and the **actual heavy or long-running processing continues asynchronously in the background**.

This approach **combines the responsiveness of synchronous communication** with the **scalability and resilience of asynchronous processing**. It’s often used when:

* **Immediate client feedback** is important (e.g., “Your request has been received”).
* The **final result is not required instantly** or takes significant time to compute.
* We want to **avoid keeping the client connection open** for extended periods.

{% hint style="success" %}
**Phase 1 (Sync):** The server validates the request, stores it (e.g., in a database or message queue), and returns an **acknowledgment or tracking ID**.

**Phase 2 (Async):** The request is processed in the background, and the client is notified of completion via **polling**, **webhooks**, or **push updates**.
{% endhint %}

{% hint style="info" %}
**Examples**

* **Online food ordering**: We place an order, get an instant “Order Received” confirmation, but actual preparation and delivery happen later.
* **Payment processing**: We get an immediate “Transaction in Progress” message, while the final debit/credit settlement occurs after bank verification.
* **Cloud file uploads**: System confirms “Upload Accepted” instantly, but virus scanning and indexing happen afterward.
{% endhint %}

## Is it Similar to Request-Response Pattern (Truly Asynchronous) ?

They sound similar, but **Async Requests with Sync Feedback** and **Request-Response Pattern (Truly Asynchronous)** differ in some important ways.

Here’s the distinction:

#### **1. Request-Response Pattern (Truly Asynchronous)**

The client sends a request, and the server **does not** send any immediate business confirmation other than possibly a transport-level acknowledgment (e.g., TCP ACK).

The actual **response** is sent later via **a separate callback mechanism** (e.g., webhook, push notification, async message).

* **Client perspective:** They don’t get meaningful data right away, so they must rely entirely on async delivery.
* **Example:**
  * Client sends a job request to an API.
  * API queues it and later calls the client’s webhook with results.
  * No “job ID” is returned at the time of request; just a generic acknowledgment like HTTP 202.

#### **2. Async Requests with Sync Feedback**

The client sends a request, and the server **immediately returns some useful response synchronously** - typically a **job ID, tracking token, or initial status**.

This allows the client to **start tracking progress** (via polling or a separate status API) while the backend continues processing.

* **Client perspective:** They get **something actionable right away**, but the final result is delivered later.
* **Example:**
  * Client uploads a video for transcoding.
  * API immediately returns `{"jobId": "12345", "status": "processing"}`.
  * Client can then poll `/jobs/12345` or subscribe to updates.
  * Final “success” or “failure” comes later.

## Why This Pattern is Useful in System Design ?

The **Async Requests with Sync Feedback** pattern addresses one of the biggest challenges in modern distributed systems - **balancing user experience with backend performance and scalability**.

#### **1. Improves Perceived Responsiveness**

* Users hate waiting with no feedback.
* By **instantly acknowledging** a request, the system creates the perception of speed, even if the actual work is still pending.
* Example: An e-commerce checkout page confirms an order in milliseconds, while inventory checks, fraud detection, and shipping label creation happen later.

#### **2. Prevents Client Timeouts**

* Some operations take longer than typical HTTP or gRPC timeouts allow.
* Instead of keeping the connection open, the server **returns quickly**, avoiding timeout errors and unnecessary retries.
* This also **reduces load on network resources**.

#### **3. Decouples Frontend from Backend Processing**

* The initial sync response acts as a **fire-and-forget handoff** to background workers.
* This allows backend teams to **scale processing independently** of the request-response API.
* Useful when workloads vary drastically (e.g., batch processing, AI model training).

#### **4. Supports Long-Running and Resource-Intensive Tasks**

* Video transcoding, bulk data imports, or large report generation can take minutes or hours.
* Clients shouldn’t need to keep a connection alive that long - a simple job ID and polling or push updates are enough.

#### **5. Enables Better Fault Isolation**

* If a downstream service or processing pipeline fails, the user doesn’t see a broken page - they only see a “Processing” status.
* Failures can be **retried in the background** without impacting the client’s immediate experience.

#### **6. Easier Integration with Event-Driven Architectures**

* This pattern naturally aligns with **message queues**, **event buses**, and **pub/sub systems**.
* The sync acknowledgment can be followed by async event processing and notifications, integrating well with microservices.

## **Characteristics**

#### **1. Immediate Acknowledgment**

* The server **returns a response almost instantly** after receiving the request, confirming that the request has been accepted for processing.
* This acknowledgment is **not the final result** - it’s only a confirmation that the work has been queued or scheduled.
* Example: HTTP 202 Accepted with a job ID.

#### **2. Decoupled Processing**

* The main request-handling thread or process **hands off work to an asynchronous job executor** (e.g., a message queue, background worker, or serverless function).
* The response is independent of when or how the task completes.

#### **3. Persistent Task Tracking**

* The client is provided with a **tracking mechanism** - typically:
  * A **Job ID** to query status via polling API.
  * A **Webhook endpoint** where the final result will be pushed.
  * Or **server-push notifications** (WebSockets, SSE).
* This ensures clients can **retrieve the final output later** without re-sending the same request.

#### **4. Status Transitions**

* Tasks often move through **well-defined lifecycle states**:
  * `Pending` → `Processing` → `Completed` → `Failed`\
    (with optional states like `Queued`, `Cancelled`, `Retrying`)
* Clients can check or subscribe to these updates.

#### **5. Reduced Coupling Between Client & Backend**

* The client **does not wait** for the backend to complete work.
* Backend services can process tasks at their own pace, scale independently, and recover from temporary outages without affecting client responsiveness.

#### **6. Fault Tolerance Friendly**

* Because tasks are queued or persisted before processing, the system can survive:
  * Worker restarts
  * Partial failures
  * Processing delays
* This makes it **resilient for critical workflows**.

#### **7. User Experience Focused**

* From a UX perspective, users see **instant confirmation**, avoiding frustration caused by long page loads or frozen screens.
* Commonly paired with **progress indicators**, notifications, or dashboards.

## **Execution Flow**

#### **Step 1 – Client Sends Request**

* The client submits a request to the API endpoint as usual.
*   Example:

    ```http
    POST /process-report
    Content-Type: application/json

    { "reportType": "sales", "dateRange": "2025-01" }
    ```

#### **Step 2 – Server Validates & Queues the Task**

* **Validation Phase**: The server quickly checks:
  * Required fields
  * Authentication / authorization
  * Basic format correctness
* **Task Creation Phase**:
  * The server generates a **unique Job ID** (UUID or sequence number).
  * The task is **queued** in:
    * Message broker (RabbitMQ, Kafka, AWS SQS)
    * Job scheduler (Celery, BullMQ)
    * Database table for pending tasks

#### **Step 3 – Immediate Acknowledgment Response**

* The server **does not process the request in-line** - instead, it sends a quick acknowledgment.
*   HTTP 202 Accepted is the most common:

    ```http
    HTTP/1.1 202 Accepted
    Content-Type: application/json

    {
      "jobId": "e21f3a1b-54d9-4c3b-9f11-9e3c2d47fa52",
      "status": "pending",
      "statusUrl": "/jobs/e21f3a1b-54d9-4c3b-9f11-9e3c2d47fa52"
    }
    ```

#### **Step 4 – Background Processing**

* A **background worker** or microservice picks up the task from the queue.
* Processing happens asynchronously:
  * Could take milliseconds (e.g., image resizing) or hours (e.g., data aggregation).
  * The system updates **task state** in a status store.

#### **Step 5 – Client Polls or Awaits Push Notification**

*   **Polling Approach**: The client periodically calls:

    ```http
    GET /jobs/e21f3a1b-54d9-4c3b-9f11-9e3c2d47fa52
    ```

    Response example:

    ```json
    { "jobId": "...", "status": "processing", "progress": 45 }
    ```
* **Push Approach**:
  * Server sends a **webhook** or **WebSocket/SSE message** when the task is done.

#### **Step 6 – Task Completion**

* Once completed:
  * The job’s status becomes `"completed"`.
  * The output is either:
    * **Returned inline** in the status check endpoint
    * **Stored** in a location provided in the final status response (e.g., S3 file link).

Example:

```json
{
  "jobId": "...",
  "status": "completed",
  "resultUrl": "/downloads/sales-report-2025-01.pdf"
}
```

#### **Step 7 – Error or Timeout Handling**

*   If processing fails:

    ```json
    {
      "jobId": "...",
      "status": "failed",
      "error": "Data source unavailable"
    }
    ```
* Optional retries can be triggered automatically based on system rules.

## **Advantages**

#### **1. Immediate User Acknowledgment**

* **Why it matters**:\
  Users get an instant confirmation that their request is received, even if processing will take time.
* **Impact**:
  * Improves **user experience** by eliminating long waiting times on a blocking request.
  * Reduces risk of **client timeouts**.
* **Example**:\
  When uploading a large video to YouTube, we immediately get a confirmation and a “Processing” status, rather than waiting minutes for the HTTP call to complete.

#### **2. Decoupled Processing for Scalability**

* **Why it matters**:\
  Processing is done in a background worker or microservice, separate from the API request thread.
* **Impact**:
  * Allows **horizontal scaling** of workers without affecting API gateway performance.
  * Handles **spiky workloads** without overloading the front-end service.
* **Example**:\
  An e-commerce site generating bulk invoices can handle thousands of requests without tying up API threads.

#### **3. Better System Reliability**

* **Why it matters**:\
  Long-running operations are prone to network failures if done synchronously.
* **Impact**:
  * Reduces failure rates due to **HTTP timeout limits**.
  * Ensures work can resume from the queue even if the original API node crashes.
* **Example**:\
  A batch data import continues processing even if the client disconnects.

#### **4. Improved User Interface Experience**

* **Why it matters**:\
  UIs can display **real-time progress** and **status updates** to the user.
* **Impact**:
  * Enables **progress bars**, **"in-progress" states**, and **retry options**.
  * Encourages more **interactive** and **informative** UX flows.
* **Example**:\
  Google Drive shows "Scanning for viruses" or "Processing" for uploaded files, rather than leaving the user guessing.

#### **5. Flexibility for Multiple Feedback Mechanisms**

* **Why it matters**:\
  The feedback can be delivered via **polling**, **webhooks**, **push notifications**, or **WebSocket/SSE**.
* **Impact**:
  * Works for different client types (browsers, mobile apps, server-to-server).
  * Enables **API consumers** to choose the feedback mechanism they prefer.
* **Example**:\
  Stripe payment processing can notify via webhooks for backend systems or WebSocket for dashboard UIs.

#### **6. Easier Error Recovery**

* **Why it matters**:\
  Since the request is tracked via a job ID, failures can be retried without resubmitting the original request payload.
* **Impact**:
  * Prevents **duplicate work**.
  * Allows **partial retry** for only failed jobs.
* **Example**:\
  A PDF generation service can retry failed conversions without re-uploading the original document.

#### **7. Works Well for Both Short & Long Jobs**

* **Why it matters**:\
  The same pattern can support:
  * Jobs finishing in seconds (image thumbnail generation)
  * Jobs taking hours (machine learning model training)
* **Impact**:
  * Creates a **consistent client workflow** regardless of task duration.
* **Example**:\
  AWS Elastic Transcoder uses the same job submission process whether transcoding a 1-minute clip or a 2-hour movie.

## **Limitations**

#### **1. Increased Implementation Complexity**

* **Why it’s a challenge**:\
  This pattern requires two workflows - one for **immediate acknowledgment** and another for **background processing**.
* **Impact**:
  * Extra **infrastructure components** (message queues, job processors).
  * More **code paths** to maintain and test.
* **Example**:\
  An API that accepts a video upload must manage:
  1. API response for job creation.
  2. Asynchronous job execution pipeline.
  3. Status reporting mechanism.

#### **2. State Tracking Overhead**

* **Why it’s a challenge**:\
  The system must persist and manage **job states** (Pending, Processing, Completed, Failed).
* **Impact**:
  * Requires **database or cache storage** for job metadata.
  * Risk of **state inconsistency** if background workers fail.
* **Example**:\
  If a background worker crashes mid-task, the system must detect and update job status to "Failed" rather than leaving it “In Progress” forever.

#### **3. Potential Latency in Results**

* **Why it’s a challenge**:\
  Even though the request returns quickly, the **actual task** might still take minutes or hours.
* **Impact**:
  * Consumers must handle **delayed gratification** and design for asynchronous workflows.
  * May need **polling** or push notifications to know when work is done.
* **Example**:\
  A large database export job could take hours, meaning the client must wait for a separate completion signal.

#### **4. Additional Client Logic Required**

* **Why it’s a challenge**:\
  Clients must store and use a **job ID** to check status later.
* **Impact**:
  * More **client-side code** for tracking results.
  * Increases API **integration complexity**.
* **Example**:\
  A mobile app must implement a “check status” endpoint call and handle multiple states.

#### **5. Harder Error Propagation**

* **Why it’s a challenge**:\
  Unlike synchronous calls, errors don’t come immediately - they appear later via polling or push.
* **Impact**:
  * May delay error handling by clients.
  * Requires **status codes and error models** for asynchronous results.
* **Example**:\
  If payment processing fails after initial confirmation, the user may only know minutes later.

#### **6. More Infrastructure Components**

* **Why it’s a challenge**:\
  Usually requires:
  * **Message queues** (RabbitMQ, Kafka, SQS)
  * **Background workers**
  * **Status APIs** or **real-time channels**
* **Impact**:
  * Higher **maintenance** and **operational costs**.
  * More points of **failure**.
* **Example**:\
  If the job queue becomes overloaded, results will be delayed even if the initial request succeeded.

#### **7. Consistency and Data Synchronization Risks**

* **Why it’s a challenge**:\
  Since processing is decoupled, there’s a risk the **original request data** changes before processing finishes.
* **Impact**:
  * Possible **stale data** issues.
  * Need for **data snapshotting** at job creation.
* **Example**:\
  A user updates their profile picture while an old one is still being processed for thumbnails - leading to incorrect images being generated.
