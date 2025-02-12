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



