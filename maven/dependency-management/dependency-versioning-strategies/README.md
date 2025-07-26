# Dependency Versioning Strategies

## About

In Maven, **dependency versioning** determines which version of a library or framework is used in our project. Proper versioning is essential for

* Ensuring **compatibility** with other dependencies.
* Preventing **breaking changes** from new versions.
* Managing **security fixes and performance improvements**.

Since dependencies evolve, we must have a **strategy** to manage their versions effectively.

## Types of Dependency Versioning in Maven

### **1. Fixed Versioning (Explicit Version)**

* We manually specify a **fixed** version of a dependency in `pom.xml`.
* Ensures stability but requires manual updates.
* **Example:**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <version>3.1.0</version>
</dependency>
```

{% hint style="info" %}
**Pros:** Predictable and stable.\
**Cons:** Requires manual updates when a new version is released.
{% endhint %}

### **2. Floating Versioning (Using LATEST and RELEASE)**

* **LATEST**: Uses the latest available version (including SNAPSHOT versions).
* **RELEASE**: Uses the latest **stable** release (non-SNAPSHOT).
* **Example:**

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-lang3</artifactId>
    <version>LATEST</version>
</dependency>
```

{% hint style="info" %}
**Pros:** Automatically picks the newest version.\
**Cons:** Can cause unexpected breaking changes.\
**Note:** `LATEST` and `RELEASE` are deprecated in Maven 3.
{% endhint %}

Imagine the following versions exist in Maven Central:

```
1.0.0
1.1.0
1.2.0-SNAPSHOT
1.2.0
1.3.0-SNAPSHOT
```

* If we specify **`LATEST`**, it selects `1.3.0-SNAPSHOT` because it's the newest, even if it's unstable.
* If we specify **`RELEASE`**, it selects `1.2.0` because it's the latest **stable** release.

### **3. Version Ranges**

* Allows specifying **a range** of acceptable versions.
* **Syntax Examples:**
  * `[1.5,2.0]` → Accepts versions **1.5 to 2.0 (inclusive)**.
  * `[1.5,2.0)` → Accepts **1.5 to 2.0 (excluding 2.0)**.
  * `(,1.5]` → Accepts **any version up to 1.5 (inclusive)**.
  * `[1.0,]` → Accepts **1.0 and all later versions**.
* **Example:**

```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>[2.12,2.14]</version>
</dependency>
```

{% hint style="info" %}
**Pros:** Allows controlled flexibility in updates.\
**Cons:** Still requires periodic review to ensure compatibility.
{% endhint %}

### **4. Dependency Management with BOM (Bill of Materials)**

* Instead of specifying versions in every dependency, a **BOM** centralizes versioning.
* Helps keep versions consistent across large projects.
* **Example:**

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

Now, dependencies inside the project **inherit** the BOM’s versions:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

{% hint style="info" %}
**Pros:** Avoids conflicts and keeps dependency versions uniform.\
**Cons:** You are tied to the BOM's choices.
{% endhint %}

### **5. SNAPSHOT Versions (For Development)**

* Used for **ongoing development versions** before an official release.
* **Example:**

```xml
<dependency>
    <groupId>com.example</groupId>
    <artifactId>my-library</artifactId>
    <version>1.0.0-SNAPSHOT</version>
</dependency>
```

{% hint style="info" %}
**Pros:** Useful for testing the latest features.\
**Cons:** Can be unstable and change unexpectedly.\
**Note:** SNAPSHOT versions should **not be used in production**.
{% endhint %}

