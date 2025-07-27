# ActiveMQ

## About

**Apache ActiveMQ** is an open-source, multi-protocol, Java-based message broker designed to facilitate **asynchronous communication** in **distributed systems**. It plays a foundational role in **Event Driven Architecture (EDA)** by acting as the mediator between producers and consumers, enabling loose coupling and high availability.

At its core, ActiveMQ is based on the **Message-Oriented Middleware (MOM)** paradigm. MOM enables software components or applications to communicate and coordinate actions by exchanging messages, without needing to be tightly integrated or aware of each other’s internal workings.

This decoupling is achieved through two primary message communication models:

1. **Point-to-Point (Queue-based)**: One producer sends a message, and one consumer receives it.
2. **Publish-Subscribe (Topic-based)**: One producer broadcasts a message, and multiple consumers can receive it.

ActiveMQ abstracts these models into its JMS-compliant API and enhances them with robust delivery, persistence, and routing mechanisms.

{% hint style="success" %}
**Official Resources**

* **Website**:\
  [https://activemq.apache.org/](https://activemq.apache.org/)
* **Documentation** (for ActiveMQ "Classic"):\
  [https://activemq.apache.org/components/classic/](https://activemq.apache.org/components/classic/)
* **Download Page**:\
  [https://activemq.apache.org/components/classic/download/](https://activemq.apache.org/components/classic/download/)
* **GitHub Repository**:\
  [https://github.com/apache/activemq](https://github.com/apache/activemq)
{% endhint %}

## Role in Event Driven Architecture

In an Event Driven Architecture, ActiveMQ acts as the **event transport layer**. It enables:

* **Decoupling of services**: Services don't call each other directly but communicate via messages.
* **Scalability**: Messages can be load-balanced across consumers.
* **Asynchronous processing**: Producers send messages and move on without waiting for responses.
* **Resilience**: Messages can be stored and retried, enabling fault-tolerant behavior.

## Architectural Benefits of Using ActiveMQ

* **Separation of Concerns**: Services focus on producing/consuming events without knowing each other's business logic.
* **Time Independence**: Senders and receivers do not need to be active at the same time.
* **Resilience**: System remains operational even when certain components are down or lagging behind.
* **Performance Optimization**: High throughput and reduced bottlenecks with asynchronous processing.

## ActiveMQ Components

<table><thead><tr><th width="170.23828125">Component</th><th>Description</th></tr></thead><tbody><tr><td><strong>Broker</strong></td><td>The central server that manages message routing between producers and consumers.</td></tr><tr><td><strong>Producer</strong></td><td>Application that sends messages to a queue or topic.</td></tr><tr><td><strong>Consumer</strong></td><td>Application that receives messages from a queue or topic.</td></tr><tr><td><strong>Queue</strong></td><td>Used in point-to-point messaging. Only one consumer processes a message.</td></tr><tr><td><strong>Topic</strong></td><td>Used in publish-subscribe messaging. All active subscribers receive the message.</td></tr><tr><td><strong>Virtual Topic</strong></td><td>Hybrid model where messages published to a topic are copied to multiple consumer queues.</td></tr><tr><td><strong>Persistence Store</strong></td><td>KahaDB, JDBC or other databases used to store messages for durability.</td></tr></tbody></table>

## Messaging Patterns Supported

ActiveMQ supports multiple messaging patterns that are essential in real-world systems:

* **Command Pattern**: Systems send commands for other services to act upon.
* **Event Notification**: Inform other systems about state changes or events.
* **Request/Reply**: A pattern where the sender expects a response back (though not ideal for high throughput).
* **Retry with Backoff**: Built-in support for redelivery policies and dead-letter queues.

## Protocols and Interoperability

ActiveMQ supports several messaging protocols, making it flexible and integrable across various languages and platforms:

* **OpenWire** (native)
* **AMQP**
* **MQTT**
* **STOMP**
* **REST & WebSocket**

This makes it suitable for heterogeneous environments, including **IoT**, **JavaEE**, **microservices**, and **legacy systems**.

## ActiveMQ Versions

Apache ActiveMQ exists in two major forms:

<table data-full-width="true"><thead><tr><th width="170.96484375">Variant</th><th>Also Known As</th><th>Description</th></tr></thead><tbody><tr><td><strong>ActiveMQ Classic</strong></td><td>ActiveMQ 5.x</td><td>The original and most widely used version. Stable, mature, feature-rich.</td></tr><tr><td><strong>ActiveMQ Artemis</strong></td><td>ActiveMQ 6.x (formerly HornetQ)</td><td>High-performance, next-generation broker designed for scalability and modern protocols.</td></tr></tbody></table>

<table><thead><tr><th width="147.68359375">Feature</th><th width="268.76171875">ActiveMQ Classic</th><th>ActiveMQ Artemis</th></tr></thead><tbody><tr><td>JMS Version</td><td>1.1</td><td>2.0</td></tr><tr><td>Protocols</td><td>OpenWire, STOMP, MQTT, AMQP</td><td>OpenWire, Core, AMQP 1.0, MQTT, STOMP</td></tr><tr><td>Performance</td><td>Moderate</td><td>High</td></tr><tr><td>I/O</td><td>Blocking</td><td>Asynchronous</td></tr><tr><td>Scalability</td><td>Limited</td><td>High</td></tr><tr><td>Clustering</td><td>Basic</td><td>Built-in, advanced</td></tr><tr><td>Suitability</td><td>Legacy systems, ease of use</td><td>Modern, high-scale systems</td></tr></tbody></table>
