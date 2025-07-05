# Apache Commons IO

## About

**Apache Commons IO** is a part of the Apache Commons project and provides utility classes and functions to simplify I/O (Input/Output) operations in Java. It mainly deals with operations related to files, directories, input streams, output streams, readers, writers, and file filters.

This library is highly useful when working with file systems and stream handling in a safe, clean, and reliable way. It reduces boilerplate code that is often repetitive and error-prone in raw Java I/O code.

## Maven Dependency

To use Apache Commons IO in our Java project, include the following dependency in our Maven `pom.xml`:

```xml
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.15.1</version> <!-- Use the latest stable version -->
</dependency>
```

## Key Packages and Classes

Apache Commons IO is structured around several utility classes, each targeting a specific concern related to file or stream I/O operations. These classes are located primarily in the package `org.apache.commons.io` and its sub-packages.

Each class addresses common use cases in file and stream manipulation, enabling cleaner and more reliable code.

### 1. `FileUtils`

**Purpose**: Simplifies operations involving files and directories.

**Use Cases**:

* Copying files or entire directory trees from one location to another.
* Reading a file's content into a `String` or `List<String>`.
* Writing data to a file in a single line of code.
* Deleting files and directories recursively.
* Comparing file contents.
* Calculating the size of a directory.
* Cleaning the contents of a directory without deleting the directory itself.

`FileUtils` is one of the most widely used classes when working with the file system, as it provides a high-level abstraction over common file operations.

### 2. `IOUtils`

**Purpose**: Provides utilities for stream and reader/writer operations.

**Use Cases**:

* Copying data between `InputStream` and `OutputStream`, or `Reader` and `Writer`.
* Reading an entire stream into a `String` or `byte[]`.
* Safely closing streams using `closeQuietly` to avoid repetitive try-catch blocks.
* Working with buffered reading/writing without writing boilerplate code.
* Skipping bytes or characters in streams.

`IOUtils` is stream-focused and ideal when working with sockets, HTTP requests, or raw data input/output.

### 3. `FilenameUtils`

**Purpose**: Deals with file name and path manipulations in a platform-independent way.

**Use Cases**:

* Extracting the base name, extension, or full path from a file path.
* Normalizing paths across platforms (handling separators like `/` or `\`).
* Concatenating paths or validating whether a file is in a specific directory.
* Comparing file paths with or without case sensitivity.

This class is helpful when writing code that needs to manipulate paths dynamically, especially in cross-platform environments.

### 4. `FileSystemUtils`

**Purpose**: Interacts with the underlying file system to query available disk space.

**Use Cases**:

* Retrieving the amount of free space on a specific drive or partition.
* Performing pre-checks before writing large files or performing disk-intensive operations.

This class is limited in use and may not work uniformly across all platforms but is helpful for disk space validations in applications like file uploaders or backup systems.

### 5. `LineIterator`

**Purpose**: Allows efficient line-by-line reading of files or input streams without loading the entire content into memory.

**Use Cases**:

* Reading large files where loading the entire content is impractical.
* Processing logs, CSVs, or text files line by line.
* Implementing custom line filters or parsers during iteration.

This is especially useful in memory-constrained environments or when processing large datasets.

### 6. `FileFilterUtils`

**Purpose**: Provides factory methods for creating `FileFilter` or `FilenameFilter` implementations.

**Use Cases**:

* Filtering files based on extension, size, age, or naming patterns.
* Creating complex file filters using AND/OR/NOT combinations.
* Listing files in a directory that match specific criteria (e.g., all `.txt` files larger than 1MB).

This class improves code readability and reduces manual implementation of file filtering logic.

### 7. `EndianUtils`

**Purpose**: Supports conversions between different byte orders (big endian and little endian).

**Use Cases**:

* Reading and writing data structures to binary files where byte order matters.
* Interfacing with external systems or file formats that require specific endianness.

This class is helpful in low-level file manipulation, such as handling binary data from sensors or hardware systems.

### 8. `HexDump`

**Purpose**: Generates hexadecimal representations of binary data.

**Use Cases**:

* Debugging binary files or streams.
* Logging raw byte arrays in a human-readable format.
* Visualizing content of files for troubleshooting or validation.

Useful in development tools, forensic analysis, and debugging byte-level data processing.

### 9. `DirectoryWalker`

**Purpose**: Abstract class that simplifies recursive traversal of directories.

**Use Cases**:

* Walking through a directory structure to perform a custom operation on each file or folder.
* Building tools that index, search, or process hierarchical file data.

It provides a template method-based design for writing your own file-walking logic.

