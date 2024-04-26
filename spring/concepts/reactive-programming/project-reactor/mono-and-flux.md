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
        error -> log.info("Error: ", error),
        () -> log.info("Mono Completed")
);
```

<figure><img src="../../../../.gitbook/assets/image (47).png" alt=""><figcaption></figcaption></figure>



**Mono.empty()**: This method creates an empty Mono, meaning it emits no items and completes immediately after being subscribed to. It's useful when you need to represent a Mono that has no data to emit.

```java
Mono<Void> emptyMono = Mono.empty();

emptyMono.subscribe(
        data -> log.info("This won't be called (no value)"),
        error -> log.info("Error: ", error),
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
        error -> log.info("Error: {}", error.getMessage()),
        () -> log.info("Mono Won't Complete (due to error)")
);
```

<figure><img src="../../../../.gitbook/assets/image (49).png" alt=""><figcaption></figcaption></figure>

