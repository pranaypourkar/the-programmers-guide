# Dependency Tree & Analysis

## About

A **dependency tree** in Maven is a hierarchical representation of all dependencies in a project, including **direct** and **transitive dependencies**. It helps to -

* Identify **dependency conflicts** (duplicate or incompatible versions).
* Understand **why a dependency is included** in the project.
* Optimize **dependency versions** to avoid unnecessary bloating.

#### **Example of a Dependency Tree**

Consider the following `pom.xml`:

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <version>3.1.0</version>
    </dependency>
    
    <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.17.1</version>
    </dependency>
</dependencies>
```

When you run the following command:

```sh
mvn dependency:tree
```

We will get output like this:

```
[INFO] com.example:my-project:jar:1.0.0
[INFO] ├── org.springframework.boot:spring-boot-starter-web:jar:3.1.0
[INFO] │   ├── org.springframework.boot:spring-boot-starter:jar:3.1.0
[INFO] │   │   ├── org.springframework.boot:spring-boot:jar:3.1.0
[INFO] │   │   ├── org.apache.logging.log4j:log4j-core:jar:2.14.1 (conflict)
[INFO] ├── org.apache.logging.log4j:log4j-core:jar:2.17.1 (direct)
```

**Notice** that `log4j-core` appears **twice**—once as **direct** and once as **transitive** (from `spring-boot-starter`).\
**Maven will use the nearest version** (2.17.1 in this case).

## Dependency Tree Components

#### **1. Direct Dependencies**

* These are **explicitly declared** in `pom.xml`.
* Example: `spring-boot-starter-web` and `log4j-core` are direct dependencies.

#### **2. Transitive Dependencies**

* These are **indirect dependencies** pulled in by other dependencies.
* Example: `spring-boot-starter-web` **pulls in** `log4j-core`.

#### **3. Conflict Resolution**

* When different versions of a library exist, Maven applies **Nearest-Wins Strategy**.

## Commands for Analyzing Dependencies

### **1. Checking Full Dependency Tree**

```sh
mvn dependency:tree
```

Displays **all dependencies**, including transitive ones.

### **2. Finding Why a Dependency Exists**

```sh
mvn dependency:tree -Dincludes=org.apache.logging.log4j:log4j-core
```

This command shows **which dependencies brought in `log4j-core`**.

### **3. Displaying Dependencies in a Graphical Format**

For better readability, generate a dependency graph:

```sh
mvn dependency:tree -DoutputType=dot -DoutputFile=dependency-graph.dot
```

Then use a tool like **Graphviz** to visualize it.

### **4. Checking Dependency Versions**

```sh
mvn dependency:resolve
```

Lists **resolved versions** of all dependencies.

### **5. Finding Dependency Conflicts**

```sh
mvn dependency:tree -Dverbose
```

Shows **conflicts** and which version Maven picks.
