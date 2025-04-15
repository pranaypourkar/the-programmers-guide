# Packaging and Deployment

## About

In a Maven build lifecycle, **packaging and deployment plugins** are responsible for producing distributable artifacts (like JAR, WAR, or EAR files) and moving them to the appropriate destinations — such as local/remote repositories, servers, or other deployment environments. These plugins play a critical role in transitioning code from build to runtime.

## **Maven JAR Plugin**

Creates a JAR file from compiled `.class` files and resources in the `target/` directory. This is the default packaging for standard Java applications.

**Default Goal**

`jar:jar`

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-jar-plugin</artifactId>
  <version>3.3.0</version>
  <configuration>
    <archive>
      <manifest>
        <mainClass>com.example.MainApp</mainClass>
      </manifest>
    </archive>
  </configuration>
</plugin>
```

**Useful Config Options**

| Option                       | Description                |
| ---------------------------- | -------------------------- |
| `archive.manifest.mainClass` | Sets the entry point class |
| `excludes`                   | Exclude specific files     |
| `includes`                   | Include specific files     |

## **Maven WAR Plugin**

Packages the web application into a WAR file for deployment to a servlet container like Tomcat.

**Default Goal**

`war:war`

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-war-plugin</artifactId>
  <version>3.4.0</version>
  <configuration>
    <failOnMissingWebXml>false</failOnMissingWebXml>
    <webResources>
      <resource>
        <directory>src/main/webapp</directory>
      </resource>
    </webResources>
  </configuration>
</plugin>
```

**Useful Config Options**

<table><thead><tr><th width="303.8984375">Option</th><th>Description</th></tr></thead><tbody><tr><td><code>failOnMissingWebXml</code></td><td>For servlet 3.0+, disables need for <code>web.xml</code></td></tr><tr><td><code>webResources</code></td><td>Add custom web assets</td></tr><tr><td><code>packagingExcludes</code></td><td>Exclude specific files from WAR</td></tr></tbody></table>

## **Maven Assembly Plugin**

Creates custom distributions like ZIP, TAR, or executable JARs with dependencies.

**Common Goals**

| Goal     | Description                  |
| -------- | ---------------------------- |
| `single` | Creates one packaged archive |

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-assembly-plugin</artifactId>
  <version>3.6.0</version>
  <executions>
    <execution>
      <phase>package</phase>
      <goals><goal>single</goal></goals>
      <configuration>
        <descriptorRefs>
          <descriptorRef>jar-with-dependencies</descriptorRef>
        </descriptorRefs>
        <archive>
          <manifest>
            <mainClass>com.example.MainApp</mainClass>
          </manifest>
        </archive>
      </configuration>
    </execution>
  </executions>
</plugin>
```

**Descriptor Refs**

* `jar-with-dependencies`
* `project`
* `bin`
* `src`

## **Maven Deploy Plugin**

Uploads your artifact (JAR, WAR, etc.) to a remote Maven repository for sharing with others.

**Default Goal**

`deploy:deploy`

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-deploy-plugin</artifactId>
  <version>3.1.1</version>
  <configuration>
    <altDeploymentRepository>my-repo::default::https://repo.example.com/releases</altDeploymentRepository>
  </configuration>
</plugin>
```

**Repository Credentials**

Defined in `~/.m2/settings.xml` under `<servers>` tag.

## **Maven Install Plugin**

Installs the artifact into your local Maven repository (`~/.m2/repository`), so it can be used as a dependency by other local projects.

**Default Goal**

`install:install`

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-install-plugin</artifactId>
  <version>3.1.1</version>
</plugin>
```

No special configuration is required unless we're customizing the artifact or installing non-built JARs.

## **Maven Shade Plugin**

Creates an uber/fat JAR by including all dependencies, and allows filtering, renaming, and relocating classes to avoid conflicts.

**Common Goal**

`shade:shade`

**Basic Configuration**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-shade-plugin</artifactId>
  <version>3.5.0</version>
  <executions>
    <execution>
      <phase>package</phase>
      <goals>
        <goal>shade</goal>
      </goals>
      <configuration>
        <createDependencyReducedPom>true</createDependencyReducedPom>
        <transformers>
          <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
            <mainClass>com.example.MainApp</mainClass>
          </transformer>
        </transformers>
      </configuration>
    </execution>
  </executions>
</plugin>
```
