# Configuration Properties

## **Connection Properties**

These properties configure how our application connects to the **ActiveMQ broker**, either remote or embedded. Proper configuration ensures reliable communication between our application and the messaging system.

<table data-full-width="true"><thead><tr><th width="166.43145751953125">Property</th><th width="477.11376953125">Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.activemq.broker-url</code></td><td>Specifies the <strong>URI of the ActiveMQ broker</strong> that our application should connect to. This can be a simple TCP URI, or a failover URI to enable high availability.</td><td><p><code>spring.activemq.broker-url=tcp://localhost:61616</code><br></p><p><code>spring.activemq.broker-url=failover:(tcp://localhost:61616,tcp://backup:61616)</code></p></td></tr><tr><td><code>spring.activemq.user</code></td><td>The <strong>username</strong> used to authenticate with the broker. Required if the broker has security enabled.</td><td><code>spring.activemq.user=admin</code></td></tr><tr><td><code>spring.activemq.password</code></td><td>The <strong>password</strong> for the above user to authenticate with the broker. Keep this secure and do not hardcode it in source files.</td><td><code>spring.activemq.password=admin123</code></td></tr><tr><td><code>spring.activemq.in-memory</code></td><td>If set to <code>true</code>, Spring Boot will create an <strong>embedded (in-memory) ActiveMQ broker</strong> for local development or testing purposes. Not used in production.</td><td><code>spring.activemq.in-memory=true</code></td></tr></tbody></table>

## **Security and Serialization**

These properties manage how objects are deserialized from messages received from ActiveMQ. **Improper configuration can lead to security vulnerabilities**, such as arbitrary code execution during deserialization.

<table data-full-width="true"><thead><tr><th width="190.65020751953125">Property</th><th>Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.activemq.packages.trust-all</code></td><td>When set to <code>true</code>, all incoming serialized Java objects are <strong>trusted for deserialization</strong>. This is <strong>insecure and risky</strong> in production.</td><td><code>spring.activemq.packages.trust-all=true</code> (only for development/testing)</td></tr><tr><td><code>spring.activemq.packages.trusted</code></td><td>Defines a <strong>comma-separated list of package names</strong> whose classes are trusted for deserialization. This is the <strong>secure approach</strong>.</td><td><code>spring.activemq.packages.trusted=com.myapp.model,com.myapp.dto</code></td></tr></tbody></table>

## **Messaging Model (Queue vs Topic)**

This setting determines the **messaging pattern** our application uses:

* **Point-to-Point (Queue)**
  * Each message is **delivered to only one consumer**.
  * Ideal for **work queues**, **task processing**, or **command-style** messages.
  * Multiple consumers can be configured, but **only one receives each message** (load balancing style).
* **Publish-Subscribe (Topic)**
  * Each message is **broadcast to all active subscribers**.
  * Ideal for **notifications**, **events**, or **real-time updates**.
  * Consumers must be **online at the time of message** unless they are **durable subscribers**.

{% hint style="success" %}
A **Virtual Topic** is a **hybrid messaging model** in ActiveMQ that allows:

* **Publishers** to send messages to a **Topic**.
* **Consumers** to consume those messages **from Queues**.

It combines **Pub/Sub delivery behavior** with **Queue semantics**, like message persistence and load balancing among consumers.

**How Virtual Topics Work**

* **Publisher** sends to:\
  `VirtualTopic.MyTopic`
* **Consumer** listens to:\
  `Consumer.A.VirtualTopic.MyTopic`\
  `Consumer.B.VirtualTopic.MyTopic`

Each consumer group (`A`, `B`) gets **its own queue**. Within each group, multiple consumers can compete for messages — just like in point-to-point.
{% endhint %}

| Property                    | Purpose                                                                            | Example                                                                                                                                      |
| --------------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `spring.jms.pub-sub-domain` | Enables selection between **Queue (false)** and **Topic (true)** messaging models. | <p><code>spring.jms.pub-sub-domain=true</code> for Topic</p><p><br><code>spring.jms.pub-sub-domain=false</code> for Queue (default mode)</p> |

{% hint style="danger" %}
If we accidentally set `spring.jms.pub-sub-domain=true` for a **virtual topic consumer**, our listener will try to subscribe as if to a real Topic — and it won’t work as expected, because `Consumer.*.VirtualTopic.*` destinations are **queues**, not actual topics.
{% endhint %}

## **Listener Container Configuration**

These properties control the behavior and performance of **JMS message listeners** — such as how many threads handle messages, how acknowledgments work, and how long consumers wait for new messages.

<table data-full-width="true"><thead><tr><th width="226.86541748046875">Property</th><th width="410.76385498046875">Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.jms.listener.concurrency</code></td><td>Sets the <strong>minimum number of concurrent consumers</strong> (threads) to start initially.</td><td><code>spring.jms.listener.concurrency=2</code></td></tr><tr><td><code>spring.jms.listener.max-concurrency</code></td><td>Sets the <strong>maximum number of concurrent consumers</strong>, useful for dynamic scaling.</td><td><code>spring.jms.listener.max-concurrency=10</code></td></tr><tr><td><code>spring.jms.listener.acknowledge-mode</code></td><td>Defines <strong>how message acknowledgment is handled</strong> (auto, manual, etc.).</td><td><code>spring.jms.listener.acknowledge-mode=auto</code></td></tr><tr><td><code>spring.jms.listener.receive-timeout</code></td><td>Specifies how long the consumer <strong>waits for a message</strong> before timing out. Applies <strong>per consumer thread</strong>.</td><td><code>spring.jms.listener.receive-timeout=1000ms</code></td></tr><tr><td><code>spring.jms.listener.idle-timeout</code></td><td>If no messages are received, <strong>how long to wait before shutting down idle threads</strong>.</td><td><code>spring.jms.listener.idle-timeout=30000ms</code></td></tr></tbody></table>

**`spring.jms.listener.concurrency`**

* Specifies the **starting number of concurrent consumers**.
* These consumers poll messages in parallel.
* Useful for increasing **message throughput** on high-volume queues.
* Internally sets `setConcurrentConsumers(int)` on the listener container.



**`spring.jms.listener.max-concurrency`**

* Allows the listener to **scale up** the number of consumers based on load.
* Internally sets `setMaxConcurrentConsumers(int)`.
* Helps in **burst traffic scenarios** to handle spikes without overload.

> Example: If `concurrency=2` and `max-concurrency=6`, the listener will start with 2 threads and can dynamically scale up to 6 if message volume increases.

\
&#xNAN;**`spring.jms.listener.acknowledge-mode`**

Controls **when** and **how** JMS messages are acknowledged:

* `auto` – Container automatically acknowledges after successful receipt. (default)
* `manual` – We manually acknowledge within the listener using `SessionAwareMessageListener`.
* `client` – Our code is responsible for calling `Message.acknowledge()`.
* `dups-ok` – Permits **lazy acknowledgment** (fewer acks, but duplicates may occur).

> `manual` is used in **error-handling-heavy** apps that need full control over retries and redelivery.



`spring.jms.listener.receive-timeout`

This property controls **how long a consumer thread waits for a new message** before it decides to pause or shut down (if using idle timeout).

**Example**

```
spring.jms.listener.concurrency=3
spring.jms.listener.idle-timeout=60000
spring.jms.listener.receive-timeout=2000
```

* 3 listener threads will be started.
* If they remain idle (no messages) for 60 seconds, they will be shut down to save resources.
* receive-timeout=2000 means: Each listener thread will wait 2 seconds while polling for a message.

Each of the 3 threads does the following:

1. It **calls the broker** (e.g., ActiveMQ) asking: “Do you have a message for me?”
2. The broker responds **immediately** if a message is available.
3. If there is **no message**, the thread **waits for up to 2 seconds**.
   * If still no message, the thread times out and loops back to try again.
4. After multiple consecutive timeouts, if the queue is **idle for 60 seconds**, the thread is **shut down** (controlled by `idle-timeout`).

**Without `receive-timeout`:**

* The thread may block **indefinitely** waiting for a message.
* This can make our application **slow to shut down** or **unresponsive** under idle conditions.

**With a `receive-timeout`:**

* Our listener thread periodically wakes up to check for:
  * **Shutdown signals**
  * **Idle timeout**
  * **Queue metrics**
* Ensures better **thread lifecycle management** and graceful **shutdown** in cloud-native deployments or auto-scaling environments.

{% hint style="info" %}
When `spring.jms.listener.receive-timeout` is **not set**, Spring uses the default behavior of the underlying `DefaultMessageListenerContainer`:

* It **blocks indefinitely** while waiting for a message.
* As soon as a message becomes available, it is picked up and processed.
* This ensures **zero CPU wastage** when there's no message traffic — the thread simply waits.
{% endhint %}

#### **When We Should Set It Explicitly**

<table data-header-hidden data-full-width="true"><thead><tr><th width="300.23175048828125"></th><th width="182.42529296875"></th><th></th></tr></thead><tbody><tr><td>Use Case</td><td>Should Set <code>receive-timeout</code>?</td><td>Why</td></tr><tr><td>Basic applications with steady traffic</td><td>Not needed</td><td>Threads are always busy receiving messages.</td></tr><tr><td>Apps with graceful shutdown needs</td><td>Recommended</td><td>Prevents threads from being stuck and delays shutdown.</td></tr><tr><td>Apps with conditional polling logic</td><td>Recommended</td><td>Gives control over how often threads wake up and check.</td></tr><tr><td>Apps using manual ack or retries</td><td>Recommended</td><td>Helps manage polling intervals and visibility on failures.</td></tr><tr><td>Low-volume queues</td><td>Recommended</td><td>Avoid long blocking or thread hanging.</td></tr></tbody></table>



#### `spring.jms.listener.idle-timeout`

This property controls how long a **consumer thread** can remain **idle (not receiving any messages)** before it is eligible for shutdown. It’s especially useful when our application uses **dynamic scaling of listeners**, i.e., when `max-concurrency` is greater than `concurrency`.

In a scalable message consumer setup:

* The listener container starts with a **minimum number of consumer threads** (`concurrency`).
* Based on message load, it **creates additional threads** (up to `max-concurrency`) to handle bursts.
* If traffic slows down or stops, **these extra threads aren’t needed anymore**.
* `idle-timeout` defines the **wait time (in milliseconds)** after which an idle thread is **removed** to free up resources (memory, CPU).

{% hint style="info" %}
By default, **`idle-timeout` is not explicitly set**, and the underlying `DefaultMessageListenerContainer` behavior is:

* **Never shuts down** idle consumers once scaled up.
* So unless configured, extra threads remain **even if traffic stops**.
{% endhint %}



### **Prefetch**

**Not a Spring property**, but **important for tuning** message delivery.

| Property (in ActiveMQ URI)            | Purpose                                                                                                                                     | Example                                                                                |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `?jms.prefetchPolicy.queuePrefetch=1` | Controls how many messages are **prefetched and held in memory** per consumer. Lower means more accurate load balancing but higher latency. | `spring.activemq.broker-url=tcp://localhost:61616?jms.prefetchPolicy.queuePrefetch=10` |

* Default is usually 1000, which may **overload memory** if messages are large.
* Set to 1 for **strict ordering** or **manual acknowledgment** use cases.

> In high-throughput systems, tune prefetch with concurrency for **better throughput and stability**.

### Best Practice

<table data-full-width="true"><thead><tr><th width="352.31597900390625">Property</th><th>Best Practice</th></tr></thead><tbody><tr><td><code>spring.jms.listener.concurrency</code></td><td>Start with a modest value (e.g., 2–5). Avoid setting too high; it can overwhelm the broker.</td></tr><tr><td><code>spring.jms.listener.max-concurrency</code></td><td>Set only if our workload is <strong>bursty</strong>. Max concurrency should be 2–3x the base concurrency.</td></tr><tr><td><code>spring.jms.listener.acknowledge-mode</code></td><td>Use <code>auto</code> for simple use cases. Use <code>manual</code> when we need to retry, log, or inspect failures explicitly.</td></tr><tr><td><code>spring.jms.listener.receive-timeout</code></td><td>Use 500–1000 ms. Don’t set it too high (blocks threads); don’t set too low (causes polling pressure).</td></tr><tr><td><code>spring.jms.listener.idle-timeout</code></td><td>Set to 30s–60s to scale down inactive consumers gracefully. Useful when <code>max-concurrency</code> is used.</td></tr></tbody></table>

#### **Recommended Settings for**  `spring.jms.listener.receive-timeout`

<table data-full-width="true"><thead><tr><th width="273.06689453125">Use Case</th><th width="199.07464599609375">Recommended Timeout</th><th>Reason</th></tr></thead><tbody><tr><td><strong>General Purpose Production</strong></td><td><code>1000</code> ms (1 second)</td><td>Balanced between CPU usage and responsiveness</td></tr><tr><td><strong>High Throughput (Bulk)</strong></td><td><code>100–500</code> ms</td><td>Lower timeout improves throughput by quickly retrying</td></tr><tr><td><strong>Low Volume / Latency Sensitive</strong></td><td><code>2000–5000</code> ms</td><td>Reduces CPU churn in low traffic queues</td></tr><tr><td><strong>Testing / Debugging</strong></td><td><code>10000</code> ms</td><td>More predictable for step-by-step tracing</td></tr></tbody></table>

{% hint style="info" %}
* **Too low** (`< 100ms`) → high CPU usage due to frequent polling.
* **Too high** → slows down shutdown of listener container.
{% endhint %}

#### **Prefetch Configuration (ActiveMQ)**

<table data-full-width="true"><thead><tr><th width="331.712646484375">Configuration Option (in broker-url)</th><th>Best Practice</th></tr></thead><tbody><tr><td><code>jms.prefetchPolicy.queuePrefetch=1</code></td><td>Use when <strong>manual acknowledgment</strong>, <strong>low-latency</strong>, or <strong>ordered processing</strong> is required.</td></tr><tr><td><code>jms.prefetchPolicy.queuePrefetch=10–50</code></td><td>Balanced value for <strong>most production systems</strong> (with concurrency).</td></tr><tr><td><code>jms.prefetchPolicy.queuePrefetch=100+</code></td><td>Use only for <strong>high-throughput consumers</strong> that can process large volumes fast (e.g., batch jobs).</td></tr><tr><td>Use topic prefetch tuning separately</td><td><code>jms.prefetchPolicy.topicPrefetch=1</code> if consumers are slow or need strict delivery control.</td></tr></tbody></table>

## **JmsTemplate Behavior**

These properties configure the behavior of the `JmsTemplate`, a **synchronous API** used to **send and receive JMS messages**. It is commonly used in **producer components**, or for **direct request-response** patterns (though less recommended for high-scale apps).

<table data-full-width="true"><thead><tr><th width="274.873291015625">Property</th><th>Purpose</th><th>Example</th></tr></thead><tbody><tr><td><code>spring.jms.template.default-destination</code></td><td>Sets the <strong>default queue or topic name</strong> to send messages to if no destination is specified at runtime.</td><td><code>spring.jms.template.default-destination=notifications.queue</code></td></tr><tr><td><code>spring.jms.template.receive-timeout</code></td><td>Sets how long the template waits during a <strong>synchronous receive()</strong> call before timing out.</td><td><code>spring.jms.template.receive-timeout=3000ms</code></td></tr></tbody></table>

**`spring.jms.template.default-destination`**

*   Allows us to omit the destination when calling `convertAndSend()` or `send()`:

    ```java
    jmsTemplate.convertAndSend(myObject); // Uses default destination
    ```
* This is useful when our app mostly talks to **a single queue/topic**.
* If we are interacting with **multiple destinations**, we should **set it programmatically** or pass it explicitly to `convertAndSend(destination, message)`.

> Good for simplification, but limits flexibility in multi-queue systems.



**`spring.jms.template.receive-timeout`**

*   Controls how long `receive()` or `receiveAndConvert()` waits for a message:

    ```java
    javaCopyEditMessage message = jmsTemplate.receive(); // Waits until timeout
    ```
* A value of `0` means **wait indefinitely**.
* A value of `-1` or omitting it means **non-blocking receive** — the call returns immediately with null if no message is available.

> Use non-blocking or time-limited receives in production to avoid **thread starvation** or **deadlocks**.

## **Broker-Level Tuning (via URL or API)**

These advanced settings control **core message delivery behaviors** such as prefetching, redelivery, retries, and Dead Letter Queue (DLQ) handling. Tuning these properly ensures **better performance, memory utilization, and failure handling** — especially under high load or error-prone scenarios.

| Setting                            | Purpose                                                                                                   | Example                                                     |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `jms.prefetchPolicy.queuePrefetch` | Controls **how many messages** a consumer **pre-fetches** from the broker before processing.              | `tcp://localhost:61616?jms.prefetchPolicy.queuePrefetch=10` |
| `RedeliveryPolicy` (programmatic)  | Controls how the broker **retries failed messages**, including delay intervals, backoff multipliers, etc. |                                                             |

`jms.prefetchPolicy.queuePrefetch`

* Prefetch means the number of messages **fetched in advance** by each consumer from the broker.
* They are held in memory and processed one by one (or concurrently, depending on our app).
* Too high a prefetch value can lead to:
  * **Memory pressure**.
  * **Uneven load balancing** across consumers.
  * **Redelivery delays** if consumers crash before processing buffered messages.
*   Set this in the broker URL string in `spring.activemq.broker-url`:

    ```properties
    propertiesCopyEditspring.activemq.broker-url=tcp://localhost:61616?jms.prefetchPolicy.queuePrefetch=10
    ```
* Set to `1` if we:
  * Need **strict message ordering**.
  * Rely on **manual acknowledgment** and want **safe recovery**.
* Default (often 1000) is **too high** for many real-world cases.

> **Best Practice**: Start with `queuePrefetch=10` for most apps, tune up/down based on throughput vs. memory trade-off.



#### `RedeliveryPolicy` (Programmatic Configuration)

Defines what happens when a **message is not acknowledged** or **fails processing**:

* How many times to retry
* Delay between retries
* Whether to use exponential backoff
* Whether to send to **Dead Letter Queue (DLQ)**

**Example: Spring Java Config**

```java
@Bean
public ActiveMQConnectionFactory activeMQConnectionFactory() {
    ActiveMQConnectionFactory factory = new ActiveMQConnectionFactory("tcp://localhost:61616");

    RedeliveryPolicy policy = new RedeliveryPolicy();
    policy.setInitialRedeliveryDelay(1000);        // 1 second
    policy.setRedeliveryDelay(5000);               // 5 seconds between retries
    policy.setMaximumRedeliveries(3);              // Try 3 times
    policy.setUseExponentialBackOff(true);
    policy.setBackOffMultiplier(2.0);              // Delay: 5s, 10s, 20s...

    factory.setRedeliveryPolicy(policy);
    return factory;
}
```

> After 3 failed attempts, message is routed to **ActiveMQ.DLQ** (by default).

## Other Properties

#### **`spring.activemq.pool.max-connections`:**

* This property sets the maximum number of physical connections in the connection pool managed by Spring for ActiveMQ.
* **How it works:**
  * ActiveMQ uses a connection pool to manage physical connections to the message broker efficiently.
  * By setting `spring.activemq.pool.max-connections` to `5`, we are limiting the pool to hold at most 5 connections.
  * Each connection can be shared by multiple sessions, which helps in reducing the overhead of creating and closing connections.
* **Impact on our Consumer App:**
  * **Connection Reuse:**
    * The application will reuse up to `max-connections` physical connections to the broker.
    * If our app creates many consumer threads (due to concurrency settings), they will share these pooled connections.
  * **Performance:**
    * A higher value reduces connection creation overhead but increases resource usage.
    * If we set it too low and have many consumers, some consumers may need to wait for a connection, causing delays.
  * **Scalability:**
    * If multiple applications are consuming messages from the same broker, the `max-connections` setting must align with broker capacity to avoid connection throttling.
* **Use case:**
  * It's useful when multiple threads or components in the application need to interact with ActiveMQ concurrently.
  * The connection pool improves performance by reusing connections instead of creating a new one for every operation.

#### **`spring.cloud.stream.default.consumer.concurrency`:**

* This property sets the level of concurrency for message consumers when using **Spring Cloud Stream** with ActiveMQ (or any message broker).
* **How it works:**
  * When consuming messages from a topic or queue, this property determines the number of concurrent consumers (threads) that will process messages.
  * If set to `5`, the framework will create 5 consumers to fetch and process messages from the queue simultaneously.
* **Impact on our Consumer App:**
  * **Throughput:**
    * A higher concurrency value increases the number of messages processed simultaneously, enhancing throughput.
    * However, if not tuned carefully, it may overwhelm our application or broker with excessive load.
  * **Connection Utilization:**
    * Each concurrent consumer typically requires a separate session, which in turn requires a connection from the pool.
    * For example, if `concurrency=5`, our app will create 5 consumers (threads) and may need 5 sessions, drawing from the connection pool.
  * **Load Distribution:**
    * If multiple instances of our app are running, each instance will process `concurrency` number of messages in parallel, distributing the load across instances.
* **Impact on ActiveMQ:**
  * Each consumer thread will typically require its own session. With `spring.activemq.pool.max-connections` set to `5`, the pool must provide sufficient connections for these threads.
  * If the connection pool size is smaller than the number of consumers, contention for connections can occur, potentially leading to delays.

## **Tuning Tips**

**Match Connections to Concurrency:**

* Ensure `max-connections >= concurrency` to avoid connection contention.

**Test Under Load:**

* Simulate real-world traffic to find the optimal settings.
