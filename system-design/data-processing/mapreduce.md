# MapReduce

## About

**MapReduce** is a programming model and a processing framework designed to handle **large-scale data** across **distributed systems**. It was introduced by **Google** and popularized by **Apache Hadoop**. The idea is to process massive datasets by **splitting the task into two phases** — **Map** and **Reduce**, and executing them in **parallel** on a cluster of commodity machines.

MapReduce emerged as a solution for:

* Processing **huge volumes of data (TBs or PBs)** that can't fit on a single machine.
* Ensuring **fault-tolerant**, **parallel** computation.
* Providing a **declarative programming model** where developers focus on logic, not orchestration.
* Working close to the storage layer (e.g., HDFS), minimizing data movement.

## MapReduce Phases

### **1. Input Splitting**

Before any processing begins, the input data must be split into **logical chunks** (input splits). Each split is processed independently by a mapper.

* **InputFormat** defines how input files are split and read.
* Common formats include **TextInputFormat**, **KeyValueTextInputFormat**, and **SequenceFileInputFormat**.
* For example, a 128MB file might be split into two 64MB chunks, each handled by a separate Mapper.

**Why it matters:** This phase lays the groundwork for **parallelism**. Proper splitting ensures **balanced workload** and avoids **straggler tasks**.

### **2. Mapping Phase**

This is the **first active phase** in the job. Each split is processed line-by-line by a **Mapper** function.

* **Input:** `(key1, value1)` — typically byte offset and a line of text.
* **Output:** `(key2, value2)` — any intermediate key-value pair.
* Mappers are **stateless** and run in **parallel** across the cluster.

**Key Characteristics**

* Highly customizable.
* Stateless function — operates on one record at a time.
* Emits zero, one, or many key-value pairs.

**Example**\
For word count, `(offset, "MapReduce is great")` →\
`("MapReduce", 1)`, `("is", 1)`, `("great", 1)`

### **3. Optional: Combiner Phase**

Combiner acts like a **mini-reducer** that runs after the map phase **on the same node**, reducing the volume of data sent across the network.

* **Input:** Mapper’s intermediate `(key2, value2)` pairs.
* **Output:** Reduced form of those pairs.
* Logic is often identical to the Reducer.
* Combiner is **not guaranteed** to run — it's an optimization.

**Why it helps:** Drastically reduces **network congestion** by performing **local aggregation** before shuffling.

### **4. Partitioning**

Partitioning controls **how intermediate keys are distributed to Reducers**.

* A **Partitioner** function takes the key and assigns it to a reducer.
* Default: **HashPartitioner** — assigns keys based on hash mod number of reducers.
* You can create **custom partitioners** to group keys by business logic (e.g., by region or category).

**Purpose:** Distributes the workload **evenly** among reducers and ensures **all values for a given key go to the same reducer**.

### **5. Shuffle Phase**

Shuffle is the **most resource-intensive** step. It occurs **between map and reduce**.

* The system collects, sorts, and groups intermediate `(key2, value2)` pairs.
* Keys are grouped and values aggregated into lists.
* Data is transferred (shuffled) from mapper nodes to the appropriate reducer nodes.

**Features**

* **Sorting by key** is mandatory before reducing.
* **Merges** data from multiple mappers.
* Data is stored in memory or spilled to disk based on size.

**Challenges**

* High I/O and network load.
* Needs careful tuning (buffer sizes, memory).

### **6. Sorting**

Before the Reduce phase, all `(key2, value2)` pairs are **sorted by key**.

* Sorting happens **after shuffling**, before reduction begins.
* Enables deterministic processing and grouping.
* Can be customized using a **Key Comparator** or **Secondary Sort**.

**Example**\
After shuffle and sort:\
`("MapReduce", [1, 1, 1])`, `("is", [1, 1])`, `("great", [1])`

### **7. Reduce Phase**

The Reducer processes each **grouped key** and a **list of its associated values**.

* **Input:** `(key2, list(value2))`
* **Output:** `(key3, value3)` — the final result.
* Runs in parallel across reducers (based on partitions).
* Reducers are **stateful** across a key group but isolated from each other.

**Common reducer operations**

* Aggregation (sums, counts)
* Filtering
* Merging datasets

**Example**\
`("MapReduce", [1, 1, 1])` → `("MapReduce", 3)`

### **8. Output Writing**

After processing, results are written to **HDFS** (or another distributed file system) by the **OutputFormat**.

* Output is written in key-value format.
* Each reducer writes to a **separate output file** (e.g., `part-00000`).
* Custom output formats allow writing to databases, NoSQL, etc.

**Final Files**\
Typically stored in a directory with one file per reducer.

### **9. Job Completion & Cleanup**

Once all reducers finish, the job tracker (or YARN application master in Hadoop 2+) marks the job as **completed**.

* Temporary files and metadata are cleaned.
* Job status and metrics are recorded for inspection.

## Common Use Cases



## Limitations of MapReduce

