# Request & Response

## About

At the heart of every API interaction is a **request-response cycle**. Whether you’re calling an external service or communicating between internal systems, this exchange is how APIs operate. One side **sends a request**, and the other **returns a response**.

## What is a Request?

A **request** is what an API consumer (client) sends to an API provider (server) to **ask for something**. It could be asking for data, creating a new record, updating existing information, or deleting something.

Every API request has several key components:

#### 1. **URL (Uniform Resource Locator)**

* The **address of the resource** you're trying to access.
* Example: `https://api.example.com/products/42`

#### 2. **HTTP Method (Verb)**

* Tells the server **what action** to perform:
  * `GET`: Retrieve data
  * `POST`: Create new data
  * `PUT`/`PATCH`: Update existing data
  * `DELETE`: Remove data

#### 3. **Headers**

* Contain **metadata** about the request.
* Examples:
  * `Content-Type: application/json`
  * `Authorization: Bearer <token>`

#### 4. **Query Parameters / Path Parameters**

* Used to **filter or identify specific resources**.
* Query: `/users?role=admin`
* Path: `/users/123`

#### 5. **Request Body (Optional)**

* Used with methods like `POST` or `PUT`.
* Contains **data to be sent to the server**, usually in JSON format.

```json
{
  "name": "Alice",
  "email": "alice@example.com"
}
```

## What Is a Response?

The **response** is the **reply** from the server after processing the request. It lets the client know whether the request was successful, and includes any data or error message.

A response consists of:

#### 1. **Status Code**

* Indicates the **result** of the request.
  * `200 OK` – Successful
  * `201 Created` – Resource created
  * `400 Bad Request` – Problem with the request
  * `401 Unauthorized` – Invalid credentials
  * `500 Internal Server Error` – Something failed on the server

#### 2. **Headers**

* Provide metadata, such as:
  * `Content-Type: application/json`
  * `Cache-Control: no-cache`

#### 3. **Response Body (Usually JSON)**

* Contains the **actual data** or an error message.
* Example:

```json
jsonCopyEdit{
  "id": 42,
  "name": "Laptop",
  "price": 599.99
}
```

## Example

#### Request

```http
GET /products/42
Host: api.shop.com
Authorization: Bearer eyJhbGciOiJIUzI1Ni...
Accept: application/json
```

#### Response

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "id": 42,
  "name": "Wireless Mouse",
  "price": 29.99
}
```
