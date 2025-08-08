# Transactions

## About

In traditional relational databases, **transactions** are fundamental units of work that guarantee **atomicity, consistency, isolation, and durability (ACID)**. However, in the NoSQL world - where performance, scalability, and availability are often prioritized - support for transactions can vary significantly.

Many NoSQL databases **relax ACID properties** in favor of eventual consistency and horizontal scalability. Still, the concept of transactions remains critical, especially for use cases where **data integrity across multiple operations or entities must be preserved**.

NoSQL systems typically support:

* **Single-document transactions** (common in document stores like MongoDB),
* **Lightweight multi-operation transactions** (as in Redis or Cassandra), and
* **Full ACID-compliant multi-document transactions** (less common, but possible in some newer NoSQL systems).

## **Why Transactions Matter in NoSQL ?**

Although many NoSQL systems are designed to scale without rigid transactional guarantees, there are scenarios where **transactions are not optional**:

#### **1. Data Integrity**

Transactions are essential when a sequence of operations must succeed or fail as a unit - for example, debiting one account and crediting another in a financial system.

#### **2. Application Logic Simplification**

Without transactions, developers must handle **partial failures manually**, adding complexity to the codebase. Proper transactional support removes this burden and reduces the chance of bugs.

#### **3. Coordinating Multi-Entity Updates**

In cases where multiple related records (e.g., user profile and order records) need to be updated together, transactions help **maintain logical consistency**.

#### **4. Recovery and Rollbacks**

Transactions enable systems to **rollback changes** in case of failure, ensuring the database doesn't end up in a partially updated or corrupt state.

#### **5. Bridging Eventual Consistency**

Even in eventually consistent systems, lightweight transactional mechanisms can help bridge the gap by offering **short-term guarantees**, often through local or scoped transactions.

## Types of Transactions in NoSQL

Unlike traditional relational databases that often offer full ACID transactions by default, NoSQL databases offer a **spectrum of transactional support**, each optimized for specific performance or scalability goals. Understanding these types is key to applying the right strategy in different use cases.

### 1. Single-Document Transactions

* Supported by many document stores (e.g., **MongoDB**, **Couchbase**).
* All operations on a single document are **atomic** - either all succeed or none do.
* Useful for scenarios where related data is **embedded** in one object or record.

### 2. Local (Node-Level) Transactions

* Applied to operations that are **confined to a single node or partition** in the database.
* Ensures atomicity within that local scope.
* Example: **Cassandra’s lightweight transactions** use a Paxos-based protocol to ensure consistency for row-level updates.

### 3. Multi-Document Transactions

* Some newer NoSQL systems (e.g., **MongoDB 4.0+**, **FoundationDB**) support ACID-compliant multi-document transactions.
* Often comes with trade-offs in terms of **performance, latency, and complexity**, especially in distributed setups.

### 4. Distributed Transactions

* Involves coordinating updates across multiple shards or partitions.
* Typically **avoided in NoSQL** systems due to high overhead, though some solutions implement them using **2-phase commit (2PC)** or consensus protocols like **Raft** or **Paxos**.
* Useful in systems that prioritize correctness over throughput.

### 5. Application-Level Transactions

* Where the database doesn't support the desired transactionality, developers build it in the **application logic**, using compensating actions or idempotency techniques.
* Offers flexibility but increases **development and testing complexity**.

## How NoSQL Systems Implement Transactions ?

Due to the distributed and decentralized architecture of NoSQL systems, implementing transactions is far from trivial. The strategies differ depending on the database model and the level of transactional guarantee required.

#### **1. Document Stores (e.g., MongoDB, Couchbase)**

* **MongoDB** supports:
  * **Atomic operations** on individual documents by default.
  * **ACID-compliant multi-document transactions** in replica sets and sharded clusters.
* Internally relies on **write-ahead logging**, **journaling**, and **locking mechanisms** for consistency.

#### **2. Key-Value Stores (e.g., Redis)**

* Use **optimistic concurrency control** or **pipelining** to simulate transactional behavior.
* Redis supports `MULTI` and `EXEC` commands to queue multiple operations and execute them atomically.
* However, rollback is limited - if an error occurs, only unexecuted commands are discarded.

#### **3. Wide-Column Stores (e.g., Cassandra, HBase)**

* **Cassandra** uses **lightweight transactions (LWT)** for conditional updates using Paxos.
* Not meant for general-purpose ACID transactions - intended for limited, high-consistency use cases.

#### **4. Graph Databases (e.g., Neo4j)**

* Neo4j supports **fully ACID-compliant transactions** since its storage is typically non-distributed.
* Transactions span multiple nodes and relationships in the graph and include rollback and isolation.

#### **5. Distributed Consensus (e.g., FoundationDB, CockroachDB)**

* Built around **consensus protocols** (like Paxos, Raft) to guarantee full transactional semantics across distributed nodes.
* Sacrifice some write throughput for **strong consistency and serializability**.

## When to Use Transactions ?

In NoSQL systems, transactions are **not always necessary**, and in many cases, they are deliberately avoided to gain better scalability and performance. However, there are specific scenarios where transactions become essential - not only to ensure correctness but also to simplify logic and protect data integrity.

Below are the most common situations where using transactions in NoSQL is justified and often recommended:

#### **1. Financial or Monetary Operations**

When working with operations that involve **money, credits, or balances**, correctness is non-negotiable. For example:

* Transferring funds between two user accounts.
* Charging a customer and updating their order status.
* Managing gift card balances or loyalty points.

Even a slight inconsistency in these workflows can lead to **loss of money, legal risk, or user distrust**. Transactions help ensure that **either all steps succeed, or none do.**

#### **2. Multi-Step Workflows with Dependencies**

In workflows where multiple steps **must succeed together**, transactions protect against partial updates:

* Creating a user and simultaneously provisioning default settings or related records.
* Processing an e-commerce order: reserving inventory, creating a payment record, generating a shipment.
* Publishing a blog post and creating associated metadata and notification tasks.

Without transactions, systems may end up in **inconsistent or incomplete states**, requiring compensating actions and recovery logic.

#### **3. Simultaneous Writes to Shared Records**

In collaborative or real-time systems where multiple users or processes may update the same document or key:

* Collaborative document editing.
* Shared task lists or project boards.
* Updating leaderboard rankings.

Transactions (or atomic operations) help **avoid race conditions and overwrite conflicts**, ensuring **correct and synchronized updates.**

#### **4. Maintaining Referential Integrity**

In relational modeling within NoSQL (e.g., using references in documents or graphs), you may need to:

* Insert or update related entities **together** to ensure that no dangling references or orphaned records are created.
* Delete a parent entity and ensure that all child entities are also removed or handled appropriately.

Without transactions, such changes can result in **inconsistent or broken relationships.**

#### **5. Inventory, Reservation, and Stock Systems**

Systems that handle **limited resources** must ensure that they aren’t overbooked or oversold:

* Booking a hotel room or event ticket.
* Reserving a product in an online store.
* Allocating compute resources in a cloud service.

Transactions help ensure **correct counts and safe concurrent access**, especially under high load.

#### **6. Auditing and Logging Requirements**

For regulatory or debugging purposes, sometimes changes must be tracked **in sync** with application data:

* Logging every data modification.
* Recording who made a change and why.
* Maintaining snapshots or versioned records.

Transactions help ensure **both data and logs** are written together, preserving **a complete and accurate audit trail.**

## Limitations and Trade-offs of Transactions

While transactions bring critical safeguards to data consistency, their use in NoSQL environments comes with notable limitations and trade-offs - especially in systems designed for high scalability and availability. Understanding these limitations is vital when deciding when and how to use transactions in NoSQL systems.

#### **1. Performance Overhead**

* **Transactional operations introduce latency** due to additional steps like locking, logging, and coordination.
* In distributed environments, this overhead grows, particularly when ensuring atomicity across partitions or nodes.
* As a result, **write throughput may decrease**, and response times can become less predictable.

#### **2. Reduced Scalability**

* Many NoSQL systems are designed to scale horizontally by avoiding tight coordination between nodes.
* Full ACID transactions often require **global coordination**, which can **bottleneck scalability**, especially in write-heavy workloads.
* To preserve transactional integrity, some NoSQL databases **intentionally limit distributed transaction scope**, which restricts design flexibility.

#### **3. Complexity in Distributed Environments**

* Implementing consistent transactions across nodes often involves **complex protocols** like Two-Phase Commit (2PC) or Paxos.
* These protocols can **fail silently** under certain network conditions or node crashes, requiring advanced error handling.
* Recovery and rollback mechanisms across a distributed system are **harder to manage and test** compared to single-node environments.

#### **4. Limited or Varying Support Across Vendors**

* Not all NoSQL systems support transactions, and those that do often support only **a subset** (e.g., single-document atomicity).
* There is **no standardized transaction model** in NoSQL - each vendor defines and implements transactions differently.
* This limits **portability of code and patterns** across different NoSQL platforms.

#### **5. Eventual Consistency Conflicts**

* Many NoSQL systems embrace **eventual consistency** to maintain high availability (as per the CAP theorem).
* Enabling strict transactions in such systems often **undermines their consistency models**, or requires developers to manually resolve **conflict scenarios**.
* This adds both **operational and conceptual complexity**.

#### **6. Loss of Flexibility and Simplicity**

* A major appeal of NoSQL is its simplicity in data modeling and access patterns (e.g., denormalized documents, schema-less design).
* Introducing transactions reintroduces **tight coupling**, **inter-document dependencies**, and **rigid workflows** that contradict NoSQL’s core design philosophies.

#### **7. Hidden Costs in Application Logic**

* If the database doesn't support the required level of transactionality, developers must **simulate it at the application level**.
* This results in increased **code complexity**, potential **race conditions**, and a higher burden on QA and monitoring efforts.
