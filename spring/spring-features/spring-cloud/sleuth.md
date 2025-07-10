# Sleuth

```
Spring Cloud Sleuth supports propagating trace and custom headers.
Baggage Propagation Configuration
I am passing like this 
private final Tracer tracer;

tracer.createBaggage("user", hostLogContext.getUserName());
        tracer.createBaggage("session", hostLogContext.getSessionId());
        tracer.createBaggage("clientip", hostLogContext.getIdAddress());
        Asyn method

pass some custom header to the calling service. I am using sleuth tracing. 
```
