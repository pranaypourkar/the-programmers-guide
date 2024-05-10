# Java Code Snippets

<table data-full-width="true"><thead><tr><th>Code</th><th width="202">Output</th><th>Comment</th></tr></thead><tbody><tr><td><pre class="language-java"><code class="lang-java">System.out.print("Amigo");
System.out.println("Is The");
System.out.print("Best");
</code></pre></td><td>AmigoIs The<br>Best</td><td><code>println</code> doesn't start printing text from a new line. It prints text on the current line, but makes it so the next text will be printed on a new line.</td></tr><tr><td>int a, b, c;</td><td></td><td><code>int</code> variables named a, b, c are created. These variables can store integers.</td></tr><tr><td><pre class="language-java"><code class="lang-java">int a = 1 + 'b'; //99
String str = "sss" + a; //sss99 
</code></pre></td><td></td><td>When you add strings and numbers, the result is always a string. We can add character to integer.</td></tr><tr><td><pre class="language-java"><code class="lang-java">String str = "abc"
StringBuilder(str).reverse().toString()
</code></pre></td><td>cba</td><td>Reverse a string using StringBuilder</td></tr><tr><td><pre class="language-java"><code class="lang-java">String str = Arrays.stream(result)
        .mapToObj(String::valueOf)
        .collect(Collectors.joining())
</code></pre></td><td>For eg str = ['1','2','3'] then result "123" string</td><td>Concatenate array values to a String</td></tr><tr><td><p>Difference between </p><p><code>int[] arr = new int[]{2,4,6,7,9};</code> </p><p>and </p><p><code>int[] arr = {2,4,6,7,9};</code></p></td><td></td><td><p><strong><code>int[] arr = new int[]{2,4,6,7,9};</code></strong></p><p>This approach combines the array declaration (<code>int[] arr</code>) with initialization using a new keyword (<code>new</code>). It explicitly allocates memory for the array of the specified size (5 elements in this case) and then initializes the elements with the provided values within curly braces <code>{}</code>.</p><p></p><p><strong><code>int[] arr = {2,4,6,7,9};</code></strong></p><p>This is a shorthand notation for array initialization. Java allows directly initializing the array with values within curly braces <code>{}</code> during declaration. Internally, Java still creates an array and assigns the provided values to its elements.</p><p><strong>Essentially, both methods achieve the same result</strong></p></td></tr><tr><td>Increment Operator<br><code>++i</code> and <code>i++</code></td><td></td><td><p><strong><code>++i</code> (Pre-increment):</strong></p><ul><li>The variable is incremented by 1 first.</li><li>The incremented value is returned and used in the expression.</li></ul><p><strong><code>i++</code> (Post-increment):</strong></p><ul><li>The current value of the variable is used in the expression first.</li><li>Then, the variable is incremented by 1.</li></ul></td></tr><tr><td><p>Return sub-array<br></p><pre><code>Arrays.copyOfRange(arr, start, end);
</code></pre></td><td></td><td>If we want to return a subarray of an <code>int[]</code> array in Java, we can use the <code>Arrays.copyOfRange()</code> method. This method allows you to create a new array that is a copy of a specified range of elements from the original array.</td></tr><tr><td><p></p><pre class="language-java"><code class="lang-java">int[] arr = { 1, 2, 1, 3, 5, 1 };
System.out.println(Arrays.toString(arr));
List&#x3C;Integer> arrList = IntStream.of(arr)
        .boxed()
        .collect(Collectors.toList());
</code></pre></td><td></td><td>To convert int array to ArrayList</td></tr><tr><td><p></p><pre class="language-java"><code class="lang-java">int[] result = arrList.stream()
        .mapToInt(Integer::intValue)
        .filter(element -> element != key)
        .toArray();
</code></pre></td><td></td><td>Convert ArrayList back to int array</td></tr><tr><td><pre class="language-java"><code class="lang-java">for (i = 0;i&#x3C;10;i++) {
    System.out.print(i);
}
System.out.println();
for (i=0;i&#x3C;10;++i) {
    System.out.print(i);
}
</code></pre></td><td>0123456789 0123456789</td><td>Both loops will print the same sequence of numbers because the difference between <code>++i</code> and <code>i++</code> only matters when the incremented value of <code>i</code> is being used within the same expression.</td></tr><tr><td><pre class="language-java"><code class="lang-java">int i;
System.out.print(i);
</code></pre></td><td>Compile Error</td><td></td></tr><tr><td><pre class="language-java"><code class="lang-java">System.out.println(s1 = "aaa"); // aaa
System.out.println(i = 10); // 10
</code></pre></td><td></td><td>Assignmnet operator while printing is valid</td></tr><tr><td><pre class="language-java"><code class="lang-java">int[] arr = new int[10];
System.out.println(arr);
</code></pre></td><td><code>[I@hashcode</code> (the actual hashcode will vary). This is not the actual content of the array, but a memory address and a hashcode representing the array object itself.</td><td><p>An array in Java is an object. It doesn't have a built-in way to directly print its contents using <code>System.out.println(arr)</code>. When you try to print the array itself, Java prints the object representation, which includes:<code>[I</code>: This indicates the array's type. <code>[I</code> signifies an array of integers (<code>int</code>).</p><p><code>@</code>: This symbol separates the type information from the hashcode.</p><p><code>hashcode</code>: This is a unique identifier generated for the array object itself. It's used for internal memory management purposes.</p></td></tr><tr><td><pre class="language-java"><code class="lang-java">public static void main(String[] args) {
    int[] arr = new int[10];
    System.out.println(arr[9]);
}
</code></pre></td><td>0</td><td>Array elements are initialized with default 0 value.</td></tr><tr><td><pre class="language-java"><code class="lang-java">public class Application {
    static ArithmeticException e;
    public static void main(String[] args) {
        throw e;
    }
}
</code></pre></td><td>NullPointer Exception</td><td></td></tr><tr><td><pre class="language-javascript"><code class="lang-javascript">public class Application {
    static ArithmeticException e = new ArithmeticException();
    public static void main(String[] args) {
        throw e;
    }
}
</code></pre></td><td>Arithmetic Excpetion</td><td></td></tr><tr><td><pre class="language-java"><code class="lang-java">int[] result = {1,2,3};
List&#x3C;Integer> arrList = IntStream.of(arr)
        .boxed()
        .collect(Collectors.toList());

</code></pre></td><td></td><td>Convert int[] to List&#x3C;Integer></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr></tbody></table>



