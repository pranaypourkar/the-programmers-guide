# Rules for Polymorphism

## **About**

Polymorphism in Java is governed by a set of rules that vary depending on whether it is **compile-time (method overloading)** or **runtime (method overriding)**. Below is a consolidated set of rules for both types.

## **Rules for Compile-Time Polymorphism (Method Overloading)**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th width="263.703125"></th><th width="84.51171875"></th><th></th></tr></thead><tbody><tr><td><strong>Rule</strong></td><td><strong>Example</strong></td><td><strong>Valid / Invalid</strong></td><td><strong>Reason</strong></td></tr><tr><td><strong>Same method name</strong></td><td><code>void print() {}</code><br><code>void print(String msg) {}</code></td><td>Valid</td><td>Overloaded methods must share the same name.</td></tr><tr><td><strong>Different parameter list</strong></td><td><code>void sum(int a, int b) {}</code><br><code>void sum(double a, double b) {}</code></td><td>Valid</td><td>Changing type/number/order of parameters allows overloading.</td></tr><tr><td><strong>Return type alone not enough</strong></td><td><code>int getData() {}</code><br><code>String getData() {}</code></td><td>Invalid</td><td>Compiler cannot differentiate only by return type.</td></tr><tr><td><strong>Different access modifiers allowed</strong></td><td><code>public void show(int x) {}</code><br><code>private void show(String y) {}</code></td><td>Valid</td><td>Access modifiers do not affect method signature.</td></tr><tr><td><strong>Different exceptions allowed</strong></td><td><code>void read() throws IOException {}</code><br><code>void read(String s) throws SQLException {}</code></td><td>Valid</td><td>Exception type does not affect overloading.</td></tr><tr><td><strong>Inheritance overloading</strong></td><td><code>class Parent { void show(int x) {} }</code><br><code>class Child extends Parent { void show(double x) {} }</code></td><td>Valid</td><td>Overloading works across parent-child classes if parameters differ.</td></tr><tr><td><strong>Varargs overloading</strong></td><td><code>void display(String... items) {}</code><br><code>void display(String item) {}</code></td><td>Valid</td><td>Varargs can overload fixed parameters, but must be last.</td></tr><tr><td><strong>Static / final methods can be overloaded</strong></td><td><code>static void log(int x) {}</code><br><code>static void log(String y) {}</code></td><td>Valid</td><td>Static/final methods are still matched at compile time.</td></tr><tr><td><strong>Compile-time resolution</strong></td><td><p></p><pre><code>public class Problem1 {

    static void test(int x) {
        System.out.println("x");
    }

    static void test(long y) {
        System.out.println("y");
    }

    public static void main(String[] args) {
        test(5); //x
        test(5L); //y
    }

}
</code></pre></td><td>Valid</td><td>Compiler picks best match based on argument type.</td></tr><tr><td><strong>Ambiguity causes compile error</strong></td><td><p></p><pre><code>public static void main(String[] args) {
    doSomething(5, 5); // Ambiguous method call. Both error
}

static void doSomething(int x, long y) {
    System.out.println("x");
}

static void doSomething(long x, int y) {
    System.out.println("y");
}
</code></pre></td><td>Invalid</td><td>Compiler cannot decide; both match equally well.</td></tr></tbody></table>

## **Rules for Runtime Polymorphism (Method Overriding)**

<table data-header-hidden data-full-width="true"><thead><tr><th></th><th></th><th></th><th></th></tr></thead><tbody><tr><td><strong>Rule</strong></td><td><strong>Example</strong></td><td><strong>Valid / Invalid</strong></td><td><strong>Reason</strong></td></tr><tr><td><strong>Must be in inheritance hierarchy</strong></td><td><code>class Parent { void show() {} }</code><br><code>class Child extends Parent { void show() {} }</code></td><td>Valid</td><td>Overriding requires a parent-child relationship.</td></tr><tr><td><strong>Same method signature</strong></td><td><code>void display(int x)</code> in Parent and Child</td><td>Valid</td><td>Method name, parameters, and order must match exactly.</td></tr><tr><td><strong>Return type must be same or covariant</strong></td><td>Parent: <code>Object getData()</code><br>Child: <code>String getData()</code></td><td>Valid</td><td>Covariant return types allowed (narrower type in subclass).</td></tr><tr><td><strong>Access level cannot be more restrictive</strong></td><td>Parent: <code>public void show()</code><br>Child: <code>protected void show()</code></td><td>Invalid</td><td>Cannot reduce visibility in overriding method.</td></tr><tr><td><strong>Can increase access level</strong></td><td>Parent: <code>protected void show()</code><br>Child: <code>public void show()</code></td><td>Valid</td><td>Visibility can be widened in overriding method.</td></tr><tr><td><strong>Cannot override static methods</strong></td><td>Parent: <code>static void print()</code><br>Child: <code>static void print()</code></td><td>Invalid (this is hiding, not overriding)</td><td>Static methods belong to the class, not object.</td></tr><tr><td><strong>Cannot override final methods</strong></td><td>Parent: <code>final void show()</code></td><td>Invalid</td><td>Final methods cannot be changed in subclass.</td></tr><tr><td><strong>Cannot override private methods</strong></td><td>Parent: <code>private void secret()</code></td><td>Invalid</td><td>Private methods are not inherited.</td></tr><tr><td><strong>Overridden method can throw fewer/narrower checked exceptions</strong></td><td>Parent: <code>void read() throws IOException</code><br>Child: <code>void read()</code></td><td>Valid</td><td>Checked exceptions can be reduced or removed.</td></tr><tr><td><strong>Dynamic method dispatch occurs at runtime</strong></td><td><code>Parent p = new Child(); p.show();</code></td><td>Valid</td><td>JVM decides which method to call based on object type, not reference type.</td></tr></tbody></table>
