# java.net

## About

The `java.net` package provides classes for implementing networking applications in Java. It offers support for both low-level communication (e.g., sockets) and high-level abstractions (e.g., URLs). This package is essential for creating Java applications that communicate over TCP/IP, including web clients, servers, and distributed systems.

It allows developers to work with IP addresses, hostnames, ports, sockets, datagrams, and HTTP requests.

## **Key Classes and Interfaces**

### **URL**

Represents a Uniform Resource Locator, a pointer to a "resource" on the World Wide Web.\
Useful methods: `openConnection()`, `getHost()`, `getPath()`, `getProtocol()`.

### **URLConnection**

Represents a communication link between the application and a URL.\
Allows you to read from and write to a resource referenced by a URL.

### **InetAddress**

Represents an IP address. Used for DNS resolution and IP-level information.\
Key methods: `getByName()`, `getLocalHost()`, `getHostAddress()`.

### **Socket**

Implements client-side TCP connections. Allows bi-directional communication with a server.\
Used with `InputStream` and `OutputStream`.

### **ServerSocket**

Implements server-side TCP communication. Listens on a port and accepts incoming connections.\
Used to create socket-based servers.

### **DatagramSocket**

Implements UDP communication. Sends and receives datagram packets (connectionless).\
Used when low-latency and stateless communication is required.

### **DatagramPacket**

Represents a data packet sent or received via `DatagramSocket`.

### **URI**

Represents a Uniform Resource Identifier and provides methods for parsing and validating URIs.

### **HttpURLConnection**

A subclass of `URLConnection` that supports HTTP-specific features such as request methods, headers, response codes.
