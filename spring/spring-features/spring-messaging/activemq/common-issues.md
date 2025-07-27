# Common Issues

## ActiveMQ logs shows Memory usage has reached or exceeded configured limits

Logs

{% code overflow="wrap" %}
```
 WARN | Transport Connection to: tcp://11.128.88.20:51976 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.34.1:51176 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.16.1:62767 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.26.1:62148 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.16.1:40315 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.34.1:36189 failed: java.io.EOFException
 WARN | Transport Connection to: tcp://11.128.26.1:16568 failed: java.io.EOFException
 INFO | Usage(default:memory:queue://Spring.Cloud.Stream.dlq:memory) percentUsage=69%, usage=467812303, limit=668309914, percentUsageMinDelta=1%;Parent:Usage(default:memory) percentUsage=100%, usage=668329690, limit=668309914, percentUsageMinDelta=1%: Usage Manager Memory Limit reached. Producer (ID:transaction-manager-945bf56d59-xv2tq-34973-1736379783901-1:49:3:1) stopped to prevent flooding queue://Spring.Cloud.Stream.dlq. See http://activemq.apache.org/producer-flow-control.html for more info (blocking for: 964s)
```
{% endcode %}

### How ActiveMQ Works in This Context

ActiveMQ is a message broker designed to mediate communication between producers (applications sending messages) and consumers (applications receiving messages). Here’s a simplified flow relevant to your situation:

1. **Producer Sends Messages:**
   * A producer sends messages to a queue or topic.
   * Messages are stored in the broker's memory or on disk if persistence is enabled.
2. **Consumer Processes Messages:**
   * A consumer fetches messages from the queue and processes them.
   * If no consumer is available, messages accumulate in the queue.
3. **Flow Control Mechanism:**
   * ActiveMQ enforces flow control to manage broker resources like memory.
   * If memory usage exceeds configured limits, producers are blocked to prevent overloading the broker.
4. **Dead Letter Queue (DLQ):**
   * When a message cannot be delivered or processed (e.g., retries are exhausted), it is sent to a DLQ for further analysis.

### Understanding the Current Situation

1.  **Memory Limits Reached:**

    *   ActiveMQ is running out of memory, as indicated by the logs:

        ```
        pgsqlCopyEditUsage Manager Memory Limit reached.
        ```
    *   Memory usage details:

        ```
        percentUsage=100%, usage=668329690, limit=668309914
        ```
    * When memory is full, producers are stopped, resulting in delays or blocking (`blocking for: 964s`).

    **Root Causes:**

    * Large message backlog (e.g., unprocessed messages in `Spring.Cloud.Stream.dlq`).
    * Insufficient memory configuration for the broker.
2.  **Connection Failures:**

    *   Multiple warnings like:

        ```
        WARN | Transport Connection to: tcp://11.128.88.20:51976 failed: java.io.EOFException
        ```
    * These indicate that some clients (producers/consumers) are losing their connections to the broker.

    **Root Causes:**

    * Network instability or client misconfiguration.
    * Resource exhaustion at the broker (e.g., threads, memory).
3.  **DLQ Overload:**

    * The queue `Spring.Cloud.Stream.dlq` is being flooded. This queue is typically used for undeliverable or failed messages.

    **Root Causes:**

    * Application issues causing messages to be redirected to the DLQ.
    * Lack of consumers processing messages from the DLQ.

### How ActiveMQ Handles These Situations

1. **Memory Usage Management:**
   * ActiveMQ allocates a memory pool to hold messages temporarily.
   * If this pool exceeds the configured limit, flow control stops producers to avoid memory overflow.
2. **Dead Letter Queue:**
   * Messages are redirected to the DLQ when:
     * Delivery fails (e.g., no consumer or consumer errors).
     * Retry limits are exceeded.
3. **Transport Failures:**
   * Connections between clients and the broker are maintained via TCP.
   * Failures (e.g., `EOFException`) occur due to abrupt disconnections or resource limitations.

### Troubleshooting Steps

**1. Memory Configuration:**

*   Increase the memory limits for the broker in the `activemq.xml` configuration:

    ```xml
    <systemUsage>
        <memoryUsage>
            <memoryLimit>1 gb</memoryLimit> <!-- Adjust as needed -->
        </memoryUsage>
    </systemUsage>
    ```
* Monitor memory usage to ensure it's sufficient for your workload.

**2. Dead Letter Queue (DLQ) Management:**

* The queue `Spring.Cloud.Stream.dlq` seems to be accumulating messages. Check why messages are being redirected to the DLQ.
* Mitigate DLQ growth:
  * Address application issues causing messages to fail.
  * Enable DLQ message cleanup or archiving.
  * Consider applying a TTL (time-to-live) for messages.

**3. Connection Stability:**

* Review network health to reduce `EOFException` occurrences.
  * Ensure low-latency, stable connectivity between clients and the broker.
*   Configure `transportConnector` with keep-alive options in `activemq.xml`:

    ```xml
    <transportConnector name="tcp" uri="tcp://0.0.0.0:61616?wireFormat.maxInactivityDuration=30000" />
    ```

**4. Broker Monitoring and Metrics:**

* Monitor ActiveMQ metrics using tools like JMX, Prometheus, or built-in web consoles.
* Key metrics:
  * Memory usage.
  * Queue sizes.
  * Consumer counts.

**5. Thread and Resource Limits:**

*   Ensure broker threads and resources are sufficient:

    ```xml
    <broker>
        <threadPool maxConnections="500" maxThreads="200" />
    </broker>
    ```

**6. Producer Backoff Strategy:**

* Configure producers to handle flow control gracefully. For instance, retry with backoff when blocked.

**7. Message Prioritization:**

* Use message priorities to ensure critical messages are not delayed or blocked.



