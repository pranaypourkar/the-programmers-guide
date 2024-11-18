# Distributed Tracing

## About

**Distributed Tracing** is a technique for monitoring and debugging microservices-based architectures by tracking the flow of requests across service boundaries. It helps identify bottlenecks, errors, or performance issues by tracing each request as it propagates through the system.

## Terminologies Commonly Used

### **Trace**

A **trace** represents the complete journey of a request as it propagates through various services in a distributed system. It is composed of one or more **spans**, each representing a specific operation within the request.

### **Span**

A **span** is a unit of work or operation within a trace.

Each span contains:

* A **Span ID**: A unique identifier for the span.
* **Start and End Timestamps**: To measure the duration of the operation.
* **Attributes**: Metadata such as service name, method, and status code.
* **Parent Span ID**: The span ID of the parent operation, linking spans hierarchically.
* **Logs**: Events or errors that occurred during the span.

### **Trace ID**

A globally unique identifier that ties together all spans within a single trace. It is propagated across service boundaries to maintain continuity in the trace.

### **Context Propagation**

Refers to the mechanism of passing the **Trace ID** and **Span ID** between services.

Commonly done via headers, such as:

* `X-B3-TraceId`
* `X-B3-SpanId`
* `X-B3-ParentSpanId`

### **Root Span**

The first span in a trace, typically representing the entry point of the request, such as an API gateway or front-end service.

### **Child Span**

A span that represents a sub-operation within the trace. It is linked to its parent span using the **Parent Span ID**.

### **Sampling**

The process of deciding whether to trace a particular request.

Types:

* **Always Sampling**: Traces every request (useful in development).
* **Probability Sampling**: Traces only a percentage of requests (e.g., 1%).

### **Annotations/Tags**

Metadata associated with a span, providing context about the operation.

Examples:

* `http.method`: "GET"
* `http.url`: "/api/orders"
* `status`: "200 OK"

### **Logs**

Structured or unstructured events recorded within a span.

Useful for debugging and capturing key moments, like:

* A database query start/end.
* An error occurrence.

### **Parent-Child Relationship**

Defines the hierarchical structure of spans within a trace. A **parent span** can have multiple **child spans**, representing sequential or parallel operations.

### **Baggage**

Metadata or data that propagates along with the trace context across service boundaries. Useful for passing information, such as a tenant ID or user session, without including it in the span itself.

### **Service Dependency Graph**

A visualization of the interactions between services in a distributed system. Derived from spans and traces, showing how services depend on each other.

### **Root Cause Analysis**

The process of using traces to identify the origin of a failure or bottleneck in a distributed system.

### **Instrumentation**

The process of adding tracing logic to code, typically using libraries like Spring Cloud Sleuth, OpenTelemetry, or custom SDKs.

* **Automatic Instrumentation**: Provided by frameworks and tools.
* **Manual Instrumentation**: Developers explicitly add tracing logic.

### **Distributed Context**

A collection of information (Trace ID, Span ID, Baggage) shared across services in a distributed trace.

### **Propagation Formats**

Standards for propagating trace and span information:

* **B3 Propagation**: Used by Zipkin.
* **W3C Trace Context**: An open standard supported by OpenTelemetry.

### **Latency**

The time taken for a span to complete its operation. Helps identify slow operations in a service.

### **Trace Sampling Rate**

The proportion of requests traced to reduce overhead. For example, setting the rate to **0.1** means 10% of requests are sampled.

### **Trace Aggregation**

The process of collecting traces from multiple services into a centralized system, like Zipkin, Jaeger, or OpenTelemetry backends.

### **Dependency Heatmap**

A visualization tool that highlights services with high latency or error rates.

### **Error Span**

A span that records an operation that failed or encountered an issue. Typically contains additional logs and annotations about the failure.

## Flow of a Distributed Tracing in a Springboot Application

### **1. Request Initiation**

* A request enters the system, such as an HTTP request to Service A.
* A trace ID is generated, and the first span (root span) is created.

### **2. Context Propagation**

* Service A calls Service B using HTTP, Kafka, or another protocol.
* The trace ID and span ID are propagated as headers or metadata.

### **3. Span Creation**

* Service B creates a new span as a child of the span from Service A.
* This process repeats across all services involved in handling the request.

### **4. Data Collection**

* Each span records details such as:
  * Start and end timestamps.
  * Tags (metadata) like method name, status code, and error messages.
  * Logs for events during the span.

### **5. Data Export**

* Spans are exported to a distributed tracing system (e.g., Zipkin or Jaeger) via HTTP or gRPC.

### **6. Trace Visualization**

* The tracing system aggregates spans into traces and provides a UI to visualize the flow of requests across services.

{% hint style="success" %}
**Scenario**

A user submits a request to an e-commerce platform's **Order Service**, which interacts with the **Inventory Service** and **Payment Service**.

1. **Order Service**:
   * Receives the user request and initiates the trace.
   * Calls Inventory Service and Payment Service.
2. **Inventory Service**:
   * Checks product availability.
3. **Payment Service**:
   * Processes the payment.

```
Request with Trace ID: `12345` and Span ID: `a1`
   |
[Order Service]
   |-- Trace ID: `12345`, Span ID: `a1` (Root Span)
   |-- Calls Inventory Service
   |
[Inventory Service]
   |-- Trace ID: `12345`, Span ID: `b2` (Child Span of `a1`)
   |-- Records Inventory Check
   |
[Order Service]
   |-- Calls Payment Service
   |
[Payment Service]
   |-- Trace ID: `12345`, Span ID: `c3` (Child Span of `a1`)
   |-- Records Payment Processing
```
{% endhint %}





## Benefits of Distributed Tracing

### **Improved Observability**

* **What it means**: Distributed tracing provides visibility into the journey of a request across all services.
* **Impact**:
  * Identifies how each service contributes to the overall request lifecycle.
  * Reveals dependencies between services and their interactions.

### **Efficient Debugging and Root Cause Analysis**

* **What it means**: Pinpoints where failures or bottlenecks occur within a complex system.
* **Impact**:
  * Quickly identify slow or failing services.
  * Reduce mean time to resolution (MTTR) by highlighting problematic spans (e.g., failed API calls, timeouts).

### **Performance Optimization**

* **What it means**: Highlights latency hotspots and underperforming components.
* **Impact**:
  * Detect services with high response times or resource usage.
  * Optimize database queries, external API calls, or internal service interactions.

### **Better Understanding of Service Dependencies**

* **What it means**: Tracing maps out all upstream and downstream dependencies of a service.
* **Impact**:
  * Understand how changes in one service affect others.
  * Helps in impact analysis during development or deployment of new features.

### **Ease of Collaboration Across Teams**

* **What it means**: Provides a unified view of a request's flow, useful for cross-functional debugging.
* **Impact**:
  * Reduces blame-shifting between teams (e.g., backend vs. database teams).
  * Provides a common language (traces, spans, tags) for discussion and analysis.

### **Compliance and Auditing**

* **What it means**: Detailed traces can be used for auditing purposes.
* **Impact**:
  * Provide evidence of system behavior in response to requests.
  * Useful for compliance in industries with strict monitoring requirements (e.g., finance, healthcare).

### **Foundation for AI Operations and Automation**

* **What it means**: The data from distributed tracing can feed into automated tools for intelligent monitoring.
* **Impact**:
  * Predict failures using historical tracing data.
  * Enable self-healing systems by linking trace metrics with automated remediation.
