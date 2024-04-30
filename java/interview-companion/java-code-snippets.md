# Java Code Snippets

1. Commands and sample output

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
</code></pre></td><td>For eg str = ['1','2','3'] then result "123" string</td><td>Concatenate array values to a String</td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr></tbody></table>



