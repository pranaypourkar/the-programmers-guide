# Set 5 - Streams and Collection

## Problem 1: Filtering and Collecting as Map

Given a list of Person class containing name and age fields, filter the person by allowing only above 20 years of age and get a map of persons by age.

{% hint style="warning" %}
Assumption

* Name is unique
{% endhint %}

_person.java class_

```java
import java.util.Objects;

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

    public void setName(String name) {
        this.name = name;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        Person person = (Person) o;
        return age == person.age && Objects.equals(name, person.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
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

```java
Person p1 = new Person("Alice", 21);
Person p2 = new Person("Larve", 22);
Person p3 = new Person("Kido", 20);
Person p4 = new Person("Nikee", 21);
Person p5 = new Person("Vieq", 19);
Person p6 = new Person("Yuk", 22);

List<Person> personList = List.of(p1,p2,p3,p4,p5,p6);
Map<Integer, List<Person>> personsByAge = personList.stream()
            .filter(person -> person.getAge() >= 20)
            .collect(Collectors.groupingBy(Person::getAge));

personsByAge.forEach((age, persons) -> System.out.println("Age " + age + ": " + persons));

// Output
// Age 20: [Person{name='Kido', age=20}]
// Age 21: [Person{name='Alice', age=21}, Person{name='Nikee', age=21}]
// Age 22: [Person{name='Larve', age=22}, Person{name='Yuk', age=22}]
```





