# Version Overview

## About

Apache ActiveMQ has evolved significantly over the years, offering multiple distributions that serve different architectural and performance requirements. This page provides a complete overview of ActiveMQ’s versions, their purpose, and guidance on choosing the right version for your needs.

ActiveMQ is available in **two main distributions**:

1. **ActiveMQ “Classic”** (also called **ActiveMQ 5.x**)
2. **ActiveMQ Artemis** (initially referred to as **ActiveMQ 6**, but now developed independently)

Both are maintained by the Apache Software Foundation, but they differ in architecture, performance capabilities, and intended use cases.

## ActiveMQ Classic (5.x Series)

**Overview**

ActiveMQ Classic is the original implementation of ActiveMQ and has been widely adopted in production systems for over a decade. It is designed around the JMS 1.1 specification and provides rich enterprise-level features.

**Key Features**

* Full support for JMS 1.1
* Support for various protocols: OpenWire (native), STOMP, AMQP, MQTT, and WebSocket
* Virtual Topics for combining queue and topic semantics
* Master-Slave failover for high availability
* Pluggable persistence using KahaDB, JDBC, LevelDB, etc.
* Embedded broker support for lightweight deployments
* Mature ecosystem, tools, and documentation

**Use Cases**

* Java-based enterprise applications
* Systems requiring JMS compliance
* Legacy integrations and back-office automation

**Limitations**

* Single-threaded persistence store can become a bottleneck under high load
* Not built from the ground up for modern multi-core concurrency
* More complex clustering setup compared to Artemis

## ActiveMQ Artemis

**Overview**

ActiveMQ Artemis is the next-generation message broker, initially developed as part of the HornetQ project (from JBoss/Red Hat). It was donated to Apache and serves as the modern, high-performance successor to ActiveMQ Classic.

**Key Features**

* Full support for JMS 2.0
* Designed for high throughput and low latency
* Asynchronous, non-blocking architecture
* Core messaging API (in addition to JMS)
* Support for advanced protocols: AMQP, STOMP, MQTT, OpenWire, and more
* Advanced message routing with address-based routing
* Built-in clustering, high availability, and replication
* Pluggable storage engines and advanced journaling (via high-performance disk I/O)

**Use Cases**

* Cloud-native and containerized applications
* Real-time analytics pipelines
* Systems requiring high throughput and minimal latency
* Applications using JMS 2.0 or non-Java clients

**Limitations**

* Smaller user base compared to Classic (though growing steadily)
* Steeper learning curve if migrating from Classic
* Some plugins and community extensions may not yet support Artemis

## Comparison

<table><thead><tr><th width="147.83203125">Feature</th><th>ActiveMQ Classic (5.x)</th><th>ActiveMQ Artemis</th></tr></thead><tbody><tr><td>JMS Version</td><td>1.1</td><td>2.0</td></tr><tr><td>Architecture</td><td>Thread-per-connection</td><td>Asynchronous, non-blocking</td></tr><tr><td>Performance</td><td>Moderate</td><td>High throughput, low latency</td></tr><tr><td>Persistence</td><td>KahaDB, JDBC</td><td>Advanced journal-based storage</td></tr><tr><td>Protocols</td><td>OpenWire, MQTT, AMQP, STOMP</td><td>Same as Classic + more efficient protocol stack</td></tr><tr><td>Clustering</td><td>Master-Slave, Network of Brokers</td><td>Built-in replication and clustering</td></tr><tr><td>Management</td><td>JMX, Web Console</td><td>JMX, CLI, Web Console</td></tr><tr><td>Maturity</td><td>Highly mature, widely adopted</td><td>Modern, actively developed</td></tr></tbody></table>

## Version Lifecycle and Stability

* **ActiveMQ Classic** is stable and still actively maintained, with regular bug fixes and minor enhancements.
* **ActiveMQ Artemis** is under active development and receives frequent updates focused on performance improvements and new features.

Both distributions are maintained by the Apache ActiveMQ team, and no official end-of-life has been announced for either.

## Choosing the Right Version

Use the following criteria to decide which version fits your needs:

* Choose **ActiveMQ Classic** if:
  * We need a well-established JMS 1.1-compliant broker
  * Our system is already integrated with it
  * We need full support for Virtual Topics and legacy enterprise patterns
* Choose **ActiveMQ Artemis** if:
  * We are building a new system or migrating to microservices
  * We require JMS 2.0 or higher performance
  * We are integrating with multiple non-Java clients
  * We need scalable, modern messaging with efficient clustering

## Release Cycles

* **ActiveMQ Classic** typically follows a slower release cycle with focus on stability.
* **ActiveMQ Artemis** has a more frequent release cadence with a focus on new features and performance improvements.

We can track releases on their respective Apache project pages:

* [ActiveMQ Classic Releases](https://activemq.apache.org/components/classic/download/)
* [ActiveMQ Artemis Releases](https://activemq.apache.org/components/artemis/download/)



