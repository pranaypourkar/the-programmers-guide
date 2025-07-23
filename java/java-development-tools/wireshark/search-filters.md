# Search Filters

Wireshark provides a vast array of filters to help us focus on specific types of network traffic. Filters in Wireshark can be categorized into **Capture Filters** (set before starting the packet capture) and **Display Filters** (used after capturing packets to filter and display specific packets).

## **1. Capture Filters**

Capture filters are applied during packet capture and determine which packets are recorded. These filters use the **Berkeley Packet Filter (BPF)** syntax.

### **Capture Specific Protocols**

*   Capture only HTTP traffic:

    ```plaintext
    port 80
    ```
*   Capture only TCP traffic:

    ```plaintext
    tcp
    ```
*   Capture only UDP traffic:

    ```plaintext
    udp
    ```
*   Capture only ICMP traffic:

    ```plaintext
    icmp
    ```

### **Filter by IP Address**

*   Capture packets to or from a specific IP:

    ```plaintext
    host 192.168.1.1
    ```
*   Capture packets from a specific subnet:

    ```plaintext
    net 192.168.1.0/24
    ```

### **Filter by Port**

*   Capture traffic on a specific port (e.g., HTTP):

    ```plaintext
    port 80
    ```
*   Capture traffic on multiple ports:

    ```plaintext
    port 80 or port 443
    ```

### **Exclude Traffic**

*   Exclude packets to/from a specific host:

    ```plaintext
    not host 192.168.1.1
    ```
*   Exclude traffic on a port:

    ```plaintext
    not port 22
    ```

### **Capture Traffic Between Hosts**

```plaintext
host 192.168.1.1 and host 192.168.1.2
```

## **2. Display Filters**

Display filters are used after the packets have been captured to refine what we see. They use Wireshark's own syntax and allow for more advanced filtering options compared to capture filters.

### **Protocol Filters**

* **Filter by Protocol**:
  *   Show only TCP packets:

      ```plaintext
      tcp
      ```
  *   Show only DNS packets:

      ```plaintext
      dns
      ```
  *   Show only HTTP packets:

      ```plaintext
      http
      ```
  *   Show only ARP packets:

      ```plaintext
      arp
      ```

### **Filter by IP Address**

* **Filter by Source or Destination IP**:
  *   Source IP:

      ```plaintext
      ip.src == 192.168.1.1
      ```
  *   Destination IP:

      ```plaintext
      ip.dst == 192.168.1.2
      ```
  *   Any packets to/from an IP:

      ```plaintext
      ip.addr == 192.168.1.1
      ```
*   **Filter by Subnet**:

    ```plaintext
    ip.addr == 192.168.1.0/24
    ```

### **Filter by Ports**

* **Filter by Specific Port**:
  *   Source Port:

      ```plaintext
      tcp.srcport == 80
      ```
  *   Destination Port:

      ```plaintext
      tcp.dstport == 443
      ```
  *   Any packets using a port:

      ```plaintext
      tcp.port == 80
      ```
*   **Filter by Port Range**:

    ```plaintext
    tcp.port >= 1000 and tcp.port <= 2000
    ```

### **TCP-Specific Filters**

* **Filter by TCP Flags**:
  *   SYN packets:

      ```plaintext
      tcp.flags.syn == 1
      ```
  *   ACK packets:

      ```plaintext
      tcp.flags.ack == 1
      ```
  *   Reset packets:

      ```plaintext
      tcp.flags.reset == 1
      ```
  *   FIN packets:

      ```plaintext
      tcp.flags.fin == 1
      ```
* **Filter by TCP Errors**:
  *   Retransmissions:

      ```plaintext
      tcp.analysis.retransmission
      ```
  *   Out-of-order packets:

      ```plaintext
      tcp.analysis.out_of_order
      ```
  *   Duplicate ACKs:

      ```plaintext
      tcp.analysis.duplicate_ack
      ```
  *   ACK lost segments:

      ```plaintext
      tcp.analysis.ack_lost_segment
      ```

### **HTTP-Specific Filters**

* **Filter by HTTP Methods**:
  *   GET requests:

      ```plaintext
      http.request.method == "GET"
      ```
  *   POST requests:

      ```plaintext
      http.request.method == "POST"
      ```
* **Filter by HTTP Response Codes**:
  *   Errors (4xx and 5xx):

      ```plaintext
      http.response.code >= 400
      ```
*   **Filter by Content Type**:

    ```plaintext
    http.content_type contains "json"
    ```

### **DNS-Specific Filters**

* **Filter by DNS Query or Response**:
  *   Show only DNS queries:

      ```plaintext
      dns.flags.response == 0
      ```
  *   Show only DNS responses:

      ```plaintext
      dns.flags.response == 1
      ```
*   **Filter by DNS Error Responses**:

    ```plaintext
    dns.flags.rcode != 0
    ```

### **ICMP-Specific Filters**

* **Filter by ICMP Type**:
  *   Echo Request:

      ```plaintext
      icmp.type == 8
      ```
  *   Echo Reply:

      ```plaintext
      icmp.type == 0
      ```
* **Filter by ICMP Error Messages**:
  *   Destination Unreachable:

      ```plaintext
      icmp.type == 3
      ```
  *   Time Exceeded:

      ```plaintext
      icmp.type == 11
      ```

### **TLS/SSL-Specific Filters**

* **Filter by Handshake Messages**:
  *   ClientHello:

      ```plaintext
      ssl.handshake.type == 1
      ```
  *   ServerHello:

      ```plaintext
      ssl.handshake.type == 2
      ```
*   **Filter Encrypted Traffic**:

    ```plaintext
    ssl.record.content_type == 23
    ```

### **Application-Layer Filters**

* **Filter by Payload Content**:
  *   Search for specific text in the payload:

      ```plaintext
      frame contains "error"
      ```
  *   Search for JSON with specific keys:

      ```plaintext
      json.key contains "status"
      ```
*   **Filter for Specific SQL Errors**:

    ```plaintext
    frame contains "SQLException"
    ```

### **Error Filters**

*   **General Error Filters**:

    ```plaintext
    _ws.expert.severity == error
    ```
*   **Warnings**:

    ```plaintext
    _ws.expert.severity == warning
    ```

### **Other Filters**

* **Filter by Frame Length**:
  *   Frames larger than 1000 bytes:

      ```plaintext
      frame.len > 1000
      ```
* **Filter by Time**:
  *   Packets captured after a specific time:

      ```plaintext
      frame.time >= "2024-12-24 10:00:00"
      ```
*   **Custom Filters**: Combine multiple filters using `and`, `or`, and `not`:

    ```plaintext
    ip.addr == 192.168.1.1 and tcp.port == 80
    ```

