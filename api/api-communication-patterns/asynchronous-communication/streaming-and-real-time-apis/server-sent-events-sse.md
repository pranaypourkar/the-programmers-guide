# Server-Sent Events (SSE)

## About

**Server-Sent Events (SSE)** is a **unidirectional streaming technology** that enables a server to **push continuous updates to the client over a single, long-lived HTTP connection**. Unlike the traditional request-response model, SSE allows the server to send data to the client whenever new information is available, without the client having to request it repeatedly.

* **Protocol Basis:** SSE is built on **HTTP/1.1** and uses the `text/event-stream` MIME type.
* **Direction of Data Flow:**\
  &#xNAN;_&#x53;erver → Client_ only (no client-to-server streaming).
* **Use Cases:**
  * Real-time notifications
  * Social media live feeds
  * Sports score updates
  * Live dashboards & monitoring tools
  * Stock market tickers
* **Why It’s Different from WebSockets:**\
  WebSockets are **bi-directional** (both client and server can push messages at any time). SSE is **simpler**, using plain HTTP, and is **optimized for one-way updates**.
* **How the Client Connects:** Clients typically use the **`EventSource`** API in JavaScript to establish and maintain the connection.

**Example**

```javascript
const source = new EventSource('/events');
source.onmessage = (event) => {
    console.log("Received:", event.data);
};
```

{% hint style="success" %}
#### **When SSE Shines ?**

* **Perfect For:**
  * Live news feeds
  * Stock price tickers
  * Social media notifications
  * Real-time dashboards
  * Multiplayer game state updates (if one-way is enough)
* **Not Ideal For:**
  * Chat apps, multiplayer games with bidirectional comms → WebSockets fit better.
{% endhint %}

## Characteristics

* **Unidirectional Communication**
  * Data flows **only from server to client**.
  * The client cannot send data over the SSE channel (must use a separate HTTP request if needed).
* **Persistent HTTP Connection**
  * Uses **a single long-lived TCP connection**.
  * No repeated handshake like polling or WebSockets — less overhead.
* **Text-Based Event Stream**
  * Data is transmitted in plain UTF-8 text format.
  * Messages follow the `event:` and `data:` format.
  *   Example server output:

      ```
      event: update
      data: {"temperature": 28}

      ```
* **Automatic Reconnection**
  * If the connection drops, browsers automatically try to reconnect after a delay.
  * The server can control reconnection timing via the `retry:` field.
* **Event IDs for Resume**
  * Each event can have an `id:` that the client stores.
  * On reconnect, the client sends the last event ID so the server can resume from where it left off.
* **MIME Type `text/event-stream`**
  * Required for browsers to treat the connection as an SSE stream.
  * Ensures messages are processed as events, not plain text.
* **HTTP/1.1 Friendly**
  * Works over standard HTTP without special upgrades or protocols.
  * Plays well with proxies, firewalls, and load balancers.
* **Lightweight Protocol**
  * No extra framing or complex handshake like WebSockets.
  * Easy to implement server-side with minimal libraries.

## Execution Flow

Here’s the typical lifecycle of an SSE connection:

1. **Client Initiates the Connection**
   * The client uses JavaScript’s `EventSource` API (in browsers) or equivalent libraries in other environments.
   *   Example (Browser):

       ```javascript
       const source = new EventSource('/events');
       ```
   *   This sends a normal **HTTP GET request** to the server with the header:

       ```
       Accept: text/event-stream
       ```
2. **Server Accepts and Opens Event Stream**
   *   The server responds with:

       ```
       Content-Type: text/event-stream
       Cache-Control: no-cache
       Connection: keep-alive
       ```
   * Keeps the connection **open indefinitely** — no `Content-Length` header is sent.
3. **Server Sends Events to Client**
   * Each message follows SSE formatting rules:
     * `data:` → the event payload (can span multiple lines).
     * `event:` → optional custom event name.
     * `id:` → optional unique event ID for resuming after reconnect.
     * Blank line (`\n\n`) indicates the end of an event.
   *   Example:

       ```
       id: 101
       event: news
       data: {"headline": "Breaking News!", "category": "world"}
       ```
4. **Client Receives and Handles Events**
   *   Browser automatically parses the stream and triggers event listeners:

       ```javascript
       source.addEventListener('news', event => {
         console.log('News received:', JSON.parse(event.data));
       });
       ```
5. **Automatic Reconnection (if needed)**
   * If the connection drops, the browser will:
     * Wait the retry interval (`retry:` from the server or default 3s).
     *   Send a new GET request with the header:

         ```
         Last-Event-ID: <last received id>
         ```
     * Server resumes from that event ID.
6. **Closing the Connection**
   *   Client can manually close:

       ```javascript
       source.close();
       ```
   * Or server can terminate by sending normal HTTP close semantics.

## Advantages

SSE offers several unique strengths, especially for **one-way, event-driven data delivery** from server to client:

#### **1. Simple to Implement**

* **No custom protocol handling** - uses plain HTTP, so you don’t need a WebSocket server or extra libraries.
* **Example:**
  * Server: just keep an HTTP connection open and write `text/event-stream` data.
  * Client: use the built-in `EventSource` API (supported in all modern browsers except IE).
* **Benefit:** Quick setup with minimal boilerplate compared to WebSockets.

#### **2. Lightweight and Low Overhead**

* **One-way only** (server → client), so no extra complexity for handling bidirectional channels.
* Fewer TCP connections and smaller headers than repeated HTTP polling.
* **Benefit:** Lower bandwidth and CPU usage for high-frequency event streams.

#### **3. Automatic Reconnection & Resume Support**

* **Built-in reconnect** — browsers automatically retry if the connection drops.
* `id:` field lets the client resume from the last missed event after reconnection.
* **Benefit:** More resilient than raw WebSockets without custom heartbeat logic.

#### **4. Works Seamlessly with Existing HTTP Infrastructure**

* SSE works over:
  * Standard HTTP/HTTPS ports (80/443)
  * Existing HTTP proxies, caches, and load balancers
* No firewall or reverse-proxy configuration headaches common with WebSockets.
* **Benefit:** Easier deployment in enterprise and cloud environments.

#### **5. Native Support for Event Streams**

* Events can have:
  * **Custom event names** (`event: news`)
  * **Retry intervals** (`retry: 10000`)
  * **Multi-line data support**
* **Benefit:** More semantic than sending plain text or JSON blobs over WebSockets.

#### **6. More Efficient than Polling**

* Unlike client polling:
  * No need for periodic requests.
  * Server pushes updates **only when there’s new data**.
* **Benefit:** Better real-time feel with less network waste.

## Limitations

While SSE is excellent for **lightweight, one-way streaming**, it comes with inherent trade-offs that make it unsuitable for certain scenarios.

#### **1. One-Way Communication Only**

* SSE only allows **server → client** communication.
* **Limitation:** If the client also needs to send frequent updates to the server, SSE alone isn’t enough — you’d need:
  * Regular AJAX/Fetch requests, or
  * A separate WebSocket channel.
* **Example:** A chat application would require two-way communication, making WebSockets more suitable.

#### **2. Limited Browser Support**

* Not supported in **Internet Explorer** and some older browsers.
* Polyfills exist, but they remove the “native” advantage.
* **Impact:** Requires fallback mechanisms for certain enterprise environments.

#### **3. Scaling Challenges**

* Each client connection remains **open for the entire session**.
* Large-scale connections (e.g., tens of thousands of clients) require careful server tuning:
  * OS-level file descriptor limits
  * Connection keep-alive settings
  * Potential need for reverse-proxy buffering adjustments
* **Impact:** Can lead to higher memory usage compared to short-lived HTTP requests.

#### **4. Payload Format Restriction**

* SSE only supports **UTF-8 text data** natively.
* **Binary data** must be:
  * Base64-encoded, or
  * Sent over a different channel.
* **Impact:** This adds overhead if your stream includes images, audio, or other binary blobs.

#### **5. Connection Limits in Browsers**

* Browsers limit the number of **simultaneous open HTTP connections** per domain (usually 6).
* If SSE connections are long-lived, it can block other HTTP requests to the same server.
* **Impact:** Could affect performance if the app makes many parallel requests.

#### **6. Not as Flexible as WebSockets**

* WebSockets allow custom subprotocols and binary framing.
* SSE is strictly **HTTP text-based streaming**.
* **Impact:** Less control for applications that need mixed content types or high-frequency two-way messaging.

#### **7. Proxy and Intermediary Behavior**

* Some proxies may:
  * Buffer SSE data, delaying delivery
  * Close idle connections despite keep-alives
* **Impact:** Real-time performance can degrade if infrastructure isn’t SSE-friendly.

## Common Technologies & Protocols Used

While SSE is part of the **HTML5 standard** and supported natively in most modern browsers, successful adoption often involves pairing it with reliable backend frameworks, libraries, and infrastructure optimizations.

#### **1. Native Browser API: `EventSource`**

* All major browsers (except Internet Explorer) provide the **`EventSource`** interface for SSE.
*   **Basic Usage:**

    ```javascript
    const evtSource = new EventSource("/stream");
    evtSource.onmessage = (event) => {
        console.log("Message from server:", event.data);
    };
    ```
* Handles:
  * Automatic reconnection
  * Last Event ID handling
  * UTF-8 decoding
* **Benefit:** No external library needed on the client side.

#### **2. Server-Side Implementations**

SSE works over standard **HTTP/1.1 or HTTP/2** connections. Many backend frameworks offer built-in support:

**Java / Spring Boot**

* Using **`SseEmitter`** or **Spring WebFlux Flux**.
*   Example:

    ```java
    @GetMapping("/stream")
    public SseEmitter streamEvents() {
        SseEmitter emitter = new SseEmitter();
        executorService.execute(() -> {
            try {
                emitter.send(SseEmitter.event().data("Hello!"));
                emitter.complete();
            } catch (IOException e) {
                emitter.completeWithError(e);
            }
        });
        return emitter;
    }
    ```

**Node.js**

*   Common with **Express.js**:

    ```javascript
    app.get("/stream", (req, res) => {
        res.setHeader("Content-Type", "text/event-stream");
        res.setHeader("Cache-Control", "no-cache");
        res.write(`data: ${JSON.stringify({ msg: "Hello" })}\n\n`);
    });
    ```

**Python**

* Flask + `flask_sse` or raw WSGI streaming.
* Django Channels for async SSE.

**Go**

*   Using native HTTP streaming with:

    ```go
    w.Header().Set("Content-Type", "text/event-stream")
    fmt.Fprintf(w, "data: %s\n\n", "Hello SSE")
    ```

#### **3. Infrastructure Considerations**

* **Nginx / Apache / Caddy**: Must be configured for streaming and disabling buffering.
  *   Nginx example:

      ```nginx
      location /stream {
          proxy_pass http://backend;
          proxy_http_version 1.1;
          proxy_set_header Connection '';
          proxy_buffering off;
      }
      ```
* **CDN Support**: Some CDNs (like Cloudflare) may buffer SSE unless explicitly configured.

#### **4. Popular Libraries & Tools**

* **Frontend**
  * Native `EventSource`
  * `eventsource` npm package for Node.js clients
* **Backend**
  * Spring Boot (`SseEmitter`)
  * Express.js raw HTTP streaming
  * `fastapi-sse` for Python
* **Testing**
  *   `curl` for quick checks:

      ```bash
      curl -N http://localhost:8080/stream
      ```

#### **5. Protocol Specifications**

* **RFC 6202** – Defines best practices for server-sent event delivery.
* **MIME Type**: `text/event-stream`
* **Encoding**: UTF-8 only
