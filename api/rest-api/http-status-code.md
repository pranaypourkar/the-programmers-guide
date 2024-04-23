# HTTP Status Code

HTTP status codes act as a common language between servers and clients. An HTTP status code is a three-digit numeric response code sent by a web server to a browser or client application in response to an HTTP request. It's essentially a signal that communicates the outcome of the request.



### Why HTTP status codes are important:

* **Clarity and Universality:** These codes provide a standardized way for servers to communicate the success or failure of a request. This universal language ensures everyone (browsers, developers, applications) understands the outcome.
* **Troubleshooting:** Status codes are crucial for troubleshooting issues between clients and servers. By understanding the code, developers can pinpoint where the problem lies (client-side error, server-side error, etc.) and take corrective actions. For example, a "404 Not Found" status code indicates that the requested resource does not exist, while a "500 Internal Server Error" indicates a problem on the server side. This helps developers diagnose and troubleshoot issues efficiently.
* **Improved User Experience:** For user-facing applications (web apps), proper use of status codes can enhance the user experience. For instance, a 404 Not Found code can be used to display a user-friendly "Page Not Found" message, rather than a cryptic error message.
* **API Design:** While developing REST APIs, using HTTP status codes effectively is essential. They convey the result of API calls clearly, allowing developers integrating with the API to understand what's happening.
* **SEO and Web Standards**: Proper use of status codes can impact search engine optimization (SEO) and adherence to web standards. For example, returning the appropriate status code for redirects (e.g., "301 Moved Permanently") ensures that search engines understand the change in URL and transfer any link equity.



### HTTP Status Codes and use case

Below are some of the common HTTP status codes and their typical uses in REST APIs

1. **1xx Informational**: These codes indicate the request was received and the process is ongoing. They don't necessarily mean success, but rather the server is working on it.
   * **100 Continue**: The client can continue with its request.
   * **101 Switching Protocols**: The server switches protocols as requested by the client.
2. **2xx Success**: These are the happy path codes, indicating the request was successfully processed and understood.
   * **200 OK**: The request was successful. **Example:** When a client sends a GET request for a webpage, and the server successfully retrieves and returns the webpage content, it responds with a 200 status code.
   * **201 Created**: The request has been fulfilled and a new resource has been created. **Example**: When a client sends a POST request to create a new user account, and the server successfully creates the account, it responds with a 201 status code along with the URI of the newly created user resource.
   * **202 Accepted**: This status code indicates that the request has been accepted for processing but has not yet been completed. It is typically used in scenarios where the request is queued for asynchronous processing. **Example:** When a server receives a request to process a large batch job, it might respond with a 202 status code to acknowledge receipt of the request, while the actual processing happens asynchronously.
   * **203 Non-Authoritative Information**: This status code indicates that the server is returning a meta-information response (such as headers) that may be from a third-party source rather than the original server. It is primarily used in proxy scenarios. **Example:**  A proxy server may return a 203 status code along with cached content from another server, indicating to the client that the information provided is not authoritative
   * **204 No Content**: The server successfully processed the request but isn't returning any content. **Example:** When a client sends a PUT request to update a resource, and the server successfully updates the resource without returning any additional data, it responds with a 204 status code.
   * **205 Reset Content**: This status code instructs the client to reset the document from which the original request was sent. It is primarily used in scenarios where the client-side form data should be cleared after a successful submission. **Example:** After submitting a form to update some data, the server might respond with a 205 status code, prompting the client to clear the form fields to prevent accidental resubmission.
   * **206 Partial Content**: This status code is used when the server is delivering only a partial response to the client, typically in response to a request with a Range header. **Example**: When a client requests a large file and specifies a range of bytes it needs (e.g., for resuming a paused download), the server may respond with a 206 status code and send only the requested range of bytes.
3. **3xx Redirection**: These codes indicate the client needs to take further action to complete the request, typically involving redirection to a different URL.
   * **301 Moved Permanently**: The resource requested has been permanently moved to a new URL.
   * **304 Not Modified**: Used for caching purposes, indicating the requested resource hasn't changed since the client last accessed it.
4. **4xx Client Error**: These codes indicate an issue with the request itself, typically due to a mistake on the client-side (e.g., browser, your application).
   * **400 Bad Request**: The request cannot be fulfilled due to bad syntax or other client-side errors.
   * **401 Unauthorized**: The request requires authentication.
   * **403 Forbidden**: The server understood the request, but refuses to authorize it.
   * **404 Not Found**: The requested resource could not be found.
5. **5xx Server Error**: These codes indicate an issue on the server-side preventing it from fulfilling the request.
   * **500 Internal Server Error**: A generic error message indicating a problem with the server.
   * **502 Bad Gateway**: The server, while acting as a gateway or proxy, received an invalid response from an inbound server.
   * **503 Service Unavailable**: The server is currently unavailable (often due to maintenance or overloading).
   * **504 Gateway Timeout**: The server, while acting as a gateway or proxy, did not receive a timely response from an upstream server it needed to access.





### Correlation of HTTP status codes with HTTP methods (verbs)

HTTP Method (Verb)

<table data-full-width="true"><thead><tr><th width="152"></th><th width="238"></th><th></th></tr></thead><tbody><tr><td>HTTP Method (Verb)</td><td>Typical Use Case</td><td>Common Status Codes</td></tr><tr><td>GET</td><td>Retrieve data from a resource</td><td><p>* 200 OK: Success, data returned in response body. </p><p>* 301 Moved Permanently: Resource has been moved to a new location. </p><p>* 401 Unauthorized: Client lacks proper credentials. </p><p>* 403 Forbidden: Client authorized but not allowed to access resource. </p><p>* 404 Not Found: Requested resource could not be found.</p></td></tr><tr><td>POST</td><td>Create a new resource</td><td><p>* 201 Created: New resource created successfully, location of new resource in response (e.g., in a header). </p><p>* 400 Bad Request: Invalid data provided in the request body.</p><p>* 401 Unauthorized: Client lacks proper credentials.  </p><p>* 403 Forbidden: Client not authorized to create new resources. </p><p>* 409 Conflict: Resource creation conflicts with existing data.</p></td></tr><tr><td>PUT</td><td>Update a complete resource</td><td><p>* 200 OK: Resource updated successfully. </p><p>* 204 No Content: Resource updated but no data returned in response body. </p><p>* 400 Bad Request: Invalid data provided in the request body. </p><p>* 401 Unauthorized: Client lacks proper credentials. </p><p>* 403 Forbidden: Client not authorized to update resource. </p><p>* 404 Not Found: Resource could not be found for update.</p></td></tr><tr><td>PATCH</td><td>Update a partial resource</td><td><p>* 200 OK: Resource partially updated successfully. </p><p>* 204 No Content: Resource updated but no data returned in response body. </p><p>* 400 Bad Request: Invalid data provided in the request body.</p><p>* 401 Unauthorized: Client lacks proper credentials.  </p><p>* 403 Forbidden: Client not authorized to update resource. </p><p>* 404 Not Found: Resource could not be found for update.</p></td></tr><tr><td>DELETE</td><td>Delete a resource</td><td><p>* 200 OK: Resource deleted successfully (may or may not have content in response body). </p><p>* 204 No Content: Resource deleted successfully, no content returned. </p><p>* 401 Unauthorized: Client lacks proper credentials. </p><p>* 403 Forbidden: Client not authorized to delete resource. </p><p>* 404 Not Found: Resource could not be found for deletion.</p></td></tr></tbody></table>







