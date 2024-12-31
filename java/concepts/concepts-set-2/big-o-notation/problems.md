# Problems

## For loop

### Simple for loop

```java
int a = 0, b = 0;    
for (i = 0; i < N; i++) {
    a = a + 5;  
}
for (j = 0; j < M; j++) {
    b = b + 5;
}
//Time O(N+M), Space O(1)
```

### Nested for loop

```java
int a = 0, b = 0; 
for (i = 0; i < N; i++) { 
    for (j = 0; j < N; j++) { 
        a = a + j; 
    } 
} 
for (k = 0; k < N; k++) { 
    b = b + k; 
}
//Time O(N^2), Space O(1)
```

```java
int a = 0;
for (i = 0; i < N; i++) {
    for (j = N; j > i; j--) {
        a = a + i + j;
    }
}
//Time O(N^2), Space O(1)
```

{% hint style="success" %}
* **Outer Loop (`for (i = 0; i < N; i++)`)**:\
  The outer loop runs from `i = 0` to `i = N - 1`, which means it executes **N times**.
*   **Inner Loop (`for (j = N; j > i; j--)`)**:

    * For a given value of `i`, the inner loop runs from `j = N` to `j = i + 1`.
    * The number of iterations for the inner loop depends on the current value of `i`:
      * When `i = 0`, the inner loop runs `N` times.
      * When `i = 1`, the inner loop runs `N - 1` times.
      * When `i = 2`, the inner loop runs `N - 2` times.
      * ...
      * When `i = N - 1`, the inner loop runs `1` time.

    Thus, the total number of inner loop iterations is the sum of the first `N` natural numbers:

    Total Iterations=N+(N−1)+(N−2)+⋯+1=N\*(N+1)/2
{% endhint %}

```java
int count = 0;
for (int i = N; i > 0; i /= 2) {     // Outer loop
    for (int j = 0; j < i; j++) {    // Inner loop
        count += 1;
    }
}
//Time O(N), Space O(1)
```

{% hint style="success" %}
**Outer Loop**

The outer loop runs with the variable `i`, starting at N and halving its value in each iteration (i/=2).\
Thus, the value of `i` takes the following sequence:

N,N/2,N/4,N/8,…,1

The number of iterations in the outer loop is determined by how many times N can be halved before it becomes 1. This is equivalent to the number of times N can be divided by 2, which is:

Number of iterations=⌊log⁡2(N)⌋+1

So, the outer loop runs **O(log⁡N)** times.

**Inner Loop**

The inner loop runs from j=0j=0 to j\<ij\<i.\
For each iteration of the outer loop, the number of iterations of the inner loop is equal to the current value of `i`.

* When i=N, the inner loop runs N times.
* When i=N/2​, the inner loop runs N/2 times.
* When i=N/4​, the inner loop runs N/4​ times.
* ...
* When i=1, the inner loop runs 1 time.

This is a geometric series with the first term N and a common ratio of 1 /2 . The sum of this series is N\*( 1)/(1− 1/2) ​ i.e. 2N.
{% endhint %}



## While loop

### Simple while loop

```java
int a = 0, i = N;
while (i > 0) {
    a += i;
    i /= 2;
}
//Time O(log(N)), Space O(1)
```



