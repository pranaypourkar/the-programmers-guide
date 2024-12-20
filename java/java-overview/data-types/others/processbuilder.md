# ProcessBuilder

## **About**

The `ProcessBuilder` class, part of the `java.lang` package, provides a structured way to create and manage operating system processes in Java. Unlike the `Runtime.exec()` method, `ProcessBuilder` offers more control over process behavior, including redirecting standard input/output and modifying the environment variables for the new process. It is ideal for executing system commands, starting external applications, and interacting with the OS in a robust and flexible manner.

## **Features**

1. **Flexible Command Configuration**: Allows specifying commands and arguments in a list format.
2. **Environment Customization**: Supports modification of the process’s environment variables.
3. **I/O Redirection**: Provides fine-grained control over input, output, and error streams.
4. **Chaining Processes**: Enables chaining multiple commands or processes.
5. **Thread-Safe Execution**: Designed for safe usage in multi-threaded environments.

## **Internal Working**

The `ProcessBuilder` class works as a builder pattern for creating and managing system processes.

1. **Command Setup**:
   * The `command()` method defines the executable and its arguments. Internally, the `ProcessBuilder` stores the command as a `List<String>`.
2. **Environment Variables**:
   * The `environment()` method returns a `Map<String, String>` that represents the process’s environment variables. These variables are inherited from the parent process unless explicitly modified.
3. **I/O Redirection**:
   * The `redirectInput()`, `redirectOutput()`, and `redirectError()` methods manage the process’s I/O streams. By default, input, output, and error streams are inherited from the parent process.
4. **Process Creation**:
   * The `start()` method creates and starts the process using the specified command, environment, and redirection settings. Internally, this invokes native OS commands using the JVM’s process management facilities.
5. **Process Interaction**:
   * The `Process` object returned by `start()` allows interaction with the process, such as reading its output, writing to its input, and checking its exit status.

## **Key Methods**

<table data-header-hidden data-full-width="true"><thead><tr><th width="415"></th><th></th></tr></thead><tbody><tr><td><strong>Method</strong></td><td><strong>Description</strong></td></tr><tr><td><strong><code>command(List&#x3C;String> command)</code></strong></td><td>Sets or retrieves the command and arguments for the process.</td></tr><tr><td><strong><code>command(String... command)</code></strong></td><td>Sets the command and arguments for the process.</td></tr><tr><td><strong><code>environment()</code></strong></td><td>Returns a map of environment variables for the process.</td></tr><tr><td><strong><code>directory(File directory)</code></strong></td><td>Sets or retrieves the working directory for the process.</td></tr><tr><td><strong><code>redirectInput()</code></strong></td><td>Configures the source for the process’s input (e.g., file or stream).</td></tr><tr><td><strong><code>redirectOutput()</code></strong></td><td>Configures the destination for the process’s standard output.</td></tr><tr><td><strong><code>redirectError()</code></strong></td><td>Configures the destination for the process’s error output.</td></tr><tr><td><strong><code>redirectErrorStream(boolean redirect)</code></strong></td><td>Merges standard error with standard output if set to <code>true</code>.</td></tr><tr><td><strong><code>start()</code></strong></td><td>Starts the process and returns a <code>Process</code> object.</td></tr></tbody></table>

## **Big(O) for Operations**

* **Process Creation**: O(1) (dependent on the OS)
* **Environment Access**: O(n) (where `n` is the number of environment variables)
* **I/O Redirection**: O(1) (configuration is constant time)

## **Limitations**

1. **Platform Dependence**: The behavior of executed commands depends on the underlying operating system.
2. **Error Handling**: Errors in command syntax or missing executables can lead to runtime exceptions.
3. **Thread Blocking**: If output streams are not managed, processes may hang due to full buffers.
4. **Complex Commands**: Handling complex shell commands (like pipelines) requires extra work, such as using shell interpreters (e.g., `bash`).

## **Real-World Usage**

1. **System Administration**: Executing system commands for file manipulation, backups, or server management.
2. **Third-Party Integration**: Running external tools or scripts as part of a larger application workflow.
3. **Testing and Automation**: Automating system-level tasks or integrating with CI/CD pipelines.
4. **Logging and Monitoring**: Running diagnostic commands and capturing their output for monitoring purposes.

## **Examples**

### **1. Running a Simple Command**

```java
import java.io.IOException;

public class ProcessBuilderExample {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("echo", "Hello, ProcessBuilder!");
        try {
            Process process = pb.start();
            process.waitFor(); // Wait for the process to finish
            System.out.println("Process completed."); // Output: Process completed.
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

### **2. Redirecting Output to a File**

```java
import java.io.File;

public class ProcessBuilderExample {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("ls");
        pb.redirectOutput(new File("output.txt")); // Redirect output to a file
        try {
            pb.start();
            System.out.println("Output written to output.txt"); // Output: Output written to output.txt
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### **3. Modifying Environment Variables**

```java
import java.util.Map;

public class ProcessBuilderExample {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("printenv");
        Map<String, String> env = pb.environment();
        env.put("MY_VAR", "HelloWorld"); // Add custom environment variable
        try {
            pb.start();
            System.out.println("Custom environment set."); // Output: Custom environment set.
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### **4. Handling Input and Output**

```java
import java.io.*;

public class ProcessBuilderExample {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("cat");
        pb.redirectInput(ProcessBuilder.Redirect.PIPE); // Redirect input
        pb.redirectOutput(ProcessBuilder.Redirect.INHERIT); // Redirect output to console

        try {
            Process process = pb.start();
            try (Writer writer = new OutputStreamWriter(process.getOutputStream())) {
                writer.write("Hello from ProcessBuilder!"); // Writing to process input
                writer.flush();
            }
            process.waitFor();
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

### **5. Combining Standard and Error Streams**

```java
public class ProcessBuilderExample {
    public static void main(String[] args) {
        ProcessBuilder pb = new ProcessBuilder("ls", "-l", "/nonexistent");
        pb.redirectErrorStream(true); // Combine standard error and standard output
        try {
            Process process = pb.start();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println(line); // Output: Combined standard and error output
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

