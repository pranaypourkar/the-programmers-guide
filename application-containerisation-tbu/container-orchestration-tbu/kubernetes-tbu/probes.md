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

## **Types of Probes**

### **1. Liveness Probe**

* **Purpose**: Checks whether the container is still running and has not encountered an unrecoverable error.
* **Action**: If the liveness probe fails, Kubernetes restarts the container to recover from failures like deadlocks or crashes.
* **Common Use Cases**:
  * Detecting **deadlocks**, where the application is running but stuck.
  * Restarting containers that hang without terminating (e.g., a service that crashes but doesn’t exit).

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

**Best Practices:**

1. **Liveness Probe**:
   * Should be quick and lightweight to avoid overloading the system.
   * Ideal for checking basic application health (e.g., responding to HTTP requests).
2. **Readiness Probe**:
   * Should reflect actual readiness to handle requests (e.g., database connectivity, third-party service availability).
   * Keep it lightweight, but make sure it checks critical dependencies.
3. **Startup Probe**:
   * Set a reasonable failure threshold to account for application startup delays.
   * Don’t use the startup probe for ongoing health monitoring once the application is fully started.



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
