---
description: Overview of flatMap along with real world examples.
---

# flatmap

In Java streams, `flatMap` is an intermediate operation, meaning it returns a new stream without modifying the original, and combines two actions:

1. **Mapping:** It applies a function (a `Function` interface implementation) to each element in the stream, producing a new stream of corresponding elements.
2. **Flattening:** It merges the resulting nested streams (created by the mapping) into a single, flat stream.

`flatMap` is particularly useful for working with collections that contain nested structures. It works with streams of any type, allowing for flexibility in data processing.

{% hint style="info" %}
The term "flatMap" originates from functional programming languages, particularly from the concept of "map" and "flat."&#x20;

1. **Map**: The `map` operation applies a function to each element of a collection, resulting in a new collection where each element is the result of applying the function to the corresponding element of the original collection.
2. **Flat**: The "flat" part comes from the idea of "flattening" nested structures. When you have a nested collection (like a list of lists), "flattening" means converting it into a single, non-nested collection.
{% endhint %}



**Example 1:** We have a list of list of integers. Our task in to return a list of integers having numbers divisible by 2.

```java
// Input
List<List<Integer>> list = List.of(
                                List.of(1,2,3,14,17),
                                List.of(4,5,6,18),
                                List.of(7,8,9),
                                List.of(10,11,12,13)
                           );
```

* Traditional approach using iteration

```java
List<Integer> result1 = new ArrayList<>();
        for (int i=0; i<list.size(); i++){
            for (int j=0; j<list.get(i).size(); j++) {
                int num = list.get(i).get(j);
                if (num%2 == 0) {
                    result1.add(num);
                }
            }
        }
```

* Using Streams and flatMap

<pre class="language-java"><code class="lang-java"><strong>List&#x3C;Integer> result2 = list.stream()
</strong>                .flatMap(Collection::stream)
                .filter(a -> a%2==0)
                .toList();
</code></pre>

<figure><img src="../../../.gitbook/assets/image (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) ( (7).png" alt=""><figcaption><p>Output</p></figcaption></figure>



**Example 2**: Lets say we have a list of sentences. Our task is to extract all unique words from sentences.

```java
// input
List<String> sentences = Arrays.asList("Hello to world!", 
                                       "Welcome to Java.", 
                                       "Let's explore streams!");

Set<String> result = sentences.stream()
                .flatMap(sentence -> Stream.of(sentence.split("\\W+")))
                .collect(Collectors.toSet());

 System.out.println(result); 
```

<figure><img src="../../../.gitbook/assets/image (2) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption></figcaption></figure>



**Example 3**: Lets say we have a list of sentences. Our task is to extract all unique words from sentences and the associated length of the word in Map.

```java
// input
List<String> sentences = Arrays.asList("Hello to world!", 
                                       "Welcome to Java.", 
                                       "Let's explore streams!");

Map<String, Integer> result = sentences.stream()
                .flatMap(sentence -> Stream.of(sentence.split("\\W+")))
                .distinct()
                .collect(Collectors.toMap(Function.identity(), String::length));

System.out.println(result);
```

<figure><img src="../../../.gitbook/assets/image (3) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1) (1).png" alt=""><figcaption><p>Output</p></figcaption></figure>
