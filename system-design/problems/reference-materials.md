# Reference Materials

## Java Data Type Size Chart

### **1. Primitive Data Types**

<table data-full-width="true"><thead><tr><th width="108.625">Data Type</th><th width="95.859375">Size (bits)</th><th width="104.8359375">Size (bytes)</th><th width="109.96484375">Default Value</th><th>Range</th><th>Notes</th></tr></thead><tbody><tr><td><code>byte</code></td><td>8</td><td>1</td><td><code>0</code></td><td>-128 to 127</td><td>Smallest integer type</td></tr><tr><td><code>short</code></td><td>16</td><td>2</td><td><code>0</code></td><td>-32,768 to 32,767</td><td>Compact integer</td></tr><tr><td><code>int</code></td><td>32</td><td>4</td><td><code>0</code></td><td>-2^31 to 2^31-1 (~±2.14B)</td><td>Common for integers</td></tr><tr><td><code>long</code></td><td>64</td><td>8</td><td><code>0L</code></td><td>-2^63 to 2^63-1</td><td>Use <code>L</code> suffix</td></tr><tr><td><code>float</code></td><td>32</td><td>4</td><td><code>0.0f</code></td><td>±3.4E+38 (~7 digit precision)</td><td>Use <code>f</code> suffix</td></tr><tr><td><code>double</code></td><td>64</td><td>8</td><td><code>0.0d</code></td><td>±1.7E+308 (~15 digit precision)</td><td>Default for decimals</td></tr><tr><td><code>char</code></td><td>16</td><td>2</td><td><code>\u0000</code></td><td>0 to 65,535</td><td>Represents Unicode characters</td></tr><tr><td><code>boolean</code></td><td>1 (JVM dependent)</td><td>JVM-defined (1 byte min)</td><td><code>false</code></td><td><code>true</code> or <code>false</code></td><td>Actual size varies (not directly defined in spec)</td></tr></tbody></table>

> JVM may pad primitives and objects for alignment — actual memory usage may exceed declared size.

### **2. Reference Types (Object Overhead)**

<table data-full-width="true"><thead><tr><th width="166.375">Component</th><th width="302.04296875">64-bit JVM (compressed oops)</th><th>Notes</th></tr></thead><tbody><tr><td>Object header</td><td>12 bytes</td><td>Includes mark word &#x26; class pointer</td></tr><tr><td>Object reference</td><td>4 bytes (compressed), 8 bytes (uncompressed)</td><td>Pointers to other objects</td></tr><tr><td>Array header</td><td>16 bytes (object header + length)</td><td>All arrays are objects</td></tr><tr><td>Alignment padding</td><td>Align to 8-byte boundary</td><td>JVM aligns for performance</td></tr></tbody></table>

### **3. Common Object Sizes (Estimated)**

<table><thead><tr><th width="182.1640625">Object Type</th><th width="164.41796875">Approx Size (bytes)</th><th>Comments</th></tr></thead><tbody><tr><td><code>Integer</code></td><td>~16 bytes</td><td>Object wrapping a primitive <code>int</code></td></tr><tr><td><code>Long</code></td><td>~24 bytes</td><td>Larger due to 64-bit value</td></tr><tr><td><code>String</code> (empty)</td><td>~40 bytes</td><td>Includes char array reference</td></tr><tr><td><code>UUID</code></td><td>~32 bytes</td><td>2 <code>long</code> values internally</td></tr><tr><td><code>ArrayList</code> (empty)</td><td>~24 bytes</td><td>Plus internal array (default size 10)</td></tr></tbody></table>

## Tips for Memory-Efficient Code

* Prefer primitives (`int`, `long`) over wrappers (`Integer`, `Long`) in large collections.
* Use `record` instead of class for data holders (Java 14+).
* Use `final` where possible to help the JVM with optimization.
* Avoid deep object graphs in caches — flatten where feasible.
* Use off-heap caching (e.g., Redis, Ehcache) for large datasets.
