# Custom Stack

## About

A **stack** follows the **LIFO (Last In, First Out)** principle. The main operations in a stack are:

* **Push** (Add an element)
* **Pop** (Remove the top element)
* **Peek** (View the top element)
* **isEmpty** (Check if the stack is empty)

There are 2 ways to implement Stack i.e.

1. LinkedList-based Stack (Dynamic size)
2. Array-based Stack (Fixed size)

## 1. LinkedList-based Stack

### **Stack Data Structure**

Each node contains:

* A **data value**
* A **reference to the next node**

Here's the **Node class**:

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

### **Stack Class**

The `CustomStack` class will maintain:

* A **top** node (points to the last added element)
* The **size** of the stack

```java
public class CustomStack<E> {
    private Node<E> top;
    private int size;

    public CustomStack() {
        this.top = null;
        this.size = 0;
    }
}
```

### **Core Operations**

Below are the essential operations for a **stack**.

**Push (Add Element)**

```java
public void push(E data) {
    Node<E> newNode = new Node<>(data);
    newNode.next = top;
    top = newNode;
    size++;
}
```

**Pop (Remove and Return the Top Element)**

```java
public E pop() {
    if (isEmpty()) throw new RuntimeException("Stack is empty");

    E data = top.data;
    top = top.next;
    size--;
    return data;
}
```

**Peek (View Top Element Without Removing)**

```java
public E peek() {
    if (isEmpty()) throw new RuntimeException("Stack is empty");
    return top.data;
}
```

**Check if Stack is Empty**

```java
public boolean isEmpty() {
    return top == null;
}
```

**Get Stack Size**

```java
public int size() {
    return size;
}
```

**Print Stack**

```java
public void printStack() {
    Node<E> temp = top;
    while (temp != null) {
        System.out.print(temp.data + " -> ");
        temp = temp.next;
    }
    System.out.println("null");
}
```

### **Complete Custom Stack Implementation**

```java
public class CustomStack<E> {
    private Node<E> top;
    private int size;

    private static class Node<E> {
        E data;
        Node<E> next;

        Node(E data) {
            this.data = data;
            this.next = null;
        }
    }

    public CustomStack() {
        this.top = null;
        this.size = 0;
    }

    public void push(E data) {
        Node<E> newNode = new Node<>(data);
        newNode.next = top;
        top = newNode;
        size++;
    }

    public E pop() {
        if (isEmpty()) throw new RuntimeException("Stack is empty");

        E data = top.data;
        top = top.next;
        size--;
        return data;
    }

    public E peek() {
        if (isEmpty()) throw new RuntimeException("Stack is empty");
        return top.data;
    }

    public boolean isEmpty() {
        return top == null;
    }

    public int size() {
        return size;
    }

    public void printStack() {
        Node<E> temp = top;
        while (temp != null) {
            System.out.print(temp.data + " -> ");
            temp = temp.next;
        }
        System.out.println("null");
    }

    public static void main(String[] args) {
        CustomStack<Integer> stack = new CustomStack<>();
        stack.push(10);
        stack.push(20);
        stack.push(30);
        stack.printStack(); // Output: 30 -> 20 -> 10 -> null

        System.out.println("Top element: " + stack.peek()); // Output: 30
        System.out.println("Popped: " + stack.pop()); // Output: 30
        stack.printStack(); // Output: 20 -> 10 -> null

        System.out.println("Stack size: " + stack.size()); // Output: 2
    }
}
```

### **Time Complexity Analysis**

| Operation                  | Complexity |
| -------------------------- | ---------- |
| Push (`push`)              | **O(1)**   |
| Pop (`pop`)                | **O(1)**   |
| Peek (`peek`)              | **O(1)**   |
| Is Empty (`isEmpty`)       | **O(1)**   |
| Get Size (`size`)          | **O(1)**   |
| Print Stack (`printStack`) | **O(n)**   |

## 2. Array-based Stack

### **Stack Data Structure**

For an **array-based stack**, we maintain:

* An **array** to store elements
* A **top** pointer to track the topmost element
* A **size** to track the number of elements

### **Stack Class**

```java
public class CustomArrayStack<E> {
    private E[] stack;
    private int top;
    private int capacity;

    public CustomArrayStack(int capacity) {
        this.capacity = capacity;
        this.stack = (E[]) new Object[capacity]; // Generic array creation
        this.top = -1; // Stack is empty initially
    }
}
```

### **Core Operations**

**Push (Add Element)**

```java
public void push(E data) {
    if (top == capacity - 1) throw new RuntimeException("Stack Overflow");

    stack[++top] = data;
}
```

**Pop (Remove and Return the Top Element)**

```java
public E pop() {
    if (isEmpty()) throw new RuntimeException("Stack is empty");

    E data = stack[top];
    stack[top--] = null; // Prevent memory leak
    return data;
}
```

**Peek (View Top Element Without Removing)**

```java
public E peek() {
    if (isEmpty()) throw new RuntimeException("Stack is empty");
    return stack[top];
}
```

**Check if Stack is Empty**

```java
public boolean isEmpty() {
    return top == -1;
}
```

**Get Stack Size**

```java
public int size() {
    return top + 1;
}
```

**Print Stack**

```java
public void printStack() {
    for (int i = top; i >= 0; i--) {
        System.out.print(stack[i] + " -> ");
    }
    System.out.println("null");
}
```

### **Complete Custom Stack Implementation**

```java
public class CustomArrayStack<E> {
    private E[] stack;
    private int top;
    private int capacity;

    @SuppressWarnings("unchecked")
    public CustomArrayStack(int capacity) {
        this.capacity = capacity;
        this.stack = (E[]) new Object[capacity];
        this.top = -1;
    }

    public void push(E data) {
        if (top == capacity - 1) throw new RuntimeException("Stack Overflow");
        stack[++top] = data;
    }

    public E pop() {
        if (isEmpty()) throw new RuntimeException("Stack is empty");

        E data = stack[top];
        stack[top--] = null; // Avoid memory leak
        return data;
    }

    public E peek() {
        if (isEmpty()) throw new RuntimeException("Stack is empty");
        return stack[top];
    }

    public boolean isEmpty() {
        return top == -1;
    }

    public int size() {
        return top + 1;
    }

    public void printStack() {
        for (int i = top; i >= 0; i--) {
            System.out.print(stack[i] + " -> ");
        }
        System.out.println("null");
    }

    public static void main(String[] args) {
        CustomArrayStack<Integer> stack = new CustomArrayStack<>(5);
        stack.push(10);
        stack.push(20);
        stack.push(30);
        stack.printStack(); // Output: 30 -> 20 -> 10 -> null

        System.out.println("Top element: " + stack.peek()); // Output: 30
        System.out.println("Popped: " + stack.pop()); // Output: 30
        stack.printStack(); // Output: 20 -> 10 -> null

        System.out.println("Stack size: " + stack.size()); // Output: 2
    }
}
```

### **Time Complexity Analysis**

| Operation                  | Complexity |
| -------------------------- | ---------- |
| Push (`push`)              | **O(1)**   |
| Pop (`pop`)                | **O(1)**   |
| Peek (`peek`)              | **O(1)**   |
| Is Empty (`isEmpty`)       | **O(1)**   |
| Get Size (`size`)          | **O(1)**   |
| Print Stack (`printStack`) | **O(n)**   |

