# Array Algorithms

## 1. Rotate Array

Rotate the array A by B positions

```java
ArrayList<Integer> result = new ArrayList<Integer>();
  for (int i = 0; i < A.size(); i++) {
  result.add( A.get( (i + B) % A.size() ) );
}
```

