# Caching

## About

Caching is a design technique used in software systems to temporarily store frequently accessed data in a faster storage layer so that future requests for that data can be served more quickly. Instead of fetching the data from a slower or more expensive resource (like a database, external service, or disk), the system retrieves it from a cache, which is typically memory-based and significantly faster.

A cache can reside at various levels — within the application, in a shared service like Redis, or even in front of the system as a content delivery network (CDN). The basic idea is to trade memory or local compute resources to gain faster response times and reduce the load on downstream systems.

Common examples of cached data include user profiles, configuration settings, product details, access tokens, or computed results of expensive operations.

## Why Cache?

Caching serves multiple high-level system objectives. The main drivers for using caching include:

### 1. Reducing Latency

Fetching data from memory (cache) is orders of magnitude faster than from databases or remote services. Caching helps reduce the end-to-end latency of a request, improving application responsiveness and user experience.

Example: Serving user profile data from Redis cache in 2 ms vs querying the database in 50–100 ms.

### 2. Improving Throughput

Caching offloads the backend data stores by absorbing repeated requests. With fewer calls to the underlying systems, those systems can handle more diverse queries or user requests overall.

Example: If 90% of the traffic is handled by cache, only 10% hits the primary data store, allowing it to serve other operations more efficiently.

### 3. Enabling Scalability

As user traffic increases, systems need to scale. Caching allows horizontal scaling by reducing pressure on centralized systems. This is particularly important in distributed systems where multiple stateless application instances are running.

Example: A system with distributed caching can serve millions of requests per second with consistent performance without overloading the database.

### 4. Increasing Fault Tolerance

In certain scenarios, a cache can serve stale or fallback data if the primary data source is down, helping the system degrade gracefully instead of failing entirely.

Example: Serve a cached version of pricing or configuration during a temporary database outage.

## Where Caching Fits in System Architecture ?

Caching can be introduced at various layers in a system's architecture depending on what data is being cached and what the performance goals are. Common placement options include:

### 1. Client-Side Caching

* Implemented in browsers or mobile apps.
* Used for static assets, session tokens, or small data payloads.

### 2. Application-Level Caching

* Typically in-memory caches like `ConcurrentHashMap` in Java or frameworks like Spring’s `@Cacheable`.
* Limited to a single application instance (pod-level).
* Fastest access, but no data sharing between instances.

### 3. Distributed Caching Layer

* Used to share cached data between multiple pods or microservices.
* Technologies include Redis, Memcached, Hazelcast, Infinispan.
* Suitable for horizontally scalable architectures.

### 4. Database Caching

* Query result caches, materialized views, or second-level ORM caches (e.g., Hibernate’s L2 cache).
* Reduces pressure on database for repeated queries.

### 5. CDN or Edge Caching

* Used in web applications to cache static resources like images, JS/CSS files.
* Deployed closer to the user’s location to reduce network latency.

Each caching layer has different access patterns, expiry mechanisms, and trade-offs. In modern architectures, multiple types of caches are often used in combination.
