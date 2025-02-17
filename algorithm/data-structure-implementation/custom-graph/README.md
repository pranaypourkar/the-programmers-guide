# Custom Graph

## About

Graphs are **non-linear data structures** consisting of **vertices (nodes)** and **edges (connections between nodes)**. They can represent **real-world relationships** like **social networks, road maps, and computer networks**.

### **Types of Graph Representation**

There are multiple ways to implement graphs in a computer program, each with its own advantages and trade-offs. The **three most common implementations** are:

1. **Adjacency Matrix**
2. **Adjacency List**
3. **Edge List**

## **Adjacency Matrix Representation**

An **Adjacency Matrix** is a **2D array (V × V matrix)** where **V is the number of vertices**. Each **cell (i, j)** indicates whether there is an **edge** between vertex **i** and vertex **j**.

### **Structure**

* For an **unweighted graph**, the matrix contains **0 (no edge)** or **1 (edge exists)**.
* For a **weighted graph**, the matrix stores the **weight of the edge** instead of 1.

### **Example: Adjacency Matrix for an Undirected Graph**

Consider the following undirected graph:

```
    (A) --1-- (B)
     |       / |
     4    3    | 
     | /       |
    (C) --2-- (D)
```

|   | A | B | C | D |
| - | - | - | - | - |
| A | 0 | 1 | 4 | 0 |
| B | 1 | 0 | 3 | 1 |
| C | 4 | 3 | 0 | 2 |
| D | 0 | 1 | 2 | 0 |

## **Adjacency List Representation**

An **Adjacency List** represents a graph as an **array of linked lists (or lists in general)**. Each **vertex** has a list of all the **adjacent vertices** (neighbors).

### **Structure**

For the same undirected graph:

```
    (A) --1-- (B)
     |       / |
     4    3    | 
     | /       |
    (C) --2-- (D)
```

The adjacency list would look like:

```
A → [(B,1), (C,4)]
B → [(A,1), (C,3), (D,1)]
C → [(A,4), (B,3), (D,2)]
D → [(B,1), (C,2)]
```

For a **directed graph**, the edges point in **one direction only**.

```
    A → B
    A → C
    B → C
    C → D
```

Adjacency List Representation

```
A → [B, C]
B → [C]
C → [D]
D → []
```

## **Edge List Representation**

An **Edge List** is a **list of all edges**, where each edge is represented as a **pair (or triplet for weighted graphs)**.

### **Structure**

For the same undirected graph:

```
    (A) --1-- (B)
     |       / |
     4    3    | 
     | /       |
    (C) --2-- (D)
```

The edge list would look like:

| Edge | Start | End | Weight |
| ---- | ----- | --- | ------ |
| 1    | A     | B   | 1      |
| 2    | A     | C   | 4      |
| 3    | B     | C   | 3      |
| 4    | B     | D   | 1      |
| 5    | C     | D   | 2      |

## **Choosing the Right Implementation**

1. **Use Adjacency Matrix when**
   * The graph is **dense** (i.e., E≈V^2).
   * Fast edge lookup is required O(1).
   * The graph doesn't change frequently.
2. **Use Adjacency List when**
   * The graph is **sparse** (i.e., E≪ V^2E).
   * Space efficiency is a concern.
   * Need to iterate over neighbors frequently.
3. **Use Edge List when**
   * The graph changes dynamically (adding/removing edges frequently).
   * Need a **compact** edge representation.
   * Algorithms like **Kruskal’s Algorithm** (which sorts edges) are required.
