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

