# FileUtils

## About

`FileUtils` is a utility class from the Apache Commons IO library that simplifies operations involving `java.io.File` objects. It provides high-level methods for file copying, reading, writing, deleting, comparing, and directory traversal.

This class helps eliminate boilerplate code often required when using Java’s native file APIs, and it ensures safe and efficient handling of file operations.

## Key Features

`FileUtils` provides practical, high-level operations for handling files and directories. It abstracts away the repetitive and error-prone boilerplate associated with `java.io.File` and `FileInputStream`/`FileOutputStream`.

### 1. Copying a File

Copies the contents of one file to another location. If the destination file exists, it will be overwritten.

**Use Case:**

Used in backup systems, file transfer utilities, or when moving files between temporary and permanent storage.

**Example:**

```java
import org.apache.commons.io.FileUtils;
import java.io.File;
import java.io.IOException;

public class FileCopyExample {
    public static void main(String[] args) throws IOException {
        File source = new File("C:/reports/report.txt");
        File destination = new File("D:/backup/report-copy.txt");
        FileUtils.copyFile(source, destination);
        System.out.println("File copied successfully.");
    }
}
```

### 2. Copying a Directory

Recursively copies a directory along with all its subdirectories and files to a new location.

**Use Case:**

Used for full-folder backup, project export, or copying data sets.

**Example:**

```java
File sourceDir = new File("C:/projects/projectA");
File targetDir = new File("D:/archives/projectA-backup");
FileUtils.copyDirectory(sourceDir, targetDir);
```

### 3. Reading File Content into a String

Reads the entire file content into a single string using the specified encoding.

**Use Case:**

Used when reading configuration files, templates, or small data files.

**Example:**

```java
File file = new File("C:/data/config.txt");
String content = FileUtils.readFileToString(file, "UTF-8");
System.out.println("Config contents:\n" + content);
```

### 4. Reading Lines into a List

Reads a file line-by-line into a `List<String>`, which can be processed further.

**Use Case:**

Useful for reading CSVs, logs, or any line-oriented files.

**Example:**

```java
List<String> lines = FileUtils.readLines(new File("C:/logs/server.log"), "UTF-8");
for (String line : lines) {
    if (line.contains("ERROR")) {
        System.out.println("Found error: " + line);
    }
}
```

### 5. Writing a String to a File

Writes text to a file, creating or overwriting it. We can also append instead of overwrite.

**Use Case:**

Used in logging, report generation, configuration writing, or saving user-generated content.

**Example:**

```java
File file = new File("C:/output/report.txt");
String content = "Report generated on " + java.time.LocalDate.now();
FileUtils.writeStringToFile(file, content, "UTF-8");
```

**Appending example**:

```java
FileUtils.writeStringToFile(file, "\nAdditional data", "UTF-8", true);
```

### 6. Deleting Files or Directories

Deletes individual files or entire directory structures, including all contents.

**Use Case:**

Used in cleanup operations, temp folder purging, or scheduled deletion tasks.

**Example (delete file):**

```java
File fileToDelete = new File("C:/temp/oldfile.txt");
FileUtils.forceDelete(fileToDelete);
```

**Delete directory recursively**:

```java
FileUtils.deleteDirectory(new File("C:/temp/oldfolder"));
```

### 7. Cleaning a Directory

Deletes the contents of a directory, but not the directory itself.

**Use Case:**

Used when reusing temporary folders or clearing staging areas before writing new data.

**Example:**

```java
File tempDir = new File("C:/temp/cache/");
FileUtils.cleanDirectory(tempDir);
```

### 8. Comparing File Content

Checks whether two files have the same content byte-for-byte.

**Use Case:**

Used in file integrity validation, de-duplication logic, or detecting file modifications.

**Example:**

```java
File file1 = new File("C:/docs/fileA.txt");
File file2 = new File("C:/docs/fileB.txt");

if (FileUtils.contentEquals(file1, file2)) {
    System.out.println("Files are identical.");
} else {
    System.out.println("Files differ.");
}
```

### 9. Calculating File and Directory Size

Returns the size in bytes of a file or the total size of all contents in a directory.

**Use Case:**

Used in disk usage reports, upload limit validations, or quota systems.

**Example:**

```java
File directory = new File("C:/data/uploads");
long totalBytes = FileUtils.sizeOfDirectory(directory);
System.out.println("Total size: " + totalBytes + " bytes");
```

### 10. Moving Files or Directories

Moves a file or directory to a new location. The original is deleted.

**Use Case:**

Used when processing files in stages (e.g., staging → processing → archive).

**Example:**

```java
File source = new File("C:/incoming/invoice.pdf");
File target = new File("C:/processed/invoice.pdf");
FileUtils.moveFile(source, target);
```



