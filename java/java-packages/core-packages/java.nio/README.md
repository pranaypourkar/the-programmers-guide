# java.nio

## About

The `java.nio` (New I/O) package, introduced in Java 1.4, provides a more efficient, buffer-oriented, and channel-based approach to I/O operations compared to the traditional stream-based I/O (`java.io`). It was designed for **high-performance, scalable I/O**, particularly for applications such as servers, networked services, and file-processing systems.

Key features of `java.nio` include:

* **Buffers** for storing and manipulating data.
* **Channels** for reading/writing data asynchronously or synchronously.
* **Selectors** for non-blocking multiplexed I/O.
* **Memory-mapped files** for high-speed file access.
* **Charset** and **encoding/decoding** support.

It emphasizes **non-blocking I/O**, where threads can perform useful work instead of waiting for I/O operations to complete.

## **Key Classes and Interfaces**

### **1. Buffer Classes**

Buffers are containers for data, supporting relative and absolute get/put operations.

* **`Buffer`** (abstract class) – Base class for all buffers, with properties like capacity, position, limit, and mark.
* **`ByteBuffer`** – Stores bytes; can be direct (allocated outside the heap for faster I/O) or non-direct.
* **`CharBuffer`** – Stores characters (UTF-16).
* **`ShortBuffer`** – Stores short integers.
* **`IntBuffer`** – Stores integers.
* **`LongBuffer`** – Stores long integers.
* **`FloatBuffer`** – Stores floats.
* **`DoubleBuffer`** – Stores doubles.
* **`MappedByteBuffer`** – A special `ByteBuffer` for memory-mapped file regions.

### **2. Channel Classes and Interfaces**

Channels connect I/O sources/sinks to buffers.

* **`ReadableByteChannel`** – Interface for channels that can read data into buffers.
* **`WritableByteChannel`** – Interface for channels that can write data from buffers.
* **`FileChannel`** – Reads/writes from files, supports memory-mapping.
* **`SocketChannel`** – For TCP socket connections.
* **`ServerSocketChannel`** – For listening to incoming TCP connections.
* **`DatagramChannel`** – For UDP connections.
* **`Pipe`** – Two-way communication channel between threads.

### **3. Selector and SelectionKey**

Used for **non-blocking multiplexed I/O**.

* **`Selector`** – Monitors multiple channels for events (read, write, accept, connect).
* **`SelectionKey`** – Represents the registration of a channel with a selector, holding interest and ready-operation sets.

### **4. Charset and Encoding Utilities**

For handling text encoding/decoding.

* **`Charset`** – Represents a character set.
* **`CharsetEncoder`** – Encodes characters into bytes.
* **`CharsetDecoder`** – Decodes bytes into characters.

### **5. Other Utilities**

* **`ByteOrder`** – Represents the byte order (endianness) used by buffers (`BIG_ENDIAN` or `LITTLE_ENDIAN`).
* **`BufferOverflowException` / `BufferUnderflowException`** – Exceptions for buffer boundary errors.
* **`InvalidMarkException`** – Exception for invalid buffer mark usage.
