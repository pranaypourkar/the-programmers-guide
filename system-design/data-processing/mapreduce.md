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
* We can create **custom partitioners** to group keys by business logic (e.g., by region or category).

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

MapReduce shines in **batch processing of large-scale datasets**. Its simplicity and horizontal scalability make it suitable for a wide range of analytical, processing, and transformation tasks across industries.

#### **1. Log Analysis**

**a. Web Server Logs**

* Parse millions of HTTP logs to extract:
  * IP address frequency
  * Status code analysis (e.g., count all 404s)
  * URL access frequency
  * Top users or top referrers

**b. Application Logs**

* Analyze logs for errors, exceptions, or bottlenecks.
* Aggregate logs over time to detect usage trends or issues.

_Example:_ Count all failed login attempts in a given date range.

#### **2. Text Mining & Indexing**

**a. Search Engine Indexing**

* Break down web pages into words (tokens), then group and count occurrences across the web.
* Build inverted indexes mapping words to document IDs.

**b. Word Count**

* Classic introductory example.
* Used in summarization, frequency analysis, spam detection.

#### **3. Data Aggregation**

* Aggregate financial, transactional, or sensor data.
* Examples:
  * Sum of sales per store or region.
  * Average temperature per city from weather sensors.
  * Total transactions per customer per month.

Useful in:

* Finance
* IoT data analysis
* Retail sales aggregation

#### **4. ETL (Extract, Transform, Load) Pipelines**

MapReduce is often used in **data warehousing** or **data lake** environments.

* **Extract** raw data from different sources (logs, databases).
* **Transform** it by cleaning, filtering, deduplicating, joining.
* **Load** it into analytical databases or distributed storage for BI tools.

_Example:_ Clean and standardize customer names across datasets before ingestion.

#### **5. Machine Learning Preprocessing**

Before training ML models, large datasets are often:

* Cleaned
* Tokenized
* Normalized
* Transformed into feature vectors

MapReduce can efficiently handle:

* Vectorization of large datasets
* Feature extraction
* Computing statistics (mean, standard deviation, min-max scaling)

#### **6. Recommendation Systems**

* Count product views, purchases, and co-occurrence.
* Identify frequently bought-together items.
* Build collaborative filtering data structures (user-product matrices).

Used in:

* E-commerce (Amazon)
* Streaming services (Netflix, Spotify)

#### **7. Bioinformatics**

Huge biological datasets (like genome sequences) are ideal for MapReduce.

* DNA/RNA sequence alignment and comparison
* Mutation detection
* Protein folding simulations

These tasks are **compute-heavy** and **embarrassingly parallel** — a good fit for MapReduce.

#### **8. Social Network Analysis**

* Count likes, shares, comments per user.
* Analyze friend-of-friend relationships.
* Identify communities, influencers, or spam behavior.

_Example:_ Find the most shared hashtags or most active users in a dataset of social media posts.

#### **9. Clickstream Analysis**

* Analyze user paths on a website or app.
* Identify most common navigation paths.
* Measure conversion funnels.

Helps in:

* Marketing analytics
* UI/UX optimization
* A/B testing impact analysis

#### **10. Fraud Detection**

* Aggregate and analyze transaction patterns.
* Identify anomalies in spending behavior.
* Correlate transactions with geolocation, IPs, or timestamps.

_Note:_ While real-time detection often uses stream processing, MapReduce is used for **historical fraud analysis**.

#### **11. Sensor & IoT Data Aggregation**

* Collect and analyze data from devices like smart meters, thermostats, or industrial sensors.
* Compute:
  * Averages
  * Outliers
  * Time-based trends

_Example:_ Detect power surges or usage patterns across a city grid.

#### **12. Data Deduplication**

* Identify and remove duplicates in large datasets.
* Useful in merging data from multiple sources where overlap is possible.

_Example:_ Combine multiple customer records with overlapping IDs or similar names.

#### **13. Graph Processing (with limitations)**

Although not ideal for highly iterative tasks, MapReduce can handle:

* PageRank calculation (used by search engines)
* Counting triangles or connected components in social networks

_Advanced platforms like Apache Giraph or Spark GraphX are better, but basic versions can run on MapReduce._

## Limitations of MapReduce

MapReduce is a powerful model for distributed batch processing, but it is not a one-size-fits-all solution. It has several **practical and architectural limitations** that make it less suitable for certain use cases, especially in modern real-time data systems.

#### **1. Not Designed for Real-Time Processing**

**MapReduce is batch-oriented** — it processes data in large chunks at scheduled intervals.

* It is **not suitable for low-latency, real-time systems**.
* You can’t get immediate feedback from newly arriving data.

> _Example:_ If we're trying to detect fraud as it happens or display live dashboards, MapReduce will be too slow.

#### **2. High Latency**

Each MapReduce job requires:

* Job setup
* Task scheduling
* Data shuffling between Map and Reduce phases

These steps introduce significant **overhead and latency**, especially for smaller jobs.

> Even simple tasks like a word count may take tens of seconds to minutes to complete.

#### **3. Inefficient for Iterative Computation**

Many algorithms — such as machine learning, graph traversal (e.g., PageRank), or deep learning — require **repeated passes over the same data**.

* MapReduce stores intermediate output to **disk** after each step.
* This results in heavy I/O operations, making iterative algorithms inefficient and slow.

> Spark and other in-memory platforms handle such workloads better by avoiding repeated disk writes.

#### **4. Complexity in Writing Code**

* Developers must **manually write map and reduce functions** for every task.
* Even simple operations (like joins or sorting) require verbose and boilerplate code.
* There's no built-in **declarative language** (like SQL) — although tools like Hive try to bridge this gap.

> Writing and debugging MapReduce code often takes more time than using higher-level frameworks.

#### **5. Poor Support for Multi-Step Workflows**

Most real-world data pipelines involve:

* Multiple stages
* Data dependencies
* Conditionals and branching

MapReduce doesn't provide native support for **complex, chained workflows**. Orchestration tools like Apache Oozie or Airflow are needed, which adds to complexity.

#### **6. Disk-Based Between Phases**

Between the Map and Reduce phases, all intermediate data is:

* Written to disk
* Transferred over the network
* Then read back by reducers

This **disk-based architecture** makes it:

* Slow for lightweight jobs
* Resource-intensive for large workflows

> In contrast, newer frameworks use **in-memory DAG execution**.

#### **7. No Built-in Data Streaming**

MapReduce has **no concept of a data stream** — data must be static and finite.

* Cannot handle unbounded data sources like IoT streams, live logs, or event feeds.
* Requires the full dataset to be available beforehand.

> Apache Kafka + Apache Flink/Spark Streaming are preferred for such scenarios.

#### **8. Lack of Fault Tolerance for Custom Logic**

While MapReduce handles node failures during shuffles or I/O phases, any failure inside:

* Custom map()
* Custom reduce()

…often leads to job termination. Developers need to add manual error handling and checkpointing to improve reliability.

#### **9. Rigid Data Flow**

MapReduce enforces a **strict two-phase data flow**: Map → Shuffle → Reduce.

* This structure doesn’t allow more dynamic branching, multiple reductions, or conditional logic.
* Complex tasks become hard to model or inefficient.

#### **10. Not Suited for Small or Interactive Jobs**

* Job setup overhead makes it **unsuitable for fast queries or ad-hoc analysis**.
* For small datasets or quick jobs, traditional SQL databases or Spark SQL are faster and easier to use.

#### **11. Weak in Complex Joins and SQL-like Operations**

* Joining multiple datasets is difficult.
* Map-side and reduce-side joins require manual partitioning and tuning.

> In contrast, tools like Hive or Presto provide SQL-like syntax on top of distributed systems.

#### **12. High Resource Usage**

Because of:

* Disk I/O between phases
* Network shuffling
* Multiple redundant copies

…MapReduce often requires **more memory, CPU, and storage** than in-memory or stream-based systems for the same task.

