# SystemUtils

## About

`SystemUtils` is a utility class provided by **Apache Commons Lang** for accessing **system-related information** such as:

* Java runtime version
* Operating system details
* File system properties
* User environment details
* Temporary and user directories

Java’s built-in `System.getProperty()` works well, but it's verbose and lacks consistency. `SystemUtils` provides a **clean, constant-based**, and **null-safe** way to retrieve environment and system properties.

## Characteristics

* All fields and methods are **static**.
* Offers system-level constants for Java and OS properties.
* Safer alternative to `System.getProperty(...)`.
* Commonly used in **logging**, **debugging**, **platform-specific behavior**, and **testing**.

## Maven Dependency & Import

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>3.12.0</version> <!-- or latest -->
</dependency>
```

```java
import org.apache.commons.lang3.SystemUtils;
```

## Commonly Used Constants and Methods

### 1. Java Version Information

<table><thead><tr><th width="283.006103515625">Constant</th><th>Description</th></tr></thead><tbody><tr><td><code>JAVA_VERSION</code></td><td>Java version (e.g., <code>"17"</code> or <code>"1.8.0_321"</code>)</td></tr><tr><td><code>JAVA_VERSION_FLOAT</code></td><td>Java version as float</td></tr><tr><td><code>JAVA_VERSION_TRIMMED</code></td><td>Trimmed version (e.g., <code>"17"</code>, <code>"11"</code>, <code>"1.8"</code>)</td></tr><tr><td><code>JAVA_VENDOR</code></td><td>Java vendor (e.g., <code>"Oracle Corporation"</code>)</td></tr><tr><td><code>JAVA_VENDOR_URL</code></td><td>Vendor URL</td></tr><tr><td><code>JAVA_HOME</code></td><td>Path to installed Java home</td></tr></tbody></table>

**Example:**

```java
System.out.println(SystemUtils.JAVA_VERSION); // e.g., "17.0.2"
```

### 2. Operating System Details

| Constant        | Description                       |
| --------------- | --------------------------------- |
| `OS_NAME`       | OS name (e.g., `"Windows 10"`)    |
| `OS_VERSION`    | OS version                        |
| `OS_ARCH`       | Architecture (`"x86"`, `"amd64"`) |
| `IS_OS_WINDOWS` | Boolean flag if Windows           |
| `IS_OS_LINUX`   | Boolean flag if Linux             |
| `IS_OS_MAC`     | Boolean flag if macOS             |

**Example:**

```java
if (SystemUtils.IS_OS_WINDOWS) {
    // Windows-specific code
}
```

### 3. User Environment Details

| Constant         | Description                    |
| ---------------- | ------------------------------ |
| `USER_NAME`      | System username                |
| `USER_HOME`      | Home directory path            |
| `USER_DIR`       | Working directory              |
| `TMP_DIR`        | Temporary directory            |
| `LINE_SEPARATOR` | OS-specific newline ( or `\r`) |

**Example:**

```java
String tmpPath = SystemUtils.TMP_DIR;
```

### 4. File System Properties

<table><thead><tr><th width="346.439208984375">Constant</th><th>Description</th></tr></thead><tbody><tr><td><code>FILE_SEPARATOR</code></td><td>OS file separator (<code>"/"</code> or <code>"\\"</code>)</td></tr><tr><td><code>PATH_SEPARATOR</code></td><td>OS path separator (<code>":"</code> or <code>";"</code>)</td></tr><tr><td><code>LINE_SEPARATOR</code></td><td>OS-specific new line</td></tr></tbody></table>

These help write **cross-platform file-handling logic**.

## Why Use `SystemUtils` Instead of `System.getProperty()`?

| Concern           | `System.getProperty()`                | `SystemUtils` Advantage                   |
| ----------------- | ------------------------------------- | ----------------------------------------- |
| Null safety       | Returns null, needs checking          | Safe constants and clear names            |
| Readability       | `"os.name"`, `"java.version"` unclear | `SystemUtils.OS_NAME` is self-explanatory |
| Constants & flags | Must write logic manually             | Provides `IS_OS_*` flags directly         |
| Duplication       | Often repeated keys in code           | Centralized and standardized references   |





