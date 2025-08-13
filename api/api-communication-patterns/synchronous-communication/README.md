# Synchronous Communication

## About

Synchronous communication in software systems refers to a **communication style where the client sends a request and waits for an immediate response from the server** before continuing further processing. In other words, the client is _blocked_ until the server completes the operation and returns the result (or an error).

This pattern is deeply rooted in traditional networking and programming models and is the **most familiar paradigm** for developers, given its resemblance to human conversation: one party speaks, the other listens and replies before the next exchange occurs.

{% hint style="warning" %}
* **Tight coupling in time** → The client and server must both be _available_ and _responsive_ at the same time for the interaction to succeed.
* **Direct dependency** → The client cannot proceed without the response.
* **Latency sensitivity** → End-to-end performance is directly impacted by the slowest operation in the chain.
{% endhint %}

## **Why It Matters in System Design ?**

Synchronous communication is **not just a default** - it’s an intentional choice that has implications for **performance, scalability, and fault tolerance**. While it offers simplicity and immediate feedback, it also creates **temporal coupling**, meaning failures or delays in the callee can ripple up and stall the caller.

In distributed systems, over-reliance on synchronous calls can cause cascading failures, so architects often weigh it against asynchronous patterns when designing for **resilience and scale**.

## Characteristics

Synchronous communication exhibits several defining traits that distinguish it from asynchronous or hybrid approaches. These characteristics influence **system behavior, performance, fault tolerance, and user experience**.

**1. Temporal Coupling**

* **Definition**: The client and server must be active and ready _at the same time_ for communication to occur successfully.
* **Implication**: If one party is down, the interaction fails immediately.
* **Example**: A REST API call to retrieve a user profile will fail instantly if the user service is unavailable.

**2. Blocking Nature**

* **Default Behavior**: The caller waits for the callee to respond before proceeding.
* **Impact**: Thread or process resources are occupied until a response is received, which can cause **thread starvation**under high load.
* **Example**: In Java’s `RestTemplate`, the calling thread halts until the HTTP request completes.

**3. Immediate Feedback Loop**

* **Pro**: The client gets an instant success/failure result, simplifying error handling and retries.
* **Con**: The overall system becomes sensitive to latency spikes.
* **Example**: Logging into a web application returns either a 200 OK or 401 Unauthorized immediately after request submission.

**4. Predictable Control Flow**

* **Benefit**: Easy to design, debug, and trace since execution follows a straight, sequential path.
* **Limitation**: Difficult to scale if multiple dependent services are chained synchronously.
* **Example**: Service A calls Service B → Service B calls Service C → Response bubbles back up. A delay in Service C delays the entire chain.

**5. Tight Coupling Between Components**

* **Description**: Synchronous calls increase runtime dependencies between services.
* **Consequence**: A change in response structure or behavior of one service can immediately impact dependent services.
* **Example**: If a payment service changes its API contract, all synchronous consumers must update simultaneously.

**6. Resource Utilization Patterns**

* **Observation**: Active waiting consumes CPU, memory, and thread pools, especially when response times are unpredictable.
* **Risk**: Under heavy load, synchronous systems can hit connection limits or exhaust worker threads faster than async ones.

**7. Simplicity at the Expense of Scalability**

* **Why**: The straightforward model makes it ideal for small systems but potentially problematic in large, high-traffic distributed architectures.
* **Example**: Monolithic applications thrive on sync calls, but microservices often limit their use to critical, low-latency interactions.

## **When to Use ?**

Choosing synchronous communication should be a deliberate decision based on **latency requirements, business rules, operational constraints, and system design goals**.\
While synchronous calls can introduce coupling and scaling challenges, they are still the best fit in certain scenarios.

**1. Real-Time User Interactions**

* **Rationale**: Users expect **immediate feedback** in interactive applications, making synchronous calls a natural choice.
* **Example**:
  * Logging in to a banking app → immediate authentication result.
  * Submitting a search query → results must be displayed right away.

**2. Critical, Low-Latency Operations**

* **Why**: When the outcome must be determined _before proceeding_ to the next step in the workflow.
* **Example**:
  * **E-commerce checkout** → payment gateway must confirm payment before order placement.
  * **Flight booking systems** → seat availability must be checked instantly before ticket issuance.

**3. Small, Tightly Bound Systems**

* **Context**: In monolithic architectures or small-scale services, the cost of synchronous calls is minimal compared to their simplicity.
* **Example**:
  * Internal admin tools calling database-backed APIs.
  * A simple internal reporting dashboard retrieving analytics data.

**4. Dependent Operations That Must Complete Sequentially**

* **Why**: Some workflows cannot move forward unless earlier steps succeed, making async impractical.
* **Example**:
  * Order processing: Validate inventory → charge payment → update order status.
  * Healthcare systems: Verify patient ID → fetch medical records → authorize access.

**5. Strong Consistency Requirements**

* **Reason**: Certain domains require the **latest state** of data at the moment of access, which is more easily guaranteed synchronously.
* **Example**:
  * Banking → balance check before withdrawal.
  * Inventory → exact stock count before shipping.

**6. Error-Handling Simplicity**

* **Advantage**: Failures are detected **immediately** and can be handled in the same transaction scope.
* **Example**:
  * If a payment API returns a decline, the order creation process stops instantly without compensating actions.

**7. Regulatory and Compliance Scenarios**

* **Why**: Some industries mandate **acknowledged delivery and confirmation** before continuing an operation.
* **Example**:
  * Electronic health record (EHR) updates.
  * Securities trading execution.

## **Advantages**

Synchronous communication remains a widely used interaction model because it provides **predictable, immediate, and straightforward** request-response exchanges. While modern systems increasingly lean toward asynchronous methods, synchronous patterns still shine in many contexts.

**1. Immediate Feedback**

* **Benefit**: The caller receives a result instantly (success, failure, or data), which is crucial for user-facing workflows.
* **Example**:
  * Logging in → user is instantly notified of invalid credentials.
  * Real-time stock price lookup → immediate market price is shown.

**2. Simpler Development Model**

* **Reason**: Many developers are more familiar with synchronous request-response patterns.
* **Advantage**: No need to design callback handlers, message queues, or background jobs for basic operations.
* **Example**:
  * Internal APIs for data retrieval within a monolithic codebase.

**3. Predictable Execution Flow**

* **Benefit**: Code execution follows a clear, linear order, making reasoning and debugging easier.
* **Example**:
  * Payment processing: Step A (validate card) → Step B (process payment) → Step C (send confirmation).

**4. Easier Error Handling**

* **Why**: Errors are detected **in the same transaction scope** and can be handled immediately.
* **Example**:
  * If a database update fails, the system can roll back the transaction right away.

**5. Strong Consistency Support**

* **Advantage**: Works well in scenarios requiring **fresh, up-to-date data** before proceeding.
* **Example**:
  * Banking → confirm account balance before withdrawal.
  * Airline booking → confirm available seats before ticket purchase.

**6. Lower Operational Overhead**

* **Why**: No need for extra infrastructure like message brokers, background workers, or event logs.
* **Example**:
  * Small internal applications with minimal scaling needs.

**7. Better for User Experience in Interactive UIs**

* **Reason**: Immediate results give users a sense of responsiveness and control.
* **Example**:
  * E-commerce product search.
  * Online form validation on submit.

**8. Easy to Monitor and Trace**

* **Benefit**: Most APM (Application Performance Monitoring) tools and logging systems handle synchronous calls well out of the box.
* **Example**:
  * Tools like Spring Sleuth or Zipkin can directly trace request paths without special handling.

## **Limitations**

While synchronous communication offers simplicity and predictability, it comes with **trade-offs** that can significantly impact scalability, fault tolerance, and performance in distributed systems. Understanding these limitations is essential to avoid architectural pitfalls.

**1. Tight Coupling Between Services**

* **Why it’s a problem**:
  * The caller depends on the callee’s **immediate availability** and **response time**.
  * A failure in one service can propagate instantly, causing cascading failures.
* **Example**:
  * In a microservices architecture, if the authentication service is down, every other service that requires login fails instantly.

**2. Increased Latency in Chained Calls**

* **Impact**:
  * In workflows involving multiple synchronous calls, **total response time** grows linearly with the number of calls.
* **Example**:
  * A user request that triggers:
    1. API Gateway → Order Service (200 ms)
    2. Order Service → Payment Service (300 ms)
    3. Payment Service → Inventory Service (250 ms)\
       **Total** = 750 ms before user sees a response.

**3. Poor Fault Tolerance**

* **Reason**: If the downstream service is slow or unavailable, the caller waits (or times out).
* **Effect**: Can cause thread blocking and resource starvation under load.
* **Example**:
  * A checkout service hangs because the payment service is overloaded, eventually exhausting all request-handling threads.

**4. Scalability Bottlenecks**

* **Why**:
  * Each request ties up resources (threads, memory) until the response is received.
  * High-traffic scenarios require significantly more infrastructure to handle load.
* **Example**:
  * Serving 10,000 concurrent synchronous requests may require 10× more hardware compared to an async solution.

**5. Timeout & Retry Complexity**

* **Challenge**:
  * Setting the right timeout is tricky—too short and you risk false failures; too long and you block resources unnecessarily.
  * Retrying failed synchronous calls can cause **thundering herd** problems.
* **Example**:
  * Hundreds of clients retry at the same time after a short network outage, overwhelming the recovering service.

**6. Reduced Resilience in Distributed Systems**

* **Reason**:
  * Modern distributed systems often span regions and networks with variable latency.
  * Synchronous patterns amplify these latency spikes.
* **Example**:
  * A global e-commerce API experiences slower response times for international customers due to distance-based latency.

**7. Not Suitable for Long-Running Tasks**

* **Why**:
  * Users and systems shouldn’t block waiting for operations that take minutes or hours.
* **Example**:
  * Report generation that takes 15 minutes shouldn’t hold a synchronous HTTP connection open.

**8. Limited Offline Support**

* **Impact**:
  * The requester must be online and connected at the time of communication.
* **Example**:
  * Mobile applications that need to work in poor connectivity environments can’t rely solely on synchronous calls.
