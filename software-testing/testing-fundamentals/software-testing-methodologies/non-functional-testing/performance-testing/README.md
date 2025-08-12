# Performance Testing

## About

**Performance Testing** is a type of non-functional testing that evaluates how well a software application performs under expected or varying workloads.\
It focuses on attributes such as speed, scalability, stability, and responsiveness, ensuring the system can handle both normal and peak usage without degradation of service.

Unlike functional testing, which checks _what_ the system does, performance testing assesses _how well_ it does it.\
It can involve simulating hundreds, thousands, or even millions of users, as well as stressing the system beyond its designed limits to identify breaking points.

## Purpose of Performance Testing

* Validate that the application meets performance requirements for response time, throughput, and resource utilization.
* Detect performance bottlenecks before deployment.
* Ensure system stability under sustained or peak load conditions.
* Support capacity planning for future growth.
* Prevent performance-related failures in production that could impact user satisfaction or business operations.

## Aspects of Performance Testing

Performance testing evaluates multiple technical and operational dimensions that determine whether an application can deliver a high-quality user experience under expected and peak conditions.\
Each aspect targets a different performance attribute, and together they provide a complete picture of system behavior.

#### 1. **Response Time**

Measures the time taken for the system to respond to a request from the moment it is sent until the first byte or complete response is received.

* **Why it matters**: Directly impacts user satisfaction and usability.
* **What to watch for**: High latency under normal load, sudden spikes during peak usage, or slow responses for specific workflows.

#### 2. **Throughput**

Represents the number of transactions, requests, or data units the system can process within a given time frame.

* **Why it matters**: Determines if the system can handle business transaction volumes.
* **What to watch for**: Throughput dropping under load, uneven throughput across modules, or bottlenecks at specific services.

#### 3. **Scalability**

The system’s ability to maintain or improve performance as workload increases by adding resources such as servers, CPU, or memory.

* **Why it matters**: Ensures future growth without significant redesign.
* **What to watch for**: Diminishing returns when adding hardware, poor horizontal scaling, or dependency bottlenecks.

#### 4. **Stability**

The system’s ability to operate reliably over time under consistent or varying load conditions.

* **Why it matters**: Critical for long-running operations, SaaS platforms, and high-availability systems.
* **What to watch for**: Memory leaks, thread leaks, database connection exhaustion, or performance degradation over hours or days.

#### 5. **Resource Utilization**

Tracks how system resources (CPU, memory, disk I/O, network bandwidth) are consumed during operation.

* **Why it matters**: Efficient resource use ensures cost-effectiveness and prevents capacity exhaustion.
* **What to watch for**: High CPU usage without load, unoptimized memory allocation, disk contention, or network saturation.

#### 6. **Concurrency and Contention**

Evaluates how well the system handles multiple concurrent users or processes without significant degradation.

* **Why it matters**: Modern applications must support high levels of parallel activity.
* **What to watch for**: Thread contention, database locking, race conditions, or degraded performance under high concurrency.

#### 7. **Error Rate**

Measures the percentage of failed transactions or requests under varying loads.

* **Why it matters**: High error rates under load can indicate systemic instability or resource exhaustion.
* **What to watch for**: HTTP 5xx errors, failed database transactions, or dropped connections during stress conditions.

## Types of Performance Testing

<table data-header-hidden data-full-width="true"><thead><tr><th valign="top"></th><th valign="top"></th><th valign="top"></th><th valign="top"></th><th valign="top"></th><th valign="top"></th></tr></thead><tbody><tr><td valign="top"><strong>Type</strong></td><td valign="top"><strong>Purpose</strong></td><td valign="top"><strong>Key Focus</strong></td><td valign="top"><strong>Typical Scenarios</strong></td><td valign="top"><strong>Key Metrics</strong></td><td valign="top"><strong>Example Tools</strong></td></tr><tr><td valign="top"><strong>Load Testing</strong></td><td valign="top">To verify system performance under expected or typical workloads.</td><td valign="top">Response time, throughput, resource utilization under normal load.</td><td valign="top">Simulating the average daily user load or transaction volume.</td><td valign="top">Avg/95th percentile response time, throughput (TPS), CPU/memory usage.</td><td valign="top">JMeter, k6, Gatling, LoadRunner</td></tr><tr><td valign="top"><strong>Stress Testing</strong></td><td valign="top">To determine the system’s breaking point by pushing it beyond normal operational limits.</td><td valign="top">System stability and failure behavior under extreme load.</td><td valign="top">Gradually increasing load until system crashes or becomes unresponsive.</td><td valign="top">Max sustainable throughput, error rates, time-to-failure.</td><td valign="top">JMeter, Locust, BlazeMeter</td></tr><tr><td valign="top"><strong>Spike Testing</strong></td><td valign="top">To evaluate system performance when load suddenly increases or decreases.</td><td valign="top">Elasticity, recovery time, and stability under rapid load changes.</td><td valign="top">Sudden traffic surges after marketing campaigns or news coverage.</td><td valign="top">Response time during spikes, error rate, recovery time.</td><td valign="top">JMeter, k6, Gatling</td></tr><tr><td valign="top"><strong>Soak (Endurance) Testing</strong></td><td valign="top">To check system stability and performance over extended periods.</td><td valign="top">Memory leaks, resource leaks, performance degradation over time.</td><td valign="top">Running the system at normal load for 24+ hours to detect long-term issues.</td><td valign="top">Memory usage growth, CPU stability, transaction consistency.</td><td valign="top">JMeter, Gatling, LoadRunner</td></tr><tr><td valign="top"><strong>Scalability Testing</strong></td><td valign="top">To determine how performance changes when scaling up or down.</td><td valign="top">Efficiency of horizontal/vertical scaling, load distribution.</td><td valign="top">Adding servers or resources to handle increased users.</td><td valign="top">Performance improvement %, cost per transaction, load balancing efficiency.</td><td valign="top">JMeter, k6, Cloud-based test tools (e.g., BlazeMeter)</td></tr></tbody></table>

## Best Practices

* **Define Clear Performance Criteria**: Establish measurable KPIs (e.g., max response time, acceptable error rate).
* **Test in Production-Like Environments**: Ensure accuracy by replicating network, hardware, and software configurations.
* **Use Realistic Workload Models**: Simulate real user behavior and transaction mixes.
* **Include Both Baseline and Stress Scenarios**: Benchmark normal operation and failure thresholds.
* **Monitor System Metrics**: Collect detailed metrics on resource usage to identify bottlenecks.
* **Automate Where Feasible**: Schedule and repeat tests regularly to detect performance drift.
* **Integrate with CI/CD**: Run key performance tests automatically to catch regressions early.
