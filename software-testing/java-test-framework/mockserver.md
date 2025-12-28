# MockServer

## About

MockServer is a powerful open-source HTTP/HTTPS mock server that supports mocking both SOAP and REST requests and responses. With advanced features like request matching, response templating, proxying, and SSL/TLS support, MockServer provides a flexible and robust solution for API testing. Additional features like header matching, fault injection, and dynamic responses further enhance the tool's capabilities. MockServer also offers client libraries for several programming languages, allowing for easy integration with testing frameworks like JUnit. Finally, Testcontainers provides seamless support for MockServer as an HTTP mock server, making it a popular choice for modern testing environments

_**For more details, visit the official site**_ [_**https://www.mock-server.com/**_](https://www.mock-server.com/)

In this page, we will see how to mock a SOAP (XML) and REST (JSON) API request/response with the help of MockServer.

## **Setup MockServer**

We will use docker-compose way of starting the MockServer. Create a file named docker-compose.yml and add the below contents to it.

```yaml
version: "3.9"
# https://docs.docker.com/compose/compose-file/

services:
  mockserver:
    container_name: mockserver
    image: mockserver/mockserver:5.14.0
    : -logLevel DEBUG -serverPort 1090
    environment:
      MOCKSERVER_LOG_LEVEL: INFO
      MOCKSERVER_SERVER_PORT: 1090
      MOCKSERVER_INITIALIZATION_JSON_PATH: /mockserver/stubs/*.json
    ports:
      - "1090:1090"
    volumes:
      - ./stubs:/mockserver/stubs
networks:
  default:
    name: company_default
```

Create a folder with name **stubs, in which we will store sample json files for initialisation.**

![](https://static.wixstatic.com/media/5fb94b_617a514b92e241078cf77c5474bc5c10~mv2.png/v1/fill/w_290,h_288,fp_0.50_0.50,q_90/5fb94b_617a514b92e241078cf77c5474bc5c10~mv2.webp)<img src="https://static.wixstatic.com/media/5fb94b_312670708c3144c2a4ea7063e9e6c799~mv2.jpg/v1/fill/w_288,h_288,fp_0.50_0.50,q_90/5fb94b_312670708c3144c2a4ea7063e9e6c799~mv2.webp" alt="" data-size="original"><br>

_**Let's create mock request/response file (REST-books-list.json) for sample REST API inside the stubs folder.**_

<pre class="language-json"><code class="lang-json">{
<strong>  "httpRequest": {
</strong>    "method": "GET",
    "path": "/rest-api/books"
  },
<strong>  "httpResponse": {
</strong>    "statusCode": 200,
    "body": [{
      "title": "To Kill a Mockingbird",
      "author": "Harper Lee",
      "id": "10001"
    },
    {
      "title": "The Great Gatsby",
      "author": "F. Scott Fitzgerald",
      "id": "10002"
    },
    {
      "title": "Pride and Prejudice",
      "author": "Jane Austen",
      "id": "10003"
    }]
  }
}
</code></pre>



_**Let's create mock request/response file (SOAP-books-list.json) for sample SOAP API inside the stubs folder.**_

<pre class="language-json"><code class="lang-json">{
<strong>  "httpRequest": {
</strong>    "method": "POST",
    "path": "/soap-api/books",
    "body": {
      "type": "XML",
      "xml": "&#x3C;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">&#x3C;soap:Body>&#x3C;GetBooksRequest xmlns=\"http://example.com/\">&#x3C;/GetBooksRequest>&#x3C;/soap:Body>&#x3C;/soap:Envelope>"
    }
  },
<strong>  "httpResponse": {
</strong>    "statusCode": 200,
    "headers": {
      "Content-Type": "application/xml"
    },
    "body": {
      "type": "XML",
      "xml": "&#x3C;soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">&#x3C;soap:Body>&#x3C;GetBooksResponse xmlns=\"http://example.com/\">&#x3C;Book>&#x3C;ID>10001&#x3C;/ID>&#x3C;Title>To Kill a Mockingbird&#x3C;/Title>&#x3C;Author>Harper Lee&#x3C;/Author>&#x3C;/Book>&#x3C;Book>&#x3C;ID>10002&#x3C;/ID>&#x3C;Title>The Great Gatsby&#x3C;/Title>&#x3C;Author>F. Scott Fitzgerald&#x3C;/Author>&#x3C;/Book>&#x3C;Book>&#x3C;ID>10003&#x3C;/ID>&#x3C;Title>Pride and Prejudice&#x3C;/Title>&#x3C;Author>Jane Austen&#x3C;/Author>&#x3C;/Book>&#x3C;/GetBooksResponse>&#x3C;/soap:Body>&#x3C;/soap:Envelope>"
    }
  }
}
</code></pre>



_**Let's start the MockServer with the help of below command**_

```
docker-compose up mockserver
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_fe30fec83aa6467faf944ed59b6f9091~mv2.png/v1/fill/w_1480,h_360,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_fe30fec83aa6467faf944ed59b6f9091~mv2.png" alt="ree"><figcaption></figcaption></figure>

## **Access the MockServer UI page**

_**Go to below url to view the UI which shows logs, active expectations and requests.**_

```
http://localhost:1090/mockserver/dashboard
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_38dffa4ee8aa44988799a896c1539c02~mv2.png/v1/fill/w_1480,h_728,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_38dffa4ee8aa44988799a896c1539c02~mv2.png" alt="ree"><figcaption></figcaption></figure>

> Note that MockServer has been initialised with the sample request/response files and exposed at 1090 port

## **Verify the Mock API's**

### _Postman_

<figure><img src="https://static.wixstatic.com/media/5fb94b_ae6cbc01657441ccb962fe548ea180f6~mv2.png/v1/fill/w_702,h_746,al_c,q_90,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_ae6cbc01657441ccb962fe548ea180f6~mv2.png" alt="ree" width="375"><figcaption></figcaption></figure>

<figure><img src="https://static.wixstatic.com/media/5fb94b_1d402241a3a247ea882dbfa08e5fa584~mv2.png/v1/fill/w_1222,h_1298,al_c,q_90,enc_avif,quality_auto/5fb94b_1d402241a3a247ea882dbfa08e5fa584~mv2.png" alt="ree" width="375"><figcaption></figcaption></figure>

<br>

### _Curl_

```
curl http://localhost:1090/rest-api/books
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_8b5db64010624a109d3941e6f64b1733~mv2.png/v1/fill/w_1368,h_490,al_c,q_90,enc_avif,quality_auto/5fb94b_8b5db64010624a109d3941e6f64b1733~mv2.png" alt="ree"><figcaption></figcaption></figure>

```
curl -X POST -H "Content-Type: application/xml" -d '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><GetBooksRequest xmlns="http://example.com/"></GetBooksRequest></soap:Body></soap:Envelope>' http://localhost:1090/soap-api/books
```

<figure><img src="https://static.wixstatic.com/media/5fb94b_71fea26c1470498eba07787d1c8437c1~mv2.png/v1/fill/w_1480,h_108,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/5fb94b_71fea26c1470498eba07787d1c8437c1~mv2.png" alt="ree"><figcaption></figcaption></figure>

Files are attached for the reference below.

{% file src="../../.gitbook/assets/Code.zip" %}
