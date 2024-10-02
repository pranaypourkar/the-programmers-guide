# Server-Side Load Balancing Example

## About

In **server-side load balancing**, a central load balancer distributes incoming traffic across multiple backend servers to ensure that no single server is overwhelmed with requests.

## **NGINX**

One of the most widely used tools for server-side load balancing is **NGINX**. Unlike client-side load balancing (where the client makes decisions about which server to use), server-side load balancing occurs on a dedicated machine that sits between the client and the backend services.

### **What is NGINX?**

NGINX is a powerful open-source web server that also functions as a **reverse proxy**, **load balancer**, and **HTTP cache**. It is commonly used to manage incoming HTTP, TCP, and UDP traffic and distribute it efficiently across multiple backend servers.

### How Server-Side Load Balancing Works with NGINX?

When a client sends a request to a system using server-side load balancing, the request is first received by the load balancer (NGINX in this case). NGINX then selects a backend server (from a pool of servers) based on a predefined **load-balancing algorithm** and forwards the request to that server. Once the backend server processes the request, it sends the response back to NGINX, which in turn forwards it to the client.

### NGINX Load Balancing Architecture

* **Client**: Sends requests to the load balancer (NGINX).
* **NGINX (Load Balancer)**: Distributes incoming requests to one of the backend servers based on a load-balancing algorithm.
* **Backend Servers**: A pool of servers (e.g., API servers, web servers) that handle the actual processing of requests.

### Example

