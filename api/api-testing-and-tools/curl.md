# Curl

## About

`curl` is a command-line tool used to **transfer data to or from a server** using various internet protocols. It is widely used by developers to test REST APIs, download files, and simulate client requests.

It is short for "**Client URL**" and supports protocols like HTTP, HTTPS, FTP, SFTP, and more. In API development, `curl` is commonly used to send HTTP requests and inspect server responses.

## Why Use curl?

* To test API endpoints from the terminal
* To simulate real HTTP requests (GET, POST, PUT, DELETE)
* To send custom headers, payloads, or authentication tokens
* To debug issues like authentication failures or incorrect responses

## Basic Syntax

```
curl [options] [URL]
```

## Curl Options

<table data-full-width="true"><thead><tr><th width="333.8133544921875">Option</th><th>Description</th></tr></thead><tbody><tr><td><code>-X</code> or <code>--request</code> <code>&#x3C;METHOD></code></td><td>Specifies the HTTP method (GET, POST, PUT, DELETE, etc.)</td></tr><tr><td><code>-H</code> or <code>--header</code> <code>&#x3C;HEADER></code></td><td>Adds a custom header (e.g., <code>Content-Type</code>, <code>Authorization</code>)</td></tr><tr><td><code>-d</code> or <code>--data</code> <code>&#x3C;DATA></code></td><td>Sends data in the body (used with POST, PUT, etc.)</td></tr><tr><td><code>--data-raw</code> <code>&#x3C;DATA></code></td><td>Sends raw, unprocessed data</td></tr><tr><td><code>--data-urlencode</code> <code>&#x3C;DATA></code></td><td>Sends URL-encoded data</td></tr><tr><td><code>-F</code> or <code>--form</code> <code>&#x3C;KEY=VALUE></code></td><td>Sends form data, including file uploads (multipart/form-data)</td></tr><tr><td><code>-u</code> or <code>--user</code> <code>&#x3C;user:password></code></td><td>Uses basic authentication</td></tr><tr><td><code>-o</code> or <code>--output</code> <code>&#x3C;file></code></td><td>Saves the response body to a file</td></tr><tr><td><code>-O</code></td><td>Saves the file using the remote file name</td></tr><tr><td><code>-i</code> or <code>--include</code></td><td>Includes response headers in the output</td></tr><tr><td><code>-I</code> or <code>--head</code></td><td>Sends a HEAD request (returns headers only)</td></tr><tr><td><code>-v</code> or <code>--verbose</code></td><td>Prints detailed info for debugging (request/response, SSL handshake, etc.)</td></tr><tr><td><code>-s</code> or <code>--silent</code></td><td>Hides progress bar and error messages</td></tr><tr><td><code>-S</code> or <code>--show-error</code></td><td>Shows error even when <code>--silent</code> is used</td></tr><tr><td><code>-L</code> or <code>--location</code></td><td>Follows redirects (3xx responses)</td></tr><tr><td><code>-k</code> or <code>--insecure</code></td><td>Ignores SSL certificate validation (not recommended in production)</td></tr><tr><td><code>--compressed</code></td><td>Requests a compressed response (e.g., gzip)</td></tr><tr><td><code>--http1.1</code>, <code>--http2</code>, <code>--http3</code></td><td>Forces use of specific HTTP protocol versions</td></tr><tr><td><code>--url</code> <code>&#x3C;URL></code></td><td>Specifies the URL explicitly (used in scripts)</td></tr><tr><td><code>--max-time</code> <code>&#x3C;seconds></code></td><td>Sets a timeout for the entire request</td></tr><tr><td><code>--connect-timeout</code> <code>&#x3C;seconds></code></td><td>Sets timeout for connection phase only</td></tr><tr><td><code>--retry</code> <code>&#x3C;n></code></td><td>Automatically retries the request up to <code>n</code> times</td></tr><tr><td><code>-e</code> or <code>--referer</code> <code>&#x3C;URL></code></td><td>Sets the <code>Referer</code> header</td></tr><tr><td><code>-A</code> or <code>--user-agent</code> <code>&#x3C;string></code></td><td>Sets a custom <code>User-Agent</code> header</td></tr><tr><td><code>--cert</code> <code>&#x3C;file></code></td><td>Uses a client certificate (for mTLS)</td></tr><tr><td><code>--key</code> <code>&#x3C;file></code></td><td>Specifies the private key file for <code>--cert</code></td></tr><tr><td><code>--cacert</code> <code>&#x3C;file></code></td><td>Uses a custom CA certificate file</td></tr><tr><td><code>--cookie</code> <code>&#x3C;data></code></td><td>Sends cookies with the request</td></tr><tr><td><code>--cookie-jar</code> <code>&#x3C;file></code></td><td>Stores received cookies into a file</td></tr><tr><td><code>--trace</code> <code>&#x3C;file></code></td><td>Logs a full trace of the request/response (headers + body)</td></tr><tr><td><code>--trace-ascii</code> <code>&#x3C;file></code></td><td>Logs trace in a human-readable format</td></tr><tr><td><code>--fail</code></td><td>Fails silently on HTTP errors (no body output on 400/500)</td></tr></tbody></table>

## Common curl Commands



### 1. GET Request (default method)

```bash
curl https://api.example.com/users
```

Sends a GET request to fetch data.

### 2. POST Request with JSON Body

```bash
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice","email":"alice@example.com"}'
```

* `-X` specifies the HTTP method (POST)
* `-H` adds a header
* `-d` sends data in the request body

### 3. PUT Request

```bash
curl -X PUT https://api.example.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@newdomain.com"}'
```

Used to update existing data.

### 4. DELETE Request

```bash
curl -X DELETE https://api.example.com/users/123
```

Deletes a resource by ID.

### 5. Custom Headers

```bash
curl https://api.example.com/data \
  -H "Authorization: Bearer <token>" \
  -H "Accept: application/json"
```

Adds headers like auth tokens and Accept types.

### 6. Form Submission (application/x-www-form-urlencoded)

```bash
curl -X POST https://api.example.com/login \
  -d "username=admin&password=secret"
```

Mimics a form submission.

### 7. File Upload

```bash
curl -X POST https://api.example.com/upload \
  -F "file=@path/to/file.jpg"
```

Uses `multipart/form-data` for uploading files.

### 8. Save Response to File

```bash
curl https://example.com/image.jpg -o image.jpg
```

Downloads and saves the file.

### 9. View Response Headers

```bash
curl -I https://api.example.com
```

Shows HTTP headers only, without the response body.

### 10. Verbose Output (for debugging)

```bash
curl -v https://api.example.com
```

Prints detailed request/response information, including headers and connection steps.

### 11. Basic Authentication

```bash
curl -u username:password https://api.example.com/secure
```

Adds a `Authorization: Basic` header.

### 12. Bearer Token Authentication

```bash
curl -H "Authorization: Bearer <token>" https://api.example.com
```

Used for OAuth 2.0 or JWT-secured APIs.
