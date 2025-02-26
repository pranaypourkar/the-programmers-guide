# Horizontal Scaling (Scaling Out)

## About

Horizontal Scaling (Scaling Out) is the process of increasing system capacity by adding more machines (nodes) rather than upgrading a single machine. This approach distributes workloads across multiple servers, improving performance, fault tolerance, and scalability.

## **How Horizontal Scaling Works?**

* Instead of upgrading an existing machine, multiple machines (servers) are added to share the load.
* A **load balancer** distributes incoming requests across different servers.
* The system handles failures better, as other servers can take over when one fails.
* Common in microservices, distributed databases, and web applications with high traffic.

## **Advantages of Horizontal Scaling**

<table data-header-hidden data-full-width="true"><thead><tr><th width="323"></th><th></th></tr></thead><tbody><tr><td><strong>Advantage</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Unlimited Scaling</strong></td><td>No hardware limitation; just keep adding machines.</td></tr><tr><td><strong>Fault Tolerance</strong></td><td>If one machine fails, others take over, ensuring uptime.</td></tr><tr><td><strong>No Downtime</strong></td><td>Servers can be added dynamically without stopping the system.</td></tr><tr><td><strong>Cost-Effective</strong></td><td>Cheaper to add commodity hardware instead of buying a high-end machine.</td></tr><tr><td><strong>Better Load Distribution</strong></td><td>Requests are spread across multiple nodes, preventing a single point of failure.</td></tr></tbody></table>

## **Disadvantages of Horizontal Scaling**

<table data-header-hidden data-full-width="true"><thead><tr><th width="332"></th><th></th></tr></thead><tbody><tr><td><strong>Disadvantage</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>Increased Complexity</strong></td><td>Requires distributed coordination and data synchronization.</td></tr><tr><td><strong>Data Consistency Issues</strong></td><td>Managing consistency across multiple nodes is harder than in a single system.</td></tr><tr><td><strong>Networking Overhead</strong></td><td>Communication between multiple machines introduces latency.</td></tr><tr><td><strong>Higher Operational Costs</strong></td><td>More infrastructure and monitoring tools are needed.</td></tr></tbody></table>

## **When to Use Horizontal Scaling?**

* **Web Applications with High Traffic:** Websites like Facebook, Google, and Twitter need multiple servers to handle billions of requests.
* **Distributed Databases:** NoSQL databases like Cassandra and MongoDB scale horizontally for handling large datasets.
* **Microservices Architectures:** Each microservice can run on different machines, allowing independent scaling.
* **Real-time Applications:** Systems like video streaming (Netflix) or online gaming need multiple servers to handle concurrent users.
