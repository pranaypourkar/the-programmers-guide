# Examples

## 1. Extending `Thread`&#x20;

### Print numbers from 1 to 5 in a separate thread with a 1 second pause

**Scenario:** We are asked to create a thread that prints numbers from 1 to 5 with a 1-second pause.

```java
package practice;

public class ThreadExamples {

    static class NumberPrinter extends Thread {

        public void run() {
            for (int i = 1; i <= 5; i++) {
                System.out.println("Thread: " + i);
                try {
                    Thread.sleep(1000); // Sleep for 1 second
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public static void main(String[] args) {
        NumberPrinter t = new NumberPrinter();
        t.start();
    }
}
```

### **Simulate two independent threads performing tasks**

**Scenario:** Create two threads representing background tasks that run in parallel.

```java
package practice;

public class ThreadExamples {

    static class TaskA extends Thread {

        @Override
        public void run() {
            System.out.println("Task A running by " + Thread.currentThread().getName());
        }
    }

    static class TaskB extends Thread {

        @Override
        public void run() {
            System.out.println("Task B running by " + Thread.currentThread().getName());
        }
    }


    public static void main(String[] args) {
        TaskA t1 = new TaskA();
        TaskB t2 = new TaskB();

        t1.start();
        t2.start();
    }
}
```

### Add 2 numbers in a separate thread

**Scenario:** We are asked to create a separate thread that performs addition of 2 numbers.

```java
package practice;

public class ThreadExamples {

    static class AdderThread extends Thread {
        private int a;
        private int b;

        public AdderThread(int a, int b) {
            this.a = a;
            this.b = b;
        }

        @Override
        public void run() {
            int sum = a + b;
            System.out.println("Sum (Thread): " + sum);
        }
    }

    public static void main(String[] args) {
        AdderThread add = new AdderThread(3,5);
        add.start();
    }
}
```

## 2. Implementing `Runnable`&#x20;

### **Run multiple tasks using the same class**

**Scenario:** We are asked to launch multiple threads with shared logic (e.g., printing thread names).

```java
package practice;

public class ThreadExamples {

    static class MyRunnable implements Runnable {
        @Override
        public void run() {
            System.out.println("Thread " + Thread.currentThread().getName() + " is running");
        }
    }
    
    public static void main(String[] args) {
        MyRunnable instance = new MyRunnable();
        Thread t1 = new Thread(instance);
        Thread t2 = new Thread(instance);
        t1.start();
        t2.start();
    }
}
```

### **Access a shared variable counter** safely updated by two threads

**Scenario:** Print a shared counter from multiple threads safely.

```java
package practice;

public class ThreadExamples {

    static class CounterRunnable implements Runnable {
        private int counter = 0;

        @Override
        public void run() {
            synchronized (this) {
                counter++;
                System.out.println(Thread.currentThread().getName() + " => Counter: " + counter);
            }
        }
    }

    public static void main(String[] args) {
        CounterRunnable instance = new CounterRunnable();
        Thread t1 = new Thread(instance);
        Thread t2 = new Thread(instance);
        t1.start();
        t2.start();
    }
}
```

### Add 2 numbers in a separate thread

**Scenario:** We are asked to create a separate thread that performs addition of 2 numbers.

```java
package practice;

public class ThreadExamples {

    static class AdderRunnable implements Runnable {
        private int a;
        private int b;

        public AdderRunnable(int a, int b) {
            this.a = a;
            this.b = b;
        }

        public void run() {
            int sum = a + b;
            System.out.println("Sum (Runnable): " + sum);
        }
    }

    public static void main(String[] args) {
        Thread t = new Thread(new AdderRunnable(5, 10));
        t.start();
    }
}
```

## 3. Implementing `Callable`&#x20;

### **Compute factorial of a number and return result**

**Scenario:** We are asked to return the factorial of a number using thread.

```java
package practice;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class ThreadExamples {

    static class FactorialTask implements Callable<Integer> {

        private int n;

        public FactorialTask(int n) {
            this.n = n;
        }

        @Override
        public Integer call() {
            int fact = 1;

            for (int i = 1; i <= n; i++) {
                fact = fact * i;
            }

            return fact;
        }
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        FactorialTask task = new FactorialTask(5);

        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<Integer> future = executor.submit(task);
        System.out.println("Factorial: " + future.get());
        executor.shutdown();
    }
}
```

### Add 2 numbers in a separate thread

**Scenario:** We are asked to create a separate thread that performs addition of 2 numbers.

```java
package practice;

import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class ThreadExamples {

    static class AdderCallable implements Callable<Integer> {
        private int a;
        private int b;

        public AdderCallable(int a, int b) {
            this.a = a;
            this.b = b;
        }

        @Override
        public Integer call() {
            return a + b;
        }
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<Integer> future = executor.submit(new AdderCallable(5, 10));
        System.out.println("Sum (Callable): " + future.get());
        executor.shutdown();
    }
}
```

## 4. Using `ExecutorService`&#x20;

### **Submit 10 print tasks with a thread pool of size 3**

**Scenario:** We are asked to submit a batch of printing tasks to a fixed thread pool.

```java
package practice;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadExamples {

    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);

        for (int i = 1; i <= 10; i++) {
            final int taskId = i;
            executor.submit(() -> {
                System.out.println("Running Task " + taskId + " in " + Thread.currentThread().getName());
            });
        }

        executor.shutdown();
    }
}    
```

{% hint style="success" %}
Variable used in lambda expression should be final or effectively final
{% endhint %}

### **Schedule a periodic task every 2 seconds**

**Scenario:** Run a health check every 2 seconds using scheduled thread pool.

<pre class="language-java"><code class="lang-java"><strong>package practice;
</strong>
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class ThreadExamples {

    public static void main(String[] args) {
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

        Runnable task = () -> System.out.println("Health check at: " + System.currentTimeMillis());

        scheduler.scheduleAtFixedRate(task, 0, 2, TimeUnit.SECONDS);
    }
}
</code></pre>

### Add 2 numbers in a separate thread

**Scenario:** We are asked to create a separate thread that performs addition of 2 numbers.

```java
package practice;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class ThreadExamples {

    public static void main(String[] args) {
        ExecutorService executor = Executors.newSingleThreadExecutor();
        int a = 5;
        int b = 10;

        executor.execute(() -> {
            int sum = a + b;
            System.out.println("Sum (Executor + Runnable): " + sum);
        });

        executor.shutdown();
    }
}
```

## 5. Using `CompletableFuture`&#x20;

### **Asynchronously fetch user and print welcome message**

**Scenario:** Simulate a service fetching a user and print a greeting message after it's done.

```java
package practice;

import java.util.concurrent.CompletableFuture;

public class ThreadExamples {

    public static void main(String[] args) {
        CompletableFuture.supplyAsync(() -> "John Doe")
            .thenApply(user -> "Welcome, " + user)
            .thenAccept(System.out::println).get();
    }
}
```

### **Chain two async operations with transformation**

**Scenario:** Fetch user ID, then fetch user's orders based on the ID.

```java
package practice;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public class ThreadExamples {

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        CompletableFuture.supplyAsync(() -> "user123")
            .thenCompose(user -> CompletableFuture.supplyAsync(() -> "Orders for " + user))
            .thenAccept(System.out::println).get();
    }
}
```

{% hint style="success" %}
The main thread may **exit immediately** before the async operations complete, especially if it's in a `main()` method. That’s why **we may not see any output without .get()** — the `CompletableFuture` hasn’t finished when the program exits.
{% endhint %}

### **Combine multiple futures and wait for all**

**Scenario:** Run two independent tasks and combine their results.

```java
package practice;

import java.util.concurrent.CompletableFuture;

public class ThreadExamples {

    public static void main(String[] args) {
        CompletableFuture<String> future1 = CompletableFuture.supplyAsync(() -> "Result 1");
        CompletableFuture<String> future2 = CompletableFuture.supplyAsync(() -> "Result 2");

        CompletableFuture.allOf(future1, future2)
            .thenRun(() -> {
                try {
                    System.out.println(future1.get());
                    System.out.println(future2.get());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            });
    }
}
```

### Add 2 numbers in a separate thread

**Scenario:** We are asked to create a separate thread that performs addition of 2 numbers.

```java
package practice;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public class ThreadExamples {

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        int a = 5;
        int b = 10;

        CompletableFuture
            .supplyAsync(() -> a + b)
            .thenAccept(sum -> System.out.println("Sum (CompletableFuture): " + sum)).get();
    }
}
```
