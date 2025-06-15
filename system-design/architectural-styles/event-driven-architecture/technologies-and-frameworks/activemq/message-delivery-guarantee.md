# Message Delivery Guarantee

## About

Message delivery guarantees define how reliably a message broker ensures that a message sent by a producer reaches one or more consumers. In distributed systems and asynchronous messaging architectures, these guarantees are crucial to maintaining data consistency, correctness, and resilience in case of failures.

ActiveMQ supports **three primary message delivery guarantees**:

1. **At-Most-Once Delivery**
2. **At-Least-Once Delivery**
3. **Exactly-Once Delivery**

Each model has trade-offs between **reliability**, **performance**, and **complexity**, and the appropriate model depends on our application's consistency and throughput requirements.

## 1. At-Most-Once Delivery

A message is delivered to a consumer **zero or one time**. It may be lost if a failure occurs before or during delivery, but it is never redelivered or duplicated.

**Use Case:**

* When **occasional message loss is acceptable**
* Logging, metrics, fire-and-forget notifications
* High-throughput systems that prioritize speed over reliability

**Characteristics:**

* Fastest of all delivery models
* No built-in retry mechanism
* Simplified consumer logic
* Non-persistent messaging (typically)
* Risk of silent message loss

**ActiveMQ Configuration:**

* Session Acknowledgement Mode: `AUTO_ACKNOWLEDGE`
* Producer Delivery Mode: `NON_PERSISTENT`
* No transactions
* No redelivery policy needed

**Example Behavior:**

* Producer sends a message to a queue
* Message is immediately considered "delivered" once handed off
* If consumer fails or crashes before processing, message is **not retried**

## 2. At-Least-Once Delivery

A message is delivered **one or more times** until a consumer acknowledges receipt. This ensures **no message loss**, but **duplicates may occur**.

**Use Case:**

* When **data loss is unacceptable**, but duplicates can be handled
* Event sourcing, data ingestion, notifications
* Common in most business-critical systems

**Characteristics:**

* Messages persist in broker until acknowledged
* Redelivery happens on failure or lack of acknowledgment
* Consumers must be **idempotent** (able to process duplicates safely)
* Supports persistent messaging
* Can be combined with redelivery policies

**ActiveMQ Configuration:**

* Session Acknowledgement Mode: `CLIENT_ACKNOWLEDGE` or `INDIVIDUAL_ACKNOWLEDGE`
* Producer Delivery Mode: `PERSISTENT`
* Redelivery Policy (can define retries, delays, etc.)

**Redelivery Policy Parameters:**

* `maximumRedeliveries`: Number of retry attempts before sending to dead-letter queue
* `redeliveryDelay`: Time between retries
* `useExponentialBackOff`: Exponential increase in delays between retries

**Example Behavior:**

* Producer sends a message to a queue
* Consumer receives the message but crashes before acknowledging
* ActiveMQ redelivers the message after a delay
* The message may be delivered multiple times until successfully acknowledged

## 3. Exactly-Once Delivery

A message is delivered **only once** and is **never lost or duplicated**, even in the face of system or network failures. This is the **most reliable** and **most complex** delivery model.

**Use Case:**

* Financial transactions, order processing, inventory updates
* Any system that requires **strong consistency** and **no duplication**
* Often used with transactional message processing and XA transactions

**Characteristics:**

* Relies on **transactions** and **commit/rollback** mechanisms
* Uses `SESSION_TRANSACTED` or external distributed transaction managers (XA)
* Slower performance due to two-phase commit (2PC)
* Ensures atomicity: either all operations succeed or none do

**ActiveMQ Configuration:**

* Session Acknowledgement Mode: `SESSION_TRANSACTED`
* Delivery Mode: `PERSISTENT`
* Transactions must be explicitly committed
* If rollback occurs, messages are redelivered
* Can integrate with external transaction managers for XA compliance

**XA Transactions (Distributed Transactions):**

* Enables coordinating message delivery and DB updates in a single transaction
* Requires additional configuration in broker and client
* Uses the XA protocol to ensure exactly-once semantics across systems

**Example Behavior:**

* Producer sends a message as part of a transaction
* Consumer receives the message and processes it
* Transaction commits only if processing succeeds
* If consumer crashes or rollback is issued, message remains in the queue and is redelivered

## Comparison

| Guarantee     | Message Loss | Duplicates | Performance | Complexity | Idempotent Consumer Required |
| ------------- | ------------ | ---------- | ----------- | ---------- | ---------------------------- |
| At-Most-Once  | Possible     | No         | High        | Low        | No                           |
| At-Least-Once | No           | Possible   | Medium      | Medium     | Yes                          |
| Exactly-Once  | No           | No         | Low         | High       | No                           |

### Message Acknowledgement Modes in JMS

<table><thead><tr><th width="227.359375">Mode</th><th>Description</th></tr></thead><tbody><tr><td><code>AUTO_ACKNOWLEDGE</code></td><td>Automatically acknowledges message receipt once it is received. Suitable for at-most-once.</td></tr><tr><td><code>CLIENT_ACKNOWLEDGE</code></td><td>Application explicitly acknowledges message. Suitable for at-least-once.</td></tr><tr><td><code>DUPS_OK_ACKNOWLEDGE</code></td><td>Lazy acknowledgment. Can lead to duplicates. Rarely used.</td></tr><tr><td><code>SESSION_TRANSACTED</code></td><td>Message acknowledgment is part of a JMS transaction. Suitable for exactly-once.</td></tr><tr><td><code>INDIVIDUAL_ACKNOWLEDGE</code></td><td>ActiveMQ extension allowing per-message acknowledgment. Useful for partial success handling.</td></tr></tbody></table>

## Practical Tips

* Use **at-most-once** only when **latency matters more than correctness**.
* Use **at-least-once** when **no data loss** is acceptable but you can **handle duplicates**.
* Use **exactly-once** when **data correctness and consistency** are critical, and you're willing to accept **lower throughput** and **more complexity**.
* For **microservices**, idempotent consumer logic is often preferred to simplify integration with at-least-once delivery.

## **Two-Phase Commit**

**2PC** stands for **Two-Phase Commit**, a protocol used in **distributed systems** to ensure **atomicity** (all-or-nothing behavior) across multiple systems or resources (e.g., databases, message brokers like ActiveMQ, etc.) during a **single transaction**.

### What Problem Does 2PC Solve ?

Imagine a transaction that:

* Sends a message to a queue (ActiveMQ), and
* Updates a database record

We want either both actions to succeed, or none at all (to prevent inconsistency).

However, these systems (ActiveMQ and DB) are separate, possibly on different servers. What happens if one succeeds and the other fails?\
That’s where 2PC comes in.

### How Two-Phase Commit Works ?

The protocol has two phases:

#### Phase 1: Prepare Phase (Voting Phase)

* A Transaction Coordinator asks all involved participants (e.g., DB, message broker) if they are ready to commit.
* Each participant:
  * Writes changes to a temporary log (not visible yet).
  * Replies with either Yes (ready to commit) or No (rollback needed).

#### Phase 2: Commit or Rollback Phase

* If all participants vote Yes, the coordinator sends a COMMIT command.
* If any participant votes No, the coordinator sends a ROLLBACK to all.
* Each participant then either commits or rolls back their part of the transaction.

### Guarantees Provided

* **Atomicity**: All operations succeed or none do.
* **Consistency**: No system is left in an intermediate state.
* **Durability**: If a crash occurs after a commit, the decision can be recovered from logs.

### Trade-Offs

<table><thead><tr><th width="126.4765625">Aspect</th><th>Details</th></tr></thead><tbody><tr><td><strong>Pros</strong></td><td>Strong consistency across services</td></tr><tr><td><strong>Cons</strong></td><td>Slow, can block resources during commit</td></tr><tr><td><strong>Failure Risk</strong></td><td>If the coordinator crashes in between, participants may be in limbo ("in-doubt" state)</td></tr><tr><td><strong>Alternatives</strong></td><td>3PC (Three-Phase Commit), Sagas, Eventual consistency patterns</td></tr></tbody></table>

### ActiveMQ and 2PC

ActiveMQ can **participate in XA (extended architecture) transactions**, which implement 2PC. This allows:

* Coordinated commits between **message send/receive** and **database operations**
* Configuration via **transaction managers** like Atomikos, Bitronix, or Spring's JTA support

**Example Scenario:**

* Service receives a request to update customer info and publish an event.
* ActiveMQ and our database both register as participants.
* The transaction manager uses 2PC to commit both only if both succeed.
