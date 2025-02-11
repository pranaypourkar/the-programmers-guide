# Max Heap Implementation

## About

A **Max Heap** is a **binary heap** where the **parent node is always greater than its children**. The largest element is stored at the **root**.

## **Operations Supported:**

* **Insert (O(log n))** → When we insert into a max heap, we start by inserting the element at the bottom (rightmost spot to maintain the complete tree property).\
  Then, we fix the tree by swapping the new element with its parent until we find an appropriate spot for the element. We essentially **bubble up** the maximum element.
* **Extract Max (O(log n))** → The root (max element) is removed and replaced with the last element.\
  We then **heapify down**, swapping the new root with its largest child until the heap property is restored.
* **Peek Max (O(1))** → Retrieve the maximum element (root) without removing it.
* **Heapify (O(log n))** → Maintains the heap property after insertion or deletion.

## **Max Heap Implementation in Java**

```java
import java.util.Arrays;

class MaxHeap {
    private int[] heap;
    private int size;
    private int capacity;

    public MaxHeap(int capacity) {
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
        while (index > 0 && heap[parent(index)] < heap[index]) {
            swap(index, parent(index));
            index = parent(index);
        }
    }

    // Extract the maximum (root) element
    public int extractMax() {
        if (size == 0) throw new IllegalStateException("Heap is empty!");
        int max = heap[0];
        heap[0] = heap[size - 1]; // Replace root with last element
        size--;
        heapifyDown(0);
        return max;
    }

    // Heapify down (bubble down)
    private void heapifyDown(int index) {
        while (true) {
            int largest = index;
            int left = leftChild(index);
            int right = rightChild(index);

            if (left < size && heap[left] > heap[largest]) largest = left;
            if (right < size && heap[right] > heap[largest]) largest = right;

            if (largest == index) break;
            swap(index, largest);
            index = largest;
        }
    }

    // Get the maximum value (without removing)
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

// Main class to test Max Heap
public class MaxHeapDemo {
    public static void main(String[] args) {
        MaxHeap maxHeap = new MaxHeap(10);
        
        maxHeap.insert(20);
        maxHeap.insert(15);
        maxHeap.insert(30);
        maxHeap.insert(10);
        maxHeap.insert(40);

        System.out.println("Heap after insertions:");
        maxHeap.printHeap(); // Expected: [40, 30, 20, 10, 15]

        System.out.println("Extracted Max: " + maxHeap.extractMax()); // Expected: 40
        maxHeap.printHeap(); // Expected: [30, 15, 20, 10]

        System.out.println("Peek Max: " + maxHeap.peek()); // Expected: 30
    }
}
```

## **Time Complexity**

| Operation   | Time Complexity |
| ----------- | --------------- |
| Insert      | O(log n)        |
| Extract Max | O(log n)        |
| Peek Max    | O(1)            |
| Heapify     | O(log n)        |
