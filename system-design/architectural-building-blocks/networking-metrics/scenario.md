# Scenario

## Example

### **Water Pipe Analogy**&#x20;

Imagine you have a **water pipe** that carries water from a tank (sender) to a bucket (receiver).

* **Latency**  → The time it takes for the first drop of water to reach the bucket once the tap is turned on.
* **Bandwidth**  → The maximum amount of water the pipe **can** carry per second (pipe width).
* **Throughput**  → The **actual** amount of water flowing through the pipe at any given time, considering real-world inefficiencies.

#### **Ways to Change Performance:**

1️. **Making the Pipe Wider (Increasing Bandwidth)**

* More water **can** flow through at the same time.
* This does **not** reduce the time taken for the first drop to arrive (latency remains the same).

2️. **Using a Shorter Pipe (Reducing Latency)**

* Water takes less time to reach the bucket.
* Bandwidth and throughput stay the same unless other factors are changed.

3️. **Increasing Water Pressure (Increasing Speed)**

* Water reaches the bucket **faster**, reducing latency.
* More water can also flow through at a higher rate, increasing **throughput**.

4️. **Leaks and Blockages (Network Congestion & Packet Loss)**

* If there are **leaks** (packet loss) or **blockages** (network congestion), **throughput** is reduced even if bandwidth is high.

{% hint style="success" %}
- A **wider pipe** increases **bandwidth** but doesn’t change **latency**.
- A **shorter pipe** reduces **latency** but doesn’t change **bandwidth**.
- **Faster water flow** reduces **latency** and increases **throughput**.
- **Blockages and leaks** reduce **throughput** below the available **bandwidt**
{% endhint %}

### Web Page Load Time

Assume a web page request travels **4000 km** via fiber optic cable, passing through **3 routers**, with a **1 MB** page size on a **100 Mbps** connection.

<table><thead><tr><th width="462">Delay Type</th><th>Value</th></tr></thead><tbody><tr><td>Transmission Delay</td><td><strong>80 ms</strong></td></tr><tr><td>Propagation Delay</td><td><strong>20 ms</strong></td></tr><tr><td>Processing Delay</td><td><strong>5 ms × 3 routers = 15 ms</strong></td></tr><tr><td>Queuing Delay</td><td><strong>10 ms</strong></td></tr><tr><td><strong>Total Latency</strong></td><td><strong>125 ms</strong></td></tr></tbody></table>
