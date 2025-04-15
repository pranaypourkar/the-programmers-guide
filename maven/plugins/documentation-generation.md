# Documentation Generation

## About

The **Documentation Generation** category in Maven encompasses plugins that generate project documentation in standardized formats such as **Javadoc**, **project reports**, or **custom site documentation**. These tools play a critical role in delivering readable, maintainable, and shareable technical information—especially for large codebases, open-source projects, or enterprise systems.

They help automate the creation of:

* API documentation (e.g., Javadoc)
* Project metadata (build info, dependencies, plugins)
* Custom written pages
* Multi-module documentation sites

## Maven Javadoc Plugin

The **Maven Javadoc Plugin** generates Javadoc API documentation for our Java source code. This is one of the most commonly used documentation plugins and is often configured for both site generation and direct Javadoc generation.

#### **Common Goals**

| Goal                   | Description                                           |
| ---------------------- | ----------------------------------------------------- |
| `javadoc:javadoc`      | Generates Javadoc for the current module              |
| `javadoc:aggregate`    | Generates combined Javadoc for a multi-module project |
| `javadoc:test-javadoc` | Generates Javadoc for test classes                    |

#### **Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-javadoc-plugin</artifactId>
  <version>3.6.3</version>
  <configuration>
    <encoding>UTF-8</encoding>
    <doclint>none</doclint>
    <failOnError>false</failOnError>
  </configuration>
</plugin>
```

#### **Additional Configurations**

| Element                 | Purpose                                          |
| ----------------------- | ------------------------------------------------ |
| `doclint`               | Turn off strict lint checks (useful for Java 8+) |
| `excludePackageNames`   | Exclude certain packages from documentation      |
| `reportOutputDirectory` | Customize output folder                          |
| `source`                | Set Java version for Javadoc parsing             |

## **Maven Site Plugin**

The **Maven Site Plugin** generates a full website for our project including reports, documentation pages, and Javadoc. It can also deploy the generated site to a remote server or repository.

It pulls in content from various report-generating plugins like Checkstyle, PMD, Surefire, and more.

#### **Common Goals**

<table><thead><tr><th width="175.87890625">Goal</th><th>Description</th></tr></thead><tbody><tr><td><code>site:site</code></td><td>Generates the site in the <code>target/site</code> folder</td></tr><tr><td><code>site:deploy</code></td><td>Deploys the site to a remote server (e.g., GitHub Pages)</td></tr><tr><td><code>site:stage</code></td><td>Prepares a staged version of the site</td></tr></tbody></table>

#### **Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-site-plugin</artifactId>
  <version>4.0.0-M14</version>
</plugin>
```

#### **Site Descriptor (`src/site/site.xml`)**

This file allows us to customize menus, pages, reports, and the structure of the site.

Example:

```xml
<project name="MyProject">
  <body>
    <menu name="Documentation">
      <item name="User Guide" href="user-guide.html"/>
    </menu>
  </body>
</project>
```

#### **Supported Documentation Formats**

* **APT (Almost Plain Text)**
* **XHTML**
* **Markdown**
* **FML (FAQ Markup Language)**

Place content under: `src/site/markdown`, `src/site/apt`, etc.

{% hint style="info" %}
**Doxia Tools**

The **Doxia module** is the underlying framework used by the Maven Site Plugin for rendering various markup formats (Markdown, APT, etc.). Although not typically configured directly as a plugin, understanding Doxia is useful if we want to extend or customize our documentation formats.

We typically work with Doxia when

* Writing custom site generators
* Working on Maven extensions
* Integrating documentation with custom lifecycle phases
{% endhint %}

### **Asciidoctor Maven Plugin**

For projects requiring **rich, styled, and versioned documentation**, the **Asciidoctor Maven Plugin** allows writing technical documentation using [Asciidoctor](https://asciidoctor.org/), which is popular for developer-focused projects and docs-as-code workflows.

#### **Common Goals:**

| Goal                           | Description                           |
| ------------------------------ | ------------------------------------- |
| `asciidoctor:process-asciidoc` | Converts `.adoc` files to HTML or PDF |
| `asciidoctor:output-html`      | Output to HTML                        |
| `asciidoctor:output-pdf`       | Output to PDF                         |

#### **Basic Configuration**

```xml
<plugin>
  <groupId>org.asciidoctor</groupId>
  <artifactId>asciidoctor-maven-plugin</artifactId>
  <version>2.2.1</version>
  <executions>
    <execution>
      <goals>
        <goal>process-asciidoc</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```

Place documentation in `src/docs/asciidoc`.

