# Tracing Modes

## About

In distributed systems, tracing enables developers and operators to understand how requests flow across multiple services, components, or systems. Tracing captures **where a request originated, how long each operation took, where it went, and whether it succeeded or failed**.

However, distributed systems involve many communication patterns—some synchronous, some asynchronous, some initiated by systems or users. **Each of these patterns requires a different tracing mode.**



## 1. Synchronous Request Tracing (HTTP or gRPC)

In synchronous tracing, one component directly invokes another and waits for a response. The call chain is linear and immediate, like a conversation where one person speaks and the other replies without delay.

{% hint style="info" %}
Most API calls between microservices fall under this category. If a frontend calls a backend, and the backend calls a database or another service, this is a synchronous flow. The trace reflects the full path of that request.
{% endhint %}

#### Tool Behavior:

* Tools like **Spring Cloud Sleuth** and **OpenTelemetry** handle this automatically in most frameworks.
* Trace context is passed via HTTP headers.
* We usually don’t need to write any extra code.

## 2. Asynchronous Execution Tracing (Method-level async)

Here, work is delegated to a background thread or task that runs independently of the main request. The calling component does not wait for the result and continues execution.

{% hint style="info" %}
Sending a confirmation email after completing a request, generating reports, or uploading data in the background are all examples of this mode.
{% endhint %}

#### Tool Behavior:

* **Spring Cloud Sleuth** **does not automatically preserve trace context** across `@Async` methods.
* We must use either:
  * `@Async` with context-aware thread pools, or
  * Manually capture and pass the trace context.
* **OpenTelemetry** provides options like `ContextPropagators` but requires more setup.

## 3. Asynchronous Request Tracing (Messaging Queues)

In this mode, work is handed off using messaging systems or queues. The producer of the message does not wait for the consumer to respond. The components are decoupled in time.

{% hint style="info" %}
This is common in event-driven systems. For example, placing an order may produce an "OrderCreated" message that is consumed by other services for fulfillment, inventory checks, or notifications.
{% endhint %}

#### Tool Behavior:

* **Spring Cloud Sleuth** supports JMS and Kafka.
* **OpenTelemetry** has instrumentation for most messaging systems.
* We need to ensure the trace context is **passed in the message headers**.
* On the consumer side, the tool can automatically continue the trace **if** the headers are intact and supported.

## 4. Scheduled Job Tracing

This mode covers tasks that are triggered by time rather than user action. These tasks are independent of any parent request and run on a fixed schedule or cron expression.

{% hint style="info" %}
Data cleanups, nightly batch processes, reconciliation jobs, and scheduled billing tasks fall into this category. Even though no user initiated them, their behavior and failures should be traceable.
{% endhint %}

#### Tool Behavior:

* **No parent trace context exists** for scheduled tasks.
* You must **manually start a new trace or span** in the job.
* Some tools offer annotations or helper methods to create a span at the start of the task.

## 5. Internal Event Tracing (Within a Single Service)

Within a single service, logic may be decoupled using events or internal signals. These are not exposed externally, but tracing them is still useful for internal observability.

{% hint style="info" %}
Systems that use Domain-Driven Design (DDD) or Command Query Responsibility Segregation (CQRS) may trigger multiple handlers inside the same service. Tracing how these handlers respond helps with local debugging and performance tuning.
{% endhint %}

#### Tool Behavior:

* In most frameworks, we need to **manually wrap each event handler** in a span.
* Tools don’t automatically trace internal events because they don’t go through a transport layer.

## 6. External Triggered Tracing (CLI tools, scripts, etc.)

These are flows that begin outside the system, such as through command-line tools, scripts, or third-party services. Since there is no inbound request to trace, the trace must start manually.

{% hint style="info" %}
A migration script that updates data in a system or a CI/CD tool that hits deployment APIs would fall under this mode. Observability is still important, especially for auditing and troubleshooting.
{% endhint %}

#### Tool Behavior:

* These tools have no initial trace context.
* Create a new root trace manually when the script or external system starts.
* Pass trace context manually if the tool makes multiple calls.

## 7. Hybrid Tracing (Combination of Modes)

Most complex systems use multiple modes in a single workflow. For example, a synchronous API call might publish an event, which is processed asynchronously by another service, which then triggers a background task.

{% hint style="info" %}
A customer onboarding flow might begin with an API call, trigger multiple downstream services through messages, run async validation, and store results using a background job. Without proper tracing, understanding the full lifecycle becomes nearly impossible.
{% endhint %}

#### Tool Behavior:

* Tools can trace each mode individually.
* We must **ensure trace context is passed across boundaries** (headers, message metadata, thread locals, etc.).
* Gaps in context propagation will break trace continuity.
