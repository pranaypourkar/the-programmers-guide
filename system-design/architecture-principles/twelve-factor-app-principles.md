# Twelve-Factor App Principles

## About

The [**Twelve-Factor App**](https://12factor.net/) methodology is a set of best practices for building modern, scalable, and maintainable software-as-a-service (SaaS) applications. These principles are especially useful in cloud-native and microservices architectures and align well with **Spring Boot** microservices. Below is a detailed explanation of each factor and how it applies to Spring Boot microservices.

## 1. Codebase

* **One codebase tracked in version control, many deploys.**
* A Spring Boot microservice should have **one codebase per service**, stored in version control (e.g., Git).
* Different environments (dev, QA, prod) should be **different deployments** of the same codebase, not separate branches or repositories.

## 2. Dependencies

* **Explicitly declare and isolate dependencies.**
* Spring Boot uses **Maven or Gradle** to manage dependencies via the `pom.xml` or `build.gradle`.
* All dependencies should be declared explicitly, no reliance on global or system-wide packages.

## 3. Config

* **Store config in the environment.**
* Configurations like DB credentials, API keys, etc. should be stored in **environment variables**.
* In Spring Boot:
  * Use `@Value` or `@ConfigurationProperties` to inject values.
  * Use profiles (`application-dev.yml`, `application-prod.yml`) to manage environment-specific configurations.
  * Externalize configuration via environment variables or tools like Spring Cloud Config.

## 4. Backing Services

* **Treat backing services as attached resources.**
* Databases, caches, message brokers, and other services should be treated as **external resources**.
* In Spring Boot:
  * Use `application.yml` to define connections.
  * Services can be swapped without code changes (e.g., switching from MySQL to PostgreSQL).

## 5. Build, Release, Run

* **Strictly separate build and run stages.**
* Spring Boot apps should follow these stages:
  * **Build**: Compile code and package it (`mvn package`).
  * **Release**: Combine build with config (Dockerize to create Image or prepare deployment).
  * **Run**: Execute the app in a runtime environment using the release artifact.

## 6. Processes

* **Execute the app as one or more stateless processes.**
* Spring Boot microservices should be **stateless** – store no session or local data.
* Any state should be stored in a database, cache, or distributed store.
* This enables horizontal scaling (multiple instances).

## 7. Port Binding

* **Export services via port binding.**
* Spring Boot apps should be self-contained and expose HTTP endpoints via a port (`server.port`).
* No need for an external web server like Apache – use embedded servers (Tomcat, Jetty, etc.).

## 8. Concurrency

* **Scale out via the process model.**
* Multiple instances of the Spring Boot app should be run to scale.
* Use orchestration tools (Docker, Kubernetes) to run multiple containers/pods.
* Avoid thread-heavy logic unless necessary – prefer stateless RESTful design.

## 9. Disposability

* **Maximize robustness with fast startup and graceful shutdown.**
* Spring Boot apps should:
  * Start quickly (limit init logic).
  * Handle `SIGTERM` or `SIGINT` for graceful shutdown (use `@PreDestroy` or `DisposableBean`).
  * Clean up resources like DB connections on shutdown.

## 10. Dev/Prod Parity

* **Keep development, staging, and production as similar as possible.**
* Ensure environments are consistent:
  * Use Docker to simulate production locally.
  * Use similar databases and queues in all stages.

## 11. Logs

* **Treat logs as event streams.**
* Spring Boot should log to **stdout/stderr** using SLF4J/Logback.
* Logs should not be written to files manually.
* External tools like ELK Stack (Elasticsearch, Logstash, Kibana), or Splunk can collect logs.

## 12. Admin Processes

* **Run admin/management tasks as one-off processes.**
* Tasks like DB migration, data import/export should be run separately.
* Use Spring Boot command-line runners (`CommandLineRunner`, `ApplicationRunner`) or Flyway/Liquibase for DB migrations.
