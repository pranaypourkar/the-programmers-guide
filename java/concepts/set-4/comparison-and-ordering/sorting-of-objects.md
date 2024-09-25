# Sorting of Objects

## Arrays

### Ascending Order

```java
// Integer array
int[] intArray = {5, 2, 9, 1, 5, 6};
Arrays.sort(intArray);
System.out.println(Arrays.toString(intArray));

// Character array
char[] charArray = {'b', 'a', 'd', 'c'};
Arrays.sort(charArray);
System.out.println(Arrays.toString(charArray));

// Long array
long[] longArray = {5L, 2L, 9L, 1L, 5L, 6L};
Arrays.sort(longArray);
System.out.println(Arrays.toString(longArray));

// String array
String[] stringArray = {"banana", "apple", "cherry"};
Arrays.sort(stringArray);
System.out.println(Arrays.toString(stringArray));
```

<figure><img src="../../../../.gitbook/assets/image (245).png" alt="" width="245"><figcaption></figcaption></figure>

### Descending Order

```java
// Integer array
Integer[] intArray = {5, 2, 9, 1, 5, 6};
Arrays.sort(intArray, Collections.reverseOrder());
System.out.println(Arrays.toString(intArray));

// Character array
Character[] charArray = {'b', 'a', 'd', 'c'};
Arrays.sort(charArray, Collections.reverseOrder());
System.out.println(Arrays.toString(charArray));

// Long array
Long[] longArray = {5L, 2L, 9L, 1L, 5L, 6L};
Arrays.sort(longArray, Collections.reverseOrder());
System.out.println(Arrays.toString(longArray));

// String array
String[] stringArray = {"banana", "apple", "cherry"};
Arrays.sort(stringArray, Collections.reverseOrder());
System.out.println(Arrays.toString(stringArray));
```

<figure><img src="../../../../.gitbook/assets/image (246).png" alt="" width="296"><figcaption></figcaption></figure>

## List

### Wrapper Primitive

#### Ascending Order

```java
// Integer list
List<Integer> intList = new ArrayList<>(List.of(5, 2, 9, 1, 5, 6));
Collections.sort(intList);
System.out.println(intList);

// Character list
List<Character> charList = new ArrayList<>(List.of('b', 'a', 'd', 'c'));
Collections.sort(charList);
System.out.println(charList);

// Long list
List<Long> longList = new ArrayList<>(List.of(5L, 2L, 9L, 1L, 5L, 6L));
Collections.sort(longList);
System.out.println(longList);

// String list
List<String> stringList = new ArrayList<>(List.of("banana", "apple", "cherry"));
Collections.sort(stringList);
System.out.println(stringList);
```

<figure><img src="../../../../.gitbook/assets/image (247).png" alt="" width="239"><figcaption></figcaption></figure>

#### Descending Order

```java
// Integer list
List<Integer> intList = new ArrayList<>(List.of(5, 2, 9, 1, 5, 6));
Collections.sort(intList, Collections.reverseOrder());
// Or intList.sort(Collections.reverseOrder());
System.out.println(intList);

// Character list
List<Character> charList = new ArrayList<>(List.of('b', 'a', 'd', 'c'));
Collections.sort(charList, Collections.reverseOrder());
System.out.println(charList);

// Long list
List<Long> longList = new ArrayList<>(List.of(5L, 2L, 9L, 1L, 5L, 6L));
Collections.sort(longList, Collections.reverseOrder());
System.out.println(longList);

// String list
List<String> stringList = new ArrayList<>(List.of("banana", "apple", "cherry"));
Collections.sort(stringList, Collections.reverseOrder());
System.out.println(stringList);
```

<figure><img src="../../../../.gitbook/assets/image (248).png" alt="" width="269"><figcaption></figcaption></figure>

{% hint style="success" %}
We can replace `Collections.sort(...)` with `givenList.sort(...)`.\
Note that a comparator function is mandatory to pass in sort method here.

For example

```
intList.sort(Collections.reverseOrder());
```
{% endhint %}

### Custom Object

Consider a Person class below as a custom object

```java
public class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}
```

#### Ascending Order

```java
List<Person> people = new ArrayList<>();
people.add(new Person("Alice", 30));
people.add(new Person("Bob", 25));
people.add(new Person("Charlie", 35));

// Sorting by age in ascending order
Collections.sort(people, Comparator.comparingInt(Person::getAge));
people.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (249).png" alt="" width="172"><figcaption></figcaption></figure>

#### Descending Order

```java
List<Person> people = new ArrayList<>();
people.add(new Person("Alice", 30));
people.add(new Person("Bob", 25));
people.add(new Person("Charlie", 35));

// Sorting by age in descending order
people.sort(Comparator.comparingInt(Person::getAge).reversed());
people.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (250).png" alt="" width="131"><figcaption></figcaption></figure>

## Sets

### Wrapper Primitive

We usually use a `TreeSet` to maintain order.

#### Ascending Order

```java
// Integer set
Set<Integer> intSet = new TreeSet<>(Set.of(5, 2, 9, 1, 7, 6));
System.out.println(intSet);

// Character set
Set<Character> charSet = new TreeSet<>(Set.of('b', 'a', 'd', 'c'));
System.out.println(charSet);

// Long set
Set<Long> longSet = new TreeSet<>(Set.of(5L, 2L, 9L, 1L, 7L, 6L));
System.out.println(longSet);

// String set
Set<String> stringSet = new TreeSet<>(Set.of("banana", "apple", "cherry"));
System.out.println(stringSet);
```

<figure><img src="../../../../.gitbook/assets/image (11).png" alt="" width="281"><figcaption></figcaption></figure>

#### Descending Order

```java
// Integer set
Set<Integer> intSet = new TreeSet<>(Collections.reverseOrder());
intSet.addAll(Set.of(5, 2, 9, 1, 7, 6));
System.out.println(intSet);

// Character set
Set<Character> charSet = new TreeSet<>(Collections.reverseOrder());
charSet.addAll(Set.of('b', 'a', 'd', 'c'));
System.out.println(charSet);

// Long set
Set<Long> longSet = new TreeSet<>(Collections.reverseOrder());
longSet.addAll(Set.of(5L, 2L, 9L, 1L, 7L, 6L));
System.out.println(longSet);

// String set
Set<String> stringSet = new TreeSet<>(Collections.reverseOrder());
stringSet.addAll(Set.of("banana", "apple", "cherry"));
System.out.println(stringSet);
```

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (1) (1).png" alt="" width="346"><figcaption></figcaption></figure>

### **Custom Objects**

#### **Ascending Order**

```java
Set<Person> people = new TreeSet<>(Comparator.comparingInt(Person::getAge));
people.add(new Person("Alice", 30));
people.add(new Person("Bob", 25));
people.add(new Person("Charlie", 35));

people.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (1).png" alt="" width="206"><figcaption></figcaption></figure>

```java
Set<Person> personSet = new HashSet<>();
personSet.add(new Person("Alice", 30));
personSet.add(new Person("Bob", 25));
personSet.add(new Person("Charlie", 35));

List<Person> personList = new ArrayList<>(personSet);
personList.sort(Comparator.comparingInt(Person::getAge));

personList.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (3) (1) (1) (1).png" alt="" width="191"><figcaption></figcaption></figure>

#### **Descending Order**

```java
Set<Person> personSet = new HashSet<>();
personSet.add(new Person("Alice", 30));
personSet.add(new Person("Bob", 25));
personSet.add(new Person("Charlie", 35));

List<Person> personList = new ArrayList<>(personSet);
personList.sort(Comparator.comparingInt(Person::getAge).reversed());

personList.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (4) (1) (1).png" alt="" width="158"><figcaption></figcaption></figure>

```java
Set<Person> people = new TreeSet<>(Comparator.comparingInt(Person::getAge).reversed());
people.add(new Person("Alice", 30));
people.add(new Person("Bob", 25));
people.add(new Person("Charlie", 35));

people.forEach(p -> System.out.println(p.getName() + " - " + p.getAge()));
```

<figure><img src="../../../../.gitbook/assets/image (5) (1) (1).png" alt=""><figcaption></figcaption></figure>

## Maps

Maps in Java do not have a natural order, so to sort them we often sort their keys or values and then create a new `LinkedHashMap` to maintain the order.

### Wrapper Primitives

#### Ascending Order by Keys

```java
Map<Integer, String> map = new HashMap<>();
map.put(5, "five");
map.put(2, "two");
map.put(8, "eight");

Map<Integer, String> sortedMap = new TreeMap<>(map);

for (Map.Entry<Integer, String> entry : sortedMap.entrySet())
System.out.println("Entry Key - " + entry.getKey() + " Entry Value - " + entry.getValue());
```

<figure><img src="../../../../.gitbook/assets/image (6) (1) (1).png" alt="" width="368"><figcaption></figcaption></figure>

#### Ascending Order by Values

```java
Map<Integer, String> map = new HashMap<>();
map.put(5, "five");
map.put(2, "two");
map.put(8, "eight");

List<Map.Entry<Integer, String>> entries = new ArrayList<>(map.entrySet());
entries.sort(Map.Entry.comparingByValue());

Map<Integer, String> sortedMapByValue = new LinkedHashMap<>();
for (Map.Entry<Integer, String> entry : entries) {
    sortedMapByValue.put(entry.getKey(), entry.getValue());
}

for (Map.Entry<Integer, String> entry : sortedMapByValue.entrySet()) {
    System.out.println("Entry Key - " + entry.getKey() + " Entry Value - " + entry.getValue());
}
```

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (2) (1).png" alt="" width="281"><figcaption></figcaption></figure>

#### Descending Order by Keys

```java
Map<Integer, String> map = new HashMap<>();
map.put(5, "five");
map.put(2, "two");
map.put(8, "eight");

Map<Integer, String> sortedMap = new TreeMap<>(Collections.reverseOrder());
sortedMap.putAll(map);

for (Map.Entry<Integer, String> entry : sortedMap.entrySet()) {
    System.out.println("Entry Key - " + entry.getKey() + " Entry Value - " + entry.getValue());
}
```

<figure><img src="../../../../.gitbook/assets/image (7) (1) (1).png" alt="" width="296"><figcaption></figcaption></figure>

#### Descending Order by Values

<pre class="language-java"><code class="lang-java">Map&#x3C;Integer, String> map = new HashMap&#x3C;>();
map.put(5, "five");
map.put(2, "two");
map.put(8, "eight");

List&#x3C;Map.Entry&#x3C;Integer, String>> entries = new ArrayList&#x3C;>(map.entrySet());
entries.sort(Map.Entry.comparingByValue(Comparator.reverseOrder()));

Map&#x3C;Integer, String> sortedMapByValue = new LinkedHashMap&#x3C;>();
for (Map.Entry&#x3C;Integer, String> entry : entries) {
<strong>    sortedMapByValue.put(entry.getKey(), entry.getValue());
</strong>}

for (Map.Entry&#x3C;Integer, String> entry : sortedMapByValue.entrySet()) {
    System.out.println("Entry Key - " + entry.getKey() + " Entry Value - " + entry.getValue());
}
</code></pre>

<figure><img src="../../../../.gitbook/assets/image (7).png" alt="" width="277"><figcaption></figcaption></figure>

### Custom Object

**Person Class**

```java
class Person {
    private String id;
    private String name;
    private int age;

    public Person(String id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    @Override
    public String toString() {
        return "Person{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

#### Ascending Order by Keys

```
Map<String, Person> personMap = new HashMap<>();
personMap.put("2", new Person("2", "Bob", 25));
personMap.put("1", new Person("1", "Alice", 30));
personMap.put("3", new Person("3", "Charlie", 35));

Map<String, Person> sortedByKeyMap = new TreeMap<>(personMap);

// Print sorted map
sortedByKeyMap.forEach((key, value) -> System.out.println(key + ": " + value));
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1) (2).png" alt="" width="332"><figcaption></figcaption></figure>

#### Descending Order by Keys

```java
Map<String, Person> personMap = new HashMap<>();
personMap.put("2", new Person("2", "Bob", 25));
personMap.put("1", new Person("1", "Alice", 30));
personMap.put("3", new Person("3", "Charlie", 35));

Map<String, Person> sortedByKeyDescMap = new TreeMap<>(Collections.reverseOrder());
sortedByKeyDescMap.putAll(personMap);

// Print sorted map
sortedByKeyDescMap.forEach((key, value) -> System.out.println(key + ": " + value));
```

<figure><img src="../../../../.gitbook/assets/image (3) (1) (1).png" alt="" width="329"><figcaption></figcaption></figure>

#### Ascending Order by Values (Person's Age)

```java
Map<String, Person> personMap = new HashMap<>();
personMap.put("2", new Person("2", "Bob", 25));
personMap.put("1", new Person("1", "Alice", 30));
personMap.put("3", new Person("3", "Charlie", 35));

List<Map.Entry<String, Person>> entries = new ArrayList<>(personMap.entrySet());
entries.sort(Map.Entry.comparingByValue(Comparator.comparingInt(Person::getAge)));

Map<String, Person> sortedByValueMap = new LinkedHashMap<>();
for (Map.Entry<String, Person> entry : entries) {
        sortedByValueMap.put(entry.getKey(), entry.getValue());
}

// Print sorted map
sortedByValueMap.forEach((key, value) -> System.out.println(key + ": " + value));
```

<figure><img src="../../../../.gitbook/assets/image (4) (1).png" alt="" width="328"><figcaption></figcaption></figure>

#### Descending Order by Values (Person's Age)

```java
Map<String, Person> personMap = new HashMap<>();
personMap.put("2", new Person("2", "Bob", 25));
personMap.put("1", new Person("1", "Alice", 30));
personMap.put("3", new Person("3", "Charlie", 35));

List<Map.Entry<String, Person>> entries = new ArrayList<>(personMap.entrySet());
entries.sort(Map.Entry.comparingByValue(Comparator.comparingInt(Person::getAge).reversed()));

Map<String, Person> sortedByValueMap = new LinkedHashMap<>();
for (Map.Entry<String, Person> entry : entries) {
        sortedByValueMap.put(entry.getKey(), entry.getValue());
}

// Print sorted map
sortedByValueMap.forEach((key, value) -> System.out.println(key + ": " + value));
```

<figure><img src="../../../../.gitbook/assets/image (5) (1).png" alt="" width="318"><figcaption></figcaption></figure>

## Nested List

### Wrapper Primitives

#### Ascending Order

```java
List<List<Integer>> nestedList = new ArrayList<>();
nestedList.add(Arrays.asList(3, 5, 4));
nestedList.add(Arrays.asList(8, 2, 6));

// Sort inner lists
for (List<Integer> list : nestedList) {
        Collections.sort(list);
}

// Sort outer list based on the first element of each inner list
nestedList.sort(Comparator.comparingInt(list -> list.get(0)));

nestedList.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (6) (1).png" alt="" width="128"><figcaption></figcaption></figure>

#### Descending Order

```java
List<List<Integer>> nestedList = new ArrayList<>();
nestedList.add(Arrays.asList(3, 5, 4));
nestedList.add(Arrays.asList(8, 2, 6));

// Sort inner lists in reverse order
for (List<Integer> list : nestedList) {
        Collections.sort(list, Collections.reverseOrder());
}

// Sort outer list in reverse order based on the first element of each inner list
nestedList.sort(Comparator.comparingInt((List<Integer> list) -> list.get(0)).reversed());

nestedList.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (7) (1).png" alt="" width="82"><figcaption></figcaption></figure>

### Custom Object

```java
class Person {
    private String name;
    private int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    @Override
    public String toString() {
        return "Person{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

#### Ascending Order by Age

```java
List<List<Person>> nestedPersonList = new ArrayList<>();
nestedPersonList.add(Arrays.asList(new Person("Alice", 30), new Person("Bob", 25)));
nestedPersonList.add(Arrays.asList(new Person("Charlie", 35), new Person("Dave", 28)));

// Sort inner lists by age
for (List<Person> list : nestedPersonList) {
        list.sort(Comparator.comparingInt(Person::getAge));
}

// Sort outer list by the first person's age in each inner list
nestedPersonList.sort(Comparator.comparingInt(list -> list.get(0).getAge()));

nestedPersonList.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (8).png" alt="" width="476"><figcaption></figcaption></figure>

#### Descending Order by Age

```java
List<List<Person>> nestedPersonList = new ArrayList<>();
nestedPersonList.add(Arrays.asList(new Person("Alice", 30), new Person("Bob", 25)));
nestedPersonList.add(Arrays.asList(new Person("Charlie", 35), new Person("Dave", 28)));

// Sort inner lists by age in reverse order
for (List<Person> list : nestedPersonList) {
        list.sort(Comparator.comparingInt(Person::getAge).reversed());
}

// Sort outer list by the first person's age in reverse order
nestedPersonList.sort(Comparator.comparingInt((List<Person> list) -> list.get(0).getAge()).reversed());

nestedPersonList.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (9).png" alt="" width="472"><figcaption></figcaption></figure>

## Nested Map

### Wrapper Primitives

#### Ascending Order

```java
Map<Integer, Map<Integer, String>> nestedMap = new HashMap<>();
nestedMap.put(1, new HashMap<>(Map.of(3, "three", 1, "one", 2, "two")));
nestedMap.put(2, new HashMap<>(Map.of(6, "six", 5, "five", 4, "four")));

// Sort inner maps
for (Map.Entry<Integer, Map<Integer, String>> entry : nestedMap.entrySet()) {
        Map<Integer, String> sortedInnerMap = new TreeMap<>(entry.getValue());
        nestedMap.put(entry.getKey(), sortedInnerMap);
}

// Sort outer map
Map<Integer, Map<Integer, String>> sortedNestedMap = new TreeMap<>(nestedMap);
sortedNestedMap.forEach((key, value) -> System.out.println(STR."Key: \{key} Value: \{value}"));
```

<figure><img src="../../../../.gitbook/assets/image (10).png" alt="" width="302"><figcaption></figcaption></figure>

#### Descending Order

```java
Map<Integer, Map<Integer, String>> nestedMap = new HashMap<>();
nestedMap.put(1, new HashMap<>(Map.of(3, "three", 1, "one", 2, "two")));
nestedMap.put(2, new HashMap<>(Map.of(6, "six", 5, "five", 4, "four")));

// Sort inner maps in reverse order
for (Map.Entry<Integer, Map<Integer, String>> entry : nestedMap.entrySet()) {
    Map<Integer, String> sortedInnerMap = new TreeMap<>(Collections.reverseOrder());
    sortedInnerMap.putAll(entry.getValue());
    nestedMap.put(entry.getKey(), sortedInnerMap);
}

// Sort outer map in reverse order
Map<Integer, Map<Integer, String>> sortedNestedMap = new TreeMap<>(Collections.reverseOrder());
sortedNestedMap.putAll(nestedMap);

sortedNestedMap.forEach((key, value) -> System.out.println(STR."Key: \{key} Value: \{value}"));
```

<figure><img src="../../../../.gitbook/assets/image (3).png" alt="" width="290"><figcaption></figcaption></figure>

### Custom Object

Assuming `Person` as keys in nested maps.

#### Ascending Order

```java
Map<Person, Map<Person, String>> nestedPersonMap = new HashMap<>();
nestedPersonMap.put(new Person("Group1", 50), new HashMap<>(Map.of(new Person("Alice", 30), "Alice", new Person("Bob", 25), "Bob")));
nestedPersonMap.put(new Person("Group2", 60), new HashMap<>(Map.of(new Person("Charlie", 35), "Charlie", new Person("Dave", 28), "Dave")));

// Sort inner maps by age
for (Map.Entry<Person, Map<Person, String>> entry : nestedPersonMap.entrySet()) {
    Map<Person, String> sortedInnerMap = new TreeMap<>(Comparator.comparingInt(Person::getAge));
    sortedInnerMap.putAll(entry.getValue());
    nestedPersonMap.put(entry.getKey(), sortedInnerMap);
}

// Sort outer map by age
Map<Person, Map<Person, String>> sortedNestedPersonMap = new TreeMap<>(Comparator.comparingInt(Person::getAge));
sortedNestedPersonMap.putAll(nestedPersonMap);

sortedNestedPersonMap.forEach((key, value) -> System.out.println(STR."Key: \{key} Value: \{value}"));
```

<figure><img src="../../../../.gitbook/assets/image (1) (1) (1) (2).png" alt=""><figcaption></figcaption></figure>

#### Descending Order

```java
Map<Person, Map<Person, String>> nestedPersonMap = new HashMap<>();
nestedPersonMap.put(new Person("Group1", 50), new HashMap<>(Map.of(new Person("Alice", 30), "Alice", new Person("Bob", 25), "Bob")));
nestedPersonMap.put(new Person("Group2", 60), new HashMap<>(Map.of(new Person("Charlie", 35), "Charlie", new Person("Dave", 28), "Dave")));

// Sort inner maps by age in reverse order
for (Map.Entry<Person, Map<Person, String>> entry : nestedPersonMap.entrySet()) {
        Map<Person, String> sortedInnerMap = new TreeMap<>(Comparator.comparingInt(Person::getAge).reversed());
        sortedInnerMap.putAll(entry.getValue());
        nestedPersonMap.put(entry.getKey(), sortedInnerMap);
}

// Sort outer map by age in reverse order
Map<Person, Map<Person, String>> sortedNestedPersonMap = new TreeMap<>(Comparator.comparingInt(Person::getAge).reversed());
sortedNestedPersonMap.putAll(nestedPersonMap);

sortedNestedPersonMap.forEach((key, value) -> System.out.println(STR."Key: \{key} Value: \{value}"));
```

<figure><img src="../../../../.gitbook/assets/image (2) (1) (1).png" alt=""><figcaption></figcaption></figure>

## Nested Set

Since `Set` does not maintain order, we'll use a sorted `Set` implementation like `TreeSet`.

### **Wrapper Primitives**

#### **Ascending Order**

```java
Set<Set<Integer>> nestedSet = new HashSet<>();
nestedSet.add(new HashSet<>(Arrays.asList(3, 5, 1)));
nestedSet.add(new HashSet<>(Arrays.asList(8, 2, 6)));

// Sort inner sets
Set<Set<Integer>> sortedNestedSet = new TreeSet<>(Comparator.comparingInt(set -> set.iterator().next()));
for (Set<Integer> set : nestedSet) {
        sortedNestedSet.add(new TreeSet<>(set));
}

sortedNestedSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (3) (1).png" alt="" width="95"><figcaption></figcaption></figure>

#### **Descending Order**

```java
Set<Set<Integer>> nestedSet = new HashSet<>();
nestedSet.add(new HashSet<>(Arrays.asList(3, 5, 1)));
nestedSet.add(new HashSet<>(Arrays.asList(8, 2, 6)));

// Sort inner sets
Set<Set<Integer>> sortedNestedSet = new TreeSet<>(Comparator.comparingInt((Set<Integer> set) -> set.iterator().next()).reversed());
for (Set<Integer> set : nestedSet) {
        sortedNestedSet.add(new TreeSet<>(set).descendingSet());
}

sortedNestedSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (4).png" alt="" width="92"><figcaption></figcaption></figure>

### **Custom Object**

Assuming `Person` as elements in sets.

#### **Ascending Order**

```java
Set<Set<Person>> nestedPersonSet = new HashSet<>();
nestedPersonSet.add(new HashSet<>(Arrays.asList(new Person("Alice", 30), new Person("Bob", 25))));
nestedPersonSet.add(new HashSet<>(Arrays.asList(new Person("Charlie", 35), new Person("Dave", 28))));

// Sort inner sets by age
Set<Set<Person>> sortedNestedPersonSet = new TreeSet<>(Comparator.comparingInt(set -> set.iterator().next().getAge()));
for (Set<Person> set : nestedPersonSet) {
        Set<Person> sortedInnerSet = new TreeSet<>(Comparator.comparingInt(Person::getAge));
        sortedInnerSet.addAll(set);
        sortedNestedPersonSet.add(sortedInnerSet);
}

sortedNestedPersonSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (5).png" alt="" width="476"><figcaption></figcaption></figure>

#### **Descending Orde**

```java
Set<Set<Person>> nestedPersonSet = new HashSet<>();
nestedPersonSet.add(new HashSet<>(Arrays.asList(new Person("Alice", 30), new Person("Bob", 25))));
nestedPersonSet.add(new HashSet<>(Arrays.asList(new Person("Charlie", 35), new Person("Dave", 28))));

// Sort inner sets by age
Set<Set<Person>> sortedNestedPersonSet = new TreeSet<>(Comparator.comparingInt((Set<Person> set) -> set.iterator().next().getAge()).reversed());
for (Set<Person> set : nestedPersonSet) {
    Set<Person> sortedInnerSet = new TreeSet<>(Comparator.comparingInt(Person::getAge).reversed());
    sortedInnerSet.addAll(set);
    sortedNestedPersonSet.add(sortedInnerSet);
}

sortedNestedPersonSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (6).png" alt="" width="479"><figcaption></figcaption></figure>

## Nested List of Set

### Wrapper Primitives

#### Ascending Order

```java
List<Set<Integer>> nestedListSet = new ArrayList<>();
nestedListSet.add(new HashSet<>(Arrays.asList(3, 5, 1)));
nestedListSet.add(new HashSet<>(Arrays.asList(8, 2, 6)));

// Sort inner sets
List<Set<Integer>> sortedNestedListSet = new ArrayList<>();
for (Set<Integer> set : nestedListSet) {
        Set<Integer> sortedSet = new TreeSet<>(set);
        sortedNestedListSet.add(sortedSet);
}

// Sort outer list based on the first element of each inner set
sortedNestedListSet.sort(Comparator.comparingInt(set -> set.iterator().next()));

// Print sorted nested list of sets
System.out.println("Ascending Order:");
sortedNestedListSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (251).png" alt="" width="106"><figcaption></figcaption></figure>

#### Descending Order

```java
List<Set<Integer>> nestedListSet = new ArrayList<>();
nestedListSet.add(new HashSet<>(Arrays.asList(3, 5, 1)));
nestedListSet.add(new HashSet<>(Arrays.asList(8, 2, 6)));

// Sort inner sets in reverse order
List<Set<Integer>> sortedNestedListSet = new ArrayList<>();
for (Set<Integer> set : nestedListSet) {
        Set<Integer> sortedSet = new TreeSet<>(Collections.reverseOrder());
        sortedSet.addAll(set);
        sortedNestedListSet.add(sortedSet);
}

// Sort outer list based on the first element of each inner set in reverse order
sortedNestedListSet.sort(Comparator.comparingInt((Set<Integer> set) -> set.iterator().next()).reversed());

// Print sorted nested list of sets
System.out.println("Descending Order:");
sortedNestedListSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (252).png" alt="" width="168"><figcaption></figcaption></figure>

### Custom Objects

Person Class

```java
class Person {
    private String id;
    private String name;
    private int age;

    public Person(String id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }

    public int getAge() {
        return age;
    }

    @Override
    public String toString() {
        return "Person{id='" + id + "', name='" + name + "', age=" + age + '}';
    }
}
```

#### Ascending Order

<pre class="language-java"><code class="lang-java">List&#x3C;Set&#x3C;Person>> nestedListSet = new ArrayList&#x3C;>();
nestedListSet.add(new HashSet&#x3C;>(Arrays.asList(new Person("1", "Alice", 30), new Person("2", "Bob", 25))));
nestedListSet.add(new HashSet&#x3C;>(Arrays.asList(new Person("3", "Charlie", 35), new Person("4", "Dave", 28))));

// Sort inner sets by age
List&#x3C;Set&#x3C;Person>> sortedNestedListSet = new ArrayList&#x3C;>();
for (Set&#x3C;Person> set : nestedListSet) {
<strong>        Set&#x3C;Person> sortedSet = new TreeSet&#x3C;>(Comparator.comparingInt(Person::getAge));
</strong>        sortedSet.addAll(set);
        sortedNestedListSet.add(sortedSet);
}

// Sort outer list based on the first person's age in each inner set
sortedNestedListSet.sort(Comparator.comparingInt(set -> set.iterator().next().getAge()));

// Print sorted nested list of sets
System.out.println("Ascending Order by Age:");
sortedNestedListSet.forEach(System.out::println);
</code></pre>

<figure><img src="../../../../.gitbook/assets/image (253).png" alt=""><figcaption></figcaption></figure>

#### Descending Order

```java
List<Set<Person>> nestedListSet = new ArrayList<>();
nestedListSet.add(new HashSet<>(Arrays.asList(new Person("1", "Alice", 30), new Person("2", "Bob", 25))));
nestedListSet.add(new HashSet<>(Arrays.asList(new Person("3", "Charlie", 35), new Person("4", "Dave", 28))));

// Sort inner sets by age in reverse order
List<Set<Person>> sortedNestedListSet = new ArrayList<>();
for (Set<Person> set : nestedListSet) {
        Set<Person> sortedSet = new TreeSet<>(Comparator.comparingInt(Person::getAge).reversed());
        sortedSet.addAll(set);
        sortedNestedListSet.add(sortedSet);
}

// Sort outer list based on the first person's age in each inner set in reverse order
sortedNestedListSet.sort(Comparator.comparingInt((Set<Person> set) -> set.iterator().next().getAge()).reversed());

// Print sorted nested list of sets
System.out.println("Descending Order by Age:");
sortedNestedListSet.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (254).png" alt="" width="563"><figcaption></figcaption></figure>

## Nested List of Map

### Wrapper Primitives

#### Ascending Order

```java
List<Map<Integer, String>> nestedListMap = new ArrayList<>();
nestedListMap.add(new HashMap<>(Map.of(3, "three", 1, "one", 2, "two")));
nestedListMap.add(new HashMap<>(Map.of(6, "six", 5, "five", 4, "four")));

// Sort inner maps
List<Map<Integer, String>> sortedNestedListMap = new ArrayList<>();
for (Map<Integer, String> map : nestedListMap) {
        Map<Integer, String> sortedMap = new TreeMap<>(map);
        sortedNestedListMap.add(sortedMap);
}

// Sort outer list based on the first key in each inner map
sortedNestedListMap.sort(Comparator.comparingInt(map -> map.keySet().iterator().next()));

// Print sorted nested list of maps
System.out.println("Ascending Order:");
sortedNestedListMap.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (255).png" alt="" width="221"><figcaption></figcaption></figure>

#### Descending Order

```java
List<Map<Integer, String>> nestedListMap = new ArrayList<>();
nestedListMap.add(new HashMap<>(Map.of(3, "three", 1, "one", 2, "two")));
nestedListMap.add(new HashMap<>(Map.of(6, "six", 5, "five", 4, "four")));

// Sort inner maps in reverse order
List<Map<Integer, String>> sortedNestedListMap = new ArrayList<>();
for (Map<Integer, String> map : nestedListMap) {
        Map<Integer, String> sortedMap = new TreeMap<>(Collections.reverseOrder());
        sortedMap.putAll(map);
        sortedNestedListMap.add(sortedMap);
}

// Sort outer list based on the first key in each inner map in reverse order
sortedNestedListMap.sort(Comparator.comparingInt((Map<Integer, String> map) -> map.keySet().iterator().next()).reversed());

// Print sorted nested list of maps
System.out.println("Descending Order:");
sortedNestedListMap.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (256).png" alt="" width="226"><figcaption></figcaption></figure>

### Custom Object

#### Ascending Order

```java
List<Map<String, Person>> nestedListMap = new ArrayList<>();
nestedListMap.add(new HashMap<>(Map.of("2", new Person("2", "Bob", 25), "1", new Person("1", "Alice", 30))));
nestedListMap.add(new HashMap<>(Map.of("4", new Person("4", "Dave", 28), "3", new Person("3", "Charlie", 35))));

// Sort inner maps by key
List<Map<String, Person>> sortedNestedListMap = new ArrayList<>();
for (Map<String, Person> map : nestedListMap) {
        Map<String, Person> sortedMap = new TreeMap<>(map);
        sortedNestedListMap.add(sortedMap);
}

// Sort outer list based on the first key in each inner map
sortedNestedListMap.sort(Comparator.comparing(map -> map.keySet().iterator().next()));

// Print sorted nested list of maps
System.out.println("Ascending Order by Key:");
sortedNestedListMap.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (257).png" alt="" width="563"><figcaption></figcaption></figure>

#### Descending Order

```java
List<Map<String, Person>> nestedListMap = new ArrayList<>();
nestedListMap.add(new HashMap<>(Map.of("2", new Person("2", "Bob", 25), "1", new Person("1", "Alice", 30))));
nestedListMap.add(new HashMap<>(Map.of("4", new Person("4", "Dave", 28), "3", new Person("3", "Charlie", 35))));

// Sort inner maps by key in reverse order
List<Map<String, Person>> sortedNestedListMap = new ArrayList<>();
for (Map<String, Person> map : nestedListMap) {
        Map<String, Person> sortedMap = new TreeMap<>(Collections.reverseOrder());
        sortedMap.putAll(map);
        sortedNestedListMap.add(sortedMap);
}

// Sort outer list based on the first key in each inner map in reverse order
sortedNestedListMap.sort(Comparator.comparing((Map<String, Person> map) -> map.keySet().iterator().next()).reversed());

// Print sorted nested list of maps
System.out.println("Descending Order by Key:");
sortedNestedListMap.forEach(System.out::println);
```

<figure><img src="../../../../.gitbook/assets/image (258).png" alt="" width="563"><figcaption></figcaption></figure>

