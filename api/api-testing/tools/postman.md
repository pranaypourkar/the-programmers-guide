# Postman

## About

**Postman** is one of the most widely used tools for working with APIs. It provides a powerful, user-friendly interface to send requests, inspect responses, and automate testing. Postman supports both REST and SOAP APIs and is equally useful for developers, testers, and DevOps engineers.

<figure><img src="../../../.gitbook/assets/postman-1.png" alt=""><figcaption></figcaption></figure>

## What is Postman ?

Postman is an API platform that allows us to develop, test, document, and monitor APIs in one place. It started as a simple Chrome extension but has grown into a full-fledged desktop and web application used across the software industry.

We can manually send HTTP requests (like GET, POST, PUT, DELETE), view responses, and organize our API workflows into collections. It also supports automation, collaboration, and mocking.

## Installing Postman

Postman is available as a **desktop application** and also has a **web version**. For full functionality (especially testing with local servers), the desktop app is recommended.

### 1. **Download Postman**

Visit the official Postman website:

[**https://www.postman.com/downloads/**](https://www.postman.com/downloads/)

Choose the version suitable for our operating system:

* Windows (x64, x86)
* macOS (Intel or Apple Silicon)
* Linux (Ubuntu, Debian, Fedora, etc.)

### 2. **Install on Windows**

* Download the `.exe` installer.
* Double-click to run it.
* Follow the on-screen installation steps.
* Once installed, launch Postman and sign in or create a free account.

### 3. **Install on macOS**

* Download the `.zip` file for macOS.
* Unzip and drag the Postman app to the Applications folder.
* Launch it from Applications and sign in.

### 4. **Install on Linux (Ubuntu/Debian)**

Using Snap (recommended):

```bash
sudo snap install postman
```

Or download the `.tar.gz` from the website and extract it manually if Snap is not available.

### 5. **Using Postman on the Web**

If we prefer not to install anything:

* Go to https://web.postman.co
* Sign in with our account.
* Start using Postman directly from the browser.

Note: Some features like sending requests to `localhost` may not work on the web version due to browser restrictions.

### 6. **Create an Account (Optional but Recommended)**

Creating a free Postman account enables features like:

* Syncing collections and environments
* Collaboration with teams
* Access to Postman Cloud features

## Features

### **1. Request Building**

We can build and send HTTP requests easily by choosing the method (GET, POST, etc.), adding headers, query parameters, path variables, request bodies (JSON, form data, etc.), and then hitting "Send."

### **2. Collections**

Collections are groups of API requests saved in an organized way. We can share these with our team or export them to be used in automation tools like Newman.

### **3. Environment Variables**

We can define environments like `dev`, `test`, `prod` with variables such as base URLs, tokens, etc. This makes it easy to switch between environments without changing requests manually.

### **4. Pre-request Scripts and Tests**

Postman supports writing scripts using JavaScript. These can run:

* **Before** the request is sent (e.g., to set a token dynamically)
* **After** the response is received (e.g., to validate status code or response content)

### **5. Mock Servers**

Mock servers allow we to simulate an API endpoint that returns a fixed response. This is useful during development if the backend isn’t ready yet.

### **6. Monitors**

We can schedule collections to run periodically using monitors. It helps we verify that our APIs are working as expected over time.

### **7. Documentation**

Postman can auto-generate API documentation from our collections, which can then be published and shared.
