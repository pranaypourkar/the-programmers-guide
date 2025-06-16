# Project Reactor

Project Reactor is the foundation for reactive programming within the Spring framework ecosystem. It's a comprehensive, non-blocking library that adheres to the Reactive Streams specification. Here's a breakdown of its role in Spring and its key features:

### **Role in Spring**

* **Core Library:** Project Reactor provides the building blocks for creating reactive applications in Spring. It's tightly integrated with other Spring libraries like Spring WebFlux and Spring Data, enabling a cohesive reactive programming experience.
* **Non-Blocking Approach:** Project Reactor promotes an asynchronous and non-blocking approach to handling requests and data streams. This improves responsiveness and scalability for Spring applications.

### **Key Features**

* **Data Streams (`Flux` and `Mono`):** It defines two fundamental data types:

\-> `Flux`: Represents a stream of zero or more values emitted over time.

\-> `Mono`: Represents a publisher of zero or one value.

* **Operators:** Project Reactor offers a rich set of operators for manipulating and transforming data streams. These operators enable filtering, mapping, aggregation, and other essential operations in a declarative and composable way.
* **Backpressure Management:** Project Reactor provides mechanisms to manage backpressure. This ensures that data producers don't overwhelm consumers with more data than they can handle, preventing bottlenecks and maintaining smooth data flow.
* **Integration with Spring MVC and WebFlux:** Project Reactor integrates seamlessly with both Spring MVC (traditional synchronous approach) and Spring WebFlux (reactive web framework). This allows to choose the approach that best suits their needs within the same Spring ecosystem.
* **Testing Support:** Project Reactor offers tools for testing reactive applications to ensure the correct behavior of reactive code.



{% hint style="info" %}
Backpressure handling strategies are techniques used to manage situations where a data producer (publisher) generates data faster than a data consumer (subscriber) can process it. Unhandled backpressure can lead to overwhelmed subscribers, dropped data, and system instability.

**Buffering:**

* This strategy involves creating a temporary buffer to store incoming data from the producer. The buffer acts as a holding area until the subscriber can process the data. This allows the producer to continue emitting data even if the subscriber is temporarily overloaded.
* **Advantage:** Absorbs temporary spikes in data flow and prevents data loss.
* **Disadvantage:** Requires managing buffer size to avoid memory exhaustion. Large buffers can also introduce latency.



**Dropping Data:**

* This strategy involves discarding data that the subscriber cannot keep up with. This is a last resort approach when other strategies are not feasible. Dropped data might lead to incomplete information, so it's crucial to understand the impact on your application.
* **Advantage:** Simplest approach, but be aware of potential data loss.
* **Disadvantage:** Can lead to inaccurate results or missed information.



**Latest Item:**

* **Description:** Ensures the subscriber only receives the **latest** emitted item, discarding older ones.
* **Advantage:** Useful when only the most recent data is relevant.
* **Disadvantage:** Older data might be lost



**Error**:&#x20;

* Sometimes, it may be appropriate to signal an error to the publisher if the downstream subscriber cannot keep up with the emission rate. This can indicate a problem with resource management or system performance. Reactor provides operators like `onBackpressureError` for signaling an error in case of backpressure.



**Drop Oldest (Buffer with Overflow Strategy):**

* **Description:** Maintains a buffer to hold incoming data but drops the **oldest items** when the buffer overflows.
* **Advantage:** Absorbs temporary spikes in data flow and avoids data loss for newer items.
* **Disadvantage:** Older data might be dropped, potentially leading to missed information.
{% endhint %}





{% hint style="info" %}
Difference between ProjectReactor.io vs Spring WebFlux?

**Project Reactor** serves as a general-purpose reactive library providing support for asynchronous programming, error handling, backpressure, and a wide range of operators. It operates on a lower level compared to Spring WebFlux, similar to Java 8 Streams and Optional but with added capabilities for reactive programming.

Spring **WebFlux**, on the other hand, is a framework specifically designed for creating reactive web services. It leverages reactive libraries like Project Reactor (or even RxJava) to offer high scalability with low resource usage. While it utilizes Project Reactor under the hood, its primary focus is on providing tools and abstractions for building reactive web applications, handling HTTP requests, and managing resources efficiently.
{% endhint %}



### Maven Dependency

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>io.projectreactor</groupId>
            <artifactId>reactor-bom</artifactId>
            <version>2023.0.5</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

```xml
<dependency>
    <groupId>io.projectreactor</groupId>
    <artifactId>reactor-core</artifactId>
</dependency>
```



### Concepts

#### Mono

* **Definition**: The `Mono` class is a fundamental component of Project Reactor. It is defined in the `reactor.core.publisher` package. A `Mono` represents a publisher that emits at most one value (or none) and then terminates with a signal. This signal can be -&#x20;

&#x20;   \-> `onComplete`: Signifies successful completion of the stream, with or without a value emitted.

&#x20;   \-> `onError`: Indicates an error occurred during the stream processing.

`Mono` is good for scenarios where we expect a single result from an asynchronous operation, such as making a database call to fetch a specific user profile.

*   **Creation**: There are several ways to create a `Mono`:

    \-> Using static factory methods like `Mono.just()`, `Mono.empty()`, or `Mono.error()` to create instances of `Mono`.

    \-> Transforming other reactive types or Java objects into a `Mono` using methods like `Mono.fromCallable()`, `Mono.fromFuture()`, or `Mono.fromSupplier()`.

    \-> Generating a `Mono` from a callback-based API using methods like `Mono.create()`.
* **Operators**: `Mono` provides a rich set of operators for working with asynchronous data streams. These operators allows to transform, filter, combine, and manipulate `Mono` streams in a declarative and composable manner. Examples of operators include `map`, `flatMap`, `filter`, `defaultIfEmpty`, `zipWith`, `concatWith`, and many more.
* **Subscription**: Like other reactive types, `Mono` follows the reactive stream specification and adheres to the Publisher-Subscriber pattern. Subscribers can subscribe to a `Mono` using the `subscribe()` method and define callback functions to handle emitted items, errors, and completion signals.
* **Backpressure Handling**: `Mono` supports backpressure, allowing downstream subscribers to signal to upstream producers when they are overwhelmed and need to slow down the rate of data emission. Backpressure handling helps prevent resource exhaustion and system instability in scenarios with high data throughput.
* **Schedulers**: `Mono` allows to specify the execution context for asynchronous operations using schedulers. Schedulers control where and how operations within the `Mono` should be executed, enabling control over concurrency and parallelism.

#### Flux

* **Definition**: `Flux` is a generic class provided by Project Reactor, found in the `reactor.core.publisher` package. It represents a stream of zero to N items, emitting items asynchronously over time. It is suitable for handling multiple-value asynchronous sequences, such as multiple results from a database query, a series of events, or a stream of data from a web socket.
* **Creation**: There are various ways to create a `Flux`:
  * Using static factory methods like `Flux.just()`, `Flux.fromIterable()`, or `Flux.empty()` to create instances of `Flux`.
  * Transforming other reactive types or Java objects into a `Flux` using methods like `Flux.fromArray()`, `Flux.fromStream()`, or `Flux.fromCallable()`.
  * Generating a `Flux` from a callback-based API using methods like `Flux.create()`.
* **Operators**: `Flux` provides a rich set of operators for working with asynchronous data streams. These operators allow developers to transform, filter, combine, and manipulate `Flux` streams in a declarative and composable manner. Examples of operators include `map`, `flatMap`, `filter`, `mergeWith`, `concatWith`, `zip`, `take`, `skip`, and many more.
* **Subscription**: Similar to `Mono`, `Flux` follows the Publisher-Subscriber pattern and adheres to the reactive stream specification. Subscribers can subscribe to a `Flux` using the `subscribe()` method and define callback functions to handle emitted items, errors, and completion signals.
* **Backpressure Handling**: `Flux` supports backpressure, allowing downstream subscribers to signal to upstream producers when they are overwhelmed and need to slow down the rate of data emission. Backpressure handling helps prevent resource exhaustion and system instability in scenarios with high data throughput.
* **Schedulers**: `Flux` allows developers to specify the execution context for asynchronous operations using schedulers. Schedulers control where and how operations within the `Flux` should be executed, enabling fine-grained control over concurrency and parallelism.
