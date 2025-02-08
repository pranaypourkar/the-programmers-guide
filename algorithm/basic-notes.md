# Basic Notes

## Excel Sheet

Excel organizes data into a **grid structure** consisting of **columns** and **rows**. Each cell is identified by a unique **address** derived from the column name and row number.

#### **1. Column Naming**

Columns in Excel are identified using **letters**:

* Columns are labeled from **A to Z** initially.
* After **Z**, the column names continue with two-letter combinations:
  * AA, AB, AC, ..., AZ, BA, BB, ..., BZ, CA, ..., and so on.
* This continues up to **XFD**, which is the last column in modern Excel versions (totaling 16,384 columns).

**Examples:**

* First column: **A**
* 26th column: **Z**
* 27th column: **AA**
* 702nd column: **ZZ**
* 703rd column: **AAA**
* Last column: **XFD**

#### **2. Row Naming**

Rows in Excel are identified using **numbers**:

* Rows are labeled starting from **1** and increment by 1 for each row.
* Modern Excel versions support up to **1,048,576 rows**.

**Examples:**

* First row: **1**
* 10th row: **10**
* 1,048,576th row: **1,048,576**

#### **3. Cell Addressing**

Each cell is uniquely identified by combining the **column letter** and the **row number**. For example:

* The first cell: **A1** (Column A, Row 1)
* A cell in the 5th column and 10th row: **E10**
* A cell in the 703rd column and 1st row: **AAA1**

## ASCII Character

**ASCII** (American Standard Code for Information Interchange) is a character encoding standard used to represent text in computers, communications equipment, and other devices. It uses numeric codes to map characters and symbols to their binary representations.

### **1. Key Features of ASCII**

1. **Standard ASCII**:
   * Represents **128 characters** (0 to 127).
   * Includes:
     * **Control characters** (0 to 31 and 127) for non-printable instructions like line breaks.
     * **Printable characters** (32 to 126) for symbols, digits, uppercase and lowercase letters.
2. **Extended ASCII**:
   * Represents **256 characters** (0 to 255) by extending the 7-bit ASCII with an 8th bit.
   * Adds additional symbols, graphical characters, and characters for non-English languages.

### **2. ASCII Character Groups**

#### **Control Characters (0–31, 127):**

Non-printable commands for controlling devices.

* Examples:
  * `0`: Null (\0)
  * `9`: Horizontal Tab (\t)
  * `10`: Line Feed (\n)
  * `13`: Carriage Return (\r)
  * `27`: Escape (ESC)

#### **Printable Characters (32–126):**

Human-readable symbols.

* **32–47**: Special symbols (e.g., `space`, `!`, `"`, `#`, `$`, `%`).
* **48–57**: Digits (0–9).
* **58–64**: More symbols (e.g., `:`, `;`, `<`, `=`, `>`).
* **65–90**: Uppercase letters (A–Z).
* **91–96**: Special symbols (e.g., `[`, `\`, `]`, `^`, `_`).
* **97–122**: Lowercase letters (a–z).
* **123–126**: Special symbols (e.g., `{`, `|`, `}`, `~`).

#### **Extended ASCII (128–255):**

Used in systems that support 8-bit encoding. Includes:

* Accented characters (e.g., `é`, `ñ`).
* Box-drawing symbols.
* Mathematical symbols.

## Power of 2

<table data-full-width="true"><thead><tr><th width="127">Power of 2</th><th>Exact Value</th><th width="212">Approximate Value</th><th>Equivalent in Storage (Bytes → KB, MB, GB, etc.)</th></tr></thead><tbody><tr><td>2⁰</td><td>1</td><td>1</td><td>1 Byte</td></tr><tr><td>2¹</td><td>2</td><td>2</td><td>2 Bytes</td></tr><tr><td>2²</td><td>4</td><td>4</td><td>4 Bytes (e.g., an <code>int</code> in Java)</td></tr><tr><td>2³</td><td>8</td><td>8</td><td>8 Bytes (e.g., a <code>long</code> in Java)</td></tr><tr><td>2⁴</td><td>16</td><td>16</td><td>16 Bytes</td></tr><tr><td>2⁵</td><td>32</td><td>32</td><td>32 Bytes</td></tr><tr><td>2⁶</td><td>64</td><td>64</td><td>64 Bytes</td></tr><tr><td>2⁷</td><td>128</td><td>128</td><td>128 Bytes</td></tr><tr><td>2⁸</td><td>256</td><td>256</td><td>256 Bytes (1 KB / 4 pages of text)</td></tr><tr><td>2⁹</td><td>512</td><td>512</td><td>512 Bytes</td></tr><tr><td>2¹⁰</td><td>1,024</td><td>~1K</td><td>1 KB</td></tr><tr><td>2²⁰</td><td>1,048,576</td><td>~1M (Million)</td><td>1 MB</td></tr><tr><td>2³⁰</td><td>1,073,741,824</td><td>~1B (Billion)</td><td>1 GB</td></tr><tr><td>2⁴⁰</td><td>1,099,511,627,776</td><td>~1T (Trillion)</td><td>1 TB</td></tr><tr><td>2⁵⁰</td><td>1,125,899,906,842,624</td><td>~1P (Quadrillion)</td><td>1 PB</td></tr><tr><td>2⁶⁰</td><td>1,152,921,504,606,846,976</td><td>~1E (Exabyte)</td><td>1 EB</td></tr></tbody></table>

## Java Datatype and Memory Size Table

<table data-full-width="true"><thead><tr><th width="131">Data Type</th><th width="122">Size (Bytes)</th><th>Size (Bits)</th><th width="181">Minimum Value</th><th width="219">Maximum Value</th><th>Default Value</th></tr></thead><tbody><tr><td><code>boolean</code></td><td>1 (JVM dependent)</td><td>8 (for alignment)</td><td><code>false</code></td><td><code>true</code></td><td><code>false</code></td></tr><tr><td><code>byte</code></td><td>1</td><td>8</td><td>-128</td><td>127</td><td>0</td></tr><tr><td><code>short</code></td><td>2</td><td>16</td><td>-32,768</td><td>32,767</td><td>0</td></tr><tr><td><code>char</code></td><td>2</td><td>16</td><td>0 (<code>\u0000</code>)</td><td>65,535 (<code>\uFFFF</code>)</td><td><code>\u0000</code></td></tr><tr><td><code>int</code></td><td>4</td><td>32</td><td>-2³¹ (-2,147,483,648)</td><td>2³¹-1 (2,147,483,647)</td><td>0</td></tr><tr><td><code>long</code></td><td>8</td><td>64</td><td>-2⁶³ (-9,223,372,036,854,775,808)</td><td>2⁶³-1 (9,223,372,036,854,775,807)</td><td>0L</td></tr><tr><td><code>float</code></td><td>4</td><td>32</td><td>~ ±3.4 × 10⁻³⁸</td><td>~ ±3.4 × 10³⁸</td><td>0.0f</td></tr><tr><td><code>double</code></td><td>8</td><td>64</td><td>~ ±1.7 × 10⁻³⁰⁸</td><td>~ ±1.7 × 10³⁰⁸</td><td>0.0d</td></tr></tbody></table>



