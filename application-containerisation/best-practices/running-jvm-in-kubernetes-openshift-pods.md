# Running JVM in Kubernetes/OpenShift Pods

## About

Running a JVM-based application inside **Kubernetes/OpenShift** requires **proper configuration** to optimize **memory**, **CPU**, **garbage collection**, and **resource utilization** while preventing **OOM errors** and ensuring **stability**. Below are **best practices** categorized for different aspects of JVM tuning in containers.

## **Memory Management Best Practices**

**Why?** JVM does **not** automatically respect Kubernetes/OpenShift memory limits unless explicitly configured.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Recommended JVM Options</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Use <code>MaxRAMPercentage</code>instead of <code>-Xmx</code></strong></td><td><code>-XX:MaxRAMPercentage=75.0</code> <em>(Java 11+)</em></td><td>Sets heap memory dynamically based on container limits instead of a fixed size.</td></tr><tr><td><strong>Use <code>InitialRAMPercentage</code>for predictable startup memory</strong></td><td><code>-XX:InitialRAMPercentage=50.0</code> <em>(Java 11+)</em></td><td>Ensures a <strong>reasonable</strong> heap allocation at startup.</td></tr><tr><td><strong>Enable container-awareness</strong></td><td><code>-XX:+UseContainerSupport</code> <em>(Java 10+)</em></td><td>Ensures JVM respects cgroups memory limits. <em>(Enabled by default in Java 11+)</em>.</td></tr><tr><td><strong>Dump heap on OOM errors for debugging</strong></td><td><code>-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/dumps/heap.hprof</code></td><td>Allows post-mortem analysis of memory issues.</td></tr><tr><td><strong>Exit JVM immediately on OOM to restart the pod</strong></td><td><code>-XX:+ExitOnOutOfMemoryError</code></td><td>Prevents a failing pod from staying alive and consuming resources.</td></tr></tbody></table>

**Example for memory-optimized Kubernetes JVM:**

```shell
java -XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0 -XX:+ExitOnOutOfMemoryError -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/dumps/heap.hprof -jar app.jar
```

## **CPU and Threading Best Practices**

**Why?** By default, JVM detects **all** available CPU cores, which may lead to excessive thread creation in Kubernetes/OpenShift environments.

<table data-header-hidden data-full-width="true"><thead><tr><th width="294"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Recommended JVM Options</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Limit CPU usage to avoid pod throttling</strong></td><td><code>-XX:ActiveProcessorCount=&#x3C;N></code></td><td>Manually set the number of CPU cores JVM should use.</td></tr><tr><td><strong>Set appropriate thread pool sizes</strong></td><td><code>-Djava.util.concurrent.ForkJoinPool.common.parallelism=&#x3C;N></code></td><td>Ensures thread pools match available resources.</td></tr><tr><td><strong>Enable efficient garbage collection</strong></td><td><code>-XX:+UseG1GC</code> <em>(Default in Java 11+)</em></td><td>Balances performance and latency for most applications.</td></tr><tr><td><strong>For latency-sensitive apps, use ZGC</strong></td><td><code>-XX:+UseZGC</code> <em>(Java 17+)</em></td><td><strong>Low-latency GC</strong> with minimal pause times, ideal for real-time processing.</td></tr></tbody></table>

**Example for CPU-aware Kubernetes JVM:**

```shell
java -XX:ActiveProcessorCount=2 -XX:+UseG1GC -Djava.util.concurrent.ForkJoinPool.common.parallelism=2 -jar app.jar
```

## **Garbage Collection (GC) Best Practices**

**Why?** Containers are resource-constrained, and GC tuning prevents excessive memory usage and long pauses.

<table data-header-hidden data-full-width="true"><thead><tr><th width="365"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Recommended JVM Options</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Use G1GC for balanced performance</strong> <em>(Default in Java 11+)</em></td><td><code>-XX:+UseG1GC</code></td><td>Good for most microservices.</td></tr><tr><td><strong>For low-latency workloads, use ZGC</strong> <em>(Java 17+)</em></td><td><code>-XX:+UseZGC</code></td><td><strong>Pause times &#x3C;1ms</strong>, great for real-time processing.</td></tr><tr><td><strong>For memory-constrained environments, use Shenandoah GC</strong> <em>(Java 17+)</em></td><td><code>-XX:+UseShenandoahGC</code></td><td>Works well with small heap sizes.</td></tr><tr><td><strong>Enable GC logging for monitoring</strong></td><td><code>-Xlog:gc:/var/logs/gc.log</code></td><td>Helps analyze GC behavior inside containers.</td></tr></tbody></table>

**Example GC tuning for Kubernetes JVM:**

```shell
java -XX:+UseG1GC -Xlog:gc:/var/logs/gc.log -jar app.jar
```

## **Resource Requests & Limits**

**Why?** Properly defining **CPU and memory requests/limits** ensures stable performance and prevents resource contention.

{% hint style="info" %}
**Requests**

* The **minimum** amount of **CPU/memory** allocated to a container.
* Kubernetes ensures that the container **always gets at least this amount**.
* If a node does **not have enough requested resources**, Kubernetes **won't schedule the pod**.

**Limits**

* The **maximum** amount of **CPU/memory** a container can use.
* If a container **exceeds the memory limit**, it **gets killed (OOMKilled)**.
* If it **exceeds CPU limit**, it gets **throttled** (not killed).
{% endhint %}

<table data-header-hidden data-full-width="true"><thead><tr><th width="349"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Kubernetes YAML Example</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Set appropriate memory requests &#x26; limits</strong></td><td><code>yaml resources: requests: memory: "1Gi" limits: memory: "2Gi"</code></td><td>Ensures JVM doesn’t allocate more memory than the pod allows.</td></tr><tr><td><strong>Set CPU limits for predictable performance</strong></td><td><code>yaml resources: requests: cpu: "500m" limits: cpu: "1"</code></td><td>Prevents excessive CPU usage and throttling.</td></tr></tbody></table>

## **Monitoring & Observability Best Practices**

**Why?** Monitoring JVM inside Kubernetes helps detect performance bottlenecks, memory leaks, and CPU issues.

<table data-header-hidden data-full-width="true"><thead><tr><th width="273"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Tool/Option</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Enable JMX for real-time monitoring</strong></td><td><code>-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010</code></td><td>Allows Prometheus/Grafana to collect JVM metrics.</td></tr><tr><td><strong>Use Prometheus with Micrometer for JVM metrics</strong></td><td><code>io.micrometer:micrometer-registry-prometheus</code></td><td>Exposes JVM <strong>heap, GC, and thread metrics</strong> for Kubernetes dashboards.</td></tr><tr><td><strong>Enable GC logs for analysis</strong></td><td><code>-Xlog:gc:/var/logs/gc.log</code></td><td>Useful for debugging memory issues.</td></tr></tbody></table>

**Example JMX-enabled Kubernetes JVM:**

```shell
java -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -XX:+UseG1GC -Xlog:gc:/var/logs/gc.log -jar app.jar
```

## **Auto-Restart & Resilience Best Practices**

**Why?** If a JVM crashes or runs out of memory, Kubernetes should automatically restart the pod.

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Best Practice</strong></td><td><strong>Kubernetes Configuration</strong></td><td><strong>Explanation</strong></td></tr><tr><td><strong>Set restart policy to <code>Always</code></strong></td><td><code>yaml restartPolicy: Always</code></td><td>Ensures the pod restarts if JVM crashes.</td></tr><tr><td><strong>Use <code>livenessProbe</code> to detect JVM failures</strong></td><td><code>yaml livenessProbe: httpGet: path: /actuator/health port: 8080 initialDelaySeconds: 10 periodSeconds: 5</code></td><td>Restarts JVM if it becomes unresponsive.</td></tr><tr><td><strong>Use <code>readinessProbe</code> to prevent traffic to unhealthy pods</strong></td><td><code>yaml readinessProbe: httpGet: path: /actuator/health port: 8080 initialDelaySeconds: 5 periodSeconds: 5</code></td><td>Ensures pods receive traffic <strong>only when fully ready</strong>.</td></tr></tbody></table>

## **Sample Kubernetes Pod Spec**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: java-app
spec:
  containers:
  - name: my-java-app
    image: my-java-image
    resources:
      requests:
        memory: "1Gi"
        cpu: "500m"
      limits:
        memory: "2Gi"
        cpu: "1"
    env:
      - name: JAVA_OPTS
        value: "-XX:MaxRAMPercentage=75.0 -XX:+UseG1GC -XX:+ExitOnOutOfMemoryError"
```

Our pod has:

* **Memory Request**: `1Gi` (Minimum guaranteed memory)
* **Memory Limit**: `2Gi` (Maximum memory allowed)
* **JVM Option**: `-XX:MaxRAMPercentage=75.0` (JVM will use **75% of available memory**)

<table data-header-hidden data-full-width="true"><thead><tr><th width="189"></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Stage</strong></td><td><strong>Kubernetes Perspective</strong></td><td><strong>JVM Perspective</strong></td></tr><tr><td><strong>Pod Scheduling</strong></td><td>Kubernetes ensures the node has at least <code>1Gi</code> RAM available.</td><td>JVM is not aware of <code>requests</code>, only <code>limits</code>.</td></tr><tr><td><strong>Memory Allocation</strong></td><td>Pod starts with memory between <code>1Gi</code> and <code>2Gi</code>, based on availability.</td><td>JVM calculates max heap as <code>75% of available RAM</code>.</td></tr><tr><td><strong>Heap Calculation</strong></td><td>Pod cannot exceed <code>2Gi</code>. If exceeded, <strong>pod is killed (OOMKilled)</strong>.</td><td>JVM takes <strong>75% of 2Gi</strong>, so <strong>JVM heap max = 1.5Gi</strong>. Remaining <strong>0.5GiB</strong> is used by <strong>JVM metaspace, thread stacks, GC, etc.</strong></td></tr></tbody></table>







