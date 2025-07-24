# java.net.InetAddress

## About

`InetAddress` is a class in the `java.net` package that represents an IP address — either IPv4 or IPv6. It is used to identify hosts (computers, servers, etc.) on the Internet or a local network. We can use `InetAddress` to resolve hostnames to IP addresses and vice versa, or to get information about the local machine’s IP configuration.

## **Why It’s Important**

In networking applications, we often need to work with IP addresses — either to connect to a server, identify a client, or bind a service to a specific interface. `InetAddress` provides a high-level abstraction over IP addresses, simplifying these operations.

It hides low-level byte-level IP address handling and makes tasks like DNS lookups easy using simple methods.

## **Key Methods**

<table><thead><tr><th width="263.92620849609375">Method</th><th>Description</th></tr></thead><tbody><tr><td><code>getByName(String host)</code></td><td>Returns the IP address of the given hostname.</td></tr><tr><td><code>getAllByName(String host)</code></td><td>Returns all IP addresses associated with a hostname.</td></tr><tr><td><code>getLocalHost()</code></td><td>Returns the IP address of the local machine.</td></tr><tr><td><code>getHostName()</code></td><td>Returns the hostname associated with this IP address.</td></tr><tr><td><code>getHostAddress()</code></td><td>Returns the textual representation of the IP address.</td></tr><tr><td><code>isReachable(int timeout)</code></td><td>Tests if the address is reachable within a timeout period.</td></tr><tr><td><code>equals(Object obj)</code></td><td>Compares two <code>InetAddress</code> objects for equality.</td></tr><tr><td><code>toString()</code></td><td>Returns the string representation in the format: hostname / IP.</td></tr></tbody></table>

## **Example**

```java
import java.net.*;

public class InetAddressExample {
    public static void main(String[] args) throws Exception {
        InetAddress address = InetAddress.getByName("openai.com");

        System.out.println("Host Name: " + address.getHostName());
        System.out.println("IP Address: " + address.getHostAddress());
        System.out.println("Is Reachable: " + address.isReachable(2000));
    }
}
```

```
Host Name: openai.com
IP Address: 104.18.30.59
Is Reachable: true
```

```java
import java.net.InetAddress;
import java.net.UnknownHostException;

public class Main {
    public static void main(String[] args) {
        try {
            InetAddress localHost = InetAddress.getLocalHost();
            System.out.println("Local Host: " + localHost);
            System.out.println("Host Name: " + localHost.getHostName());
            System.out.println("Host Address: " + localHost.getHostAddress());
        } catch (UnknownHostException e) {
            e.printStackTrace();
        }
    }
}
```

```
Local Host: my-machine/192.168.1.10
Host Name: my-machine
Host Address: 192.168.1.10
```

