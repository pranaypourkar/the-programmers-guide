# Message Queues & Brokers

## **What is a Message Queue?**

A **Message Queue (MQ)** is a mechanism that enables asynchronous communication between different components of a system. It temporarily stores messages until they are processed by a receiver.

* **Producer**: Sends messages to the queue.
* **Message Queue**: Stores messages temporarily.
* **Consumer**: Retrieves and processes messages from the queue.

#### **Example Workflow:**

1. A user clicks on the Ad Banner.
2. Banner service triggers/produces an event called ClickInteractionEvent.
3. Metric service listens to that ClickInteractionEvent event and updates the metric data.

## **What is a Message Broker?**

A **Message Broker** is middleware that manages message queues and routes messages between producers and consumers.

### **Functions of a Message Broker**

* **Message Routing**: Ensures messages reach the right consumer(s).
* **Asynchronous Processing**: Allows consumers to process messages independently.
* **Load Balancing**: Distributes messages across multiple consumers.
* **Reliability**: Ensures messages are delivered even if a system crashes.
* **Scalability**: Supports distributed messaging across multiple instances.



## **Messaging Patterns**

Message queues and brokers support different messaging patterns:

### **Point-to-Point (Queue-Based Messaging)**

* **One Producer → One Consumer**
* Messages are processed by **only one consumer**.
* Used in **task processing systems** (e.g., background jobs).

✅ **Example**:\
A payment processing system where each transaction message is handled by a single worker.

***

#### **2️⃣ Publish-Subscribe (Topic-Based Messaging)**

* **One Producer → Multiple Consumers**.
* Messages are **broadcasted** to multiple subscribers.
* Used in **real-time updates** (e.g., notifications, logs).

✅ **Example**:\
A stock market app sends price updates to multiple user dashboards.

#### **3️⃣ Request-Response**

* The producer sends a message and expects a response.
* Used in **synchronous RPC-style messaging**.

✅ **Example**:\
A client requests account details from a microservice via a message broker.

