# Database Scaling via Sharding

## **About Database Scaling**

Database scaling refers to methods used to **handle increased loads** on a database system by improving **performance, availability, and throughput**. There are two primary types of database scaling:

1. **Vertical Scaling (Scaling Up)** → Increasing resources (CPU, RAM, storage) of a single machine.
2. **Horizontal Scaling (Scaling Out)** → Distributing data across multiple machines to manage larger workloads.

**Database Sharding** is a form of **horizontal scaling**, where data is partitioned across multiple database instances.

## **What is Database Sharding?**

Database sharding is a technique used to **split a large database into smaller, independent databases** (called shards) to distribute the workload efficiently. Each shard contains a **subset of the total data** and operates independently, reducing contention and improving performance.

{% hint style="info" %}
Sharding means splitting the data across multiple machines while ensuring we have a way to figure out which data is on which machine.
{% endhint %}

**Example**: A user database for a social media platform might be sharded based on **user ID ranges**, where:

* Users **1-1M** → Stored in **Shard 1**
* Users **1M-2M** → Stored in **Shard 2**
* And so on...

Each shard **functions like a standalone database**, reducing query load and improving response time.

{% hint style="success" %}
### **Popular Databases Supporting Sharding**

🔹 **SQL Databases:** MySQL (MySQL Fabric), PostgreSQL (Citus), MariaDB, Vitess\
🔹 **NoSQL Databases:** MongoDB, Cassandra, DynamoDB, HBase
{% endhint %}

## **Objectives of Database Sharding**

* **Performance Optimization** → Reduces query load by distributing requests across multiple shards.
* **High Availability** → Failure of one shard does not impact the entire system.
* **Scalability** → Enables horizontal scaling by adding more shards as data grows.
* **Cost Efficiency** → Avoids expensive monolithic database servers by distributing load across commodity hardware.
* **Improved Write Throughput** → Different shards can handle concurrent write operations independently

## **How Database Sharding Works ?**

Sharding is implemented by defining **sharding keys**, which determine how data is distributed. Some common sharding techniques include:

### **A. Range-Based Sharding**

Data is divided into shards based on a **continuous range of values** (e.g., user IDs, timestamps).

**Example**:

* User IDs **1–1000** → **Shard 1**
* User IDs **1001–2000** → **Shard 2**

**Pros:** Simple implementation & Efficient range queries

**Cons:** Uneven distribution (hot shards if some ranges are more active)

### **B. Hash-Based Sharding**

A **hash function** is applied to a column (e.g., `user_id % number_of_shards`) to distribute data evenly across shards.

**Example**:

* `hash(user_id) % 4` → Determines which of 4 shards the data will go into

**Pros:** Even data distribution & Avoids hotspot issues

**Cons:** Harder to query across multiple shards. Rebalancing is complex when adding/removing shards

### **C. Directory-Based Sharding**

A **lookup table** (directory) maps data to the appropriate shard.

**Example**: A mapping table determines that **"customers from US"** go to **Shard A** and **"customers from EU"** go to **Shard B**.

**Pros:** Full control over shard placement. Flexible data distribution

**Cons:** Single point of failure (if directory is unavailable). Increased complexity

## **Sharding vs. Replication**

<table data-full-width="true"><thead><tr><th>Feature</th><th width="358">Sharding</th><th>Replication</th></tr></thead><tbody><tr><td><strong>Definition</strong></td><td>Splits data across multiple nodes</td><td>Copies full dataset across multiple nodes</td></tr><tr><td><strong>Purpose</strong></td><td>Improves scalability</td><td>Improves availability &#x26; redundancy</td></tr><tr><td><strong>Query Execution</strong></td><td>Requires routing queries to correct shard</td><td>Queries can be served from any replica</td></tr><tr><td><strong>Write Scalability</strong></td><td>High (each shard operates independently)</td><td>Low (writes must sync to all replicas)</td></tr></tbody></table>

{% hint style="success" %}
Sharding is best for handling massive datasets, while replication is better for read-heavy workloads.
{% endhint %}

## **Challenges of Database Sharding**

1. **Complex Querying** → Queries spanning multiple shards require additional logic.
2. **Rebalancing Shards** → Adding/removing shards requires **redistributing** data efficiently.
3. **Cross-Shard Joins** → SQL joins become inefficient across shards.
4. **Data Consistency** → Ensuring ACID compliance across shards can be difficult.
5. **Operational Complexity** → More shards mean **higher maintenance efforts**.

## **When to Use Database Sharding?**

### **Sharding is beneficial when:**

* Your database size exceeds a single machine's capacity.
* You experience high write throughput that a single database cannot handle.
* Your system needs high availability and fault tolerance.

### **Avoid sharding if:**

* Your database is not large enough to justify complexity.
* Most of your queries require joins across multiple shards.
* A simple read-replication setup is sufficient for scaling.
