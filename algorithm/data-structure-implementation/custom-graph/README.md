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
```
