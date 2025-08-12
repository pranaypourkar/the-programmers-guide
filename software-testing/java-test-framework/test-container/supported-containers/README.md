# Supported Containers

## About

Testcontainers provides pre-built, production-grade containers for a wide range of technologies commonly used in modern software development and testing. These containers are built and maintained with testing in mind — ensuring fast startup, isolated environments, and integration with popular test frameworks like **JUnit**, **Spring Boot**, and **TestNG**.

They are especially useful in **integration testing**, where simulating real infrastructure components (like databases, message brokers, or cloud services) is essential to verifying end-to-end functionality. Rather than relying on mock objects or in-memory alternatives, Testcontainers allows you to spin up **real services** in **throwaway containers** during test execution.

## **Why Use Pre-Built Containers?**

1. **Realism in Testing**\
   Pre-built containers run the same software your production system depends on. This means tests behave more like your real-world deployments.
2. **Speed and Repeatability**\
   Containers start quickly and are disposed of after the test run. You get clean state every time, removing flakiness caused by leftover data.
3. **Minimal Setup Overhead**\
   No need to manually install or configure test dependencies (like databases or queues). Simply declare the container and let Testcontainers handle the lifecycle.
4. **Portability Across Teams and CI**\
   Since everything runs in Docker containers, the same test setup works on your local machine and on CI/CD pipelines like GitHub Actions, GitLab, Jenkins, etc.
5. **Support for Popular Tech Stack Components**\
   Testcontainers includes official modules for a wide variety of backend systems like PostgreSQL, Kafka, Redis, Elasticsearch, MongoDB, Oracle XE, and many more.
6. **Custom Containers with GenericContainer**\
   Even if a specific service isn't officially supported, you can use `GenericContainer` to define your own containerized service using any Docker image.

## **Use Cases for Supported Containers**

* Integration Tests with Real Databases
* Verifying Messaging Systems (e.g., Kafka, RabbitMQ)
* Simulating Cloud APIs using LocalStack
* Testing Search Queries with Elasticsearch
* Validating Session Stores using Redis
* End-to-End Testing with Browser Containers
