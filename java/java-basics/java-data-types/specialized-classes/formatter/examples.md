# Examples

## 1. **Generating Log Messages**

In logging systems, it’s common to format log messages to include timestamps, log levels, and specific message details. The `Formatter` class helps maintain a consistent format.

```java
Formatter formatter = new Formatter();
String logMessage = formatter.format("%1$tF %1$tT - [%2$s] - %3$s", new java.util.Date(), "INFO", "Application started successfully").toString();
System.out.println(logMessage); // 2024-12-27 14:35:20 - [INFO] - Application started successfully
```

## 2. **Creating a Table of Data (Report Generation)**

Formatter is useful in generating tabular data, such as a report for employees, students, or any structured data where alignment is crucial

```java
Formatter formatter = new Formatter();
formatter.format("| %-20s | %-10s | %-10s | %-15s |\n", "Employee", "Department", "Salary", "Joining Date");
formatter.format("| %-20s | %-10s | %-10.2f | %-15s |\n", "Alice", "HR", 75000.50, "2020-01-15");
formatter.format("| %-20s | %-10s | %-10.2f | %-15s |\n", "Bob", "Engineering", 95000.75, "2018-05-20");
formatter.format("| %-20s | %-10s | %-10.2f | %-15s |\n", "Charlie", "Marketing", 80000.00, "2019-11-30");

System.out.println(formatter.toString());
```

Output

```
| Employee             | Department | Salary    | Joining Date    |
| Alice                | HR         | 75000.50  | 2020-01-15      |
| Bob                  | Engineering| 95000.75  | 2018-05-20      |
| Charlie              | Marketing  | 80000.00  | 2019-11-30      |
```

## 3. **Currency and Number Formatting**

Formatter can be used to format financial data according to the required conventions, including currency formatting.

```java
Locale locale = Locale.US;
Formatter formatter = new Formatter(locale);
formatter.format("Price: %.2f", 12345.6789);
System.out.println(formatter.toString());  // $12,345.68

locale = Locale.FRANCE;
formatter = new Formatter(locale);
formatter.format("Price: %.2f", 12345.6789);
System.out.println(formatter.toString());  // 12 345,68 €
```

## **4. Generating a Custom File Output (Exporting Data)**

Formatter can be used to create formatted text files, for instance, when exporting data to CSV or any structured text file. In this case, `Formatter` is used to format and write data to a CSV file.

```java
import java.io.File;
import java.io.IOException;
import java.util.Formatter;

public class CSVExport {
    public static void main(String[] args) throws IOException {
        Formatter formatter = new Formatter(new File("employee_data.csv"));
        formatter.format("Employee Name,Department,Salary,Joining Date\n");
        formatter.format("Alice,HR,75000.50,2020-01-15\n");
        formatter.format("Bob,Engineering,95000.75,2018-05-20\n");
        formatter.format("Charlie,Marketing,80000.00,2019-11-30\n");
        formatter.close();
        System.out.println("File exported successfully!");
    }
}
```

**Output (file `employee_data.csv`):**

```javascript
Employee Name,Department,Salary,Joining Date
Alice,HR,75000.50,2020-01-15
Bob,Engineering,95000.75,2018-05-20
Charlie,Marketing,80000.00,2019-11-30
```

## **5. Locale-specific Date Formatting**

Formatter is useful in generating date/time strings in different formats based on the locale. Here, `Formatter` is used to format dates based on the locale.

```java
import java.util.Formatter;
import java.util.Locale;

public class DateFormatting {
    public static void main(String[] args) {
        Formatter formatter = new Formatter();
        formatter.format("Today's date in US: %1$tm/%1$td/%1$tY", new java.util.Date());
        System.out.println(formatter.toString());  // Today's date in US: 12/27/2024
        
        Locale frenchLocale = Locale.FRANCE;
        formatter = new Formatter(frenchLocale);
        formatter.format("Today's date in France: %1$td/%1$tm/%1$tY", new java.util.Date());
        System.out.println(formatter.toString());  // Today's date in France: 27/12/2024
    }
}
```

## 6. **File Content Formatting for Reporting**

In a reporting system, if we need to format large amounts of data to generate readable reports, `Formatter` can be used. In this example, `Formatter` is used to generate a formatted sales report with headers and data.

```java
import java.util.Formatter;

public class ReportFormatter {
    public static void main(String[] args) {
        Formatter formatter = new Formatter();
        String title = "Monthly Sales Report";
        String header = "| %-15s | %-10s | %-15s | %-15s |\n";
        String data = "| %-15s | %-10d | %-15.2f | %-15s |\n";
        
        // Header
        formatter.format(header, "Product", "Quantity", "Unit Price", "Total Sales");
        
        // Data
        formatter.format(data, "Product A", 100, 15.75, "$1,575.00");
        formatter.format(data, "Product B", 200, 25.00, "$5,000.00");
        
        System.out.println(title);
        System.out.println(formatter.toString());
    }
}
```

```mathematica
Monthly Sales Report
| Product         | Quantity  | Unit Price       | Total Sales      |
| Product A       | 100       | 15.75            | $1,575.00        |
| Product B       | 200       | 25.00            | $5,000.00        |
```

## 7. **Formating Time and Duration**

Formatter can be used to format elapsed time or duration for display purposes, e.g., when displaying download or processing times. In this case, `Formatter` is used to format the duration in a standard `hh:mm:ss` format.

```java
import java.util.Formatter;

public class DurationFormatter {
    public static void main(String[] args) {
        long seconds = 3661; // 1 hour, 1 minute, and 1 second
        Formatter formatter = new Formatter();
        formatter.format("Elapsed Time: %02d:%02d:%02d", 
                         (seconds / 3600), // hours
                         (seconds % 3600) / 60, // minutes
                         seconds % 60); // seconds
        System.out.println(formatter.toString()); //Elapsed Time: 01:01:01
    }
}
```
