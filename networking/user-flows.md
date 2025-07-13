# User Flows

## Scenario 1: Opening a Website in a Browser

1. **DNS Resolution**:
   * When you enter a website's domain name (e.g., `example.com`) in your browser, the browser first needs to resolve this domain name to an IP address. It does this by querying a Domain Name System (DNS) server. The DNS server returns the IP address associated with the domain.
2. **Establishing a TCP Connection**:
   * Once the browser has the IP address of the website, it initiates a TCP (Transmission Control Protocol) connection to the server hosting the website. This involves a three-way handshake:
     * **SYN**: The browser sends a SYN (synchronize) packet to the server.
     * **SYN-ACK**: The server responds with a SYN-ACK (synchronize-acknowledge) packet, acknowledging the SYN.
     * **ACK**: The browser sends an ACK (acknowledge) packet back to the server, completing the handshake and establishing a TCP connection.
3. **TLS Handshake (if HTTPS)**:
   * If the website uses HTTPS (HTTP over TLS/SSL), the browser initiates a TLS (Transport Layer Security) handshake with the server. This involves:
     * **Encryption Negotiation**: The client (browser) and server agree on encryption algorithms and exchange keys.
     * **Certificate Verification**: The server presents its SSL/TLS certificate, which includes its public key and is signed by a trusted Certificate Authority (CA). The browser verifies the certificate's validity and authenticity.
     * **Session Keys Exchange**: The client and server exchange session keys to encrypt and decrypt data transmitted during the session.
4. **HTTP Request**:
   * Once the TCP and TLS handshakes are complete, the browser sends an HTTP request (e.g., GET request) to the server. The request includes details such as the requested resource (URL), headers (metadata), and optionally, cookies.
5. **Server Processing**:
   * The server receives the HTTP request, processes it, and generates an HTTP response. This may involve querying databases, executing application logic, or retrieving static content.
6. **HTTP Response**:
   * The server sends back an HTTP response to the browser. The response includes status information (e.g., 200 OK, 404 Not Found), headers (e.g., content type, cache-control), and the requested content (e.g., HTML, images, scripts).
7. **Rendering the Page**:
   * The browser receives the HTML content and begins parsing it to render the webpage. It fetches additional resources referenced in the HTML (e.g., CSS files, JavaScript, images) and may make additional HTTP requests to the server or other servers.
8. **Displaying the Website**:
   * Finally, the browser renders the website based on the received content and displays it to the user. Interactive elements like forms or JavaScript-powered features may require further interaction between the browser and the server.

## Scenario 2: Website or Mobile App Calling a Backend API

1. **DNS Resolution and TCP Connection**:
   * Similar to scenario 1, the client (website or mobile app) first resolves the domain name of the backend API to an IP address using DNS. It then establishes a TCP connection with the server hosting the API via a three-way handshake.
2. **TLS Handshake (if HTTPS)**:
   * If the backend API uses HTTPS, the client initiates a TLS handshake with the server to establish a secure connection. This involves encryption negotiation, certificate verification, and session keys exchange.
3. **HTTP Request**:
   * Once the TCP and TLS handshakes are complete, the client sends an HTTP request to the backend API server. The request typically includes:
     * **HTTP Method**: GET, POST, PUT, DELETE, etc.
     * **Endpoint**: The specific API endpoint (e.g., `/api/users`)
     * **Headers**: Metadata such as authentication tokens (e.g., JWT), content type, and other custom headers.
     * **Body**: Data payload (for POST, PUT requests) encoded in JSON, XML, or other formats.
4. **Server Processing**:
   * The backend API server receives the HTTP request, validates authentication tokens, parses the request data, and executes the corresponding business logic (e.g., querying databases, processing data).
5. **HTTP Response**:
   * The server generates an HTTP response based on the request processing results. The response includes:
     * **Status Code**: Indicates success (2xx), client error (4xx), or server error (5xx).
     * **Headers**: Response metadata such as content type, cache-control directives, and custom headers.
     * **Body**: Response data formatted in JSON, XML, or other specified format.
6. **Client Processing**:
   * The client (website or mobile app) receives the HTTP response and processes the data according to the application's logic. This may involve displaying data to the user, updating UI components, or triggering further actions.
7. **Error Handling and Retry**:
   * Depending on the response status code, the client application may handle errors gracefully, retry the request (e.g., for temporary network issues), or prompt the user with appropriate messages.
8. **Session Management and Security**:
   * Throughout the interaction, session management and security measures (e.g., token expiration, HTTPS encryption) ensure data confidentiality, integrity, and authentication between the client and the backend API.
