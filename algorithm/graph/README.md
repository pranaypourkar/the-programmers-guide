# Graph

## About

A **Graph** is a fundamental data structure used to represent relationships between objects. It consists of **vertices (nodes)** and **edges (connections between nodes)**. Graphs are widely used in areas such as computer networks, social media, pathfinding algorithms, and artificial intelligence.

**Characteristics of Graphs**

* **Non-linear Data Structure** → Unlike arrays, linked lists, or trees, graphs do not follow a linear arrangement of elements.
* **Consists of Vertices (V) and Edges (E)** → A graph **G** is defined as **G = (V, E)**, where:
  * **V** is the set of vertices (nodes).
  * **E** is the set of edges (connections).
* **Used for Relationship Representation** → Suitable for **real-world modeling** like networks, web pages, cities, and transportation systems.
* **Supports Various Traversal Techniques** → DFS (Depth First Search) and BFS (Breadth First Search) help explore graph structures.

**Example Graph**

```
      A ----- B
      |       |
      |       |
      C ----- D
```

* **Vertices:** `{A, B, C, D}`
* **Edges:** `{(A-B), (A-C), (B-D), (C-D)}`

## Components of a Graph

A graph consists of several fundamental components:

### **Vertices (Nodes)**

* The **fundamental unit** of a graph.
* Each vertex represents **an entity** in a system (e.g., a person in a social network, a city in a map, or a webpage in a web graph).
* A graph can contain **millions or billions of vertices** in large-scale applications.

**Examples of Vertices in Different Domains**

| **Domain**       | **Vertex Representation** |
| ---------------- | ------------------------- |
| Social Network   | A user profile            |
| Computer Network | A router or a switch      |
| City Map         | A location or landmark    |
| Web Graph        | A webpage                 |

***

#### **2️⃣ Edges (Links)**

* An **edge** connects two vertices.
* Represents a **relationship or connection** between entities.
* Can be **directed** (one-way) or **undirected** (two-way).

**Types of Edges**

| **Edge Type**       | **Description**                                                                     |
| ------------------- | ----------------------------------------------------------------------------------- |
| **Undirected Edge** | A bidirectional connection. Example: A friendship in a social network.              |
| **Directed Edge**   | A one-way connection. Example: A "follower" relationship on Twitter.                |
| **Weighted Edge**   | An edge with a weight (cost, distance, etc.). Example: Distance between two cities. |

**Example Graph with Weighted and Directed Edges**

```
lessCopyEdit      A ----(5)----> B
      |             |
     (2)           (3)
      |             |
      C ----(4)----> D
```

* **A → B** has a weight of **5**.
* **C → D** has a weight of **4**.

***

#### **3️⃣ Degree of a Vertex**

* The **degree of a vertex** is the **number of edges connected** to it.
* In a **directed graph**, we differentiate between:
  * **In-degree** → Number of incoming edges.
  * **Out-degree** → Number of outgoing edges.

**Example**

```
mathematicaCopyEdit      A → B → C
      ↑   ↓
      D ← E
```

| Vertex | In-degree | Out-degree | Degree |
| ------ | --------- | ---------- | ------ |
| A      | 1         | 1          | 2      |
| B      | 1         | 2          | 3      |
| C      | 1         | 0          | 1      |
| D      | 1         | 1          | 2      |
| E      | 1         | 1          | 2      |

***

#### **4️⃣ Path in a Graph**

* A **path** is a **sequence of vertices** connected by edges.
* A path can be **simple** (no repeated vertices) or **cyclic** (forms a loop).

**Example**

```
cssCopyEdit      A → B → C → D
```

* Path: `A → B → C → D`
* Path Length: **3** (number of edges)

***

#### **5️⃣ Cycle in a Graph**

* A **cycle** is a path that **starts and ends at the same vertex**.
* **Cyclic Graph** → Contains at least one cycle.
* **Acyclic Graph** → Does **not** contain cycles.

**Example of a Cyclic Graph**

```
mathematicaCopyEdit      A → B → C
      ↑       ↓
      D ←---- E
```

* Cycle: `A → B → C → E → D → A`

**Example of an Acyclic Graph**

```
cssCopyEdit      A → B → C → D
```

* No cycles present.

***

#### **6️⃣ Connected and Disconnected Graphs**

* **Connected Graph** → Every vertex has at least **one path** to another vertex.
* **Disconnected Graph** → Some vertices have **no connection** to others.

**Example of a Connected Graph**

```
mathematicaCopyEdit      A → B → C
      ↓    ↓  ↑
      D → E → F
```

* All nodes are **reachable** from any other node.

**Example of a Disconnected Graph**

```
cssCopyEdit      A → B    C → D
```

* `{A, B}` is separate from `{C, D}`.

***

#### **7️⃣ Weighted and Unweighted Graphs**

* **Unweighted Graph** → All edges have **equal importance**.
* **Weighted Graph** → Edges have **weights or costs**.

**Example of a Weighted Graph**

```
lessCopyEdit      A --(3)--> B
      |          |
     (2)        (5)
      |          |
      C --(4)--> D
```

* **Path Cost:** `A → C → D = 2 + 4 = 6`.

***

#### **8️⃣ Directed and Undirected Graphs**

* **Undirected Graph** → Edges have **no direction**.
* **Directed Graph (Digraph)** → Edges have **specific direction**.

**Example of an Undirected Graph**

```
lessCopyEdit      A --- B
      |     |
      C --- D
```

* `A - B` means **both A can reach B and B can reach A**.

**Example of a Directed Graph**

```
cssCopyEdit      A → B
      ↓   ↓
      C → D
```

* `A → B` means **A can reach B, but B cannot reach A**.

***

#### **9️⃣ Subgraphs**

* A **subgraph** is a smaller portion of a graph.
* It consists of a subset of **vertices and edges**.

**Example of a Subgraph**

Original Graph:

```
mathematicaCopyEdit      A → B → C
      ↓    ↓  ↑
      D → E → F
```

Subgraph:

```
mathematicaCopyEdit      B → C
      ↓  
      E  
```

## Types of Graphs



## Applications of Graphs



