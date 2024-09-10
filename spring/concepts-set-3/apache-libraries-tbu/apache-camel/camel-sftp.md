# Camel SFTP

## About

Apache Camel’s SFTP component allows to transfer files to and from SFTP (SSH File Transfer Protocol) servers. It supports both the sending (uploading) and receiving (downloading) of files, making it useful in various integration scenarios where secure file transfer is required.

For more details, refer to official documentation page - [https://camel.apache.org/components/4.4.x/sftp-component.html](https://camel.apache.org/components/4.4.x/sftp-component.html)

## Key Aspects of Camel SFTP

### **Component URI Format**

The basic URI format for the Camel SFTP component looks like this:

```ruby
sftp://[username@]hostname[:port]/directoryname[?options]
```

* `username@hostname`: Specifies the username and the hostname of the SFTP server.
* `:port`: Optional; the port number. The default SFTP port is 22.
* `directoryname`: The remote directory on the SFTP server.
* `options`: Additional configuration options, like connection timeouts, key-based authentication, or polling intervals.

**Example**:

```java
from("sftp://user@myhost.com/data?password=secret")
.to("file:/local/storage");
```

In this example, Camel downloads files from the `/data` directory of the SFTP server `myhost.com` and stores them in the local `/local/storage` directory.

### **Options and Configuration**

The Camel SFTP component provides numerous options to fine-tune the behavior of file transfers. Here are some commonly used options:

{% hint style="info" %}
For more details, refer to the official documentation - [https://camel.apache.org/components/4.4.x/sftp-component.html#\_query\_parameters](https://camel.apache.org/components/4.4.x/sftp-component.html#\_query\_parameters)
{% endhint %}

*   **fileName**: Specifies a specific file to download or upload.

    ```java
    from("sftp://user@myhost.com/data?password=secret&fileName=myfile.txt")
    .to("file:/local/files");
    ```
*   **binary**: Set to `true` to treat the files as binary files. The default is `false`, meaning files are transferred in ASCII mode.

    ```java
    from("sftp://user@myhost.com/data?password=secret&binary=true")
    .to("file:/local/files");
    ```
*   **disconnect**: Whether or not to disconnect from the SFTP server after each operation. The default is `false`.

    ```java
    from("sftp://user@myhost.com/data?password=secret&disconnect=true")
    .to("file:/local/files");
    ```
*   **delay**: Sets the polling interval (in milliseconds) for the SFTP server. By default, this is 500 milliseconds.

    ```java
    from("sftp://user@myhost.com/data?password=secret&delay=10000")
    .to("file:/local/files");
    ```
*   **delete**: Whether to delete files after they have been successfully transferred. The default is `false`.

    ```java
    from("sftp://user@myhost.com/data?password=secret&delete=true")
    .to("file:/local/files");
    ```
*   **passiveMode**: Whether to use passive mode. The default is `false`.

    ```java
    from("sftp://user@myhost.com/data?password=secret&passiveMode=true")
    .to("file:/local/files");
    ```

### **SFTP Security Options**

*   **Strict Host Key Checking**: By default, SFTP follows strict host key checking. We can configure this using `knownHostsFile` and `strictHostKeyChecking` options.

    ```java
    from("sftp://user@myhost.com/data?privateKeyFile=/home/user/.ssh/id_rsa&knownHostsFile=/home/user/.ssh/known_hosts&strictHostKeyChecking=yes")
    .to("file:/local/files");
    ```
*   **Private Key Authentication**: We can specify the private key file and its passphrase for secure authentication.

    ```java
    from("sftp://user@myhost.com/data?privateKeyFile=/home/user/.ssh/id_rsa&privateKeyPassphrase=secret")
    .to("file:/local/files");
    ```

### **Authentication Options**

There are two main ways to authenticate when using SFTP in Camel: **password-based** and **key-based**.

*   **Password Authentication**: If the SFTP server uses password authentication, we can provide the password as an option in the URI.

    ```java
    from("sftp://user@myhost.com/data?password=secret")
    .to("file:/local/files");
    ```
*   **Key-based Authentication**: Key-based authentication is more secure and widely used for automated processes.

    ```java
    from("sftp://user@myhost.com/data?privateKeyFile=/home/user/.ssh/id_rsa&knownHostsFile=/home/user/.ssh/known_hosts")
    .to("file:/local/files");
    ```

    * `privateKeyFile`: Specifies the path to the private key file.
    * `knownHostsFile`: Specifies the known hosts file, ensuring the server is trusted.
    * If the private key is encrypted, we can use the `privateKeyPassphrase` option to provide the passphrase.

### **SFTP File Filters Options**

We can filter the files that are picked up by the SFTP component by using Camel's file filter options:

*   **Ant-style file filtering**:

    ```java
    from("sftp://user@myhost.com/data?password=secret&include=.*\\.txt")
    .to("file:/local/files");
    ```

    This filter only includes files that match the `*.txt` pattern.
*   **Filtering by Last Modified Time**: We can filter files by their last modified time using the `noop` option (which prevents files from being deleted or moved) and a custom file filter.

    ```java
    from("sftp://user@myhost.com/data?password=secret&noop=true&lastModified=2022-01-01T00:00:00Z")
    .to("file:/local/files");
    ```

### **Idempotent File Consumer Options**

To avoid processing the same file multiple times, we can use Camel’s idempotent consumer feature, which ensures that each file is processed only once.

```java
from("sftp://user@myhost.com/data?password=secret&idempotent=true&idempotentRepository=#myRepo")
.to("file:/local/files");
```

* The `idempotent=true` option ensures the file is only picked up once, and we can specify a custom idempotent repository (e.g., `#myRepo`) to manage file state.

### Message Headers

In Apache Camel, message headers are key-value pairs that provide additional metadata for a message. These headers do not form part of the message body itself but are used to control routing, transformations, and component-specific behaviors.

When using the Camel SFTP component, we can set or retrieve certain message headers to influence how the component behaves during file transfers. The SFTP component supports a set of message headers that can control various aspects of the SFTP operations such as file handling, directory management, and more.

{% hint style="info" %}
**How Message Headers Work in Apache Camel**

* **Headers as Metadata**: Message headers do not alter the message body, but provide additional data that can influence how routing logic works or how a component processes the message.
* **Setting Headers**: We can set these headers programmatically in our routes, either through a processor or directly in the route definition.
* **Accessing Headers**: We can also access headers to retrieve important information about the message, such as the file name, last modified time, or file size when dealing with file transfers.
{% endhint %}

{% hint style="success" %}
The SFTP component in Apache Camel automatically sets some of these message headers when it processes files. For instance, headers like `CamelFileName`, `CamelFileAbsolutePath`, and `CamelFileLastModified` are typically set by the component during file read or write operations.
{% endhint %}

The Camel SFTP component supports the following 10 key message headers:

1. **`CamelFileName`**
   * **Description**: Specifies the name of the file being written or read.
   * **Example Usage**: We can use this header to set the target filename when writing to a remote SFTP server.
   *   **Example**:

       ```java
       from("direct:start")
           .setHeader("CamelFileName", constant("myfile.txt"))
           .to("sftp://remotehost?username=user&password=secret&fileName=myfile.txt");
       ```
2. **`CamelFileNameOnly`**
   * **Description**: Contains only the name of the file (without the path).
   * **Use Case**: This can be useful when we need to extract just the filename from a full file path.
3. **`CamelFileAbsolutePath`**
   * **Description**: Contains the absolute file path of the file.
   * **Use Case**: Useful for logging or debugging to know the exact location of the file on the SFTP server.
4. **`CamelFileAbsolute`**
   * **Description**: A boolean flag indicating whether the file path is absolute or relative.
   * **Use Case**: Can help determine if the file is referenced with a full path or a relative one.
5. **`CamelFileRelativePath`**
   * **Description**: The relative file path, which is relative to the starting directory of the SFTP connection.
   * **Use Case**: This can help when working with files in a specific directory relative to the root SFTP folder.
6. **`CamelFileLastModified`**
   * **Description**: The timestamp (in milliseconds) of the last time the file was modified.
   * **Use Case**: We can use this to compare file modification times or to handle files based on their age.
7. **`CamelFileLength`**
   * **Description**: The size of the file in bytes.
   * **Use Case**: Helpful when we need to verify file sizes or log file size information during transfers.
8. **`CamelFtpReplyCode`**
   * **Description**: The FTP reply code received from the FTP/SFTP server.
   * **Use Case**: Useful for debugging and handling specific reply codes for error handling.
9. **`CamelFtpReplyString`**
   * **Description**: The full FTP reply message string from the FTP/SFTP server.
   * **Use Case**: Similar to `CamelFtpReplyCode`, this is useful for troubleshooting and debugging.
10. **`CamelFtpUserDir`**
    * **Description**: The home directory of the user on the SFTP server.
    * **Use Case**: Can be helpful when needing to determine the base directory for the SFTP session.

{% hint style="info" %}
We can easily print the headers that are automatically set by the Apache Camel SFTP component during a file download by logging them in your Camel route.

```
from("sftp://remotehost?username=user&password=secret&directory=/inbound")
    .log("Downloading file: ${header.CamelFileName}")
    .log("File Absolute Path: ${header.CamelFileAbsolutePath}")
    .log("File Last Modified: ${header.CamelFileLastModified}")
    .log("File Size: ${header.CamelFileLength}")
    .log("FTP Reply Code: ${header.CamelFtpReplyCode}")
    .log("FTP Reply String: ${header.CamelFtpReplyString}")
    .log("FTP User Home Directory: ${header.CamelFtpUserDir}")
    .to("file://local/output");
```
{% endhint %}

## **Sending Files to an SFTP Server (Upload)**

To send (upload) files to an SFTP server, the following configuration can be used:

```java
from("file:/local/files?noop=true")
.to("sftp://user@myhost.com/upload?password=secret");
```

* The local files in `/local/files` will be uploaded to the `/upload` directory on the SFTP server.
* The `noop=true` option ensures that files are not moved or deleted after processing locally.

## **Receiving Files from an SFTP Server (Download)**

To download files from an SFTP server, we can define a route like this:

```java
from("sftp://user@myhost.com/download?password=secret&delete=true&delay=60000")
.to("file:/local/files");
```

* Files are downloaded from the `/download` directory on the SFTP server.
* `delete=true`: Deletes the file from the remote directory after a successful download.
* `delay=60000`: Polls the remote server every 60 seconds to check for new files.

## **Error Handling**

Camel provides ways to handle errors during file transfer, such as retrying or logging errors. For instance:

```java
onException(Exception.class)
  .log("Error occurred during SFTP file transfer: ${exception.message}")
  .handled(true);

from("sftp://user@myhost.com/data?password=secret")
  .to("file:/local/files");
```

## **Stream Downloading**

We can download large files from an SFTP server using streaming, which reduces memory consumption by not loading the entire file into memory at once.

```java
from("sftp://user@myhost.com/largefile?streamDownload=true")
.to("file:/local/storage");
```

