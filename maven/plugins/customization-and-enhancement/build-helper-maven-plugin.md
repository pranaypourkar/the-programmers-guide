# build-helper-maven-plugin

It is a useful Maven plugin provided by the Mojo project **"org.codehaus.mojo"**. It helps in managing various aspects of the build process. Some of the ways in which it helps is given below.

* Add more source directories to the project
* Add more test source directories to your project
* Add more resource directories to your project
* Attach additional artifacts to your project
* Access the parsed components of a project version (properties then can be used in other parts of the Maven build or in the POM configuration)
* Resolve the latest released version of a project
* Remove a project's artifacts from local repository
* Reserve a list of random and unused network ports
* Retrieve current host IP address
* Retrieve current hostname
* Retrieve available number of CPUs

Visit the official documentation for more details - [https://www.mojohaus.org/build-helper-maven-plugin/usage.html](https://www.mojohaus.org/build-helper-maven-plugin/usage.html)



**Example 1**: Adding source and test directories to the build path.

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) ( (2).png" alt="" width="330"><figcaption></figcaption></figure>

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>build-helper-maven-plugin</artifactId>
    <executions>
        <!-- Add more source directories from target folder to the project -->
        <execution>
            <id>add-build-sources</id>
            <phase>generate-sources</phase>
            <goals>
                <goal>add-source</goal>
            </goals>
            <configuration>
                <sources>
                    <source>${project.build.directory}/generated-sources</source>
                </sources>
            </configuration>
        </execution>
        <!-- Add more source directories from main-2 folder to the project -->
        <execution>
            <id>add-main-2-sources</id>
            <phase>generate-sources</phase>
            <goals>
                <goal>add-source</goal>
            </goals>
            <configuration>
                <sources>
                    <source>${basedir}/src/main-2/java</source>
                </sources>
            </configuration>
        </execution>
        <!-- Add more resource directories from main-2 folder to the project -->
        <execution>
            <id>add-main-2-resources</id>
            <phase>generate-resources</phase>
            <goals>
                <goal>add-resource</goal>
            </goals>
            <configuration>
                <resources>
                    <resource>
                        <directory>${basedir}/src/main-2/resources</directory>
                        <targetPath>resources</targetPath>
                        <excludes>
                            <exclude>**/junk/**</exclude>
                        </excludes>
                    </resource>
                </resources>
            </configuration>
        </execution>
        <!-- Add more test source directories from test-2 folder to the project -->
        <execution>
            <id>add-test-2-sources</id>
            <phase>generate-test-sources</phase>
            <goals>
                <goal>add-test-source</goal>
            </goals>
            <configuration>
                <sources>
                    <source>${basedir}/src/test-2/java</source>
                </sources>
            </configuration>
        </execution>
        <!-- Add more test resource directories from test-2 folder to the project -->
        <execution>
            <id>add-test-2-resource</id>
            <phase>generate-test-resources</phase>
            <goals>
                <goal>add-test-resource</goal>
            </goals>
            <configuration>
                <resources>
                    <resource>
                        <directory>${basedir}/src/test-2/resources</directory>
                        <targetPath>resources</targetPath>
                        <excludes>
                            <exclude>**/junk/**</exclude>
                        </excludes>
                    </resource>
                </resources>
            </configuration>
        </execution>
    </executions>
</plugin>
```

> Run `mvn clean compile`  or click on load maven changes button in Intellij in pom.xml file to reflect the changes.&#x20;
>
> ![](<../../../.gitbook/assets/image (25).png>)

