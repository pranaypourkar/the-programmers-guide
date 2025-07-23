# Random

## About

The **`Random`** class in Java is part of the `java.util` package and is used to generate pseudo-random numbers. It provides methods for generating different types of random numbers, including integers, doubles, booleans, and long values. The random numbers produced by the `Random` class are based on a seed value, which influences the sequence of generated values.

* **`Random`** is used for generating random numbers for applications like simulations, games, random sampling, and cryptography (though for cryptography, `SecureRandom` is recommended).
* The class uses an internal seed value to produce a sequence of random numbers. If the same seed is used, the sequence of random numbers will be the same, which can be useful for repeatable tests or simulations.
* The `Random` class is not suitable for cryptographic purposes due to its predictability; for secure random numbers, Java provides the `SecureRandom` class.

{% hint style="info" %}
The **seed** is an initial value used by the random number generator (RNG) to start its internal computation of random numbers. The seed ensures that the random number generator produces a deterministic sequence of numbers, which is particularly useful for reproducibility.

#### **How Seed Works?**

When a seed is set, it initializes the internal state of the RNG. The RNG then uses this state in its algorithm (typically a pseudo-random number generation algorithm like a linear congruential generator) to produce the next number in the sequence.

If the same seed is provided, the initial state will be the same, and the sequence of generated numbers will also be identical.
{% endhint %}

## **Features**

1. **Deterministic Random Number Generation:** The `Random` class uses a deterministic algorithm, meaning it generates the same sequence of random numbers for the same seed.
2. **Support for Multiple Data Types:** It can generate random values of various types, including `int`, `long`, `boolean`, `double`, and arrays of bytes.
3. **Seeding:** The `Random` class allows the seeding of the random number generator to produce a repeatable sequence of random numbers. If no seed is provided, the system clock is used as the default seed.
4. **Performance:** While not suitable for cryptographic purposes, `Random` is efficient for general use cases like simulations and games.
5. **Thread-Local Random:** Since Java 1.7, the `ThreadLocalRandom` class was introduced to provide random number generation that avoids contention among multiple threads. It's preferred when generating random numbers in concurrent applications.

## **Declaration**

To use the `Random` class, we must import it from the `java.util` package:

```java
import java.util.Random;
```

## **Common Methods in `Random` Class**

1. **Generation of Random Numbers:**
   * `nextInt()`: Returns a random integer.
   * `nextInt(bound)`: Returns a random integer between 0 (inclusive) and the specified bound (exclusive).
   * `nextLong()`: Returns a random long value.
   * `nextFloat()`: Returns a random float between 0.0 and 1.0.
   * `nextDouble()`: Returns a random double between 0.0 and 1.0.
   * `nextBoolean()`: Returns a random boolean value.
   * `nextGaussian()`: Returns a random `double` from a Gaussian (normal) distribution with mean 0.0 and standard deviation 1.0.
   * `nextBytes(byte[] bytes)`: Fills the provided byte array with random bytes.
2. **Seeding Methods:**
   * `setSeed(long seed)`: Sets the seed for the random number generator.
   * `Random(long seed)`: Constructor that initializes the random number generator with a specific seed.
3. **State Methods:**
   * `nextInt(int bound)`: Returns a random integer between 0 (inclusive) and the specified bound (exclusive).
   * `nextLong()`: Generates a random long number.

## **Usage**

### **Basic Usage of `Random` Class**

```java
import java.util.Random;

public class RandomExample {
    public static void main(String[] args) {
        Random random = new Random();

        // Generate random integer
        int randomInt = random.nextInt();
        System.out.println("Random Integer: " + randomInt);

        // Generate random integer within a bound (0-99)
        int boundedInt = random.nextInt(100);
        System.out.println("Random Integer within bound (0-99): " + boundedInt);

        // Generate random long
        long randomLong = random.nextLong();
        System.out.println("Random Long: " + randomLong);

        // Generate random boolean
        boolean randomBoolean = random.nextBoolean();
        System.out.println("Random Boolean: " + randomBoolean);

        // Generate random float
        float randomFloat = random.nextFloat();
        System.out.println("Random Float: " + randomFloat);

        // Generate random double
        double randomDouble = random.nextDouble();
        System.out.println("Random Double: " + randomDouble);

        // Generate random bytes
        byte[] randomBytes = new byte[5];
        random.nextBytes(randomBytes);
        System.out.println("Random Bytes: " + new String(randomBytes));
    }
}
```

### **Using `Random` with a Seed**

```java
import java.util.Random;

public class RandomSeedExample {
    public static void main(String[] args) {
        Random random1 = new Random(1234L);
        Random random2 = new Random(1234L);

        // Generating the same random numbers for the same seed
        System.out.println("Random 1: " + random1.nextInt());
        System.out.println("Random 2: " + random2.nextInt());

        // Changing the seed
        Random random3 = new Random(5678L);
        System.out.println("Random 3: " + random3.nextInt());
    }
}
```

### **Using `ThreadLocalRandom` for Concurrent Applications**

```java
import java.util.concurrent.ThreadLocalRandom;

public class ThreadLocalRandomExample {
    public static void main(String[] args) {
        // Generating random numbers without contention in multi-threaded environment
        int randomInt = ThreadLocalRandom.current().nextInt(100);
        System.out.println("Random Integer from ThreadLocalRandom: " + randomInt);

        double randomDouble = ThreadLocalRandom.current().nextDouble(0.0, 1.0);
        System.out.println("Random Double from ThreadLocalRandom: " + randomDouble);
    }
}
```

### **Using `nextGaussian()` for Normal Distribution**

```java
import java.util.Random;

public class GaussianExample {
    public static void main(String[] args) {
        Random random = new Random();

        // Generate random numbers from a Gaussian distribution
        for (int i = 0; i < 5; i++) {
            System.out.println("Gaussian Value: " + random.nextGaussian());
        }
    }
}
```



