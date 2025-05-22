# Queues and Topics

## About

In ActiveMQ, **Queues** and **Topics** are the two main types of **destinations** where messages are sent by producers and received by consumers. They form the foundation of how communication is organized in a message-driven system. Understanding how they work is essential to building reliable and scalable event-driven and microservices-based architectures.

## What is a Queue ?

A **Queue** is used in **point-to-point (P2P)** messaging.

* A **message sent to a queue** is received by **only one** consumer.
* If multiple consumers are listening to the same queue, **only one of them** will receive each message.
* This model is like a **task distribution system** or a **load balancer**.

#### Characteristics

<table><thead><tr><th width="254.29296875">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>One message, one consumer</strong></td><td>A single message goes to only one consumer.</td></tr><tr><td><strong>Message buffering</strong></td><td>If no consumer is available, the message is stored until one becomes available.</td></tr><tr><td><strong>Load balancing</strong></td><td>Messages are distributed among consumers in a round-robin or demand-based manner.</td></tr><tr><td><strong>Persistence</strong></td><td>Messages can be stored persistently to survive broker restarts.</td></tr><tr><td><strong>Redelivery</strong></td><td>If a consumer fails to acknowledge a message, the broker will <strong>redeliver</strong> it to another consumer.</td></tr></tbody></table>

{% hint style="info" %}
Imagine a help desk queue. Customers take a ticket (produce a message), and the next available support agent (consumer) helps them. No two agents handle the same ticket.
{% endhint %}

## What is a Topic?

A **Topic** is used in **publish-subscribe (pub-sub)** messaging.

* A **message sent to a topic** is delivered to **all active subscribers**.
* Each subscriber gets a **copy** of the message.
* This model is ideal for **event broadcasting** or **notifications**.

#### Characteristics

<table><thead><tr><th width="274.94140625">Feature</th><th>Description</th></tr></thead><tbody><tr><td><strong>One message, many consumers</strong></td><td>Every active subscriber receives a copy of the message.</td></tr><tr><td><strong>No buffering by default</strong></td><td>If a subscriber is offline, it may <strong>miss messages</strong> unless it's a durable subscriber.</td></tr><tr><td><strong>Durable subscriptions</strong></td><td>Subscribers can be configured to receive messages sent while they were offline.</td></tr><tr><td><strong>Broadcasting</strong></td><td>Suitable for scenarios like sending alerts or publishing changes to multiple services.</td></tr></tbody></table>

{% hint style="info" %}
Think of a topic as a public announcement system. The speaker (producer) announces something, and all people currently listening (subscribers) hear it. If someone isn't present, they won’t hear it—unless they have a recording device (durable subscription).
{% endhint %}

## Virtual Topics (Advanced Hybrid)

* Producers send to a **topic**, but consumers read from **queues** mapped to that topic.
* It combines the **broadcasting** nature of topics with the **decoupled processing** of queues.
* Ideal when each consumer group wants to independently process **all messages**.

Example destination:

```
Producer: topic://VirtualTopic.news
Consumer1: queue://Consumer.A.VirtualTopic.news
Consumer2: queue://Consumer.B.VirtualTopic.news
```

Each consumer group gets a **full copy** of the topic stream, but with queue semantics (including redelivery, persistence, etc.).

{% hint style="success" %}
Each queue gets **all messages**, and messages are processed in **point-to-point** fashion within each queue.
{% endhint %}

## **Redelivery and Dead Letter Queue (DLQ)**

#### **Redelivery Policy**

ActiveMQ allows redelivery of messages that are not acknowledged.

**Example XML configuration:**

```xml
<redeliveryPolicy maximumRedeliveries="3" redeliveryDelay="1000"/>
```

* `maximumRedeliveries`: Number of retry attempts
* `redeliveryDelay`: Delay before a message is retried

#### **DLQ (Dead Letter Queue)**

If a message fails more than the configured redelivery attempts, it is routed to the DLQ:

```
ActiveMQ.DLQ
```

This queue acts as a **quarantine** for failed messages, allowing developers to inspect or manually reprocess them.

## **Asynchronous vs Synchronous Sending**

#### **Synchronous Sending**

By default, in ActiveMQ 5, sending a message is synchronous:

* The producer waits for a broker acknowledgment before proceeding.
* More reliable but introduces latency.

```java
ActiveMQConnectionFactory factory = new ActiveMQConnectionFactory();
factory.setUseAsyncSend(false); // default
```

#### **Asynchronous Sending**

Producers can be configured for asynchronous mode:

```java
factory.setUseAsyncSend(true);
```

* Fire-and-forget behavior: messages are buffered locally and sent in batches.
* Faster, but if the broker crashes before acknowledging, messages can be lost.
* Suitable for **high-throughput, lower-guarantee** use cases.

#### **ActiveMQ Artemis (v6+)**

In Artemis (used by ActiveMQ 6), send operations are **asynchronous by default**. Synchronous behavior must be enabled explicitly.

## **Flow Control & Blocking Behavior**

When broker or destination resource limits are hit, ActiveMQ can **block** the producer to apply backpressure.

#### **producerFlowControl**

This flag controls whether the producer should block when resources are exhausted.

**Queue Policy Example:**

```xml
<policyEntry queue=">" producerFlowControl="true" memoryLimit="10mb"/>
```

* `producerFlowControl=true`: producer will **block** if the destination’s memory is full.
* `producerFlowControl=false`: message may be rejected or discarded based on policy.

#### **Memory Limit Example**

```xml
<systemUsage>
  <memoryUsage>
    <memoryUsage limit="512mb"/>
  </memoryUsage>
</systemUsage>
```

Memory is shared between destinations and can trigger blocking.

## **Message Acknowledgements**

#### **Modes**

* **AUTO\_ACKNOWLEDGE**: Messages are automatically acknowledged after processing.
* **CLIENT\_ACKNOWLEDGE**: Consumer must explicitly acknowledge using `message.acknowledge()`.
* **DUPS\_OK\_ACKNOWLEDGE**: Allows lazy acknowledgment with possible duplicates.

Unacknowledged messages are **redelivered** after a timeout or consumer failure.

## **Message Ordering Considerations**

* Queues preserve message order **per producer session and per queue**.
* If messages are redelivered or load balanced, order **might not be preserved** across consumers.
* Topics do not guarantee order across subscribers.

## **Message Expiry and TTL (Time-to-Live)**

Producers can set an expiration time for messages:

```java
producer.setTimeToLive(60000); // 60 seconds
```

If the message is not delivered before TTL, it will be discarded or sent to DLQ.

## **Message Selectors**

Consumers can filter messages using **JMS selectors**, based on message headers.

```java
consumer = session.createConsumer(queue, "priority = 'high'");
```

Only messages matching the condition are delivered.

## **Queues and Topics in Microservices (Multi-Pod Environments)**

In a containerized, auto-scaling microservice world (e.g., Kubernetes), messaging architecture plays a critical role.

### **Queue with Multiple Pods**

Use case: task distribution

* 1 producer sends messages to `order-processing.queue`
* 3 pods of `order-service` consume from the queue
* Each pod receives a **subset** of messages
* **Built-in load balancing**

### **Topic in Multi-Pod**

Use case: event broadcasting

* 1 producer sends to `event.orders.created`
* All listeners (e.g., analytics, audit, notification) receive it

Problem: in a scaled deployment (e.g., 3 pods of `email-service`), **each pod gets duplicate events**, causing over-processing.

#### **Solution: Virtual Topics**

* Producer sends to `VirtualTopic.order.events`
* Each service group listens on its own consumer queue:
  * `Consumer.email.VirtualTopic.order.events`
  * `Consumer.audit.VirtualTopic.order.events`
* Pods of `email-service` share the queue and **load-balance** processing
* Avoids duplication and supports redelivery
