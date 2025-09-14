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

## DataBufferLimitException – "Exceeded limit on max bytes to buffer"
