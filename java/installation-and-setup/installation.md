# Installation

## **Step-by-Step Java Installation**

### **1. Choosing the Java Distribution**

Java has various distributions; each serves specific purposes. Some popular ones include -

* **Oracle JDK**: Official distribution from Oracle. Free for personal use, but commercial use may require licensing.
* **OpenJDK**: Open-source and widely used for development and production.
* **Others**: Amazon Corretto, Azul Zulu, Liberica JDK, AdoptOpenJDK (now Eclipse Temurin).

### **2. Downloading Java**

* Visit the appropriate JDK provider’s website -
  * Oracle: [https://www.oracle.com/java/technologies/javase-downloads.html](https://www.oracle.com/java/technologies/javase-downloads.html)
  * OpenJDK: [https://jdk.java.net](https://jdk.java.net)
  * Other distributions as per preference.
* Download the appropriate version (e.g., JDK 8, JDK 11, JDK 17, or later).
  * LTS (Long-Term Support) versions (e.g., JDK 8, JDK 11, JDK 17) are preferred for production.
  * Latest versions for experimental or cutting-edge features.

### **3. Installation on Different Operating Systems**

#### **Windows**

1. Run the downloaded installer (`.exe`).
2. Follow the prompts in the installation wizard
   * Accept the license agreement.
   * Choose an installation directory or leave it as the default.
3. The installer will copy files and set up the Java Runtime Environment (JRE) alongside the JDK.
4. Set Environment Variables
   * Open _System Properties_ → _Environment Variables_.
   * Add or update the following:
     * **JAVA\_HOME**: Set to the JDK installation path (e.g., `C:\Program Files\Java\jdk-17`).
     * **PATH**: Add `%JAVA_HOME%\bin` to PATH to access `java` and `javac` commands from any terminal.
5. Verify installation
   * Open Command Prompt.
   * Run `java -version` and `javac -version`.

#### **macOS**

1.  Install via the `.dmg` package or use a package manager like **Homebrew**

    ```
    brew install openjdk
    ```
2. If using the downloaded `.dmg`

* Double-click the file and follow installation steps.
* The installer sets up JDK in `/Library/Java/JavaVirtualMachines/`.

3. Set Environment Variables

*   Edit `~/.zshrc` or `~/.bash_profile`:

    ```
    export JAVA_HOME=$(/usr/libexec/java_home -v 17)
    export PATH=$JAVA_HOME/bin:$PATH
    ```

4. Verify installation

* Run `java -version` and `javac -version` in the terminal.

## **Installing Multiple JDK Versions**

* Download multiple versions (e.g., JDK 8, JDK 11, JDK 17) side-by-side and update the java path as needed.
*   Use tools like **SDKMAN** to manage multiple JDKs

    ```
    curl -s "https://get.sdkman.io" | bash
    sdk install java 17-open
    sdk use java 17-open
    ```

## Java Program to check if Java is installed on the computer

```java
public static void main(String[] args) {
        // Display Java version
        System.out.println("\nJava Version: " + System.getProperty("java.version"));

        // Display Java runtime version
        System.out.println("Java Runtime Version: " + System.getProperty("java.runtime.version"));

        // Display Java home directory
        System.out.println("Java Home: " + System.getProperty("java.home"));

        // Display Java vendor name
        System.out.println("Java Vendor: " + System.getProperty("java.vendor"));

        // Display Java vendor URL
        System.out.println("Java Vendor URL: " + System.getProperty("java.vendor.url"));

        // Display Java class path
        System.out.println("Java Class Path: " + System.getProperty("java.class.path") + "\n");
    }
```

<figure><img src="../../.gitbook/assets/image (464).png" alt=""><figcaption></figcaption></figure>

## **Java Installation Best Practices**

* Use LTS versions for stability in production.
* Regularly update to the latest security patches.
* Install only the necessary tools (e.g., avoid JDK if only JRE is required).
* Automate installation in CI/CD pipelines using scripts or tools like Docker

{% hint style="info" %}
- **Java Development Kit (JDK)**:
  * Includes compiler (`javac`), debugger, and libraries.
- **Java Runtime Environment (JRE)**:
  * Required for running Java applications.
- **Environment Variables**:
  * **JAVA\_HOME**: Points to the JDK root directory.
  * **PATH**: Enables access to Java commands globally.
{% endhint %}
