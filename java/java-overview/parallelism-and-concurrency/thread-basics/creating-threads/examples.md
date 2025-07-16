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
    
```

## 2. Implementing `Runnable`&#x20;

### **Run multiple tasks using the same class**

**Scenario:** We are asked to launch multiple threads with shared logic (e.g., printing thread names).

```
```

### **Access a shared variable across multiple threads**

**Scenario:** Print a shared counter from multiple threads safely.

```
```

## 3. Implementing `Callable`&#x20;

### **Compute factorial of a number and return result**

**Scenario:** We are asked to return the factorial of a number using threads.

```java
    
```

### **Fetch user details from simulated service**

**Scenario:** Simulate an API call using a background thread that returns user info.

```java
    
```



## 4. Using `ExecutorService`&#x20;

### **Submit 10 print tasks with a thread pool of size 3**

**Scenario:** We are asked to submit a batch of printing tasks to a fixed thread pool.

```java
    
```

### **Schedule a periodic task every 2 seconds**

**Scenario:** Run a health check every 2 seconds using scheduled thread pool.

```java
    
```



## 5. Using `CompletableFuture`&#x20;

### **Asynchronously fetch user and print welcome message**

**Scenario:** Simulate a service fetching a user and print a greeting message after it's done.

```java
    
```

### **Chain two async operations with transformation**

**Scenario:** Fetch user ID, then fetch user's orders based on the ID.

```java
    
```

### **Combine multiple futures and wait for all**

**Scenario:** Run two independent tasks and combine their results.

```java
```
