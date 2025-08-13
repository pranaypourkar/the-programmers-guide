# WebSockets

## About

**WebSockets** is a full-duplex, bidirectional communication protocol that operates over a single, long-lived TCP connection. Unlike traditional HTTP, where the client must initiate every request, WebSockets allow **both the client and server to send data at any time**, enabling real-time, low-latency communication.

It is standardized under **RFC 6455** and was designed to overcome the limitations of HTTP polling, long-polling, and other “workarounds” that tried to simulate real-time behavior over a request–response protocol.

### **How WebSockets Differ from HTTP ?**

* **Connection Lifecycle**\
  &#xNAN;_&#x48;TTP_: A new TCP connection is created for each request/response cycle (or reused via keep-alive).\
  &#xNAN;_&#x57;ebSocket_: A single TCP connection is established and remains open until explicitly closed.
* **Communication Direction**\
  &#xNAN;_&#x48;TTP_: Unidirectional - server responds only when the client requests.\
  &#xNAN;_&#x57;ebSocket_: Bidirectional - either side can send a message at any moment.
* **Protocol Upgrade**\
  &#xNAN;_&#x57;ebSockets_ start as an HTTP request using the `Upgrade` header and then switch the connection to the WebSocket protocol.

### **Use Cases**

* **Real-time dashboards** (stock tickers, IoT monitoring, sports scores)
* **Chat/messaging applications** (WhatsApp Web, Slack)
* **Online multiplayer games**
* **Collaborative applications** (Google Docs-like editors, whiteboards)
* **Live streaming of telemetry or analytics data**

### **Why WebSockets Matter ?**

* Eliminates the inefficiency of repeated HTTP requests in polling.
* Reduces latency to milliseconds for instant updates.
* Enables event-driven architectures where servers push updates proactively.
* Supports rich, interactive user experiences in web and mobile apps.

## Characteristics

#### **1. Full-Duplex Communication**

WebSockets enable both the client and server to send and receive messages at any time, independently of one another.

* **Contrast with HTTP:** In HTTP, the client sends a request, and the server responds - communication is strictly request-response and half-duplex.
* **In WebSockets:** Once the connection is established, the server can proactively push data to the client without being asked. This is ideal for use cases like stock market tickers, multiplayer games, and live notifications where data changes frequently and unpredictably.
* **Example:** In a chat application, the server can send a new message to the client as soon as another user sends it, without the client polling or re-requesting updates.

#### **2. Single Persistent TCP Connection**

After the handshake, WebSockets use the same TCP connection for the entire communication session.

* **Benefits:**
  * No repeated TCP 3-way handshakes.
  * No HTTP request/response headers for every message.
  * Dramatic reduction in network chatter.
* **Impact:** This persistence makes WebSockets much faster and more scalable for high-frequency data transfer scenarios.
* **Note:** The persistent connection also means the server must handle many open sockets simultaneously, which has implications for resource management and scaling.

#### **3. Lightweight Message Frames**

WebSocket messages are transmitted in compact binary frames with minimal metadata, unlike HTTP requests that carry full headers and cookies for each call.

* **Structure:** Each WebSocket frame has a small header (2–14 bytes) compared to the hundreds of bytes typical in HTTP headers.
* **Impact:** This efficiency makes WebSockets suitable for rapid, high-volume messaging such as financial market data or live telemetry feeds.

#### **4. Protocol Upgrade from HTTP**

WebSockets are not a completely separate protocol from the start - they leverage HTTP for the handshake.

* **Process:**
  * The client sends an HTTP `GET` request with `Upgrade: websocket` and `Connection: Upgrade` headers.
  * If the server supports WebSockets, it responds with `101 Switching Protocols`.
  * The connection then switches from HTTP to WebSocket protocol over the same TCP connection.
* **Benefit:** This makes WebSockets firewall- and proxy-friendly since they begin as regular HTTP traffic.

#### **5. Cross-Origin Communication Support**

Unlike traditional AJAX requests that are tightly bound by the browser's same-origin policy, WebSockets can connect to different domains as long as the server explicitly allows it.

* **Security:** This is controlled by the server handshake, where it can choose to accept or reject cross-origin requests.
* **Practical Use:** Useful for real-time dashboards that aggregate data from multiple APIs hosted on different domains.

#### **6. Stateful Connection**

Once the WebSocket connection is open, the server can retain the context of the session.

* **Example:** Authentication tokens can be exchanged once at connection start, and subsequent messages don’t need to carry them repeatedly.
* **Impact:** Reduces redundancy in message payloads and improves throughput.
* **Caution:** Servers must have a strategy for handling dropped connections and restoring state after reconnection.

#### **7. Binary and Text Data Support**

WebSockets can handle both UTF-8 encoded text messages and binary frames.

* **Binary frames:** Ideal for sending compressed data, multimedia content, or even custom protocol messages.
* **Benefit:** Enables efficient transmission without base64 encoding, which would increase payload size.

#### **8. Low Latency and Real-Time Capabilities**

Because there’s no handshake or header exchange for each message, latency is extremely low.

* **Measured Latency:** Often in the range of a few milliseconds after the connection is established.
* **Use Cases:** Real-time financial transactions, online multiplayer games, collaborative document editing, IoT device monitoring.

## Execution Flow

#### **1. Connection Initiation (Handshake Phase)**

The WebSocket protocol starts as an HTTP(S) request to ensure compatibility with existing infrastructure like firewalls and proxies.

1. **Client Sends HTTP Upgrade Request:**
   *   Example headers:

       ```
       GET /chat HTTP/1.1
       Host: example.com
       Upgrade: websocket
       Connection: Upgrade
       Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
       Sec-WebSocket-Version: 13
       ```
   * **Purpose:** The `Upgrade: websocket` and `Connection: Upgrade` headers signal the client’s intention to switch protocols.
2. **Server Responds with Protocol Switch:**
   *   If the server supports WebSockets, it replies with:

       ```
       HTTP/1.1 101 Switching Protocols
       Upgrade: websocket
       Connection: Upgrade
       Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
       ```
   * **Result:** TCP connection is now upgraded from HTTP to WebSocket protocol.

#### **2. Data Transmission Phase**

Once the handshake completes, both client and server can send messages at any time. This is the **full-duplex** stage.

* **Message Types:**
  * **Text Frames:** UTF-8 encoded strings.
  * **Binary Frames:** For compact data such as compressed JSON, images, or custom formats.
  * **Control Frames:** For ping/pong (keep-alive) and close operations.
* **Frame Structure:**
  * Minimal overhead (2–14 bytes header).
  * Includes an opcode (type of message), payload length, masking key (client-to-server messages are masked), and the actual data.
* **Flow Example:**
  1. Client sends a chat message frame: `"Hello, world!"`.
  2. Server sends a frame with `"Hello back!"`.
  3. Messages can be interleaved - no need to wait for replies.

#### **3. Keep-Alive Mechanism**

To prevent idle connections from being dropped by intermediaries (e.g., NAT routers, proxies), WebSockets use **ping/pong frames**:

* **Client or server** sends a **ping**.
* The other side **must reply with a pong**.
* This confirms the connection is alive and responsive.

#### **4. Error Handling and Recovery**

During communication, issues like partial frames, network failures, or protocol violations may occur.

* **Close Frame with Error Code:** Sent before termination to explain the reason.
* **Reconnection Strategy:** The client application often includes retry logic (e.g., exponential backoff) to reconnect after failures.

#### **5. Connection Termination Phase**

Either the client or the server can close the WebSocket connection:

1. **Close Frame Sent:** Contains an optional status code and reason.
2. **Acknowledgement:** The other side responds with its own close frame.
3. **TCP Connection Closed:** Graceful shutdown of the underlying socket.

#### **Note**

* After handshake, **no more HTTP headers** are sent.
* All communication happens via compact WebSocket frames.
* **Security:**
  * `wss://` (WebSocket Secure) uses TLS for encryption.
  * Prevents MITM attacks and protects sensitive data.

## **Advantages**

#### **1. True Full-Duplex Communication**

* **What it means:**\
  Unlike HTTP request–response, WebSockets allow both client and server to send data independently, without waiting for the other to finish.
* **Why it matters:**
  * Ideal for chat systems, multiplayer games, collaborative editing (e.g., Google Docs).
  * Reduces perceived latency since updates are pushed instantly rather than polled.
* **Example:**\
  In a stock price monitoring app, the server can push price changes the moment they occur without waiting for the client to “ask” for updates.

#### **2. Reduced Network Overhead**

* **What it means:**\
  After the handshake, communication happens over lightweight binary frames - no repeated HTTP headers, cookies, or full request metadata.
* **Why it matters:**
  * Significant bandwidth savings for high-frequency updates.
  * Lower CPU usage on both client and server since parsing overhead is minimal.
* **Example:**\
  For a real-time dashboard updating every second, WebSocket traffic might be **90% smaller** than equivalent REST polling traffic.

#### **3. Lower Latency for Real-Time Apps**

* **What it means:**\
  Data is sent immediately when it’s available - no polling delays.
* **Why it matters:**
  * In WebSockets, the "time to first byte" after an event is almost just network transmission time.
  * In polling-based systems, latency = polling interval + processing time.
* **Example:**\
  Multiplayer online games use WebSockets to synchronize player positions in milliseconds.

#### **4. Bi-Directional Event Propagation**

* **What it means:**\
  Both parties can initiate messages - useful for distributed workflows.
* **Why it matters:**
  * Allows **real-time server control** (e.g., server can send "shutdown soon" events).
  * Enables **client-driven updates** without waiting for HTTP request cycles.
* **Example:**\
  A collaborative whiteboard where drawing strokes from one user are sent to others instantly.

#### **5. Supports Both Text and Binary Data**

* **What it means:**\
  WebSockets can transmit UTF-8 text or raw binary payloads without additional encoding layers.
* **Why it matters:**
  * Binary frames reduce payload size for structured data like Protocol Buffers or compressed JSON.
  * No need for Base64 encoding (common in HTTP APIs), which bloats payload by \~33%.
* **Example:**\
  Video streaming applications can send chunks as binary frames directly.

#### **6. Works Well Over Firewalls and Proxies**

* **What it means:**\
  WebSockets start with an HTTP(S) handshake, making them firewall-friendly.
* **Why it matters:**
  * No need for custom ports or complex NAT traversal.
  * Works in environments where direct TCP sockets would be blocked.
* **Example:**\
  Corporate networks that block raw TCP still often allow `wss://` WebSocket connections.

#### **7. Extensible Protocol**

* **What it means:**\
  Supports subprotocols to define application-specific semantics (e.g., STOMP, MQTT over WebSockets).
* **Why it matters:**
  * We can implement standardized messaging formats without reinventing framing logic.
  * Easy to integrate with message brokers or IoT systems.
* **Example:**\
  STOMP over WebSockets in a Spring Boot + ActiveMQ setup for real-time messaging.

#### **8. Cross-Platform Support**

* **What it means:**\
  Native APIs in modern browsers (`WebSocket` API), Node.js, Python, Java, Go, etc.
* **Why it matters:**
  * No special plugins needed.
  * Unified protocol for web, mobile, and desktop applications.
* **Example:**\
  A trading platform can reuse the same WebSocket backend for both web and mobile apps.

## **Limitations**

#### **1. Persistent Connection Overhead**

* **What it means:**\
  WebSockets keep the TCP (or TLS) connection open for the entire session.
* **Why it matters:**
  * Each connection consumes memory (socket buffers) and file descriptors on the server.
  * Scaling to millions of concurrent connections requires careful infrastructure planning.
* **Example:**\
  A chat app with 1 million active users would need specialized load balancers and servers optimized for long-lived connections.

#### **2. Server Resource Management**

* **What it means:**\
  Unlike HTTP request–response, where connections are short-lived, WebSockets need servers to maintain state about each connection.
* **Why it matters:**
  * Higher RAM usage.
  * Requires event-driven, non-blocking servers (e.g., Netty, Node.js) to avoid thread exhaustion.
* **Example:**\
  Using traditional blocking thread-per-connection servers for WebSockets would quickly max out threads.

#### **3. Connection Reliability Issues**

* **What it means:**\
  If a WebSocket connection drops (network blip, server restart), clients need reconnection logic.
* **Why it matters:**
  * Requires heartbeat/ping-pong messages to detect broken connections.
  * No built-in automatic reconnection in the WebSocket protocol itself - must be implemented in application code.
* **Example:**\
  Mobile users switching from Wi-Fi to 4G often cause silent connection drops unless we actively monitor pings.

#### **4. Proxy and Load Balancer Timeouts**

* **What it means:**\
  Some proxies or load balancers close idle connections after a set timeout (e.g., 60 seconds).
* **Why it matters:**
  * Need to send periodic keep-alive messages to keep the connection open.
  * Must configure infrastructure to support long-lived TCP sessions.
* **Example:**\
  AWS ALB defaults to 60s idle timeout; without tuning, WebSocket connections may unexpectedly close.

#### **5. Security Considerations**

* **What it means:**\
  WebSockets bypass much of HTTP’s request–response security model.
* **Why it matters:**
  * Must handle authentication/authorization at connection time _and_ per message.
  * Susceptible to CSRF-like attacks if not scoped to origin.
  * Messages aren’t inspected by traditional HTTP security tools unless integrated with WS-aware middleware.
* **Example:**\
  A WebSocket server accepting messages without per-message auth could allow unauthorized data injections.

#### **6. Not Ideal for Low-Frequency Updates**

* **What it means:**\
  Maintaining a persistent connection just for rare updates wastes resources.
* **Why it matters:**
  * Better to use short-lived mechanisms (e.g., HTTP long polling, SSE) for infrequent events.
  * Idle connections still consume server capacity.
* **Example:**\
  A weather app updating every 10 minutes doesn’t need a full WebSocket session.

#### **7. More Complex Debugging**

* **What it means:**\
  Traffic is not easily readable as plain HTTP logs.
* **Why it matters:**
  * Requires special tools or browser dev tools to inspect frames.
  * Harder to trace compared to stateless REST requests.
* **Example:**\
  Debugging a binary WebSocket protocol often involves writing custom message decoders.

#### **8. Limited Native HTTP/REST Integration**

* **What it means:**\
  WebSockets are a separate protocol after the handshake - they don’t inherently support HTTP verbs, caching, or REST semantics.
* **Why it matters:**
  * Can’t use HTTP middleware (e.g., caching proxies) without protocol translation.
  * Makes integration with purely RESTful systems more complex.
* **Example:**\
  An API gateway handling REST routes might require a separate WebSocket route handler.

## **Common Technologies & Protocols Used**

#### **1. Core Protocol**

* **RFC 6455 – The WebSocket Protocol**
  * Defines the handshake mechanism to upgrade from HTTP(S) to WebSocket (`ws://` or `wss://`).
  * Supports both **text** and **binary** frames.
  * Works over TCP, optionally secured with TLS (`wss`).
* **Subprotocols**
  * Optional higher-level protocols negotiated at handshake.
  * Examples: `graphql-ws` (GraphQL over WebSockets), `mqtt` (IoT messaging).

#### **2. Server-Side Frameworks & Libraries**

* **Java**
  * **Spring WebSocket** (integrates with STOMP for pub-sub messaging).
  * **Netty** – event-driven networking framework, highly scalable.
  * **Undertow** / **Jetty** – lightweight, non-blocking servlet containers with WebSocket support.
* **Node.js**
  * **ws** – lightweight WebSocket library.
  * **Socket.IO** – adds auto-reconnect, event-based messaging, and fallbacks (long polling).
* **Python**
  * **websockets** – asyncio-based WebSocket implementation.
  * **FastAPI** – built-in WebSocket support.
* **Go**
  * **Gorilla WebSocket** – widely used, stable Go WebSocket library.
  * **nhooyr/websocket** – minimal and idiomatic.

#### **3. Messaging Protocols Over WebSockets**

* **STOMP (Simple Text Oriented Messaging Protocol)**
  * Text-based, frame-oriented protocol for pub-sub messaging.
  * Works well with message brokers like ActiveMQ, RabbitMQ.
* **MQTT over WebSockets**
  * Lightweight IoT protocol, often tunneled via WebSockets to bypass firewalls.
* **WAMP (Web Application Messaging Protocol)**
  * Supports RPC and pub-sub over WebSockets.

#### **4. Client-Side Implementations**

* **Browser APIs**
  * `WebSocket` constructor in JavaScript (`new WebSocket("wss://example.com/socket")`).
  * Event listeners for `onopen`, `onmessage`, `onclose`, `onerror`.
* **Mobile**
  * iOS: `URLSessionWebSocketTask`.
  * Android: `okhttp-ws` or native `WebSocket` libraries.
* **Desktop**
  * Libraries for .NET (`System.Net.WebSockets`), Java, and C++.

#### **5. Infrastructure & Gateway Support**

* **API Gateways with WebSocket Support**
  * AWS API Gateway (WebSocket APIs).
  * NGINX (reverse proxy and load balancing for WebSockets).
  * HAProxy (supports WebSocket protocol upgrade).
* **CDN/WebSocket Optimization**
  * Cloudflare supports `ws` and `wss` proxying with automatic scaling.
  * Azure Front Door / AWS CloudFront – limited WebSocket support.

#### **6. Testing & Debugging Tools**

* **Browser DevTools** – inspect frames in the Network tab.
* **wscat** – CLI WebSocket client.
* **Postman** – now supports WebSocket testing.
* **Wireshark** – can decode WebSocket frames.

#### **7. Protocol Extensions**

* **Per-Message Compression Extension (PMCE)** – reduces bandwidth for text/binary payloads.
* **Multiplexing (experimental)** – multiple streams over a single WebSocket connection.
