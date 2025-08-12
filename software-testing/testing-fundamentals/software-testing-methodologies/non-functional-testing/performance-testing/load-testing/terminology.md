# Terminology

## About

Understanding key terms used in load testing is essential for designing realistic tests, interpreting results correctly, and communicating findings effectively. This section defines common terminology used in load testing, particularly in the context of API and web system testing.

## **Virtual Users (VU)**

Virtual Users simulate actual users interacting with the system. Each VU may perform a set of operations (e.g., login, search, checkout). VUs run in parallel to generate concurrent load.

* In tools like JMeter or k6, each thread or script instance typically represents a VU.
* VUs may share or isolate sessions and data depending on configuration.

## **Concurrent Users**

The number of users or threads actively interacting with the system **at the same time**. This differs from total users over time — concurrency focuses on simultaneous activity.

* Example: 1,000 users over 1 hour ≠ 1,000 concurrent users.
* Important for measuring peak system load.

## **Ramp-Up Time**

The time taken to increase the number of virtual users from 0 to the target level.

* Used to avoid sudden overload.
* Example: If ramp-up is 60 seconds for 100 users, the tool adds \~1.67 users per second.

## **Throughput**

The number of transactions or requests the system processes per second (TPS or RPS).

* Indicates system capacity.
* Throughput depends on both system performance and test design (e.g., think time, errors).

## **Response Time (Latency)**

The time taken for a request to complete from initiation to receiving the full response.

* Typically measured in milliseconds or seconds.
* Can be analyzed in percentiles (e.g., 95% of requests < 1s).
* Includes server processing time and network delay.

## **Think Time**

The pause between two consecutive user actions to simulate human behavior.

* Without think time, load generators unrealistically hammer the system.
* Think time makes test results closer to real-world usage patterns.

## **Error Rate**

The percentage of requests that fail during the test.

* Acceptable error rate depends on business tolerance.
* High error rate may indicate application, infrastructure, or configuration issues.

## **Bottleneck**

A component or resource that limits the overall system performance under load.

* Could be CPU, memory, database, thread pool, disk I/O, or a slow third-party service.
* Bottlenecks are identified using both load test results and system monitoring.

## **Test Duration**

Total time for which the test runs.

* Short tests (under 5 minutes) help validate setup and scripts.
* Long-running tests (30 mins or more) help uncover memory leaks, saturation points, and performance degradation over time.

## **Steady State**

A period during the test when the load is constant and stable, allowing accurate performance measurements.

* Typically follows ramp-up and precedes ramp-down.
* Metrics are usually analyzed from this window to avoid startup noise.

## **Capacity**

The maximum number of concurrent users or transactions the system can handle while meeting performance goals (e.g., < 2s response time).

* Capacity is determined experimentally through load and stress testing.
* Exceeding capacity results in degraded performance or failures.

## **Baseline**

The initial set of performance measurements taken before tuning or optimization.

* Used for comparison with future test runs.
* Establishes normal system behavior under expected load.

## **Load Pattern**

The shape or structure of how load is applied over time. Common patterns include:

* Constant load
* Ramp-up and hold
* Step-wise increase
* Spike
* Random/chaotic

Choosing the right pattern is essential to replicate real usage conditions.

## **90th / 95th / 99th Percentile Response Time**

Percentile metrics indicate the response time threshold below which a certain percentage of requests fall.

* 95th percentile = 95% of requests responded in this time or less.
* These metrics help identify outliers and worst-case behavior, not just averages.

## **Warm-Up**

The initial phase of the test where the system stabilizes before measurements begin.

* Especially important for systems with JIT compilers (e.g., Java), caches, or lazy loading.
* Avoid analyzing metrics during this period.

## **System Under Test (SUT)**

The complete set of components (application, backend, DB, infrastructure) being evaluated in the test.

* SUT should resemble production as closely as possible.
* May include microservices, databases, message brokers, caches, and frontend.

## **SLA (Service Level Agreement)**

Performance standards agreed upon with stakeholders or customers.

* Common SLA metrics:
  * 95% of requests complete < 1.5s
  * Error rate < 1%
  * Uptime ≥ 99.9%
* Load testing validates these targets under expected load.

