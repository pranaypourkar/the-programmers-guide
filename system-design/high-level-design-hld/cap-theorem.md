# CAP Theorem

## About

CAP Theorem, also known as Brewer’s Theorem, is a concept in distributed systems, introduced by computer scientist Eric Brewer in 2000. It states that in any distributed data store, it is impossible to simultaneously achieve all three of the following guarantees:

1. **Consistency (C)**: Every read receives the most recent write or an error. In other words, all nodes in the system return the same data at any given time.
2. **Availability (A)**: Every request (read or write) receives a response (success or failure) without guarantee that it contains the most recent write.
3. **Partition Tolerance (P)**: The system continues to operate despite network partitions or communication breakdowns between parts of the system.

<figure><img src="../../.gitbook/assets/image (529).png" alt=""><figcaption></figcaption></figure>

## CAP Theorem

### **1. Consistency (C)**

* Consistency means that after an update is made, all nodes (or replicas) in the distributed system see the same data at the same time. A consistent system appears as if it is running on a single node.
* If we read data from any node in the system, the data should be identical.

**Real-world impact**: If a system is consistent, even during a failure, all nodes reflect the same data. However, it can lead to increased latency or reduced availability as nodes need to synchronize.

**Example**: Traditional relational databases (RDBMS) often guarantee consistency, where once a transaction is committed, all reads will reflect the latest write.

### **2. Availability (A)**

* Availability means the system guarantees that every request (read or write) will receive a response, even if some of the nodes are down.
* There’s no guarantee that this response contains the latest data (since the system might return a previous version of the data if some nodes haven’t synchronized).

**Real-world impact**: High availability ensures that users are not left waiting indefinitely for a response, but it might serve stale data to some users during partition scenarios.

**Example**: Systems like DNS or NoSQL databases like Cassandra prioritize availability, ensuring responses to requests even during a failure.

### **3. Partition Tolerance (P)**

* Partition tolerance means the system continues to function even when there is a communication breakdown (partition) between nodes.
* In distributed systems, partitions are inevitable due to network failures, and the system must tolerate such partitions while maintaining either consistency or availability.

**Real-world impact**: Partition tolerance is usually a requirement in distributed systems, as network failures or latency issues can lead to nodes being unable to communicate with each other.

**Example**: NoSQL databases like MongoDB and Cassandra are designed with partition tolerance in mind, ensuring that even if nodes are temporarily disconnected, the system continues to operate.

## The Trade-Off (Consistency, Availability, Partition Tolerance)

The CAP Theorem essentially says that a distributed system can only guarantee **two out of the three** properties simultaneously. This creates the following trade-offs -

### 1. **CP Systems (Consistency + Partition Tolerance)**

In a **CP system**, we prioritize **Consistency** and **Partition Tolerance**. This means that:

* **Consistency**: All nodes in the system will always return the most up-to-date, consistent data. No matter which node we query, we get the most recent version of the data.
* **Partition Tolerance**: The system will continue to function even if a network partition (a break in communication between nodes) occurs. It ensures that despite the partition, the system does not end up in a split-brain scenario where different nodes have conflicting data.

#### **What is sacrificed?**

**Availability**: During a partition, some parts of the system might become unavailable to maintain consistency. If two nodes can’t communicate, the system may choose to block reads or writes to prevent inconsistencies. This results in increased latency or downtime for parts of the system.

#### **Example Scenarios:**

* **Banking systems**: In financial transactions, consistency is critical. We cannot afford to show inconsistent account balances or allow double spending, so systems will prioritize consistency and block requests during partitions.
* **HBase** and **Zookeeper** are examples of CP systems, where they block some operations in favor of ensuring that data is always consistent across nodes, but this comes at the cost of availability during partitions.

#### **CP Trade-offs in Practice:**

* When we need **strong guarantees of correctness**, CP systems are ideal.
* However, expect that when partitions happen (e.g., network outages or node failures), some parts of the system may become unavailable until the partition heals.

### 2. **AP Systems (Availability + Partition Tolerance)**

In an **AP system**, we prioritize **Availability** and **Partition Tolerance**. This means that:

* **Availability**: The system guarantees that every request (whether a read or write) will receive a response, even if some of the nodes are down or disconnected. The system remains available to users, even if some parts of the system experience network failures.
* **Partition Tolerance**: Like in CP systems, AP systems ensure that the system remains operational despite network partitions. Even if nodes cannot communicate due to a partition, the system continues to respond to queries, allowing operations to continue on isolated partitions.

#### **What is sacrificed?**

**Consistency**: Since nodes may not be able to communicate, the system sacrifices consistency. Different nodes might have slightly different views of the data, leading to **eventual consistency**. This means that after a partition heals, the system will reconcile data between nodes, and eventually, all nodes will agree on the same state.

#### **Example Scenarios:**

* **Social media platforms**: If you post a photo on a social media site, you expect that the site will remain available, even if some data centers are temporarily out of sync. AP systems prioritize availability, allowing users to continue interacting with the platform, while the system resolves inconsistencies later.
* **Amazon DynamoDB**, **Cassandra**, and **Riak** are examples of AP systems. These databases prioritize high availability and partition tolerance at the expense of strong consistency, offering eventual consistency instead.

#### **AP Trade-offs in Practice:**

* If availability is critical to your business (e.g., e-commerce, social media, real-time applications), AP systems are preferred.
* The downside is that during partitions, clients might read stale or inconsistent data until the partition is resolved and data converges.

### 3. **CA Systems (Consistency + Availability)**

In a **CA system**, we prioritize **Consistency** and **Availability**. This means that:

* **Consistency**: The system guarantees that all nodes return the most up-to-date data. Every read reflects the most recent write, so all clients see a consistent view of the data.
* **Availability**: The system guarantees that every request gets a response, even if nodes are down. There is no scenario where the system becomes unresponsive.

#### **What is sacrificed?**

**Partition Tolerance**: CA systems do not tolerate network partitions. If there is a network partition (a break in communication between nodes), the system cannot guarantee both consistency and availability. It must either stop responding or sacrifice consistency, and most CA systems choose to stop responding, leading to system downtime during a partition.

#### **Example Scenarios:**

* **Single-node relational databases (RDBMS)**: Traditional databases like MySQL and PostgreSQL that run on a single node are typically CA. They are highly available, and since there is no partition in a single-node setup, consistency is guaranteed.
* **Enterprise applications**: Systems that require both high availability and consistency within a single, non-distributed node may prefer a CA approach, but this doesn’t work well in distributed environments.

#### **CA Trade-offs in Practice:**

* CA systems are suited for non-distributed, **single-node architectures** where partitioning is not a concern (since there’s only one node).
* In practice, most modern systems are distributed, making CA systems impractical for larger, scalable applications. CA systems break down in the presence of network partitions because we must give up either availability or consistency in such cases.

## Real-World Example of Trade-Offs

### **1. Cassandra (AP System):**

* Cassandra is designed for high availability and partition tolerance.
* If a network partition occurs, Cassandra will still allow reads and writes to continue, even if different nodes hold slightly different data. After the partition is resolved, Cassandra uses **eventual consistency** to reconcile the differences between nodes.
* It sacrifices **strong consistency** during the partition.

### **2. HBase (CP System):**

* HBase guarantees strong consistency and partition tolerance.
* If a network partition happens, HBase may block reads and writes to ensure that all data is consistent across nodes. This means some operations may become unavailable until the partition is healed.
* It sacrifices **availability** to maintain consistency.

### **3. Single-node PostgreSQL (CA System):**

* A single-node relational database like PostgreSQL guarantees consistency and availability as long as no network partition happens (since it’s a single node).
* However, if we distribute PostgreSQL across multiple nodes, we would need to choose between consistency and availability during a network partition, often sacrificing partition tolerance.

## Why we can't have all 3 (C, A, P) at once ?

We can't have **Consistency (C)**, **Availability (A)**, and **Partition Tolerance (P)** all at once in a distributed system due to the inherent limitations in handling network partitions.

### 1. **Network Partitions** are inevitable

* In any distributed system, **network partitions** can happen. A partition occurs when some nodes in the system are unable to communicate with others due to network issues (like a node going down, network latency, or a network link failure). This is a fundamental challenge because, once a partition occurs, some parts of the system cannot communicate with others.

### 2. **Partition Tolerance (P) is mandatory**

*   **Partition tolerance** is required and a must to have in modern distributed systems because network partitions can occur unexpectedly. The system must continue operating (serving requests, processing data, etc.) even when some nodes are unreachable. Without partition tolerance, the system would simply go down every time a network partition occurs, which is unacceptable for large-scale, resilient applications.

    Since partitions are unavoidable, a distributed system must either:

    * **Handle them and tolerate the partition** (allowing nodes to operate independently for some time),
    * **Or stop all operations during a partition**, which breaks availability and limits the utility of the system.

### 3. **The Core CAP Trade-off**

Given that partitions will happen and that partition tolerance is essential, a distributed system must choose between **Consistency** and **Availability** during a partition:

#### **If the system chooses Consistency (C):**

* **Consistency** means all nodes must return the latest, correct data. If a network partition happens and some nodes can’t communicate with others, maintaining consistency would require stopping operations in some parts of the system to ensure that no inconsistent data is read or written.
* **Trade-off**: This means the system sacrifices **Availability (A)**. Some users won’t be able to get a response until the partition is resolved and the system can guarantee that the data is consistent across all nodes.

#### **If the system chooses Availability (A):**

* **Availability** means that every request gets a response, regardless of network partitions. During a partition, nodes that cannot communicate must continue operating independently and provide answers to user requests.
* **Trade-off**: This sacrifices **Consistency (C)**. Since nodes are unable to communicate, they might return **stale or inconsistent data**. The system is **available** but may temporarily serve different versions of data from different parts of the system.

### **Scenario: Distributed Database with Partition**

Let’s break down a real-world scenario to understand why it's impossible to achieve all three at the same time:

Imagine we have a distributed database that spans multiple data centers. Suddenly, there’s a network partition that isolates some of the data centers from each other, meaning nodes in one region can’t talk to nodes in another.

#### **Option 1: Prioritize Consistency and Partition Tolerance (CP)**

* In this case, to maintain **consistency**, the system must ensure that all nodes agree on the current state of the data before any new reads or writes are processed.
* But since some nodes are isolated due to the partition, they cannot confirm the state of the data with the other nodes. To prevent inconsistencies, the system will **block reads and writes** until the partition is resolved and the nodes can communicate again.
* **Outcome**: The system remains consistent, but during the partition, it sacrifices **availability**. Some parts of the system become unavailable until the partition is healed.

#### **Option 2: Prioritize Availability and Partition Tolerance (AP)**

* In this case, the system continues to allow reads and writes during the partition, ensuring that all nodes remain **available** to handle user requests.
* However, since the nodes cannot communicate with each other, they may start working with slightly different versions of the data, leading to **temporary inconsistencies**.
* **Outcome**: The system remains available, but the data might be inconsistent across different nodes during the partition.

#### **Option 3: Prioritize Consistency and Availability (CA)**

* In this case, we want to maintain both **consistency** and **availability**. The system must return the correct, consistent data for every request, and it must stay available to all users.
*   But when a partition happens, maintaining both becomes impossible. Since nodes in different parts of the system can’t communicate, we either have to:

    * **Allow operations to continue independently (which breaks consistency)**, or
    * **Block operations (which breaks availability)**.

    We can’t do both at the same time because the partition prevents nodes from ensuring consistency while staying available.
* **Outcome**: Partition tolerance is sacrificed. The system cannot tolerate network partitions and either stops responding or provides inconsistent data.

### 4. Visualizing the Impossibility

* **Without a network partition**, we could theoretically have **C**, **A**, and **P** together because all nodes are able to communicate freely.
* **With a network partition**, nodes can’t exchange information, so we’re forced to choose:
  * Do we want all nodes to return the same, consistent data (Consistency)? Then some nodes may need to go offline until the partition heals.
  * Or do we want the system to remain fully operational and available (Availability)? Then some nodes might return outdated or inconsistent data because they can’t communicate with the rest of the system.

### 5. Summary of the Conflict

1. **Partition tolerance (P)** is a fundamental requirement in any distributed system because partitions are unavoidable.
2. When a partition happens, the system can either:
   * **Remain available (A)** and serve all requests, but risk returning inconsistent data.
   * **Ensure consistency (C)** by forcing some nodes to block operations, sacrificing availability.

Since partitions will happen, we must choose between **Consistency** or **Availability**. We cannot have both while also ensuring that the system tolerates network partitions.

This is why the CAP Theorem states that **Consistency, Availability, and Partition Tolerance cannot all be guaranteed simultaneously** in a distributed system. We must choose two.
