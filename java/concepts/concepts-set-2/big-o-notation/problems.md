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

```java
int i, j, k = 0;
for (i = n / 2; i <= n; i++) {            // Outer loop
    for (j = 2; j <= n; j = j * 2) {      // Inner loop
        k = k + n / 2;                    // Body
    }
}
//Time O(Nlog(N)), Space O(1)
```

{% hint style="info" %}
**Outer Loop**

The outer loop runs with the variable `i`, starting at n/2 and going up to n.\
Thus, the number of iterations of the outer loop is:

Number of iterations of outer loop=n−n/2+1=n/2+1

This is approximately O(n) since the dominant term is n/2, which scales linearly with n.

**Inner Loop**

The inner loop runs with the variable `j`, starting at 2 and doubling its value in each iteration (j=j∗2).\
Thus, the values of `j` are: 2,4,8,16,…,n

The number of iterations in the inner loop is determined by how many times j can be doubled before it exceeds n. This is equivalent to the number of times n can be divided by 2, which is:

Number of iterations of inner loop=log⁡(n)

Thus, the inner loop runs **O(log⁡n)** times.

**Total Iterations**

To calculate the total number of iterations of the inner loop across all iterations of the outer loop:

* The outer loop runs O(n/2) ≈ O(n) times.
* For each iteration of the outer loop, the inner loop runs O(logn) times.

Thus, the total number of iterations is: O(n)⋅O(log⁡n)=O(nlog⁡n)
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



## Complex Problems

### GCD with Euclidean algorithm

This is Euclidean algorithm which repeatedly replaces the pair (n, m) with (m , n mod  m)  until m=0. The result is the greatest common divisor (GCD) of n and m .

```java
int gcd(int n, int m) {
    if (n % m == 0) return m;         // Base case
    if (n < m) swap(n, m);           // Ensure n >= m
    while (m > 0) {                  // Loop until m becomes 0
        n = n % m;                   // Compute remainder
        swap(n, m);                  // Swap n and m
    }
    return n;                        // Return the GCD
}
//Time O(log(N)), Space O(1)
```

{% hint style="success" %}
#### **Worst-Case Example**

The worst-case input for the Euclidean algorithm occurs when the two numbers are consecutive Fibonacci numbers, because the remainder reduction is minimal in each step. For example:

* For n=Fk+1​ and m=Fk​ (where Fk​ is the k-th Fibonacci number), the algorithm performs k steps.
* Since Fibonacci numbers grow exponentially (Fk≈ϕk, where ϕ is the golden ratio), the number of steps is proportional to logN.

Eg: 8 and 13.

(13 % 8) = 5 which is the previous fibonacci number of 8.

Same way : (8 % 5) = 3 , (5 % 3) = 2 , (3 % 2) = 1 , (2 % 1) = 0.
{% endhint %}

### For loops

```
Consider the following for loops:
  A) for(i = 0; i < n; i++)
  B) for(i = 0; i < n; i += 2)
  C) for(i = 1; i < n; i *= 2)
  D) for(i = n; i > -1; i /= 2)
If n is the size of input(positive), which function is the most efficient?
-> C
```

{% hint style="info" %}
#### **A) for (i = 0; i < n; i++)**

* **Loop Analysis**:
  * The loop starts at i=0 and increments by 1 (i++) until i\<n.
  * The number of iterations is directly proportional to nn.
* **Time Complexity**: O(n)

**B) for (i = 0; i < n; i += 2)**

* **Loop Analysis**:
  * The loop starts at i=0 and increments by 2 (i+=2) until i\<n.
  * Since the increment step is 2, the number of iterations will be approximately half the size of n. Number of iterations=⌈n/2⌉
* **Time Complexity**: O(n)

Although the number of iterations is halved compared to Case A, the time complexity remains O(n) because constants are ignored in Big-O notation.

#### _C) for (i = 1; i < n; i = 2)_

* **Loop Analysis**:
  * The loop starts at i=1 and multiplies by 2 (i∗=2) until i\<n.
  * The value of i follows the sequence: 1,2,4,8,… The loop runs while i\<n.
  * The number of iterations corresponds to the number of times ii can be doubled before it exceeds nn:Number of iterations=⌊log⁡2(n)⌋
* **Time Complexity**: O(log⁡n)

This is more efficient than both A and B because the growth rate is logarithmic, much smaller than linear.

#### **D) for (i = n; i > -1; i /= 2)**

* **Loop Analysis**:
  * The loop starts at i=n and divides i by 2 (i/=2) until i>−1.
  * The value of i follows the sequence: n,n/2,n/4,…n. The loop runs while i>−1. Loop will not end since i will stuck at 0.
{% endhint %}



