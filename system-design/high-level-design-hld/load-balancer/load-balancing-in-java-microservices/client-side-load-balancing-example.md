# Client-Side Load Balancing Example

## About

Client-side load balancing is a method where the load-balancing logic is executed on the client rather than a centralized load balancer.

## Netflix Ribbon

**Netflix Ribbon** is one of the popular libraries for implementing client-side load balancing in Java applications, often used in microservice architectures, particularly in conjunction with Spring Cloud.

### **What is Ribbon?**

Ribbon is a **client-side load balancer** that automatically distributes traffic across multiple service instances based on a configurable algorithm. Unlike traditional load balancers (such as HAProxy or NGINX), which reside between clients and servers, Ribbon allows clients to perform load balancing themselves by maintaining a list of server instances.

### How Ribbon Works?

Ribbon works by:

1. **Maintaining a list of available service instances**: Ribbon is responsible for keeping track of all the instances of a service, typically using service discovery mechanisms like **Eureka** or statically configured lists.
2. **Load Balancing Requests**: Each time a client makes a request, Ribbon selects an instance of the service based on a **load-balancing strategy** (e.g., round-robin, random, or weighted).
3. **Routing Requests to Instances**: Once Ribbon has selected a service instance, the client sends the request directly to that instance.

### Key Components of Ribbon

1. **ServerList**: Ribbon uses this to maintain a list of available servers (service instances). This can be dynamically populated using service discovery tools like Eureka, or it can be hardcoded.
2. **ILoadBalancer**: This interface defines the load balancer, which determines how to pick a server from the list of available instances. Ribbon provides default implementations, such as round-robin or random.
3. **Ping**: Ribbon can periodically check if instances are up or down by "pinging" them to ensure the health of the services. This ensures that requests are not sent to unhealthy instances.
4. **ServerListFilter**: This filters the available server list to exclude servers based on certain conditions (e.g., health status, region).
5. **IRule**: This defines the load-balancing strategy (or rule) that Ribbon uses to select a server. Some built-in strategies include:
   * **RoundRobinRule**: Distributes requests evenly across all available instances.
   * **RandomRule**: Chooses a random instance for each request.
   * **WeightedResponseTimeRule**: Chooses instances based on their response time, giving preference to faster instances.

### Example

