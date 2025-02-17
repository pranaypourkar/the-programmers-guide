# Adjacency Matrix

## **About**

An **Adjacency Matrix** is a **2D array representation of a graph** where:

* **Rows and columns represent vertices**.
* **Each cell (i, j) contains 1 (or weight) if there is an edge from vertex i to vertex j, otherwise 0**.

## **Why Use an Adjacency Matrix?**

* **Fast Edge Lookup**: Checking if an edge exists is O(1).
* **Best for Dense Graphs**: If the graph has many edges, adjacency matrices are efficient.
* **Easier Implementation**: Simple 2D array structure.

## **Structure of an Adjacency Matrix**

An adjacency matrix consists of:

* A **2D array `graph[V][V]`**, where `V` is the number of vertices.
* If the graph is **undirected**, `graph[i][j] = graph[j][i]`.
* If the graph is **weighted**, the matrix stores **weights instead of 1s**.

#### **Representation**

For a graph with 4 vertices (**V = 4**) and edges **(0→1, 0→2, 1→3, 2→3)**:

|       | 0 | 1 | 2 | 3 |
| ----- | - | - | - | - |
| **0** | 0 | 1 | 1 | 0 |
| **1** | 1 | 0 | 0 | 1 |
| **2** | 1 | 0 | 0 | 1 |
| **3** | 0 | 1 | 1 | 0 |

## **1. Graph Representation Using a 2D Array**

### **Code**

```java
import java.util.*;

class Graph {
    private int vertices; // Number of vertices
    private int[][] adjacencyMatrix; // Adjacency Matrix

    // Constructor
    public Graph(int vertices) {
        this.vertices = vertices;
        adjacencyMatrix = new int[vertices][vertices]; // Initialize matrix with 0s
    }

    // Method to add an edge (Undirected Graph)
    public void addEdge(int src, int dest) {
        adjacencyMatrix[src][dest] = 1;
        adjacencyMatrix[dest][src] = 1; // For undirected graph
    }

    // Method to add a directed edge
    public void addDirectedEdge(int src, int dest) {
        adjacencyMatrix[src][dest] = 1;
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        adjacencyMatrix[src][dest] = 0;
        adjacencyMatrix[dest][src] = 0; // For undirected graph
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        return adjacencyMatrix[src][dest] == 1;
    }

    // Method to print the adjacency matrix
    public void printGraph() {
        System.out.println("Adjacency Matrix:");
        for (int i = 0; i < vertices; i++) {
            for (int j = 0; j < vertices; j++) {
                System.out.print(adjacencyMatrix[i][j] + " ");
            }
            System.out.println();
        }
    }

    // Method to get neighbors of a given vertex
    public List<Integer> getNeighbors(int vertex) {
        List<Integer> neighbors = new ArrayList<>();
        for (int i = 0; i < vertices; i++) {
            if (adjacencyMatrix[vertex][i] == 1) {
                neighbors.add(i);
            }
        }
        return neighbors;
    }

    // Depth-First Search (DFS)
    public void dfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        System.out.print("DFS Traversal: ");
        dfsHelper(startVertex, visited);
        System.out.println();
    }

    private void dfsHelper(int vertex, boolean[] visited) {
        visited[vertex] = true;
        System.out.print(vertex + " ");
        for (int i = 0; i < vertices; i++) {
            if (adjacencyMatrix[vertex][i] == 1 && !visited[i]) {
                dfsHelper(i, visited);
            }
        }
    }

    // Breadth-First Search (BFS)
    public void bfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[startVertex] = true;
        queue.add(startVertex);

        System.out.print("BFS Traversal: ");
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");

            for (int i = 0; i < vertices; i++) {
                if (adjacencyMatrix[vertex][i] == 1 && !visited[i]) {
                    queue.add(i);
                    visited[i] = true;
                }
            }
        }
        System.out.println();
    }

    // Main Method for Testing
    public static void main(String[] args) {
        Graph graph = new Graph(5);

        // Adding edges
        graph.addEdge(0, 1);
        graph.addEdge(0, 2);
        graph.addEdge(1, 3);
        graph.addEdge(1, 4);
        graph.addEdge(2, 4);

        // Printing the adjacency matrix
        graph.printGraph();

        // Checking if edge exists
        System.out.println("Edge between 0 and 1: " + graph.hasEdge(0, 1));
        System.out.println("Edge between 2 and 3: " + graph.hasEdge(2, 3));

        // Removing an edge
        graph.removeEdge(1, 4);
        graph.printGraph();

        // Getting neighbors of a vertex
        System.out.println("Neighbors of vertex 1: " + graph.getNeighbors(1));

        // Performing DFS and BFS
        graph.dfs(0);
        graph.bfs(0);
    }
}
```

### **Output**

```java
Adjacency Matrix:
0 1 1 0 0 
1 0 0 1 1 
1 0 0 0 1 
0 1 0 0 0 
0 1 1 0 0 

Edge between 0 and 1: true
Edge between 2 and 3: false

Adjacency Matrix:
0 1 1 0 0 
1 0 0 1 0 
1 0 0 0 1 
0 1 0 0 0 
0 0 1 0 0 

Neighbors of vertex 1: [0, 3]

DFS Traversal: 0 1 3 2 4 
BFS Traversal: 0 1 2 3 4 
```

### **Operations Breakdown and Time Complexity**

<table data-full-width="true"><thead><tr><th width="169">Operation</th><th width="193">Time Complexity</th><th>Explanation</th></tr></thead><tbody><tr><td><strong>Add Edge</strong></td><td>O(1)</td><td>Directly updates the adjacency matrix.</td></tr><tr><td><strong>Remove Edge</strong></td><td>O(1)</td><td>Directly removes the edge from the matrix.</td></tr><tr><td><strong>Check Edge</strong></td><td>O(1)</td><td>Looks up value in matrix.</td></tr><tr><td><strong>Get Neighbours</strong></td><td>O(V)</td><td>Scans row in matrix to find connected vertices.</td></tr><tr><td><strong>DFS Traversal</strong></td><td>O(V²)</td><td>In the worst case, visits every vertex and edge.</td></tr><tr><td><strong>BFS Traversal</strong></td><td>O(V²)</td><td>Uses queue, but still needs to check matrix for neighbours.</td></tr></tbody></table>

## **2. Weighted Graph Implementation**

If the graph is **weighted**, we replace **1** with the **weight of the edge**.

### Code

```java
import java.util.*;

class WeightedGraph {
    private int vertices; // Number of vertices
    private int[][] adjacencyMatrix; // Adjacency Matrix

    // Constructor
    public WeightedGraph(int vertices) {
        this.vertices = vertices;
        adjacencyMatrix = new int[vertices][vertices];

        // Initialize the matrix with a large value to indicate no edge (-1 is used here)
        for (int i = 0; i < vertices; i++) {
            Arrays.fill(adjacencyMatrix[i], -1);
        }
    }

    // Method to add an edge (Undirected Graph)
    public void addEdge(int src, int dest, int weight) {
        adjacencyMatrix[src][dest] = weight;
        adjacencyMatrix[dest][src] = weight; // For undirected graph
    }

    // Method to add a directed edge
    public void addDirectedEdge(int src, int dest, int weight) {
        adjacencyMatrix[src][dest] = weight;
    }

    // Method to remove an edge
    public void removeEdge(int src, int dest) {
        adjacencyMatrix[src][dest] = -1;
        adjacencyMatrix[dest][src] = -1; // For undirected graph
    }

    // Method to check if an edge exists
    public boolean hasEdge(int src, int dest) {
        return adjacencyMatrix[src][dest] != -1;
    }

    // Method to get the weight of an edge
    public int getEdgeWeight(int src, int dest) {
        return adjacencyMatrix[src][dest];
    }

    // Method to print the adjacency matrix
    public void printGraph() {
        System.out.println("Weighted Adjacency Matrix:");
        for (int i = 0; i < vertices; i++) {
            for (int j = 0; j < vertices; j++) {
                System.out.print((adjacencyMatrix[i][j] == -1 ? "∞" : adjacencyMatrix[i][j]) + "\t");
            }
            System.out.println();
        }
    }

    // Method to get neighbors of a given vertex
    public List<Integer> getNeighbors(int vertex) {
        List<Integer> neighbors = new ArrayList<>();
        for (int i = 0; i < vertices; i++) {
            if (adjacencyMatrix[vertex][i] != -1) {
                neighbors.add(i);
            }
        }
        return neighbors;
    }

    // Depth-First Search (DFS)
    public void dfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        System.out.print("DFS Traversal: ");
        dfsHelper(startVertex, visited);
        System.out.println();
    }

    private void dfsHelper(int vertex, boolean[] visited) {
        visited[vertex] = true;
        System.out.print(vertex + " ");
        for (int i = 0; i < vertices; i++) {
            if (adjacencyMatrix[vertex][i] != -1 && !visited[i]) {
                dfsHelper(i, visited);
            }
        }
    }

    // Breadth-First Search (BFS)
    public void bfs(int startVertex) {
        boolean[] visited = new boolean[vertices];
        Queue<Integer> queue = new LinkedList<>();
        
        visited[startVertex] = true;
        queue.add(startVertex);

        System.out.print("BFS Traversal: ");
        while (!queue.isEmpty()) {
            int vertex = queue.poll();
            System.out.print(vertex + " ");

            for (int i = 0; i < vertices; i++) {
                if (adjacencyMatrix[vertex][i] != -1 && !visited[i]) {
                    queue.add(i);
                    visited[i] = true;
                }
            }
        }
        System.out.println();
    }

    // Main Method for Testing
    public static void main(String[] args) {
        WeightedGraph graph = new WeightedGraph(5);

        // Adding edges with weights
        graph.addEdge(0, 1, 4);
        graph.addEdge(0, 2, 2);
        graph.addEdge(1, 3, 7);
        graph.addEdge(1, 4, 1);
        graph.addEdge(2, 4, 3);

        // Printing the adjacency matrix
        graph.printGraph();

        // Checking if edge exists and its weight
        System.out.println("Edge between 0 and 1: " + graph.hasEdge(0, 1));
        System.out.println("Weight of edge (0,1): " + graph.getEdgeWeight(0, 1));
        System.out.println("Edge between 2 and 3: " + graph.hasEdge(2, 3));

        // Removing an edge
        graph.removeEdge(1, 4);
        graph.printGraph();

        // Getting neighbors of a vertex
        System.out.println("Neighbors of vertex 1: " + graph.getNeighbors(1));

        // Performing DFS and BFS
        graph.dfs(0);
        graph.bfs(0);
    }
}
```

#### **Output**

```java
Weighted Adjacency Matrix:
∞	4	2	∞	∞	
4	∞	∞	7	1	
2	∞	∞	∞	3	
∞	7	∞	∞	∞	
∞	1	3	∞	∞	

Edge between 0 and 1: true
Weight of edge (0,1): 4
Edge between 2 and 3: false

Weighted Adjacency Matrix:
∞	4	2	∞	∞	
4	∞	∞	7	∞	
2	∞	∞	∞	3	
∞	7	∞	∞	∞	
∞	∞	3	∞	∞	

Neighbors of vertex 1: [0, 3]

DFS Traversal: 0 1 3 2 4 
BFS Traversal: 0 1 2 3 4 

```

### **Operations Breakdown and Time Complexity**

<table data-full-width="true"><thead><tr><th width="194">Operation</th><th width="195">Time Complexity</th><th>Explanation</th></tr></thead><tbody><tr><td><strong>Add Edge</strong></td><td>O(1)</td><td>Directly updates the adjacency matrix.</td></tr><tr><td><strong>Remove Edge</strong></td><td>O(1)</td><td>Directly removes the edge from the matrix.</td></tr><tr><td><strong>Check Edge</strong></td><td>O(1)</td><td>Looks up value in matrix.</td></tr><tr><td><strong>Get Edge Weight</strong></td><td>O(1)</td><td>Directly accesses weight from matrix.</td></tr><tr><td><strong>Get Neighbors</strong></td><td>O(V)</td><td>Scans row in matrix to find connected vertices.</td></tr><tr><td><strong>DFS Traversal</strong></td><td>O(V²)</td><td>Worst-case visits all vertices and edges.</td></tr><tr><td><strong>BFS Traversal</strong></td><td>O(V²)</td><td>Uses queue, but still checks matrix for neighbors.</td></tr></tbody></table>
