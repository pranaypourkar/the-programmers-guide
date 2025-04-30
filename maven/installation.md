# Installation

## About

Apache Maven is a build automation and project management tool primarily used for Java-based projects. This guide provides step-by-step instructions to install Maven on Windows and macOS systems.

## Prerequisites

Before installing Maven, ensure that the following prerequisites are met:

### Java Development Kit (JDK)

* Maven requires **Java JDK 8 or higher**.
* Ensure Java is installed and properly configured.

**To check if Java is installed**

Open a terminal or command prompt and run:

```bash
java -version
```

This should output the installed Java version.

**To check the JDK compiler**

```bash
javac -version
```

If not installed, download and install the JDK from:

* Oracle: [https://www.oracle.com/java/technologies/javase-downloads.html](https://www.oracle.com/java/technologies/javase-downloads.html)
* OpenJDK: [https://jdk.java.net/](https://jdk.java.net/)

#### JAVA\_HOME Environment Variable

Ensure the `JAVA_HOME` environment variable is set and points to our JDK installation directory.

## Downloading Apache Maven

1. Go to the official Maven download page: [https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)
2. Download the **binary zip archive** (for Windows) or **tar.gz archive** (for macOS/Linux):
   * Example: `apache-maven-3.9.6-bin.zip` or `apache-maven-3.9.6-bin.tar.gz`
3. Verify the archive’s checksum (optional but recommended) using the instructions provided on the download page.

## Installation on Windows

### Step 1: Extract the Archive

*   Extract the `.zip` file to a preferred location, such as:

    ```
    C:\Program Files\Apache\Maven
    ```

### Step 2: Set Environment Variables

Open System Properties > Environment Variables, and configure the following:

**Add `MAVEN_HOME`:**

* Variable Name: `MAVEN_HOME`
*   Variable Value: path to your Maven folder, e.g.:

    ```
    C:\Program Files\Apache\Maven\apache-maven-3.9.6
    ```

**Add Maven `bin` directory to `Path`:**

*   Edit the `Path` variable and add:

    ```
    %MAVEN_HOME%\bin
    ```

### Step 3: Verify Installation

Open a new Command Prompt and run:

```bash
mvn -version
```

We should see Maven version, Java version, and our operating system.

## Installation on macOS

### Option 1: Install via Homebrew (recommended)

If we have Homebrew installed:

```bash
brew install maven
```

This will automatically handle download, setup, and path configuration.

**To verify**

```bash
mvn -version
```

### Option 2: Manual Installation

**Step 1: Extract the Archive**

Download and extract the `tar.gz` archive:

```bash
tar -xvzf apache-maven-3.9.6-bin.tar.gz
sudo mv apache-maven-3.9.6 /opt/maven
```

**Step 2: Set Environment Variables**

Add the following to your `~/.bash_profile`, `~/.zshrc`, or `~/.bashrc` (depending on your shell):

```bash
export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$PATH
```

Apply the changes:

```bash
source ~/.bash_profile
# or
source ~/.zshrc
```

**Step 3: Verify Installation**

```bash
mvn -version
```
