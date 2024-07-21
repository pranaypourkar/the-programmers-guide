# Fluent API Design

## About

Fluent API design in Java refers to a style of coding where the API is designed to be readable and expressive by chaining method calls in a fluid manner. This approach makes the code more intuitive and easier to understand by resembling natural language phrases. Fluent APIs are typically used to build complex objects or configurations through a series of method calls. <mark style="background-color:purple;">This pattern is often implemented using method chaining and builder patterns.</mark>

{% hint style="info" %}
Fluent setters are setters that return the same type as the type being modified.

```
public Builder seatCount(int seatCount) {
    this.seatCount = seatCount;
    return this;
}
```
{% endhint %}

## Key Characteristics

1. **Method Chaining:** Each method returns an instance of the current object, allowing multiple methods to be called in a single statement.
2. **Readable Code:** The chained methods form a readable and self-explanatory sequence of operations.
3. **Immutability:** Often, fluent APIs make use of immutable objects, especially when using the Builder pattern.
4. **Flexible and Extensible:** Fluent APIs allow for easy extension and customization without changing the existing code structure.

## Benefits of Fluent API Design

1. **Improved Readability:** Fluent APIs make the code more readable and maintainable by closely resembling natural language.
2. **Reduced Boilerplate:** Helps reduce boilerplate code, especially when constructing complex objects or configurations.
3. **Enhanced Flexibility:** Makes it easier to create flexible and extensible APIs that can adapt to changing requirements.
4. **Method Chaining:** Encourages a smooth and continuous flow of operations, making the code more intuitive.

## Example: Builder Pattern

A common example of fluent API design is the Builder pattern for constructing complex objects. We will use lombok annotation for generating boilerplate code for Builder.

```java
import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class Car {
    private String make;
    private String model;
    private int year;
    private String color;
}
```

Usage

```java
public class CarUsage {
    public static void main(String[] args) {
        Car car = Car.builder()
            .make("Make")
            .model("XYZ")
            .year(2024)
            .color("Blue")
            .build();
        System.out.println(car.getColor()); // Oupput - Blue
    }
}
```

Generated Builder Class by Lombok

```java
public class Car {
    private String make;
    private String model;
    private int year;
    private String color;

    Car(final String make, final String model, final int year, final String color) {
        this.make = make;
        this.model = model;
        this.year = year;
        this.color = color;
    }

    public static CarBuilder builder() {
        return new CarBuilder();
    }

    public String getMake() {
        return this.make;
    }

    public String getModel() {
        return this.model;
    }

    public int getYear() {
        return this.year;
    }

    public String getColor() {
        return this.color;
    }

    public static class CarBuilder {
        private String make;
        private String model;
        private int year;
        private String color;

        CarBuilder() {
        }

        public CarBuilder make(final String make) {
            this.make = make;
            return this;
        }

        public CarBuilder model(final String model) {
            this.model = model;
            return this;
        }

        public CarBuilder year(final int year) {
            this.year = year;
            return this;
        }

        public CarBuilder color(final String color) {
            this.color = color;
            return this;
        }

        public Car build() {
            return new Car(this.make, this.model, this.year, this.color);
        }

        public String toString() {
            return "Car.CarBuilder(make=" + this.make + ", model=" + this.model + ", year=" + this.year + ", color=" + this.color + ")";
        }
    }
}
```
