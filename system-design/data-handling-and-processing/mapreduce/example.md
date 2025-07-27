# Example

## Web Log Analysis – Count 404 Errors

Parse a large web server log file and count how many times the server returned a **404 (Not Found)** HTTP status code.

#### **Input Sample (webserver.log)**

```
127.0.0.1 - - [23/Jul/2024:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1024
127.0.0.1 - - [23/Jul/2024:10:01:00 +0000] "GET /notfound.html HTTP/1.1" 404 512
127.0.0.1 - - [23/Jul/2024:10:02:00 +0000] "GET /page.html HTTP/1.1" 404 0
```

### Solution 1: Using Spring libraries

#### Sample Log File (`webserver.log`)

```plaintext
127.0.0.1 - - [23/Jul/2024:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1024
127.0.0.1 - - [23/Jul/2024:10:01:00 +0000] "GET /notfound.html HTTP/1.1" 404 512
127.0.0.1 - - [23/Jul/2024:10:02:00 +0000] "GET /page.html HTTP/1.1" 404 0
```

Place this file in `src/main/resources/` as `webserver.log`.

#### Java Code: Simulating MapReduce

```java
package com.example.logprocessor;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Stream;

@SpringBootApplication
public class WebLog404CounterApp implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(WebLog404CounterApp.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        AtomicInteger count404 = new AtomicInteger(0);

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                getClass().getClassLoader().getResourceAsStream("webserver.log")))) {

            Stream<String> lines = reader.lines();

            // Mapper + Reducer (Combined using Stream API)
            lines.parallel()
                .map(line -> {
                    String[] tokens = line.split(" ");
                    if (tokens.length > 8 && "404".equals(tokens[8])) {
                        return 1;  // 404 found
                    } else {
                        return 0;
                    }
                })
                .forEach(count -> count404.addAndGet(count));

            System.out.println("Total 404 Errors: " + count404.get());
        }
    }
}
```

#### Output

```
Total 404 Errors: 2
```



## **Sales Aggregation – Total Sales per Product**

Given a file containing sales data (`product,price`), calculate the **total revenue per product**.

#### **Input Sample (sales.txt)**

```
Book,12
Pen,3
Book,10
Notebook,8
Pen,2
```

### Solution 1: Using Hadoop

#### 1. **Mapper Class**

```java
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

import java.io.IOException;

/**
 * Mapper Class for Sales Aggregation.
 * Input: product,price (e.g., Book,12)
 * Output: (product, price)
 */
public class SalesMapper extends Mapper<LongWritable, Text, Text, IntWritable> {

    private Text product = new Text();
    private IntWritable price = new IntWritable();

    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        // Each line of the file: "Product,Price"
        String line = value.toString();
        String[] parts = line.split(",");

        if (parts.length == 2) {
            product.set(parts[0].trim());             // e.g., "Book"
            price.set(Integer.parseInt(parts[1].trim())); // e.g., 12
            context.write(product, price);            // Emits (Book, 12)
        }
    }
}
```

#### 2. **Reducer Class**

```java
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

/**
 * Reducer Class for Sales Aggregation.
 * Input: (product, list of prices)
 * Output: (product, total sales)
 */
public class SalesReducer extends Reducer<Text, IntWritable, Text, IntWritable> {

    private IntWritable totalSales = new IntWritable();

    @Override
    protected void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
        int sum = 0;

        for (IntWritable val : values) {
            sum += val.get();  // Add all sales for the same product
        }

        totalSales.set(sum);
        context.write(key, totalSales); // Emits (Book, 22)
    }
}
```

#### 3. **Driver Class**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/**
 * Driver Class to run Sales Aggregation MapReduce job.
 */
public class SalesDriver {

    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: SalesDriver <input path> <output path>");
            System.exit(-1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Sales Aggregation");

        job.setJarByClass(SalesDriver.class);
        job.setMapperClass(SalesMapper.class);
        job.setReducerClass(SalesReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));   // Input: sales.txt
        FileOutputFormat.setOutputPath(job, new Path(args[1])); // Output folder

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
```

#### Running the MapReduce Job

```bash
# Create input directory and put file in HDFS
hadoop fs -mkdir /input
hadoop fs -put sales.txt /input/

# Run the job
hadoop jar sales-aggregation.jar com.example.SalesDriver /input /output

# Check result
hadoop fs -cat /output/part-r-00000
```

{% hint style="success" %}
ha&#x64;_&#x6F;op jar sales-aggregation.jar com.example.SalesDriver /input /output_

This does the following:

1. Sets up the Hadoop environment with the configuration and resources.
2. Initializes YARN or LocalRunner (depending on cluster mode).
3. Submits your job using the Hadoop JobTracker / ResourceManager.
4. Spawns Mapper and Reducer tasks in containers.
5. Reads from HDFS input, writes to HDFS output.
{% endhint %}

#### Output

```
Book    22
Notebook 8
Pen     5
```
