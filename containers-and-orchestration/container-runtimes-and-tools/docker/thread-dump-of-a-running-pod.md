# Thread Dump of a running pod

## About

To take a thread dump of a running pod (container) in a Dockerized environment, including for a service like ActiveMQ, we can follow these steps.

## Steps to Take a Thread Dump of a Running Pod

### **1. Identify the Running Container Name**:

First, identify the container name of our ActiveMQ pod (or any other pod) that is running. If we're using Docker Compose, the container name is likely defined in the `docker-compose.yml` file under the `container_name` key.

Alternatively, list all running containers with:

```bash
docker ps
```

This will display all running containers and their names, like:

```bash
CONTAINER ID        IMAGE                             COMMAND                  CREATED             STATUS             PORTS                                        NAMES
f1e8c1d35d2c        symptoma/activemq:5.17.3          "/bin/sh -c '/opt/act…"   10 minutes ago      Up 10 minutes      61616/tcp, 8161/tcp                          activemq
```

The container name here is `activemq`.

### **2. Access the Container**

Once we have the container name, we can execute commands within the container. Use the `docker exec` command to enter the container's shell:

```bash
docker exec -it activemq /bin/bash
```

### **3. Get the Java Process ID**

ActiveMQ is typically running as a Java process inside the container. We need to identify the PID (process ID) of the Java process running ActiveMQ.

We can list all Java processes inside the container using:

```bash
ps aux | grep java
```

The output will look something like this:

```bash
root     11234  1.2  2.5 1913928 50764 ?       Sl   10:01   0:15 java -Xms512m -Xmx1024m -jar /opt/activemq/activemq.jar
```

Here, the Java process ID is `11234`.

### **4. Take a Thread Dump**

Now that we have the PID of the Java process, we can generate a thread dump using the `jstack` command. In the container, if `jstack` is available, run:

```bash
jstack 11234 > /tmp/thread_dump.txt
```

This will generate a thread dump and save it to `/tmp/thread_dump.txt` inside the container.

### **5. Retrieve the Thread Dump**

After generating the thread dump, we can copy it to our local machine using the `docker cp` command:

```bash
docker cp activemq:/tmp/thread_dump.txt ./thread_dump.txt
```

Now, the thread dump will be available on our local machine.

### **6. Analyze the Thread Dump**

Open the `thread_dump.txt` file in a text editor and analyze the output. A thread dump shows all the threads in the JVM, their states, and what they're currently doing. It can help diagnose issues such as thread contention, deadlocks, or long-running threads.
