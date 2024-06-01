# Mono & Flux

## Maven Dependency

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

<dependencies>
    <dependency>
        <groupId>io.projectreactor</groupId>
        <artifactId>reactor-core</artifactId>
    </dependency>

    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.30</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

## Mono

### What is Mono?

Mono is a type in the Reactor library. It represents a stream that emits at most one item, and it can emit either a single item, an error, or nothing (completion). It's commonly used in reactive programming for handling asynchronous operations, such as making network requests or interacting with databases.

Mono is useful for handling asynchronous operations in a non-blocking, efficient manner. It allows to work with streams of data in a reactive way, enabling better scalability and responsiveness in applications. Mono simplifies handling asynchronous tasks by providing operators for transforming, filtering, and combining data streams.

### Sample Examples

#### **Static Factory Methods**

**Mono.just()**: This static factory method creates a Mono that emits a single item. You provide the item as an argument to the method, and the resulting Mono emits that item to any subscribers.

```java
String name = "Alice";
Mono<String> monoName = Mono.just(name);

monoName.subscribe(
        data -> log.info("Emitted Name: {}", data),
        error -> log.error("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (47).png" alt=""><figcaption></figcaption></figure>



**Mono.empty()**: This method creates an empty Mono, meaning it emits no items and completes immediately after being subscribed to. It's useful when you need to represent a Mono that has no data to emit.

```java
Mono<Void> emptyMono = Mono.empty();

emptyMono.subscribe(
        data -> log.info("This won't be called (no value)"),
        error -> log.error("Error: ", error),
        () -> log.info("Empty Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (48).png" alt=""><figcaption></figcaption></figure>



**Mono.error()**: This method creates a Mono that emits an error signal immediately after being subscribed to. You provide an exception or error object as an argument, and the resulting Mono emits that error to any subscribers

```java
Exception someException = new Exception("Something went wrong!");
Mono<String> errorMono = Mono.error(someException);

errorMono.subscribe(
        data -> log.info("This won't be called (error emitted)"),
        error -> log.error("Error: {}", error.getMessage()),
        () -> log.info("Mono Won't Complete (due to error)")
);
```

<figure><img src="../../../../.gitbook/assets/image (49).png" alt=""><figcaption></figcaption></figure>

#### **Transforming Other Data Sources**

**Mono.fromCallable()**

```java
Callable<String> getNameCallable = () -> "Bob";
Mono<String> monoName = Mono.fromCallable(getNameCallable);

monoName.subscribe(
        data -> log.info("Emitted Name: {}", data),
        error -> log.error("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>



**Mono.fromSupplier()**

```java
Supplier<String> getNameSupplier = () -> "Charlie";
Mono<String> monoName2 = Mono.fromSupplier(getNameSupplier);

monoName2.subscribe(
        data -> log.info("Emitted Name: {}", data),
        error -> log.error("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>



**Mono.create()**

It allows to create a Mono by providing a consumer function that defines the asynchronous behavior of the Mono. The consumer function receives a `MonoSink` parameter, which is used to emit items, errors, and completion signals.

```java
Mono<String> asyncMono = Mono.create(sink -> {
    // Simulate an asynchronous operation, such as fetching data from a database or making a network call
    // This operation might take some time to complete
    // Use different thread instead of main thread
    new Thread(() -> {
        try {
            Thread.sleep(2000); // Simulate delay
            String result = "Async result";
            sink.success(result); // Emit the result
        } catch (InterruptedException e) {
            sink.error(e); // Emit an error if interrupted
        }
    }).start();
});

// Subscribe to the Mono to receive the result
asyncMono.subscribe(
        result -> log.info("Received result: {}", result),
        error -> log.error("Error occurred: {}", error.getMessage()),
        () -> log.info("Mono completed")
);

// Main thread continues execution while waiting for the asynchronous operation to complete
log.info("Waiting for async operation to complete...");
```

<figure><img src="../../../../.gitbook/assets/image (4) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

#### **Operators for Data Manipulation**

**map() - Transforming Data**

```java
Mono<String> monoName = Mono.just("David");
Mono<Integer> monoNameLength = monoName.map(String::length);

monoNameLength.subscribe(
        length -> log.info("Name Length: {}", length),
        error -> log.info("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>



**filter() - Filtering Data**

```java
Mono<Integer> numberMono = Mono.just(42);
Mono<Integer> evenNumberMono = numberMono.filter(number -> number % 2 == 0);

evenNumberMono.subscribe(
        data -> log.info("Emitted Even Number: {}", data),
        error -> log.info("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>

#### **Backpressure Handling**

In general, `Mono` instances in Reactor represent streams that emit at most one item, an error, or nothing (completion). Due to this characteristic, backpressure handling with `Mono` is less common compared to other reactive types like `Flux`, which can emit multiple items. Flux deals with potentially large streams of data where the producer might emit data faster than the consumer can process it. Backpressure becomes essential to prevent overwhelming the subscriber and potential system instability.

However, there are still scenarios where backpressure handling may be relevant with `Mono`, especially when `Mono` is used in combination with other reactive types or in situations where asynchronous operations may produce data at a rate that exceeds the capacity of downstream processing.



#### Schedulers

Mono, like other reactive types, allows you to specify the execution context (thread pool or scheduler) for asynchronous operations using Schedulers. This provides control over concurrency and parallelism in your reactive code.

```java
package org.example;

import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@Slf4j
public class Application {
    public static void main(String[] args) {
        Mono<String> asyncMono = Mono.fromCallable(() -> {
            // Simulate some expensive computation
            Thread.sleep(1000);
            return "Async result";
        }).subscribeOn(Schedulers.parallel()); // Execute the computation on a parallel scheduler

        asyncMono.subscribe(log::info); // Subscribe to the Mono

        log.info("Continuing the main program");
        // Sleep to ensure the program doesn't terminate before the asynchronous operation completes
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (5) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>





## Flux

### What is Flux?

Flux is also a type in the Reactor library. It represents a stream that can emit zero to many items, potentially an unbounded number of items, over time. Similar to Mono, Flux can emit items, errors, or a completion signal. It's designed for handling asynchronous data streams in reactive programming, enabling developers to process sequences of data asynchronously.

Flux is essential for handling asynchronous data streams in a non-blocking and efficient manner, just like Mono. It allows developers to work with sequences of data emitted over time, making it suitable for scenarios where multiple items need to be processed asynchronously. Flux enables better scalability and responsiveness in applications by providing operators for transforming, filtering, and combining data streams, similar to Mono. Flux is particularly useful when dealing with scenarios such as real-time data processing, event-driven architectures, or reactive systems where events or data arrive asynchronously. Its support for backpressure ensures that the downstream consumers can control the rate of data emission, preventing overload and resource exhaustion.
