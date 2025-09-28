# Common Issues

## About

As with any production system, building reactive applications using **Spring WebFlux** often surfaces unexpected runtime issues.\
These problems may arise due to:

* The **reactive programming model** itself (e.g., misuse of `block()`)
* **Spring WebFlux defaults** (e.g., buffer sizes, codecs, timeouts)
* **Integration challenges** with external APIs (large payloads, streaming, backpressure)
* **Deployment/runtime environment** constraints (e.g., Netty, memory limits, thread model)

The goal of this section is to document:

1. **Common errors** encountered in real-world WebFlux projects
2. **Typical scenarios** where they occur
3. **Observed behavior** (what developers or users see)
4. **Root cause** (technical explanation of why it happens)
5. **Resolutions & best practices** to handle them

## Issue 1

#### DataBufferLimitException – "Exceeded limit on max bytes to buffer"

#### Problem

In Spring WebFlux applications, while calling external APIs or handling large request/response bodies, you might encounter the following runtime exception:

```
org.springframework.core.io.buffer.DataBufferLimitException: Exceeded limit on max bytes to buffer : 1048576
	at org.springframework.core.io.buffer.LimitedDataBufferList.raiseLimitException(LimitedDataBufferList.java:99)
	at org.springframework.core.io.buffer.LimitedDataBufferList.updateCount(LimitedDataBufferList.java:92)
	at org.springframework.core.io.buffer.LimitedDataBufferList.add(LimitedDataBufferList.java:58)
	at reactor.core.publisher.MonoCollect$CollectSubscriber.onNext(MonoCollect.java:103)
	at reactor.core.publisher.FluxMap$MapSubscriber.onNext(FluxMap.java:122)
	at reactor.core.publisher.FluxPeek$PeekSubscriber.onNext(FluxPeek.java:200)
	at reactor.core.publisher.FluxMap$MapSubscriber.onNext(FluxMap.java:122)
	at reactor.netty.channel.FluxReceive.onInboundNext(FluxReceive.java:377)
	at reactor.netty.channel.ChannelOperations.onInboundNext(ChannelOperations.java:435)
	at reactor.netty.http.server.HttpServerOperations.onInboundNext(HttpServerOperations.java:803)
	at reactor.netty.channel.ChannelOperationsHandler.channelRead(ChannelOperationsHandler.java:115)
```

**Symptoms**

* The request or response is **not processed** and fails immediately.
* Logs show a `DataBufferLimitException`.
* Typically occurs when handling **payloads larger than \~1MB** (default Spring buffer limit).

**Scenario Example**

```java
String response = webClient.post()
    .uri("/soap-endpoint")
    .bodyValue(requestPayload)
    .retrieve()
    .bodyToMono(String.class)   // buffers entire response in memory
    .block();
```

If the SOAP service returns a payload of **1.5MB**, the exception is thrown before the `Mono` can emit a value.

#### **Root Cause**

* Spring WebFlux **buffers request/response bodies in memory** before mapping them to objects.
* By default, the **maximum in-memory buffer size** is **1MB (1048576 bytes)**.
* Any payload exceeding this limit triggers `DataBufferLimitException`.
* The exception originates in `LimitedDataBufferList` inside Spring’s reactive codecs.

Key points

* It’s a **Spring WebFlux limitation**, not a Project Reactor problem.
* `WebClient` or `@RequestBody` handling triggers buffering.
* Large payloads must either **increase buffer** or **stream** to avoid memory errors.

#### **Solution**

**1. Increase Maximum In-Memory Buffer (Quick Fix)**

In `application.yml`:

```yaml
spring:
  codec:
    max-in-memory-size: 2MB
```

Or in `application.properties`:

```properties
spring.codec.max-in-memory-size=2MB
```

Programmatically for a specific `WebClient`:

```java
WebClient.builder()
    .codecs(configurer -> 
        configurer.defaultCodecs().maxInMemorySize(2 * 1024 * 1024)) // 2MB
    .build();
```

**2. Use Streaming for Large Payloads (Recommended)**

Instead of buffering the entire response:

```java
Flux<DataBuffer> responseFlux = webClient.post()
    .uri("/soap-endpoint")
    .bodyValue(requestPayload)
    .retrieve()
    .bodyToFlux(DataBuffer.class); // stream response chunk by chunk
```

Or use:

```java
BodyExtractors.toDataBuffers()
```

to process large payloads incrementally.
