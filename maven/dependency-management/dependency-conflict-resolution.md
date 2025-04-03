# Dependency Conflict Resolution

## About

A **dependency conflict** occurs in Maven when multiple dependencies in a project bring different versions of the same library (**transitive dependencies**), leading to:

* **Version Mismatches** → Different versions of the same dependency in the classpath.
* **Compilation/Runtime Issues** → Unexpected behavior due to incompatible versions.
* **ClassNotFoundException / NoSuchMethodError** → When an older version is used instead of the expected one.

Maven resolves these conflicts **automatically**, but understanding the resolution mechanism helps avoid issues.

{% hint style="success" %}
**Maven does not allow multiple versions of the same library in the classpath simultaneously**.

**Why ?**

* Java’s **classloading mechanism** does not support multiple versions of the same class in the same classpath.
* If two dependencies bring different versions of the same library, Maven picks **one** but warns about the conflict.
* The other version is **ignored**, which can cause **runtime errors** if the selected version lacks required methods/classes.
{% endhint %}

## How Do Dependency Conflicts Occur?

Consider a project with dependencies:

```xml
<dependency>
    <groupId>org.apache.logging.log4j</groupId>
    <artifactId>log4j-core</artifactId>
    <version>2.17.1</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

#### What Happens Internally?

* `spring-boot-starter-web` **also depends on** `log4j-core`, but at **version 2.14.1**.
* Now, two versions (**2.17.1 & 2.14.1**) exist in the dependency tree.
* Maven must **decide which version to use**.

## What Happens If Two Versions Are Declared?

**Example: Conflicting Dependencies**

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.0</version>
</dependency>

<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.13.3</version>
</dependency>
```

**Maven resolves this conflict automatically**, choosing **only one version** based on:

1. **Direct Dependency Preference** – If one version is declared explicitly, it is preferred.
2. **Nearest-Wins Strategy** – If both are transitive dependencies, Maven picks the closest version.

To check which version is used:

```sh
mvn dependency:tree
```

{% hint style="success" %}
Only one version appears in the resolved dependency tree.
{% endhint %}

## Maven’s Conflict Resolution Strategy

### **1. Nearest-Wins Strategy (Dependency Mediation)**

* **Maven chooses the nearest dependency version** in the dependency tree.
* If a dependency appears **multiple times**, the closest one to the project **wins**.

**Example: Nearest-Wins in Action**

```xml
<dependencies>
    <dependency>
        <groupId>com.example</groupId>
        <artifactId>lib-A</artifactId>
        <version>1.2.0</version>
    </dependency>

    <dependency>
        <groupId>com.example</groupId>
        <artifactId>lib-B</artifactId>
        <version>1.0.0</version>
    </dependency>
</dependencies>
```

If `lib-B` **internally** depends on `lib-A:1.0.0`, but the project declares `lib-A:1.2.0`, Maven will use **1.2.0** because it is **closer** to the project.

**Issue**: This may cause incompatibilities if the newer version is **not backward compatible**.

### **2. Dependency Tree Analysis**

Use the following command to **check all dependencies** and their versions:

```sh
mvn dependency:tree
```

Example output:

```
[INFO] com.example:my-project:jar:1.0.0
[INFO] ├── org.apache.logging.log4j:log4j-core:jar:2.17.1 (direct)
[INFO] ├── org.springframework.boot:spring-boot-starter-web:jar:3.1.0
[INFO] │   └── org.apache.logging.log4j:log4j-core:jar:2.14.1 (conflict)
```

**Solution**: Manually enforce `log4j-core:2.17.1` to resolve the conflict.

### **3. Forcing a Specific Version (Dependency Management)**

If Maven picks an **older or undesired version**, explicitly **override** it using `<dependencyManagement>`:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
            <version>2.17.1</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

This ensures **all modules** in a multi-module project use the same version.

### **4. Using Exclusions to Remove Unwanted Dependencies**

If a dependency is causing conflicts **indirectly**, we can **exclude it**:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <exclusion>
            <groupId>org.apache.logging.log4j</groupId>
            <artifactId>log4j-core</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

This **removes** `log4j-core` from `spring-boot-starter-web`.

{% hint style="danger" %}
Be careful! Excluding dependencies may break functionality.
{% endhint %}

### **5. Using a BOM (Bill of Materials)**

BOMs **standardize versions** across projects:

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>3.1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

It ensures **consistent versions** across modules.

## Can We Force Two Versions in the Same Project?

**Not directly in the same classpath!** But some workarounds exist:

### **Solution 1: Shading (Relocating Dependencies)**

* Used in **fat JARs** (e.g., with **Maven Shade Plugin**) to bundle different versions under separate namespaces.
* Example: If **two different libraries require different `jackson-databind` versions**, we can **relocate** one version.

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <relocations>
                    <relocation>
                        <pattern>com.fasterxml.jackson</pattern>
                        <shadedPattern>shaded.com.fasterxml.jackson</shadedPattern>
                    </relocation>
                </relocations>
            </configuration>
        </execution>
    </executions>
</plugin>
```

This moves `jackson-databind:2.13.3` under `shaded.com.fasterxml.jackson`, **avoiding conflicts**.

### **Solution 2: Isolating Dependencies in Different Classloaders**

* Used in **OSGi, Java Modules (JPMS), or custom classloading strategies**.
* Example: **Spring Boot’s parent-first and child-first classloading strategies**.



