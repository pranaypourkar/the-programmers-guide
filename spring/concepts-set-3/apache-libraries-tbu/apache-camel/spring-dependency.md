# Spring Dependency

## 1. **`camel-jsch-starter` (Spring Boot Integration for SFTP)**

```xml
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-jsch-starter</artifactId>
    <version>x.x.x</version>
</dependency>
```

This dependency is specific to Spring Boot applications and provides automatic configuration and integration of Camel's SFTP component using the **JSCH** library. JSCH is a Java implementation of SSH2 and is used for handling **SFTP**(Secure FTP) operations.

* **Spring Boot Integration**: The `camel-jsch-starter` dependency is a **Spring Boot starter**, meaning it will automatically configure the Camel SFTP component for you when using Spring Boot. We don't need to explicitly configure beans or components since Spring Boot manages it through auto-configuration.
* **Use Case**: This is ideal if you're using Spring Boot and want to work with **SFTP** (not plain FTP) without manually configuring Camel's `SftpComponent`.
* **No version specification needed**: Because this is a Spring Boot starter, the version is controlled by the Spring Boot and Camel BOM (Bill of Materials), ensuring version compatibility automatically.

## 2. **`camel-ftp` (Camel FTP/SFTP Component)**

```xml
<dependency>
    <groupId>org.apache.camel</groupId>
    <artifactId>camel-ftp</artifactId>
    <version>x.x.x</version>
    <!-- use the same version as your Camel core version -->
</dependency>
```

The `camel-ftp` dependency provides both **FTP** and **SFTP** capabilities to Apache Camel by including both the **FTP** and **SFTP** components. However, this is a general dependency that we can use in any Camel project, whether or not we're using Spring Boot.

* **Manual Configuration**: Unlike the Spring Boot starter, we may need to manually configure the components in our application (especially if not using Spring Boot), though it can still work automatically with Spring Boot.
* **FTP and SFTP**: This dependency supports both **plain FTP** (File Transfer Protocol) and **SFTP** (Secure FTP) using the same library.
* **Version Control**: We need to specify the version, and it should match your Camel core version to ensure compatibility.

## 3. **`camel-ftp-starter` (Camel FTP/SFTP Spring Component)**

```markup
<dependency>
    <groupId>org.apache.camel.springboot</groupId>
    <artifactId>camel-ftp-starter</artifactId>
    <version>x.x.x</version>
</dependency>
```

The `camel-ftp-starter` is a Spring Boot starter that simplifies the integration of FTP and SFTP protocols in Spring Boot applications. It is an extension of the general `camel-ftp` component, but packaged in a way that takes advantage of Spring Boot’s auto-configuration mechanism.

* **Auto-Configuration**:
  * This starter will auto-configure the necessary components (`FtpComponent` and `SftpComponent`) for FTP and SFTP operations without requiring manual setup in your Spring Boot application.
  * As a Spring Boot starter, it simplifies the integration of FTP and SFTP by reducing the boilerplate code we would otherwise need to configure in a non-Spring Boot environment.
* **FTP and SFTP Support**:
  * Unlike `camel-jsch-starter` (which only supports SFTP), `camel-ftp-starter` provides support for both **FTP** and **SFTP** protocols.
  * It uses Apache Commons Net under the hood for FTP and JSCH for SFTP.
* **Spring Boot Features**:
  * Leverages Spring Boot’s auto-configuration capabilities, which means we don't have to manually define FTP or SFTP components unless we want custom configurations.
  * Supports the properties-based configuration of FTP and SFTP servers via the `application.properties` or `application.yml` files in a Spring Boot project.

