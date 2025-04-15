# gmavenplus-plugin

## **About**

If we use Groovy scripts in our project, this plugin helps integrate and compile Groovy code seamlessly within Maven.

#### **Use Cases**

* Run Groovy logic
* Integrate Groovy DSLs
* Compile mixed Java-Groovy codebases

#### **Example**

```xml
<plugin>
  <groupId>org.codehaus.gmavenplus</groupId>
  <artifactId>gmavenplus-plugin</artifactId>
  <version>1.13.1</version>
  <executions>
    <execution>
      <goals>
        <goal>compile</goal>
        <goal>generateStubs</goal>
      </goals>
    </execution>
  </executions>
</plugin>
```
