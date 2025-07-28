# Content Type

## About

The `Content-Type` is an **HTTP header** used to indicate the **media type** (also called MIME type) of the data being sent in the **body** of an HTTP request or response. It tells the server or client how to **interpret the content** of the message body.

## Why is Content-Type Important?

APIs often exchange data in formats like JSON, XML, HTML, plain text, etc. The `Content-Type` header helps ensure that:

* The **server knows how to parse the incoming request body**
* The **client knows how to handle the response body**

If the `Content-Type` is missing or incorrect, the receiver may fail to understand or parse the data correctly.

## Usage

### In a **Request**

When a client (like Postman, browser, or frontend app) sends data to the server, it must specify the format using the `Content-Type` header.

Example:

```
POST /api/users
Content-Type: application/json

{
  "name": "John",
  "email": "john@example.com"
}
```

The server will use this header to determine how to read the request body — in this case, as JSON.

### In a **Response**

When the server responds, it can also set the `Content-Type` to tell the client what format the response body is in.

Example:

```
HTTP/1.1 200 OK
Content-Type: application/xml

<user>
  <name>John</name>
  <email>john@example.com</email>
</user>
```

## Possible Content-Type Values

<table data-full-width="true"><thead><tr><th width="353.70489501953125">Content-Type</th><th>Description</th></tr></thead><tbody><tr><td><code>application/json</code></td><td>JSON data. Most common format in REST APIs.</td></tr><tr><td><code>application/xml</code></td><td>XML data. Used in older APIs and some enterprise systems.</td></tr><tr><td><code>text/plain</code></td><td>Plain text data with no formatting.</td></tr><tr><td><code>text/html</code></td><td>HTML content, used in web pages.</td></tr><tr><td><code>application/x-www-form-urlencoded</code></td><td>Form data encoded in key-value pairs (like <code>key=value&#x26;key2=value2</code>). Default for HTML forms.</td></tr><tr><td><code>multipart/form-data</code></td><td>Used for form submissions that include files (e.g., image uploads).</td></tr><tr><td><code>application/octet-stream</code></td><td>Binary data; generic for any file (used in downloads or file streams).</td></tr><tr><td><code>application/pdf</code></td><td>PDF files.</td></tr><tr><td><code>application/zip</code></td><td>ZIP compressed files.</td></tr><tr><td><code>application/javascript</code></td><td>JavaScript files.</td></tr><tr><td><code>text/css</code></td><td>CSS stylesheets.</td></tr><tr><td><code>image/png</code></td><td>PNG image.</td></tr><tr><td><code>image/jpeg</code></td><td>JPEG image.</td></tr><tr><td><code>image/gif</code></td><td>GIF image.</td></tr><tr><td><code>image/svg+xml</code></td><td>SVG (Scalable Vector Graphics) in XML format.</td></tr><tr><td><code>audio/mpeg</code></td><td>MP3 audio format.</td></tr><tr><td><code>audio/wav</code></td><td>WAV audio format.</td></tr><tr><td><code>video/mp4</code></td><td>MP4 video format.</td></tr><tr><td><code>video/x-msvideo</code></td><td>AVI video format.</td></tr><tr><td><code>application/vnd.api+json</code></td><td>JSON:API specification format.</td></tr><tr><td><code>application/graphql</code></td><td>GraphQL query format.</td></tr><tr><td><code>application/ld+json</code></td><td>Linked Data using JSON (used in semantic web, schema.org).</td></tr><tr><td><code>application/soap+xml</code></td><td>SOAP XML format (used in SOAP-based APIs).</td></tr><tr><td><code>application/vnd.ms-excel</code></td><td>Microsoft Excel (XLS) file.</td></tr><tr><td><code>application/vnd.openxmlformats-officedocument.spreadsheetml.sheet</code></td><td>Microsoft Excel (XLSX) file.</td></tr><tr><td><code>application/msword</code></td><td>Microsoft Word (DOC) file.</td></tr><tr><td><code>application/vnd.openxmlformats-officedocument.wordprocessingml.document</code></td><td>Microsoft Word (DOCX) file.</td></tr><tr><td><code>application/x-yaml</code></td><td>YAML format (not standard but used in APIs and config services).</td></tr><tr><td><code>application/x-protobuf</code></td><td>Protocol Buffers (binary serialization format).</td></tr><tr><td><code>application/x-ndjson</code></td><td>Newline-delimited JSON (used in streaming APIs).</td></tr></tbody></table>

## Relation to Accept Header

* `Content-Type` is used to indicate the **format being sent**.
* `Accept` is used to indicate the **format expected in response**.

Example:

```
POST /api/data
Content-Type: application/json
Accept: application/xml
```

This means:

* "I’m sending you JSON"
* "Please respond with XML"

## Content-Type in API Frameworks (like Spring)

In Java Spring (or similar frameworks):

* To define what our API **accepts**, use `consumes = MediaType.APPLICATION_JSON_VALUE`
* To define what our API **returns**, use `produces = MediaType.APPLICATION_XML_VALUE`

Example:

```java
@PostMapping(value = "/users", consumes = "application/json", produces = "application/xml")
public UserResponse createUser(@RequestBody UserRequest user) {
    ...
}
```

## What Happens if Content-Type is Missing ?

* The server might reject the request (`415 Unsupported Media Type`)
* The server might default to another format and incorrectly parse the data
* The client might misinterpret the response content



