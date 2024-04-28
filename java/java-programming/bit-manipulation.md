# Bit Manipulation

## Example

### Using Bit Manipulation for Addition of Two Numbers in Java

```
// Java Program to implement
// Bit Manipulation to Find 
// the Sum of two Numbers
import java.io.*;

// Driver Class
class GFG {
	// function to find sum
	public static int sum(int num1, int num2)
	{
		if (num2 == 0) return num1;
		return sum(num1 ^ num2, (num1 & num2) << 1);
	}
	
	// main function
	public static void main(String[] args)
	{
		GFG ob = new GFG();
		int res = ob.sum(28, 49);
		System.out.println(res);
	}
}

```



