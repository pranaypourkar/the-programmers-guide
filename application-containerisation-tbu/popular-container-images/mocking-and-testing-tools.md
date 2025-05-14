# Mocking & Testing Tools

## About

Containers for tools like MockServer and WireMock used to simulate APIs, dependencies, or external services in a controlled environment. They are crucial for integration and contract testing, especially in microservice architectures.

## **MockServer 5.15.0**

MockServer is a powerful tool for mocking and testing HTTP and HTTPS APIs. It allows developers to simulate RESTful services, HTTP endpoints, and complex integration behaviors. The `mockserver:mockserver-5.15.0` image is a stable release ideal for local testing, CI pipelines, or integration with tools like Testcontainers.

**Docker Pull Command:**

```bash
docker pull --platform linux/amd64 mockserver/mockserver:mockserver-5.15.0
```

**Basic Usage:**

```bash
docker run -d \
  -p 1080:1080 \
  mockserver/mockserver:mockserver-5.15.0
```

**Notes:**

* REST API is available on port `1080` for setting up expectations and verifying requests
* Can be used in automated tests with Java libraries or Postman scripts
* Compatible with Testcontainers via `org.testcontainers:mockserver`
