# Example

## Web Log Analysis – Count 404 Errors

Parse a large web server log file and count how many times the server returned a **404 (Not Found)** HTTP status code.

#### **Input Sample (webserver.log)**

```
127.0.0.1 - - [23/Jul/2024:10:00:00 +0000] "GET /index.html HTTP/1.1" 200 1024
127.0.0.1 - - [23/Jul/2024:10:01:00 +0000] "GET /notfound.html HTTP/1.1" 404 512
127.0.0.1 - - [23/Jul/2024:10:02:00 +0000] "GET /page.html HTTP/1.1" 404 0
```





## **Sales Aggregation – Total Sales per Product**

Given a file containing sales data (`product,price`), calculate the **total revenue per product**.

#### **Input Sample (sales.txt)**

```
Book,12
Pen,3
Book,10
Notebook,8
Pen,2
```
