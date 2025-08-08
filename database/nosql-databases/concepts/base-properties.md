---
hidden: true
---

# BASE Properties

## About

BASE (Basically Available, Soft state, Eventually consistent) is an alternative model to ACID used in distributed NoSQL databases. Unlike ACID, which prioritizes strong consistency, BASE focuses on availability, performance, and scalability by allowing temporary inconsistencies.

## Why BASE?

* In large-scale distributed systems (e.g., Amazon DynamoDB, Apache Cassandra, MongoDB), achieving **strong ACID consistency is costly** and impacts availability.
* **The CAP Theorem states** that a distributed database **cannot guarantee Consistency, Availability, and Partition Tolerance at the same time**.
* BASE sacrifices **strong consistency** to ensure **high availability and partition tolerance**.

## **1. Basically Available (BA)**

* **The system is always available to respond to requests**, even if some nodes fail.
* Instead of blocking due to consistency requirements, **BASE systems return partial or stale data**.
* Ensures **low-latency responses** for users.

**Example**

* **Amazon DynamoDB** always responds to read requests, but the data might be **slightly outdated** if updates are still propagating across servers.
* **MongoDB** allows queries even when replicas are not fully synchronized.

## **2. Soft State (S)**

* The database **does not have to be in a strict, consistent state at all times**.
* Data might be **changing due to background replication or eventual synchronization**.
* Nodes can **temporarily have different versions of the same data**.

**Example**

* In **Cassandra**, data changes asynchronously across replicas, and it may take some time before all nodes reflect the same data.
* **Redis caches data** that may differ from the primary database for a short time.

## **3. Eventually Consistent (E)**

* The system **guarantees that all nodes will eventually have the same data**, but not immediately.
* Instead of **strong consistency**, BASE databases offer **eventual consistency**, meaning:
  * Updates **propagate over time**.
  * Different nodes may return **different results for the same query** temporarily.
  * Reads might return **old values** if updates are still syncing.

**Example**

* **DNS servers**: If you update a website’s IP address, it **takes time** to propagate across the world.
* **Amazon S3**: Newly uploaded files may **take time** before appearing across all data centers.

## **How BASE Works in NoSQL Databases**

### **1. Eventual Consistency Mechanisms**

To maintain consistency over time, BASE databases use:

* **Quorum-based writes (DynamoDB, Cassandra)**:
  * Updates are written to **a majority of nodes** and eventually copied to all nodes.
* **Vector Clocks (Cassandra, Riak)**:
  * Tracks multiple versions of an object and merges them when possible.
* **Conflict Resolution (MongoDB, CouchDB)**:
  * If multiple versions of data exist, rules like **latest timestamp wins** are applied.

#### **Example: Eventual Consistency in Cassandra**

```sql
INSERT INTO users (id, name) VALUES (1, 'Alice') USING CONSISTENCY QUORUM;
```

* The data is **written to a subset of nodes** first, then **replicated** to all nodes.
* If another client **reads the data too soon**, they might **see old values**.

### **2. BASE in CAP Theorem**

BASE databases **sacrifice consistency** to ensure **availability and partition tolerance**:

* CA (Consistency + Availability) → SQL databases (ACID, MySQL, PostgreSQL).
* AP (Availability + Partition Tolerance) → NoSQL (BASE, DynamoDB, Cassandra).
* CP (Consistency + Partition Tolerance) → Some NoSQL (Zookeeper, HBase, MongoDB in strong consistency mode).
