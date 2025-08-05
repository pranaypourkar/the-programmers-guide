# Stress Testing

## About

**Stress Testing** is a type of performance testing that evaluates how a system behaves under extreme or beyond-expected workload conditions.\
Its primary goal is to determine the system’s breaking point, understand how it fails, and verify whether it can recover gracefully without data loss or prolonged downtime.

Unlike load testing, which measures performance under expected conditions, stress testing deliberately pushes the system past its capacity limits to reveal vulnerabilities in hardware, software, or architecture.

## Purpose of Stress Testing

* Identify the **maximum operating capacity** of the system.
* Determine the **breaking point** where performance starts to degrade significantly or the system becomes unresponsive.
* Evaluate how the system **recovers** after failure, including restart time and data integrity.
* Expose **bottlenecks** in hardware, software, or network infrastructure under extreme demand.
* Assess **error handling and failover mechanisms** during overload situations.

## Aspects of Stress Testing

Stress testing examines how the system behaves when pushed well beyond its normal operating limits.\
Each aspect focuses on different stress conditions and the resulting system behavior.

#### 1. **Load Threshold Identification**

Determines the maximum number of concurrent users, transactions, or requests the system can sustain before performance begins to degrade.

* Reveals the point where latency, error rate, or resource consumption spikes.

#### 2. **Performance Degradation Pattern**

Studies how performance metrics change as load approaches and exceeds capacity.

* Helps identify gradual slowdowns vs sudden failures.
* Useful for predicting early-warning indicators before critical failures occur.

#### 3. **Failure Mode Analysis**

Evaluates the nature of system failure when overloaded.

* Determines if failures are graceful (controlled shutdown, error handling) or catastrophic (crash, data loss).

#### 4. **Resource Exhaustion Behavior**

Observes the system’s stability under maximum utilization of CPU, memory, disk I/O, or network bandwidth.

* Detects memory leaks, deadlocks, and thread contention issues.

#### 5. **Recovery Capability**

Assesses the system’s ability to return to normal operation after the overload condition ends.

* Measures restart times, service availability restoration, and data integrity after recovery.

#### 6. **Sustained Overload Resilience**

Evaluates how the system behaves when subjected to continuous overload for extended durations.

* Useful for detecting cumulative failures like connection pool exhaustion or log file growth issues.

## When to Perform Stress Testing ?

Stress testing is typically performed:

* Before high-visibility launches or promotional events expected to cause traffic spikes.
* After major infrastructure or scaling changes.
* As part of disaster recovery and resilience testing.
* To validate service-level agreements (SLAs) for uptime and recovery times.
* In preparation for seasonal traffic peaks (e.g., holiday sales, ticket bookings).

## Stress Testing Tools

* **General Purpose Load/Stress Tools**
  * Apache JMeter
  * Gatling
  * k6
  * Locust
* **Cloud-based Scalable Testing**
  * BlazeMeter
  * AWS Distributed Load Testing
  * Azure Load Testing
* **Monitoring and Analysis**
  * Grafana + Prometheus
  * New Relic, Datadog, AppDynamics

## Best Practices

#### 1. **Define Clear Overload Targets**

Decide the stress levels to simulate (e.g., 200%, 300% of normal load) and the duration of overload phases.

* Ensure targets are realistic and aligned with business risk scenarios.

#### 2. **Establish a Baseline First**

Run load tests to determine normal capacity before applying stress.

* A baseline helps measure how far performance falls under extreme conditions.

#### 3. **Simulate Realistic Overload Scenarios**

Design scenarios that mirror actual potential stress conditions, such as:

* Sudden user surges from marketing campaigns.
* API abuse or malicious traffic spikes.
* Batch processing overlap with peak user activity.

#### 4. **Monitor System Internals and Externals**

Track both system-level metrics (CPU, memory, network I/O) and application-level metrics (response time, error rate, queue length).

* Use detailed logging to pinpoint bottlenecks during overload.

#### 5. **Test Failover and Recovery**

Plan tests to trigger failover mechanisms and observe if backup systems engage correctly.

* Evaluate how quickly and cleanly the system recovers after stress is removed.

#### 6. **Isolate Test Environments**

Avoid conducting uncontrolled stress tests on live production systems unless part of a controlled chaos engineering exercise.

* Use staging or pre-production with production-equivalent configurations.

#### 7. **Iterate and Retest**

After resolving issues found in a stress test, repeat the test to confirm fixes and identify new potential weak points.

#### 8. **Document Results for Risk Assessment**

Record stress levels, failure points, and recovery times.

* Share findings with engineering, operations, and business stakeholders for capacity planning and incident preparedness.
