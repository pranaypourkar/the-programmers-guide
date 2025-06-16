# Asynchronous Computation

## About

Asynchronous computation in Spring Boot refers to executing tasks or methods asynchronously, meaning they run in the background without blocking the main thread of execution. This allows the main thread to continue processing other tasks while the asynchronous computation runs independently. Asynchronous processing is especially useful for tasks that are time-consuming, such as I/O operations, long-running calculations, or external API calls.

## Ways to Achieve Asynchronous Computation in Spring Boot

### **1. Using `@Async` Annotation**

* The `@Async` annotation is the simplest and most commonly used approach in Spring Boot for asynchronous processing.
* When applied to a method, the method execution is offloaded to a separate thread, freeing the caller to continue with other operations.
* Refer to this Page for more details: [async-annotation.md](async-annotation.md "mention")

### **2. Using `CompletableFuture` and `Future`**

* Asynchronous processing can be achieved using `CompletableFuture` or `Future`.
* This allows the caller to retrieve the result of the computation later or handle exceptions.
* Refer to this Page for more details: [executorservice](../../../java/concepts/concepts-set-1/asynchronous-computation/executorservice/ "mention")

### **3. Using `WebFlux` for Reactive Programming**

* Spring WebFlux is part of the Spring ecosystem that enables building non-blocking, reactive applications.
* It uses reactive types like `Mono` and `Flux` to achieve asynchronous processing.
* Refer to this Page for more details: [reactive-programming](../reactive-programming/ "mention")

### **4. Using Project Reactor (`Mono` and `Flux`) without WebFlux**:

* Even if you are not using WebFlux, you can still leverage Project Reactor’s `Mono` and `Flux` for asynchronous, non-blocking processing in your Spring Boot application.
* Refer to this Page for more details: [project-reactor](../reactive-programming/project-reactor/ "mention")
