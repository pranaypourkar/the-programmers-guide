# Client Polling

## About

**Client Polling** is a communication pattern where a client **repeatedly sends requests** to a server at fixed intervals (or under certain conditions) to check whether new data or state changes are available. Instead of the server pushing updates as they happen, the client takes the initiative to ask, “Do you have anything new for me?”

While often associated with **asynchronous data updates**, polling itself operates in a **synchronous request–response manner** - each poll is a standard HTTP or API call, and the client **waits for a response** before deciding whether to act on it. The _asynchronous_ nature lies only in the fact that updates may not be immediately available, leading to repeated requests over time.

## Characteristics

Client Polling has several distinct traits that make it easy to implement but also potentially inefficient if misused.

#### 1. **Fixed or Dynamic Polling Intervals**

* **Fixed Interval**: The client polls at a constant time gap (e.g., every 10 seconds).
* **Dynamic Interval**: The polling frequency changes based on conditions (e.g., slow polling when idle, fast polling after detecting a near-complete process).

**Example**:

* Fixed: A dashboard fetching metrics every 15 seconds.
* Dynamic: An order-tracking app polling every 30 seconds until “Shipped,” then every 5 seconds until “Delivered.”

#### 2. **Stateless Interactions**

* Each polling request is **independent** of previous ones.
* The server does not need to maintain a long-lived connection or memory of past polls (beyond normal request handling).

#### 3. **Synchronous Request–Response Cycle**

* Each poll follows the standard synchronous model:
  1. Client sends request.
  2. Server processes and sends response.
  3. Client waits until the response is received before sending the next poll.

#### 4. **Increased Network Overhead**

* Frequent polling increases request volume, consuming **more bandwidth and server resources**, especially if most polls return “no new data.”

#### 5. **Latency Trade-offs**

* Shorter intervals → Lower latency (faster updates) but higher network load.
* Longer intervals → Reduced load but higher latency (slower updates).

#### 6. **Fallback Mechanism for Real-Time Features**

* Often used as a **backup** when WebSockets, Server-Sent Events (SSE), or Push APIs are not available due to network restrictions or client limitations.

## Execution Flow

Client Polling follows a repetitive **check-for-updates** cycle between the client and the server.\
While the underlying HTTP requests are short-lived, the polling logic creates a continuous feedback loop.

#### **1. Client Initializes the Polling Mechanism**

* The application (browser, mobile app, or service) starts a timer or scheduler to send periodic requests.
* The interval is determined by application needs or configuration (e.g., `setInterval()` in JavaScript, `ScheduledExecutorService` in Java).

#### **2. Client Sends a Polling Request**

* At each interval, the client sends an HTTP request to the server.
* The request typically includes:
  * **Authentication** (e.g., OAuth token, API key).
  * **Context** (e.g., last received timestamp or version ID).
  * **Specific resource endpoint** to check for changes.

#### **3. Server Processes the Request**

* The server checks if there is **new data or changes** since the last request.
* Possible outcomes:
  * **New Data Available** → Respond with updated resource data.
  * **No Changes** → Respond with status code `204 No Content` or an empty payload.

#### **4. Client Processes the Response**

* If data is received, the client updates its UI or state accordingly.
* If no data, the client waits until the next scheduled polling interval.

#### **5. Loop Repeats Until Stop Condition**

* Polling continues indefinitely or until:
  * User closes the application.
  * Specific event or status is reached (e.g., “Order Delivered”).
  * The client switches to a different communication pattern (e.g., WebSocket).

#### **Example Flow - Order Tracking App**

1. **T=0s** - Client requests `/orders/123/status`. Server responds: `"Processing"`.
2. **T=10s** - Client requests again. Server responds: `"Shipped"`.
3. **T=20s** - Client requests again. Server responds: `"In Transit"`.
4. **T=30s** - Client requests again. Server responds: `"Delivered"`.
5. **Stop** - Polling ends as the final state is reached.

## Advantages

Although often seen as a less efficient communication method compared to push-based or streaming patterns, **Client Polling** still offers distinct benefits in certain scenarios.

#### **1. Simplicity of Implementation**

* **Minimal Infrastructure Changes** - Works with any standard HTTP server; no need for WebSockets, message brokers, or streaming protocols.
* **Easy to Implement in Clients** - Can be done with built-in timers (`setInterval`, cron jobs, scheduled tasks) and standard HTTP libraries.
*   **Example:**

    ```javascript
    setInterval(() => {
        fetch('/orders/123/status')
          .then(res => res.json())
          .then(console.log);
    }, 10000); // poll every 10s
    ```

#### **2. Works Across Firewalls and Proxies**

* **Standard HTTP(S) Traffic** - Since polling uses basic HTTP GET/POST requests, it passes easily through enterprise firewalls and NAT configurations.
* **No Persistent Connections Needed** - Reduces complications with proxy timeouts or keep-alive issues.

#### **3. Predictable Resource Usage**

* **Controlled Load** - The frequency of polling is explicitly configured (e.g., once every 5 seconds).
* **No Sudden Spikes** - Unlike event-driven systems where high event frequency can overwhelm the client, polling requests are evenly spaced.

#### **4. Client-Controlled Timing**

* The client decides **when** and **how often** to check for updates.
* Can dynamically adjust polling frequency based on:
  * User activity (active → poll frequently; idle → poll rarely).
  * System load (reduce polling rate during peak hours).

#### **5. No Need for Real-Time Infrastructure**

* If updates are infrequent or delayed processing is acceptable, polling avoids the cost and complexity of implementing **real-time push mechanisms**.

#### **6. Reliable Fallback Strategy**

* Polling serves as a **backup mechanism** when push channels fail.
* Many production systems implement **WebSocket → Polling** failover.
  * Example: Slack or Gmail fall back to polling if real-time connections are dropped.

#### **7. Easy Debugging and Testing**

* Polling is easier to monitor and debug since every request is an independent HTTP transaction that can be inspected with common tools (Postman, curl, browser DevTools).

## Limitations

While **Client Polling** is conceptually simple, it comes with significant trade-offs that make it unsuitable for certain use cases, especially those requiring real-time responsiveness or large-scale efficiency.

#### **1. Wasted Network Requests**

* **Inefficient Data Retrieval** - Polling sends requests at fixed intervals regardless of whether new data exists.
* **Example:** If polling every 5 seconds but updates only occur once every 5 minutes, **59 out of 60 requests return unchanged data**.
* This wastes **bandwidth**, increases **server load**, and can add **unnecessary cloud costs**.

#### **2. Increased Latency for Fresh Data**

* Polling is **not truly real-time**; the freshness of data depends on the polling interval.
* Example: If polling every 10 seconds, the **average delay** for new data is \~5 seconds.
* Reducing the interval improves freshness but **amplifies network and processing overhead**.

#### **3. Scalability Challenges**

* High-frequency polling from many clients can overwhelm servers.
* **Scenario:** 10,000 clients polling every second → 10,000 requests/sec even if no data changes.
* This leads to unnecessary **CPU cycles**, **database queries**, and potential **throttling**.

#### **4. Poor for Event-Heavy Workloads**

* Polling is inherently **pull-based**, so events between polling cycles may be **delayed** or even **missed** if the backend overwrites states quickly.
* Real-time systems (e.g., chat apps, live sports scores) perform poorly under polling compared to WebSockets or SSE.

#### **5. Higher Energy Consumption for Mobile Devices**

* Frequent polling **prevents aggressive power-saving modes** on mobile devices.
* Impacts **battery life** and **cellular data usage**, making it a poor choice for mobile-first applications.

#### **6. Inefficient Resource Utilization**

* Polling forces the backend to repeatedly process identical queries.
* Leads to **cache thrashing** and unnecessary **database I/O**.
* Even with caching, the HTTP request/response overhead remains.

#### **7. Network and API Rate Limits**

* Cloud API providers often impose **rate limits** (e.g., 60 requests/min per API key).
* Aggressive polling can quickly exhaust quotas, leading to **429 Too Many Requests** errors or temporary bans.

#### **8. Limited Event Granularity**

* Polling typically only retrieves the **latest state**, not the **event history**.
* Example: In a stock ticker app, polling may skip transient spikes if the value changes back before the next poll.

#### **9. Not Ideal for Highly Dynamic Data**

* For systems where updates occur multiple times per second, polling cannot keep up without introducing massive overhead.
* Example: Multiplayer games, collaborative editing, or real-time analytics dashboards.
