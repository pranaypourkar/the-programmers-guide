# Stack

## **About**

`Stack` is a part of the Java Collections Framework and is a subclass of `Vector`. It represents a last-in, first-out (LIFO) stack of objects. It allows elements to be added, removed, and retrieved in a way that the most recently added element is always the first to be removed.

The `Stack` class provides methods that operate on the stack in a LIFO manner, such as `push()`, `pop()`, `peek()`, and `empty()`.

## **Features**

1. **LIFO (Last In, First Out):** The last element added is the first one to be removed.
2. **Dynamic Size:** Similar to `ArrayList`, `Stack` resizes dynamically as elements are added or removed.
3. **Allowing Duplicates:** Like `ArrayList`, `Stack` allows duplicates.
4. **Resizes Automatically:** The size of the stack grows or shrinks automatically based on the number of elements.
5. **Thread-Safe (but not recommended):** `Stack` is synchronized, meaning it is thread-safe for concurrent use.
6. **Element Access via `peek()`:** Allows looking at the top element of the stack without removing it.
7. **Inheritance:** `Stack` is a subclass of `Vector`, so it inherits the functionality of a resizable array.
8. **Empty Check via `empty()`:** Provides an easy way to check if the stack is empty.
9. **Accessing Element via `search()`:** Can search for an element in the stack and return its distance from the top of the stack.

## **Key Methods**

* `push(E item)`: Adds an item to the top of the stack.
* `pop()`: Removes and returns the item at the top of the stack. Throws `EmptyStackException` if the stack is empty.
* `peek()`: Returns the item at the top of the stack without removing it. Throws `EmptyStackException` if the stack is empty.
* `empty()`: Returns `true` if the stack is empty, otherwise `false`.
* `search(Object o)`: Returns the 1-based position of the object in the stack, or -1 if not found.
* `size()`: Returns the number of elements in the stack.
* `clear()`: Removes all elements from the stack (not directly available, but can be done using `removeAllElements()` from the parent `Vector` class).
* `clone()`: Creates a shallow copy of the stack.
* `contains(Object o)`: Returns `true` if the stack contains the specified element.

## **Big O Time Complexity for Stack Operations**

<table data-header-hidden data-full-width="true"><thead><tr><th width="264"></th><th width="228"></th><th></th></tr></thead><tbody><tr><td><strong>Operation</strong></td><td><strong>Big(O) Time Complexity</strong></td><td><strong>Details</strong></td></tr><tr><td><strong>Push (add an element)</strong></td><td>O(1)</td><td>Adding an element to the top of the stack takes constant time.</td></tr><tr><td><strong>Pop (remove an element)</strong></td><td>O(1)</td><td>Removing the top element from the stack takes constant time.</td></tr><tr><td><strong>Peek (top element)</strong></td><td>O(1)</td><td>Accessing the top element without removal takes constant time.</td></tr><tr><td><strong>Empty Check</strong></td><td>O(1)</td><td>Checking if the stack is empty is constant time.</td></tr><tr><td><strong>Search</strong></td><td>O(n)</td><td>Searching through the stack requires iterating over the elements.</td></tr><tr><td><strong>Size</strong></td><td>O(1)</td><td>Retrieving the size of the stack is constant time.</td></tr><tr><td><strong>Contains</strong></td><td>O(n)</td><td>Checking if an element exists in the stack requires a scan through all elements.</td></tr></tbody></table>

## Example

### Basic Operation

```java
import java.util.Stack;

public class StackExample {
    public static void main(String[] args) {
        // Creating a Stack of Strings
        Stack<String> stack = new Stack<>();

        // Push elements to the stack
        stack.push("Apple");
        stack.push("Banana");
        stack.push("Cherry");
        stack.push("Date");
        System.out.println("Stack after push operations: " + stack); //Stack after push operations: [Apple, Banana, Cherry, Date]

        // Peek the top element
        System.out.println("Top element (peek): " + stack.peek()); //Top element (peek): Date

        // Pop the top element
        System.out.println("Popped element: " + stack.pop()); //Popped element: Date
        System.out.println("Stack after pop operation: " + stack); //Stack after pop operation: [Apple, Banana, Cherry]

        // Check if stack is empty
        System.out.println("Is the stack empty? " + stack.empty()); //Is the stack empty? false

        // Search for an element (distance from the top)
        System.out.println("Position of 'Banana': " + stack.search("Banana")); //Position of 'Banana': 2
        System.out.println("Position of 'Date': " + stack.search("Date")); //Position of 'Date': -1

        // Clone the stack
        Stack<String> clonedStack = (Stack<String>) stack.clone();
        System.out.println("Cloned Stack: " + clonedStack); //Cloned Stack: [Apple, Banana, Cherry]

        // Iterating over the stack
        System.out.println("Iterating over stack:"); //Iterating over stack:
        for (String fruit : stack) {
            System.out.println(fruit);
        }
        //Apple
        //Banana
        //Cherry

        // Size of the stack
        System.out.println("Size of stack: " + stack.size()); //Size of stack: 3

        // Clear the stack
        stack.removeAllElements();
        System.out.println("Stack after clear operation: " + stack); //Stack after clear operation: []
    }
}
```

### **Generic Stack**

We can create a stack for any data type, ensuring type safety.

```java
Stack<Integer> numberStack = new Stack<>();
numberStack.push(10);
numberStack.push(20);
System.out.println("Sum of stack: " + numberStack.stream().mapToInt(Integer::intValue).sum());
```

### **Custom Class in Stack**

We can store custom objects in the stack.

```java
class Book {
    String title;
    double price;

    public Book(String title, double price) {
        this.title = title;
        this.price = price;
    }

    @Override
    public String toString() {
        return "Book{title='" + title + "', price=" + price + "}";
    }
}

Stack<Book> bookStack = new Stack<>();
bookStack.push(new Book("Java Basics", 19.99));
bookStack.push(new Book("Advanced Java", 29.99));

System.out.println("Books in stack: " + bookStack);
```

### **Thread-Safety in Stack (Not Recommended)**

Since `Stack` is synchronized i.e. each individual method call, such as `push()` or `pop()`, is thread-safe on its own., it can be used in a multithreaded environment, but modern alternatives like `Deque` are preferred for performance reasons.

<pre class="language-java"><code class="lang-java"><strong>Stack&#x3C;Integer> threadSafeStack = new Stack&#x3C;>();
</strong>synchronized (threadSafeStack) {
    threadSafeStack.push(1);
    threadSafeStack.push(2);
}
</code></pre>

{% hint style="info" %}
Even though `Stack` methods are synchronized, method-level synchronization alone does not guarantee thread safety for **compound operations** or **sequences of method calls**. For example:

1. **Compound Operations:** If we need to perform multiple operations atomically (as a single unit of work), method-level synchronization is not sufficient.
   *   Example:

       ```java
       if (!stack.isEmpty()) {
           stack.pop();
       }
       ```

       * Here, another thread could modify the stack between the `isEmpty()` and `pop()` calls, leading to incorrect behavior or exceptions.
2.  **Manual Synchronization Block:** By synchronizing on the entire `Stack` object, we can ensure that the entire sequence of operations is performed atomically:

    ```java
    synchronized (stack) {
        if (!stack.isEmpty()) {
            stack.pop();
        }
    }
    ```

    * In this example, the `isEmpty()` check and `pop()` are both protected within the same synchronization block.
{% endhint %}

## Why Stack is Not Recommended in Modern java?

In modern Java development, **`Stack`** is generally not recommended due to several reasons. These are related to its design, inefficiencies, and better alternatives that have emerged in the Java Collections Framework.

### **1. Legacy Design**

* **`Stack`** is a part of the **legacy collections** (introduced in JDK 1.0) and extends **`Vector`**, another legacy class.
* **`Vector`** is synchronized, which makes **`Stack`** synchronized by inheritance. This synchronization is often unnecessary and can lead to performance bottlenecks.

### **2. Synchronized by Default**

* The synchronization in `Stack` is not fine-grained or optional. This makes it slower compared to alternatives like `ArrayDeque` when synchronization is not required.
* Modern Java provides thread-safe data structures like **`ConcurrentLinkedDeque`** or **`LinkedBlockingDeque`**, which are more efficient for concurrent environments.

### **3. Inefficient for Stack Operations**

* `Stack` inherits many irrelevant methods from `Vector`, like `insertElementAt`, which don't align with the stack principle of Last-In-First-Out (LIFO).
* These methods clutter the API and make it less intuitive for stack-specific operations.
* Modern alternatives like **`ArrayDeque`** are specifically designed for stack and queue operations.

### **4. Better Alternatives**

* **`ArrayDeque`**: This is the recommended class for stack operations in modern Java. It is faster, more memory-efficient, and does not have the unnecessary overhead of synchronization unless explicitly needed.

```java
Deque<Integer> stack = new ArrayDeque<>();
stack.push(10);
stack.push(20);
System.out.println(stack.pop()); // Output: 20
```

* **`LinkedList`**: It also implements the `Deque` interface and can be used for stack-like operations, though `ArrayDeque`is preferred for performance reasons.

### **5. Poor Memory and Performance Management**

* The resizing mechanism of `Vector` (and thus `Stack`) is not as optimized as modern implementations.
* Modern classes like `ArrayDeque` use an adaptive resizing strategy that is more efficient for growing and shrinking the stack.

### **6. Lack of Modern Features**

* **`Stack`** does not support features like lambdas, streams, or functional programming constructs seamlessly, which are common in modern Java practices.

## **When to Use Stack ?**

* **Expression Evaluation:** Useful in evaluating postfix or prefix expressions.
* **Undo Mechanism:** Often used in undo operations (LIFO order).
* **Backtracking Algorithms:** Useful in problems such as maze solvers or recursive algorithms.
* **Browser History Navigation:** Browsers use stacks to store previous pages to support the "Back" button functionality.
