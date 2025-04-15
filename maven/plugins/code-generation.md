# Code Generation

## About

**Code Generation** plugins in Maven are used to automate the creation of source code during the build process. These plugins reduce manual coding effort by generating boilerplate code, stubs, client/server APIs, proxies, or model classes from various specifications (e.g., OpenAPI, WSDL, XSD, Protocol Buffers, etc.).

Automated code generation ensures:

* **Consistency** between contract (specs) and implementation.
* **Productivity** by eliminating repetitive tasks.
* **Synchronization** of APIs across services and clients.

**Common Scenarios for Code Generation**

* Generating **Java classes** from **XML schemas (XSD)**.
* Generating **SOAP client stubs** from **WSDL** files.
* Generating **REST clients or servers** from **OpenAPI/Swagger** specs.
* Generating **gRPC or Protocol Buffers** classes.
* Creating **JPA entities, DTOs, mappers**, or **boilerplate code**.

### **JAXB2 Maven Plugin**

Generates Java classes from XSD schemas using JAXB 2. It's useful in projects where XML configuration or communication is required.

**Common Goals**

| Goal  | Description                      |
| ----- | -------------------------------- |
| `xjc` | Compile `.xsd` into Java classes |

**Basic Configuration**

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>jaxb2-maven-plugin</artifactId>
  <version>2.5.0</version>
  <executions>
    <execution>
      <goals>
        <goal>xjc</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <schemaDirectory>src/main/resources/schema</schemaDirectory>
    <outputDirectory>${project.build.directory}/generated-sources/jaxb</outputDirectory>
  </configuration>
</plugin>
```

#### **Useful Config Options**

<table><thead><tr><th width="286.19921875">Option</th><th>Description</th></tr></thead><tbody><tr><td><code>schemaDirectory</code></td><td>Path to XSD files</td></tr><tr><td><code>outputDirectory</code></td><td>Directory to generate Java classes</td></tr><tr><td><code>clearOutputDir</code></td><td>Clean output before generation</td></tr><tr><td><code>packageName</code></td><td>Override package name</td></tr></tbody></table>

## **OpenAPI Generator Maven Plugin**

Generates client/server code from OpenAPI (Swagger) definitions. Supports many languages and frameworks.

**Common Goals**

| Goal       | Description                        |
| ---------- | ---------------------------------- |
| `generate` | Generates code from `openapi.yaml` |

**Basic Configuration**

```xml
<plugin>
  <groupId>org.openapitools</groupId>
  <artifactId>openapi-generator-maven-plugin</artifactId>
  <version>6.6.0</version>
  <executions>
    <execution>
      <goals>
        <goal>generate</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <inputSpec>${project.basedir}/src/main/resources/openapi.yaml</inputSpec>
    <generatorName>java</generatorName>
    <output>${project.build.directory}/generated-sources/openapi</output>
    <apiPackage>com.example.api</apiPackage>
    <modelPackage>com.example.model</modelPackage>
  </configuration>
</plugin>
```

#### **Popular Generator Types:**

* `java` (Spring, JAX-RS)
* `typescript`, `python`, `go`, `kotlin`, etc.

## **wsimport (JAX-WS Maven Plugin)**

Generates Java classes from WSDL for SOAP-based web service clients.

**Basic Configuration**

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>jaxws-maven-plugin</artifactId>
  <version>2.3</version>
  <executions>
    <execution>
      <goals>
        <goal>wsimport</goal>
      </goals>
      <configuration>
        <wsdlUrls>
          <wsdlUrl>https://example.com/service?wsdl</wsdlUrl>
        </wsdlUrls>
        <packageName>com.example.ws</packageName>
      </configuration>
    </execution>
  </executions>
</plugin>
```

## **protobuf-maven-plugin**

Used to compile `.proto` files into Java or other languages using the Protocol Buffers compiler.

**Basic Configuration**

```xml
<plugin>
  <groupId>org.xolstice.maven.plugins</groupId>
  <artifactId>protobuf-maven-plugin</artifactId>
  <version>0.6.1</version>
  <executions>
    <execution>
      <goals>
        <goal>compile</goal>
        <goal>compile-custom</goal>
      </goals>
    </execution>
  </executions>
  <configuration>
    <protoSourceRoot>${project.basedir}/src/main/proto</protoSourceRoot>
  </configuration>
</plugin>
```

**Generated Output**

By default, `.java` classes will be generated from `.proto` files under:

```
target/generated-sources/protobuf
```

## **mapstruct-processor (for Annotation Processing)**

Used for annotation-based generation of Java bean mappers.

**Basic Configuration**

```xml
<dependency>
  <groupId>org.mapstruct</groupId>
  <artifactId>mapstruct</artifactId>
  <version>1.5.5.Final</version>
</dependency>
<dependency>
  <groupId>org.mapstruct</groupId>
  <artifactId>mapstruct-processor</artifactId>
  <version>1.5.5.Final</version>
  <scope>provided</scope>
</dependency>
```

Additionally, enable annotation processing in your build tool (IDE or compiler).

