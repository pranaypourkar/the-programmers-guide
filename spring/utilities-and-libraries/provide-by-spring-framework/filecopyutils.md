---
hidden: true
---

# FileCopyUtils

**FileCopyUtils -** `org.springframework.util.FileCopyUtils`

It is a part of the Spring Framework's utility package. It provides static methods to perform file copy operations. This utility offer's methods for copying the contents of an `InputStream` to an `OutputStream`, as well as copying the contents of a file to another file or stream.

* **Copying contents from a file to a variable of String type.**

Create 2 sample files (for e.g. _**SampleXmlResponse.xml**_ and _**SampleJsonResponse.json**_) inside _**mocks**_ folder.

<figure><img src="../../../.gitbook/assets/image (203).png" alt="" width="260"><figcaption><p>Folder Structure</p></figcaption></figure>

<table><thead><tr><th>SampleJsonResponse.json</th><th>SampleXmlResponse.xml</th></tr></thead><tbody><tr><td><pre class="language-json"><code class="lang-json">{
</code></pre></td><td></td></tr><tr><td>"getWeatherResponse": {</td><td></td></tr></tbody></table>

```
"location": "New York",
"temperature": "75°F",
"conditions": "Sunny"
```

} } |

```xml
<SOAP-ENV:Envelope
xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:ns1="http://www.example.com/weather">
<SOAP-ENV:Body>
<ns1:getWeatherResponse>
<ns1:location>New York</ns1:location>
<ns1:temperature>75°F</ns1:temperature>
<ns1:conditions>Sunny</ns1:conditions>
</ns1:getWeatherResponse>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>
```

|

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

<figure><img src="../../../.gitbook/assets/image (204).png" alt="" width="563"><figcaption><p>Output</p></figcaption></figure>
