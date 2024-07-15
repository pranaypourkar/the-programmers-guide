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

