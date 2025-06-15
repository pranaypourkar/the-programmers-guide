# Fundamentals

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
