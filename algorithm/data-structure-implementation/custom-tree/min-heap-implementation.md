# Min Heap Implementation

## About

A **Min Heap** is a **binary heap** where the **parent node is always smaller than its children**. The smallest element is stored at the **root**.

## **Operations Supported:**

* **Insert (O(log n))** → Add an element while maintaining heap order.&#x20;

{% hint style="info" %}
When we insert into a min-heap, we always start by inserting the element at the bottom. We insert at the rightmost spot so as to maintain the complete tree property. Then, we fix the tree by swapping the new element with its parent, until we find an appropriate spot for the element. We essentially bubble up the minimum element.
{% endhint %}

* **Extract Min (O(log n))** → Remove the smallest element.

{% hint style="info" %}
Removes and returns the smallest element (root) while maintaining heap order.

* The root node (minimum element) is removed.
* The last element in the heap is moved to the root to maintain the **complete tree property**.
* Then, the heap is restructured by **bubbling down** (heapify down) the new root to restore the heap property.
* We compare the new root with its smallest child and swap if necessary, repeating this process until the correct position is found.
{% endhint %}

* **Peek Min (O(1))** → Get the smallest element without removing it.

{% hint style="info" %}
Retrieves the minimum element without removing it.

* Since the **smallest element is always at the root** in a Min Heap, we simply return the root value.
* This operation is **constant time O(1)** because no restructuring is needed.
{% endhint %}

* **Heapify (O(log n))** → Maintain heap property after insertion or deletion.

{% hint style="info" %}
Ensures the heap property is maintained after insertion or deletion.

* **Heapify Up**: Used after insertion to **bubble up** the inserted element.
* **Heapify Down**: Used after deletion (Extract Min) to **bubble down** the root.
* Each step reduces the number of swaps exponentially, leading to **O(log n) complexity**.
{% endhint %}

## **Min Heap Implementation in Java**

```java
import java.util.Arrays;

class MinHeap {
    private int[] heap;
    private int size;
    private int capacity;

    public MinHeap(int capacity) {
        this.capacity = capacity;
        this.size = 0;
        this.heap = new int[capacity];
    }

    // Get parent and child indices
    private int parent(int i) { return (i - 1) / 2; }
    private int leftChild(int i) { return 2 * i + 1; }
    private int rightChild(int i) { return 2 * i + 2; }

    // Insert a new value into the heap
    public void insert(int value) {
        if (size == capacity) {
            System.out.println("Heap is full!");
            return;
        }
        heap[size] = value;
        size++;
        heapifyUp(size - 1);
    }

    // Heapify up (bubble up)
    private void heapifyUp(int index) {
        while (index > 0 && heap[parent(index)] > heap[index]) {
            swap(index, parent(index));
            index = parent(index);
        }
    }

    // Extract the minimum (root) element
    public int extractMin() {
        if (size == 0) throw new IllegalStateException("Heap is empty!");
        int min = heap[0];
        heap[0] = heap[size - 1]; // Replace root with last element
        size--;
        heapifyDown(0);
        return min;
    }

    // Heapify down (bubble down)
    private void heapifyDown(int index) {
        while (true) {
            int smallest = index;
            int left = leftChild(index);
            int right = rightChild(index);

            if (left < size && heap[left] < heap[smallest]) smallest = left;
            if (right < size && heap[right] < heap[smallest]) smallest = right;

            if (smallest == index) break;
            swap(index, smallest);
            index = smallest;
        }
    }

    // Get the minimum value (without removing)
    public int peek() {
        if (size == 0) throw new IllegalStateException("Heap is empty!");
        return heap[0];
    }

    // Swap two elements in the heap
    private void swap(int i, int j) {
        int temp = heap[i];
        heap[i] = heap[j];
        heap[j] = temp;
    }

    // Print the heap
    public void printHeap() {
        System.out.println(Arrays.toString(Arrays.copyOf(heap, size)));
    }
}

// Main class to test Min Heap
public class MinHeapDemo {
    public static void main(String[] args) {
        MinHeap minHeap = new MinHeap(10);
        
        minHeap.insert(20);
        minHeap.insert(15);
        minHeap.insert(30);
        minHeap.insert(10);
        minHeap.insert(40);

        System.out.println("Heap after insertions:");
        minHeap.printHeap(); // Expected: [10, 15, 30, 20, 40]

        System.out.println("Extracted Min: " + minHeap.extractMin()); // Expected: 10
        minHeap.printHeap(); // Expected: [15, 20, 30, 40]

        System.out.println("Peek Min: " + minHeap.peek()); // Expected: 15
    }
}
```

## **Time Complexity**

| Operation   | Time Complexity |
| ----------- | --------------- |
| Insert      | O(log n)        |
| Extract Min | O(log n)        |
| Peek Min    | O(1)            |
| Heapify     | O(log n)        |
