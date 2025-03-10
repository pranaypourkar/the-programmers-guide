# Heap Memory



<figure><img src="../../../../.gitbook/assets/JVM_Heap_Memory_Structure-01.png" alt="" width="482"><figcaption></figcaption></figure>

### **Heap Memory Tuning & Optimization**

Heap size can be **configured** using JVM options:

```sh
java -Xms512m -Xmx4G -XX:NewRatio=2 -XX:+UseG1GC
```

<table><thead><tr><th width="280">Option</th><th>Description</th></tr></thead><tbody><tr><td><code>-Xms512m</code></td><td>Initial heap size (512MB)</td></tr><tr><td><code>-Xmx4G</code></td><td>Maximum heap size (4GB)</td></tr><tr><td><code>-XX:NewRatio=2</code></td><td>Young:Old Generation ratio (1:2)</td></tr><tr><td><code>-XX:+UseG1GC</code></td><td>Use <strong>G1 Garbage Collector</strong></td></tr></tbody></table>

### **Common Heap Memory Issues**

#### **`OutOfMemoryError (OOM)`**

Occurs when **heap is full and GC fails to free memory**.

**Example:**

```java
import java.util.ArrayList;
import java.util.List;

public class OOMExample {
    public static void main(String[] args) {
        List<byte[]> list = new ArrayList<>();
        while (true) {
            list.add(new byte[10 * 1024 * 1024]); // Allocating 10MB repeatedly
        }
    }
}
```

**Throws `java.lang.OutOfMemoryError: Java heap space`**

#### **Memory Leak**

* **Objects remain referenced** even though they are no longer needed.
* Example: **Unclosed JDBC connections, static collections holding references**.

#### **High GC Pause Times**

* Full GC causes **long application pauses**.
* Solution: **Tune GC algorithms (Use G1/ZGC for low-latency apps).**
