# exec-maven-plugin

## **About**

Allows us to execute system commands or Java classes within the Maven lifecycle.

#### **Use Cases**

* Run Java programs during build
* Call external tools or scripts (Python, Bash, etc.)

#### **Run Java Class Example**

```xml
<plugin>
  <groupId>org.codehaus.mojo</groupId>
  <artifactId>exec-maven-plugin</artifactId>
  <version>3.1.0</version>
  <executions>
    <execution>
      <phase>compile</phase>
      <goals>
        <goal>java</goal>
      </goals>
      <configuration>
        <mainClass>com.example.Tool</mainClass>
      </configuration>
    </execution>
  </executions>
</plugin>
```
