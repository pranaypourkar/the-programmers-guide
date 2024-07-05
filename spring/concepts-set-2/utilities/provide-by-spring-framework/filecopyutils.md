# FileCopyUtils

**FileCopyUtils -** `org.springframework.util.FileCopyUtils`

It is a part of the Spring Framework's utility package. It provides static methods to perform file copy operations. This utility offer's methods for copying the contents of an `InputStream` to an `OutputStream`, as well as copying the contents of a file to another file or stream.



* **Copying contents from a file to a variable of String type.**

Create 2 sample files (for e.g. _**SampleXmlResponse.xml**_ and _**SampleJsonResponse.json**_) inside _**mocks**_ folder.

<figure><img src="../../../../.gitbook/assets/image (8) (1) (1) (1) (1).png" alt="" width="260"><figcaption><p>Folder Structure</p></figcaption></figure>

| SampleJsonResponse.json                                                                                                                                                             | SampleXmlResponse.xml                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <pre class="language-json"><code class="lang-json">{
  "getWeatherResponse": {
    "location": "New York",
    "temperature": "75°F",
    "conditions": "Sunny"
  }
}
</code></pre> | <p></p><pre class="language-xml"><code class="lang-xml">&#x3C;SOAP-ENV:Envelope
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:ns1="http://www.example.com/weather">
    &#x3C;SOAP-ENV:Body>
        &#x3C;ns1:getWeatherResponse>
            &#x3C;ns1:location>New York&#x3C;/ns1:location>
            &#x3C;ns1:temperature>75°F&#x3C;/ns1:temperature>
            &#x3C;ns1:conditions>Sunny&#x3C;/ns1:conditions>
        &#x3C;/ns1:getWeatherResponse>
    &#x3C;/SOAP-ENV:Body>
&#x3C;/SOAP-ENV:Envelope>
</code></pre> |

Add logic in the main application class and execute the code.

```java
package org.example;

import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.util.FileCopyUtils;

import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

@Slf4j
public class Application {

    private static final String SUB_DIRECTORY = "mocks";
    private static final String XML_FILENAME = "SampleXmlResponse.xml";
    private static final String JSON_FILENAME = "SampleJsonResponse.json";

    public static void main(String[] args) {
        log.info("Mock XML Response:\n{}", getMockResponse(XML_FILENAME));
        log.info("Mock JSON Response:\n{}", getMockResponse(JSON_FILENAME));
    }

    @SneakyThrows
    public static String getMockResponse(String fileName) {
        var resourceLoader = new DefaultResourceLoader();
        var resource = resourceLoader.getResource(String.format("classpath:%s/%s", SUB_DIRECTORY, fileName));
        return FileCopyUtils.copyToString(new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8));
    }
}
```

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt="" width="563"><figcaption><p>Output</p></figcaption></figure>

