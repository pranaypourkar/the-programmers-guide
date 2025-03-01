# System Characteristics

## About

System characteristics define the fundamental properties that determine how a system performs, scales, and handles failures. These characteristics help architects design robust, scalable, and fault-tolerant systems.

## **1. Scalability**

Scalability is the ability of a system to handle increasing amounts of work by adding resources. A scalable system ensures that performance does not degrade as demand grows.

### **Types of Scaling**

* **Vertical Scaling (Scaling Up)**
  * Increasing the capacity of a single server (e.g., adding more CPU, RAM, or disk).
  * Has a physical limit—hardware can only be upgraded so much.
  * Example: Upgrading a database server from 32GB RAM to 128GB RAM.
* **Horizontal Scaling (Scaling Out)**
  * Adding more servers to distribute the load.
  * Often preferred in cloud-based architectures for better redundancy.
  * Example: Adding multiple web servers behind a load balancer.
* **Auto-Scaling**
  * Dynamically adding or removing resources based on demand.
  * Used in cloud environments (AWS Auto Scaling, Kubernetes Horizontal Pod Autoscaler).

### **Challenges in Scalability**

* Data consistency across multiple nodes.
* Load balancing efficiently.
* Database sharding complexities.

## **2. Availability**

Availability refers to the **percentage of time a system remains operational and accessible**. It is usually expressed as a **percentage (e.g., 99.99%)**, often called **“nines” of availability**.

### **Availability Levels**

| Availability (%)     | Downtime per Year | Downtime per Month |
| -------------------- | ----------------- | ------------------ |
| 99% (Two nines)      | \~3.65 days       | \~7.2 hours        |
| 99.9% (Three nines)  | \~8.76 hours      | \~43.8 minutes     |
| 99.99% (Four nines)  | \~52.6 minutes    | \~4.38 minutes     |
| 99.999% (Five nines) | \~5.26 minutes    | \~26.3 seconds     |

### **Methods to Improve Availability**

* **Redundancy:** Deploying backup servers to avoid single points of failure.
* **Failover Mechanisms:** Switching to standby resources if the primary system fails.
* **Load Balancing:** Distributing traffic across multiple servers.
* **Replication:** Keeping multiple copies of data to avoid data loss.

### **Trade-offs**

* High availability often comes at the cost of **complexity and additional resources**.

## **3. Reliability**

Reliability is the ability of a system to **perform correctly and consistently over time** without failures. A reliable system **minimizes unexpected downtimes and data inconsistencies**.

### **Factors Affecting Reliability**

* **Hardware Failures:** Server crashes, disk failures.
* **Software Bugs:** Memory leaks, race conditions, deadlocks.
* **Network Failures:** Packet loss, connection timeouts.

### **Techniques to Improve Reliability**

* **Error Handling and Recovery:** Implementing retry mechanisms and circuit breakers.
* **Data Replication:** Ensuring backups exist in case of failures.
* **Testing Strategies:** Unit tests, integration tests, and chaos engineering.

### **Difference Between Availability and Reliability**

<table data-header-hidden data-full-width="true"><thead><tr><th width="171"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Aspect</strong></td><td><strong>Availability</strong></td><td><strong>Reliability</strong></td></tr><tr><td>Focus</td><td>Ensuring system is operational</td><td>Ensuring system works correctly over time</td></tr><tr><td>Metric</td><td>Uptime percentage (e.g., 99.99%)</td><td>Mean Time Between Failures (MTBF)</td></tr><tr><td>Example</td><td>A website is up 99.99% of the time</td><td>A website never crashes due to software bugs</td></tr></tbody></table>

## **4. Fault Tolerance**

Fault tolerance is the **system's ability to continue operating even when components fail**. A fault-tolerant system does not crash completely due to failures.

### **Types of Faults**

* **Transient Faults:** Temporary network failures, server timeouts.
* **Intermittent Faults:** Occasional hardware failures.
* **Permanent Faults:** Hardware crashes, disk corruption.

### **Fault Tolerance Mechanisms**

* **Redundant Components:** Standby servers, multiple database replicas.
* **Graceful Degradation:** Partial functionality when some services fail.
* **Self-Healing Systems:** Detecting and automatically recovering from failures.

### **Example**

A **fault-tolerant database** might use **leader-follower replication**. If the leader node fails, a follower takes over automatically.

## **5. Consistency**

Consistency ensures that **all clients see the same data at any given time**.

### **Types of Consistency**

* **Strong Consistency:** Every read receives the latest write.
* **Eventual Consistency:** Data is updated eventually but might be inconsistent for a short time (used in NoSQL databases).
* **Causal Consistency:** Guarantees that causally related updates appear in the correct order.

### **Trade-offs: CAP Theorem**

According to **CAP Theorem**, a distributed system can only provide **two out of three** properties:

1. **Consistency** (C) – All nodes return the same data.
2. **Availability** (A) – The system remains responsive.
3. **Partition Tolerance** (P) – The system can function even when network partitions occur.

### Example:

* SQL databases prioritize Consistency and Partition Tolerance (CP).
* NoSQL databases prioritize Availability and Partition Tolerance (AP).

## **6. Durability**

Durability ensures that **once a transaction is committed, it remains permanently stored** even in case of failures.

### **Durability Mechanisms**

* **Write-Ahead Logging (WAL):** Logging every write operation before applying it.
* **Data Replication:** Copying data to multiple locations.
* **Snapshots and Backups:** Periodic data dumps to prevent data loss.

### **Example**

A bank transaction that **deducts money from one account and adds it to another** must be **durable**. If a power outage occurs after the deduction, the system must ensure that the addition is completed when it restarts.

## Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th width="222"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Characteristic</strong></td><td><strong>Definition</strong></td><td><strong>Key Considerations</strong></td></tr><tr><td><strong>Scalability</strong></td><td>Ability to handle increased load</td><td>Vertical vs. Horizontal Scaling</td></tr><tr><td><strong>Availability</strong></td><td>Uptime percentage</td><td>Redundancy, Failover, Load Balancing</td></tr><tr><td><strong>Reliability</strong></td><td>Correct and consistent performance over time</td><td>Error Handling, Testing, Replication</td></tr><tr><td><strong>Fault Tolerance</strong></td><td>System's ability to function despite failures</td><td>Redundant components, Self-healing systems</td></tr><tr><td><strong>Consistency</strong></td><td>Ensures all users see the same data</td><td>CAP Theorem, Strong vs. Eventual Consistency</td></tr><tr><td><strong>Durability</strong></td><td>Data remains intact after crashes</td><td>Write-Ahead Logging, Data Replication</td></tr></tbody></table>
