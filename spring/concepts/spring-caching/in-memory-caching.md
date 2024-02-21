---
description: >-
  Provides details about in memory caching and various supported cache
  providers.
---

# In-Memory Caching

### Default Spring In-memory Caching

When @EnableCaching is enabled, Spring Boot auto-configures a basic but functional caching setup without further configuration. By default, a simple in-memory cache based on a _<mark style="color:orange;">concurrent hashmap</mark>_ is used. This provides fast access but loses data on application restart. A default `SimpleCacheManager` manages the in-memory cache and a basic `SimpleKeyGenerator` creates keys based on method arguments. No eviction policy is defined by default.

{% hint style="info" %}
Default behavior is suitable for basic use cases but might not be optimal for production environments. For better performance, customization, and scalability, consider using specific cache providers like Redis, Hazelcast, Memcached or Caffeine. With different caching provider, we need to customize the caching configuration by providing implementation of the CacheManager interface.
{% endhint %}

#### Dependency

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
```

#### Annotations

* **@EnableCaching:**

This annotation is used at the configuration class level to enable Spring's caching capabilities in the application. With this, Spring sets up a default cache manager and creates an in-memory cache using a single concurrent hashmap as the underlying storage mechanism. With this annotation, caching can be disabled by removing only one configuration line rather than all the annotations in the code.





* **@Cacheable:**
* **@CachePut:**&#x20;
* **@CacheEvict:**
* **@CacheConfig:**
* **@Caching:**



