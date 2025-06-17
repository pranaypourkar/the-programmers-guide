# Operational Issues

## About

This section focuses on real-world failures and challenges that can occur when a system is deployed and running in production. These are not architectural flaws in the design, but operational behaviors that impact system reliability, performance, or availability.

It covers how a system behaves under load, how it fails, and what kind of failures you can expect once the application is live.

## Importance in System Design

* **Bridges the gap between design and reality**: Many systems look good on paper but fail in real-world usage due to operational oversights.
* **Supports resilience and fault tolerance**: Identifying operational issues early helps design more robust recovery and fallback strategies.
* **Encourages defensive thinking**: Helps engineers proactively account for things like thread exhaustion, memory pressure, or IO limitations.
* **Improves observability planning**: We learn what needs to be logged, traced, or alerted on by studying real failure modes.
