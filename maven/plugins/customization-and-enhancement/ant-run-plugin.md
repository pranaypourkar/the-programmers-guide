# ant-run plugin

## **About**

Enables running custom Ant tasks as part of our Maven lifecycle. It is helpful for executing shell commands, scripting logic, or copying files in a non-standard way.

#### **Use Cases**

* Run OS-level scripts
* File manipulations not covered by Maven plugins
* Trigger other build tools (e.g., Gradle, Make)

#### **Example – Custom Script Execution**

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-antrun-plugin</artifactId>
  <version>3.1.0</version>
  <executions>
    <execution>
      <phase>generate-sources</phase>
      <goals>
        <goal>run</goal>
      </goals>
      <configuration>
        <target>
          <echo message="Custom task started..." />
          <mkdir dir="generated/code" />
        </target>
      </configuration>
    </execution>
  </executions>
</plugin>
```
