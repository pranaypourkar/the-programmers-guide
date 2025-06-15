---
description: Data Collector example using Strategy and Pipeline Pattern
---

# Data Collector

Let's design a flexible and extensible solution to extract various data points from different sources or formats.

{% hint style="info" %}
**Strategy Pattern**: Encapsulate data collection algorithms in separate classes (Data Collectors).&#x20;

**Pipeline Pattern**: Break down the data extraction process into smaller, independent steps (each Data Collector). Process data sequentially for clarity and maintainability.
{% endhint %}



Create DataCollector interface along with a method collect which takes input as well as output object, which is to be updated.

_**DataCollector.java**_

```java
public interface DataCollector {
    void collect(InputData inputData, OutputData outputData);
}
```



Create several implementation (for eg. header collector, token collector, request collector etc) of the interface.

_**HeaderDataCollector.java**_- Collects headers and set in the output

```java
@Component
public class HeaderDataCollector implements DataCollector {
    @Override
    public void collect(InputData inputData, OutputData outputData) {
        var headers = inputData.getHeaders();
        outputData.setHeaderHost(headers.get("x-host"));
        outputData.setHeaderTraceId(headers.get("x-trace-id"));
        outputData.setHeaderSpanId(headers.get("x-span-id"));
    }
}
```

_**TokenDataCollector.java**_- Collects token metadata and set in the output

```java
@Component
public class TokenDataCollector implements DataCollector {
    @Override
    public void collect(InputData inputData, OutputData outputData) {
        // Add logic to extract claims from JWT token and Set the values accordingly.

        // Sample values are provided below.
        outputData.setUserId("claim.userid");
        outputData.setUserIp("claim.ip");
        outputData.setUserName("claim.subject");
        outputData.setUserEmailId("claim.emailid");
        outputData.setUserPreferredLanguage("claim.language");
    }
}
```

**HttpRequestDataCollector.java**- Collects http request related parameters

```java
@Component
public class HttpRequestDataCollector implements DataCollector {
    @Override
    public void collect(InputData inputData, OutputData outputData) {
        outputData.setCookie(inputData.getCookie());
        outputData.setHttpType(inputData.getHttpType());
        outputData.setRequest(inputData.getRequest());
        outputData.setResponse(inputData.getResponse());
        outputData.setUrl(inputData.getUrl());
    }
}
```



Now, we will create a pipeline class which goes through all the above implementation to extract and set data in the output.

_**DataCollectorPipeline.java**_

```java
@RequiredArgsConstructor
@Component
public class DataCollectorPipeline {

    private final List<DataCollector> dataCollectors;

    public void collect(InputData inputData, OutputData outputData) {
        dataCollectors.forEach(collector -> collector.collect(inputData, outputData));
    }
}
```

{% hint style="info" %}
@RequiredArgsConstructor will inject all the DataCollector beans into `dataCollectors` list&#x20;
{% endhint %}



Pipeline can be called in the service class like below.

_**DataService.java**_

```java
@RequiredArgsConstructor
@Service
public class DataService {

    private final DataCollectorPipeline dataCollectorPipeline;

    public OutputData extractData(InputData inputData) {
        var outputData = new OutputData();
        dataCollectorPipeline.collect(inputData, outputData);
        return outputData;
    }
}
```

