# MapStruct Mapper

## About&#x20;

MapStruct is a code generator that simplifies the implementation of mappings between Java bean types based on a convention-over-configuration approach. It is a tool designed to help developers map data from one Java object to another. It is a popular choice for mapping objects, especially in large-scale enterprise applications, due to its performance and ease of use.

{% hint style="info" %}
**What is "Convention-Over-Configuration"?**

"Convention-over-configuration" is a software design principle used to reduce the number of decisions developers need to make, without sacrificing flexibility. In simpler terms, it means that the framework will assume reasonable default behavior unless the developer specifies otherwise. This approach minimizes the need for extensive configuration by relying on common conventions.

**How Does MapStruct Use Convention-Over-Configuration?**

MapStruct uses this principle to simplify object mappings by following these conventions

* **Property Name Matching**:
  * By default, MapStruct maps properties in source and target objects that have the same name and compatible types.
  * For example, if we have a `UserDTO` class with a `name` field and a `UserEntity` class with a `name` field, MapStruct will automatically map `UserDTO.name` to `UserEntity.name`.
* **Type Matching**:
  * MapStruct can automatically convert between types that have a clear conversion path (e.g., `String` to `int`, `Date` to `String`).
  * This reduces the need for explicit type conversion configuration.
* **Default Method Generation**:
  * MapStruct generates implementation code for the mapping methods based on the interface definitions provided by the developer.
  * For instance, if we define a method `UserDTO toUserDTO(UserEntity entity);` in a mapper interface, MapStruct will generate the implementation for this method, mapping each field based on conventions.
{% endhint %}

## Maven POM Dependency and Plugin

Include the required dependencies in pom.xml file.

```xml
<!-- This dependency includes the core MapStruct library which provides 
the API and main functionality for object mapping. -->
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct</artifactId>
    <version>1.4.2.Final</version>
</dependency>
<!-- This dependency includes the MapStruct annotation processor which 
generates the implementation of the mapper interfaces at compile time. -->
<dependency>
    <groupId>org.mapstruct</groupId>
    <artifactId>mapstruct-processor</artifactId>
    <version>1.4.2.Final</version>
</dependency>
```

```xml
<!-- The maven-compiler-plugin is a Maven plugin used to compile Java source files. 
In the context of using MapStruct, it is configured to ensure that the MapStruct annotation 
processor is correctly set up during the compilation phase. -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <version>${maven-compiler-plugin.version}</version>
    <configuration>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>${lombok.version}</version>
            </path>
            <path>
                <groupId>org.mapstruct</groupId>
                <artifactId>mapstruct-processor</artifactId>
                <version>${mapstruct.version}</version>
            </path>
        </annotationProcessorPaths>
        <useIncrementalCompilation>false</useIncrementalCompilation>
    </configuration>
</plugin>
```

## **Core Features**

MapStruct provides a set of core features that allow to map properties between different objects seamlessly. These include:

* **Basic Type Mapping**: MapStruct automatically maps properties with the same name and compatible types.
* **Handling Null Values**: By default, MapStruct maps null values, but we can customize this behavior.
* **Customizing Mappings with `@Mapping`**: This annotation allows to define how individual fields are mapped.



