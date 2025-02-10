# Binary Search Tree Implementation

## About

A **Binary Search Tree (BST)** is a **binary tree** where:

* **Left child** contains values **less than** the parent node.
* **Right child** contains values **greater than** the parent node.
* No duplicate values are allowed.

1. **TreeNode Class** – Represents a node with `data`, `left`, and `right` references.
2. **BinarySearchTree Class** – Implements common BST operations:
   * Insert
   * Search
   * Traversals (Inorder, Preorder, Postorder)
   * Deletion
   * Level-order traversal (BFS)

## **Java Implementation**

```java
// Node class representing each element in the BST
class TreeNode {
    int data;
    TreeNode left, right;

    public TreeNode(int data) {
        this.data = data;
        this.left = this.right = null;
    }
}

// BST class implementing insert, search, delete, and traversals
class BinarySearchTree {
    private TreeNode root;

    public BinarySearchTree() {
        this.root = null;
    }

    // Insert a new value into the BST
    public void insert(int value) {
        root = insertRec(root, value);
    }

    private TreeNode insertRec(TreeNode root, int value) {
        if (root == null) {
            return new TreeNode(value);
        }
        if (value < root.data) {
            root.left = insertRec(root.left, value);
        } else if (value > root.data) {
            root.right = insertRec(root.right, value);
        }
        return root;
    }

    // Search for a value in the BST
    public boolean search(int value) {
        return searchRec(root, value);
    }

    private boolean searchRec(TreeNode root, int value) {
        if (root == null) return false;
        if (root.data == value) return true;
        return value < root.data ? searchRec(root.left, value) : searchRec(root.right, value);
    }

    // Delete a node from the BST
    public void delete(int value) {
        root = deleteRec(root, value);
    }

    private TreeNode deleteRec(TreeNode root, int value) {
        if (root == null) return null;

        if (value < root.data) {
            root.left = deleteRec(root.left, value);
        } else if (value > root.data) {
            root.right = deleteRec(root.right, value);
        } else {
            // Case 1: Node with one child or no child
            if (root.left == null) return root.right;
            if (root.right == null) return root.left;

            // Case 2: Node with two children – find inorder successor (smallest in right subtree)
            root.data = minValue(root.right);
            root.right = deleteRec(root.right, root.data);
        }
        return root;
    }

    private int minValue(TreeNode root) {
        int minVal = root.data;
        while (root.left != null) {
            minVal = root.left.data;
            root = root.left;
        }
        return minVal;
    }

    // Inorder traversal (Left, Root, Right) – Sorted order
    public void inorder() {
        inorderRec(root);
        System.out.println();
    }

    private void inorderRec(TreeNode root) {
        if (root != null) {
            inorderRec(root.left);
            System.out.print(root.data + " ");
            inorderRec(root.right);
        }
    }

    // Preorder traversal (Root, Left, Right)
    public void preorder() {
        preorderRec(root);
        System.out.println();
    }

    private void preorderRec(TreeNode root) {
        if (root != null) {
            System.out.print(root.data + " ");
            preorderRec(root.left);
            preorderRec(root.right);
        }
    }

    // Postorder traversal (Left, Right, Root)
    public void postorder() {
        postorderRec(root);
        System.out.println();
    }

    private void postorderRec(TreeNode root) {
        if (root != null) {
            postorderRec(root.left);
            postorderRec(root.right);
            System.out.print(root.data + " ");
        }
    }

    // Level-order traversal (BFS using queue)
    public void levelOrder() {
        if (root == null) return;
        Queue<TreeNode> queue = new LinkedList<>();
        queue.add(root);
        while (!queue.isEmpty()) {
            TreeNode tempNode = queue.poll();
            System.out.print(tempNode.data + " ");
            if (tempNode.left != null) queue.add(tempNode.left);
            if (tempNode.right != null) queue.add(tempNode.right);
        }
        System.out.println();
    }
}

// Main class to test BST implementation
public class BSTDemo {
    public static void main(String[] args) {
        BinarySearchTree bst = new BinarySearchTree();

        // Insert elements into BST
        bst.insert(50);
        bst.insert(30);
        bst.insert(70);
        bst.insert(20);
        bst.insert(40);
        bst.insert(60);
        bst.insert(80);

        System.out.println("Inorder traversal (Sorted order):");
        bst.inorder(); // 20 30 40 50 60 70 80

        System.out.println("Preorder traversal:");
        bst.preorder(); // 50 30 20 40 70 60 80

        System.out.println("Postorder traversal:");
        bst.postorder(); // 20 40 30 60 80 70 50

        System.out.println("Level order traversal:");
        bst.levelOrder(); // 50 30 70 20 40 60 80

        // Search for a value
        System.out.println("Search 40: " + bst.search(40)); // true
        System.out.println("Search 100: " + bst.search(100)); // false

        // Delete a node
        bst.delete(50);
        System.out.println("Inorder after deleting 50:");
        bst.inorder(); // 20 30 40 60 70 80
    }
}
```

## **Explanation of Methods**

| **Method**      | **Description**                                             |
| --------------- | ----------------------------------------------------------- |
| `insert(value)` | Inserts a new value in the BST.                             |
| `search(value)` | Searches for a value in the BST. Returns `true` if found.   |
| `delete(value)` | Deletes a value from the BST, handling different cases.     |
| `inorder()`     | Prints nodes in **sorted order** (Left → Root → Right).     |
| `preorder()`    | Prints nodes in **root-first order** (Root → Left → Right). |
| `postorder()`   | Prints nodes in **root-last order** (Left → Right → Root).  |
| `levelOrder()`  | Prints nodes **level-wise** (Breadth-First Search).         |

## **Time Complexity**

| **Operation** | **Best Case (Balanced Tree)** | **Worst Case (Skewed Tree)** |
| ------------- | ----------------------------- | ---------------------------- |
| Insert        | O(log N)                      | O(N)                         |
| Search        | O(log N)                      | O(N)                         |
| Delete        | O(log N)                      | O(N)                         |
| Traversal     | O(N)                          | O(N)                         |
