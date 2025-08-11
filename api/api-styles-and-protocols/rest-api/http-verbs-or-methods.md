# HTTP Verbs or Methods

### What are HTTP Verbs?

HTTP verbs, also known as HTTP methods or request methods, are a set of keywords that define the desired action to be performed on a specific resource on a server.



Below are different types of HTTP verbs and their typical usage given.

### **GET:**

* **Description:** This is the most basic and widely used HTTP verb. It retrieves data from a specified resource.
* **When to Use:** We should use GET when we want to fetch data from a server, like requesting a web page, retrieving a list of products from an API, or getting information about a specific user.

### **POST:**

* **Description:** This verb creates a new resource or submits data to an existing resource.
* **When to Use:** Use POST when we need to submit data to a server, such as creating a new user account, posting a comment, or uploading a file. The data is usually sent in the request body.

### **PUT:**

* **Description:** This verb updates an existing resource completely, replacing it with the new data provided in the request body.
* **When to Use:** Use PUT when we want to entirely overwrite an existing resource on the server. It's often used for updating specific entities, like modifying a product's details in an API.

### **PATCH:**

* **Description:** This verb is used to update a part of an existing resource.
* **When to Use:** Use PATCH when we only need to modify specific parts of a resource, rather than replacing the entire thing. This can be useful for updating individual attributes of an entity in an API.

### **DELETE:**

* **Description:** This verb deletes a specified resource.
* **When to Use:** Use DELETE when we want to remove a resource from the server, such as deleting a user account, a product, or a specific piece of data.

### **TRACE:**

* **Description:** This verb is used for debugging purposes and allows tracing of an HTTP request through the network. It echoes the entire request back to the client, including headers and body, allowing you to see any modifications made by intermediary servers.
* **When to Use:** TRACE is rarely used in typical web browsing or API interactions. However, it can be helpful for network administrators or developers to troubleshoot issues related to request routing, headers, or message manipulation by intermediary servers.

### **OPTIONS:**

* **Description:** This verb retrieves the supported HTTP methods for a specific resource. It essentially asks the server, "What can I do with this resource?"
* **When to Use:** Use OPTIONS when you want to discover what operations are allowed on a resource before sending an actual request. This can be useful for clients that dynamically adjust their behavior based on the available methods. For example, a web browser might use OPTIONS to determine if it can upload files (using POST) to a specific resource.

### **CONNECT:**

* **Description:** This verb establishes a tunnel between the client and the server. It's typically used for creating secure connections through firewalls or proxies that might block certain ports.
* **When to Use:** CONNECT is often used for establishing secure connections (HTTPS) through an intermediary server that only allows HTTP traffic. The client creates a tunnel to the target server, effectively bypassing the intermediary's restrictions on HTTPS communication.

### **PURGE (Not a standard HTTP verb):**

* **Description:** While not an official part of the HTTP standard, PURGE is sometimes used to request the removal of a cached resource from a server or intermediary cache.
* **When to Use:** This verb might be used in situations where the content on the server has been updated, and you want to ensure clients retrieve the latest version by clearing the cached copy. However, due to its non-standard nature, support for PURGE can vary across servers.

### **LOCK (WebDAV):**

* **Description:** This verb, part of the WebDAV extension to HTTP, is used to acquire a lock on a resource. This prevents other clients from modifying the resource until the lock is released.
* **When to Use:** LOCK is used in collaborative editing scenarios where multiple users might try to modify the same resource concurrently. By acquiring a lock, a user can ensure exclusive access for editing and prevent conflicts.

### **UNLOCK (WebDAV):**

* **Description:** This verb, also part of WebDAV, releases a lock that was previously acquired using the LOCK method.
* **When to Use:** UNLOCK is used to relinquish the exclusive access granted by a lock. Once a user finishes editing a resource, they would typically release the lock using UNLOCK to allow other users to access and modify it.

### **MKCOL (WebDAV):**

* **Description:** This verb, another part of WebDAV, is used to create a new collection (directory) on the server.
* **When to Use:** MKCOL is used when you want to create a new folder or directory structure on a web server that supports WebDAV. This allows for managing collections of resources on the server through HTTP requests.

### **COPY (WebDAV):**

* **Description:** This verb, also part of WebDAV, is used to create a copy of a resource on the server.
* **When to Use:** COPY allows you to duplicate an existing resource, creating a new version with a potentially different name or location. This can be useful for tasks like version control or creating backups.

{% hint style="info" %}
The verbs LOCK, UNLOCK, MKCOL, and COPY are part of the WebDAV extension to HTTP. They are not standard HTTP verbs and require server-side support for WebDAV to function correctly. WebDAV (Web Distributed Authoring and Versioning) is an extension to the Hypertext Transfer Protocol (HTTP) that allows users to collaboratively edit and manage files on a web server. It provides a set of functionalities beyond basic file retrieval and modification that standard HTTP offers
{% endhint %}
