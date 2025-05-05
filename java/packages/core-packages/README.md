# Core Packages

## About

Core packages in Java are those essential packages that form the foundation of the Java Standard Edition (Java SE) platform. These packages provide the fundamental classes and interfaces necessary for writing Java programs. They include classes for basic data types, system input and output, utilities, networking, and more. The core packages are automatically available in every Java program and do not require explicit import statements for their use.

## Important core packages in Java

### **`java.lang`**:

* Contains classes that are fundamental to the design of the Java programming language, such as `Object`, `Class`, `String`, `Math`, `System`, `Thread`, and wrapper classes for primitive types like `Integer`, `Double`, etc.

### **`java.util`**:

* Provides the collections framework, legacy collection classes, event model, date and time facilities, internationalization, and miscellaneous utility classes (`ArrayList`, `HashMap`, `Collections`, `Date`, `Random`, etc.).

### **`java.io`**:

* Contains classes for system input and output through data streams, serialization, and the file system (`File`, `InputStream`, `OutputStream`, `Reader`, `Writer`, etc.).

### **`java.nio`**:

* Defines the buffer classes, which are used throughout the NIO packages to provide high-performance I/O operations (`ByteBuffer`, `CharBuffer`, `FileChannel`, `Path`, etc.).

### **`java.net`**:

* Provides classes for networking applications, including support for TCP, UDP, and HTTP (`Socket`, `ServerSocket`, `URL`, `URLConnection`, etc.).

### **`java.security`**:

* Contains the classes and interfaces that implement the Java security model, including the APIs for digital signatures, message digests, authentication, and access control (`MessageDigest`, `Signature`, `KeyStore`, `Permission`, etc.).

### **`java.sql`**:

* Provides the classes and interfaces for accessing and processing data stored in a data source (usually a relational database) using the Java Database Connectivity (JDBC) API (`Connection`, `Statement`, `ResultSet`, `DriverManager`, etc.).

### **`java.text`**:

* Provides classes and interfaces for handling text, dates, numbers, and messages in a manner independent of natural languages (`DateFormat`, `NumberFormat`, `SimpleDateFormat`, `MessageFormat`, etc.).

### **`java.time`**:

* Introduced in Java 8, this package contains classes for date and time manipulation (`LocalDate`, `LocalTime`, `LocalDateTime`, `ZonedDateTime`, etc.).

### **`java.math`**:

* Provides classes for performing arbitrary-precision integer arithmetic (`BigInteger`) and arbitrary-precision decimal arithmetic (`BigDecimal`).
