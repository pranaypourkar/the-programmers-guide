# properties-maven-plugin

## **About**

This plugin allows us to read external properties from files or define new ones inside the POM, which can then be used throughout your Maven build.

#### **Use Cases**

* Read values from external config
* Set dynamic values as Maven properties

#### **Example – Reading from a File**

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>properties-maven-plugin</artifactId>
  <version>1.0.0</version>
  <executions>
    <execution>
      <phase>initialize</phase>
      <goals>
        <goal>read-project-properties</goal>
      </goals>
      <configuration>
        <files>
          <file>build.properties</file>
        </files>
      </configuration>
    </execution>
  </executions>
</plugin>
```
