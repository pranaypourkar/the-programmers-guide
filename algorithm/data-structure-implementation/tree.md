# Tree

## About

Trees can be implemented in Java using different approaches based on the underlying data structure. The three most common ways are:

1. **Using Classes and Objects** (Explicitly defining a `Node` class)
2. **Using Arrays** (Implicit tree representation)
3. **Using Linked Nodes** (Each node storing references to children)

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Structure</strong></td><td><strong>Commonly Used In</strong></td></tr><tr><td><strong>1. Using Classes and Objects</strong></td><td>Each node is an object with left and right child references</td><td>Binary Trees (BST, AVL, Red-Black Trees)</td></tr><tr><td><strong>2. Using Arrays</strong></td><td>The tree is stored in a fixed-size array with index-based relationships</td><td>Heap, Complete Binary Trees</td></tr><tr><td><strong>3. Using Linked Nodes</strong></td><td>Each node stores a list or array of references to its children</td><td>N-ary Trees, Trie, General Trees</td></tr></tbody></table>

## 1. Using Classes and Objects

### **Structure**

* Each node is an instance of a **Node class**, containing:
  * **Data (value of the node)**
  * **Left child reference**
  * **Right child reference** (for binary trees)
* The `TreeNode` class can be used to build **Binary Search Trees (BST), AVL Trees, and Red-Black Trees**.

### **Example**

```java
class TreeNode {
    int data;
    TreeNode left, right;

    public TreeNode(int data) {
        this.data = data;
        this.left = this.right = null;
    }
}
```

### **Advantages**

* **Flexible** – Suitable for various tree types
* **Easier to implement operations** (insert, delete, traverse)
* **Memory-efficient for sparse trees** (as only necessary nodes are allocated)

### **Disadvantages**

* **More memory overhead** due to object references
* **Extra pointer space required per node**

## **2. Using Arrays (Implicit Tree Representation)**

### **Structure**

* The tree is stored in an **array**, where:
  * **Root node is at index `0`**
  * **Left child of node `i` is at `2*i + 1`**
  * **Right child of node `i` is at `2*i + 2`**

### **Example**

```java
class ArrayTree {
    int[] tree;
    
    public ArrayTree(int size) {
        tree = new int[size]; // Fixed-size array
    }
}
```

### **Advantages**

* **Space-efficient for complete trees** (no extra pointers)
* **Better cache locality (faster access in memory)**

### **Disadvantages**

* **Wasted space for sparse trees**
* **Difficult to dynamically expand**
* **Harder to perform operations like insertion and deletion**

## **3. Using Linked Nodes (Each node storing references to children)**

### **Structure**

* Each node has:
  * **Data**
  * **List or array of references to children**

### **Example**

```java
import java.util.*;

class TreeNode {
    int data;
    List<TreeNode> children;

    public TreeNode(int data) {
        this.data = data;
        this.children = new ArrayList<>();
    }
}
```

### **Advantages**

* **Efficient for N-ary trees (Trie, QuadTree, etc.)**
* **Can handle variable number of children easily**

### **Disadvantages**

* **More memory overhead due to references**
* **Traversal can be complex compared to binary trees**

## **Which Method is Better?**

| **Method**            | **Best For**                  | **Commonly Used In**      |
| --------------------- | ----------------------------- | ------------------------- |
| **Class-based Nodes** | Most general-purpose trees    | BST, AVL, Red-Black Trees |
| **Array-based**       | Fixed structure, fast lookups | Heaps, Priority Queues    |
| **Linked Nodes**      | Variable number of children   | Trie, N-ary Trees         |

