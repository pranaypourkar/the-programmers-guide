# Graph Traversal Techniques

## About

Graph traversal is the process of visiting all the nodes (vertices) in a graph in a specific manner. It is essential for various applications like **pathfinding, connectivity checking, and network analysis**. There are two primary techniques:

* **Depth First Search (DFS)**
* **Breadth First Search (BFS)**

Each technique has unique properties, use cases, and performance characteristics.

## **1. Depth-First Search (DFS)**

### **About DFS**

Depth-First Search is a traversal algorithm that explores as far as possible along one branch before backtracking. It follows the "depth" path first and only moves to another branch when it cannot proceed further.

### **Characteristics of DFS**

* **Recursive or Stack-Based:** DFS can be implemented using recursion (which internally uses a stack) or explicitly using a stack data structure.
* **Backtracking Approach:** If a path is blocked, it backtracks to the last visited node and explores another path.
* **Visits One Path at a Time:** Unlike BFS, DFS doesn't explore all neighbors at the same level before going deeper.
* **Works Well for Path-Finding and Topological Sorting:** DFS is used in scenarios where exhaustive searching or ordering is needed.
* **Can Get Stuck in Cycles (Without Visited Set):** If cycles exist, DFS may revisit nodes indefinitely unless a **visited set** is maintained.

### **Algorithm to Find DFS**

1. **Start at a given source node**.
2. **Mark it as visited**.
3. **Visit an adjacent unvisited node**, mark it visited, and repeat.
4. **If no adjacent unvisited node exists, backtrack** to the last node with unvisited neighbors.
5. **Repeat until all nodes are visited**.

### **Example Usage**

* **Maze Solving:** DFS follows one path until it reaches a dead end, then backtracks to find another path.
* **Topological Sorting in DAGs (Directed Acyclic Graphs):** DFS helps in ordering tasks (e.g., task scheduling).
* **Finding Connected Components in an Undirected Graph:** DFS can identify all nodes connected to a given node.

### **Time and Space Complexity**

<table data-header-hidden><thead><tr><th></th><th width="288"></th><th></th></tr></thead><tbody><tr><td><strong>Scenario</strong></td><td><strong>Time Complexity</strong></td><td><strong>Space Complexity</strong></td></tr><tr><td>Adjacency List (V = vertices, E = edges)</td><td>O(V + E)</td><td>O(V)</td></tr><tr><td>Adjacency Matrix</td><td>O(V²)</td><td>O(V)</td></tr></tbody></table>

* **Time Complexity Explanation:** Each vertex is visited once, and all edges are checked once.
* **Space Complexity Explanation:** In the worst case, the recursion stack (or explicit stack) may store all vertices.

## **2. Breadth-First Search (BFS)**

### **About BFS**

Breadth-First Search is a traversal technique that explores all neighbors of a node before moving to the next level of nodes. It follows a **level-order traversal** strategy.

### **Characteristics of BFS**

* **Queue-Based:** BFS uses a queue data structure for traversal.
* **Explores Neighbors First:** It visits all neighbors of a node before moving deeper.
* **Guaranteed Shortest Path (in Unweighted Graphs):** BFS ensures that the first time a node is reached, it's reached by the shortest path.
* **Memory Intensive in Large Graphs:** Since it stores all nodes of a level, it requires more memory than DFS in some cases.
* **Better for Finding the Shortest Path in an Unweighted Graph.**

### **Algorithm to Find BFS**

1. **Start at a given source node**.
2. **Enqueue the node and mark it as visited**.
3. **Dequeue a node**, explore all its unvisited neighbors, mark them as visited, and enqueue them.
4. **Repeat until the queue is empty**.

### **Example Usage**

* **Shortest Path in an Unweighted Graph:** BFS finds the shortest path from a source to a destination.
* **Social Network Friend Recommendations:** It finds connections at each level (e.g., friends of friends).
* **Web Crawlers:** BFS is used to crawl web pages in layers.

### **Time and Space Complexity**

| **Scenario**                             | **Time Complexity** | **Space Complexity** |
| ---------------------------------------- | ------------------- | -------------------- |
| Adjacency List (V = vertices, E = edges) | O(V + E)            | O(V)                 |
| Adjacency Matrix                         | O(V²)               | O(V)                 |

* **Time Complexity Explanation:** Every vertex and edge is processed once.
* **Space Complexity Explanation:** The queue stores all vertices at a given level.

## **Comparison**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Criteria</strong></td><td><strong>DFS</strong></td><td><strong>BFS</strong></td></tr><tr><td><strong>Data Structure Used</strong></td><td>Stack (recursion or explicit)</td><td>Queue</td></tr><tr><td><strong>Traversal Pattern</strong></td><td>Depth-first (goes deep before backtracking)</td><td>Breadth-first (visits all neighbors first)</td></tr><tr><td><strong>Best Use Case</strong></td><td>Backtracking problems, Topological Sorting, Cycles detection</td><td>Shortest path problems, Level-wise traversal</td></tr><tr><td><strong>Space Complexity (Worst Case)</strong></td><td>O(V) (stack space in recursion)</td><td>O(V) (queue holds nodes at each level)</td></tr><tr><td><strong>Guaranteed Shortest Path?</strong></td><td>No</td><td>Yes (in an unweighted graph)</td></tr><tr><td><strong>Memory Usage</strong></td><td>Less for large graphs with deep paths</td><td>More in wide graphs</td></tr></tbody></table>



