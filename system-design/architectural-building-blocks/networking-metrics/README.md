# Networking Metrics

## About

Networking metrics are essential performance indicators that help assess the efficiency, reliability, and responsiveness of a system’s network. They play a crucial role in designing scalable, high-performance distributed systems and optimizing network infrastructure.

## **1. Latency**

Latency is the **time delay** between when a request is made and when a response is received. It is measured in **milliseconds (ms)** and can impact system performance, user experience, and data transmission.

Latency can be classified into different types based on where it occurs:

1. Network Latency (End-to-End Delay)
2. Application Latency
3. Disk Latency (Storage Latency)
4. Database Latency
5. Memory Latency

### **1. Network Latency**

The delay in transmitting data over a network from sender to receiver.

#### **Causes of Network Latency**

* **Physical Distance** → Longer distances take more time (e.g., sending data from the US to India).
* **Congestion** → High traffic on a network slows down data transmission.
* **Packet Loss & Retransmission** → Lost packets require resending, increasing latency.
* **Bandwidth Limitations** → Lower bandwidth means slower data transfer.
* **Routing & Switching Delays** → Time spent at intermediate routers and switches.

#### **Formula for Total Network Latency**

`Network Latency = Transmission Delay + Propagation Delay + Processing Delay + Queuing Delay`

#### **Example Calculation**

* Packet Size = 10 MB
* Bandwidth = 100 Mbps
* Distance = 3000 km
* Speed of Light in Fiber = 200,000 km/s

Transmission Delay = (10×8) / 100 = 0.8 seconds\
Propagation Delay = 3000 / 200000 = 0.015 seconds\
&#xNAN;_&#x54;otal Latency ≈ 0.815 seconds (815 ms)_

#### **Optimization Techniques**

* Use **Content Delivery Networks (CDNs)** to bring data closer to users.
* Reduce **DNS resolution time** (avoid unnecessary redirects).
* Optimize **network routing** to use faster paths.

### **2. Application Latency**

The delay caused by an application while processing a request.

#### **Causes of Application Latency**

* **Slow Backend Processing** → Heavy computations or inefficient algorithms.
* **Database Queries** → Complex or unoptimized queries slow response time.
* **API Call Delays** → Waiting for responses from third-party APIs.
* **Thread Blocking** → Poor multi-threading can cause delays.

#### **Application Latency Breakdown**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Definition</strong></td><td><strong>Optimization</strong></td></tr><tr><td><strong>Processing Time</strong></td><td>Time for backend logic execution</td><td>Use efficient algorithms</td></tr><tr><td><strong>Database Query Time</strong></td><td>Time spent fetching data from the DB</td><td>Optimize queries, indexing</td></tr><tr><td><strong>API Call Delay</strong></td><td>Delay from external APIs</td><td>Use async API calls, caching</td></tr></tbody></table>

#### **Formula for Application Latency**

`Application Latency = Processing Time + DB Query Time + API Call Delay`

#### **Example Calculation**

* Processing Time = 100 ms
* DB Query Time = 200 ms
* API Call Delay = 300 ms

_Total Latency = 100 + 200 + 300 = 600 ms_

#### **Optimization Techniques**

* **Reduce DB calls** → Use caching (Redis, Memcached).
* **Improve backend performance** → Optimize algorithms, use parallel processing.
* **Use Asynchronous Processing** → Reduce blocking operations.

### **3. Disk Latency (Storage Latency)**

The time delay in retrieving data from a storage device (HDD/SSD).

#### **Causes of Disk Latency**

* **Mechanical Movements in HDD** → Seek time, rotational delay.
* **Slow SSD Response** → NAND flash limitations.
* **Large File Transfers** → More data requires more time.

#### **Disk Latency Breakdown**

<table data-header-hidden data-full-width="true"><thead><tr><th width="245"></th><th width="407"></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Definition</strong></td><td><strong>Optimization</strong></td></tr><tr><td><strong>Seek Time</strong></td><td>Time for HDD head to reach the data location</td><td>Use SSD instead of HDD</td></tr><tr><td><strong>Rotational Delay</strong></td><td>Time waiting for the correct disk sector</td><td>Use NVMe SSDs</td></tr><tr><td><strong>Data Transfer Time</strong></td><td>Time to read/write data</td><td>Optimize storage architecture</td></tr></tbody></table>

#### **Formula for Disk Latency**

`Disk Latency=Seek Time + Rotational Delay + Data Transfer Time`

#### **Example Calculation**

* Seek Time = 5 ms
* Rotational Delay = 3 ms
* Data Transfer Time = 2 ms

_Total Latency = 5 + 3 + 2 = 10 ms_

#### **Optimization Techniques**

* Use **SSDs instead of HDDs**.
* Optimize **indexing and compression**.

### **4. Database Latency**

The delay in retrieving data from a database.

#### **Causes of Database Latency**

* **Slow Queries** → Poor indexing, large joins, unnecessary columns.
* **Locks and Contention** → Concurrent transactions blocking each other.
* **Network Bottlenecks** → Delays in transferring data from the database.

#### **Database Latency Breakdown**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Component</strong></td><td><strong>Definition</strong></td><td><strong>Optimization</strong></td></tr><tr><td><strong>Query Execution Time</strong></td><td>Time taken to run a query</td><td>Optimize queries</td></tr><tr><td><strong>Indexing Delay</strong></td><td>Time spent searching without indexes</td><td>Use proper indexing</td></tr><tr><td><strong>Lock Contention</strong></td><td>Delays due to concurrent transactions</td><td>Use optimistic locking</td></tr></tbody></table>

#### **Optimization Techniques**

* Use **indexes** to speed up lookups.
* Avoid **full-table scans**.
* Optimize **schema design** to reduce joins.

### **5. Memory Latency**

The delay in retrieving data from RAM.

#### **Causes of Memory Latency**

* **Cache Misses** → Data not found in L1/L2 cache.
* **Slow RAM Speeds** → Older DDR generations have higher latency.
* **Memory Bus Contention** → Multiple processes accessing memory simultaneously.

#### **Optimization Techniques**

* Use **faster RAM (DDR5 vs DDR4 vs DDR3)**.
* Optimize **memory allocation** (avoid excessive swapping).

## **2. Bandwidth**

The maximum rate of data transfer over a network connection in a given period.

### **Formula**

`Bandwidth = Total Data Transferred / Time Taken`

{% hint style="success" %}
**Throughput vs Bandwidth**: Bandwidth is the **theoretical limit**, whereas **throughput** is the actual amount of data transferred.

**Bandwidth Throttling**: Intentional reduction of bandwidth to control network congestion.
{% endhint %}

### **Optimization Techniques**

* Use **data compression** (e.g., Gzip, Brotli for web pages).
* Optimize **TCP window size** for large data transfers.
* Implement **QoS (Quality of Service) policies** to prioritize critical traffic.

## **3. Throughput**

The actual amount of data successfully transmitted per unit time.

### **Formula**

`Throughput = Total Successful Data Received / Time Taken`

### **Factors Affecting Throughput**

* **Network Congestion** – Delay caused by excessive traffic overwhelming network bandwidth.
* **Packet Loss** – Data packets failing to reach their destination due to network issues.
* **Hardware Limitations** – Performance bottlenecks due to outdated or underpowered network devices.

### **Optimization Techniques**

* Use **Load Balancing** to distribute traffic.
* Reduce **network bottlenecks** (e.g., upgrade network hardware).
* Implement **TCP optimization** (e.g., TCP Fast Open, congestion control algorithms).

## **4. Packet Loss**

The percentage of data packets that fail to reach their destination.

### **Formula**

`Packet Loss(%) = (Lost Packets / Total Packets Sent) × 100`

### **Causes**

* **Network Congestion** – Delay caused by excessive traffic overwhelming network bandwidth.
* **Faulty Hardware** – Malfunctioning network devices leading to degraded performance or connectivity issues.
* **Misconfigured Routers/Switches** – Incorrect network settings causing inefficient routing, bottlenecks, or connectivity failures.

### **Optimization Techniques**

* Use **redundancy mechanisms** like **Forward Error Correction (FEC)**.
* Implement **packet prioritization** for critical data.
* Optimize **MTU (Maximum Transmission Unit) size** to prevent fragmentation.

## **5. Jitter**

Variation in latency over time, causing delays in data packet arrival.

### **Formula**

`Jitter = ∣T2−T1∣`

where **T1** and **T2** are arrival times of two consecutive packets.

### **Impact**

* Causes **poor voice/video quality** in real-time applications (VoIP, Zoom, gaming).
* Leads to **buffering issues** in streaming services.

### **Optimization Techniques**

* Use **Jitter Buffers** to smooth packet delivery.
* Implement **Traffic Shaping** to prioritize real-time data.
* Reduce **network congestion** using QoS techniques.

## **6. Connection Establishment Time**

The time taken to establish a **network connection** (e.g., TCP handshake).

### **Formula**

`Connection Time = DNS Resolution Time + TCP Handshake Time + TLS Handshake Time`

### **Optimization Techniques**

* Use **persistent connections** (e.g., keep-alive in HTTP/2).
* Implement **TLS session resumption** to speed up HTTPS connections.
* Optimize **DNS resolution** using caching and fast resolvers.
