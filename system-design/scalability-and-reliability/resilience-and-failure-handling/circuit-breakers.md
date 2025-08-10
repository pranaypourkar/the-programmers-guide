---
hidden: true
---

# Circuit Breakers

Resilience4j Circuit Breaker

```
resilience4j.circuitbreaker:
  instances:
    abc:
      slowCallDurationThreshold: 5000
      permittedNumberOfCallsInHalfOpenState: 5
      slidingWindowType: TIME_BASED
      slidingWindowSize: 120
      waitDurationInOpenState: 300000
      minimumNumberOfCalls: 5
```
