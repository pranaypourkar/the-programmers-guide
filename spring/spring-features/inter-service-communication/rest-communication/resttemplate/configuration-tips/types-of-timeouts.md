# Types of Timeouts

## About

Timeouts are a critical part of designing resilient, responsive HTTP clients. Without proper timeouts, applications risk hanging indefinitely, exhausting system resources, or propagating delays downstream.

## 1. **Connection Timeout**

Connection timeout defines how long the client will wait to establish a TCP socket connection to the target server.

**Why It Matters**

This phase occurs before any HTTP request is actually sent. If the remote server is unavailable, misconfigured, or experiencing heavy load, connection establishment may hang. This timeout ensures the application doesn't waste time waiting for a connection that might never succeed.

**Example Use Case**

A service trying to call an external banking API that may have variable network availability. If the bank’s server is down or DNS resolution is slow, a short connection timeout will ensure your app quickly fails and retries via fallback logic or circuit breaker.

**Design Insight**

Set the connection timeout to a low value (e.g., 1–3 seconds) in production systems. A failure to connect should be treated as a hard failure and reported quickly.

## 2. **Read Timeout**

Read timeout defines the maximum time the client will wait **after sending the request** for the server to return data (including headers and body).

**Why It Matters**

Once a connection is made and the request is sent, the server might be slow in processing the request or in generating a response due to internal load, large payloads, or slowness in backend systems.

**Example Use Case**

Imagine your service fetches billing details from a third-party service that generates a PDF report. The server could take several seconds to generate and return it. A read timeout ensures the request does not wait too long and eventually times out if the response is delayed.

**Design Insight**

Set this timeout depending on the expected response size and server latency. Typically ranges from 2–10 seconds. Long read timeouts could impact your system’s ability to serve other requests under load.

## 3. **Connection Request Timeout**

This timeout applies only when using a **connection pool** (e.g., Apache HttpClient). It defines how long to wait when trying to borrow a connection from the pool if all are currently in use.

**Why It Matters**

In high-throughput systems, connections to external services are reused and managed through a pool to optimize resource usage. But if too many threads request connections simultaneously, the pool may be exhausted. This timeout controls how long threads wait before giving up.

**Example Use Case**

An e-commerce checkout system making simultaneous calls to inventory, payment, and shipping services. If the pool is limited and traffic spikes, requests might block waiting for a connection. This timeout avoids threads being blocked indefinitely.

**Design Insight**

Connection pools are not infinite. Set this timeout low (e.g., 100–500 ms) and monitor pool metrics. If timeouts frequently occur, consider increasing the pool size or introducing bulkhead isolation.
