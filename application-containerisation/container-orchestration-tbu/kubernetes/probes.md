# Probes

## About

In Kubernetes, **probes** are diagnostic tools that help the orchestrator (Kubernetes) determine the state of an application (container) inside a pod. These probes allow Kubernetes to monitor the health and readiness of the application and take appropriate action when needed.

There are **three main types of probes** in Kubernetes:

1. **Liveness Probe**: Checks whether the application is still alive and functioning.
2. **Readiness Probe**: Determines whether the application is ready to accept traffic.
3. **Startup Probe**: Used to determine if the application has successfully started (especially for slow-starting applications).

Kubernetes uses these probes to:

* Monitor the health and readiness of containers.
* Decide whether to restart a container or remove it from the load balancer.

Probes are configured at the container level and help Kubernetes perform **self-healing** actions, ensuring higher availability and reliability of applications.

Refer to the official documentation for more details - [https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

## **Types of Probes**

### **1. Liveness Probe**

* **Purpose**: Checks whether the container is still running and has not encountered an unrecoverable error.&#x20;

For a Liveness Probe we usually,&#x20;

1. Expose an endpoint from our app
2. The endpoint always replies with a success response
3. Consume the endpoint from the Liveness probe

* **Action**: If the liveness probe fails, Kubernetes restarts the container to recover from failures like deadlocks or crashes.
* **Common Use Cases**:
  * Detecting **deadlocks**, where the application is running but stuck.
  * Restarting containers that hang without terminating (e.g., a service that crashes but doesn’t exit).

{% hint style="warning" %}
Consider a scenario where our application is processing or stuck in an infinite loop and there's no way to exit or ask for help. When the process is consuming 100% CPU, it won't have time to reply to the others (i.e. readiness probe checks fails), and it will be eventually removed from the service from accepting traffic.

However, the Pod is still registered as an active replica for the current Deployment. And if we don't have a Liveness probe, it stays _Running_ but detached from the service. So, pod is not only serving any requests, but it is also consuming resources.
{% endhint %}

{% hint style="success" %}
The Liveness probe should only be used as a recovery mechanism in case the process is not responsive.
{% endhint %}

**Example:**

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 3
  periodSeconds: 5
  timeoutSeconds: 1
  failureThreshold: 3
```

In this example, Kubernetes performs an HTTP GET request to `/healthz` on port 8080. If the request fails 3 times consecutively, Kubernetes restarts the container.

### **2. Readiness Probe**

* **Purpose**: Checks whether the container is ready to accept traffic. It determines if the application is in a state where it can handle requests or if it needs to perform additional initialization.
* **Action**: If the readiness probe fails, Kubernetes stops routing traffic to the container but doesn’t restart it.
* **Common Use Cases**:
  * Ensuring the application is initialized and connected to necessary resources (e.g., databases).
  * Preventing the routing of traffic before the application is fully ready.

{% hint style="warning" %}
If readiness probe is not set, the kubelet will assume that the app is ready to receive traffic as soon as the container starts. If the container takes 5 minutes to start, all the requests to it will fail for those 5 minutes.
{% endhint %}

**Example:**

```yaml
readinessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 10
  failureThreshold: 3
```

In this example, Kubernetes runs a command (`cat /tmp/healthy`). If the file doesn't exist, the container is marked as "not ready," and it is removed from the load balancer.

#### Readiness Probe's Independence

* **Independent of Services**: The readiness probe is independent in the sense that Kubernetes will check the container's internal health status based on the configured probe parameters (like HTTP response, TCP check, or command execution).
* **External Dependencies**: The probe itself does **not** check if external dependencies (like databases or APIs) are available. If the container depends on other services (such as a database or an external API), the readiness probe will not be able to automatically detect the unavailability of those services unless we explicitly program the readiness check to verify those services.

#### **How to Handle External Dependencies with Readiness Probes**

While the readiness probe is independent of external services by default, you can configure it to **include checks for external services** by making the probe check an endpoint in your application that verifies these dependencies.

For example:

* **Database Migrations**: If your application requires database migrations to be completed before it is ready, you can write an application-level check in your code that verifies if migrations are complete. You could then make the readiness probe call an endpoint that performs this check (e.g., `/healthz/db`).
* **External APIs/Third-party services**: If your application relies on external services (like APIs or third-party services), the readiness probe can also check whether those services are reachable by your application. This could be done by adding a health check endpoint that checks the status of external services before returning a success response to Kubernetes.

#### Example of Readiness Probe with External Dependency Check:

Suppose our application needs a database to be available and ready for operation. We could have an endpoint `/readiness` in your application that checks both the application state and the availability of the database.

Here's an example:

```yaml
readinessProbe:
  httpGet:
    path: /readiness
    port: 8080
  initialDelaySeconds: 60
  periodSeconds: 30
  timeoutSeconds: 5
  failureThreshold: 3
```

In our application code, the `/readiness` endpoint might look like:

```java
@GetMapping("/readiness")
public ResponseEntity<String> checkReadiness() {
    if (databaseIsReady() && externalServiceIsAvailable()) {
        return ResponseEntity.ok("Ready");
    } else {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body("Not Ready");
    }
}
```

### **3. Startup Probe**

* **Purpose**: Ensures the application has started properly. This is useful for slow-starting applications that might take longer than usual to become ready. It avoids Kubernetes killing the container before it has had time to initialize.
* **Action**: If the startup probe fails, Kubernetes restarts the container. If the probe succeeds, the system switches to using the liveness and readiness probes.
* **Common Use Cases**:
  * Applications with complex initialization processes or external dependencies (e.g., waiting for a database to be available).
  * Preventing the premature failure of liveness probes during startup.

**Example:**

```yaml
startupProbe:
  httpGet:
    path: /startup
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

Here, Kubernetes checks the `/startup` endpoint every 10 seconds for up to 5 minutes (30 attempts) to confirm that the application has started.

## **Probe Mechanisms**

Kubernetes provides three mechanisms for probes:

**1. HTTP GET Probe**

* Sends an **HTTP GET request** to the container’s endpoint.
* The container is considered healthy if the server responds with a successful HTTP status code (usually in the `2xx` or `3xx` range).

**Example:**

```yaml
httpGet:
  path: /healthz
  port: 8080
```

**2. Command Execution Probe**

* Executes a **command** inside the container and checks the exit code.
* The probe is successful if the command exits with a `0` status code. If the command fails (non-zero exit code), the probe fails.

**Example:**

```yaml
exec:
  command:
  - cat
  - /tmp/healthy
```

**3. TCP Socket Probe**

* Opens a **TCP connection** to the container’s port.
* If the connection succeeds, the container is considered healthy. If it fails, the container is considered unhealthy.

**Example:**

```yaml
tcpSocket:
  port: 8080
```

## **Probe Configuration Parameters**

Here are the key configuration parameters for probes:

<table data-header-hidden data-full-width="true"><thead><tr><th width="233"></th><th></th></tr></thead><tbody><tr><td><strong>Parameter</strong></td><td><strong>Description</strong></td></tr><tr><td><strong>initialDelaySeconds</strong></td><td>Time (in seconds) to wait after the container starts before performing the first probe.</td></tr><tr><td><strong>periodSeconds</strong></td><td>Time (in seconds) between consecutive probe attempts.</td></tr><tr><td><strong>timeoutSeconds</strong></td><td>The amount of time (in seconds) to wait for a probe to complete before it times out.</td></tr><tr><td><strong>failureThreshold</strong></td><td>The number of consecutive failures that will trigger the container restart (for liveness probe) or removal from the load balancer (for readiness probe).</td></tr><tr><td><strong>successThreshold</strong></td><td>The number of consecutive successes required for the container to be considered healthy or ready (used in readiness probes).</td></tr><tr><td><strong>probeHandler</strong></td><td>Defines how Kubernetes should perform the probe: HTTP request, exec command, or TCP socket.</td></tr></tbody></table>

## **Use Cases and Best Practices**

### **Liveness Probe Use Cases:**

* Detect **deadlocks** or hanging processes where the application doesn’t crash but stops responding or making progress.
* Restart containers when critical internal processes (such as database connections or cache) become unresponsive.

### **Readiness Probe Use Cases:**

* Ensure the application is fully initialized before routing traffic (e.g., waiting for a database to be available).
* Protect the system during **rolling updates**: ensure that only containers that are actually ready to handle traffic are included in the load balancing pool.

### **Startup Probe Use Cases:**

* Prevent **premature failure** of liveness probes during the startup phase, especially for applications that require considerable time to initialize.
* Use for **large-scale applications** that might involve waiting for external dependencies or lengthy initialization routines.

## **Best Practices**

1. **Liveness Probe**:
   * Should be quick and lightweight to avoid overloading the system.
   * Ideal for checking basic application health (e.g., responding to HTTP requests).
2. **Readiness Probe**:
   * Should reflect actual readiness to handle requests (e.g., database connectivity, third-party service availability).
   * Keep it lightweight, but make sure it checks critical dependencies.
3. **Startup Probe**:
   * Set a reasonable failure threshold to account for application startup delays.
   * Don’t use the startup probe for ongoing health monitoring once the application is fully started.

{% hint style="info" %}
Refer to this link for more best practices- [https://github.com/learnk8s/kubernetes-production-best-practices/tree/master](https://github.com/learnk8s/kubernetes-production-best-practices/tree/master)&#x20;
{% endhint %}

## **How Probes Improve Application Lifecycle Management**

Kubernetes probes play a vital role in ensuring **reliability** and **availability** of applications, enabling **self-healing** and preventing downtime.

1. **Automatic Recovery**:
   * **Liveness probes** ensure that applications that get stuck are automatically restarted, improving **fault tolerance**.
   * **Startup probes** prevent premature container restarts during long initialization phases, allowing the application to fully initialize before becoming part of the service pool.
2. **Traffic Management**:
   * **Readiness probes** ensure that only containers that are fully ready to serve traffic are included in the load balancer, improving user experience and **availability** during updates.
3. **Simplifying Deployments and Scaling**:
   * During **rolling updates**, Kubernetes ensures only healthy containers receive traffic, which minimizes disruptions during deployment.
   * During **scaling** events, readiness probes ensure that the scaling process doesn’t send traffic to containers that are not yet ready.
4. **Monitoring and Debugging**:
   * Probes provide insights into container health and can be used to debug issues, especially when a container fails to start or hangs in an unhealthy state.
   * By fine-tuning probes, you can better handle applications with varying initialization times or external dependencies.

## Example

Using Actuator endpoints for health, readiness and startup check.

```yaml
  startupProbe:
    enabled: true
    port: "http"
    initialDelaySeconds: 120
    failureThreshold: 6
    periodSeconds: 30
    timeoutSeconds: 5
    path: /actuator/health/liveness
  livenessProbe:
    enabled: true
    port: "http"
    initialDelaySeconds: 120
    failureThreshold: 6
    periodSeconds: 30
    timeoutSeconds: 5
    path: /actuator/health/liveness
  readinessProbe:
    enabled: true
    port: "http"
    initialDelaySeconds: 120
    failureThreshold: 6
    periodSeconds: 30
    timeoutSeconds: 5
    path: /actuator/health/readiness
```

<div><figure><img src="../../../.gitbook/assets/kubernetes-probe-2.png" alt=""><figcaption></figcaption></figure> <figure><img src="../../../.gitbook/assets/kubernetes-probe-1.png" alt=""><figcaption></figcaption></figure></div>

