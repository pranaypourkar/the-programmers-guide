# Resilience Patterns

## About

Resilience patterns are **architectural and design strategies** aimed at ensuring that software systems can **withstand, recover from, and adapt to failures** without causing a complete service outage.

In modern architectures particularly **microservices**, **cloud-native applications**, and **distributed systems**  dependencies are spread across multiple services, networks, and infrastructure layers. This makes failures not just possible but **inevitable**. These failures can be caused by:

* Network latency or packet loss
* Service unavailability due to outages or deployments
* Resource exhaustion such as thread pool saturation or database connection limits
* Rate-limiting or throttling by third-party APIs
* Infrastructure failures in cloud providers

A resilient system is one that **anticipates these failures**, **absorbs the impact**, and **recovers gracefully**.\
Resilience patterns provide **repeatable solutions** to address these situations systematically, rather than leaving fault handling as an ad hoc, scattered concern in the codebase.

They focus on **graceful degradation** (still providing partial functionality when full functionality isn’t possible), **self-healing** (recovering automatically when conditions improve), and **isolation** (ensuring one failing part does not affect the whole system).

In the context of **Spring Boot**, resilience patterns are most often applied to:

* **Remote service calls** – REST APIs, gRPC, SOAP services, messaging queues.
* **Database operations** – preventing slow queries from locking resources.
* **Third-party integrations** – handling failures of payment gateways, external authentication systems, etc.

A well-designed resilience strategy not only increases **uptime and availability** but also **protects the user experience** and **reduces operational firefighting** when failures occur.

## Importance of Resilience

Resilience is **not an optional enhancement** in modern systems it is a **core requirement** for delivering reliable, high‑quality software. As businesses move toward **microservices, serverless, and cloud-native architectures**, the number of interdependent components grows, increasing the risk that **one failure can cascade into a system-wide outage**.

**Key reasons why resilience matters:**

1. **Unavoidable Failures**\
   Failures can happen for reasons outside our control such as network instability, DNS issues, API downtime, or infrastructure outages in cloud regions. Resilience patterns help ensure the system continues to function even when parts of it are broken.
2. **Business Continuity**\
   Downtime can directly translate to **lost revenue, broken SLAs, and damage to brand reputation**. Resilience mechanisms like retries, circuit breakers, and graceful degradation keep core functionality available while issues are being resolved.
3. **User Experience Protection**\
   A non‑resilient system can cause user frustration through long response times, partial failures, or complete inaccessibility. Resilience patterns ensure users still receive **timely feedback and partial functionality**, maintaining trust in the product.
4. **Prevention of Cascading Failures**\
   In distributed systems, one slow or failing service can **exhaust resources** (threads, database connections) in other services, leading to a domino effect. Isolation and fallback patterns stop failures from spreading.
5. **Operational Efficiency**\
   Without resilience mechanisms, engineers must firefight every small outage. Automated fault handling reduces **manual intervention**, freeing teams to focus on development rather than incident management.
6. **Scalability Under Stress**\
   Resilient systems handle **traffic spikes, dependency slowdowns, and intermittent faults** without collapsing under load. This is critical for high‑traffic events such as product launches, seasonal sales, or marketing campaigns.
7. **Regulatory and Compliance Requirements**\
   In industries like finance, healthcare, and telecom, **system availability** is not only a quality goal but also a **regulatory mandate**. Resilience patterns help meet uptime SLAs and compliance obligations.

In short, resilience ensures that **our system bends but doesn’t break**.\
It allows our application to **degrade gracefully, recover automatically, and continue to deliver value**, even in the face of real‑world challenges.

## Common Resilience Patterns

In distributed and cloud-native architectures, several well-known patterns help applications handle failures gracefully, prevent cascading breakdowns, and recover quickly. Below is an overview of the most common patterns, their purpose, and where they are typically used.

<table data-full-width="false"><thead><tr><th width="148.24609375" valign="top">Pattern</th><th width="194.73828125" valign="top">Purpose</th><th valign="top">How It Works</th><th valign="top">Typical Use Cases</th></tr></thead><tbody><tr><td valign="top"><strong>Retry</strong></td><td valign="top">Automatically re-attempt a failed operation after a short delay</td><td valign="top">When an operation fails due to transient errors (e.g., network glitch, temporary unavailability), it is retried based on a configured strategy (fixed delay, exponential backoff)</td><td valign="top">API calls to external services, database queries during temporary outages</td></tr><tr><td valign="top"><strong>Circuit Breaker</strong></td><td valign="top">Prevents repeated calls to a failing service to allow it time to recover</td><td valign="top">Monitors failures; if failures exceed a threshold, the circuit “opens” and future calls fail immediately or use a fallback until the service is deemed healthy again</td><td valign="top">Protecting downstream services from overload, preventing cascading failures</td></tr><tr><td valign="top"><strong>Bulkhead</strong></td><td valign="top">Isolates parts of the system to prevent a failure in one area from affecting others</td><td valign="top">Allocates dedicated resources (e.g., thread pools, connection pools) for specific functionalities so that overload in one doesn’t consume all resources</td><td valign="top">Separating database calls from external API calls so one cannot exhaust resources for the other</td></tr><tr><td valign="top"><strong>Rate Limiting</strong></td><td valign="top">Controls the number of requests processed over a given time period</td><td valign="top">Rejects or queues excess requests to prevent resource exhaustion</td><td valign="top">Protecting APIs from excessive traffic, ensuring fair usage across clients</td></tr><tr><td valign="top"><strong>Timeouts</strong></td><td valign="top">Prevents indefinite waiting for a response from an operation</td><td valign="top">Defines a maximum wait time for a response, after which the operation fails</td><td valign="top">Network calls, database queries, file reads from slow storage</td></tr><tr><td valign="top"><strong>Failover</strong></td><td valign="top">Switches to an alternative resource or system when the primary one fails</td><td valign="top">Monitors the health of primary resources and routes requests to a backup automatically</td><td valign="top">High-availability databases, redundant application instances</td></tr><tr><td valign="top"><strong>Fallback</strong></td><td valign="top">Provides an alternative execution path when the main operation fails</td><td valign="top">Returns cached data, a default value, or a reduced functionality version of the feature</td><td valign="top">Displaying cached product listings when the live catalog API is down</td></tr><tr><td valign="top"><strong>Graceful Degradation</strong></td><td valign="top">Reduces service functionality under high load instead of complete failure</td><td valign="top">Turns off non-critical features or returns simpler responses</td><td valign="top">Disabling image-heavy content when bandwidth is constrained</td></tr><tr><td valign="top"><strong>Idempotency</strong></td><td valign="top">Ensures that repeated operations produce the same effect</td><td valign="top">Assigns unique request identifiers or checks existing state before performing the operation</td><td valign="top">Payment processing, order submission APIs</td></tr><tr><td valign="top"><strong>Load Shedding</strong></td><td valign="top">Proactively rejects low-priority requests when under heavy load</td><td valign="top">Monitors system metrics and drops less important traffic to maintain service quality for critical requests</td><td valign="top">Protecting core transaction flows during traffic spikes</td></tr></tbody></table>

