# Examples

## Functional style of Soap API call in Java Springboot using Generics and Builder Pattern.

We should be able to call Soap API in the following fashion.

### Sample Outcome

```java
return soapBaseClient
            .request(getUserService::getUser)
            .payload(soapClientRequestMapper.toGetUserRequest(userId))
            .then(soapClientResponseMapper::mapToGetUserResponse)
            .fetchResponse();
```



### Java Code





```java
@FunctionalInterface
public interface RequestMethod<P, R> {
    R execute(P payload);
}
```



```java
import java.util.function.Function;

public class Request<RequestPayloadType, ResponsePayloadType> {

    private final RequestMethod<RequestPayloadType, ResponsePayloadType> requestMethod;

    private RequestPayloadType payload;

    public Request(RequestMethod<RequestPayloadType, ResponsePayloadType> requestMethod) {
        this.requestMethod = requestMethod;
    }

    public Request<RequestPayloadType, ResponsePayloadType> payload(RequestPayloadType payload) {
        this.payload = payload;
        return this;
    }

    public <ProcessedResponseType> RequestCallback<ResponsePayloadType, ProcessedResponseType> then(
        Function<ResponsePayloadType, ProcessedResponseType> handler) {
        return new RequestCallback<>(
            () -> requestMethod.execute(payload),
            handler
        );
    }
}
```



```java
import com.soap.services.ResponseHeaderType;
import java.util.function.Function;
import java.util.function.Supplier;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
public class RequestCallback<ResponsePayloadType, ProcessedResponseType> {

    private static final String RESPONSE_HEADER_FIELD_NAME = "responseHeader";
    private static final String RESPONSE_HEADER_SUCCESS_CODE = "0";

    private final Supplier<ResponsePayloadType> requestProcessor;
    private final Function<ResponsePayloadType, ProcessedResponseType> successHandler;

    public ProcessedResponseType fetchResponse() {
        // Call the Soap API
        ResponsePayloadType response = processRequest();

        // Handle error response
        handleError(response);

        // Process or Map the success Soap API Response with expected response type
        return successHandler.apply(response);
    }

    private ResponsePayloadType processRequest() {
        try {
            // Call the Soap API
            log.debug("Calling soap api");
            return requestProcessor.get();
        } catch (Exception e) {
            log.error("Soap call failed: ", e);
            throw new RuntimeException("Soap Call failed");
        }
    }

    private void handleError(ResponsePayloadType response) {
        ResponseHeaderType responseHeaderType = extractResponseHeader(response);

        if (!RESPONSE_HEADER_SUCCESS_CODE.equals(responseHeaderType.getResponseCode())) {
            throw new RuntimeException("Soap Call failed");
        }
    }

    public ResponseHeaderType extractResponseHeader(ResponsePayloadType response) {
        try {
            var responseHeaderField = response.getClass().getDeclaredField(RESPONSE_HEADER_FIELD_NAME);
            responseHeaderField.setAccessible(true);
            var responseHeader = responseHeaderField.get(response);

            return (ResponseHeaderType) responseHeader;
        } catch (NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
    }
}
```



```java
import org.springframework.stereotype.Component;

@Component
public class SoapBaseClient {

    public <RequestPayloadType, ResponsePayloadType> Request<RequestPayloadType, ResponsePayloadType> request(
        RequestMethod<RequestPayloadType, ResponsePayloadType> requestMethod) {

        // Passing the input Soap API method reference or lambda expression
        return new Request<>(requestMethod);
    }

}
```



```java
import com.example.mapper.SoapClientRequestMapper;
import com.example.mapper.SoapClientResponseMapper;
import com.example.mapper.SoapBaseClient;
import com.soap.services.GetUserService;
import java.util.function.Function;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SoapServiceClient {

    private final SoapClientResponseMapper soapClientResponseMapper;
    private final SoapClientRequestMapper soapClientRequestMapper;
    private final GetUserService getUserService;
    private final SoapBaseClient soapBaseClient;

    public User getUser(String userId) {
        return soapBaseClient
            .request(getUserService::getUser)
            .payload(soapClientRequestMapper.toGetUserRequest(userId))
            .then(soapClientResponseMapper::mapToGetUserResponse)
            .fetchResponse();
    }
}
```



```java
import com.soap.services.GetUserRequest;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface SoapClientRequestMapper {

    @Mapping(target = "userId", source = "userId")
    GetUserRequest toGetUserRequest(String userId);
}
```

```java
import com.soap.services.GetUserResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper
public interface SoapClientResponseMapper {

    @Mapping(target = "id", source = "userId")
    @Mapping(target = "name", source = "userName")
    @Mapping(target = "email", source = "userEmail")
    User mapToGetUserResponse(GetUserResponse getUserResponse);
}
```

