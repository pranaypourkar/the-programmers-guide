# Custom Queue

## About

A **Queue** follows the **FIFO (First In, First Out)** principle, meaning the first element added is the first one removed.

## 1. LinkedList-based Queue

For a **linked list-based queue**, we maintain:

* A **front** pointer (points to the first element)
* A **rear** pointer (points to the last element)

### **Node Class**

Each element in the queue is stored in a **Node**, which contains:

* `data`: The value of the node
* `next`: Pointer to the next node

```java
class Node<E> {
    E data;
    Node<E> next;

    Node(E data) {
        this.data = data;
        this.next = null;
    }
}
```

### **Queue Class**

```java
public class CustomLinkedListQueue<E> {
    private Node<E> front, rear;
    private int size;

    public CustomLinkedListQueue() {
        this.front = this.rear = null;
        this.size = 0;
    }
}
```

### **Core Operations**

**Enqueue (Add an element to the rear)**

```java
public void enqueue(E data) {
    Node<E> newNode = new Node<>(data);

    if (rear == null) { // Empty queue case
        front = rear = newNode;
    } else {
        rear.next = newNode;
        rear = newNode;
    }
    size++;
}
```

**Dequeue (Remove and return the front element)**

```java
public E dequeue() {
    if (isEmpty()) throw new RuntimeException("Queue is empty");

    E data = front.data;
    front = front.next;

    if (front == null) rear = null; // Queue is now empty
    size--;
    return data;
}
```

**Peek (View the front element without removing it)**

```java
public E peek() {
    if (isEmpty()) throw new RuntimeException("Queue is empty");
    return front.data;
}
```

**Check if Queue is Empty**

```java
public boolean isEmpty() {
    return front == null;
}
```

**Get Queue Size**

```java
public int size() {
    return size;
}
```

**Print Queue**

```java
public void printQueue() {
    Node<E> current = front;
    while (current != null) {
        System.out.print(current.data + " -> ");
        current = current.next;
    }
    System.out.println("null");
}
```

### **Complete Custom Queue Implementation**

```java
public class CustomLinkedListQueue<E> {
    private Node<E> front, rear;
    private int size;

    public CustomLinkedListQueue() {
        this.front = this.rear = null;
        this.size = 0;
    }

    public void enqueue(E data) {
        Node<E> newNode = new Node<>(data);

        if (rear == null) {
            front = rear = newNode;
        } else {
            rear.next = newNode;
            rear = newNode;
        }
        size++;
    }

    public E dequeue() {
        if (isEmpty()) throw new RuntimeException("Queue is empty");

        E data = front.data;
        front = front.next;

        if (front == null) rear = null;
        size--;
        return data;
    }

    public E peek() {
        if (isEmpty()) throw new RuntimeException("Queue is empty");
        return front.data;
    }

    public boolean isEmpty() {
        return front == null;
    }

    public int size() {
        return size;
    }

    public void printQueue() {
        Node<E> current = front;
        while (current != null) {
            System.out.print(current.data + " -> ");
            current = current.next;
        }
        System.out.println("null");
    }

    public static void main(String[] args) {
        CustomLinkedListQueue<Integer> queue = new CustomLinkedListQueue<>();
        queue.enqueue(10);
        queue.enqueue(20);
        queue.enqueue(30);
        queue.printQueue(); // Output: 10 -> 20 -> 30 -> null

        System.out.println("Front element: " + queue.peek()); // Output: 10
        System.out.println("Dequeued: " + queue.dequeue()); // Output: 10
        queue.printQueue(); // Output: 20 -> 30 -> null

        System.out.println("Queue size: " + queue.size()); // Output: 2
    }
}
```

### **Time Complexity Analysis**

| Operation                  | Complexity |
| -------------------------- | ---------- |
| Enqueue (`enqueue`)        | **O(1)**   |
| Dequeue (`dequeue`)        | **O(1)**   |
| Peek (`peek`)              | **O(1)**   |
| Is Empty (`isEmpty`)       | **O(1)**   |
| Get Size (`size`)          | **O(1)**   |
| Print Queue (`printQueue`) | **O(n)**   |

## 2. Array-based Queue

### **Queue Data Structure**

For an **array-based queue**, we maintain:

* A **front** pointer (points to the first element)
* A **rear** pointer (points to the last element)
* A **size** variable to track the number of elements
* A **fixed-size array** to store elements

### **Queue Class Definition**

```java
public class CustomArrayQueue<E> {
    private E[] queue;
    private int front, rear, size, capacity;

    @SuppressWarnings("unchecked")
    public CustomArrayQueue(int capacity) {
        this.capacity = capacity;
        this.queue = (E[]) new Object[capacity];
        this.front = this.size = 0;
        this.rear = -1;
    }
}
```

* The queue is initialized with a fixed size.
* `front` points to the first element.
* `rear` tracks the last inserted element.
* `size` keeps track of the number of elements.

### **Core Operations**

**Enqueue (Add an element at the rear)**

```java
public void enqueue(E data) {
    if (size == capacity) throw new RuntimeException("Queue is full");

    rear = (rear + 1) % capacity; // Circular increment
    queue[rear] = data;
    size++;
}
```

**Dequeue (Remove and return the front element)**

```java
public E dequeue() {
    if (isEmpty()) throw new RuntimeException("Queue is empty");

    E data = queue[front];
    queue[front] = null; // Help GC
    front = (front + 1) % capacity; // Circular increment
    size--;
    return data;
}
```

**Peek (View the front element without removing it)**

```java
public E peek() {
    if (isEmpty()) throw new RuntimeException("Queue is empty");
    return queue[front];
}
```

**Check if Queue is Empty**

```java
public boolean isEmpty() {
    return size == 0;
}
```

**Check if Queue is Full**

```java
public boolean isFull() {
    return size == capacity;
}
```

**Get Queue Size**

```java
public int size() {
    return size;
}
```

**Print Queue**

```java
public void printQueue() {
    if (isEmpty()) {
        System.out.println("Queue is empty");
        return;
    }

    System.out.print("Queue: ");
    for (int i = 0; i < size; i++) {
        System.out.print(queue[(front + i) % capacity] + " ");
    }
    System.out.println();
}
```

### **Complete Custom Queue Implementation**

```java
public class CustomArrayQueue<E> {
    private E[] queue;
    private int front, rear, size, capacity;

    @SuppressWarnings("unchecked")
    public CustomArrayQueue(int capacity) {
        this.capacity = capacity;
        this.queue = (E[]) new Object[capacity];
        this.front = this.size = 0;
        this.rear = -1;
    }

    public void enqueue(E data) {
        if (size == capacity) throw new RuntimeException("Queue is full");

        rear = (rear + 1) % capacity; // Circular increment
        queue[rear] = data;
        size++;
    }

    public E dequeue() {
        if (isEmpty()) throw new RuntimeException("Queue is empty");

        E data = queue[front];
        queue[front] = null; // Help GC
        front = (front + 1) % capacity; // Circular increment
        size--;
        return data;
    }

    public E peek() {
        if (isEmpty()) throw new RuntimeException("Queue is empty");
        return queue[front];
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public boolean isFull() {
        return size == capacity;
    }

    public int size() {
        return size;
    }

    public void printQueue() {
        if (isEmpty()) {
            System.out.println("Queue is empty");
            return;
        }

        System.out.print("Queue: ");
        for (int i = 0; i < size; i++) {
            System.out.print(queue[(front + i) % capacity] + " ");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        CustomArrayQueue<Integer> queue = new CustomArrayQueue<>(5);

        queue.enqueue(10);
        queue.enqueue(20);
        queue.enqueue(30);
        queue.printQueue(); // Output: Queue: 10 20 30

        System.out.println("Front element: " + queue.peek()); // Output: 10
        System.out.println("Dequeued: " + queue.dequeue()); // Output: 10
        queue.printQueue(); // Output: Queue: 20 30

        System.out.println("Queue size: " + queue.size()); // Output: 2
    }
}
```

### **Time Complexity Analysis**

| Operation                  | Complexity |
| -------------------------- | ---------- |
| Enqueue (`enqueue`)        | **O(1)**   |
| Dequeue (`dequeue`)        | **O(1)**   |
| Peek (`peek`)              | **O(1)**   |
| Is Empty (`isEmpty`)       | **O(1)**   |
| Is Full (`isFull`)         | **O(1)**   |
| Get Size (`size`)          | **O(1)**   |
| Print Queue (`printQueue`) | **O(n)**   |

