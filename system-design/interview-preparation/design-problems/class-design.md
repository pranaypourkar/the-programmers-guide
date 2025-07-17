# Class Design

## 1. Design a class which provides a lock only if there are no possible deadlocks.

In multithreaded systems, **deadlocks occur** when two or more threads are **waiting on each other** to release locks, and none can proceed.

Example:

* Thread 1 holds Lock A and waits for Lock B.
* Thread 2 holds Lock B and waits for Lock A.
* Both are now stuck forever.

Task is to design a class that **only allows a thread to acquire a lock if it won't create a deadlock**.

### Approach 1: **Lock Ordering**

* Assign a **unique global order (ID)** to each lock.
* Threads must **acquire locks in a specific order** (e.g., increasing ID).
* This guarantees **no cyclic wait** — hence no deadlocks.

{% hint style="success" %}
If all threads follow the **same lock acquisition order**, they will never form a circular wait.
{% endhint %}



Two bank accounts, A and B.

* Thread 1: Transfers from A to B
* Thread 2: Transfers from B to A
* If locks are acquired in different orders, deadlock can happen.

_BankAccount.java_

```java
package practice;

import java.util.concurrent.locks.ReentrantLock;

public class BankAccount {
    private final String accountId;
    private double balance;
    private final ReentrantLock lock = new ReentrantLock();

    public BankAccount(String accountId, double initialBalance) {
        this.accountId = accountId;
        this.balance = initialBalance;
    }

    public String getAccountId() {
        return accountId;
    }

    public void deposit(double amount) {
        balance += amount;
    }

    public void withdraw(double amount) {
        balance -= amount;
    }

    public double getBalance() {
        return balance;
    }

    public ReentrantLock getLock() {
        return lock;
    }

    @Override
    public String toString() {
        return accountId + ": " + balance;
    }
}
```

_TransferManager.java_

```java
package practice;

public class TransferManager {

    public static void transferMoney(BankAccount from, BankAccount to, double amount) throws InterruptedException {
        // Enforce consistent lock ordering using accountId (lexicographical order)
        BankAccount firstLock;
        BankAccount secondLock;

        if (from.getAccountId().compareTo(to.getAccountId()) < 0) {
            firstLock = from;
            secondLock = to;
        } else if (from.getAccountId().compareTo(to.getAccountId()) > 0) {
            firstLock = to;
            secondLock = from;
        } else {
            // If both accounts are same, only need one lock
            firstLock = from;
            secondLock = null;
        }

        // Lock both accounts in consistent order
        synchronizedLock(firstLock, secondLock, () -> {
            if (from.getBalance() < amount) {
                throw new IllegalArgumentException("Insufficient funds");
            }

            from.withdraw(amount);
            to.deposit(amount);
            System.out.println(Thread.currentThread().getName() + " transferred $" + amount + " from " + from.getAccountId() + " to " + to.getAccountId());
        });
    }

    private static void synchronizedLock(BankAccount first, BankAccount second, Runnable task) {
        first.getLock().lock();
        try {
            if (second != null) {
                second.getLock().lock();
            }
            try {
                task.run();
            } finally {
                if (second != null) {
                    second.getLock().unlock();
                }
            }
        } finally {
            first.getLock().unlock();
        }
    }
}
```

_BankTransferSimulation.java_

```java
package practice;

public class BankTransferSimulation {
    public static void main(String[] args) {
        BankAccount accountA = new BankAccount("A", 1000);
        BankAccount accountB = new BankAccount("B", 1000);

        // Thread 1: A → B
        Thread t1 = new Thread(() -> {
            try {
                for (int i = 0; i < 5; i++) {
                    TransferManager.transferMoney(accountA, accountB, 100);
                    Thread.sleep(50);
                }
            } catch (Exception e) {
                System.out.println("T1: " + e.getMessage());
            }
        }, "T1");

        // Thread 2: B → A (reverse direction)
        Thread t2 = new Thread(() -> {
            try {
                for (int i = 0; i < 5; i++) {
                    TransferManager.transferMoney(accountB, accountA, 50);
                    Thread.sleep(50);
                }
            } catch (Exception e) {
                System.out.println("T2: " + e.getMessage());
            }
        }, "T2");

        t1.start();
        t2.start();

        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Final balances:");
        System.out.println(accountA);
        System.out.println(accountB);
    }
}

/*
Output
T2 transferred $50.0 from B to A
T1 transferred $100.0 from A to B
T2 transferred $50.0 from B to A
T1 transferred $100.0 from A to B
T2 transferred $50.0 from B to A
T1 transferred $100.0 from A to B
T2 transferred $50.0 from B to A
T1 transferred $100.0 from A to B
T2 transferred $50.0 from B to A
T1 transferred $100.0 from A to B
Final balances:
A: 750.0
B: 1250.0
*/
```

**Explanation:**

1. **Thread-1** starts:
   * Compares `"A"` vs `"B"` → A first
   * Acquires lock on A
   * Tries to acquire lock on B
2. **Meanwhile**, Thread-2 starts:
   * Compares `"B"` vs `"A"` → A still comes first
   * Tries to acquire lock on A, but **it's held by Thread-1**
   * So **Thread-2 blocks** waiting for A
3. Thread-1 finishes:
   * Transfers money
   * Releases B
   * Releases A
4. Now Thread-2:
   * Acquires A (now free)
   * Acquires B
   * Transfers money
   * Releases both

**No deadlock! Both transfers finish correctly.**

{% hint style="warning" %}
What If We Didn't Use Ordering?

If threads acquired locks in **random order** (based on from/to):

* Thread-1 locks A → waits for B
* Thread-2 locks B → waits for A
* **Deadlock happens: each thread waits forever!**
{% endhint %}

### Approach 2: **Try-Lock with Timeout & Rollback**

When multiple threads need to acquire multiple locks, and acquiring them in different orders, there's a risk of deadlock.\
This approach tries to acquire each lock **with a timeout**, and **backs off** (releases all acquired locks) if it can't acquire all necessary locks within the timeout window.

This strategy helps in **detecting potential deadlocks early** and avoiding them by **not holding onto locks indefinitely**.

{% hint style="success" %}
By backing off and retrying, threads avoid being stuck in a cycle.
{% endhint %}

Two users trying to transfer money between two bank accounts. Each transfer needs a lock on both source and target account. If two transfers happen at the same time in opposite directions, a deadlock could happen if both threads acquire one lock each and wait for the other.

_Account.java_

```java
package practice.test;

import java.util.concurrent.locks.ReentrantLock;

public class Account {
    private final String name;
    private int balance;
    private final ReentrantLock lock = new ReentrantLock();

    public Account(String name, int initialBalance) {
        this.name = name;
        this.balance = initialBalance;
    }

    public boolean withdraw(int amount) {
        if (balance >= amount) {
            balance -= amount;
            return true;
        }
        return false;
    }

    public void deposit(int amount) {
        balance += amount;
    }

    public ReentrantLock getLock() {
        return lock;
    }

    public String getName() {
        return name;
    }

    public int getBalance() {
        return balance;
    }
}


```

_TransferService.java_

```java
package practice.test;

import java.util.concurrent.TimeUnit;

public class TransferService {

    public boolean transfer(Account from, Account to, int amount, long timeout, TimeUnit unit)
        throws InterruptedException {
        // Try to acquire both locks with timeout
        boolean fromLockAcquired = false;
        boolean toLockAcquired = false;

        try {
            fromLockAcquired = from.getLock().tryLock(timeout, unit);
            if (!fromLockAcquired) {
                System.out.println("Could not acquire lock on " + from.getName());
                return false;
            }

            // Small delay to simulate real-world locking delay
            Thread.sleep(50);

            toLockAcquired = to.getLock().tryLock(timeout, unit);
            if (!toLockAcquired) {
                System.out.println("Could not acquire lock on " + to.getName());
                return false;
            }

            // Perform transfer
            if (from.withdraw(amount)) {
                to.deposit(amount);
                System.out.printf("Transferred %d from %s to %s%n", amount, from.getName(), to.getName());
                return true;
            } else {
                System.out.printf("Insufficient balance to transfer %d from %s%n", amount, from.getName());
                return false;
            }

        } finally {
            // Always unlock in reverse order of locking
            if (toLockAcquired) {
                to.getLock().unlock();
            }
            if (fromLockAcquired) {
                from.getLock().unlock();
            }
        }
    }
}
```

_DeadlockAvoidanceExample.java_

```java
package practice.test;

import java.util.concurrent.TimeUnit;

public class DeadlockAvoidanceExample {
    public static void main(String[] args) {
        Account accA = new Account("AccountA", 1000);
        Account accB = new Account("AccountB", 1000);

        TransferService service = new TransferService();

        Runnable task1 = () -> {
            try {
                service.transfer(accA, accB, 300, 1, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        Runnable task2 = () -> {
            try {
                service.transfer(accB, accA, 500, 1, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        };

        new Thread(task1).start();
        new Thread(task2).start();
    }
}
```

**Explanation**

#### Step 1: Thread-1 starts

* Intention: Transfer ₹300 from **A → B**
* Calls `tryLock()` on **Account A**
* Successfully acquires **lock on A**
* Waits for a small delay (simulating processing)
* Calls `tryLock()` on **Account B**

#### Step 2: While Thread-1 is waiting

* **Thread-2 starts**
* Intention: Transfer ₹500 from **B → A**
* Calls `tryLock()` on **Account B**
* Successfully acquires **lock on B**
* Waits for a small delay
* Calls `tryLock()` on **Account A**

#### Step 3: Deadlock would occur…

* **Thread-1** has **lock on A**, waiting for **B**
* **Thread-2** has **lock on B**, waiting for **A**

{% hint style="danger" %}
In traditional lock acquisition (without timeout), this would be a deadlock.
{% endhint %}

#### Step 4: But tryLock() avoids this

* `tryLock(timeout)` times out for both threads on second lock
* Each thread **fails to acquire the second lock within timeout**
* Each thread:
  * Logs timeout
  * **Releases already held lock**
  * Optionally retries or exits gracefully

#### Step 5: Outcome

* No deadlock occurs
* System continues to operate
* One or both threads may retry or log failure

## 2. Design a mechanism to ensure that first is called before second and second is called before third.

```
public class Foo {
    public Foo() { ... }
    public void first() { ... }
    public void second() { ... }
    public void third() { ... }
}
```

The same instance of Foo will be passed to three different threads. ThreadA will call first,

threads will call second, and threadC will call third.&#x20;

To solve this problem where three threads (`ThreadA`, `ThreadB`, and `ThreadC`) are calling `first()`, `second()`, and `third()` respectively, **we need to enforce ordering**:

* `first()` must run **before** `second()`
* `second()` must run **before** `third()`

### Approach: Using `CountDownLatch`

We can use two `CountDownLatch` objects to control execution order:

* One latch to wait for `first()` to complete before `second()`
* Another latch to wait for `second()` to complete before `third()`

_Foo.java_

```java
package practice.test2;

import java.util.concurrent.CountDownLatch;

public class Foo {
    private final CountDownLatch secondLatch = new CountDownLatch(1);
    private final CountDownLatch thirdLatch = new CountDownLatch(1);

    public Foo() {
        // Constructor logic if needed
    }

    public void first() {
        // This will be called by ThreadA
        System.out.println("first");

        // Signal that 'first()' has completed
        secondLatch.countDown();
    }

    public void second() {
        try {
            // Wait until 'first()' is done
            secondLatch.await();
            System.out.println("second");

            // Signal that 'second()' has completed
            thirdLatch.countDown();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // Best practice
        }
    }

    public void third() {
        try {
            // Wait until 'second()' is done
            thirdLatch.await();
            System.out.println("third");
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```

_FooTest.java_

```java
package practice.test2;

public class FooTest {
    public static void main(String[] args) {
        Foo foo = new Foo();

        Thread threadA = new Thread(() -> foo.first());
        Thread threadB = new Thread(() -> foo.second());
        Thread threadC = new Thread(() -> foo.third());

        // Start threads in random order to test correctness
        threadC.start();
        threadB.start();
        threadA.start();
    }
}

/*
first
second
third
*/
```

