# Annotation Processing

## About

**Annotation Processing** is a powerful feature in Java that allows developers to **intercept and process annotations at compile time**. It plays a vital role in code generation, validation, and automation of boilerplate tasks in large-scale applications and frameworks like Spring, Lombok, Dagger, etc.

Annotation processing is a **compile-time mechanism** that inspects the source code for annotations and can generate additional source files, perform validations, or create metadata.

It is handled by tools that implement the `javax.annotation.processing.Processor` interface (now `jakarta.annotation.processing.Processor` in Jakarta EE) and is integrated with the Java compiler (`javac`).

Annotation processors run during compilation and **do not affect runtime behavior directly**, but the code they generate or validate influences the final application.

## When Is Annotation Processing Used ?

Annotation processing is used when:

* We want to **generate source code** automatically (e.g., builder classes, DTOs, factories).
* We want to **validate annotation usage** (e.g., checking constraints).
* We want to **generate configuration metadata** (e.g., Spring factories, JSON schema, etc.).
* We are building a **framework or library** that relies on compile-time structure.

## Examples

| Use Case                  | Tools/Frameworks         |
| ------------------------- | ------------------------ |
| Generate boilerplate code | Lombok                   |
| Dependency Injection      | Dagger, Hilt             |
| JSON Serialization        | AutoValue, Gson, Jackson |
| Configuration Metadata    | Spring Boot              |
| Mapper Generation         | MapStruct                |

## How It Works ?

1. We create a custom annotation.
2. We implement an annotation processor that:
   * Identifies target annotations.
   * Uses the compiler’s Abstract Syntax Tree (AST) or Elements/Mirrors API.
   * Optionally generates new source files.
3. The annotation processor is registered using `META-INF/services/javax.annotation.processing.Processor` file.
4. During compilation, `javac` invokes the processor, processes annotations, and generates code before final compilation completes.

## Use Case: **@AutoToString** Annotation

We’ll create a custom annotation `@AutoToString` that, when applied to a class, generates a helper class with a `toString()` method implementation for that class.

This is a **compile-time code generation example** - the processor will **generate code** based on our annotation.

### Folder Structure

```
annotation-processor/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/processor/AutoToStringProcessor.java
            └── com/example/annotations/AutoToString.java
│   │   └── resources/
│   │       └── META-INF/services/javax.annotation.processing.Processor
├── pom.xml
```

### Define the Annotation

```java
// file: AutoToString.java
package com.example.annotations;

import java.lang.annotation.*;

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.SOURCE)
public @interface AutoToString {}
```

* `@Target(TYPE)` — used on classes
* `@Retention(SOURCE)` — we only care during compile time

### Implement the Annotation Processor

```java
// file: AutoToStringProcessor.java
package com.example.processor;

import com.example.annotations.AutoToString;
import javax.annotation.processing.*;
import javax.lang.model.element.*;
import javax.lang.model.*;
import javax.tools.*;

import java.io.Writer;
import java.util.Set;

@SupportedAnnotationTypes("com.example.annotations.AutoToString")
@SupportedSourceVersion(SourceVersion.RELEASE_21)
public class AutoToStringProcessor extends AbstractProcessor {

    @Override
    public boolean process(Set<? extends TypeElement> annotations,
                           RoundEnvironment roundEnv) {

        for (Element element : roundEnv.getElementsAnnotatedWith(AutoToString.class)) {
            if (element.getKind() != ElementKind.CLASS) continue;

            TypeElement classElement = (TypeElement) element;
            String className = classElement.getSimpleName().toString();
            String packageName = processingEnv.getElementUtils()
                                     .getPackageOf(classElement).getQualifiedName().toString();

            String generatedClassName = className + "ToStringGenerator";

            try {
                JavaFileObject builderFile = processingEnv.getFiler()
                        .createSourceFile(packageName + "." + generatedClassName);

                try (Writer writer = builderFile.openWriter()) {
                    writer.write("package " + packageName + ";\n\n");
                    writer.write("public class " + generatedClassName + " {\n");
                    writer.write("    public static String toString(" + className + " obj) {\n");
                    writer.write("        return \"" + className + " [");

                    boolean first = true;
                    for (VariableElement field : ElementFilter.fieldsIn(classElement.getEnclosedElements())) {
                        String fieldName = field.getSimpleName().toString();
                        if (first) first = false;
                        else writer.write(" + \", ");
                        writer.write(fieldName + "=\" + obj." + fieldName);
                    }

                    writer.write(" + \"]\";\n");
                    writer.write("    }\n}\n");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return true;
    }
}
```

* It identifies all classes annotated with `@AutoToString`.
* For each class, it generates a helper class like `PersonToStringGenerator.java`.
* It creates a static method that builds a `toString` output using the class fields.

### Register the Processor

**Path:** `src/main/resources/META-INF/services/javax.annotation.processing.Processor`\
**Contents:**

```
com.example.processor.AutoToStringProcessor
```

This tells the compiler **which class is an annotation processor**.

### Use the Annotation in a Client Class

```java
// file: Person.java
package com.example.model;

import com.example.annotations.AutoToString;

@AutoToString
public class Person {
    public String name;
    public int age;
}
```

When this is compiled, the processor generates:

```java
// file: PersonToStringGenerator.java
package com.example.model;

public class PersonToStringGenerator {
    public static String toString(Person obj) {
        return "Person [name=" + obj.name + ", age=" + obj.age + "]";
    }
}
```

### Use the Generated Code

```java
public class Person {
    public static void main(String[] args) {
        Person p = new Person();
        p.name = "Alice";
        p.age = 30;

        String result = PersonToStringGenerator.toString(p);
        System.out.println(result); // Output: Person [name=Alice, age=30]
    }
}
```

### Build the JAR using Maven

#### 1. Add `pom.xml`

Here is a basic Maven config

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>annotation-processor</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>Annotation Processor</name>

    <properties>
        <maven.compiler.source>21</maven.compiler.source>
        <maven.compiler.target>21</maven.compiler.target>
    </properties>

</project>
```

No dependencies are needed unless we use external libraries in our processor.

#### 2. Package the JAR

Run this from inside our project folder

```bash
mvn clean package
```

This will generate a JAR in

```
target/annotation-processor-1.0-SNAPSHOT.jar
```

That JAR will contain

* Our processor class
* The `@AutoToString` annotation
* The `META-INF/services/javax.annotation.processing.Processor` file

### Use the JAR in Another Project

Now in our actual project (say, where `Person.java` is):

1. Put the above JAR in the classpath
2. Compile with:

```bash
javac -cp annotation-processor-1.0-SNAPSHOT.jar -processorpath annotation-processor-1.0-SNAPSHOT.jar Person.java
```

This will trigger our annotation processor during compilation.

### Use the JAR in Maven Project

In our main project's `pom.xml`, we can declare the processor as a build-time dependency only:

```xml
<dependency>
  <groupId>com.example</groupId>
  <artifactId>annotation-processor</artifactId>
  <version>1.0-SNAPSHOT</version>
  <scope>provided</scope> <!-- only during compile time -->
</dependency>
```

And for automatic annotation processing:

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.10.1</version>
      <configuration>
        <annotationProcessorPaths>
          <path>
            <groupId>com.example</groupId>
            <artifactId>annotation-processor</artifactId>
            <version>1.0-SNAPSHOT</version>
          </path>
        </annotationProcessorPaths>
      </configuration>
    </plugin>
  </plugins>
</build>
```
