# Request-Response Pattern (Blocking)

## About

The **Request-Response Pattern (Blocking)** is the **most traditional** and widely used communication pattern in distributed systems, especially in web services and enterprise applications. In this pattern, a client sends a request to a server (or service) and **waits** until it receives a response before proceeding to the next step in execution.

This “wait” means that **the calling thread remains blocked**, holding system resources (like sockets, threads, or memory buffers) until the operation completes or a timeout occurs.

## **Characteristics**

1. **Synchronous Execution**
   * The client and server operate in lockstep - the client does nothing else until the server responds.
   * Example: A browser requesting an HTML page from a web server.
2. **Tight Coupling in Time**
   * Both client and server must be available and responsive at the same moment.
   * If the server is slow, the client’s response time suffers directly.
3. **Deterministic Flow**
   * Execution order is predictable:
     1. Send request
     2. Wait for response
     3. Continue with processing
   * This makes it easier to reason about application flow.
4. **Simple Error Propagation**
   * Errors (timeouts, server errors, network failures) can be directly communicated to the client during the wait period.

## Execution Flow

The blocking request–response sequence follows a **linear, tightly coupled interaction** between the client and the server. Here’s the **step-by-step breakdown**:

**1. Client Initiates Request**

* The client constructs the request (including URL, method, headers, and body if applicable).
* This request is sent over the network to the server.
* The calling thread **enters a waiting (blocked) state** immediately after sending.

**2. Server Receives and Processes**

* The server accepts the incoming request via its listening socket.
* Request is handed off to an appropriate handler (controller, service method, etc.).
* The server performs the necessary business logic — possibly including:
  * Reading/writing to a database
  * Calling other services
  * Performing computation

**3. Server Sends Response**

* Once the operation is complete, the server sends a response message back to the client.
* This response typically contains:
  * **Status code** (e.g., `200 OK`, `404 Not Found`, `500 Internal Server Error`)
  * **Headers** (e.g., `Content-Type`, `Cache-Control`)
  * **Body** (data payload in JSON, XML, HTML, etc.)

**4. Client Unblocks and Processes Response**

* The client thread resumes execution when the response is received (or a timeout/error occurs).
* The application code processes the response — for example:
  * Updating the UI with returned data
  * Logging an error
  * Triggering the next business action

**5. End of Transaction**

* Once the client has processed the response, the transaction is considered complete.
* All associated resources (threads, sockets) are freed.

## **Advantages**

Even though _blocking_ sounds inefficient, this pattern continues to be widely used because of its **predictability, simplicity, and compatibility** with existing tools and protocols.

**1. Simplicity in Design and Implementation**

* The control flow is **linear**: request → wait → response.
* Developers don’t need to worry about concurrency callbacks, futures, or reactive programming models.
* Fits perfectly into procedural and imperative coding styles.

**Example**:

```java
String response = restTemplate.getForObject("/users/42", String.class);
System.out.println(response);
```

Here, the code execution stops at `getForObject()` until the server responds.

**2. Predictable Execution Flow**

* Debugging and tracing are straightforward because operations happen **in sequence**.
* Stack traces clearly show the point of failure without asynchronous complexity.
* Logs can be read in the **exact order** of request and response events.

**3. Strong Protocol Compatibility**

* Works well with HTTP 1.1, JDBC, SOAP, and many enterprise integration points that expect synchronous behavior.
* Many existing client libraries (e.g., `HttpURLConnection`, `RestTemplate`, `JDBC Statement`) are built for blocking communication.

**4. Easy Error Handling**

* Failures (timeouts, connection errors, server errors) are caught **immediately** in the calling method.
* No need for complex event-listening or retry schedulers.

**Example**:

```java
try {
    String data = restTemplate.getForObject("/data", String.class);
} catch (HttpClientErrorException e) {
    // Handle HTTP errors right here
}
```

**5. Natural Fit for Small Scale & Low Concurrency**

* For internal services or low-volume APIs, blocking calls offer excellent developer productivity without noticeable performance drawbacks.
* Ideal for batch jobs, admin tools, and system scripts.

**6. Better Alignment with Transactional Workloads**

* When a **database transaction** or **business process** requires immediate confirmation before proceeding, blocking ensures data integrity.
* Example: Payment processing often relies on blocking calls to guarantee transaction status before confirming to the user.

## **Limitations**

While blocking calls are straightforward, they can **quickly become a bottleneck** in modern distributed systems especially when dealing with high concurrency, long-latency operations, or resource-intensive APIs.

**1. Thread Blocking & Resource Inefficiency**

* Each request occupies a **dedicated thread** until the response arrives.
* In high-traffic scenarios, this can lead to **thread starvation** and increased memory usage.
* Example: If 1,000 concurrent users make blocking calls that take 3 seconds each, that’s 1,000 threads waiting idle, consuming resources.

**2. Poor Scalability for High-Concurrency Systems**

* Scaling a blocking architecture usually means **adding more hardware** or increasing thread pools — both expensive and not always sustainable.
* Cloud services may charge more for instances with large CPU/RAM just to handle idle waits.

**3. Increased Latency in Multi-Call Chains**

* In microservices, blocking calls **chain delays**.
* Example: Service A waits for Service B, which waits for Service C → latency multiplies across the call path.

**4. Bad Fit for Long-Running Operations**

* Use cases like report generation, media processing, or third-party API calls with unpredictable delays can **lock up resources**.
* Such workloads are better handled asynchronously with status polling or event notifications.

**5. Underutilization of Modern Hardware**

* Blocking patterns don’t leverage **non-blocking I/O** optimizations available in modern frameworks (e.g., Netty, Project Reactor).
* CPU cores may remain underutilized while threads sit idle.

**6. User Experience Degradation**

* In frontend-backend interactions, blocking API calls can cause **UI freezes** or **slow responses**, leading to a poor user experience.
* Mobile networks, in particular, can amplify this delay.

**7. Risk of Cascading Failures**

* If an upstream service is slow, the blocking pattern **propagates the delay** downstream, potentially causing queue buildups and timeouts in dependent systems.

## **Common Technologies & Protocols Used**

Although modern architectures increasingly favor non-blocking or asynchronous designs, **blocking request–response** remains common in enterprise systems - often due to simplicity, legacy integration, or specific use cases.\
Here are the most widely used technologies and protocols:

**1. HTTP/1.1 (Synchronous REST APIs)**

* **How it works:** Client sends a request → waits for the server’s response before proceeding.
* **Why common:** Simple to implement, widely supported by browsers, mobile apps, and backend services.
*   **Example:**

    ```http
    GET /orders/123
    Host: api.example.com
    Accept: application/json
    ```

    * The client remains idle until the full response is received.
* **Limitations:** Not ideal for streaming or long-lived connections due to the blocking nature.

**2. SOAP (Simple Object Access Protocol)**

* **How it works:** XML-based protocol over HTTP (or sometimes TCP), inherently blocking in most implementations.
* **Typical use case:** Enterprise integrations (ERP, CRM, banking) where transactional guarantees and strict schemas are important.
* **Example:**
  * A client sends a SOAP XML payload to a service endpoint and blocks until a structured XML response is returned.

**3. JDBC (Java Database Connectivity)**

* **How it works:** Most JDBC calls in traditional JDBC drivers are blocking — the thread waits for the database to return the result set.
*   **Example:**

    ```java
    ResultSet rs = stmt.executeQuery("SELECT * FROM users");
    while(rs.next()) {
        System.out.println(rs.getString("name"));
    }
    ```
* **Limitation:** For high-concurrency applications, blocking database calls can saturate connection pools quickly.

**4. RMI (Remote Method Invocation)**

* **How it works:** Java-specific RPC mechanism where method calls block until a remote service returns the result.
* **Typical use case:** Legacy distributed Java applications before REST/HTTP became dominant.

**5. gRPC (Unary Calls)**

* **How it works:** Although gRPC supports streaming and async calls, **unary RPCs** can be implemented as blocking calls in many clients.
*   **Example:**

    ```java
    MyServiceBlockingStub stub = MyServiceGrpc.newBlockingStub(channel);
    Response response = stub.getData(Request.newBuilder().build());
    ```
* **Note:** Developers must explicitly choose async stubs to avoid blocking.

**6. Legacy TCP Socket APIs**

* **How it works:** The client sends data over a TCP socket and blocks until the response bytes are read.
* **Example:** Low-level socket programming in C, Java, or Python.
* **Limitations:** Without proper timeout handling, this can lead to hanging threads.

**7. Framework-Specific Blocking Clients**

* **Examples:**
  * **Spring’s RestTemplate** (default)
  * **Apache HttpClient** (synchronous mode)
  * **OkHttp** (synchronous execution mode)
* **Behaviour:** The calling thread waits for the HTTP response before continuing execution.
