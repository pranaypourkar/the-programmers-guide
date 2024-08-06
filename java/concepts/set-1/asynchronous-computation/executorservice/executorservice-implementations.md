# ExecutorService Implementations

## About&#x20;

Java's `ExecutorService` provides a framework for managing a pool of threads to execute asynchronous tasks. The framework abstracts the creation, execution, and management of threads, making it easier to work with concurrent tasks. Various implementations of `ExecutorService` cater to different use cases and requirements. Below are some of the `ExecutorService` implementations in Java.

## 1. **ThreadPoolExecutor**

`ThreadPoolExecutor` is the commonly used and configurable implementation of `ExecutorService`. It allows for fine-grained control over thread management and task handling.

### **Key Characteristics**

* **Core Pool Size**: The minimum number of threads that are always kept alive, even if they are idle.
* **Maximum Pool Size**: The maximum number of threads allowed in the pool.
* **Keep-Alive Time**: The maximum time that excess idle threads will wait for new tasks before terminating.
* **Work Queue**: The queue used for holding tasks before they are executed. Can be `ArrayBlockingQueue`, `LinkedBlockingQueue`, `SynchronousQueue`, etc.
* **Rejected Execution Handler**: Defines the policy for handling tasks that cannot be executed (e.g., due to a full queue or pool shutdown). Options include `AbortPolicy`, `CallerRunsPolicy`, `DiscardPolicy`, and `DiscardOldestPolicy`.

### **Example**

```java
ExecutorService executor = new ThreadPoolExecutor(
    10, // core pool size
    20, // maximum pool size
    60L, // keep-alive time
    TimeUnit.SECONDS, // time unit
    new LinkedBlockingQueue<Runnable>(), // work queue
    new ThreadPoolExecutor.CallerRunsPolicy() // rejection policy
);
```

## 2. **Custom ThreadPoolExecutor**

For specialized needs, we can extend `ThreadPoolExecutor` and override its methods to provide custom behaviors, such as logging, monitoring, or modifying task handling.

### **Key Characteristics**

* **Customization**: Full control over the executor's behavior, including thread creation, task execution, and termination policies.

### **Usage Example**

```java
class CustomThreadPoolExecutor extends ThreadPoolExecutor {
    public CustomThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue) {
        super(corePoolSize, maximumPoolSize, keepAliveTime, unit, workQueue);
    }

    @Override
    protected void beforeExecute(Thread t, Runnable r) {
        super.beforeExecute(t, r);
        // Custom logic before task execution
    }

    @Override
    protected void afterExecute(Runnable r, Throwable t) {
        super.afterExecute(r, t);
        // Custom logic after task execution
    }

    @Override
    protected void terminated() {
        super.terminated();
        // Custom logic on termination
    }
}
```



