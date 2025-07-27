# Naming Convention

## About

In ActiveMQ, consistent and descriptive naming conventions are critical for managing message destinations, especially when using features like **Virtual Topics**, **Dead Letter Queues**, and **multiple consumer groups** in a microservices architecture.

## **Traditional Queue (Producer Side)**

```
queue://<QueueName>
```

* **What it means**: The producer sends a message to a single, named queue.
* **Message flow**: One message goes to one queue.
* The broker will deliver the message to **one available consumer**.

**Example**

```
jms_destination = queue://order-processing
```

* A producer sends order-related messages to the queue named `order-processing`.

## **Traditional Queue (Consumer Side)**

Consumers listen to the **same** queue name:

```
queue://<QueueName>
```

* Each consumer will **compete** for incoming messages.
* Only **one** consumer will receive any given message.
* This is used for **load-balanced message processing** among multiple instances of the same service.

**Example**

```
jms_destination = queue://order-processing
```

* Service A has **three instances (pods)** listening to `order-processing`.
* Messages are load-balanced — each pod gets different messages.

## **Virtual Topic (Publisher-Side Topic)**

```
topic://VirtualTopic.<TopicName>
```

* This is the topic where the **producer** sends messages.
* Each message sent here is duplicated into queues for any subscribed consumers using the matching `queue://Consumer.X.VirtualTopic.<TopicName>` format.

**Example:**

```
topic://VirtualTopic.notifications
```

* Sent messages are fanned out to:
  * `queue://Consumer.A.VirtualTopic.notifications`
  * `queue://Consumer.B.VirtualTopic.notifications`
  * `queue://Consumer.C.VirtualTopic.notifications`
  * ... etc.

Each of these queues is **isolated**. One consumer group does **not interfere** with others.

## **Queue Destination (Virtual Topic Consumer Queue)**

```
queue://Consumer.<ConsumerGroup>.VirtualTopic.<TopicName>
```

**Components Breakdown:**

<table><thead><tr><th width="180.5234375">Part</th><th>Description</th></tr></thead><tbody><tr><td><code>queue://</code></td><td>Specifies the protocol and that the destination is a queue (not a topic).</td></tr><tr><td><code>Consumer</code></td><td>Prefix to indicate that this queue is a <strong>consumer-side queue</strong> for a virtual topic.</td></tr><tr><td><code>&#x3C;ConsumerGroup></code></td><td>Logical group name of the microservice or consumer. Used to create <strong>isolated queues</strong> for each group.</td></tr><tr><td><code>VirtualTopic</code></td><td>Fixed keyword required to work with <strong>Virtual Topics</strong>.</td></tr><tr><td><code>&#x3C;TopicName></code></td><td>The name of the virtual topic being subscribed to.</td></tr></tbody></table>

**Example:**

```
jms_destination = queue://Consumer.B.VirtualTopic.notifications
```

This means:

* Messages were originally published to:\
  `topic://VirtualTopic.notifications`
* ActiveMQ **automatically created a copy** of the message in a queue:\
  `queue://Consumer.B.VirtualTopic.notifications`
* This queue is **private to consumer group B**, allowing it to process messages independently from other consumers.

## **Dead Letter Queue (DLQ)**

Messages that cannot be processed successfully are sent to the Dead Letter Queue.

```
queue://ActiveMQ.DLQ
```

* Default DLQ for ActiveMQ.
* Can be customized using broker configuration.
* Helps in debugging failed message deliveries.

## **Naming in Microservices Context**

In microservices, multiple instances (pods) of the same service may consume from the same queue. The naming convention ensures:

* Messages are not duplicated between services.
* Each service or bounded context receives its **own copy** of the message (if using Virtual Topics).
* Load balancing happens within the group, not across groups.

#### Example Use Case

**Producer:**

```
jms_destination = topic://VirtualTopic.user.events
```

**Consumers:**

```
queue://Consumer.audit.VirtualTopic.user.events
queue://Consumer.notification.VirtualTopic.user.events
queue://Consumer.analytics.VirtualTopic.user.events
```

* `audit`, `notification`, and `analytics` services all get the **same message**, but in their own isolated queues.
* Each service can independently scale with multiple pods consuming messages from their respective queues.

## **Best Practices for Naming**

<table><thead><tr><th width="502.25">Best Practice</th><th>Reason</th></tr></thead><tbody><tr><td>Use descriptive consumer group names (e.g., <code>Consumer.NotificationsService</code>)</td><td>Helps trace ownership and intent</td></tr><tr><td>Keep topic names generic (e.g., <code>VirtualTopic.user.events</code>)</td><td>Allows reuse across services</td></tr><tr><td>Avoid hardcoding destination names in code</td><td>Use environment variables or configuration files</td></tr><tr><td>Prefix DLQs with service name (e.g., <code>DLQ.NotificationsService</code>)</td><td>Easier to manage failures per service</td></tr><tr><td>Use lowercase and hyphens or dots for topic/queue names</td><td>Improves readability and consistency</td></tr></tbody></table>
