# Reactive Stream Specification

The Reactive Streams specification defines a standard for asynchronous stream processing with non-blocking back pressure in Java. It establishes a set of interfaces that enable interoperability between different reactive libraries, including those used in Spring.

For more details visit: [https://github.com/reactive-streams/reactive-streams-jvm?tab=readme-ov-file#specification](https://github.com/reactive-streams/reactive-streams-jvm?tab=readme-ov-file#specification)



Reactive Streams introduces four main interfaces:

1. **Publisher:** The Publisher interface represents a provider of a potentially unbounded number of sequenced elements, publishing them asynchronously. Publishers can emit items to one or more subscribers, adhering to the backpressure signal.

{% hint style="info" %}
The `subscribe` method is how a Subscriber tells the Publisher, "Hey, I want to listen to your data, please let me know when you have something to share." When a Subscriber calls this method on a Publisher, it's essentially saying, "Sign me up to receive your updates."
{% endhint %}

```java
package org.reactivestreams;

public interface Publisher<T> {
    /**
     * Subscribes the given Subscriber to this Publisher.
     */
    public void subscribe(Subscriber<? super T> s);
}
```

2. **Subscriber:** The Subscriber interface represents a consumer of a potentially unbounded number of sequenced elements. Subscribers receive elements emitted by a Publisher and process them accordingly. Subscribers can also signal demand to Publishers, managing the flow of data and implementing backpressure.

```java
package org.reactivestreams;

public interface Subscriber<T> {
    /**
     * Receives a Subscription for managing the backpressure relationship with the Publisher.
     */
    public void onSubscribe(Subscription s);

    /**
     * Processes the next element emitted by the Publisher.
     */
    public void onNext(T t);

    /**
     * Handles an error condition emitted by the Publisher.
     */
    public void onError(Throwable t);

    /**
     * Signals that the Publisher has completed emitting elements
     */
    public void onComplete();
}
```

3. **Subscription:** The Subscription interface represents the relationship between a Publisher and a Subscriber. It allows a Subscriber to signal how many elements it is ready to consume from the Publisher at a time. Additionally, it enables a Subscriber to cancel the flow of elements if necessary.

```java
package org.reactivestreams;

public interface Subscription {
    /**
     * Requests the Publisher to emit up to the specified number of elements to the Subscriber.
     */
    public void request(long n);

    /**
     * Cancels the subscription, stopping the flow of elements from the Publisher to the Subscriber.
     */
    public void cancel();
}
```

4. **Processor:** The Processor interface represents a processing stage—which is both a Subscriber and a Publisher. It receives elements from a preceding Publisher, processes them in some way, and then publishes the processed elements to subsequent Subscribers. Processors can be used to build complex data processing pipelines.

```java
package org.reactivestreams;

public interface Processor<T, R> extends Subscriber<T>, Publisher<R> {
}
```

