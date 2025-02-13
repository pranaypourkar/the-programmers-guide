# Shortest Path Algorithms

## About

Shortest path algorithms are used to find the minimum distance or cost between nodes in a graph. These algorithms play a crucial role in network routing, AI pathfinding, logistics, and optimization problems.

## **Types of Shortest Path Problems**

Shortest path problems involve finding the path with the **minimum cost, distance, or weight** between vertices in a graph. These problems are classified based on different requirements, constraints, and graph structures.

### **1️. Single Source Shortest Path (SSSP)**

Find the shortest path from **a single source vertex** to **all other vertices** in the graph.

**Examples of Algorithms:**

* **Dijkstra’s Algorithm** (for graphs with non-negative weights).
* **Bellman-Ford Algorithm** (for graphs with negative weights and cycle detection).
* **Breadth-First Search (BFS)** (for unweighted graphs).

**Real-World Applications:**

* **Google Maps** (finding the shortest driving route from one city to all other cities).
* **Network Routing (OSPF protocol)** (finding the fastest packet transmission path).
* **Social Networks** (finding the shortest connection path between users).

Find the shortest path to a specific destination vertex from all other vertices in the graph. Equivalent to SSSP but reversed, treating the destination as the source in a reversed graph.

**Examples of Algorithms:**

* **Dijkstra’s Algorithm** (reversed approach).
* **Bellman-Ford Algorithm** (negative weight support).

**Real-World Applications:**

* **Logistics & Delivery Networks** (finding shortest routes to a central warehouse from multiple locations).
* **Database Query Optimization** (finding optimal query execution paths).

### **3️. Single Pair Shortest Path (SPSP)**

Find the shortest path **between two specific vertices** in the graph. Unlike SSSP, we don’t need paths to all vertices—just one pair.

&#x20;**Examples of Algorithms:**

* **Dijkstra’s Algorithm** (stopping early when the destination is reached).
* _A Search Algorithm_\* (uses heuristics to guide search).

**Real-World Applications:**

* **GPS Navigation Systems** (finding the shortest route between two locations).
* **AI in Games (Pathfinding for NPCs)** (finding the best route from a start point to a goal).

### **4️. All-Pairs Shortest Path (APSP)**

Find the shortest paths **between all pairs of vertices** in the graph. Useful in dense graphs and network analysis.

**Examples of Algorithms:**

* **Floyd-Warshall Algorithm** (brute-force approach, good for small graphs).
* **Johnson’s Algorithm** (optimized for sparse graphs).

**Real-World Applications:**

* **Traffic Systems** (finding shortest routes between all city intersections).
* **Telecommunications** (finding optimal routing between all nodes in a network).
* **Social Network Analysis** (measuring closeness between all users).

### **5️. k-Shortest Paths Problem (KSPP)**

Find the **k shortest paths** between two vertices instead of just one. Useful when multiple alternative routes are needed.

**Examples of Algorithms:**

* **Yen’s Algorithm** (efficiently finds k shortest loopless paths).
* **Eppstein’s Algorithm** (finds k shortest paths in directed graphs).

**Real-World Applications:**

* **Traffic Navigation Systems** (providing multiple alternative routes).
* **Backup Routing in Networks** (alternative network paths in case of failure).

### **6️. Constrained Shortest Path Problem (CSPP)**

Find the shortest path while **satisfying additional constraints** (e.g., cost, time, energy).

**Examples of Constraints:**

* **Time-Constrained Path** (shortest path must be found within a given time limit).
* **Energy-Constrained Path** (path must not exceed a certain energy consumption).

**Examples of Algorithms:**

* **Constrained Dijkstra’s Algorithm** (modifies Dijkstra’s to enforce constraints).
* **Label-Correcting Algorithms** (used in real-time systems).

**Real-World Applications:**

* **Drone Delivery Systems** (finding the shortest path with battery constraints).
* **Cloud Computing** (finding shortest paths with CPU or bandwidth constraints).

### **7️. Shortest Path in Dynamic Graphs**

Shortest paths must be **continuously updated** as edges and weights change over time.

&#x20;**Examples of Algorithms:**

* **Dynamic Dijkstra’s Algorithm** (recomputes shortest paths efficiently when graph changes).
* **Dynamic Bellman-Ford Algorithm** (handles graphs with negative weights).

**Real-World Applications:**

* **Real-Time Traffic Navigation** (updating shortest paths when roads are blocked).
* **Stock Market Analysis** (adjusting shortest paths in financial graphs when data updates).

### **8️. Shortest Path in Graphs with Negative Weight Cycles**

If a graph has a **negative weight cycle**, shortest paths may be undefined (negative infinity). The algorithm must detect and report negative cycles.

**Examples of Algorithms:**

* **Bellman-Ford Algorithm** (can detect negative weight cycles).
* **Floyd-Warshall Algorithm** (detects negative cycles in APSP).

**Real-World Applications:**

* **Arbitrage Detection in Finance** (detecting profit opportunities in currency exchange).
* **Network Routing** (detecting faulty network paths).

### **9️. Shortest Path in Grid-Based Graphs**

Shortest path must be found in a **2D or 3D grid-based environment** (common in AI and robotics).

**Examples of Algorithms:**

* _A Algorithm_\* (uses heuristics to speed up pathfinding).
* _D Algorithm_\* (dynamic version of A\* for real-time changes).

**Real-World Applications:**

* **Robotic Path Planning** (self-driving cars, delivery drones).
* **Game AI** (pathfinding in 2D or 3D game worlds).

### Comparison

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Problem Type</strong></td><td><strong>Best Algorithms</strong></td><td><strong>Best Use Case</strong></td></tr><tr><td><strong>SSSP (Single Source Shortest Path)</strong></td><td>Dijkstra, Bellman-Ford, BFS</td><td>Finding shortest paths from one point (GPS, networks)</td></tr><tr><td><strong>Single Destination Shortest Path</strong></td><td>Dijkstra (reversed), Bellman-Ford</td><td>Finding fastest routes to a central location (warehousing, logistics)</td></tr><tr><td><strong>Single Pair Shortest Path (SPSP)</strong></td><td>A*, Dijkstra (early stop)</td><td>AI pathfinding, navigation</td></tr><tr><td><strong>All-Pairs Shortest Path (APSP)</strong></td><td>Floyd-Warshall, Johnson’s Algorithm</td><td>Network analysis, dense graphs</td></tr><tr><td><strong>k-Shortest Paths</strong></td><td>Yen’s Algorithm, Eppstein’s Algorithm</td><td>Providing alternative routes (traffic systems)</td></tr><tr><td><strong>Constrained Shortest Path</strong></td><td>Constrained Dijkstra, Label-Correcting</td><td>Finding paths with cost/time/energy constraints</td></tr><tr><td><strong>Dynamic Shortest Path</strong></td><td>Dynamic Dijkstra, Dynamic Bellman-Ford</td><td>Real-time traffic routing, stock market graphs</td></tr><tr><td><strong>Negative Weight Cycle Detection</strong></td><td>Bellman-Ford, Floyd-Warshall</td><td>Arbitrage in finance, faulty network paths</td></tr><tr><td><strong>Grid-Based Shortest Path</strong></td><td>A*, D*</td><td>AI robotics, game pathfinding</td></tr></tbody></table>



## Dijkstra’s Algorithm

### About

Dijkstra’s Algorithm is a **greedy algorithm** used to find the **shortest path from a single source vertex** to all other vertices in a graph with **non-negative weights**. It was developed by **Edsger W. Dijkstra** in 1956. It operates by selecting the **minimum distance vertex**, updating its neighbors, and repeating until all shortest paths are determined.

* **Type**: Single Source Shortest Path (SSSP)
* **Graph Type**: Weighted graphs (no negative weights)
* **Approach**: Greedy Algorithm
* **Time Complexity**:
  * **O(V²)** with an adjacency matrix (Basic version)
  * **O((V + E) log V)** with a priority queue (Optimized version using a Min-Heap)
* **Data Structure Used**: Priority Queue (Min-Heap) for efficient selection of the shortest path
* **Limitation**: Cannot handle negative weight edges

### **Working Principle**

1. **Initialize distances:** Set the source vertex’s distance to **0** and all other vertices to **infinity**.
2. **Select the minimum distance vertex:** Pick the vertex with the **smallest known distance** (initially the source).
3. **Update neighboring vertices:** For each adjacent vertex, update its shortest known distance **if a shorter path is found** through the current vertex.
4. **Repeat the process:** Continue selecting the **next minimum distance vertex** and updating neighbors until all vertices are processed.
5. **Terminate:** The algorithm stops when all vertices have been visited, and the shortest distances to all nodes are finalized.

### **Example Execution of Dijkstra’s Algorithm (Step-by-Step)**

**Graph Representation**

Consider the following weighted graph:

```
        (A)
       /   \
      4     1
     /       \
   (B) --- 2 -- (C)
     \       /
      5     3
       \   /
        (D)
```

**Graph Representation in Adjacency List Form:**

| Vertex | Adjacent Nodes (Weight) |
| ------ | ----------------------- |
| A      | B(4), C(1)              |
| B      | A(4), C(2), D(5)        |
| C      | A(1), B(2), D(3)        |
| D      | B(5), C(3)              |

We want to find the shortest path from A to all other nodes using Dijkstra’s Algorithm.

**Step 1: Initialization**

* Set the source vertex (A) distance to 0.
* Set all other vertices to ∞ (infinity).
* Maintain a "visited" set to track processed nodes.
* Use a priority queue (Min-Heap) to always select the node with the smallest known distance.

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| B      | ∞                 | -             |
| C      | ∞                 | -             |
| D      | ∞                 | -             |

**Step 2: Process Node A (Starting Node)**

* Mark **A** as visited.
* Update the distances of **B** and **C** (its adjacent nodes).
* Since **C has a smaller weight (1) compared to B (4), it will be prioritized.**

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **4**             | **A**         |
| **C**  | **1**             | **A**         |
| D      | ∞                 | -             |

**Step 3: Process Node C (Smallest Distance: 1)**

* Mark **C** as visited.
* Update distances of its neighbors **B and D**:
  * B: Current distance = 4, alternative path through C = 1 + 2 = 3 (shorter, update)
  * D: Current distance = ∞, alternative path through C = 1 + 3 = 4 (update)

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **3**             | **C**         |
| **C**  | **1**             | **A**         |
| **D**  | **4**             | **C**         |

**Step 4: Process Node B (Smallest Distance: 3)**

* Mark **B** as visited.
* Update its neighbor **D**:
  * **Current distance = 4, alternative path through B = 3 + 5 = 8 (not shorter, no update).**

No changes in the table.

**Step 5: Process Node D (Smallest Distance: 4)**

* Mark **D** as visited.
* **No updates needed since all nodes are processed.**

Final shortest distances from **A**:

| Vertex | Distance (from A) | Previous Node |
| ------ | ----------------- | ------------- |
| **A**  | **0**             | **-**         |
| **B**  | **3**             | **C**         |
| **C**  | **1**             | **A**         |
| **D**  | **4**             | **C**         |

**Step 6: Extract Shortest Paths**

* **A → C** (1)
* **A → C → B** (3)
* **A → C → D** (4)

**Final Shortest Paths from A**

| Destination | Shortest Path | Total Cost |
| ----------- | ------------- | ---------- |
| **B**       | A → C → B     | **3**      |
| **C**       | A → C         | **1**      |
| **D**       | A → C → D     | **4**      |

### **Time and Space Complexity**

* **Time Complexity**
  * **O(V²)** for an adjacency matrix
  * **O((V + E) log V)** using a priority queue (Min-Heap)
* **Space Complexity**
  * **O(V + E)** (to store the graph)

### **Limitations**

* Cannot handle negative weight edges
* Not suitable for dynamic graphs where edges change frequently
* _Less efficient than A for heuristic-based pathfinding_\*

### **Optimizations**

* **Use a priority queue (Min-Heap) instead of a simple array** to improve efficiency
* **Fibonacci Heap** reduces time complexity to **O(E + V log V)**
* **Bi-Directional Dijkstra** reduces search space by simultaneously searching from source and destination

### **Applications of Dijkstra’s Algorithm**

* **Navigation Systems** → GPS routing (Google Maps, Waze)
* **Network Routing** → Finding shortest paths in computer networks (OSPF protocol)
* **Robotics & AI** → Path planning in autonomous robots
* **Telecommunications** → Optimizing signal transmission paths
* **Game Development** → Pathfinding for AI characters
