# Custom LinkedList

## **About**

Implement a custom doubly linked list and add various operation

## **1. Data Structure**

A **LinkedList** consists of **nodes** where each node stores:

* A **data** value
* A **reference to the next node** (`next`)
* A **reference to the previous node** (`prev`) in the case of a **doubly linked list**.

Here’s how we define the **Node class**:

```java
class Node<E> {
    E data;
    Node<E> next;
    Node<E> prev;

    Node(E data) {
        this.data = data;
        this.next = null;
        this.prev = null;
    }
}
```

{% hint style="success" %}
We will keep it as static class in the custom linked list class otherwise every `Node<E>` will store an extra hidden reference to `CustomLinkedList<E>`, even though it doesn’t need it. Using `private static class Node<E>` eliminates this unnecessary reference.
{% endhint %}

## **2. LinkedList Class**

Our `CustomLinkedList` will maintain:

* A **head** (first node)
* A **tail** (last node)
* The **size** of the list

```java
public class CustomLinkedList<E> {
    private Node<E> head;
    private Node<E> tail;
    private int size;

    public CustomLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }
}
```

## **3. Core Operations**

Below are the essential operations for a **doubly linked list**.

### **3.1 Add Element at End (`addLast`)**

```java
public void addLast(E data) {
    Node<E> newNode = new Node<>(data);
    if (head == null) {  // Empty list
        head = tail = newNode;
    } else {
        tail.next = newNode;
        newNode.prev = tail;
        tail = newNode;
    }
    size++;
}
```

### **3.2 Add Element at Beginning (`addFirst`)**

```java
public void addFirst(E data) {
    Node<E> newNode = new Node<>(data);
    if (head == null) {
        head = tail = newNode;
    } else {
        newNode.next = head;
        head.prev = newNode;
        head = newNode;
    }
    size++;
}
```

### **3.3 Remove Element from End (`removeLast`)**

```java
public E removeLast() {
    if (tail == null) throw new RuntimeException("List is empty");
    
    E data = tail.data;
    if (head == tail) {  // Only one element
        head = tail = null;
    } else {
        tail = tail.prev;
        tail.next = null;
    }
    size--;
    return data;
}
```

### **3.4 Remove Element from Beginning (`removeFirst`)**

```java
public E removeFirst() {
    if (head == null) throw new RuntimeException("List is empty");

    E data = head.data;
    if (head == tail) {  // Only one element
        head = tail = null;
    } else {
        head = head.next;
        head.prev = null;
    }
    size--;
    return data;
}
```

### **3.5 Get Element at Index (`get`)**

```java
public E get(int index) {
    if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
    
    Node<E> temp = head;
    for (int i = 0; i < index; i++) {
        temp = temp.next;
    }
    return temp.data;
}
```

### **3.6 Print LinkedList (`printList`)**

```java
public void printList() {
    Node<E> temp = head;
    while (temp != null) {
        System.out.print(temp.data + " <-> ");
        temp = temp.next;
    }
    System.out.println("null");
}
```

## **4. Complete Custom LinkedList Implementation**

```java
public class CustomLinkedList<E> {
    private Node<E> head;
    private Node<E> tail;
    private int size;

    private static class Node<E> {
        E data;
        Node<E> next;
        Node<E> prev;

        Node(E data) {
            this.data = data;
            this.next = null;
            this.prev = null;
        }
    }

    public CustomLinkedList() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }

    public void addLast(E data) {
        Node<E> newNode = new Node<>(data);
        if (head == null) {
            head = tail = newNode;
        } else {
            tail.next = newNode;
            newNode.prev = tail;
            tail = newNode;
        }
        size++;
    }

    public void addFirst(E data) {
        Node<E> newNode = new Node<>(data);
        if (head == null) {
            head = tail = newNode;
        } else {
            newNode.next = head;
            head.prev = newNode;
            head = newNode;
        }
        size++;
    }

    public E removeLast() {
        if (tail == null) throw new RuntimeException("List is empty");

        E data = tail.data;
        if (head == tail) {
            head = tail = null;
        } else {
            tail = tail.prev;
            tail.next = null;
        }
        size--;
        return data;
    }

    public E removeFirst() {
        if (head == null) throw new RuntimeException("List is empty");

        E data = head.data;
        if (head == tail) {
            head = tail = null;
        } else {
            head = head.next;
            head.prev = null;
        }
        size--;
        return data;
    }

    public E get(int index) {
        if (index < 0 || index >= size) throw new IndexOutOfBoundsException();
        
        Node<E> temp = head;
        for (int i = 0; i < index; i++) {
            temp = temp.next;
        }
        return temp.data;
    }

    public void printList() {
        Node<E> temp = head;
        while (temp != null) {
            System.out.print(temp.data + " <-> ");
            temp = temp.next;
        }
        System.out.println("null");
    }

    public static void main(String[] args) {
        CustomLinkedList<Integer> list = new CustomLinkedList<>();
        list.addLast(10);
        list.addLast(20);
        list.addLast(30);
        list.printList();  // Output: 10 <-> 20 <-> 30 <-> null

        list.addFirst(5);
        list.printList();  // Output: 5 <-> 10 <-> 20 <-> 30 <-> null

        list.removeFirst();
        list.printList();  // Output: 10 <-> 20 <-> 30 <-> null

        list.removeLast();
        list.printList();  // Output: 10 <-> 20 <-> null
    }
}
```

## **5. Time Complexity Analysis**

| Operation                                 | Complexity |
| ----------------------------------------- | ---------- |
| Add at the end (`addLast`)                | **O(1)**   |
| Add at the beginning (`addFirst`)         | **O(1)**   |
| Remove from the end (`removeLast`)        | **O(1)**   |
| Remove from the beginning (`removeFirst`) | **O(1)**   |
| Get element at index (`get`)              | **O(n)**   |
| Print list (`printList`)                  | **O(n)**   |
