# Camel SFTP

## About

Apache Camel’s SFTP component allows to transfer files to and from SFTP (SSH File Transfer Protocol) servers. It supports both the sending (uploading) and receiving (downloading) of files, making it useful in various integration scenarios where secure file transfer is required.

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

### **Sending Files to an SFTP Server (Upload)**

To send (upload) files to an SFTP server, the following configuration can be used:

```java
from("file:/local/files?noop=true")
.to("sftp://user@myhost.com/upload?password=secret");
```

* The local files in `/local/files` will be uploaded to the `/upload` directory on the SFTP server.
* The `noop=true` option ensures that files are not moved or deleted after processing locally.

### **Receiving Files from an SFTP Server (Download)**

To download files from an SFTP server, we can define a route like this:

```java
from("sftp://user@myhost.com/download?password=secret&delete=true&delay=60000")
.to("file:/local/files");
```

* Files are downloaded from the `/download` directory on the SFTP server.
* `delete=true`: Deletes the file from the remote directory after a successful download.
* `delay=60000`: Polls the remote server every 60 seconds to check for new files.

### **Authentication**

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

### **Options and Configuration**

The Camel SFTP component provides numerous options to fine-tune the behavior of file transfers. Here are some commonly used options:

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

### **Error Handling**

Camel provides ways to handle errors during file transfer, such as retrying or logging errors. For instance:

```java
onException(Exception.class)
  .log("Error occurred during SFTP file transfer: ${exception.message}")
  .handled(true);

from("sftp://user@myhost.com/data?password=secret")
  .to("file:/local/files");
```

### **SFTP File Filters**

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

### **Idempotent File Consumer**

To avoid processing the same file multiple times, we can use Camel’s idempotent consumer feature, which ensures that each file is processed only once.

```java
from("sftp://user@myhost.com/data?password=secret&idempotent=true&idempotentRepository=#myRepo")
.to("file:/local/files");
```

* The `idempotent=true` option ensures the file is only picked up once, and we can specify a custom idempotent repository (e.g., `#myRepo`) to manage file state.

### **Stream Downloading**

We can download large files from an SFTP server using streaming, which reduces memory consumption by not loading the entire file into memory at once.

```java
from("sftp://user@myhost.com/largefile?streamDownload=true")
.to("file:/local/storage");
```

#### Example: Uploading Files to an SFTP Server

```java
from("file:/local/files?noop=true")
.to("sftp://user@myhost.com/upload?password=secret");
```

#### Example: Downloading Files from an SFTP Server

```java
from("sftp://user@myhost.com/data?password=secret&delete=true&delay=60000")
.to("file:/local/files");
```

