# Parallelism and Concurrency

## About

Parallelism and concurrency are both important concepts in asynchronous computation, but they are distinct and address different aspects of task execution.

## **Concurrency**

Concurrency refers to the ability of a system to handle multiple tasks at the same time. It doesn't necessarily mean these tasks are executed simultaneously. Instead, concurrency is about managing the execution of tasks in a way that they appear to run in parallel, even if they are executed on a single processor core. Concurrency creates a illusion of parallelism, however actually the chunks of a task aren’t parallelly processed.

<figure><img src="../../../../.gitbook/assets/image.png" alt="" width="563"><figcaption></figcaption></figure>

#### **Key Characteristics**

* **Interleaving:** Tasks are broken down into smaller units, which are executed in a time-sliced manner.
* **Context Switching:** The scheduler frequently switches between tasks, saving and restoring the state of each task.
* **Single-Core Execution:** Concurrency can happen on a single core by slicing time among tasks.
* **Debugging**: In concurrency, debugging is a bit hard due to non-deterministic control flow approach.

### **Parallelism**

Parallelism involves executing multiple tasks simultaneously. It requires multiple processors or cores, where each core executes a separate task at the same time.

<figure><img src="../../../../.gitbook/assets/image (1).png" alt="" width="563"><figcaption></figcaption></figure>

#### **Key Characteristics:**

* **Simultaneous Execution:** Multiple tasks are executed at the same time on different processors or cores.
* **Multi-Core Execution:** Requires multiple cores or processors to achieve parallelism.
* **No Context Switching:** Unlike concurrency, there's no need for frequent context switching between tasks.
* **Debugging**: While in this also, debugging is hard but simple than concurrency due to deterministic control flow approach.







