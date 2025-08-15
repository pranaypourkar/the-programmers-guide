# Wireshark analyze the TLS traffic

Can I test client hello and server hello?

Yes, you can test the ClientHello and ServerHello messages exchanged during the TLS handshake using Wireshark. These messages provide important information about the TLS connection and the cryptographic parameters negotiated between the client and the server.

To test the ClientHello and ServerHello messages in Wireshark, you can follow these steps:

1. Start Wireshark and select the network interface you want to capture the traffic on.
2. Apply a display filter to show only the TLS packets. You can use the display filter `tls` or `ssl` to filter out non-TLS packets and focus on the TLS traffic.
3. Open your browser and initiate a connection to the website or server you want to test. You can enter the URL in the browser's address bar or click on a link to the website.
4. Wireshark will capture the network traffic, including the TLS packets exchanged during the handshake. Look for the initial ClientHello message sent by the browser and the corresponding ServerHello response from the server.
5. Select the first ClientHello packet in the packet list and examine the details in the packet details pane. You will see information such as the supported TLS versions, cipher suites, compression methods, and any extensions included in the ClientHello message.
6. Similarly, select the corresponding ServerHello packet and inspect its details. You will find details about the TLS version chosen by the server, the selected cipher suite, compression method, and any extensions sent by the server.
