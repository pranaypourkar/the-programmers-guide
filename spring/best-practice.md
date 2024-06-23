# Best Practice

## Defining properties related to Java version and encoding

### Properties

Mentioning below properties are considered best practices for a Spring project's pom.xml

#### **`java.version`**:

* **Purpose**: Specifies the version of Java that the project is using.
* **Usage**: This property is often used in plugins and other configurations to ensure that the project is built and runs with the specified Java version.
* **Example**: `<java.version>17</java.version>`

#### **`maven.compiler.source`**:

* **Purpose**: Sets the version of the source code. It tells the Maven Compiler Plugin which version of the Java language features to use.
* **Usage**: Ensures that the compiler uses the correct Java version for source files.
* **Example**: `<maven.compiler.source>17</maven.compiler.source>`

#### **`maven.compiler.target`**:

* **Purpose**: Specifies the version of the JVM for the compiled bytecode.
* **Usage**: Ensures that the compiled bytecode is compatible with the specified version of the JVM.
* **Example**: `<maven.compiler.target>17</maven.compiler.target>`

#### **`project.build.sourceEncoding`**:

* **Purpose**: Defines the character encoding for the source files.
* **Usage**: Ensures that all source files are read and compiled using the specified encoding. UTF-8 is typically used because it can represent any character in the Unicode standard.
* **Example**: `<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>`

#### **`project.reporting.outputEncoding`**:

* **Purpose**: Sets the character encoding for the output of reporting tasks, such as generated reports and documentation.
* **Usage**: Ensures that generated reports are encoded correctly, preventing issues with special characters.
* **Example**: `<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>`

### Example

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>example-project</artifactId>
    <version>1.0.0</version>

    <properties>
        <java.version>17</java.version>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    </properties>

    <dependencies>
        <!-- Your dependencies here -->
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <source>${maven.compiler.source}</source>
                    <target>${maven.compiler.target}</target>
                    <encoding>${project.build.sourceEncoding}</encoding>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-resources-plugin</artifactId>
                <version>3.2.0</version>
                <configuration>
                    <encoding>${project.build.sourceEncoding}</encoding>
                </configuration>
            </plugin>
            <!-- Other plugins can be configured similarly -->
        </plugins>
    </build>

</project>

```



