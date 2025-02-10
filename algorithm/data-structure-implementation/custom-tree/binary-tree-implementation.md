# Binary Tree Implementation

## About

A Binary Tree is a hierarchical data structure in which each node has at most two children (left and right).

1. **Node Class** – Represents a tree node with `data`, `left`, and `right` pointers.
2. **BinaryTree Class** – Implements common operations like **insertion, traversal, search, and deletion**.

## **Implementation**

```java
// Class representing a node in a binary tree
class TreeNode {
    int data;
    TreeNode left, right;

    public TreeNode(int data) {
        this.data = data;
        this.left = this.right = null;
    }
}

// Binary Tree class with insert, search, traversal, and deletion methods
class BinaryTree {
    private TreeNode root;

    public BinaryTree() {
        this.root = null;
    }

    // Insert a new node (recursive approach)
    public void insert(int value) {
        root = insertRec(root, value);
    }

    private TreeNode insertRec(TreeNode root, int value) {
        if (root == null) {
            return new TreeNode(value);
        }
        
        if (value < root.data) {
            root.left = insertRec(root.left, value);
        } else {
            root.right = insertRec(root.right, value);
        }
        return root;
    }

    // Search for a value in the tree
    public boolean search(int value) {
        return searchRec(root, value);
    }

    private boolean searchRec(TreeNode root, int value) {
        if (root == null) return false;
        if (root.data == value) return true;
        return value < root.data ? searchRec(root.left, value) : searchRec(root.right, value);
    }

    // Inorder traversal (Left, Root, Right)
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

    // Delete a node from the tree
    public void delete(int value) {
        root = deleteRec(root, value);
    }

    private TreeNode deleteRec(TreeNode root, int value) {
        if (root == null) return root;

        if (value < root.data) {
            root.left = deleteRec(root.left, value);
        } else if (value > root.data) {
            root.right = deleteRec(root.right, value);
        } else {
            // Node with only one child or no child
            if (root.left == null) return root.right;
            else if (root.right == null) return root.left;

            // Node with two children: get inorder successor (smallest in the right subtree)
            root.data = minValue(root.right);

            // Delete the inorder successor
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

    // Print tree in level order (BFS traversal)
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

// Main class to test BinaryTree implementation
public class BinaryTreeDemo {
    public static void main(String[] args) {
        BinaryTree tree = new BinaryTree();

        // Insert nodes
        tree.insert(50);
        tree.insert(30);
        tree.insert(70);
        tree.insert(20);
        tree.insert(40);
        tree.insert(60);
        tree.insert(80);

        System.out.println("Inorder traversal:");
        tree.inorder(); // 20 30 40 50 60 70 80

        System.out.println("Preorder traversal:");
        tree.preorder(); // 50 30 20 40 70 60 80

        System.out.println("Postorder traversal:");
        tree.postorder(); // 20 40 30 60 80 70 50

        System.out.println("Level order traversal:");
        tree.levelOrder(); // 50 30 70 20 40 60 80

        // Search for a value
        System.out.println("Search 40: " + tree.search(40)); // true
        System.out.println("Search 100: " + tree.search(100)); // false

        // Delete a node
        tree.delete(50);
        System.out.println("Inorder after deleting 50:");
        tree.inorder(); // 20 30 40 60 70 80
    }
}
```

{% hint style="success" %}
#### **How Does It Ensure At Most Two Children?**

In the `insertRec()` method,

* If the value is **less than** the current node’s data, it is placed in the **left** child.
* If the value is **greater than or equal to** the current node’s data, it is placed in the **right** child.
* Since each node can have **only one left and one right child**, it enforces the rule of at most **two children per node**.
{% endhint %}

## **Methods**

| **Method**      | **Description**                                             |
| --------------- | ----------------------------------------------------------- |
| `insert(value)` | Inserts a new value in the tree.                            |
| `search(value)` | Searches for a value in the tree. Returns `true` if found.  |
| `delete(value)` | Deletes a value from the tree, handling all deletion cases. |
| `inorder()`     | Prints nodes in **sorted order** (Left → Root → Right).     |
| `preorder()`    | Prints nodes in **root-first order** (Root → Left → Right). |
| `postorder()`   | Prints nodes in **root-last order** (Left → Right → Root).  |
| `levelOrder()`  | Prints nodes **level-wise** (Breadth-First Search).         |

## **Time Complexity**

| **Operation** | **Best Case** | **Worst Case (Skewed Tree)** | **Balanced Tree** |
| ------------- | ------------- | ---------------------------- | ----------------- |
| Insert        | O(log N)      | O(N)                         | O(log N)          |
| Search        | O(log N)      | O(N)                         | O(log N)          |
| Delete        | O(log N)      | O(N)                         | O(log N)          |
| Traversal     | O(N)          | O(N)                         | O(N)              |
