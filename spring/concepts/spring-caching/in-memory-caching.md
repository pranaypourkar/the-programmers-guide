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

This annotation is used at the configuration class level to enable Spring's caching capabilities in the application. With this, Spring sets up a default cache manager and creates an in-memory cache using a single concurrent hashmap as the underlying storage mechanism. Caching can be disabled by removing only this configuration line rather than all the annotations in the code.

```java
@SpringBootApplication
@EnableCaching
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```



* **@Cacheable:**&#x20;

This annotation is used at the method level to indicate that the result of invoking a method can be cached. When this annotation is applied, Spring first checks whether the method has been called with the same arguments before. If it has, then the cached result is returned instead of invoking the method again. If annotation is parameterize with the name of the cache, the results would be stored with that name. The getName() internal call will first check the cache name before actually invoking the method and then caching the result.

```java
@SneakyThrows
@Cacheable("products")
public List<Product> retrieveAllProducts() {
    // Adding a delay assuming some data retrieval operation
    log.info("Retrieving all the products");
    Thread.sleep(5000);

    // Returning a list containing all the products
    return Arrays.asList(
            new Product(1, "box", "furniture", 1, Boolean.TRUE),
            new Product(2, "apple", "food", 10, Boolean.TRUE),
            new Product(3, "chair", "furniture", 12, Boolean.TRUE)
    );
}
```

{% hint style="info" %}
Note that in most cases, only one cache is declared, the annotation allows multiple names so that more than one cache can be used. In this case, each of the caches is checked before invoking the method. If at least one cache is hit, the associated value is returned.&#x20;

```java
@Cacheable({"products", "allProducts"})
```
{% endhint %}

{% hint style="info" %}
The cacheNames attribute is used to specify the name of the cache while value specifies the alias for the cacheNames. Both are tied to same object.
{% endhint %}



Since caches are essentially key-value stores, each invocation of a cached method needs to be translated into a suitable key for cache access. The default caching abstraction uses a simple `KeyGenerator` based on the following below algorithm. Spring internally uses `hashCode()` and `equals()` for key matching.

* If no parameters are given, return `SimpleKey.EMPTY`.
* If only one parameter is given, return that instance.
* If more than one parameter is given, return a `SimpleKey` that contains all parameters.

In certain scenario, one of the parameter might be helpful to determine the method output but may not be useful by the cache key generator. For example, `availability` parameter below. For such scenario, spring allows us to specify how the key is generated through its `key` attribute. SpEL declarations is allowed.

```java
@SneakyThrows
@Cacheable(cacheNames = "findProduct", key = "#id + '_' + #name")
public Product findProduct(int id, String name, Boolean availability) {
    // Add a delay assuming some data retrieval operation
    log.info("Finding product...");
    Thread.sleep(5000);

    // Returning a product
    return new Product(id, "box", "furniture", 1, Boolean.TRUE);
}
```

{% hint style="info" %}
We can define a custom keyGenerator on the operation if needed.

<pre class="language-java"><code class="lang-java"><strong>@Cacheable(cacheNames="books", keyGenerator="customKeyGenerator")
</strong></code></pre>
{% endhint %}



Conditional attributes can also be provided in the annotation and it takes a SpEL expression that is evaluated to either true or false. If true, the method is cached else it behaves as if the method is not cached.



* **@CachePut:**&#x20;



* **@CacheEvict:**



* **@CacheConfig:**



* **@Caching:**



