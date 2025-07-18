# Problems - Set 1

## Easy



## Medium

### Pond Sizes

We are given a **2D grid of integers** that represents a plot of land. Each cell in the grid has a number:

* If the number is `0`, it means **water**.
* Any number greater than `0` means **land**, with the value representing the height above sea level.

**Find all the ponds** in the matrix and return their **sizes**.

A **pond** is a group of water cells (`0`s) that are **connected** to each other. Two water cells are considered **connected** if they touch **vertically**, **horizontally**, or **diagonally**.

For each such group (pond), we want to know how many `0`s are in that group — that's the **size** of the pond.

A 2D array like this:

```
0 2 1 0
0 1 0 1
1 1 0 1
0 1 0 1
```

A list of integers representing the sizes of the ponds.\
For the input above, the expected result is:

```
[2, 1, 4]
```

Let's mark all water (`0`) cells and group them if they are connected:

There are **three ponds**:

1. **Pond A**: top-left corner `0`s → size 2
2. **Pond B**: single `0` at top-right corner → size 1
3. **Pond C**: group of 4 `0`s in the center-bottom → size 4

We can solve the **Pond Sizes** problem using **Depth-First Search (DFS)** or **Breadth-First Search (BFS)** to find all connected `0`s in the matrix, including diagonally. Each group of connected water cells is considered a pond, and we compute the size (number of cells) of each.

```java
import java.util.*;

public class PondSizes {

    public static List<Integer> computePondSizes(int[][] land) {
        List<Integer> pondSizes = new ArrayList<>();
        int rows = land.length;
        int cols = land[0].length;
        boolean[][] visited = new boolean[rows][cols];

        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (land[r][c] == 0 && !visited[r][c]) {
                    int size = dfs(land, visited, r, c);
                    pondSizes.add(size);
                }
            }
        }

        return pondSizes;
    }

    private static int dfs(int[][] land, boolean[][] visited, int r, int c) {
        if (r < 0 || c < 0 || r >= land.length || c >= land[0].length) return 0;
        if (land[r][c] != 0 || visited[r][c]) return 0;

        visited[r][c] = true;
        int size = 1;

        // 8 directions: vertical, horizontal, diagonal
        int[] dx = {-1, -1, -1, 0, 0, 1, 1, 1};
        int[] dy = {-1, 0, 1, -1, 1, -1, 0, 1};

        for (int d = 0; d < 8; d++) {
            size += dfs(land, visited, r + dx[d], c + dy[d]);
        }

        return size;
    }

    public static void main(String[] args) {
        int[][] land = {
            {0, 2, 1, 0},
            {0, 1, 0, 1},
            {1, 1, 0, 1},
            {0, 1, 0, 1}
        };

        List<Integer> result = computePondSizes(land);
        Collections.sort(result); // optional, for ordered output
        System.out.println("Pond sizes: " + result);  // Expected: [1, 2, 4]
    }
}
```



